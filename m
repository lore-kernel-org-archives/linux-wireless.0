Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbXLCLpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:35 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/34] iwlwifi: continue namespace changes - fix CONFIG variables
Date: Mon,  3 Dec 2007 13:43:14 +0200
Message-Id: <1196682229843-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120559_597973_86DCFA4C)
In-Reply-To: <11966822291406-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
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
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 4 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 9de4623..38802ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -446,30 +446,6 @@ union iwl3945_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWL3945_HT
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
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
index f2b5076..e4930a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4697,7 +4697,7 @@ void iwl4965_hw_setup_deferred_work(struct iwl4965_priv *priv)
 #ifdef CONFIG_IWL4965_HT
 #ifdef CONFIG_IWL4965_HT_AGG
 	INIT_WORK(&priv->agg_work, iwl4965_bg_agg_work);
-#endif /* CONFIG_IWL4965_AGG */
+#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bbcdd4d..efeb933 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7376,7 +7376,7 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 #ifdef CONFIG_IWL3945_QOS
 	unsigned long flags;
 	int q;
-#endif /* CONFIG_IWL_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 
 	IWL_DEBUG_MAC80211("enter\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e179683..907def3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7815,7 +7815,7 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 #ifdef CONFIG_IWL4965_QOS
 	unsigned long flags;
 	int q;
-#endif /* CONFIG_IWL_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
