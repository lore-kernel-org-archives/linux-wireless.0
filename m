Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63916 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DDR0X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:26:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 10:25:58 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/5] ath9k: Handle BSSID/AID for multiple interfaces
Date: Mon, 4 Apr 2011 22:56:18 +0530
Message-ID: <1301937979-14770-3-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
References: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of now bssid/aid is overridden with recently changed vif's
bss config. This may cause improper beacon updation due to
bssid/aid mismatch. On station mode, select an associated
sta vif as primary vif and configure that vif's bss into hw.
Update the primary vif on interface change and bss info change.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +-
 drivers/net/wireless/ath/ath9k/main.c  |   70 +++++++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d637345..1ffe8d4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -346,7 +346,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 
 struct ath_vif {
 	int av_bslot;
-	bool is_bslot_active;
+	bool is_bslot_active, primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	struct ath_buf *av_bcbuf;
 };
@@ -548,6 +548,7 @@ struct ath_ant_comb {
 #define SC_OP_BT_SCAN		     BIT(13)
 #define SC_OP_ANI_RUN		     BIT(14)
 #define SC_OP_ENABLE_APM	     BIT(15)
+#define SC_OP_PRIM_STA_VIF	     BIT(16)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 729f3db..e5a9f69 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -841,10 +841,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			"Bss Info ASSOC %d, bssid: %pM\n",
 			bss_conf->aid, common->curbssid);
 
-		/* New association, store aid */
-		common->curaid = bss_conf->aid;
-		ath9k_hw_write_associd(ah);
-
 		/*
 		 * Request a re-configuration of Beacon related timers
 		 * on the receipt of the first Beacon frame (i.e.,
@@ -863,7 +859,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_start_ani(common);
 	} else {
 		ath_dbg(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
-		common->curaid = 0;
 		/* Stop ANI */
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
@@ -1890,6 +1885,66 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	return ret;
 }
+static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath_softc *sc = data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+
+	switch (sc->sc_ah->opmode) {
+	case NL80211_IFTYPE_ADHOC:
+		/* There can be only one vif available */
+		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+		common->curaid = bss_conf->aid;
+		ath9k_hw_write_associd(sc->sc_ah);
+		break;
+	case NL80211_IFTYPE_STATION:
+		/*
+		 * Skip iteration if primary station vif's bss info
+		 * was not changed
+		 */
+		if (sc->sc_flags & SC_OP_PRIM_STA_VIF)
+			break;
+
+		if (bss_conf->assoc) {
+			sc->sc_flags |= SC_OP_PRIM_STA_VIF;
+			avp->primary_sta_vif = true;
+			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+			common->curaid = bss_conf->aid;
+			ath9k_hw_write_associd(sc->sc_ah);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+
+	/* Reconfigure bss info */
+	if (avp->primary_sta_vif && !bss_conf->assoc) {
+		sc->sc_flags &= ~SC_OP_PRIM_STA_VIF;
+		avp->primary_sta_vif = false;
+		memset(common->curbssid, 0, ETH_ALEN);
+		common->curaid = 0;
+	}
+
+	ieee80211_iterate_active_interfaces_atomic(
+			sc->hw, ath9k_bss_iter, sc);
+
+	/*
+	 * None of station vifs are associated.
+	 * Clear bssid & aid
+	 */
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+	    !(sc->sc_flags & SC_OP_PRIM_STA_VIF))
+		ath9k_hw_write_associd(sc->sc_ah);
+}
 
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
@@ -1907,10 +1962,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	if (changed & BSS_CHANGED_BSSID) {
-		/* Set BSSID */
-		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-		common->curaid = 0;
-		ath9k_hw_write_associd(ah);
+		ath9k_config_bss(sc, vif);
 
 		/* Set aggregation protection mode parameters */
 		sc->config.ath_aggr_prot = 0;
-- 
1.7.4.2

