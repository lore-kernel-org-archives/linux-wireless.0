Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbXKZOVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:52 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 13/15] iwlwifi: 802.11n comply HT add station flow with mac80211 framework
Date: Mon, 26 Nov 2007 16:14:40 +0200
Message-Id: <11960864922557-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_143539_143320_95D25EC1)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
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
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 +++++++++++++++++++---
 4 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index defc392..5d37ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1728,8 +1728,8 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, hdr->addr1));
-			sta_id = iwl4965_add_station_flags(priv,
-						 hdr->addr1, 0, CMD_ASYNC);
+			sta_id = iwl4965_add_station_flags(priv, hdr->addr1,
+							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq->lq.sta_id = sta_id;
@@ -1804,8 +1804,8 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, sta->addr));
-			sta_id = iwl4965_add_station_flags(priv,
-						 sta->addr, 0, CMD_ASYNC);
+			sta_id = iwl4965_add_station_flags(priv, sta->addr,
+							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			crl->lq.sta_id = sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ea130b6..8eea5c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4444,39 +4444,33 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct iwl_ht_info *ht_info)
 	return;
 }
 
-void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index)
+void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
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
-
-	sta_flags &= (~STA_FLG_FAT_EN_MSK);
-	ht_info->tx_chan_width = IWL_CHANNEL_WIDTH_20MHZ;
-	ht_info->chan_width_cap = IWL_CHANNEL_WIDTH_20MHZ;
+	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	if (iwl4965_is_fat_tx_allowed(priv, ht_info)) {
+	if (iwl4965_is_fat_tx_allowed(priv, sta_ht_inf))
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 0200bdb..c098bb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -612,8 +612,8 @@ struct iwl4965_driver_hw_info {
 struct iwl4965_addsta_cmd;
 extern int iwl4965_send_add_station(struct iwl4965_priv *priv,
 				struct iwl4965_addsta_cmd *sta, u8 flags);
-extern u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *bssid,
-			  int is_ap, u8 flags);
+extern u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
+			  int is_ap, u8 flags, void *ht_data);
 extern int iwl4965_is_network_packet(struct iwl4965_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl4965_power_init_handle(struct iwl4965_priv *priv);
@@ -748,8 +748,6 @@ extern int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd
 			  struct ieee80211_tx_control *ctrl, void *sta_in);
 extern int iwl4965_alive_notify(struct iwl4965_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl4965_priv *priv, u8 mode);
-extern void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index);
-
 extern void iwl4965_chain_noise_reset(struct iwl4965_priv *priv);
 extern void iwl4965_init_sensitivity(struct iwl4965_priv *priv, u8 flags,
 				     u8 force);
@@ -764,6 +762,8 @@ extern void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
 					int mode);
 extern void iwl4965_set_rxon_ht(struct iwl4965_priv *priv,
 				struct iwl_ht_info *ht_info);
+extern void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
+				struct ieee80211_ht_info *sta_ht_inf);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5caeac4..f90fc73 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -455,7 +455,8 @@ static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr, int is_ap, u8 flags)
+u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
+				int is_ap, u8 flags, void *ht_data)
 {
 	int i;
 	int index = IWL_INVALID_STATION;
@@ -511,7 +512,8 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr, int is_a
 	/* BCAST station and IBSS stations do not work in HT mode */
 	if (index != priv->hw_setting.bcast_sta_id &&
 	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
-		iwl4965_set_ht_add_station(priv, index);
+		iwl4965_set_ht_add_station(priv, index,
+				 (struct ieee80211_ht_info *) ht_data);
 #endif /*CONFIG_IWL4965_HT*/
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -850,7 +852,20 @@ static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
 {
 	u8 sta_id;
 
-	sta_id = iwl4965_add_station_flags(priv, addr, is_ap, 0);
+#ifdef CONFIG_IWL4965_HT
+	struct ieee80211_conf *conf = &priv->hw->conf;
+	struct ieee80211_ht_info *cur_ht_config = &conf->ht_conf;
+
+	if ((is_ap) &&
+	    (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
+	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
+		sta_id = iwl4965_add_station_flags(priv, addr, is_ap,
+						   0, cur_ht_config);
+	else
+#endif /* CONFIG_IWL4965_HT */
+		sta_id = iwl4965_add_station_flags(priv, addr, is_ap,
+						   0, NULL);
+
 	iwl4965_add_station(priv, addr, is_ap);
 
 	return sta_id;
@@ -2772,7 +2787,8 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv, struct ieee80211_hdr *h
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		sta_id = iwl4965_add_station_flags(priv, hdr->addr1, 0, CMD_ASYNC);
+		sta_id = iwl4965_add_station_flags(priv, hdr->addr1,
+						   0, CMD_ASYNC, NULL);
 
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
