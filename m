Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXK2DK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:29 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/36] iwlwifi: continue namespace changes - fix CONFIG variables
Date: Thu, 29 Nov 2007 11:09:42 +0800
Message-Id: <1196305816-23023-3-git-send-email-yi.zhu@intel.com> (sfid-20071129_033539_173366_3F0F43F6)
In-Reply-To: <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

- Remove HT code from iwl-3945.h - it is not needed here as 3945
  does not support HT. The code ended up here during the header file
  split.
- Modify a few places where the CONFIG variables were named
  incorrectly: all changes are to comments only.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   25 -------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 4 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e5b345d..02040ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -445,31 +445,6 @@ union iwl3945_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWL3945_HT
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
-#define HT_IE_MAX_AMSDU_SIZE_4K     (0)
-#define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
-#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
-
-struct sta_ht_info {
-	u8 is_ht;
-	u16 rx_mimo_ps_mode;
-	u16 tx_mimo_ps_mode;
-	u16 control_channel;
-	u8 max_amsdu_size;
-	u8 ampdu_factor;
-	u8 mpdu_density;
-	u8 operating_mode;
-	u8 supported_chan_width;
-	u8 extension_chan_offset;
-	u8 is_green_field;
-	u8 sgf;
-	u8 supp_rates[16];
-	u8 tx_chan_width;
-	u8 chan_width_cap;
-};
-#endif				/*CONFIG_IWL3945_HT */
-
 #ifdef CONFIG_IWL3945_QOS
 
 union iwl3945_qos_capabity {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9b8560d..5dee8e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4667,7 +4667,7 @@ void iwl4965_hw_setup_deferred_work(struct iwl4965_priv *priv)
 #ifdef CONFIG_IWL4965_HT
 #ifdef CONFIG_IWL4965_HT_AGG
 	INIT_WORK(&priv->agg_work, iwl4965_bg_agg_work);
-#endif /* CONFIG_IWL4965_AGG */
+#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f93cd1d..7012aed 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7347,7 +7347,7 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 #ifdef CONFIG_IWL3945_QOS
 	unsigned long flags;
 	int q;
-#endif /* CONFIG_IWL_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 
 	IWL_DEBUG_MAC80211("enter\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 04aadfb..6dd6c7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7781,7 +7781,7 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 #ifdef CONFIG_IWL4965_QOS
 	unsigned long flags;
 	int q;
-#endif /* CONFIG_IWL_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-- 
1.5.3.6
