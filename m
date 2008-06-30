Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbYF3J1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Adel Gadllah <adel.gadllah@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Fabien Crespel <fcrespel@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 33/33] iwlwifi: remove the input device from rfkill_mngr
Date: Mon, 30 Jun 2008 17:23:33 +0800
Message-Id: <1214817813-17639-34-git-send-email-yi.zhu@intel.com> (sfid-20080630_113815_444322_D97ED332)
In-Reply-To: <1214817813-17639-33-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-31-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-32-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-33-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adel Gadllah <adel.gadllah@gmail.com>

The patch removes the dependency from the input device.
A final cleanup for iwl_rfkill_mngr will be done later.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>
CC: Fabien Crespel <fcrespel@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |   45 +--------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   38 +---------------------
 4 files changed, 10 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index d7ea32f..82b66a3 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -8,7 +8,6 @@ config IWLCORE
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
-	select RFKILL_INPUT if (IWLWIFI_RFKILL && INPUT)
 
 config IWLWIFI_LEDS
 	bool
@@ -105,6 +104,7 @@ config IWL3945
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
+	select RFKILL if IWL3945_RFKILL
 	---help---
 	  Select to build the driver supporting the:
 
@@ -127,6 +127,10 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.
 
+config IWL3945_RFKILL
+	bool "Enable RF kill support in iwl3945 drivers"
+	depends on IWL3945
+
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a774978..4df42ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -690,7 +690,7 @@ enum {
 
 #endif
 
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 struct iwl3945_priv;
 
 struct iwl3945_rfkill_mngr {
@@ -800,7 +800,7 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 	struct iwl3945_rfkill_mngr rfkill_mngr;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index ffefbb4..a65de47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -98,50 +98,15 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
-#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
-	priv->rfkill_mngr.input_dev = input_allocate_device();
-	if (!priv->rfkill_mngr.input_dev) {
-		IWL_ERROR("Unable to allocate rfkill input device.\n");
-		ret = -ENOMEM;
-		goto freed_rfkill;
-	}
-
-	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
-	priv->rfkill_mngr.input_dev->phys = wiphy_name(priv->hw->wiphy);
-	priv->rfkill_mngr.input_dev->id.bustype = BUS_HOST;
-	priv->rfkill_mngr.input_dev->id.vendor = priv->pci_dev->vendor;
-	priv->rfkill_mngr.input_dev->dev.parent = device;
-	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
-#endif
-
 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto free_input_dev;
-	}
-
-#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
-	ret = input_register_device(priv->rfkill_mngr.input_dev);
-	if (ret) {
-		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
-		goto unregister_rfkill;
+		goto freed_rfkill;
 	}
-#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
-free_input_dev:
-#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
-	input_free_device(priv->rfkill_mngr.input_dev);
-	priv->rfkill_mngr.input_dev = NULL;
-#endif
-
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
@@ -155,14 +120,6 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {
-
-#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
-	if (priv->rfkill_mngr.input_dev)
-		input_unregister_device(priv->rfkill_mngr.input_dev);
-	input_free_device(priv->rfkill_mngr.input_dev);
-	priv->rfkill_mngr.input_dev = NULL;
-#endif
-
 	if (priv->rfkill_mngr.rfkill)
 		rfkill_unregister(priv->rfkill_mngr.rfkill);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3bc2644..a604a29 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8270,7 +8270,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 /*************** RFKILL FUNCTIONS **********/
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 /* software rf-kill from user */
 static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 {
@@ -8331,44 +8331,15 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
-	priv->rfkill_mngr.input_dev = input_allocate_device();
-	if (!priv->rfkill_mngr.input_dev) {
-		IWL_ERROR("Unable to allocate rfkill input device.\n");
-		ret = -ENOMEM;
-		goto freed_rfkill;
-	}
-
-	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
-	priv->rfkill_mngr.input_dev->phys = wiphy_name(priv->hw->wiphy);
-	priv->rfkill_mngr.input_dev->id.bustype = BUS_HOST;
-	priv->rfkill_mngr.input_dev->id.vendor = priv->pci_dev->vendor;
-	priv->rfkill_mngr.input_dev->dev.parent = device;
-	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
-
 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto free_input_dev;
-	}
-
-	ret = input_register_device(priv->rfkill_mngr.input_dev);
-	if (ret) {
-		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
-		goto unregister_rfkill;
+		goto freed_rfkill;
 	}
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
-free_input_dev:
-	input_free_device(priv->rfkill_mngr.input_dev);
-	priv->rfkill_mngr.input_dev = NULL;
-
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
@@ -8381,14 +8352,9 @@ error:
 
 void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
 {
-
-	if (priv->rfkill_mngr.input_dev)
-		input_unregister_device(priv->rfkill_mngr.input_dev);
-
 	if (priv->rfkill_mngr.rfkill)
 		rfkill_unregister(priv->rfkill_mngr.rfkill);
 
-	priv->rfkill_mngr.input_dev = NULL;
 	priv->rfkill_mngr.rfkill = NULL;
 }
 
-- 
1.5.3.6

