Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54836 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbZCJIz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 04:55:57 -0400
Date: Tue, 10 Mar 2009 10:55:50 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix FIF_PROMISC_IN_BSS processing in station mode
Message-ID: <20090310085550.GA2147@jm.kir.nu> (sfid-20090310_095607_418272_8AF5AFA6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must not disable ACK sending in this case since it would break
normal station operations. In addition, clarify the comment about AP
mode to make more sense.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/recv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2009-03-10 10:49:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2009-03-10 10:52:19.000000000 +0200
@@ -385,14 +385,15 @@ u32 ath_calcrxfilter(struct ath_softc *s
 	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
-	/* Can't set HOSTAP into promiscous mode */
+	/*
+	 * Set promiscuous mode when FIF_PROMISC_IN_BSS is enabled for station
+	 * mode interface or when in monitor mode. AP mode does not need this
+	 * since it receives all in-BSS frames anyway.
+	 */
 	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP) &&
 	     (sc->rx.rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR)) {
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR))
 		rfilt |= ATH9K_RX_FILTER_PROM;
-		/* ??? To prevent from sending ACK */
-		rfilt &= ~ATH9K_RX_FILTER_UCAST;
-	}
 
 	if (sc->rx.rxfilter & FIF_CONTROL)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;

-- 
Jouni Malinen                                            PGP id EFC895FA
