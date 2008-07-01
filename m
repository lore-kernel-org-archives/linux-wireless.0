Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:60235 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYGAPtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 11:49:52 -0400
Received: by fg-out-1718.google.com with SMTP id 19so968056fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 08:49:50 -0700 (PDT)
Message-ID: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> (sfid-20080701_174957_925715_C587A8BB)
Date: Tue, 1 Jul 2008 17:49:50 +0200
From: "Adel Gadllah" <adel.gadllah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: remove input device and fix rfkill state
Cc: randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>, fcrespel@gmail.com,
	yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the iwlwifi rfkill. It removes the input device from iwl3945,
adds support for RFKILL_STATE_HARD_BLOCKED and calls rfkill_force_state() to
update the state rather than accessing it directly.
The calls to iwl|iwl3945_rfkill_set_hw_state() had to be moved because
rfkill_force_state() cannot be called from an atomic context.
Tested on iwl3945 and seems to work fine.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Fabien Crespel <fcrespel@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    5 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   11 --
 drivers/net/wireless/iwlwifi/iwl-core.h     |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |   63 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-rfkill.h   |    3
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  117 +++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 -
 8 files changed, 106 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig
b/drivers/net/wireless/iwlwifi/Kconfig
index b628a44..8305de6 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -104,6 +104,7 @@ config IWL3945
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
+	select RFKILL if IWL3945_RFKILL
 	---help---
 	  Select to build the driver supporting the:

@@ -126,6 +127,10 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.

+config IWL3945_RFKILL
+       bool "Enable RF kill support in iwl3945 drivers"
+       depends on IWL3945
+
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a774978..9c0a09e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -690,14 +690,9 @@ enum {

 #endif

-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 struct iwl3945_priv;

-struct iwl3945_rfkill_mngr {
-	struct rfkill *rfkill;
-	struct input_dev *input_dev;
-};
-
 void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv);
 void iwl3945_rfkill_unregister(struct iwl3945_priv *priv);
 int iwl3945_rfkill_init(struct iwl3945_priv *priv);
@@ -800,8 +795,8 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;

-#ifdef CONFIG_IWLWIFI_RFKILL
-	struct iwl3945_rfkill_mngr rfkill_mngr;
+#ifdef CONFIG_IWL3945_RFKILL
+	struct rfkill *rfkill;
 #endif

 #ifdef CONFIG_IWL3945_LEDS
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h
b/drivers/net/wireless/iwlwifi/iwl-core.h
index eb4abe1..dafd62c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -356,10 +356,19 @@ static inline int iwl_is_init(struct iwl_priv *priv)
 	return test_bit(STATUS_INIT, &priv->status);
 }

