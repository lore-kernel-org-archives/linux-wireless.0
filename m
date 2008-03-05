Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13213 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbYCECKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/11] iwlwifi: use mac80211_tx_control_flags
Date: Tue,  4 Mar 2008 18:09:27 -0800
Message-Id: <1204682972-26004-7-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021040_908718_977D4204)
In-Reply-To: <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch makes use of the new mac80211_tx_control_flags and tx_rate to
pass Tx data, regular and 11n, from the HW tx response into the rate scaling.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   50 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   34 ++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    3 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    9 +++--
 4 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index cf7b569..306fbdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -823,6 +823,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = local_to_hw(local);
 	struct iwl4965_rate_scale_data *window = NULL;
 	struct iwl4965_rate_scale_data *search_win = NULL;
 	struct iwl4965_rate tx_mcs;
@@ -884,17 +885,6 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	search_win = (struct iwl4965_rate_scale_data *)
 	    &(search_tbl->win[0]);
 
-	tx_mcs.rate_n_flags = tx_resp->control.tx_rate->hw_value;
-
-	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band,
-				  &tbl_type, &rs_index);
-	if ((rs_index < 0) || (rs_index >= IWL_RATE_COUNT)) {
-		IWL_DEBUG_RATE("bad rate index at: %d rate 0x%X\n",
-			     rs_index, tx_mcs.rate_n_flags);
-		rcu_read_unlock();
-		return;
-	}
-
 	/*
 	 * Ignore this Tx frame response if its initial rate doesn't match
 	 * that of latest Link Quality command.  There may be stragglers
@@ -903,12 +893,28 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	 * to check "search" mode, or a prior "search" mode after we've moved
 	 * to a new "search" mode (which might become the new "active" mode).
 	 */
-	if (retries &&
-	    (tx_mcs.rate_n_flags !=
-				le32_to_cpu(table->rs_table[0].rate_n_flags))) {
-		IWL_DEBUG_RATE("initial rate does not match 0x%x 0x%x\n",
-				tx_mcs.rate_n_flags,
-				le32_to_cpu(table->rs_table[0].rate_n_flags));
+	tx_mcs.rate_n_flags = le32_to_cpu(table->rs_table[0].rate_n_flags);
+	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band, &tbl_type, &rs_index);
+	if (priv->band == IEEE80211_BAND_5GHZ)
+		rs_index -= IWL_FIRST_OFDM_RATE;
+
+	if ((tx_resp->control.tx_rate == NULL) ||
+	    (tbl_type.is_SGI ^
+		!!(tx_resp->control.flags & IEEE80211_TXCTL_SHORT_GI)) ||
+	    (tbl_type.is_fat ^
+		!!(tx_resp->control.flags & IEEE80211_TXCTL_40_MHZ_WIDTH)) ||
+	    (tbl_type.is_dup ^
+		!!(tx_resp->control.flags & IEEE80211_TXCTL_DUP_DATA)) ||
+	    (tbl_type.antenna_type ^
+		tx_resp->control.antenna_sel_tx) ||
+	    (!!(tx_mcs.rate_n_flags & RATE_MCS_HT_MSK) ^
+		!!(tx_resp->control.flags & IEEE80211_TXCTL_OFDM_HT)) ||
+	    (!!(tx_mcs.rate_n_flags & RATE_MCS_GF_MSK) ^
+		!!(tx_resp->control.flags & IEEE80211_TXCTL_GREEN_FIELD)) ||
+	    (hw->wiphy->bands[priv->band]->bitrates[rs_index].bitrate !=
+		tx_resp->control.tx_rate->bitrate)) {
+		IWL_DEBUG_RATE("initial rate does not match 0x%x\n",
+				tx_mcs.rate_n_flags);
 		rcu_read_unlock();
 		return;
 	}
@@ -959,14 +965,8 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	 * if Tx was successful first try, use original rate,
 	 * else look up the rate that was, finally, successful.
 	 */
