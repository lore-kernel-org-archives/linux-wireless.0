Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2FFKH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:28 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 14/29] NFC: Implement the pn533 target mode Tx op
Date: Wed,  6 Jun 2012 12:16:31 +0200
Message-Id: <1338977806-30279-15-git-send-email-sameo@linux.intel.com> (sfid-20120606_120734_763466_866DFA75)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   82 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 6a506e2..db40787 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -76,6 +76,7 @@ MODULE_DEVICE_TABLE(usb, pn533_table);
 
 #define PN533_CMD_TG_INIT_AS_TARGET 0x8c
 #define PN533_CMD_TG_GET_DATA 0x86
+#define PN533_CMD_TG_SET_DATA 0x8e
 
 #define PN533_CMD_RESPONSE(cmd) (cmd + 1)
 
@@ -1630,7 +1631,8 @@ static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
 	return 0;
 }
 
-static int pn533_data_exchange_tx_frame(struct pn533 *dev, struct sk_buff *skb)
+static int pn533_build_tx_frame(struct pn533 *dev, struct sk_buff *skb,
+				bool target)
 {
 	int payload_len = skb->len;
 	struct pn533_frame *out_frame;
@@ -1647,14 +1649,20 @@ static int pn533_data_exchange_tx_frame(struct pn533 *dev, struct sk_buff *skb)
 		return -ENOSYS;
 	}
 
-	skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN);
-	out_frame = (struct pn533_frame *) skb->data;
+	if (target == true) {
+		skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN);
+		out_frame = (struct pn533_frame *) skb->data;
 
-	pn533_tx_frame_init(out_frame, PN533_CMD_IN_DATA_EXCHANGE);
+		pn533_tx_frame_init(out_frame, PN533_CMD_IN_DATA_EXCHANGE);
+		tg = 1;
+		memcpy(PN533_FRAME_CMD_PARAMS_PTR(out_frame), &tg, sizeof(u8));
+		out_frame->datalen += sizeof(u8);
+	} else {
+		skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN - 1);
+		out_frame = (struct pn533_frame *) skb->data;
+		pn533_tx_frame_init(out_frame, PN533_CMD_TG_SET_DATA);
+	}
 
-	tg = 1;
-	memcpy(PN533_FRAME_CMD_PARAMS_PTR(out_frame), &tg, sizeof(u8));
-	out_frame->datalen += sizeof(u8);
 
 	/* The data is already in the out_frame, just update the datalen */
 	out_frame->datalen += payload_len;
@@ -1785,7 +1793,7 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 		goto error;
 	}
 
-	rc = pn533_data_exchange_tx_frame(dev, skb);
+	rc = pn533_build_tx_frame(dev, skb, true);
 	if (rc)
 		goto error;
 
@@ -1833,6 +1841,61 @@ error:
 	return rc;
 }
 
+static int pn533_tm_send_complete(struct pn533 *dev, void *arg,
+				  u8 *params, int params_len)
+{
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	if (params_len < 0) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error %d when sending data",
+			    params_len);
+
+		return params_len;
+	}
+
+	if (params_len > 0 && params[0] != 0) {
+		nfc_tm_deactivated(dev->nfc_dev);
+
+		return 0;
+	}
+
+	queue_work(dev->wq, &dev->tg_work);
+
+	return 0;
+}
+
+static int pn533_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
+{
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	struct pn533_frame *out_frame;
+	int rc;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	rc = pn533_build_tx_frame(dev, skb, false);
+	if (rc)
+		goto error;
+
+	out_frame = (struct pn533_frame *) skb->data;
+
+	rc = pn533_send_cmd_frame_async(dev, out_frame, dev->in_frame,
+					dev->in_maxlen, pn533_tm_send_complete,
+					NULL, GFP_KERNEL);
+	if (rc) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error %d when trying to send data", rc);
+		goto error;
+	}
+
+	return 0;
+
+error:
+	kfree_skb(skb);
+
+	return rc;
+}
+
 static void pn533_wq_mi_recv(struct work_struct *work)
 {
 	struct pn533 *dev = container_of(work, struct pn533, mi_work);
@@ -1853,7 +1916,7 @@ static void pn533_wq_mi_recv(struct work_struct *work)
 
 	skb_reserve(skb_cmd, PN533_CMD_DATAEXCH_HEAD_LEN);
 
-	rc = pn533_data_exchange_tx_frame(dev, skb_cmd);
+	rc = pn533_build_tx_frame(dev, skb_cmd, true);
 	if (rc)
 		goto error_frame;
 
@@ -1928,6 +1991,7 @@ struct nfc_ops pn533_nfc_ops = {
 	.activate_target = pn533_activate_target,
 	.deactivate_target = pn533_deactivate_target,
 	.im_transceive = pn533_transceive,
+	.tm_send = pn533_tm_send,
 };
 
 static int pn533_probe(struct usb_interface *interface,
-- 
1.7.9.1

