Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40754 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbXLSQJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:49 -0500
Subject: [PATCH 123/48] libertas: use priv->upld_buf for command responses
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50u4-00020c-Mz@pmac.infradead.org> (sfid-20071219_160951_469570_E9760314)
Date: Wed, 19 Dec 2007 15:32:12 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 15:22:43 -0500

If we don't scribble over the command we sent, then we can retry it when
the firmware responds with 0x0004 (which means -EAGAIN).

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |    2 +-
 drivers/net/wireless/libertas/if_cs.c   |   10 +---------
 drivers/net/wireless/libertas/if_sdio.c |    8 +-------
 drivers/net/wireless/libertas/if_usb.c  |   14 +-------------
 4 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index d305e98..4d38461 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -639,7 +639,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		goto done;
 	}
 
-	resp = priv->cur_cmd->cmdbuf;
+	resp = (void *)priv->upld_buf;
 
 	curcmd = le16_to_cpu(resp->command);
 
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 5814363..4b5ab9a 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -647,7 +647,6 @@ static int if_cs_get_int_status(struct lbs_private *priv, u8 *ireg)
 	struct if_cs_card *card = (struct if_cs_card *)priv->card;
 	int ret = 0;
 	u16 int_cause;
-	u8 *cmdbuf;
 	*ireg = 0;
 
 	lbs_deb_enter(LBS_DEB_CS);
@@ -679,14 +678,7 @@ sbi_get_int_status_exit:
 	/* Card has a command result for us */
 	if (*ireg & IF_CS_C_S_CMD_UPLD_RDY) {
 		spin_lock(&priv->driver_lock);
-		if (!priv->cur_cmd) {
-			cmdbuf = priv->upld_buf;
-			priv->hisregcpy &= ~IF_CS_C_S_RX_UPLD_RDY;
-		} else {
-			cmdbuf = (u8 *) priv->cur_cmd->cmdbuf;
-		}
-
-		ret = if_cs_receive_cmdres(priv, cmdbuf, &priv->upld_len);
+		ret = if_cs_receive_cmdres(priv, priv->upld_buf, &priv->upld_len);
 		spin_unlock(&priv->driver_lock);
 		if (ret < 0)
 			lbs_pr_err("could not receive cmd from card\n");
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index b24584d..5a828c7 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -136,12 +136,6 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 
 	spin_lock_irqsave(&card->priv->driver_lock, flags);
 
-	if (!card->priv->cur_cmd) {
-		lbs_deb_sdio("discarding spurious response\n");
-		ret = 0;
-		goto out;
-	}
-
 	if (size > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_sdio("response packet too large (%d bytes)\n",
 			(int)size);
@@ -149,7 +143,7 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 		goto out;
 	}
 
-	memcpy(card->priv->cur_cmd->cmdbuf, buffer, size);
+	memcpy(card->priv->upld_buf, buffer, size);
 	card->priv->upld_len = size;
 
 	card->int_cause |= MRVDRV_CMD_UPLD_RDY;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 3931fe6..7db8e6c 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -589,8 +589,6 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 				      struct if_usb_card *cardp,
 				      struct lbs_private *priv)
 {
-	uint8_t *cmdbuf;
-
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_usbd(&cardp->udev->dev,
 			     "The receive buffer is too large\n");
@@ -602,19 +600,9 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 		BUG();
 
 	spin_lock(&priv->driver_lock);
-	/* take care of cur_cmd = NULL case by reading the
-	 * data to clear the interrupt */
-	if (!priv->cur_cmd) {
-		lbs_deb_hex(LBS_DEB_HOST, "Unsolicited CMD_RESP",
-			    (void *) recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
-		cmdbuf = priv->upld_buf;
-		priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
-	} else
-		cmdbuf = (uint8_t *) priv->cur_cmd->cmdbuf;
-
 	cardp->usb_int_cause |= MRVDRV_CMD_UPLD_RDY;
 	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
-	memcpy(cmdbuf, recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
+	memcpy(priv->upld_buf, recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
 
 	kfree_skb(skb);
 	lbs_interrupt(priv);
-- 
1.5.3.4

