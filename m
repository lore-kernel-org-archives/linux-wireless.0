Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39281 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbYLRMbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 07:31:17 -0500
Date: Thu, 18 Dec 2008 14:31:10 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix key cache slot selection for splitmic
Message-ID: <20081218123110.GA32267@jm.kir.nu> (sfid-20081218_133120_922949_A116C844)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_reserve_key_cache_slot() was obviously supposed to return an index
to a free slot, not reserved one. This could have caused problems with
hardware revisions that use splitmic.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2008-12-18 13:04:31.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2008-12-18 13:05:37.000000000 +0200
@@ -756,12 +756,12 @@ static int ath_reserve_key_cache_slot(st
 			    (test_bit(i , sc->sc_keymap) ||
 			     test_bit(i + 32, sc->sc_keymap) ||
 			     test_bit(i + 64 + 32, sc->sc_keymap)))
-				return i;
+				return i + 64;
 			if (!test_bit(i + 64 + 32, sc->sc_keymap) &&
 			    (test_bit(i, sc->sc_keymap) ||
 			     test_bit(i + 32, sc->sc_keymap) ||
 			     test_bit(i + 64, sc->sc_keymap)))
-				return i;
+				return i + 64 + 32;
 		}
 	} else {
 		for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 2; i++) {

-- 
Jouni Malinen                                            PGP id EFC895FA
