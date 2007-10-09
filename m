Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7712 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbXJIIlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 04:41:46 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH, take 2] libertas: fixes for slow hardware
Date: Tue, 9 Oct 2007 10:41:57 +0200
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org
References: <200710081118.27468.hs4233@mail.mn-solutions.de> <1191849316.2703.26.camel@localhost.localdomain>
In-Reply-To: <1191849316.2703.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710091041.57159.hs4233@mail.mn-solutions.de> (sfid-20071009_094154_833494_338E13F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes for slow hardware.

Signed-off-by: Vitaly V. Bursov <vitalyvb@ukr.net>
Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: libertas-2.6/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2007-10-09 11:40:37.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/if_cs.c	2007-10-09 11:40:50.000000000 +0200
@@ -148,11 +148,11 @@ static int if_cs_poll_while_fw_download(
 {
 	int i;
 
-	for (i = 0; i < 500; i++) {
+	for (i = 0; i < 1000; i++) {
 		u8 val = if_cs_read8(card, addr);
 		if (val == reg)
 			return i;
-		udelay(100);
+		udelay(500);
 	}
 	return -ETIME;
 }
@@ -878,6 +878,9 @@ static int if_cs_probe(struct pcmcia_dev
 		goto out3;
 	}
 
+	/* Clear any interrupt cause that happend while sending
+	 * firmware/initializing card */
+	if_cs_write16(card, IF_CS_C_INT_CAUSE, IF_CS_C_IC_MASK);
 	if_cs_enable_ints(card);
 
 	/* And finally bring the card up */

