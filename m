Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab2BCAQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/28] iwlwifi: move bcast_sta_id init to common routine
Date: Thu,  2 Feb 2012 15:09:16 -0800
Message-Id: <1328224159-18134-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011713_229012_6C0CA8E4)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

There is nothing device specific in the initialization of the
bcast_sta_id so move it to the common inititalization routine.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    1 +
 5 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index f7a555b..8c1466c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -128,8 +128,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
-
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
 	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 8760034..d4f5f3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -124,8 +124,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
-
 	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
 	hw_params(priv).max_inst_size = IWL60_RTC_INST_SIZE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5245a14..dc9317d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -170,8 +170,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
-
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
 	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
@@ -199,8 +197,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
-
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
 	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 464b887..c36fb85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -145,8 +145,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
-
 	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
 	hw_params(priv).max_inst_size = IWL60_RTC_INST_SIZE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 82f8836..c41c394 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -513,6 +513,7 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].exclusive_interface_modes =
 		BIT(NL80211_IFTYPE_ADHOC);
 	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
-- 
1.7.0.4

