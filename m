Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9921 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYA1QYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:24:07 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: misc cleanups in compact-flash code
Date: Mon, 28 Jan 2008 17:24:21 +0100
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801281724.21321.hs4233@mail.mn-solutions.de> (sfid-20080128_162411_470015_9D5B01A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:57:44.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:58:30.000000000 +0100
@@ -396,11 +396,9 @@ static struct sk_buff *if_cs_receive_dat
 	if (len == 0 || len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
 		lbs_pr_err("card data buffer has invalid # of bytes (%d)\n", len);
 		priv->stats.rx_dropped++;
-		printk(KERN_INFO "##HS %s:%d TODO\n", __FUNCTION__, __LINE__);
 		goto dat_err;
 	}
 
-	//TODO: skb = dev_alloc_skb(len+ETH_FRAME_LEN+MRVDRV_SNAP_HEADER_LEN+EXTRA_LEN);
 	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + 2);
 	if (!skb)
 		goto out;
@@ -912,6 +910,7 @@ static void if_cs_detach(struct pcmcia_d
 	if_cs_disable_ints(card);
 	if_cs_release(p_dev);
 	kfree(card);
+	card = NULL;
 
 	lbs_deb_leave(LBS_DEB_CS);
 }
