Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab1LNPim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:42 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 6/8] NFC: Set and get DEP general bytes
Date: Wed, 14 Dec 2011 16:43:10 +0100
Message-Id: <1323877392-20567-7-git-send-email-sameo@linux.intel.com> (sfid-20111214_163844_738517_6B30A4AA)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without an API for setting and getting the local and remote general bytes,
drivers won't be able to properly establish a DEP link.
This API also allows them to propagate the remote general bytes they get
from the DEP link establishment up to the LLCP layer.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c   |    7 ++++++-
 include/net/nfc/nfc.h |    5 +++++
 net/nfc/core.c        |   18 ++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index ea1caae..dccd965 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1121,6 +1121,7 @@ static int pn533_activate_target_nfcdep(struct pn533 *dev)
 {
 	struct pn533_cmd_activate_param param;
 	struct pn533_cmd_activate_response *resp;
+	u16 gt_len;
 	int rc;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
@@ -1146,7 +1147,11 @@ static int pn533_activate_target_nfcdep(struct pn533 *dev)
 	if (rc != PN533_CMD_RET_SUCCESS)
 		return -EIO;
 
-	return 0;
+	/* ATR_RES general bytes are located at offset 16 */
+	gt_len = PN533_FRAME_CMD_PARAMS_LEN(dev->in_frame) - 16;
+	rc = nfc_set_remote_general_bytes(dev->nfc_dev, resp->gt, gt_len);
+
+	return rc;
 }
 
 static int pn533_activate_target(struct nfc_dev *nfc_dev, u32 target_idx,
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index bf82d29..ccfe757 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -170,6 +170,11 @@ struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
 					unsigned int *err);
 struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 
+int nfc_set_remote_general_bytes(struct nfc_dev *dev,
+					u8 *gt, u8 gt_len);
+
+u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, u8 *gt_len);
+
 int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
 							int ntargets);
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 785f1f2..3a45f21 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -352,6 +352,24 @@ error:
 	return rc;
 }
 
+int nfc_set_remote_general_bytes(struct nfc_dev *dev, u8 *gb, u8 gb_len)
+{
+	pr_debug("dev_name=%s gb_len=%d\n",
+			dev_name(&dev->dev), gb_len);
+
+	if (gb_len > NFC_MAX_GT_LEN)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_set_remote_general_bytes);
+
+u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, u8 *gt_len)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(nfc_get_local_general_bytes);
+
 /**
  * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
-- 
1.7.7.3

