Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab2FFKHJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:09 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 09/29] NFC: Add target mode activation netlink event
Date: Wed,  6 Jun 2012 12:16:26 +0200
Message-Id: <1338977806-30279-10-git-send-email-sameo@linux.intel.com> (sfid-20120606_120716_118245_8B65250A)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace gets a netlink event upon target mode activation.
The LLCP layer is also signaled when we get an ATR_REQ in order to get
the remote general bytes.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c   |   27 +++++++++++++++++++-
 include/linux/nfc.h   |    7 +++++
 include/net/nfc/nfc.h |    4 +++
 net/nfc/core.c        |   35 +++++++++++++++++++++++++++
 net/nfc/netlink.c     |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h         |    3 ++
 6 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 605a08a..c6b9bc5 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -260,6 +260,10 @@ struct pn533_cmd_jump_dep_response {
 #define PN533_INIT_TARGET_PASSIVE 0x1
 #define PN533_INIT_TARGET_DEP 0x2
 
+#define PN533_INIT_TARGET_RESP_FRAME_MASK 0x3
+#define PN533_INIT_TARGET_RESP_ACTIVE     0x1
+#define PN533_INIT_TARGET_RESP_DEP        0x4
+
 struct pn533_cmd_init_target {
 	u8 mode;
 	u8 mifare[6];
@@ -1128,10 +1132,13 @@ static int pn533_init_target_frame(struct pn533_frame *frame,
 	return 0;
 }
 
+#define ATR_REQ_GB_OFFSET 17
 static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 				      u8 *params, int params_len)
 {
 	struct pn533_cmd_init_target_response *resp;
+	u8 frame, comm_mode = NFC_COMM_PASSIVE, *gb;
+	size_t gb_len;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
@@ -1143,11 +1150,27 @@ static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 		return params_len;
 	}
 
+	if (params_len < ATR_REQ_GB_OFFSET + 1)
+		return -EINVAL;
+
 	resp = (struct pn533_cmd_init_target_response *) params;
 
-	nfc_dev_dbg(&dev->interface->dev, "Target mode 0x%x\n", resp->mode);
+	nfc_dev_dbg(&dev->interface->dev, "Target mode 0x%x param len %d\n",
+		    resp->mode, params_len);
 
-	return 0;
+	frame = resp->mode & PN533_INIT_TARGET_RESP_FRAME_MASK;
+	if (frame == PN533_INIT_TARGET_RESP_ACTIVE)
+		comm_mode = NFC_COMM_ACTIVE;
+
+	/* Again, only DEP */
+	if ((resp->mode & PN533_INIT_TARGET_RESP_DEP) == 0)
+		return -EOPNOTSUPP;
+
+	gb = resp->cmd + ATR_REQ_GB_OFFSET;
+	gb_len = params_len - (ATR_REQ_GB_OFFSET + 1);
+
+	return nfc_tm_activated(dev->nfc_dev, NFC_PROTO_NFC_DEP_MASK,
+				comm_mode, gb, gb_len);
 }
 
 static int pn533_init_target(struct nfc_dev *nfc_dev, u32 protocols)
diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 5487158..d124e92 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -56,6 +56,10 @@
  *	%NFC_ATTR_PROTOCOLS)
  * @NFC_EVENT_DEVICE_REMOVED: event emitted when a device is removed
  *	(it sends %NFC_ATTR_DEVICE_INDEX)
+ * @NFC_EVENT_TM_ACTIVATED: event emitted when the adapter is activated in
+ *      target mode.
+ * @NFC_EVENT_DEVICE_DEACTIVATED: event emitted when the adapter is deactivated
+ *      from target mode.
  */
 enum nfc_commands {
 	NFC_CMD_UNSPEC,
@@ -71,6 +75,8 @@ enum nfc_commands {
 	NFC_EVENT_DEVICE_ADDED,
 	NFC_EVENT_DEVICE_REMOVED,
 	NFC_EVENT_TARGET_LOST,
+	NFC_EVENT_TM_ACTIVATED,
+	NFC_EVENT_TM_DEACTIVATED,
 /* private: internal use only */
 	__NFC_CMD_AFTER_LAST
 };
@@ -122,6 +128,7 @@ enum nfc_attrs {
 #define NFC_NFCID1_MAXSIZE 10
 #define NFC_SENSB_RES_MAXSIZE 12
 #define NFC_SENSF_RES_MAXSIZE 18
+#define NFC_GB_MAXSIZE        48
 
 /* NFC protocols */
 #define NFC_PROTO_JEWEL		1
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 97aa0e8..41573b4b 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -198,4 +198,8 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx);
 int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 		       u8 comm_mode, u8 rf_mode);
 
+int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
+		     u8 *gb, size_t gb_len);
+int nfc_tm_deactivated(struct nfc_dev *dev);
+
 #endif /* __NET_NFC_H */
diff --git a/net/nfc/core.c b/net/nfc/core.c
index c83717b..17f1474 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -455,6 +455,41 @@ u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, size_t *gb_len)
 }
 EXPORT_SYMBOL(nfc_get_local_general_bytes);
 
+int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
+		     u8 *gb, size_t gb_len)
+{
+	int rc;
+
+	device_lock(&dev->dev);
+
+	dev->polling = false;
+
+	if (gb != NULL) {
+		rc = nfc_set_remote_general_bytes(dev, gb, gb_len);
+		if (rc < 0)
+			goto out;
+	}
+
+	if (protocol == NFC_PROTO_NFC_DEP_MASK)
+		nfc_dep_link_is_up(dev, 0, comm_mode, NFC_RF_TARGET);
+
+	rc = nfc_genl_tm_activated(dev, protocol);
+
+out:
+	device_unlock(&dev->dev);
+
+	return rc;
+}
+EXPORT_SYMBOL(nfc_tm_activated);
+
+int nfc_tm_deactivated(struct nfc_dev *dev)
+{
+	dev->dep_link_up = false;
+
+	return nfc_genl_tm_deactivated(dev);
+}
+EXPORT_SYMBOL(nfc_tm_deactivated);
+
 /**
  * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index a18fd56..21eaa9b 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -221,6 +221,68 @@ free_msg:
 	return -EMSGSIZE;
 }
 
+int nfc_genl_tm_activated(struct nfc_dev *dev, u32 protocol)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+			  NFC_EVENT_TM_ACTIVATED);
+	if (!hdr)
+		goto free_msg;
+
+	if (nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, NFC_ATTR_TM_PROTOCOLS, protocol))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_KERNEL);
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
+int nfc_genl_tm_deactivated(struct nfc_dev *dev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+			  NFC_EVENT_TM_DEACTIVATED);
+	if (!hdr)
+		goto free_msg;
+
+	if (nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_KERNEL);
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
 int nfc_genl_device_added(struct nfc_dev *dev)
 {
 	struct sk_buff *msg;
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 7d9708f..cd9fcbe 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -128,6 +128,9 @@ int nfc_genl_dep_link_up_event(struct nfc_dev *dev, u32 target_idx,
 			       u8 comm_mode, u8 rf_mode);
 int nfc_genl_dep_link_down_event(struct nfc_dev *dev);
 
+int nfc_genl_tm_activated(struct nfc_dev *dev, u32 protocol);
+int nfc_genl_tm_deactivated(struct nfc_dev *dev);
+
 struct nfc_dev *nfc_get_device(unsigned int idx);
 
 static inline void nfc_put_device(struct nfc_dev *dev)
-- 
1.7.9.1

