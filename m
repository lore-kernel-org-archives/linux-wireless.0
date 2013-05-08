Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:57027 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3EHRS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 13:18:57 -0400
Received: by mail-da0-f50.google.com with SMTP id i23so1100845dad.37
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 10:18:57 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath9k <ath9k-devel@lists.ath9k.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/3] ath9k: use ap style beaconing for mesh
Date: Wed,  8 May 2013 10:16:48 -0700
Message-Id: <1368033408-3994-3-git-send-email-thomas@cozybit.com> (sfid-20130508_191900_017824_8E317C96)
In-Reply-To: <1368033408-3994-1-git-send-email-thomas@cozybit.com>
References: <1368033408-3994-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow and Javier Lopez contributed these changes to
make mesh mode use the more similar AP beaconing mode and
queue parameters. Should improve PS performance, interface
concurrency (AP modes can coexist), and beacon interval
stability.

AR9271 (ath9k_htc) mesh interfaces also need to be in AP
operating mode.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    8 +++++---
 drivers/net/wireless/ath/ath9k/hw.c     |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 2ff570f..fd1eeba 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -39,7 +39,8 @@ static void ath9k_beaconq_config(struct ath_softc *sc)
 
 	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP ||
+	    sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
@@ -273,7 +274,8 @@ static int ath9k_beacon_choose_slot(struct ath_softc *sc)
 	u64 tsf;
 	int slot;
 
-	if (sc->sc_ah->opmode != NL80211_IFTYPE_AP) {
+	if (sc->sc_ah->opmode != NL80211_IFTYPE_AP &&
+	    sc->sc_ah->opmode != NL80211_IFTYPE_MESH_POINT) {
 		ath_dbg(common, BEACON, "slot 0, tsf: %llu\n",
 			ath9k_hw_gettsf64(sc->sc_ah));
 		return 0;
@@ -765,10 +767,10 @@ void ath9k_set_beacon(struct ath_softc *sc)
 
 	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		ath9k_beacon_config_ap(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
 		ath9k_beacon_config_adhoc(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7f25da8..a263ccc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1245,10 +1245,10 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 
 	switch (opmode) {
 	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
 		set |= AR_STA_ID1_ADHOC;
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		set |= AR_STA_ID1_STA_AP;
 		/* fall through */
@@ -2246,12 +2246,12 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 
 	switch (ah->opmode) {
 	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER, next_beacon +
 			  TU_TO_USEC(ah->atim_window ? ah->atim_window : 1));
 		flags |= AR_NDP_TIMER_EN;
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, next_beacon);
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, next_beacon -
-- 
1.7.10.4

