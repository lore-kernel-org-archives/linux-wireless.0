Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63170 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0L1Hgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 02:36:35 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 23:36:18 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Few clean ups in beacon config parameters
Date: Tue, 28 Dec 2010 13:06:26 +0530
Message-ID: <1293521786-13126-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Some minor clean ups in assigning values to beacon config parameters

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 5e108c0..385ba03 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -566,8 +566,6 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	 * last beacon we received (which may be none).
 	 */
 	dtimperiod = conf->dtim_period;
-	if (dtimperiod <= 0)		/* NB: 0 if not known */
-		dtimperiod = 1;
 	dtimcount = conf->dtim_count;
 	if (dtimcount >= dtimperiod)	/* NB: sanity check */
 		dtimcount = 0;
@@ -575,8 +573,6 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	cfpcount = 0;
 
 	sleepduration = conf->listen_interval * intval;
-	if (sleepduration <= 0)
-		sleepduration = intval;
 
 	/*
 	 * Pull nexttbtt forward to reflect the current
@@ -662,8 +658,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 }
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
-				    struct ath_beacon_config *conf,
-				    struct ieee80211_vif *vif)
+				    struct ath_beacon_config *conf)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -718,18 +713,17 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	/* Setup the beacon configuration parameters */
 	if (vif) {
 		struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-
 		iftype = vif->type;
-
 		cur_conf->beacon_interval = bss_conf->beacon_int;
 		cur_conf->dtim_period = bss_conf->dtim_period;
+	} else {
+		iftype = sc->sc_ah->opmode;
+	}
+
 		cur_conf->listen_interval = 1;
 		cur_conf->dtim_count = 1;
 		cur_conf->bmiss_timeout =
 			ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
-	} else {
-		iftype = sc->sc_ah->opmode;
-	}
 
 	/*
 	 * It looks like mac80211 may end up using beacon interval of zero in
@@ -740,13 +734,20 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	if (cur_conf->beacon_interval == 0)
 		cur_conf->beacon_interval = 100;
 
+	/*
+	 * Some times we dont parse dtim period from mac80211, in that case
+	 * use a default value
+	 */
+	if (cur_conf->dtim_period == 0)
+		cur_conf->dtim_period = 1;
+
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 		ath_beacon_config_ap(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-		ath_beacon_config_adhoc(sc, cur_conf, vif);
+		ath_beacon_config_adhoc(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_STATION:
 		ath_beacon_config_sta(sc, cur_conf);
-- 
1.7.0.4

