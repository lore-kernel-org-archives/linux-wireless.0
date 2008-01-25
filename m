Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20583 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYAYNPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:15:45 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix interrupt while removing driver
Date: Fri, 25 Jan 2008 14:15:48 +0100
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801251415.48216.hs4233@mail.mn-solutions.de> (sfid-20080125_131549_207131_A08E1318)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously I've got an interrupt while removing the driver.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:54:08.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:54:50.000000000 +0100
@@ -249,14 +249,14 @@ static irqreturn_t if_cs_interrupt(int i
 	lbs_deb_enter(LBS_DEB_CS);
 
 	int_cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
-	if(int_cause == 0x0) {
+	if (int_cause == 0x0) {
 		/* Not for us */
 		return IRQ_NONE;
 
 	} else if (int_cause == 0xffff) {
 		/* Read in junk, the card has probably been removed */
 		card->priv->surpriseremoved = 1;
-
+		return IRQ_HANDLED;
 	} else {
 		if (int_cause & IF_CS_H_IC_TX_OVER)
 			lbs_host_to_card_done(card->priv);
@@ -715,8 +715,8 @@ static void if_cs_release(struct pcmcia_
 
 	lbs_deb_enter(LBS_DEB_CS);
 
-	pcmcia_disable_device(p_dev);
 	free_irq(p_dev->irq.AssignedIRQ, card);
+	pcmcia_disable_device(p_dev);
 	if (card->iobase)
 		ioport_unmap(card->iobase);
 
