Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab0JWQSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/8] iwlwifi: make mac80211 ops a device config
Date: Sat, 23 Oct 2010 09:15:39 -0700
Message-Id: <1287850546-23500-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the future, 4965 and modern AGN devices will
need to have different mac80211 callbacks since
they have different capabilities. Prepare for
that by making the mac80211 operations a device
config.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 11 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index db54091..4266c85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -243,6 +243,7 @@ static const struct iwl_ops iwl1000_ops = {
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl1000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 176e525..f708ba0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2749,6 +2749,7 @@ static const struct iwl_ops iwl3945_ops = {
 	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
 	.led = &iwl3945_led_ops,
+	.ieee80211_ops = &iwl3945_hw_ops,
 };
 
 static struct iwl_base_params iwl3945_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 09391f0..b27f07c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -282,6 +282,8 @@ extern int iwl3945_commit_rxon(struct iwl_priv *priv,
  */
 extern u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
+extern struct ieee80211_ops iwl3945_hw_ops;
+
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b207e3e..d3cf6b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2309,6 +2309,7 @@ static const struct iwl_ops iwl4965_ops = {
 	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
 	.led = &iwlagn_led_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl4965_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index fd9fbc9..5f03277 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -485,6 +485,7 @@ static const struct iwl_ops iwl5000_ops = {
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl5150_ops = {
@@ -492,6 +493,7 @@ static const struct iwl_ops iwl5150_ops = {
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl5000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 11e6532..85bde70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -439,6 +439,7 @@ static const struct iwl_ops iwl6000_ops = {
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl6050_ops = {
@@ -447,6 +448,7 @@ static const struct iwl_ops iwl6050_ops = {
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 	.nic = &iwl6050_nic_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl6050g2_ops = {
@@ -455,6 +457,7 @@ static const struct iwl_ops iwl6050g2_ops = {
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 	.nic = &iwl6050g2_nic_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static const struct iwl_ops iwl6000g2b_ops = {
@@ -462,6 +465,7 @@ static const struct iwl_ops iwl6000g2b_ops = {
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
+	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
 static struct iwl_base_params iwl6000_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c2636a7..ad8754f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4209,7 +4209,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	kfree(priv->scan_cmd);
 }
 
-static struct ieee80211_ops iwl_hw_ops = {
+struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwl_mac_tx,
 	.start = iwl_mac_start,
 	.stop = iwl_mac_stop,
@@ -4298,10 +4298,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (cfg->mod_params->disable_hw_scan) {
 		dev_printk(KERN_DEBUG, &(pdev->dev),
 			"sw scan support is deprecated\n");
-		iwl_hw_ops.hw_scan = NULL;
+		iwlagn_hw_ops.hw_scan = NULL;
 	}
 
-	hw = iwl_alloc_all(cfg, &iwl_hw_ops);
+	hw = iwl_alloc_all(cfg);
 	if (!hw) {
 		err = -ENOMEM;
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f525d55..ba88e78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -102,6 +102,8 @@ extern struct iwl_hcmd_ops iwlagn_hcmd;
 extern struct iwl_hcmd_ops iwlagn_bt_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
+extern struct ieee80211_ops iwlagn_hw_ops;
+
 int iwl_reset_ict(struct iwl_priv *priv);
 void iwl_disable_ict(struct iwl_priv *priv);
 int iwl_alloc_isr_ict(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 25fb391..2fbcaeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -77,15 +77,15 @@ EXPORT_SYMBOL(iwl_bcast_addr);
 
 
 /* This function both allocates and initializes hw and priv. */
-struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
-		struct ieee80211_ops *hw_ops)
+struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg)
 {
 	struct iwl_priv *priv;
-
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
-	struct ieee80211_hw *hw =
-		ieee80211_alloc_hw(sizeof(struct iwl_priv), hw_ops);
+	struct ieee80211_hw *hw;
+
+	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv),
+				cfg->ops->ieee80211_ops);
 	if (hw == NULL) {
 		pr_err("%s: Can not allocate network device\n",
 		       cfg->name);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 64527de..1b66bb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -241,6 +241,7 @@ struct iwl_ops {
 	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_led_ops *led;
 	const struct iwl_nic_ops *nic;
+	const struct ieee80211_ops *ieee80211_ops;
 };
 
 struct iwl_mod_params {
@@ -396,8 +397,7 @@ struct iwl_cfg {
  *   L i b                 *
  ***************************/
 
-struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
-		struct ieee80211_ops *hw_ops);
+struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
 int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8f8c4b7..e20ab98 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3824,7 +3824,7 @@ static struct attribute_group iwl3945_attribute_group = {
 	.attrs = iwl3945_sysfs_entries,
 };
 
-static struct ieee80211_ops iwl3945_hw_ops = {
+struct ieee80211_ops iwl3945_hw_ops = {
 	.tx = iwl3945_mac_tx,
 	.start = iwl3945_mac_start,
 	.stop = iwl3945_mac_stop,
@@ -3965,7 +3965,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
-	hw = iwl_alloc_all(cfg, &iwl3945_hw_ops);
+	hw = iwl_alloc_all(cfg);
 	if (hw == NULL) {
 		pr_err("Can not allocate network device\n");
 		err = -ENOMEM;
-- 
1.7.0.4

