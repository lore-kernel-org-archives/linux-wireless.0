Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2BQUXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/26] iwlwifi: iwl_set_hw_params returns always 0
Date: Fri, 17 Feb 2012 11:13:43 -0800
Message-Id: <1329506034-1394-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212416_249136_3216E4D6)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove the return value.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   10 +++-------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 6 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8c1466c..91c4a72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -120,7 +120,7 @@ static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 	.nrg_th_cca = 62,
 };
 
-static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
+static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
@@ -146,8 +146,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 	/* Set initial sensitivity parameters */
 	hw_params(priv).sens = &iwl1000_sensitivity;
-
-	return 0;
 }
 
 static struct iwl_lib_ops iwl1000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d4f5f3b..75f0e50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -116,7 +116,7 @@ static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 	.nrg_th_cca = 62,
 };
 
-static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
+static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
@@ -142,8 +142,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 	/* Set initial sensitivity parameters */
 	hw_params(priv).sens = &iwl2000_sensitivity;
-
-	return 0;
 }
 
 static struct iwl_lib_ops iwl2000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index dc9317d..458e677 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -162,7 +162,7 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
 }
 
-static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
+static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
@@ -185,11 +185,9 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	/* Set initial sensitivity parameters */
 	hw_params(priv).sens = &iwl5000_sensitivity;
-
-	return 0;
 }
 
-static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
+static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
@@ -212,8 +210,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 
 	/* Set initial sensitivity parameters */
 	hw_params(priv).sens = &iwl5150_sensitivity;
-
-	return 0;
 }
 
 static void iwl5150_temperature(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c36fb85..19e4103 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -137,7 +137,7 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 	.nrg_th_cca = 62,
 };
 
-static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
+static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
@@ -165,7 +165,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	/* Set initial sensitivity parameters */
 	hw_params(priv).sens = &iwl6000_sensitivity;
 
-	return 0;
 }
 
 static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cf1a353..68b9e5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1082,7 +1082,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 #define IWL_RX_BUF_SIZE_4K (4 * 1024)
 #define IWL_RX_BUF_SIZE_8K (8 * 1024)
 
-static int iwl_set_hw_params(struct iwl_priv *priv)
+static void iwl_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.amsdu_size_8K)
 		hw_params(priv).rx_page_order =
@@ -1102,7 +1102,7 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).wd_timeout = cfg(priv)->base_params->wd_timeout;
 
 	/* Device-specific setup */
-	return cfg(priv)->lib->set_hw_params(priv);
+	cfg(priv)->lib->set_hw_params(priv);
 }
 
 
@@ -1239,11 +1239,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/************************
 	 * 5. Setup HW constants
 	 ************************/
-	if (iwl_set_hw_params(priv)) {
-		err = -ENOENT;
-		IWL_ERR(priv, "failed to set hw parameters\n");
-		goto out_free_eeprom;
-	}
+	iwl_set_hw_params(priv);
 
 	/*******************
 	 * 6. Setup priv
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8d60dcf..49370dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -76,7 +76,7 @@ struct iwl_cmd;
 
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
-	int (*set_hw_params)(struct iwl_priv *priv);
+	void (*set_hw_params)(struct iwl_priv *priv);
 	/* setup BT Rx handler */
 	void (*bt_rx_handler_setup)(struct iwl_priv *priv);
 	/* setup BT related deferred work */
-- 
1.7.0.4