-	if (!tx_resp->retry_count)
-		tx_mcs.rate_n_flags = tx_resp->control.tx_rate->hw_value;
-	else
-		tx_mcs.rate_n_flags =
-			le32_to_cpu(table->rs_table[index].rate_n_flags);
-
-	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band,
-				  &tbl_type, &rs_index);
+	tx_mcs.rate_n_flags = le32_to_cpu(table->rs_table[index].rate_n_flags);
+	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band, &tbl_type, &rs_index);
 
 	/* Update frame history window with "success" if Tx got ACKed ... */
 	if (tx_resp->flags & IEEE80211_TX_STATUS_ACK)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index bb8f002..05ad5a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -150,6 +150,35 @@ int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 	return -1;
 }
 
+/**
+ * translate ucode response to mac80211 tx status control values
+ */
+void iwl4965_hwrate_to_tx_control(struct iwl4965_priv *priv, u32 rate_n_flags,
+				  struct ieee80211_tx_control *control)
+{
+	int rate_index;
+
+	control->antenna_sel_tx =
+		((rate_n_flags & RATE_MCS_ANT_AB_MSK) >> RATE_MCS_ANT_A_POS);
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		control->flags |= IEEE80211_TXCTL_OFDM_HT;
+	if (rate_n_flags & RATE_MCS_GF_MSK)
+		control->flags |= IEEE80211_TXCTL_GREEN_FIELD;
+	if (rate_n_flags & RATE_MCS_FAT_MSK)
+		control->flags |= IEEE80211_TXCTL_40_MHZ_WIDTH;
+	if (rate_n_flags & RATE_MCS_DUP_MSK)
+		control->flags |= IEEE80211_TXCTL_DUP_DATA;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		control->flags |= IEEE80211_TXCTL_SHORT_GI;
+	/* since iwl4965_hwrate_to_plcp_idx is band indifferent, we always use
+	 * IEEE80211_BAND_2GHZ band as it contains all the rates */
+	rate_index = iwl4965_hwrate_to_plcp_idx(rate_n_flags);
+	if (rate_index == -1)
+		control->tx_rate = NULL;
+	else
+		control->tx_rate =
+			&priv->bands[IEEE80211_BAND_2GHZ].bitrates[rate_index];
+}
 
 /*
  * Determine how many receiver/antenna chains to use.
@@ -4084,9 +4113,8 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 	tx_status->flags |= IEEE80211_TX_STATUS_AMPDU;
 	tx_status->ampdu_ack_map = successes;
 	tx_status->ampdu_ack_len = agg->frame_count;
-	/* FIXME Wrong rate
-	tx_status->control.tx_rate = agg->rate_n_flags;
-	*/
+	iwl4965_hwrate_to_tx_control(priv, agg->rate_n_flags,
+				     &tx_status->control);
 
 	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", bitmap);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index de79816..5c60512 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -757,6 +757,9 @@ extern int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
 				const struct iwl4965_eeprom_channel *eeprom_ch,
 				u8 fat_extension_channel);
 extern void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv);
+extern void iwl4965_hwrate_to_tx_control(struct iwl4965_priv *priv,
+					 u32 rate_n_flags,
+					 struct ieee80211_tx_control *control);
 
 #ifdef CONFIG_IWL4965_HT
 void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index b0f6044..f273395 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3410,9 +3410,9 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
 		tx_status->flags = iwl4965_is_tx_success(status)?
 			IEEE80211_TX_STATUS_ACK : 0;
-		/* FIXME Wrong Rate
-		tx_status->control.tx_rate =
-				iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags); */
+		iwl4965_hwrate_to_tx_control(priv,
+					     le32_to_cpu(tx_resp->rate_n_flags),
+					     &tx_status->control);
 		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
@@ -3569,9 +3569,10 @@ static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
 	tx_status->queue_number = status;
 	tx_status->queue_length = tx_resp->bt_kill_count;
 	tx_status->queue_length |= tx_resp->failure_rts;
-
 	tx_status->flags =
 	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
+	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
+				     &tx_status->control);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
 		     "retries %d\n", txq_id, iwl4965_get_tx_fail_reason(status),
-- 
1.5.3.4