+static inline int iwl_is_rfkill_sw(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+static inline int iwl_is_rfkill_hw(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status);
+}
+
 static inline int iwl_is_rfkill(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	       test_bit(STATUS_RF_KILL_SW, &priv->status);
+	return iwl_is_rfkill_hw(priv) || iwl_is_rfkill_sw(priv);
 }

 static inline int iwl_is_ready_rf(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h
b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d1289cf..70e10ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -929,7 +929,7 @@ struct iwl_priv {
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
 #ifdef CONFIG_IWLWIFI_RFKILL
-	struct iwl_rfkill_mngr rfkill_mngr;
+	struct rfkill *rfkill;
 #endif

 #ifdef CONFIG_IWLWIFI_LEDS
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index aa9f31e..2b9a009 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -44,7 +44,7 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum
rfkill_state state)
 	struct iwl_priv *priv = data;
 	int err = 0;

-	if (!priv->rfkill_mngr.rfkill)
+	if (!priv->rfkill)
 		return 0;

 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -55,20 +55,20 @@ static int iwl_rfkill_soft_rf_kill(void *data,
enum rfkill_state state)

 	switch (state) {
 	case RFKILL_STATE_UNBLOCKED:
-		iwl_radio_kill_sw_enable_radio(priv);
-		/* if HW rf-kill is set dont allow ON state */
-		if (iwl_is_rfkill(priv))
+		if (iwl_is_rfkill_hw(priv)) {
 			err = -EBUSY;
+			goto out_unlock;
+		}
+		iwl_radio_kill_sw_enable_radio(priv);
 		break;
 	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl_radio_kill_sw_disable_radio(priv);
-		if (!iwl_is_rfkill(priv))
-			err = -EBUSY;
 		break;
 	default:
 		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
 		break;
 	}
+out_unlock:
 	mutex_unlock(&priv->mutex);

 	return err;
@@ -82,39 +82,35 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	BUG_ON(device == NULL);

 	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
-	priv->rfkill_mngr.rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
-	if (!priv->rfkill_mngr.rfkill) {
+	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
+	if (!priv->rfkill) {
 		IWL_ERROR("Unable to allocate rfkill device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}

-	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
-	priv->rfkill_mngr.rfkill->data = priv;
-	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
-	priv->rfkill_mngr.rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
-	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;
+	priv->rfkill->name = priv->cfg->name;
+	priv->rfkill->data = priv;
+	priv->rfkill->state = RFKILL_STATE_UNBLOCKED;
+	priv->rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
+	priv->rfkill->user_claim_unsupported = 1;

-	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
-	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
+	priv->rfkill->dev.class->suspend = NULL;
+	priv->rfkill->dev.class->resume = NULL;

-	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	ret = rfkill_register(priv->rfkill);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto unregister_rfkill;
+		goto freed_rfkill;
 	}

 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;

-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
 freed_rfkill:
-	if (priv->rfkill_mngr.rfkill != NULL)
-		rfkill_free(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
+	if (priv->rfkill != NULL)
+		rfkill_free(priv->rfkill);
+	priv->rfkill = NULL;

 error:
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
@@ -125,22 +121,27 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {

-	if (priv->rfkill_mngr.rfkill)
-		rfkill_unregister(priv->rfkill_mngr.rfkill);
+	if (priv->rfkill)
+		rfkill_unregister(priv->rfkill);

-	priv->rfkill_mngr.rfkill = NULL;
+	priv->rfkill = NULL;
 }
 EXPORT_SYMBOL(iwl_rfkill_unregister);

 /* set rf-kill to the right state. */
 void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
 {
-	if (!priv->rfkill_mngr.rfkill)
+	if (!priv->rfkill)
 		return;

-	if (!iwl_is_rfkill(priv))
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	if (iwl_is_rfkill_hw(priv)) {
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
+		return;
+	}
+
+	if (!iwl_is_rfkill_sw(priv))
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 	else
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_OFF;
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
 }
 EXPORT_SYMBOL(iwl_rfkill_set_hw_state);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
index 00692d2..402fd4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -33,9 +33,6 @@ struct iwl_priv;
 #include <linux/rfkill.h>

 #ifdef CONFIG_IWLWIFI_RFKILL
-struct iwl_rfkill_mngr {
-	struct rfkill *rfkill;
-};

 void iwl_rfkill_set_hw_state(struct iwl_priv *priv);
 void iwl_rfkill_unregister(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3bc2644..f27c9fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -537,10 +537,20 @@ static inline int iwl3945_is_init(struct
iwl3945_priv *priv)
 	return test_bit(STATUS_INIT, &priv->status);
 }

+static inline int iwl3945_is_rfkill_sw(struct iwl3945_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+static inline int iwl3945_is_rfkill_hw(struct iwl3945_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status);
+}
+
 static inline int iwl3945_is_rfkill(struct iwl3945_priv *priv)
 {
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	       test_bit(STATUS_RF_KILL_SW, &priv->status);
+	return iwl3945_is_rfkill_hw(priv) ||
+		iwl3945_is_rfkill_sw(priv);
 }

 static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
@@ -6013,12 +6023,11 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	else {
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
-			iwl3945_rfkill_set_hw_state(priv);
 			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
 			return -ENODEV;
 		}
 	}
-	iwl3945_rfkill_set_hw_state(priv);
+
 	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);

 	rc = iwl3945_hw_nic_init(priv);
@@ -6143,8 +6152,8 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 				    "wireless networking to work.\n");
 	}

-	iwl3945_rfkill_set_hw_state(priv);
 	mutex_unlock(&priv->mutex);
+	iwl3945_rfkill_set_hw_state(priv);
 }

 static void iwl3945_bg_set_monitor(struct work_struct *work)
@@ -6398,6 +6407,7 @@ static void iwl3945_bg_up(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	__iwl3945_up(priv);
 	mutex_unlock(&priv->mutex);
+	iwl3945_rfkill_set_hw_state(priv);
 }

 static void iwl3945_bg_restart(struct work_struct *data)
@@ -6618,6 +6628,8 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)

 	mutex_unlock(&priv->mutex);

+	iwl3945_rfkill_set_hw_state(priv);
+
 	if (ret)
 		goto out_release_irq;

@@ -8270,14 +8282,14 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */

 /*************** RFKILL FUNCTIONS **********/
