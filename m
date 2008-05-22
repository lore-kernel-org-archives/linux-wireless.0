Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760456AbYEVJMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 05:12:19 -0400
Subject: [RFA] iwl4965: support mesh networking
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 11:11:22 +0200
Message-Id: <1211447482.3698.50.camel@johannes.berg> (sfid-20080522_111237_247060_1EC83EF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This tries to make iwl4965 support mesh, but it doesn't actually work.

Here's my s-o-b so anyone else can try to make it work, I haven't
figured out yet what the bug is...

It seems that the iwlwifi card doesn't beacon, so the mesh state machine
gets stuck.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   10 +++++++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   17 ++++++++++++-----
 4 files changed, 27 insertions(+), 12 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-22 10:42:27.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-22 10:44:59.000000000 +0200
@@ -584,7 +584,8 @@ unsigned int iwl4965_fill_beacon_frame(s
 
 	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
 	    ((priv->iw_mode != IEEE80211_IF_TYPE_IBSS) &&
-	     (priv->iw_mode != IEEE80211_IF_TYPE_AP)))
+	     (priv->iw_mode != IEEE80211_IF_TYPE_AP) &&
+	     (priv->iw_mode != IEEE80211_IF_TYPE_MESH_POINT)))
 		return 0;
 
 	if (priv->ibss_beacon->len > left)
@@ -1158,6 +1159,7 @@ static void iwl4965_connection_init_rx_c
 		break;
 
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
 		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
@@ -1193,7 +1195,8 @@ static void iwl4965_connection_init_rx_c
 	 * in some case A channels are all non IBSS
 	 * in this case force B/G channel
 	 */
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	     priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT) &&
 	    !(is_channel_ibss(ch_info)))
 		ch_info = &priv->channel_info[0];
 
@@ -1218,7 +1221,8 @@ static void iwl4965_connection_init_rx_c
 
 static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 {
-	if (mode == IEEE80211_IF_TYPE_IBSS) {
+	if (mode == IEEE80211_IF_TYPE_IBSS ||
+	    mode == IEEE80211_IF_TYPE_MESH_POINT) {
 		const struct iwl_channel_info *ch_info;
 
 		ch_info = iwl_get_channel_info(priv,
@@ -3947,6 +3951,7 @@ static void iwl4965_post_associate(struc
 		break;
 
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 
 		/* clear out the station table */
 		iwlcore_clear_stations_table(priv);
@@ -3970,7 +3975,8 @@ static void iwl4965_post_associate(struc
 	iwl_chain_noise_reset(priv);
 	priv->start_calib = 1;
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	    priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT)
 		priv->assoc_station_added = 1;
 
 	iwl4965_activate_qos(priv, 0);
@@ -4960,7 +4966,8 @@ static int iwl4965_mac_beacon_update(str
 		return -EIO;
 	}
 
-	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS &&
+	    priv->iw_mode != IEEE80211_IF_TYPE_MESH_POINT) {
 		IWL_DEBUG_MAC80211("leave - not IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2008-05-22 10:42:27.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-sta.c	2008-05-22 10:44:59.000000000 +0200
@@ -46,7 +46,8 @@ u8 iwl_find_station(struct iwl_priv *pri
 	DECLARE_MAC_BUF(mac);
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) ||
-	    (priv->iw_mode == IEEE80211_IF_TYPE_AP))
+	    (priv->iw_mode == IEEE80211_IF_TYPE_AP) ||
+	    (priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT))
 		start = IWL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
@@ -229,7 +230,8 @@ u8 iwl_add_station_flags(struct iwl_priv
 
 	/* BCAST station and IBSS stations do not work in HT mode */
 	if (index != priv->hw_params.bcast_sta_id &&
-	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
+	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS &&
+	    priv->iw_mode != IEEE80211_IF_TYPE_MESH_POINT)
 		iwl_set_ht_add_station(priv, index, ht_info);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -575,7 +577,8 @@ int iwl_send_lq_cmd(struct iwl_priv *pri
 	};
 
 	if ((lq->sta_id == 0xFF) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
+	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	     priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT))
 		return -EINVAL;
 
 	if (lq->sta_id == 0xFF)
@@ -712,6 +715,7 @@ int iwl_get_sta_id(struct iwl_priv *priv
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-05-22 10:42:27.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-05-22 10:44:59.000000000 +0200
@@ -835,7 +835,8 @@ static void rs_tx_status(void *priv_rate
 	if (!priv->lq_mngr.lq_ready)
 		goto out;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	     priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT) &&
 	    !lq_sta->ibss_sta_added)
 		goto out;
 
@@ -2088,7 +2089,8 @@ static void rs_initialize_lq(struct iwl_
 	i = sta->last_txrate_idx;
 
 	if ((lq_sta->lq.sta_id == 0xff) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
+	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	     priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT))
 		goto out;
 
 	valid_tx_ant = priv->hw_params.valid_tx_ant;
@@ -2158,7 +2160,8 @@ static void rs_get_rate(void *priv_rate,
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 	i = sta->last_txrate_idx;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	     priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT) &&
 	    !lq_sta->ibss_sta_added) {
 		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 		DECLARE_MAC_BUF(mac);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-05-22 10:42:27.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-05-22 10:44:59.000000000 +0200
@@ -245,7 +245,8 @@ void iwl_reset_qos(struct iwl_priv *priv
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->qos_data.qos_active = 0;
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS ||
+	    priv->iw_mode == IEEE80211_IF_TYPE_MESH_POINT) {
 		if (priv->qos_data.qos_enable)
 			priv->qos_data.qos_active = 1;
 		if (!(priv->active_rate & 0xfff0)) {


