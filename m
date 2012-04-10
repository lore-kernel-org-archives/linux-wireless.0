Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab2DJRgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:25 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 16/18] NFC: pn533 Rx chaining support
Date: Tue, 10 Apr 2012 19:43:18 +0200
Message-Id: <1334079800-10671-17-git-send-email-sameo@linux.intel.com> (sfid-20120410_193647_436828_76590911)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When buffers on the receiption path exceed 262 bytes, the pn533 uses
a chaining mechanism where the initiator has to send NULL data frames
to fetch the remaining frames.
We do that from a workqueue context while holding the cmd lock. Once the
MI bit is gone, we aggregate the queued received skbs.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |  144 +++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 128 insertions(+), 16 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index f2ee06f..e6ec16d 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -266,8 +266,11 @@ struct pn533 {
 	int in_maxlen;
 	struct pn533_frame *in_frame;
 
+	struct sk_buff_head resp_q;
+
 	struct workqueue_struct	*wq;
 	struct work_struct cmd_work;
+	struct work_struct mi_work;
 	struct pn533_frame *wq_in_frame;
 	int wq_in_error;
 
@@ -1256,6 +1259,8 @@ static void pn533_deactivate_target(struct nfc_dev *nfc_dev, u32 target_idx)
 
 	dev->tgt_active_prot = 0;
 
+	skb_queue_purge(&dev->resp_q);
+
 	pn533_tx_frame_init(dev->out_frame, PN533_CMD_IN_RELEASE);
 
 	tg = 1;
@@ -1454,11 +1459,49 @@ struct pn533_data_exchange_arg {
 	void *cb_context;
 };
 
+static struct sk_buff *pn533_build_response(struct pn533 *dev)
+{
+	struct sk_buff *skb, *tmp, *t;
+	unsigned int skb_len = 0, tmp_len = 0;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s\n", __func__);
+
+	if (skb_queue_empty(&dev->resp_q))
+		return NULL;
+
+	if (skb_queue_len(&dev->resp_q) == 1) {
+		skb = skb_dequeue(&dev->resp_q);
+		goto out;
+	}
+
+	skb_queue_walk_safe(&dev->resp_q, tmp, t)
+		skb_len += tmp->len;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s total length %d\n",
+		    __func__, skb_len);
+
+	skb = alloc_skb(skb_len, GFP_KERNEL);
+	if (skb == NULL)
+		goto out;
+
+	skb_put(skb, skb_len);
+
+	skb_queue_walk_safe(&dev->resp_q, tmp, t) {
+		memcpy(skb->data + tmp_len, tmp->data, tmp->len);
+		tmp_len += tmp->len;
+	}
+
+out:
+	skb_queue_purge(&dev->resp_q);
+
+	return skb;
+}
+
 static int pn533_data_exchange_complete(struct pn533 *dev, void *_arg,
 						u8 *params, int params_len)
 {
 	struct pn533_data_exchange_arg *arg = _arg;
-	struct sk_buff *skb_resp = arg->skb_resp;
+	struct sk_buff *skb = NULL, *skb_resp = arg->skb_resp;
 	struct pn533_frame *in_frame = (struct pn533_frame *) skb_resp->data;
 	int err = 0;
 	u8 status;
@@ -1466,15 +1509,13 @@ static int pn533_data_exchange_complete(struct pn533 *dev, void *_arg,
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
-	dev_kfree_skb_irq(arg->skb_out);
+	dev_kfree_skb(arg->skb_out);
 
 	if (params_len < 0) { /* error */
 		err = params_len;
 		goto error;
 	}
 
-	skb_put(skb_resp, PN533_FRAME_SIZE(in_frame));
-
 	status = params[0];
 
 	cmd_ret = status & PN533_CMD_RET_MASK;
@@ -1485,25 +1526,27 @@ static int pn533_data_exchange_complete(struct pn533 *dev, void *_arg,
 		goto error;
 	}
 
+	skb_put(skb_resp, PN533_FRAME_SIZE(in_frame));
+	skb_pull(skb_resp, PN533_CMD_DATAEXCH_HEAD_LEN);
+	skb_trim(skb_resp, skb_resp->len - PN533_FRAME_TAIL_SIZE);
+	skb_queue_tail(&dev->resp_q, skb_resp);
+
 	if (status & PN533_CMD_MI_MASK) {
-		/* TODO: Implement support to multi-part data exchange */
-		nfc_dev_err(&dev->interface->dev, "Multi-part message not yet"
-								" supported");
-		/* Prevent the other messages from controller */
-		pn533_send_ack(dev, GFP_ATOMIC);
-		err = -ENOSYS;
-		goto error;
+		queue_work(dev->wq, &dev->mi_work);
+		return -EINPROGRESS;
 	}
 
-	skb_pull(skb_resp, PN533_CMD_DATAEXCH_HEAD_LEN);
-	skb_trim(skb_resp, skb_resp->len - PN533_FRAME_TAIL_SIZE);
+	skb = pn533_build_response(dev);
+	if (skb == NULL)
+		goto error;
 
-	arg->cb(arg->cb_context, skb_resp, 0);
+	arg->cb(arg->cb_context, skb, 0);
 	kfree(arg);
 	return 0;
 
 error:
-	dev_kfree_skb_irq(skb_resp);
+	skb_queue_purge(&dev->resp_q);
+	dev_kfree_skb(skb_resp);
 	arg->cb(arg->cb_context, NULL, err);
 	kfree(arg);
 	return 0;
@@ -1578,6 +1621,68 @@ error:
 	return rc;
 }
 
+static void pn533_wq_mi_recv(struct work_struct *work)
+{
+	struct pn533 *dev = container_of(work, struct pn533, mi_work);
+	struct sk_buff *skb_cmd;
+	struct pn533_data_exchange_arg *arg = dev->cmd_complete_arg;
+	struct pn533_frame *out_frame, *in_frame;
+	struct sk_buff *skb_resp;
+	int skb_resp_len;
+	int rc;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	/* This is a zero payload size skb */
+	skb_cmd = alloc_skb(PN533_CMD_DATAEXCH_HEAD_LEN + PN533_FRAME_TAIL_SIZE,
+			    GFP_KERNEL);
+	if (skb_cmd == NULL)
+		goto error_cmd;
+
+	skb_reserve(skb_cmd, PN533_CMD_DATAEXCH_HEAD_LEN);
+
+	rc = pn533_data_exchange_tx_frame(dev, skb_cmd);
+	if (rc)
+		goto error_frame;
+
+	skb_resp_len = PN533_CMD_DATAEXCH_HEAD_LEN +
+			PN533_CMD_DATAEXCH_DATA_MAXLEN +
+			PN533_FRAME_TAIL_SIZE;
+	skb_resp = alloc_skb(skb_resp_len, GFP_KERNEL);
+	if (!skb_resp) {
+		rc = -ENOMEM;
+		goto error_frame;
+	}
+
+	in_frame = (struct pn533_frame *) skb_resp->data;
+	out_frame = (struct pn533_frame *) skb_cmd->data;
+
+	arg->skb_resp = skb_resp;
+	arg->skb_out = skb_cmd;
+
+	rc = __pn533_send_cmd_frame_async(dev, out_frame, in_frame,
+					  skb_resp_len,
+					  pn533_data_exchange_complete,
+					  dev->cmd_complete_arg, GFP_KERNEL);
+	if (!rc)
+		return;
+
+	nfc_dev_err(&dev->interface->dev, "Error %d when trying to"
+						" perform data_exchange", rc);
+
+	kfree_skb(skb_resp);
+
+error_frame:
+	kfree_skb(skb_cmd);
+
+error_cmd:
+	pn533_send_ack(dev, GFP_KERNEL);
+
+	kfree(arg);
+
+	up(&dev->cmd_lock);
+}
+
 static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 								u8 cfgdata_len)
 {
@@ -1676,10 +1781,15 @@ static int pn533_probe(struct usb_interface *interface,
 			pn533_send_complete, dev);
 
 	INIT_WORK(&dev->cmd_work, pn533_wq_cmd_complete);
-	dev->wq = create_singlethread_workqueue("pn533");
+	INIT_WORK(&dev->mi_work, pn533_wq_mi_recv);
+	dev->wq = alloc_workqueue("pn533",
+				  WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				  1);
 	if (dev->wq == NULL)
 		goto error;
 
+	skb_queue_head_init(&dev->resp_q);
+
 	usb_set_intfdata(interface, dev);
 
 	pn533_tx_frame_init(dev->out_frame, PN533_CMD_GET_FIRMWARE_VERSION);
@@ -1756,6 +1866,8 @@ static void pn533_disconnect(struct usb_interface *interface)
 
 	destroy_workqueue(dev->wq);
 
+	skb_queue_purge(&dev->resp_q);
+
 	kfree(dev->in_frame);
 	usb_free_urb(dev->in_urb);
 	kfree(dev->out_frame);
-- 
1.7.9.1

