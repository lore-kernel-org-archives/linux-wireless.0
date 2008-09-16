Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49988 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYIPGF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 02:05:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/2] iwlwifi: don't delay scan in IBSS mode
Date: Tue, 16 Sep 2008 14:01:03 +0800
Message-Id: <1221544864-9494-1-git-send-email-yi.zhu@intel.com> (sfid-20080916_080534_864320_B18780DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Scan need to be delayed only after association to allow EAPOL
exchange. We don't need the delay for IBSS mode.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2737627..2652672 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2568,8 +2568,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	iwl_chain_noise_reset(priv);
 	priv->start_calib = 1;
 
-	/* we have just associated, don't start scan too early */
-	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
 
 static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
@@ -3171,6 +3169,10 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 			priv->power_data.dtim_period = bss_conf->dtim_period;
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
+
+			/* we have just associated, don't start scan too early
+			 * leave time for EAPOL echange complete
+			 */
 			priv->next_scan_jiffies = jiffies +
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
 			mutex_lock(&priv->mutex);
-- 
1.5.3.6

