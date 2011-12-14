Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61337 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab1LNPij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:39 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 5/8] NFC: Add a DEP link control netlink command
Date: Wed, 14 Dec 2011 16:43:09 +0100
Message-Id: <1323877392-20567-6-git-send-email-sameo@linux.intel.com> (sfid-20111214_163842_151509_0AF19737)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NFC-DEP (Data Exchange Protocol) is an NFC MAC layer.
This command allows to enable and disable the DEP link on to which e.g.
LLCP can run.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h   |   14 +++++
 include/net/nfc/nfc.h |   11 ++++
 net/nfc/core.c        |   77 ++++++++++++++++++++++++++
 net/nfc/netlink.c     |  144 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h         |    9 +++
 5 files changed, 255 insertions(+), 0 deletions(-)

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 36cb955..34d8303 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -62,6 +62,8 @@ enum nfc_commands {
 	NFC_CMD_GET_DEVICE,
 	NFC_CMD_DEV_UP,
 	NFC_CMD_DEV_DOWN,
+	NFC_CMD_DEP_LINK_UP,
+	NFC_CMD_DEP_LINK_DOWN,
 	NFC_CMD_START_POLL,
 	NFC_CMD_STOP_POLL,
 	NFC_CMD_GET_TARGET,
@@ -86,6 +88,8 @@ enum nfc_commands {
  * @NFC_ATTR_TARGET_SENS_RES: NFC-A targets extra information such as NFCID
  * @NFC_ATTR_TARGET_SEL_RES: NFC-A targets extra information (useful if the
  *	target is not NFC-Forum compliant)
+ * @NFC_ATTR_COMM_MODE: Passive or active mode
+ * @NFC_ATTR_RF_MODE: Initiator or target
  */
 enum nfc_attrs {
 	NFC_ATTR_UNSPEC,
@@ -95,6 +99,8 @@ enum nfc_attrs {
 	NFC_ATTR_TARGET_INDEX,
 	NFC_ATTR_TARGET_SENS_RES,
 	NFC_ATTR_TARGET_SEL_RES,
+	NFC_ATTR_COMM_MODE,
+	NFC_ATTR_RF_MODE,
 /* private: internal use only */
 	__NFC_ATTR_AFTER_LAST
 };
@@ -111,6 +117,14 @@ enum nfc_attrs {
 
 #define NFC_PROTO_MAX		6
 
+/* NFC communication modes */
+#define NFC_COMM_ACTIVE  0
+#define NFC_COMM_PASSIVE 1
+
+/* NFC RF modes */
+#define NFC_RF_INITIATOR 0
+#define NFC_RF_TARGET    1
+
 /* NFC protocols masks used in bitsets */
 #define NFC_PROTO_JEWEL_MASK	(1 << NFC_PROTO_JEWEL)
 #define NFC_PROTO_MIFARE_MASK	(1 << NFC_PROTO_MIFARE)
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 3a3304c..bf82d29 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -52,6 +52,9 @@ struct nfc_ops {
 	int (*dev_down)(struct nfc_dev *dev);
 	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
 	void (*stop_poll)(struct nfc_dev *dev);
+	int (*dep_link_up)(struct nfc_dev *dev, int target_idx,
+				u8 comm_mode, u8 rf_mode);
+	int (*dep_link_down)(struct nfc_dev *dev);
 	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
 							u32 protocol);
 	void (*deactivate_target)(struct nfc_dev *dev, u32 target_idx);
@@ -60,6 +63,9 @@ struct nfc_ops {
 							void *cb_context);
 };
 
+#define NFC_TARGET_IDX_ANY -1
+#define NFC_MAX_GT_LEN 48
+
 struct nfc_target {
 	u32 idx;
 	u32 supported_protocols;
@@ -83,6 +89,8 @@ struct nfc_dev {
 	bool dev_up;
 	bool polling;
 	bool remote_activated;
+	bool dep_link_up;
+	u32 dep_rf_mode;
 	struct nfc_genl_data genl_data;
 	u32 supported_protocols;
 
@@ -165,4 +173,7 @@ struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
 							int ntargets);
 
+int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
+		       u8 comm_mode, u8 rf_mode);
+
 #endif /* __NET_NFC_H */
diff --git a/net/nfc/core.c b/net/nfc/core.c
index f53f88a..785f1f2 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -181,6 +181,83 @@ error:
 	return rc;
 }
 
+int nfc_dep_link_up(struct nfc_dev *dev, int target_index,
+					u8 comm_mode, u8 rf_mode)
+{
+	int rc = 0;
+
+	pr_debug("dev_name=%s comm:%d rf:%d\n",
+			dev_name(&dev->dev), comm_mode, rf_mode);
+
+	if (!dev->ops->dep_link_up)
+		return -EOPNOTSUPP;
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (dev->dep_link_up == true) {
+		rc = -EALREADY;
+		goto error;
+	}
+
+	rc = dev->ops->dep_link_up(dev, target_index, comm_mode, rf_mode);
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+int nfc_dep_link_down(struct nfc_dev *dev)
+{
+	int rc = 0;
+
+	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
+
+	if (!dev->ops->dep_link_down)
+		return -EOPNOTSUPP;
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (dev->dep_link_up == false) {
+		rc = -EALREADY;
+		goto error;
+	}
+
+	if (dev->dep_rf_mode == NFC_RF_TARGET) {
+		rc = -EOPNOTSUPP;
+		goto error;
+	}
+
+	rc = dev->ops->dep_link_down(dev);
+	if (!rc) {
+		dev->dep_link_up = false;
+		nfc_genl_dep_link_down_event(dev);
+	}
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
+					u8 comm_mode, u8 rf_mode)
+{
+	dev->dep_link_up = true;
+	dev->dep_rf_mode = rf_mode;
+
+	return nfc_genl_dep_link_up_event(dev, target_idx, comm_mode, rf_mode);
+}
+EXPORT_SYMBOL(nfc_dep_link_is_up);
+
 /**
  * nfc_activate_target - prepare the target for data exchange
  *
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 1d76d38..43a1c47 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -46,6 +46,8 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 	[NFC_ATTR_DEVICE_NAME] = { .type = NLA_STRING,
 				.len = NFC_DEVICE_NAME_MAXSIZE },
 	[NFC_ATTR_PROTOCOLS] = { .type = NLA_U32 },
+	[NFC_ATTR_COMM_MODE] = { .type = NLA_U8 },
+	[NFC_ATTR_RF_MODE] = { .type = NLA_U8 },
 };
 
 static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
@@ -311,6 +313,75 @@ static int nfc_genl_dump_devices_done(struct netlink_callback *cb)
 	return 0;
 }
 
+int nfc_genl_dep_link_up_event(struct nfc_dev *dev, u32 target_idx,
+						u8 comm_mode, u8 rf_mode)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	pr_debug("DEP link is up\n");
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+				NFC_CMD_DEP_LINK_UP);
+	if (!hdr)
+		goto free_msg;
+
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
+	if (rf_mode == NFC_RF_INITIATOR)
+		NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target_idx);
+	NLA_PUT_U8(msg, NFC_ATTR_COMM_MODE, comm_mode);
+	NLA_PUT_U8(msg, NFC_ATTR_RF_MODE, rf_mode);
+
+	genlmsg_end(msg, hdr);
+
+	dev->dep_link_up = true;
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_ATOMIC);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+int nfc_genl_dep_link_down_event(struct nfc_dev *dev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	pr_debug("DEP link is down\n");
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+				NFC_CMD_DEP_LINK_DOWN);
+	if (!hdr)
+		goto free_msg;
+
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_ATOMIC);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
 static int nfc_genl_get_device(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
@@ -398,6 +469,8 @@ static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 	u32 idx;
 	u32 protocols;
 
+	pr_debug("Poll start\n");
+
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 		!info->attrs[NFC_ATTR_PROTOCOLS])
 		return -EINVAL;
@@ -452,6 +525,67 @@ out:
 	return rc;
 }
 
+static int nfc_genl_dep_link_up(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	int rc, tgt_idx;
+	u32 idx;
+	u8 comm, rf;
+
+	pr_debug("DEP link up\n");
+
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+			!info->attrs[NFC_ATTR_COMM_MODE] ||
+			!info->attrs[NFC_ATTR_RF_MODE])
+		return -EINVAL;
+
+	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
+	if (!info->attrs[NFC_ATTR_TARGET_INDEX])
+		tgt_idx = NFC_TARGET_IDX_ANY;
+	else
+		tgt_idx = nla_get_u32(info->attrs[NFC_ATTR_TARGET_INDEX]);
+
+	comm = nla_get_u8(info->attrs[NFC_ATTR_COMM_MODE]);
+	rf = nla_get_u8(info->attrs[NFC_ATTR_RF_MODE]);
+
+	if (comm != NFC_COMM_ACTIVE && comm != NFC_COMM_PASSIVE)
+		return -EINVAL;
+
+	if (rf != NFC_RF_INITIATOR && comm != NFC_RF_TARGET)
+		return -EINVAL;
+
+	dev = nfc_get_device(idx);
+	if (!dev)
+		return -ENODEV;
+
+	rc = nfc_dep_link_up(dev, tgt_idx, comm, rf);
+
+	nfc_put_device(dev);
+
+	return rc;
+}
+
+static int nfc_genl_dep_link_down(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	int rc;
+	u32 idx;
+
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+		return -EINVAL;
+
+	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
+
+	dev = nfc_get_device(idx);
+	if (!dev)
+		return -ENODEV;
+
+	rc = nfc_dep_link_down(dev);
+
+	nfc_put_device(dev);
+	return rc;
+}
+
 static struct genl_ops nfc_genl_ops[] = {
 	{
 		.cmd = NFC_CMD_GET_DEVICE,
@@ -481,6 +615,16 @@ static struct genl_ops nfc_genl_ops[] = {
 		.policy = nfc_genl_policy,
 	},
 	{
+		.cmd = NFC_CMD_DEP_LINK_UP,
+		.doit = nfc_genl_dep_link_up,
+		.policy = nfc_genl_policy,
+	},
+	{
+		.cmd = NFC_CMD_DEP_LINK_DOWN,
+		.doit = nfc_genl_dep_link_down,
+		.policy = nfc_genl_policy,
+	},
+	{
 		.cmd = NFC_CMD_GET_TARGET,
 		.dumpit = nfc_genl_dump_targets,
 		.done = nfc_genl_dump_targets_done,
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 67d6050..4d0fb12 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -68,6 +68,10 @@ int nfc_genl_targets_found(struct nfc_dev *dev);
 int nfc_genl_device_added(struct nfc_dev *dev);
 int nfc_genl_device_removed(struct nfc_dev *dev);
 
+int nfc_genl_dep_link_up_event(struct nfc_dev *dev, u32 target_idx,
+			       u8 comm_mode, u8 rf_mode);
+int nfc_genl_dep_link_down_event(struct nfc_dev *dev);
+
 struct nfc_dev *nfc_get_device(unsigned idx);
 
 static inline void nfc_put_device(struct nfc_dev *dev)
@@ -102,6 +106,11 @@ int nfc_start_poll(struct nfc_dev *dev, u32 protocols);
 
 int nfc_stop_poll(struct nfc_dev *dev);
 
+int nfc_dep_link_up(struct nfc_dev *dev, int target_idx,
+				u8 comm_mode, u8 rf_mode);
+
+int nfc_dep_link_down(struct nfc_dev *dev);
+
 int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol);
 
 int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx);
-- 
1.7.7.3

