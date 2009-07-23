Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30283 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbZGWKCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:02:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:02:36 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19048.13626.281545.724479@localhost.localdomain>
Date: Thu, 23 Jul 2009 15:32:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] ath9k: Remove redundant HT macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These can be obtained from mac80211.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/main.c  |    8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1308cac..d3c1633 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -194,8 +194,6 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
-#define IEEE80211_MIN_AMPDU_BUF    0x8
-#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR 13
 #define IEEE80211_WEP_IVLEN        3
 #define IEEE80211_WEP_KIDLEN       1
 #define IEEE80211_WEP_CRCLEN       4
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b053c1c..fb84dd8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -462,7 +462,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
-		an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
 		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
 		an->last_rssi = ATH_RSSI_DUMMY_MARKER;
@@ -888,8 +888,6 @@ static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 static void setup_ht_cap(struct ath_softc *sc,
 			 struct ieee80211_sta_ht_cap *ht_info)
 {
-#define	ATH9K_HT_CAP_MAXRXAMPDU_65536 0x3	/* 2 ^ 16 */
-#define	ATH9K_HT_CAP_MPDUDENSITY_8 0x6		/* 8 usec */
 	u8 tx_streams, rx_streams;
 
 	ht_info->ht_supported = true;
@@ -898,8 +896,8 @@ static void setup_ht_cap(struct ath_softc *sc,
 		       IEEE80211_HT_CAP_SGI_40 |
 		       IEEE80211_HT_CAP_DSSSCCK40;
 
-	ht_info->ampdu_factor = ATH9K_HT_CAP_MAXRXAMPDU_65536;
-	ht_info->ampdu_density = ATH9K_HT_CAP_MPDUDENSITY_8;
+	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-- 
1.6.3.3

