Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46404 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab2CDX6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:16 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 18/22] NFC: Remove the rf mode parameter from the DEP link up routine
Date: Mon,  5 Mar 2012 01:03:50 +0100
Message-Id: <1330905834-6994-19-git-send-email-sameo@linux.intel.com> (sfid-20120305_005821_366186_CFE8BBDC)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When calling nfc_dep_link_up, we implicitely are in initiator mode.
Which means we also can provide the general bytes as a function argument,
as all drivers will eventually request them.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c   |   20 +++++---------------
 include/net/nfc/nfc.h |    6 ++----
 net/nfc/core.c        |   22 +++++++++++-----------
 net/nfc/llcp/llcp.c   |    2 +-
 net/nfc/netlink.c     |   11 +++--------
 net/nfc/nfc.h         |    5 ++---
 6 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index ef33f64..cb6204f 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1340,21 +1340,15 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 }
 
 static int pn533_dep_link_up(struct nfc_dev *nfc_dev, int target_idx,
-						u8 comm_mode, u8 rf_mode)
+			     u8 comm_mode, u8* gb, size_t gb_len)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_cmd_jump_dep *cmd;
-	u8 cmd_len, local_gt_len, *local_gt;
+	u8 cmd_len;
 	int rc;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
-	if (rf_mode == NFC_RF_TARGET) {
-		nfc_dev_err(&dev->interface->dev, "Target mode not supported");
-		return -EOPNOTSUPP;
-	}
-
-
 	if (dev->poll_mod_count) {
 		nfc_dev_err(&dev->interface->dev,
 				"Cannot bring the DEP link up while polling");
@@ -1367,11 +1361,7 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, int target_idx,
 		return -EBUSY;
 	}
 
-	local_gt = nfc_get_local_general_bytes(dev->nfc_dev, &local_gt_len);
-	if (local_gt_len > NFC_MAX_GT_LEN)
-		return -EINVAL;
-
-	cmd_len = sizeof(struct pn533_cmd_jump_dep) + local_gt_len;
+	cmd_len = sizeof(struct pn533_cmd_jump_dep) + gb_len;
 	cmd = kzalloc(cmd_len, GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -1380,9 +1370,9 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, int target_idx,
 
 	cmd->active = !comm_mode;
 	cmd->baud = 0;
-	if (local_gt != NULL) {
+	if (gb != NULL && gb_len > 0) {
 		cmd->next = 4; /* We have some Gi */
-		memcpy(cmd->gt, local_gt, local_gt_len);
+		memcpy(cmd->gt, gb, gb_len);
 	} else {
 		cmd->next = 0;
 	}
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index d253278..d608e4e 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -53,8 +53,8 @@ struct nfc_ops {
 	int (*dev_down)(struct nfc_dev *dev);
 	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
 	void (*stop_poll)(struct nfc_dev *dev);
-	int (*dep_link_up)(struct nfc_dev *dev, int target_idx,
-				u8 comm_mode, u8 rf_mode);
+	int (*dep_link_up)(struct nfc_dev *dev, int target_idx, u8 comm_mode,
+			   u8 *gb, size_t gb_len);
 	int (*dep_link_down)(struct nfc_dev *dev);
 	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
 							u32 protocol);
@@ -179,8 +179,6 @@ struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 int nfc_set_remote_general_bytes(struct nfc_dev *dev,
 					u8 *gt, u8 gt_len);
 
-u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, u8 *gt_len);
-
 int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
 							int ntargets);
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 6089aca..f4f526f 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -181,13 +181,13 @@ error:
 	return rc;
 }
 
-int nfc_dep_link_up(struct nfc_dev *dev, int target_index,
-					u8 comm_mode, u8 rf_mode)
+int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 {
 	int rc = 0;
+	u8 *gb;
+	size_t gb_len;
 
-	pr_debug("dev_name=%s comm:%d rf:%d\n",
-			dev_name(&dev->dev), comm_mode, rf_mode);
+	pr_debug("dev_name=%s comm %d\n", dev_name(&dev->dev), comm_mode);
 
 	if (!dev->ops->dep_link_up)
 		return -EOPNOTSUPP;
@@ -204,7 +204,13 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index,
 		goto error;
 	}
 
