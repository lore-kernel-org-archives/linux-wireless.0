Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:56688 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388145AbeGXKAM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 06:00:12 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v2 06/10] NFC: st95hf: move skb allocation to ISR
Date: Tue, 24 Jul 2018 10:54:22 +0200
Message-Id: <20180724085426.23999-7-daniel@zonque.org> (sfid-20180724_105456_118268_18A0B98B)
In-Reply-To: <20180724085426.23999-1-daniel@zonque.org>
References: <20180724085426.23999-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver currently assumes that interrupts can only occur between the
time when when a command has been sent to the device and the response
to it.

This assumption, however, is wrong. The antenna of the chip is likely to
catch a lot of environmental noise, and once in a while, the device will
latch the interrupt to signal a protocol error, and keep it latched until
the response bytes are read from the chip.

As the code currently stands, skbs for responses are only prepared when
a command is sent, and the ISR bails out early if that wasn't the case.
Hence, the interrupt remains latched, and no further communication with
device is possible.

To fix this, move the call to nfc_alloc_recv_skb() from
st95hf_in_send_cmd() to st95hf_irq_thread_handler() and always read back
the interrupt reason.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 6761ab90f68d..99f84ddfdfef 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -196,7 +196,6 @@ static const struct cmd cmd_array[] = {
 
 /* st95_digital_cmd_complete_arg stores client context */
 struct st95_digital_cmd_complete_arg {
-	struct sk_buff *skb_resp;
 	nfc_digital_cmd_complete_t complete_cb;
 	void *cb_usrarg;
 	bool rats;
@@ -783,12 +782,10 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 
 	spidevice = &stcontext->spicontext.spidev->dev;
 	cb_arg = &stcontext->complete_cb_arg;
-	skb_resp = cb_arg->skb_resp;
 
-	if (unlikely(!skb_resp)) {
-		WARN(1, "unknown context in ST95HF ISR");
+	skb_resp = nfc_alloc_recv_skb(MAX_RESPONSE_BUFFER_SIZE, GFP_KERNEL);
+	if (WARN_ON(!skb_resp))
 		return IRQ_NONE;
-	}
 
 	mutex_lock(&stcontext->rm_lock);
 	res_len = st95hf_spi_recv_response(&stcontext->spicontext,
@@ -838,12 +835,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	/* call digital layer callback */
 	cb_arg->complete_cb(stcontext->ddev, cb_arg->cb_usrarg, skb_resp);
 
-	/*
-	 * This skb is now owned by the core layer.
-	 * Make sure not to use it again.
-	 */
-	cb_arg->skb_resp = NULL;
-
 	/* up the semaphore before returning */
 	mutex_unlock(&stcontext->rm_lock);
 
@@ -913,15 +904,7 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 			      void *arg)
 {
 	struct st95hf_context *stcontext = nfc_digital_get_drvdata(ddev);
-	int rc;
-	struct sk_buff *skb_resp;
-	int len_data_to_tag = 0;
-
-	skb_resp = nfc_alloc_recv_skb(MAX_RESPONSE_BUFFER_SIZE, GFP_KERNEL);
-	if (!skb_resp) {
-		rc = -ENOMEM;
-		goto error;
-	}
+	int rc, len_data_to_tag = 0;
 
 	switch (stcontext->current_rf_tech) {
 	case NFC_DIGITAL_RF_TECH_106A:
@@ -933,8 +916,7 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 		len_data_to_tag = skb->len;
 		break;
 	default:
-		rc = -EINVAL;
-		goto free_skb_resp;
+		return -EINVAL;
 	}
 
 	skb_push(skb, 3);
@@ -942,7 +924,6 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 	skb->data[1] = SEND_RECEIVE_CMD;
 	skb->data[2] = len_data_to_tag;
 
-	stcontext->complete_cb_arg.skb_resp = skb_resp;
 	stcontext->complete_cb_arg.cb_usrarg = arg;
 	stcontext->complete_cb_arg.complete_cb = cb;
 
@@ -956,17 +937,12 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 	if (rc) {
 		dev_err(&stcontext->nfcdev->dev,
 			"Error %d trying to perform data_exchange", rc);
-		goto free_skb_resp;
+		return rc;
 	}
 
 	kfree_skb(skb);
 
-	return rc;
-
-free_skb_resp:
-	kfree_skb(skb_resp);
-error:
-	return rc;
+	return 0;
 }
 
 /* p2p will be supported in a later release ! */
-- 
2.17.1