-#ifdef CONFIG_IWLWIFI_RFKILL
+#ifdef CONFIG_IWL3945_RFKILL
 /* software rf-kill from user */
 static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 {
 	struct iwl3945_priv *priv = data;
 	int err = 0;

-	if (!priv->rfkill_mngr.rfkill)
+	if (!priv->rfkill)
 	return 0;

 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -8288,20 +8300,20 @@ static int iwl3945_rfkill_soft_rf_kill(void
*data, enum rfkill_state state)

 	switch (state) {
 	case RFKILL_STATE_UNBLOCKED:
-		iwl3945_radio_kill_sw(priv, 0);
-		/* if HW rf-kill is set dont allow ON state */
-		if (iwl3945_is_rfkill(priv))
+		if (iwl3945_is_rfkill_hw(priv)) {
 			err = -EBUSY;
+			goto out_unlock;
+		}
+		iwl3945_radio_kill_sw(priv, 0);
 		break;
 	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl3945_radio_kill_sw(priv, 1);
-		if (!iwl3945_is_rfkill(priv))
-			err = -EBUSY;
 		break;
 	default:
 		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
 		break;
 	}
+out_unlock:
 	mutex_unlock(&priv->mutex);

 	return err;
@@ -8315,64 +8327,35 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
 	BUG_ON(device == NULL);

 	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
-	priv->rfkill_mngr.rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
-	if (!priv->rfkill_mngr.rfkill) {
+	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
+	if (!priv->rfkill) {
 		IWL_ERROR("Unable to allocate rfkill device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}

-	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
-	priv->rfkill_mngr.rfkill->data = priv;
-	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
-	priv->rfkill_mngr.rfkill->toggle_radio = iwl3945_rfkill_soft_rf_kill;
-	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;
-
-	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
-	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
+	priv->rfkill->name = priv->cfg->name;
+	priv->rfkill->data = priv;
+	priv->rfkill->state = RFKILL_STATE_UNBLOCKED;
+	priv->rfkill->toggle_radio = iwl3945_rfkill_soft_rf_kill;
+	priv->rfkill->user_claim_unsupported = 1;

-	priv->rfkill_mngr.input_dev = input_allocate_device();
-	if (!priv->rfkill_mngr.input_dev) {
-		IWL_ERROR("Unable to allocate rfkill input device.\n");
-		ret = -ENOMEM;
-		goto freed_rfkill;
-	}
+	priv->rfkill->dev.class->suspend = NULL;
+	priv->rfkill->dev.class->resume = NULL;

-	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
-	priv->rfkill_mngr.input_dev->phys = wiphy_name(priv->hw->wiphy);
-	priv->rfkill_mngr.input_dev->id.bustype = BUS_HOST;
-	priv->rfkill_mngr.input_dev->id.vendor = priv->pci_dev->vendor;
-	priv->rfkill_mngr.input_dev->dev.parent = device;
-	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
-
-	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	ret = rfkill_register(priv->rfkill);
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
-	if (priv->rfkill_mngr.rfkill != NULL)
-		rfkill_free(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
+	if (priv->rfkill != NULL)
+		rfkill_free(priv->rfkill);
+	priv->rfkill = NULL;

 error:
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
@@ -8381,28 +8364,28 @@ error:

 void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
 {
+	if (priv->rfkill)
+		rfkill_unregister(priv->rfkill);

-	if (priv->rfkill_mngr.input_dev)
-		input_unregister_device(priv->rfkill_mngr.input_dev);
-
-	if (priv->rfkill_mngr.rfkill)
-		rfkill_unregister(priv->rfkill_mngr.rfkill);
-
-	priv->rfkill_mngr.input_dev = NULL;
-	priv->rfkill_mngr.rfkill = NULL;
+	priv->rfkill = NULL;
 }

 /* set rf-kill to the right state. */
 void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv)
 {

-	if (!priv->rfkill_mngr.rfkill)
+	if (!priv->rfkill)
+		return;
+
+	if (iwl3945_is_rfkill_hw(priv)) {
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
 		return;
+	}

-	if (!iwl3945_is_rfkill(priv))
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	if (!iwl3945_is_rfkill_sw(priv))
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 	else
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_OFF;
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
 }
 #endif

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 60b7a64..7f65d91 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2187,13 +2187,11 @@ static int __iwl4965_up(struct iwl_priv *priv)

 	if (!test_bit(STATUS_IN_SUSPEND, &priv->status) &&
 	    iwl_is_rfkill(priv)) {
-		iwl_rfkill_set_hw_state(priv);
 		IWL_WARNING("Radio disabled by %s RF Kill switch\n",
 		    test_bit(STATUS_RF_KILL_HW, &priv->status) ? "HW" : "SW");
 		return -ENODEV;
 	}

-	iwl_rfkill_set_hw_state(priv);
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);

 	ret = priv->cfg->ops->lib->alloc_shared_mem(priv);
@@ -2330,9 +2328,8 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 				    "Kill switch must be turned off for "
 				    "wireless networking to work.\n");
 	}
-	iwl_rfkill_set_hw_state(priv);
-
 	mutex_unlock(&priv->mutex);
+	iwl_rfkill_set_hw_state(priv);
 }

 static void iwl4965_bg_set_monitor(struct work_struct *work)
@@ -2390,6 +2387,7 @@ static void iwl4965_bg_up(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	__iwl4965_up(priv);
 	mutex_unlock(&priv->mutex);
+	iwl_rfkill_set_hw_state(priv);
 }

 static void iwl4965_bg_restart(struct work_struct *data)
@@ -2604,6 +2602,8 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)

 	mutex_unlock(&priv->mutex);

+	iwl_rfkill_set_hw_state(priv);
+
 	if (ret)
 		goto out_release_irq;
