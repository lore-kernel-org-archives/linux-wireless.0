Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYHDIDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:53 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/10] iwlwifi: fix unhandled interrupt when HW rfkill is on
Date: Mon,  4 Aug 2008 16:00:43 +0800
Message-Id: <1217836848-24288-6-git-send-email-yi.zhu@intel.com> (sfid-20080804_100359_055394_2A7E6A36)
In-Reply-To: <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes unhandled interrupt when HW rfkill is on during
devices start up. The behavior changes, now open is successful even
when rfkill is on. This is to align with the situation when rfkill
is set on after opening.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9c9eb21..8a9feba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2232,17 +2232,16 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(priv, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 	else
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 
-	if (!test_bit(STATUS_IN_SUSPEND, &priv->status) &&
-	    iwl_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
+		iwl4965_enable_interrupts(priv);
 		IWL_WARNING("Radio disabled by %s RF Kill switch\n",
 		    test_bit(STATUS_RF_KILL_HW, &priv->status) ? "HW" : "SW");
-		return -ENODEV;
+		return 0;
 	}
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
@@ -2278,11 +2277,6 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
 	       priv->ucode_data.len);
 
-	/* We return success when we resume from suspend and rf_kill is on. */
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	    test_bit(STATUS_RF_KILL_SW, &priv->status))
-		return 0;
-
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
 		iwl_clear_stations_table(priv);
@@ -2651,6 +2645,9 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out_release_irq;
 
+	if (iwl_is_rfkill(priv))
+		goto out;
+
 	IWL_DEBUG_INFO("Start UP work done.\n");
 
 	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
@@ -2670,6 +2667,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
+out:
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
-- 
1.5.3.6

