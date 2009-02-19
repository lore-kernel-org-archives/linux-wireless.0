Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14463 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZBSKPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 05:15:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 02:15:06 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Filter out beacons from other BSS in STA mode
Date: Thu, 19 Feb 2009 15:41:52 +0530
Message-ID: <1235038312-17974-1-git-send-email-vasanth@atheros.com> (sfid-20090219_111511_995041_B838E117)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Passing beacons received from other BSS to s/w in non-scanning
state is unnecessary in STA mode. This patch filters them out in
h/w.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/mac.h  |    3 ++-
 drivers/net/wireless/ath9k/recv.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/mac.h b/drivers/net/wireless/ath9k/mac.h
index 74b660a..862a63f 100644
--- a/drivers/net/wireless/ath9k/mac.h
+++ b/drivers/net/wireless/ath9k/mac.h
@@ -566,8 +566,9 @@ enum ath9k_rx_filter {
 	ATH9K_RX_FILTER_BEACON = 0x00000010,
 	ATH9K_RX_FILTER_PROM = 0x00000020,
 	ATH9K_RX_FILTER_PROBEREQ = 0x00000080,
-	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
 	ATH9K_RX_FILTER_PHYERR = 0x00000100,
+	ATH9K_RX_FILTER_MYBEACON = 0x00000200,
+	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
 	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
 };
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 28ad1d5..23b6f54 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -375,14 +375,15 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->rx.rxfilter & FIF_CONTROL)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION ||
-	    sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+	    !(sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC))
+		rfilt |= ATH9K_RX_FILTER_MYBEACON;
+	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
-	   & beacon frames */
+	/* If in HOSTAP mode, want to enable reception of PSPOLL frames */
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP)
-		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
+		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
 	return rfilt;
 
-- 
1.5.5.1

