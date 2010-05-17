Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10971 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0EQGa5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:30:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:30:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19440.58036.74141.390538@gargle.gargle.HOWL>
Date: Mon, 17 May 2010 12:01:16 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/5] ath9k_htc: Cleanup rate initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a large chunk of code dealing
with rate management within the driver and simplifying
things by removing the hacky method of calculating
HT changes. A subsequent patch would fix this by
just using BSS_CHANGED_HT from mac80211.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    2 -
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  113 +++++++------------------
 2 files changed, 32 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 47255c8..b79a518 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -400,8 +400,6 @@ struct ath9k_htc_priv {
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	struct ath9k_debug debug;
 #endif
-	struct ath9k_htc_target_rate tgt_rate;
-
 	struct mutex mutex;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index cf1112b..fe5debf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -334,40 +334,35 @@ static int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
 	return ret;
 }
 
-static int ath9k_htc_init_rate(struct ath9k_htc_priv *priv,
-				 struct ieee80211_vif *vif,
-				 struct ieee80211_sta *sta)
+static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
+				 struct ieee80211_sta *sta,
+				 struct ath9k_htc_target_rate *trate)
 {
-	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
 	struct ieee80211_supported_band *sband;
-	struct ath9k_htc_target_rate trate;
 	u32 caps = 0;
-	u8 cmd_rsp;
-	int i, j, ret;
-
-	memset(&trate, 0, sizeof(trate));
+	int i, j;
 
 	/* Only 2GHz is supported */
 	sband = priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
 
 	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
-			priv->tgt_rate.rates.legacy_rates.rs_rates[j]
+			trate->rates.legacy_rates.rs_rates[j]
 				= (sband->bitrates[i].bitrate * 2) / 10;
 			j++;
 		}
 	}
-	priv->tgt_rate.rates.legacy_rates.rs_nrates = j;
+	trate->rates.legacy_rates.rs_nrates = j;
 
 	if (sta->ht_cap.ht_supported) {
 		for (i = 0, j = 0; i < 77; i++) {
 			if (sta->ht_cap.mcs.rx_mask[i/8] & (1<<(i%8)))
-				priv->tgt_rate.rates.ht_rates.rs_rates[j++] = i;
+				trate->rates.ht_rates.rs_rates[j++] = i;
 			if (j == ATH_HTC_RATE_MAX)
 				break;
 		}
-		priv->tgt_rate.rates.ht_rates.rs_nrates = j;
+		trate->rates.ht_rates.rs_nrates = j;
 
 		caps = WLAN_RC_HT_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
@@ -377,81 +372,41 @@ static int ath9k_htc_init_rate(struct ath9k_htc_priv *priv,
 
 	}
 
-	priv->tgt_rate.sta_index = ista->index;
-	priv->tgt_rate.isnew = 1;
-	trate = priv->tgt_rate;
-	priv->tgt_rate.capflags = cpu_to_be32(caps);
-	trate.capflags = cpu_to_be32(caps);
+	trate->sta_index = ista->index;
+	trate->isnew = 1;
+	trate->capflags = cpu_to_be32(caps);
+}
+
+static int ath9k_htc_send_rate_cmd(struct ath9k_htc_priv *priv,
+				    struct ath9k_htc_target_rate *trate)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	int ret;
+	u8 cmd_rsp;
 
-	WMI_CMD_BUF(WMI_RC_RATE_UPDATE_CMDID, &trate);
+	WMI_CMD_BUF(WMI_RC_RATE_UPDATE_CMDID, trate);
 	if (ret) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to initialize Rate information on target\n");
-		return ret;
 	}
 
-	ath_print(common, ATH_DBG_CONFIG,
-		  "Updated target STA: %pM (caps: 0x%x)\n", sta->addr, caps);
-	return 0;
-}
-
-static bool check_rc_update(struct ieee80211_hw *hw, bool *cw40)
-{
-	struct ath9k_htc_priv *priv = hw->priv;
-	struct ieee80211_conf *conf = &hw->conf;
-
-	if (!conf_is_ht(conf))
-		return false;
-
-	if (!(priv->op_flags & OP_ASSOCIATED) ||
-	    (priv->op_flags & OP_SCANNING))
-		return false;
-
-	if (conf_is_ht40(conf)) {
-		if (priv->ah->curchan->chanmode &
-			(CHANNEL_HT40PLUS | CHANNEL_HT40MINUS)) {
-			return false;
-		} else {
-			*cw40 = true;
-			return true;
-		}
-	} else {  /* ht20 */
-		if (priv->ah->curchan->chanmode & CHANNEL_HT20)
-			return false;
-		else
-			return true;
-	}
+	return ret;
 }
 
-static void ath9k_htc_rc_update(struct ath9k_htc_priv *priv, bool is_cw40)
+static void ath9k_htc_init_rate(struct ath9k_htc_priv *priv,
+				struct ieee80211_sta *sta)
 {
-	struct ath9k_htc_target_rate trate;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_rate trate;
 	int ret;
-	u32 caps = be32_to_cpu(priv->tgt_rate.capflags);
-	u8 cmd_rsp;
-
-	memset(&trate, 0, sizeof(trate));
-
-	trate = priv->tgt_rate;
 
-	if (is_cw40)
-		caps |= WLAN_RC_40_FLAG;
-	else
-		caps &= ~WLAN_RC_40_FLAG;
-
-	priv->tgt_rate.capflags = cpu_to_be32(caps);
-	trate.capflags = cpu_to_be32(caps);
-
-	WMI_CMD_BUF(WMI_RC_RATE_UPDATE_CMDID, &trate);
-	if (ret) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to update Rate information on target\n");
-		return;
-	}
-
-	ath_print(common, ATH_DBG_CONFIG, "Rate control updated with "
-		  "caps:0x%x on target\n", priv->tgt_rate.capflags);
+	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
+	ath9k_htc_setup_rate(priv, sta, &trate);
+	ret = ath9k_htc_send_rate_cmd(priv, &trate);
+	if (!ret)
+		ath_print(common, ATH_DBG_CONFIG,
+			  "Updated target sta: %pM, rate caps: 0x%X\n",
+			  sta->addr, be32_to_cpu(trate.capflags));
 }
 
 static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
@@ -1372,14 +1327,10 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
-		bool is_cw40 = false;
 
 		ath_print(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			  curchan->center_freq);
 
-		if (check_rc_update(hw, &is_cw40))
-			ath9k_htc_rc_update(priv, is_cw40);
-
 		ath9k_cmn_update_ichannel(hw, &priv->ah->channels[pos]);
 
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
@@ -1471,7 +1422,7 @@ static void ath9k_htc_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_ADD:
 		ret = ath9k_htc_add_station(priv, vif, sta);
 		if (!ret)
-			ath9k_htc_init_rate(priv, vif, sta);
+			ath9k_htc_init_rate(priv, sta);
 		break;
 	case STA_NOTIFY_REMOVE:
 		ath9k_htc_remove_station(priv, vif, sta);
-- 
1.7.1

