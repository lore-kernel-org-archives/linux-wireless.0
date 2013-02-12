Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3BLNZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 08:25:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: stop modifying HT SMPS capability
Date: Tue, 12 Feb 2013 14:25:52 +0100
Message-Id: <1360675552-29511-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_142603_624993_5F6F6E47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of modifying the HT SMPS capability field
for stations, track the SMPS mode explicitly in a
new field in the station struct and use it in the
drivers that care about it. This simplifies the
code using it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c   |  3 +--
 drivers/net/wireless/iwlegacy/common.c    | 16 +++++++---------
 drivers/net/wireless/iwlwifi/dvm/rs.c     |  6 ++----
 drivers/net/wireless/iwlwifi/dvm/sta.c    | 17 +++++++----------
 drivers/net/wireless/iwlwifi/mvm/rs.c     |  6 ++----
 drivers/net/wireless/rt2x00/rt2x00queue.c |  5 +----
 include/net/mac80211.h                    |  2 ++
 net/mac80211/ht.c                         | 19 +++++++++++++++++++
 net/mac80211/rc80211_minstrel_ht.c        |  6 +-----
 net/mac80211/rx.c                         | 16 ++++++----------
 net/mac80211/sta_info.c                   |  2 ++
 11 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index f3b8e91..e8324b5 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -1183,8 +1183,7 @@ il4965_rs_switch_to_mimo2(struct il_priv *il, struct il_lq_sta *lq_sta,
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
-	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2) ==
-	    WLAN_HT_CAP_SM_PS_STATIC)
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 1f59860..4c9aafb 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1830,32 +1830,30 @@ il_set_ht_add_station(struct il_priv *il, u8 idx, struct ieee80211_sta *sta)
 {
 	struct ieee80211_sta_ht_cap *sta_ht_inf = &sta->ht_cap;
 	__le32 sta_flags;
-	u8 mimo_ps_mode;
 
 	if (!sta || !sta_ht_inf->ht_supported)
 		goto done;
 
-	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
 	D_ASSOC("spatial multiplexing power save mode: %s\n",
-		(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ? "static" :
-		(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ? "dynamic" :
+		(sta->smps_mode == IEEE80211_SMPS_STATIC) ? "static" :
+		(sta->smps_mode == IEEE80211_SMPS_DYNAMIC) ? "dynamic" :
 		"disabled");
 
 	sta_flags = il->stations[idx].sta.station_flags;
 
 	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
 
-	switch (mimo_ps_mode) {
-	case WLAN_HT_CAP_SM_PS_STATIC:
+	switch (sta->smps_mode) {
+	case IEEE80211_SMPS_STATIC:
 		sta_flags |= STA_FLG_MIMO_DIS_MSK;
 		break;
-	case WLAN_HT_CAP_SM_PS_DYNAMIC:
+	case IEEE80211_SMPS_DYNAMIC:
 		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
 		break;
-	case WLAN_HT_CAP_SM_PS_DISABLED:
+	case IEEE80211_SMPS_OFF:
 		break;
 	default:
-		IL_WARN("Invalid MIMO PS mode %d\n", mimo_ps_mode);
+		IL_WARN("Invalid MIMO PS mode %d\n", sta->smps_mode);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index b25de02..abe3042 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -1289,8 +1289,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
-	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
-						== WLAN_HT_CAP_SM_PS_STATIC)
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
@@ -1345,8 +1344,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
-	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
-						== WLAN_HT_CAP_SM_PS_STATIC)
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 6deab38..d5faf74 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -196,7 +196,6 @@ static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
 				  __le32 *flags, __le32 *mask)
 {
 	struct ieee80211_sta_ht_cap *sta_ht_inf = &sta->ht_cap;
-	u8 mimo_ps_mode;
 
 	*mask = STA_FLG_RTS_MIMO_PROT_MSK |
 		STA_FLG_MIMO_DIS_MSK |
@@ -208,26 +207,24 @@ static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
 	if (!sta || !sta_ht_inf->ht_supported)
 		return;
 
-	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
-
 	IWL_DEBUG_INFO(priv, "STA %pM SM PS mode: %s\n",
 			sta->addr,
-			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ?
+			(sta->smps_mode == IEEE80211_SMPS_STATIC) ?
 			"static" :
-			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?
+			(sta->smps_mode == IEEE80211_SMPS_DYNAMIC) ?
 			"dynamic" : "disabled");
 
-	switch (mimo_ps_mode) {
-	case WLAN_HT_CAP_SM_PS_STATIC:
+	switch (sta->smps_mode) {
+	case IEEE80211_SMPS_STATIC:
 		*flags |= STA_FLG_MIMO_DIS_MSK;
 		break;
-	case WLAN_HT_CAP_SM_PS_DYNAMIC:
+	case IEEE80211_SMPS_DYNAMIC:
 		*flags |= STA_FLG_RTS_MIMO_PROT_MSK;
 		break;
-	case WLAN_HT_CAP_SM_PS_DISABLED:
+	case IEEE80211_SMPS_OFF:
 		break;
 	default:
-		IWL_WARN(priv, "Invalid MIMO PS mode %d\n", mimo_ps_mode);
+		IWL_WARN(priv, "Invalid MIMO PS mode %d\n", sta->smps_mode);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 8ba36e5..56b636d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1229,8 +1229,7 @@ static int rs_switch_to_mimo2(struct iwl_mvm *mvm,
 	if (!sta->ht_cap.ht_supported)
 		return -1;
 
-	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
-						== WLAN_HT_CAP_SM_PS_STATIC)
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
@@ -1282,8 +1281,7 @@ static int rs_switch_to_mimo3(struct iwl_mvm *mvm,
 	if (!sta->ht_cap.ht_supported)
 		return -1;
 
-	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
-						== WLAN_HT_CAP_SM_PS_STATIC)
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f35d85a..9503e69 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -343,10 +343,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		 * when using more then one tx stream (>MCS7).
 		 */
 		if (sta && txdesc->u.ht.mcs > 7 &&
-		    ((sta->ht_cap.cap &
-		      IEEE80211_HT_CAP_SM_PS) >>
-		     IEEE80211_HT_CAP_SM_PS_SHIFT) ==
-		    WLAN_HT_CAP_SM_PS_DYNAMIC)
+		    sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
 			__set_bit(ENTRY_TXD_HT_MIMO_PS, &txdesc->flags);
 	} else {
 		txdesc->u.ht.mcs = rt2x00_get_rate_mcs(hwrate->mcs);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 70f3806..cf2e014 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1238,6 +1238,7 @@ enum ieee80211_sta_rx_bandwidth {
  *	station can receive at the moment, changed by operating mode
  *	notifications and capabilities. The value is only valid after
  *	the station moves to associated state.
+ * @smps_mode: current SMPS mode (off, static or dynamic)
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1250,6 +1251,7 @@ struct ieee80211_sta {
 	u8 max_sp;
 	u8 rx_nss;
 	enum ieee80211_sta_rx_bandwidth bandwidth;
+	enum ieee80211_smps_mode smps_mode;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 797969b..c7434ee 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -102,6 +102,7 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	int i, max_tx_streams;
 	bool changed;
 	enum ieee80211_sta_rx_bandwidth bw;
+	enum ieee80211_smps_mode smps_mode;
 
 	memset(&ht_cap, 0, sizeof(ht_cap));
 
@@ -216,6 +217,24 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
 				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
 
+	switch ((ht_cap.cap & IEEE80211_HT_CAP_SM_PS)
+			>> IEEE80211_HT_CAP_SM_PS_SHIFT) {
+	case WLAN_HT_CAP_SM_PS_INVALID:
+	case WLAN_HT_CAP_SM_PS_STATIC:
+		smps_mode = IEEE80211_SMPS_STATIC;
+		break;
+	case WLAN_HT_CAP_SM_PS_DYNAMIC:
+		smps_mode = IEEE80211_SMPS_DYNAMIC;
+		break;
+	case WLAN_HT_CAP_SM_PS_DISABLED:
+		smps_mode = IEEE80211_SMPS_OFF;
+		break;
+	}
+
+	if (smps_mode != sta->sta.smps_mode)
+		changed = true;
+	sta->sta.smps_mode = smps_mode;
+
 	return changed;
 }
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 732df88..9e7c328 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -695,7 +695,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	int ack_dur;
 	int stbc;
 	int i;
-	unsigned int smps;
 
 	/* fall back to the old minstrel for legacy stations */
 	if (!sta->ht_cap.ht_supported)
@@ -731,9 +730,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
 		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
 
-	smps = (sta_cap & IEEE80211_HT_CAP_SM_PS) >>
-		IEEE80211_HT_CAP_SM_PS_SHIFT;
-
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
 		mi->groups[i].supported = 0;
 		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_SHORT_GI) {
@@ -751,7 +747,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 			continue;
 
 		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
-		if (smps == WLAN_HT_CAP_SM_PS_STATIC &&
+		if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
 		    minstrel_mcs_groups[i].streams > 1)
 			continue;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 30f1ba6..68a9e9c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2375,31 +2375,27 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		switch (mgmt->u.action.u.ht_smps.action) {
 		case WLAN_HT_ACTION_SMPS: {
 			struct ieee80211_supported_band *sband;
-			u8 smps;
+			enum ieee80211_smps_mode smps_mode;
 
 			/* convert to HT capability */
 			switch (mgmt->u.action.u.ht_smps.smps_control) {
 			case WLAN_HT_SMPS_CONTROL_DISABLED:
-				smps = WLAN_HT_CAP_SM_PS_DISABLED;
+				smps_mode = IEEE80211_SMPS_OFF;
 				break;
 			case WLAN_HT_SMPS_CONTROL_STATIC:
-				smps = WLAN_HT_CAP_SM_PS_STATIC;
+				smps_mode = IEEE80211_SMPS_STATIC;
 				break;
 			case WLAN_HT_SMPS_CONTROL_DYNAMIC:
-				smps = WLAN_HT_CAP_SM_PS_DYNAMIC;
+				smps_mode = IEEE80211_SMPS_DYNAMIC;
 				break;
 			default:
 				goto invalid;
 			}
-			smps <<= IEEE80211_HT_CAP_SM_PS_SHIFT;
 
 			/* if no change do nothing */
-			if ((rx->sta->sta.ht_cap.cap &
-					IEEE80211_HT_CAP_SM_PS) == smps)
+			if (rx->sta->sta.smps_mode == smps_mode)
 				goto handled;
-
-			rx->sta->sta.ht_cap.cap &= ~IEEE80211_HT_CAP_SM_PS;
-			rx->sta->sta.ht_cap.cap |= smps;
+			rx->sta->sta.smps_mode = smps_mode;
 
 			sband = rx->local->hw.wiphy->bands[status->band];
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 19db20a..07b312e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -375,6 +375,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
+	sta->sta.smps_mode = IEEE80211_SMPS_OFF;
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
-- 
1.8.0

