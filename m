Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab1DRRFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlagn: remove un-necessary ieee80211_ops
Date: Mon, 18 Apr 2011 09:44:15 -0700
Message-Id: <1303145057-6545-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to use ieee80211_ops, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 --
 7 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a018718..baf8011 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -220,7 +220,6 @@ static const struct iwl_ops iwl1000_ops = {
 	.lib = &iwl1000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl1000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0bd9b14..e76e02c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -304,28 +304,24 @@ static const struct iwl_ops iwl2000_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl2030_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl200_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl230_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl2000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ced89f6..655afc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -436,14 +436,12 @@ static const struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl5150_ops = {
 	.lib = &iwl5150_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl5000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ed6a0ed..905eb57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -386,7 +386,6 @@ static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl6050_ops = {
@@ -394,7 +393,6 @@ static const struct iwl_ops iwl6050_ops = {
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.nic = &iwl6050_nic_ops,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl6150_ops = {
@@ -402,14 +400,12 @@ static const struct iwl_ops iwl6150_ops = {
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.nic = &iwl6150_nic_ops,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl6030_ops = {
 	.lib = &iwl6030_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl6000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3cfd7eb..cdeb09e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3728,6 +3728,28 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 	7, 6, 5, 4,
 };
 
+/* This function both allocates and initializes hw and priv. */
+static struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg)
+{
+	struct iwl_priv *priv;
+	/* mac80211 allocates memory for this device instance, including
+	 *   space for this driver's private structure */
+	struct ieee80211_hw *hw;
+
+	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwlagn_hw_ops);
+	if (hw == NULL) {
+		pr_err("%s: Can not allocate network device\n",
+		       cfg->name);
+		goto out;
+	}
+
+	priv = hw->priv;
+	priv->hw = hw;
+
+out:
+	return hw;
+}
+
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0, i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0e98a87..885167f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -67,30 +67,6 @@ u32 iwl_debug_level;
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-
-/* This function both allocates and initializes hw and priv. */
-struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg)
-{
-	struct iwl_priv *priv;
-	/* mac80211 allocates memory for this device instance, including
-	 *   space for this driver's private structure */
-	struct ieee80211_hw *hw;
-
-	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv),
-				cfg->ops->ieee80211_ops);
-	if (hw == NULL) {
-		pr_err("%s: Can not allocate network device\n",
-		       cfg->name);
-		goto out;
-	}
-
-	priv = hw->priv;
-	priv->hw = hw;
-
-out:
-	return hw;
-}
-
 #define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
 #define MAX_BIT_RATE_20_MHZ 72 /* Mbps */
 static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index abee507..0049790 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -210,7 +210,6 @@ struct iwl_ops {
 	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_nic_ops *nic;
 	const struct iwl_legacy_ops *legacy;
-	const struct ieee80211_ops *ieee80211_ops;
 };
 
 struct iwl_mod_params {
@@ -364,7 +363,6 @@ struct iwl_cfg {
  *   L i b                 *
  ***************************/
 
-struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
 int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
-- 
1.7.0.4

