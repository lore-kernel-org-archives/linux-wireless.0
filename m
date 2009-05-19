Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59988 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbZESOCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:34 -0400
Message-Id: <20090519140228.888935865@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:41 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 4/7] ath9k: Wake up for RX filter changes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must make sure the chip is awake when changing the RX filter
parameters. This could have caused problems, e.g., when changing the
interface to promiscuous mode while in sleep mode.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:33.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:35.000000000 +0300
@@ -2428,8 +2428,10 @@ static void ath9k_configure_filter(struc
 	*total_flags &= SUPPORTED_FILTERS;
 
 	sc->rx.rxfilter = *total_flags;
+	ath9k_ps_wakeup(sc);
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
+	ath9k_ps_restore(sc);
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilter);
 }

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
