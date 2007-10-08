Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10509 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbXJHJSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:18:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: fixes for slow hardware
Date: Mon, 8 Oct 2007 11:18:27 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710081118.27468.hs4233@mail.mn-solutions.de> (sfid-20071008_101842_681487_C36F00EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes issues where either the CF module is slow (and needs 
more time while downloading the firmware) or where the host 
computer is slow, so that some card interrupts arrive while
the system was still downloading the firmware.

Signed-off-by: Vitaly V. Bursov <vitalyvb@ukr.net>
Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

-- 

Index: libertas-2.6/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/if_cs.c	
2007-10-01 14:05:53.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/if_cs.c	2007-10-01 
14:06:43.000000000 +0200
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
@@ -405,6 +405,7 @@ static struct sk_buff *if_cs_receive_dat
 	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + 2);
 	if (!skb)
 		goto out;
+	skb->dev = priv->dev;
 	skb_put(skb, len);
 	skb_reserve(skb, 2);/* 16 byte align */
 	data = skb->data;
@@ -878,6 +879,9 @@ static int if_cs_probe(struct pcmcia_dev
 		goto out3;
 	}
 
+	/* Clear any interrupt cause that happend while sending
+	 * firmware/initializing card */
+	if_cs_write16(card, IF_CS_C_INT_CAUSE, IF_CS_C_IC_MASK);
 	if_cs_enable_ints(card);
 
 	/* And finally bring the card up */
