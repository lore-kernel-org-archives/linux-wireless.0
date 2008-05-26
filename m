Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15067 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYEZKub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 06:50:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH, take 3] libertas: fix compact flash interrupt handling
Date: Mon, 26 May 2008 12:50:23 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805261250.23580.hs4233@mail.mn-solutions.de> (sfid-20080526_125034_983233_3C94F7A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code misbehaved because it polled card status and always called the
"tx over" code-path.

This also fixes a hard lockup by not allowing and card interrupts while
transferring a TX frame or a command into the card.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-05-26 08:53:27.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-05-26 10:27:24.000000000 +0200
@@ -215,9 +215,21 @@ static int if_cs_poll_while_fw_download(
 
 
 /********************************************************************/
-/* I/O                                                              */
+/* I/O and interrupt handling                                       */
 /********************************************************************/
 
+static inline void if_cs_enable_ints(struct if_cs_card *card)
+{
+	lbs_deb_enter(LBS_DEB_CS);
+	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
+}
+
+static inline void if_cs_disable_ints(struct if_cs_card *card)
+{
+	lbs_deb_enter(LBS_DEB_CS);
+	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
+}
+
 /*
  * Called from if_cs_host_to_card to send a command to the hardware
  */
@@ -228,6 +240,7 @@ static int if_cs_send_cmd(struct lbs_pri
 	int loops = 0;
 
 	lbs_deb_enter(LBS_DEB_CS);
+	if_cs_disable_ints(card);
 
 	/* Is hardware ready? */
 	while (1) {
@@ -258,19 +271,24 @@ static int if_cs_send_cmd(struct lbs_pri
 	ret = 0;
 
 done:
+	if_cs_enable_ints(card);
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
 }
 
-
 /*
  * Called from if_cs_host_to_card to send a data to the hardware
  */
 static void if_cs_send_data(struct lbs_private *priv, u8 *buf, u16 nb)
 {
 	struct if_cs_card *card = (struct if_cs_card *)priv->card;
+	u16 status;
 
 	lbs_deb_enter(LBS_DEB_CS);
+	if_cs_disable_ints(card);
+
+	status = if_cs_read16(card, IF_CS_C_STATUS);
+	BUG_ON((status & IF_CS_C_S_TX_DNLD_RDY) == 0);
 
 	if_cs_write16(card, IF_CS_H_WRITE_LEN, nb);
 
@@ -281,11 +299,11 @@ static void if_cs_send_data(struct lbs_p
 
 	if_cs_write16(card, IF_CS_H_STATUS, IF_CS_H_STATUS_TX_OVER);
 	if_cs_write16(card, IF_CS_H_INT_CAUSE, IF_CS_H_STATUS_TX_OVER);
+	if_cs_enable_ints(card);
 
 	lbs_deb_leave(LBS_DEB_CS);
 }
 
-
 /*
  * Get the command result out of the card.
  */
@@ -330,7 +348,6 @@ out:
 	return ret;
 }
 
-
 static struct sk_buff *if_cs_receive_data(struct lbs_private *priv)
 {
 	struct sk_buff *skb = NULL;
@@ -367,25 +384,6 @@ out:
 	return skb;
 }
 
-
-
-/********************************************************************/
-/* Interrupts                                                       */
-/********************************************************************/
-
-static inline void if_cs_enable_ints(struct if_cs_card *card)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
-}
-
-static inline void if_cs_disable_ints(struct if_cs_card *card)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
-}
-
-
 static irqreturn_t if_cs_interrupt(int irq, void *data)
 {
 	struct if_cs_card *card = data;
@@ -394,10 +392,8 @@ static irqreturn_t if_cs_interrupt(int i
 
 	lbs_deb_enter(LBS_DEB_CS);
 
+	/* Ask card interrupt cause register if there is something for us */
 	cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
-	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
-
-	lbs_deb_cs("cause 0x%04x\n", cause);
 	if (cause == 0) {
 		/* Not for us */
 		return IRQ_NONE;
@@ -409,9 +405,9 @@ static irqreturn_t if_cs_interrupt(int i
 		return IRQ_HANDLED;
 	}
 
-	/* TODO: I'm not sure what the best ordering is */
-
-	cause = if_cs_read16(card, IF_CS_C_STATUS) & IF_CS_C_S_MASK;
+	/* Clear interrupt cause */
+	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
+	lbs_deb_cs("cause 0x%04x\n", cause);
 
 	if (cause & IF_CS_C_S_RX_UPLD_RDY) {
 		struct sk_buff *skb;
@@ -422,7 +418,7 @@ static irqreturn_t if_cs_interrupt(int i
 	}
 
 	if (cause & IF_CS_H_IC_TX_OVER) {
-		lbs_deb_cs("tx over\n");
+		lbs_deb_cs("tx done\n");
 		lbs_host_to_card_done(priv);
 	}
 
@@ -430,7 +426,7 @@ static irqreturn_t if_cs_interrupt(int i
 		unsigned long flags;
 		u8 i;
 
-		lbs_deb_cs("cmd upload ready\n");
+		lbs_deb_cs("cmd resp\n");
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		i = (priv->resp_idx == 0) ? 1 : 0;
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -449,10 +445,11 @@ static irqreturn_t if_cs_interrupt(int i
 			& IF_CS_C_S_STATUS_MASK;
 		if_cs_write16(priv->card, IF_CS_H_INT_CAUSE,
 			IF_CS_H_IC_HOST_EVENT);
-		lbs_deb_cs("eventcause 0x%04x\n", event);
+		lbs_deb_cs("host event 0x%04x\n", event);
 		lbs_queue_event(priv, event >> 8 & 0xff);
 	}
 
+	lbs_deb_leave(LBS_DEB_CS);
 	return IRQ_HANDLED;
 }
 
