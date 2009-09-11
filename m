Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11274 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721AbZIKRiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/13] iwlwifi: clarify and clean up chain settings
Date: Fri, 11 Sep 2009 10:38:17 -0700
Message-Id: <1252690699-25796-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The chain settings we currently use in iwlwifi are
rather confusing -- and we also go by the wrong
settings entirely under certain circumstances. To
clean it up, create a new variable in the current
HT config -- single_chain_sufficient -- that tells
us whether we need more than one chain. Calculate
that based on the AP and operating mode (no IBSS
HT implemented -- so no need for multiple chains,
for station mode we use the AP's capabilities).

Additionally, since APs always send disabled SM PS
mode, keeping track of their sm_ps mode isn't very
useful -- doubly not so for our _own_ RX config
since that should depend on our, not the AP's, SM
PS mode.

Finally, document that our configuration of the
number of RX chains used is currently wrong when
in powersave (by adding a comment).

All together this removes the two remaining items
in struct iwl_ht_config that were done wrong there.

For the future, the number of RX chains and some
SM PS handshaking needs to be added to mac80211,
which then needs to tell us, and the new variable
current_ht_config.single_chain_sufficient should
also be calculated by mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |  105 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 +-
 2 files changed, 51 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d9a757a..5c6cee2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -607,8 +607,7 @@ EXPORT_SYMBOL(iwlcore_free_geos);
 static bool is_single_rx_stream(struct iwl_priv *priv)
 {
 	return !priv->current_ht_config.is_ht ||
-	       ((priv->current_ht_config.mcs.rx_mask[1] == 0) &&
-		(priv->current_ht_config.mcs.rx_mask[2] == 0));
+	       priv->current_ht_config.single_chain_sufficient;
 }
 
 static u8 iwl_is_channel_extension(struct iwl_priv *priv,
@@ -936,12 +935,8 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
-	IWL_DEBUG_ASSOC(priv, "supported HT rate 0x%X 0x%X 0x%X "
-			"rxon flags 0x%X operation mode :0x%X "
+	IWL_DEBUG_ASSOC(priv, "rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
-			ht_conf->mcs.rx_mask[0],
-			ht_conf->mcs.rx_mask[1],
-			ht_conf->mcs.rx_mask[2],
 			le32_to_cpu(rxon->flags), ht_conf->ht_protection,
 			ht_conf->extension_chan_offset);
 	return;
@@ -960,12 +955,8 @@ EXPORT_SYMBOL(iwl_set_rxon_ht);
  */
 static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
-	bool is_single = is_single_rx_stream(priv);
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
-
 	/* # of Rx chains to use when expecting MIMO. */
-	if (is_single || (!is_cam && (priv->current_ht_config.sm_ps ==
-						 WLAN_HT_CAP_SM_PS_STATIC)))
+	if (is_single_rx_stream(priv))
 		return IWL_NUM_RX_CHAINS_SINGLE;
 	else
 		return IWL_NUM_RX_CHAINS_MULTIPLE;
@@ -973,27 +964,17 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 
 static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 {
-	int idle_cnt;
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
+
 	/* # Rx chains when idling and maybe trying to save power */
-	switch (priv->current_ht_config.sm_ps) {
-	case WLAN_HT_CAP_SM_PS_STATIC:
-	case WLAN_HT_CAP_SM_PS_DYNAMIC:
-		idle_cnt = (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
-					IWL_NUM_IDLE_CHAINS_SINGLE;
-		break;
-	case WLAN_HT_CAP_SM_PS_DISABLED:
-		idle_cnt = (is_cam) ? active_cnt : IWL_NUM_IDLE_CHAINS_SINGLE;
-		break;
-	case WLAN_HT_CAP_SM_PS_INVALID:
-	default:
-		IWL_ERR(priv, "invalid mimo ps mode %d\n",
-			   priv->current_ht_config.sm_ps);
-		WARN_ON(1);
-		idle_cnt = -1;
-		break;
-	}
-	return idle_cnt;
+
+	/*
+	 * XXX: this is incorrect!!
+	 *	we always indicate to the AP that
+	 *	our SM PS mode is "disabled"
+	 */
+
+	return is_cam ? active_cnt : IWL_NUM_IDLE_CHAINS_SINGLE;
 }
 
 /* up to 4 chains */
@@ -1673,8 +1654,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 
-	priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
-
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
@@ -2406,10 +2385,9 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 EXPORT_SYMBOL(iwl_mac_conf_tx);
 
 static void iwl_ht_conf(struct iwl_priv *priv,
-			    struct ieee80211_bss_conf *bss_conf)
+			struct ieee80211_bss_conf *bss_conf)
 {
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
-	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta *sta;
 
 	IWL_DEBUG_MAC80211(priv, "enter: \n");
@@ -2417,31 +2395,48 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	if (!ht_conf->is_ht)
 		return;
 
-
-	/*
-	 * It is totally wrong to base global information on something
-	 * that is valid only when associated, alas, this driver works
-	 * that way and I don't know how to fix it.
-	 */
-
-	rcu_read_lock();
-	sta = ieee80211_find_sta(priv->hw, priv->bssid);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-	ht_cap = &sta->ht_cap;
-
-	ht_conf->sm_ps = (u8)((ht_cap->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
-
-	memcpy(&ht_conf->mcs, &ht_cap->mcs, 16);
-
 	ht_conf->ht_protection =
 		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	ht_conf->non_GF_STA_present =
 		!!(bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 
-	rcu_read_unlock();
+	ht_conf->single_chain_sufficient = false;
+
+	switch (priv->iw_mode) {
+	case NL80211_IFTYPE_STATION:
+		rcu_read_lock();
+		sta = ieee80211_find_sta(priv->hw, priv->bssid);
+		if (sta) {
+			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
+			int maxstreams;
+
+			maxstreams = (ht_cap->mcs.tx_params &
+				      IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
+					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
+			maxstreams += 1;
+
+			if ((ht_cap->mcs.rx_mask[1] == 0) &&
+			    (ht_cap->mcs.rx_mask[2] == 0))
+				ht_conf->single_chain_sufficient = true;
+			if (maxstreams <= 1)
+				ht_conf->single_chain_sufficient = true;
+		} else {
+			/*
+			 * If at all, this can only happen through a race
+			 * when the AP disconnects us while we're still
+			 * setting up the connection, in that case mac80211
+			 * will soon tell us about that.
+			 */
+			ht_conf->single_chain_sufficient = true;
+		}
+		rcu_read_unlock();
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		ht_conf->single_chain_sufficient = true;
+		break;
+	default:
+		break;
+	}
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e161f8d..0c80692 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -506,8 +506,7 @@ struct iwl_ht_config {
 	/* self configuration data */
 	bool is_ht;
 	bool is_40mhz;
-	u8 sm_ps;
-	struct ieee80211_mcs_info mcs;
+	bool single_chain_sufficient;
 	/* BSS related data */
 	u8 extension_chan_offset;
 	u8 ht_protection;
-- 
1.5.6.3

