Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763038AbXG0J3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Mohamed Abbas <mabbas@linux.intel.com>
Subject: [PATCH 13/17] iwlwifi: fix 11n on 2.4 channel
Date: Fri, 27 Jul 2007 17:26:37 +0800
Message-Id: <11855284253382-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1185528423816-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
 <11855284201330-git-send-email-yi.zhu@intel.com>
 <11855284212390-git-send-email-yi.zhu@intel.com>
 <1185528423816-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When tuned to 2.4 network we should not use FAT channel. This patch
sets supported_chan_width_set to 0 in association request if we are
going to join B/G band networks.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    8 ++++++--
 drivers/net/wireless/iwl-base.c |   38 ++++++++++++++++++++++++++++++--------
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index a333204..fcee3f5 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -4478,6 +4478,7 @@ void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
 		break;
 	default:
+		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
 		break;
 	}
 
@@ -4490,9 +4491,12 @@ void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 	iwl4965_set_rxon_chain(priv);
 
 	IWL_DEBUG_ASSOC("supported HT rate 0x%X %X "
-			"falgs 0x%X operation 0x%X\n",
+			"rxon flags 0x%X operation mode :0x%X "
+			"extension channel offset 0x%x "
+			"control chan %d\n",
 			priv->active_rate_ht[0], priv->active_rate_ht[1],
-			rxon->flags, ht_info->operating_mode);
+			rxon->flags, ht_info->operating_mode,
+			ht_info->extension_chan_offset, ht_info->control_chan);
 	return;
 }
 void iwl4965_set_ht_add_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 111e51b..a17fbd9 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1780,8 +1780,9 @@ static u16 iwl_supported_rate_to_ie(u8 * ie, u16 supported_rate,
 
 #if IWL == 4965
 #ifdef CONFIG_IWLWIFI_HT
-void static iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
-				 struct ieee80211_ht_capability *ht_cap);
+void static iwl_set_ht_capab(struct ieee80211_hw *hw,
+			     struct ieee80211_ht_capability *ht_cap,
+			     u8 use_wide_chan);
 #endif
 #endif
 
@@ -1868,10 +1869,15 @@ static int iwl_fill_probe_req(struct iwl_priv *priv,
 #if IWL == 4965
 #ifdef CONFIG_IWLWIFI_HT
 	if (is_direct && priv->is_ht_enabled) {
+		u8 use_wide_chan = 1;
+
+		if (priv->channel_width != IWL_CHANNEL_WIDTH_40MHZ)
+			use_wide_chan = 0;
 		pos += (*pos) + 1;
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_capability);
-		iwl_mac_get_ht_capab(NULL, (struct ieee80211_ht_capability *)pos);
+		iwl_set_ht_capab(NULL, (struct ieee80211_ht_capability *)pos,
+				 use_wide_chan);
 		len += 2 + sizeof(struct ieee80211_ht_capability);
 	}
 #endif  /*CONFIG_IWLWIFI_HT */
@@ -8120,13 +8126,13 @@ static int iwl_mac_conf_ht(struct ieee80211_hw *hw,
 
 }
 
-static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
-				 struct ieee80211_ht_capability *ht_cap)
+static void iwl_set_ht_capab(struct ieee80211_hw *hw,
+			     struct ieee80211_ht_capability *ht_cap,
+			     u8 use_wide_chan)
 {
 	union ht_cap_info cap;
 	union ht_param_info param_info;
 
-	IWL_DEBUG_MAC80211("enter: \n");
 	memset(&cap, 0, sizeof(union ht_cap_info));
 	memset(&param_info, 0, sizeof(union ht_param_info));
 
@@ -8134,7 +8140,7 @@ static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
 	cap.green_field = 1;
 	cap.short_GI20 = 1;
 	cap.short_GI40 = 1;
-	cap.supported_chan_width_set = 1;
+	cap.supported_chan_width_set = use_wide_chan;
 	cap.mimo_power_save_mode = 0x3;
 
 	param_info.max_rx_ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
@@ -8146,10 +8152,26 @@ static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
 	ht_cap->supported_mcs_set[1] = 0xff;
 	ht_cap->supported_mcs_set[4] =
 	    (cap.supported_chan_width_set) ? 0x1: 0x0;
+}
+
+static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
+				 struct ieee80211_ht_capability *ht_cap)
+{
+	u8 use_wide_channel = 1;
+	struct iwl_priv *priv = hw->priv;
 
+	IWL_DEBUG_MAC80211("enter: \n");
+	if (priv->channel_width != IWL_CHANNEL_WIDTH_40MHZ)
+		use_wide_channel = 0;
+
+	/* no fat tx allowed on 2.4GHZ */
+	if ((priv->phymode != MODE_IEEE80211A) &&
+	    (priv->phymode != MODE_ATHEROS_TURBO))
+		use_wide_channel = 0;
+
+	iwl_set_ht_capab(hw, ht_cap, use_wide_channel);
 	IWL_DEBUG_MAC80211("leave: \n");
 }
-
 #endif /*CONFIG_IWLWIFI_HT*/
 #endif /*IWL == 4965*/
 /*****************************************************************************
-- 
1.5.2
