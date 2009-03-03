Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35434 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbZCCRZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:05 -0500
Message-Id: <20090303172459.014230103@atheros.com> (sfid-20090303_182508_709230_9C8306D8)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:30 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 05/15] ath9k: Configure RX filter for multi-BSSID broadcast
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow RX filter to pass through all broadcast/multicast frames (i.e.,
no BSSID filtering) if virtual interfaces are used. Software filtering
will be used in this case to drop broadcast/multicast frames for
foreign BSSIDs.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/mac.h  |    1 +
 drivers/net/wireless/ath9k/recv.c |    8 ++++++++
 2 files changed, 9 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2009-03-03 18:30:59.000000000 +0200
@@ -407,6 +407,14 @@ u32 ath_calcrxfilter(struct ath_softc *s
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
+	if (sc->sec_wiphy) {
+		/* TODO: only needed if more than one BSSID is in use in
+		 * station/adhoc mode */
+		/* TODO: for older chips, may need to add ATH9K_RX_FILTER_PROM
+		 */
+		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
+	}
+
 	return rfilt;
 
 #undef RX_FILTER_PRESERVE
--- wireless-testing.orig/drivers/net/wireless/ath9k/mac.h	2009-03-02 22:17:55.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/mac.h	2009-03-03 18:30:59.000000000 +0200
@@ -570,6 +570,7 @@ enum ath9k_rx_filter {
 	ATH9K_RX_FILTER_MYBEACON = 0x00000200,
 	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
 	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
+	ATH9K_RX_FILTER_MCAST_BCAST_ALL = 0x00008000,
 };
 
 #define ATH9K_RATESERIES_RTS_CTS  0x0001

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
