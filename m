Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56752 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbYLESnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 13:43:01 -0500
Date: Fri, 5 Dec 2008 20:42:45 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9k: Free Beacon skbs in AP mode
Message-ID: <20081205184245.GA10596@jm.kir.nu> (sfid-20081205_194306_870541_7F8236A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a memory leak where AP mode did not free transmitted Beacon frame
skbs.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/ath9k/beacon.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c	2008-12-05 18:37:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c	2008-12-05 18:38:41.000000000 +0200
@@ -167,6 +167,7 @@
 		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
 				 skb->len,
 				 PCI_DMA_TODEVICE);
+		dev_kfree_skb_any(skb);
 	}
 
 	skb = ieee80211_beacon_get(sc->hw, vif);

-- 
Jouni Malinen                                            PGP id EFC895FA