-	rc = dev->ops->dep_link_up(dev, target_index, comm_mode, rf_mode);
+	gb = nfc_llcp_general_bytes(dev, &gb_len);
+	if (gb_len > NFC_MAX_GT_LEN) {
+		rc = -EINVAL;
+		goto error;
+	}
+
+	rc = dev->ops->dep_link_up(dev, target_index, comm_mode, gb, gb_len);
 
 error:
 	device_unlock(&dev->dev);
@@ -367,12 +373,6 @@ int nfc_set_remote_general_bytes(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 }
 EXPORT_SYMBOL(nfc_set_remote_general_bytes);
 
-u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, u8 *gt_len)
-{
-	return nfc_llcp_general_bytes(dev, gt_len);
-}
-EXPORT_SYMBOL(nfc_get_local_general_bytes);
-
 /**
  * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index a0cb133..3ce646e 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -281,7 +281,7 @@ void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap)
 	mutex_unlock(&local->sdp_lock);
 }
 
-u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *general_bytes_len)
+u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len)
 {
 	struct nfc_llcp_local *local;
 
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index a1388e4..fa620d0 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -542,13 +542,12 @@ static int nfc_genl_dep_link_up(struct sk_buff *skb, struct genl_info *info)
 	struct nfc_dev *dev;
 	int rc, tgt_idx;
 	u32 idx;
-	u8 comm, rf;
+	u8 comm;
 
 	pr_debug("DEP link up\n");
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
-			!info->attrs[NFC_ATTR_COMM_MODE] ||
-			!info->attrs[NFC_ATTR_RF_MODE])
+	    !info->attrs[NFC_ATTR_COMM_MODE])
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
@@ -558,19 +557,15 @@ static int nfc_genl_dep_link_up(struct sk_buff *skb, struct genl_info *info)
 		tgt_idx = nla_get_u32(info->attrs[NFC_ATTR_TARGET_INDEX]);
 
 	comm = nla_get_u8(info->attrs[NFC_ATTR_COMM_MODE]);
-	rf = nla_get_u8(info->attrs[NFC_ATTR_RF_MODE]);
 
 	if (comm != NFC_COMM_ACTIVE && comm != NFC_COMM_PASSIVE)
 		return -EINVAL;
 
-	if (rf != NFC_RF_INITIATOR && comm != NFC_RF_TARGET)
-		return -EINVAL;
-
 	dev = nfc_get_device(idx);
 	if (!dev)
 		return -ENODEV;
 
-	rc = nfc_dep_link_up(dev, tgt_idx, comm, rf);
+	rc = nfc_dep_link_up(dev, tgt_idx, comm);
 
 	nfc_put_device(dev);
 
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 6d28d75..2fd83b1 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -54,7 +54,7 @@ void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
 int nfc_llcp_register_device(struct nfc_dev *dev);
 void nfc_llcp_unregister_device(struct nfc_dev *dev);
 int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len);
-u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *general_bytes_len);
+u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len);
 int __init nfc_llcp_init(void);
 void nfc_llcp_exit(void);
 
@@ -160,8 +160,7 @@ int nfc_start_poll(struct nfc_dev *dev, u32 protocols);
 
 int nfc_stop_poll(struct nfc_dev *dev);
 
-int nfc_dep_link_up(struct nfc_dev *dev, int target_idx,
-				u8 comm_mode, u8 rf_mode);
+int nfc_dep_link_up(struct nfc_dev *dev, int target_idx, u8 comm_mode);
 
 int nfc_dep_link_down(struct nfc_dev *dev);
 
-- 
1.7.7.3

