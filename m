Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45563 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2FFKHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:24 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 13/29] NFC: Implement the pn533 target mode data fetching routine
Date: Wed,  6 Jun 2012 12:16:30 +0200
Message-Id: <1338977806-30279-14-git-send-email-sameo@linux.intel.com> (sfid-20120606_120730_997198_B7C308BA)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This one needs to be called as soon as we are activated as a target, for
the pn533 to receive the first SYMM and keep the LLCP link alive.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index fd94c6f..6a506e2 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -75,6 +75,7 @@ MODULE_DEVICE_TABLE(usb, pn533_table);
 #define PN533_CMD_IN_JUMP_FOR_DEP 0x56
 
 #define PN533_CMD_TG_INIT_AS_TARGET 0x8c
+#define PN533_CMD_TG_GET_DATA 0x86
 
 #define PN533_CMD_RESPONSE(cmd) (cmd + 1)
 
@@ -83,6 +84,9 @@ MODULE_DEVICE_TABLE(usb, pn533_table);
 #define PN533_CMD_MI_MASK 0x40
 #define PN533_CMD_RET_SUCCESS 0x00
 
+/* PN533 status codes */
+#define PN533_STATUS_TARGET_RELEASED 0x29
+
 struct pn533;
 
 typedef int (*pn533_cmd_complete_t) (struct pn533 *dev, void *arg,
@@ -296,6 +300,7 @@ struct pn533 {
 	struct workqueue_struct	*wq;
 	struct work_struct cmd_work;
 	struct work_struct mi_work;
+	struct work_struct tg_work;
 	struct pn533_frame *wq_in_frame;
 	int wq_in_error;
 
@@ -1132,6 +1137,68 @@ static int pn533_init_target_frame(struct pn533_frame *frame,
 	return 0;
 }
 
+#define PN533_CMD_DATAEXCH_HEAD_LEN (sizeof(struct pn533_frame) + 3)
+#define PN533_CMD_DATAEXCH_DATA_MAXLEN 262
+static int pn533_tm_get_data_complete(struct pn533 *dev, void *arg,
+				      u8 *params, int params_len)
+{
+	struct sk_buff *skb_resp = arg;
+	struct pn533_frame *in_frame = (struct pn533_frame *) skb_resp->data;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	if (params_len < 0) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error %d when starting as a target",
+			    params_len);
+
+		return params_len;
+	}
+
+	if (params_len > 0 && params[0] != 0) {
+		nfc_tm_deactivated(dev->nfc_dev);
+
+		kfree_skb(skb_resp);
+		return 0;
+	}
+
+	skb_put(skb_resp, PN533_FRAME_SIZE(in_frame));
+	skb_pull(skb_resp, PN533_CMD_DATAEXCH_HEAD_LEN);
+	skb_trim(skb_resp, skb_resp->len - PN533_FRAME_TAIL_SIZE);
+
+	return nfc_tm_data_received(dev->nfc_dev, skb_resp);
+}
+
+static void pn533_wq_tg_get_data(struct work_struct *work)
+{
+	struct pn533 *dev = container_of(work, struct pn533, tg_work);
+	struct pn533_frame *in_frame;
+	struct sk_buff *skb_resp;
+	size_t skb_resp_len;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	skb_resp_len = PN533_CMD_DATAEXCH_HEAD_LEN +
+		PN533_CMD_DATAEXCH_DATA_MAXLEN +
+		PN533_FRAME_TAIL_SIZE;
+
+	skb_resp = nfc_alloc_recv_skb(skb_resp_len, GFP_KERNEL);
+	if (!skb_resp)
+		return;
+
+	in_frame = (struct pn533_frame *)skb_resp->data;
+
+	pn533_tx_frame_init(dev->out_frame, PN533_CMD_TG_GET_DATA);
+	pn533_tx_frame_finish(dev->out_frame);
+
+	pn533_send_cmd_frame_async(dev, dev->out_frame, in_frame,
+				   skb_resp_len,
+				   pn533_tm_get_data_complete,
+				   skb_resp, GFP_KERNEL);
+
+	return;
+}
+
 #define ATR_REQ_GB_OFFSET 17
 static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 				      u8 *params, int params_len)
@@ -1139,6 +1206,7 @@ static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 	struct pn533_cmd_init_target_response *resp;
 	u8 frame, comm_mode = NFC_COMM_PASSIVE, *gb;
 	size_t gb_len;
+	int rc;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
@@ -1169,8 +1237,17 @@ static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 	gb = resp->cmd + ATR_REQ_GB_OFFSET;
 	gb_len = params_len - (ATR_REQ_GB_OFFSET + 1);
 
-	return nfc_tm_activated(dev->nfc_dev, NFC_PROTO_NFC_DEP_MASK,
-				comm_mode, gb, gb_len);
+	rc = nfc_tm_activated(dev->nfc_dev, NFC_PROTO_NFC_DEP_MASK,
+			      comm_mode, gb, gb_len);
+	if (rc < 0) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error when signaling target activation");
+		return rc;
+	}
+
+	queue_work(dev->wq, &dev->tg_work);
+
+	return 0;
 }
 
 static int pn533_init_target(struct nfc_dev *nfc_dev, u32 protocols)
@@ -1553,9 +1630,6 @@ static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
 	return 0;
 }
 
-#define PN533_CMD_DATAEXCH_HEAD_LEN (sizeof(struct pn533_frame) + 3)
-#define PN533_CMD_DATAEXCH_DATA_MAXLEN 262
-
 static int pn533_data_exchange_tx_frame(struct pn533 *dev, struct sk_buff *skb)
 {
 	int payload_len = skb->len;
@@ -1920,6 +1994,7 @@ static int pn533_probe(struct usb_interface *interface,
 
 	INIT_WORK(&dev->cmd_work, pn533_wq_cmd_complete);
 	INIT_WORK(&dev->mi_work, pn533_wq_mi_recv);
+	INIT_WORK(&dev->tg_work, pn533_wq_tg_get_data);
 	dev->wq = alloc_workqueue("pn533",
 				  WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
 				  1);
-- 
1.7.9.1

