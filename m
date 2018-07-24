Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:56676 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388185AbeGXKAM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 06:00:12 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v2 05/10] NFC: st95hf: remove exchange_lock
Date: Tue, 24 Jul 2018 10:54:21 +0200
Message-Id: <20180724085426.23999-6-daniel@zonque.org> (sfid-20180724_105457_188247_676B0EE2)
In-Reply-To: <20180724085426.23999-1-daniel@zonque.org>
References: <20180724085426.23999-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the exchange_lock sempahore. Its intended function
was two-fold:

a) Lock the remove() callback of the driver against the ISR, so that
   the resources only go away after the ISR has finished. This is
   unnecessary though, because `rm_lock' does that already, in
   combination with the nullification of `scontext->ddev'.

b) Indicate whether a command was sent previously. If the semaphore
   is found unused in the threaded ISR, an error is reported.
   This case can be handled much nicer by checking whether `skb_resp'
   is present in the context. For this, nullify the `skb_resp' pointer
   in the callback context after it was sent back to the NFC core.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 52 +++++++--------------------------------
 1 file changed, 9 insertions(+), 43 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index d857197ec7b2..6761ab90f68d 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -214,8 +214,6 @@ struct st95_digital_cmd_complete_arg {
  * @st95hf_supply: regulator "consumer" for NFC device.
  * @sendrcv_trflag: last byte of frame send by sendrecv command
  *	of st95hf. This byte contains transmission flag info.
- * @exchange_lock: semaphore used for signaling the st95hf_remove
- *	function that the last outstanding async nfc request is finished.
  * @rm_lock: mutex for ensuring safe access of nfc digital object
  *	from threaded ISR. Usage of this mutex avoids any race between
  *	deletion of the object from st95hf_remove() and its access from
@@ -233,7 +231,6 @@ struct st95hf_context {
 	struct st95_digital_cmd_complete_arg complete_cb_arg;
 	struct regulator *st95hf_supply;
 	unsigned char sendrcv_trflag;
-	struct semaphore exchange_lock;
 	struct mutex rm_lock;
 	u8 current_protocol;
 	u8 current_rf_tech;
@@ -785,29 +782,14 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	struct st95_digital_cmd_complete_arg *cb_arg;
 
 	spidevice = &stcontext->spicontext.spidev->dev;
+	cb_arg = &stcontext->complete_cb_arg;
+	skb_resp = cb_arg->skb_resp;
 
-	/*
-	 * check semaphore, if not down() already, then we don't
-	 * know in which context the ISR is called and surely it
-	 * will be a bug. Note that down() of the semaphore is done
-	 * in the corresponding st95hf_in_send_cmd() and then
-	 * only this ISR should be called. ISR will up() the
-	 * semaphore before leaving. Hence when the ISR is called
-	 * the correct behaviour is down_trylock() should always
-	 * return 1 (indicating semaphore cant be taken and hence no
-	 * change in semaphore count).
-	 * If not, then we up() the semaphore and crash on
-	 * a BUG() !
-	 */
-	if (!down_trylock(&stcontext->exchange_lock)) {
-		up(&stcontext->exchange_lock);
+	if (unlikely(!skb_resp)) {
 		WARN(1, "unknown context in ST95HF ISR");
 		return IRQ_NONE;
 	}
 
-	cb_arg = &stcontext->complete_cb_arg;
-	skb_resp = cb_arg->skb_resp;
-
 	mutex_lock(&stcontext->rm_lock);
 	res_len = st95hf_spi_recv_response(&stcontext->spicontext,
 					   skb_resp->data);
@@ -856,8 +838,13 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	/* call digital layer callback */
 	cb_arg->complete_cb(stcontext->ddev, cb_arg->cb_usrarg, skb_resp);
 
+	/*
+	 * This skb is now owned by the core layer.
+	 * Make sure not to use it again.
+	 */
+	cb_arg->skb_resp = NULL;
+
 	/* up the semaphore before returning */
-	up(&stcontext->exchange_lock);
 	mutex_unlock(&stcontext->rm_lock);
 
 	return IRQ_HANDLED;
@@ -868,8 +855,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	skb_resp = ERR_PTR(result);
 	/* call of callback with error */
 	cb_arg->complete_cb(stcontext->ddev, cb_arg->cb_usrarg, skb_resp);
-	/* up the semaphore before returning */
-	up(&stcontext->exchange_lock);
 	mutex_unlock(&stcontext->rm_lock);
 	return IRQ_HANDLED;
 }
@@ -965,25 +950,12 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 	    ddev->curr_protocol == NFC_PROTO_ISO14443)
 		stcontext->complete_cb_arg.rats = true;
 
-	/*
-	 * down the semaphore to indicate to remove func that an
-	 * ISR is pending, note that it will not block here in any case.
-	 * If found blocked, it is a BUG!
-	 */
-	rc = down_killable(&stcontext->exchange_lock);
-	if (rc) {
-		WARN(1, "Semaphore is not found up in st95hf_in_send_cmd\n");
-		return rc;
-	}
-
 	rc = st95hf_spi_send(&stcontext->spicontext, skb->data,
 			     skb->len,
 			     ASYNC);
 	if (rc) {
 		dev_err(&stcontext->nfcdev->dev,
 			"Error %d trying to perform data_exchange", rc);
-		/* up the semaphore since ISR will never come in this case */
-		up(&stcontext->exchange_lock);
 		goto free_skb_resp;
 	}
 
@@ -1104,7 +1076,6 @@ static int st95hf_probe(struct spi_device *nfc_spi_dev)
 		}
 	}
 
-	sema_init(&st95context->exchange_lock, 1);
 	init_completion(&spicontext->done);
 	mutex_init(&spicontext->spi_lock);
 	mutex_init(&st95context->rm_lock);
@@ -1220,11 +1191,6 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
 
 	mutex_unlock(&stcontext->rm_lock);
 
-	/* if last in_send_cmd's ISR is pending, wait for it to finish */
-	result = down_killable(&stcontext->exchange_lock);
-	if (result == -EINTR)
-		dev_err(&spictx->spidev->dev, "sleep for semaphore interrupted by signal\n");
-
 	/* next reset the ST95HF controller */
 	result = st95hf_spi_send(&stcontext->spicontext,
 				 &reset_cmd,
-- 
2.17.1
