Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaIJLLS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:11:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] mac80211: replace SMPS hw flags with wiphy feature bits
Date: Wed, 10 Sep 2014 14:07:36 +0300
Message-Id: <1410347256-9324-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_131122_156262_05B1C705)
In-Reply-To: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Use the new static_smps / dynamic_smps feature bits
instead of mac80211-internal hw flags.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c       |  5 +++--
 drivers/net/wireless/iwlegacy/4965-mac.c    |  5 ++---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  8 ++++----
 drivers/net/wireless/mac80211_hwsim.c       |  8 ++++----
 include/net/mac80211.h                      | 13 +------------
 net/mac80211/debugfs.c                      |  5 -----
 net/mac80211/debugfs_netdev.c               |  4 ++--
 net/mac80211/mlme.c                         |  2 +-
 9 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9d61bb1..4b5f001 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4759,7 +4759,6 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_MFP_CAPABLE |
 			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 			IEEE80211_HW_HAS_RATE_CONTROL |
-			IEEE80211_HW_SUPPORTS_STATIC_SMPS |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT;
 
@@ -4767,8 +4766,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	 * bytes is used for padding/alignment if necessary. */
 	ar->hw->extra_tx_headroom += sizeof(struct htt_data_tx_desc_frag)*2 + 4;
 
+	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
+
 	if (ar->ht_cap_info & WMI_HT_CAP_DYNAMIC_SMPS)
-		ar->hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
+		ar->hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_ENABLED) {
 		ar->hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 3dcbe2c..9f930a0 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5757,9 +5757,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	if (il->cfg->sku & IL_SKU_N)
-		hw->flags |=
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
+		hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS |
+				       NL80211_FEATURE_STATIC_SMPS;
 
 	hw->sta_data_size = sizeof(struct il_station_priv);
 	hw->vif_data_size = sizeof(struct il_vif_priv);
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index afb98f4..2364a3c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -125,8 +125,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	 */
 
 	if (priv->nvm_data->sku_cap_11n_enable)
-		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
+		hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS |
+				       NL80211_FEATURE_STATIC_SMPS;
 
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7c87965..395fc05 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -301,9 +301,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
-		    IEEE80211_HW_CHANCTX_STA_CSA |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
+		    IEEE80211_HW_CHANCTX_STA_CSA;
 
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
@@ -405,7 +403,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
 			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
-			       NL80211_FEATURE_P2P_GO_OPPPS;
+			       NL80211_FEATURE_P2P_GO_OPPPS |
+			       NL80211_FEATURE_DYNAMIC_SMPS |
+			       NL80211_FEATURE_STATIC_SMPS;
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1326f61..babbdc1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2045,8 +2045,6 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 
 	hw->flags = IEEE80211_HW_MFP_CAPABLE |
 		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_WANT_MONITOR_VIF |
 		    IEEE80211_HW_QUEUE_CONTROL |
@@ -2059,8 +2057,10 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			    WIPHY_FLAG_AP_UAPSD |
 			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
-	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
-	hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
+	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
+			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
+			       NL80211_FEATURE_STATIC_SMPS |
+			       NL80211_FEATURE_DYNAMIC_SMPS;
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c6e6a68..0ad1f47 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1537,16 +1537,6 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  *
- * @IEEE80211_HW_SUPPORTS_STATIC_SMPS:
- *	Hardware supports static spatial multiplexing powersave,
- *	ie. can turn off all but one chain even on HT connections
- *	that should be using more chains.
- *
- * @IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS:
- *	Hardware supports dynamic spatial multiplexing powersave,
- *	ie. can turn off all but one chain and then wake the rest
- *	up as required after, for example, rts/cts handshake.
- *
  * @IEEE80211_HW_SUPPORTS_UAPSD:
  *	Hardware supports Unscheduled Automatic Power Save Delivery
  *	(U-APSD) in managed mode. The mode is configured with
@@ -1632,8 +1622,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
-	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
-	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
+	/* free slots */
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5746561..54a189f 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -303,11 +303,6 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
 	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
 		sf += scnprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS)
-		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_STATIC_SMPS\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
-		sf += scnprintf(buf + sf, mxln - sf,
-				"SUPPORTS_DYNAMIC_SMPS\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
 		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
 	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index e205eba..c68896a 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -226,12 +226,12 @@ static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	int err;
 
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS) &&
+	if (!(local->hw.wiphy->features & NL80211_FEATURE_STATIC_SMPS) &&
 	    smps_mode == IEEE80211_SMPS_STATIC)
 		return -EINVAL;
 
 	/* auto should be dynamic if in PS mode */
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS) &&
+	if (!(local->hw.wiphy->features & NL80211_FEATURE_DYNAMIC_SMPS) &&
 	    (smps_mode == IEEE80211_SMPS_DYNAMIC ||
 	     smps_mode == IEEE80211_SMPS_AUTOMATIC))
 		return -EINVAL;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a7b92f5..f591f39 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3798,7 +3798,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmgd->uapsd_max_sp_len = sdata->local->hw.uapsd_max_sp_len;
 	ifmgd->p2p_noa_index = -1;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
+	if (sdata->local->hw.wiphy->features & NL80211_FEATURE_DYNAMIC_SMPS)
 		ifmgd->req_smps = IEEE80211_SMPS_AUTOMATIC;
 	else
 		ifmgd->req_smps = IEEE80211_SMPS_OFF;
-- 
1.9.1

