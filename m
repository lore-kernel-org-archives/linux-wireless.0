Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:24839 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYFZVzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:55:25 -0400
Received: by nf-out-0910.google.com with SMTP id d3so53601nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 14:55:23 -0700 (PDT)
Message-ID: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com> (sfid-20080626_235527_316639_95626E8B)
Date: Thu, 26 Jun 2008 23:55:22 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>
Subject: [PATCH] iwl3945: fix up rfkill kconfig and input
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The attached patch fixes iwl3945 to build with CONFIG_INPUT=n and
frees the input device on exit.
Additionally it removes the unnecessary dependency on CONFIG_IWLCORE.
It depends on the rfkill subsystem patch, which is in the iwlwifi-2.6 tree.

-----------------
This patch fixes the iwl3945 driver to build with CONFIG_INPUT=n
and remove the dependency on CONFIG_IWLCORE.
It also frees the input device on exit.
Input stuff based on patch from Randy Dunlap for iwl4965/5000.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/Kconfig
b/drivers/net/wireless/iwlwifi/Kconfig
index a382c00..3148a28 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -105,6 +105,7 @@ config IWL3945
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
+	select RFKILL_INPUT if (IWL3945_RFKILL && INPUT)
 	---help---
 	  Select to build the driver supporting the:

@@ -127,6 +128,10 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.

+config IWL3945_RFKILL
+	boolean "Enable RF kill support in iwl3945 drivers"
+	depends on IWL3945
+
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
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

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43cb8ff..5449039 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8282,7 +8282,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */

 /*************** RFKILL FUNCTIONS **********/
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 /* software rf-kill from user */
 static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 {
@@ -8340,6 +8340,7 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;

+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
@@ -8354,6 +8355,7 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 	priv->rfkill_mngr.input_dev->dev.parent = device;
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
+#endif

 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
 	if (ret) {
@@ -8361,11 +8363,13 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 		goto free_input_dev;
 	}

+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
 		goto unregister_rfkill;
 	}
+#endif

 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
@@ -8375,8 +8379,10 @@ unregister_rfkill:
 	priv->rfkill_mngr.rfkill = NULL;

 free_input_dev:
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
+#endif

 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
@@ -8391,13 +8397,16 @@ error:
 void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
 {

+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	if (priv->rfkill_mngr.input_dev)
 		input_unregister_device(priv->rfkill_mngr.input_dev);
+	input_free_device(priv->rfkill_mngr.input_dev);
+	priv->rfkill_mngr.input_dev = NULL;
+#endif

 	if (priv->rfkill_mngr.rfkill)
 		rfkill_unregister(priv->rfkill_mngr.rfkill);

-	priv->rfkill_mngr.input_dev = NULL;
 	priv->rfkill_mngr.rfkill = NULL;
 }
