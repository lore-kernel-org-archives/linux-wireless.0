Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 078/101] iwlwifi: remove unused max_nrg_cck from sensitivity and constify
Date: Sun,  4 Mar 2012 11:29:32 -0800
Message-Id: <1330889395-533-79-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214452_237806_2C2D4F58)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The sensitivity parameters are never modified, so they
should be const. Also remove the unused max_nrg_cck
value to save some space.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-2000.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 5 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 798e24e..5b0d888 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -96,9 +96,8 @@ static void iwl1000_nic_config(struct iwl_priv *priv)
 				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
 }
 
-static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
+static const struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 	.min_nrg_cck = 95,
-	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 90,
 	.auto_corr_min_ofdm_mrc = 170,
 	.auto_corr_min_ofdm_x1 = 120,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 6931820..5635b9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -91,9 +91,8 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
 
-static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
+static const struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 	.min_nrg_cck = 97,
-	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 80,
 	.auto_corr_min_ofdm_mrc = 128,
 	.auto_corr_min_ofdm_x1 = 105,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0e97cfd..a805e97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -75,9 +75,8 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 }
 
-static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
+static const struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.min_nrg_cck = 100,
-	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 90,
 	.auto_corr_min_ofdm_mrc = 170,
 	.auto_corr_min_ofdm_x1 = 105,
@@ -102,7 +101,6 @@ static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 
 static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 	.min_nrg_cck = 95,
-	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 90,
 	.auto_corr_min_ofdm_mrc = 170,
 	.auto_corr_min_ofdm_x1 = 105,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9fbab01..64060cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -113,9 +113,8 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		cfg(priv)->additional_nic_config(priv);
 }
 
-static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
+static const struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 	.min_nrg_cck = 110,
-	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 80,
 	.auto_corr_min_ofdm_mrc = 128,
 	.auto_corr_min_ofdm_x1 = 105,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7442970..c3f372e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -294,7 +294,6 @@ struct iwl_vif_priv {
 
 struct iwl_sensitivity_ranges {
 	u16 min_nrg_cck;
-	u16 max_nrg_cck;
 
 	u16 nrg_th_cck;
 	u16 nrg_th_ofdm;
-- 
1.7.0.4

