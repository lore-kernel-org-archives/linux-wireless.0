Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbXKIICT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:19 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 12/14] iwlwifi: 802.11n comply HT add station flow with mac80211 framework
Date: Fri,  9 Nov 2007 10:02:04 +0200
Message-Id: <1194595332156-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_080231_496194_F7406620)
In-Reply-To: <1194595332187-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
 <11945953313626-git-send-email-ron.rindjunsky@intel.com>
 <11945953311042-git-send-email-ron.rindjunsky@intel.com>
 <1194595331715-git-send-email-ron.rindjunsky@intel.com>
 <1194595332620-git-send-email-ron.rindjunsky@intel.com>
 <1194595332187-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch conforms the addition of a new station to the iwlwifi station
table according to the new mac80211's HT framework

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    8 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   28 ++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    8 +++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   25 ++++++++++++++++++++---
 4 files changed, 40 insertions(+), 29 deletions(-)

Index: wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
===================================================================
--- wl2_6_24_HT.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1725,8 +1725,8 @@ static struct ieee80211_rate *rs_get_rat
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, hdr->addr1));
-			sta_id = iwl_add_station(priv,
-						 hdr->addr1, 0, CMD_ASYNC);
+			sta_id = iwl_add_station(priv, hdr->addr1,
+						 0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq->lq.sta_id = sta_id;
@@ -1801,8 +1801,8 @@ static void rs_rate_init(void *priv_rate
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, sta->addr));
-			sta_id = iwl_add_station(priv,
-						 sta->addr, 0, CMD_ASYNC);
+			sta_id = iwl_add_station(priv, sta->addr,
+						 0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			crl->lq.sta_id = sta_id;
Index: wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- wl2_6_24_HT.orig/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4444,39 +4444,33 @@ void iwl4965_set_rxon_ht(struct iwl_priv
 	return;
 }
 
-void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index)
+void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
+				struct ieee80211_ht_info *sta_ht_inf)
 {
 	__le32 sta_flags;
-	struct sta_ht_info *ht_info = &priv->current_assoc_ht;
 
-	priv->current_channel_width = IWL_CHANNEL_WIDTH_20MHZ;
-	if (!ht_info->is_ht)
+	if (!sta_ht_inf || !sta_ht_inf->ht_supported)
 		goto done;
 
 	sta_flags = priv->stations[index].sta.station_flags;
 
-	if (ht_info->tx_mimo_ps_mode == IWL_MIMO_PS_DYNAMIC)
+	if (((sta_ht_inf->cap & IEEE80211_HT_CAP_MIMO_PS >> 2))
+						== IWL_MIMO_PS_DYNAMIC)
 		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
 	else
 		sta_flags &= ~STA_FLG_RTS_MIMO_PROT_MSK;
 
 	sta_flags |= cpu_to_le32(
-		(u32)ht_info->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
+	      (u32)sta_ht_inf->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
 
 	sta_flags |= cpu_to_le32(
-		(u32)ht_info->mpdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
+	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	sta_flags &= (~STA_FLG_FAT_EN_MSK);
-	ht_info->tx_chan_width = IWL_CHANNEL_WIDTH_20MHZ;
-	ht_info->chan_width_cap = IWL_CHANNEL_WIDTH_20MHZ;
-
-	if (iwl_is_fat_tx_allowed(priv, ht_info)) {
+	if (iwl_is_fat_tx_allowed(priv, sta_ht_inf))
 		sta_flags |= STA_FLG_FAT_EN_MSK;
-		ht_info->chan_width_cap = IWL_CHANNEL_WIDTH_40MHZ;
-		if (ht_info->supported_chan_width == IWL_CHANNEL_WIDTH_40MHZ)
-			ht_info->tx_chan_width = IWL_CHANNEL_WIDTH_40MHZ;
-	}
-	priv->current_channel_width = ht_info->tx_chan_width;
+	else
+		sta_flags &= (~STA_FLG_FAT_EN_MSK);
+
 	priv->stations[index].sta.station_flags = sta_flags;
  done:
 	return;
Index: wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- wl2_6_24_HT.orig/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -612,8 +612,8 @@ struct iwl_driver_hw_info {
 struct iwl_addsta_cmd;
 extern int iwl_send_add_station(struct iwl_priv *priv,
 				struct iwl_addsta_cmd *sta, u8 flags);
-extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
-			  int is_ap, u8 flags);
+extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr,
+			  int is_ap, u8 flags, void *ht_data);
 extern int iwl_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl_power_init_handle(struct iwl_priv *priv);
@@ -749,8 +749,6 @@ extern int iwl4965_tx_cmd(struct iwl_pri
 			  struct ieee80211_tx_control *ctrl, void *sta_in);
 extern int iwl4965_alive_notify(struct iwl_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
-extern void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index);
-
 extern void iwl4965_chain_noise_reset(struct iwl_priv *priv);
 extern void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags,
 				     u8 force);
@@ -765,6 +763,8 @@ extern void iwl4965_init_ht_hw_capab(str
 					int mode);
 extern void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 				struct iwl_ht_info *ht_info);
+extern void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
+		struct ieee80211_ht_info *sta_ht_inf);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
Index: wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- wl2_6_24_HT.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ wl2_6_24_HT/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -456,7 +456,8 @@ static void iwl_clear_stations_table(str
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
+u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr,
+			int is_ap, u8 flags, void *ht_data)
 {
 	int i;
 	int index = IWL_INVALID_STATION;
@@ -512,7 +513,8 @@ u8 iwl_add_station(struct iwl_priv *priv
 	/* BCAST station and IBSS stations do not work in HT mode */
 	if (index != priv->hw_setting.bcast_sta_id &&
 	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
-		iwl4965_set_ht_add_station(priv, index);
+		iwl4965_set_ht_add_station(priv, index,
+				 (struct ieee80211_ht_info *) ht_data);
 #endif /*CONFIG_IWL4965_HT*/
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -851,7 +853,22 @@ static int iwl_rxon_add_station(struct i
 {
 	u8 sta_id;
 
-	sta_id = iwl_add_station(priv, addr, is_ap, 0);
+	/* TODO - consider checking if mac80211 will allow
+	 * to query its station table - will help here */
+#ifdef CONFIG_IWL4965_HT
+	struct ieee80211_conf *conf = &priv->hw->conf;
+	struct ieee80211_ht_info *cur_ht_config = &conf->ht_conf;
+
+	if ((is_ap) &&
+	    (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
+	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
+		sta_id = iwl_add_station(priv, addr, is_ap,
+					0, cur_ht_config);
+	else
+#endif /* CONFIG_IWL4965_HT */
+		sta_id = iwl_add_station(priv, addr, is_ap,
+					 0, NULL);
+
 	iwl4965_add_station(priv, addr, is_ap);
 
 	return sta_id;
@@ -2773,7 +2790,7 @@ static int iwl_get_sta_id(struct iwl_pri
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		sta_id = iwl_add_station(priv, hdr->addr1, 0, CMD_ASYNC);
+		sta_id = iwl_add_station(priv, hdr->addr1, 0, CMD_ASYNC, NULL);
 
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
