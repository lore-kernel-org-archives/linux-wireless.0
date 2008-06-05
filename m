Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13408 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYFELGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 07:06:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] libertas: fix interrupt issue
Date: Thu, 5 Jun 2008 13:06:15 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806051306.15592.hs4233@mail.mn-solutions.de> (sfid-20080605_130629_360692_2E44C631)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps against lost interrupts and aids in debugging this.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-05-30 11:26:35.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-05-30 11:30:09.000000000 +0200
@@ -379,6 +379,8 @@ static irqreturn_t if_cs_interrupt(int i
 
 	/* Ask card interrupt cause register if there is something for us */
 	cause = if_cs_read16(card, IF_CS_CARD_INT_CAUSE);
+	lbs_deb_cs("cause 0x%04x\n", cause);
+
 	if (cause == 0) {
 		/* Not for us */
 		return IRQ_NONE;
@@ -390,10 +392,6 @@ static irqreturn_t if_cs_interrupt(int i
 		return IRQ_HANDLED;
 	}
 
-	/* Clear interrupt cause */
-	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, cause & IF_CS_BIT_MASK);
-	lbs_deb_cs("cause 0x%04x\n", cause);
-
 	if (cause & IF_CS_BIT_RX) {
 		struct sk_buff *skb;
 		lbs_deb_cs("rx packet\n");
@@ -434,6 +432,9 @@ static irqreturn_t if_cs_interrupt(int i
 		lbs_queue_event(priv, event >> 8 & 0xff);
 	}
 
+	/* Clear interrupt cause */
+	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, cause & IF_CS_BIT_MASK);
+
 	lbs_deb_leave(LBS_DEB_CS);
 	return IRQ_HANDLED;
 }
