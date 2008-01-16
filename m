Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15610 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYAPOqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 09:46:47 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas cs/sdio: fix 'NOHZ: local_softirq_pending 08' message
Date: Wed, 16 Jan 2008 15:48:44 +0100
Cc: Marc Pignat <marc.pignat@hevs.ch>, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200801161334.13623.marc.pignat@hevs.ch>
In-Reply-To: <200801161334.13623.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801161548.44341.hs4233@mail.mn-solutions.de> (sfid-20080116_144652_355376_20D21A4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>

> This patch is against 2.6.24-rc8 and has only been tested with
> the sdio interface, please test it with usb.

The patch should be against wireless-2.6, branch everything. I'm
adding a revised version:


----

netif_rx should be called only from interrupt context. if_cs and if_sdio receive
packets from other contexts, and thus should call netif_rx_ni.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

Index: wireless-2.6/drivers/net/wireless/libertas/rx.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/rx.c	2008-01-16 16:45:12.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/rx.c	2008-01-16 16:45:42.000000000 +0100
@@ -247,7 +247,10 @@ int lbs_process_rxed_packet(struct lbs_p
 	priv->stats.rx_packets++;
 
 	skb->protocol = eth_type_trans(skb, dev);
-	netif_rx(skb);
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		netif_rx_ni(skb);
 
 	ret = 0;
 done:
