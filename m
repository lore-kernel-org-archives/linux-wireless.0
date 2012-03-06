Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031487Ab2CFWnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 16/33] iwlwifi: remove num_of_queues module parameter
Date: Tue,  6 Mar 2012 13:30:51 -0800
Message-Id: <1331069468-11074-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234340_279410_DC9B0F57)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a hardware parameter, so it shouldn't
be configurable by the user. Users can disable
aggregation (which is the only thing affected)
with 11n_disable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    5 -----
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    5 -----
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    5 -----
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 6 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 2199a0e..5039a9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -122,11 +122,6 @@ static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 
 static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		cfg(priv)->base_params->num_of_queues =
-			iwlagn_mod_params.num_of_queues;
-
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 1ba0207..c173962 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -118,11 +118,6 @@ static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 
 static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		cfg(priv)->base_params->num_of_queues =
-			iwlagn_mod_params.num_of_queues;
-
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index aebdfd7..fc6ec07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -157,11 +157,6 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 
 static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		cfg(priv)->base_params->num_of_queues =
-			iwlagn_mod_params.num_of_queues;
-
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
@@ -180,11 +175,6 @@ static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		cfg(priv)->base_params->num_of_queues =
-			iwlagn_mod_params.num_of_queues;
-
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 150bef0..a64f0f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -139,11 +139,6 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		cfg(priv)->base_params->num_of_queues =
-			iwlagn_mod_params.num_of_queues;
-
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7c3165e..8cf149c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1471,8 +1471,6 @@ MODULE_PARM_DESC(debug, "debug output mask");
 
 module_param_named(swcrypto, iwlagn_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(queues_num, iwlagn_mod_params.num_of_queues, int, S_IRUGO);
-MODULE_PARM_DESC(queues_num, "number of hw queues.");
 module_param_named(11n_disable, iwlagn_mod_params.disable_11n, uint, S_IRUGO);
 MODULE_PARM_DESC(11n_disable,
 	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8ee5284..ab2e1f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -115,7 +115,6 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * Holds the module parameters
  *
  * @sw_crypto: using hardware encryption, default = 0
- * @num_of_queues: number of tx queue, HW dependent
  * @disable_11n: disable 11n capabilities, default = 0,
  *	use IWL_DISABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 1
@@ -137,7 +136,6 @@ extern struct iwl_mod_params iwlagn_mod_params;
  */
 struct iwl_mod_params {
 	int sw_crypto;
-	int num_of_queues;
 	unsigned int disable_11n;
 	int amsdu_size_8K;
 	int antenna;
-- 
1.7.0.4

