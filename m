Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55412 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbZENSak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:30:40 -0400
Message-Id: <20090514183036.280876573@atheros.com>
References: <20090514182845.684003914@atheros.com>
Date: Thu, 14 May 2009 21:28:46 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/4] ath9k: Fix a check for multicast address for virtual wiphy
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The broadcast bit is in the first, not the last octet..

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-05-14 21:04:12.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-05-14 21:12:18.000000000 +0300
@@ -637,7 +637,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		}
 
 		/* Send the frame to mac80211 */
-		if (hdr->addr1[5] & 0x01) {
+		if (is_multicast_ether_addr(hdr->addr1)) {
 			int i;
 			/*
 			 * Deliver broadcast/multicast frames to all suitable

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
