Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8337 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYEWOFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:05:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH, take 2] libertas: fix compact flash interrupt handling
Date: Fri, 23 May 2008 16:05:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805231605.04168.hs4233@mail.mn-solutions.de> (sfid-20080523_160525_646666_BBD539FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH] libertas: fix compact flash interrupt handling

The old code misbehaved because it polled card status and always
called the "tx over" code-path.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-05-23 14:24:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-05-23 14:34:49.000000000 +0200
@@ -394,10 +394,8 @@ static irqreturn_t if_cs_interrupt(int i
 
 	lbs_deb_enter(LBS_DEB_CS);
 
+	/* Ask card interrupt cause register if there is something for us */
 	cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
-	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
-
-	lbs_deb_cs("cause 0x%04x\n", cause);
 	if (cause == 0) {
 		/* Not for us */
 		return IRQ_NONE;
@@ -409,9 +407,9 @@ static irqreturn_t if_cs_interrupt(int i
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
@@ -422,7 +420,7 @@ static irqreturn_t if_cs_interrupt(int i
 	}
 
 	if (cause & IF_CS_H_IC_TX_OVER) {
-		lbs_deb_cs("tx over\n");
+		lbs_deb_cs("tx done\n");
 		lbs_host_to_card_done(priv);
 	}
 
@@ -430,7 +428,7 @@ static irqreturn_t if_cs_interrupt(int i
 		unsigned long flags;
 		u8 i;
 
-		lbs_deb_cs("cmd upload ready\n");
+		lbs_deb_cs("cmd resp\n");
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		i = (priv->resp_idx == 0) ? 1 : 0;
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -445,14 +443,17 @@ static irqreturn_t if_cs_interrupt(int i
 	}
 
 	if (cause & IF_CS_H_IC_HOST_EVENT) {
-		u16 event = if_cs_read16(priv->card, IF_CS_C_STATUS)
+		u16 status;
+		lbs_deb_cs("host event\n");
+		status = if_cs_read16(priv->card, IF_CS_C_STATUS)
 			& IF_CS_C_S_STATUS_MASK;
+		lbs_deb_cs("card status 0x%04x\n", status);
 		if_cs_write16(priv->card, IF_CS_H_INT_CAUSE,
 			IF_CS_H_IC_HOST_EVENT);
-		lbs_deb_cs("eventcause 0x%04x\n", event);
-		lbs_queue_event(priv, event >> 8 & 0xff);
+		lbs_queue_event(priv, status >> 8 & 0xff);
 	}
 
+	lbs_deb_leave(LBS_DEB_CS);
 	return IRQ_HANDLED;
 }
 
