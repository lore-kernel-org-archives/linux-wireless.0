Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab2BCAQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/28] iwlwifi: stop_hw replace enable_rfkill_int
Date: Thu,  2 Feb 2012 15:09:13 -0800
Message-Id: <1328224159-18134-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011718_999759_BFCFB69B)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This trans_ops->stop_hw leaves the RFKILL interrupt enabled,
we can call that one instead of enable_rfkill_int. By that,
we reduce the numbers of acceesses to the NIC from the upper
layers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h          |    6 ------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    2 ++
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e74bfb7..8d60dcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -297,12 +297,6 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 	       cfg(priv)->bt_params->advanced_bt_coexist;
 }
 
-static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
-{
-	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
-	iwl_write32(trans(priv), CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
-}
-
 extern bool bt_siso_mode;
 
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 78bc1e8..7177fd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -346,9 +346,10 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	flush_workqueue(priv->shrd->workqueue);
 
 	/* User space software may expect getting rfkill changes
-	 * even if interface is down */
-	iwl_write32(trans(priv), CSR_INT, 0xFFFFFFFF);
-	iwl_enable_rfkill_int(priv);
+	 * even if interface is down, trans->down will leave the RF
+	 * kill interrupt enabled
+	 */
+	iwl_trans_stop_hw(trans(priv));
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 731f287..78abff0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1149,8 +1149,10 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status))
 		iwl_enable_interrupts(trans);
 	/* Re-enable RF_KILL if it occurred */
-	else if (handled & CSR_INT_BIT_RF_KILL)
-		iwl_enable_rfkill_int(priv(trans));
+	else if (handled & CSR_INT_BIT_RF_KILL) {
+		IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
+		iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	}
 }
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ed2a921..ec26950 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1532,6 +1532,8 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
 {
 	iwl_apm_stop(trans);
 
+	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+
 	/* Even if we stop the HW, we still want the RF kill interrupt */
 	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
 	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
-- 
1.7.0.4

