Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17688 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYFPH71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 03:59:27 -0400
Received: by ug-out-1314.google.com with SMTP id h2so336083ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 00:59:26 -0700 (PDT)
Message-ID: <f6ca9fed0806160059l58286050wfeb6eda938f3a171@mail.gmail.com> (sfid-20080616_095932_636865_25F03EBB)
Date: Mon, 16 Jun 2008 09:59:26 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Dan Williams" <dcbw@redhat.com>
Subject: [PATCH] iwl3945: use rfkill subsystem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
The attached patch removes the sysfs interface from iwl3945 and uses
the rfkill subsystem instead.
(like 4965/5000 already do).

----------------------------
Use the rfkill subsystem instead of the sysfs interface.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a9b3eda..d6711fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -36,6 +36,10 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>

+/*used for rfkill*/
+#include <linux/rfkill.h>
+#include <linux/input.h>
+
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 extern struct pci_device_id iwl3945_hw_card_ids[];

@@ -686,6 +690,23 @@ enum {

 #endif

+#ifdef CONFIG_IWLWIFI_RFKILL
+struct iwl3945_priv;
+
+struct iwl3945_rfkill_mngr {
+	struct rfkill *rfkill;
+	struct input_dev *input_dev;
+};
+
+void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv);
+void iwl3945_rfkill_unregister(struct iwl3945_priv *priv);
+int iwl3945_rfkill_init(struct iwl3945_priv *priv);
+#else
+static inline void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv) {}
+static inline void iwl3945_rfkill_unregister(struct iwl_priv *priv) {}
+static inline int iwl3945_rfkill_init(struct iwl_priv *priv) { return 0; }
+#endif
+
 #define IWL_MAX_NUM_QUEUES IWL39_MAX_NUM_QUEUES

 struct iwl3945_priv {
@@ -779,6 +800,10 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;

+#ifdef CONFIG_IWLWIFI_RFKILL
+	struct iwl3945_rfkill_mngr rfkill_mngr;
+#endif
+
 #ifdef CONFIG_IWL3945_LEDS
 	struct iwl3945_led led[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 47cf4b9..98f13e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6000,11 +6000,13 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	else {
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
+			iwl3945_rfkill_set_hw_state(priv);
 			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
 			return -ENODEV;
 		}
 	}

+	iwl3945_rfkill_set_hw_state(priv);
 	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);

 	rc = iwl3945_hw_nic_init(priv);
@@ -6127,6 +6129,8 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 				    "Kill switch must be turned off for "
 				    "wireless networking to work.\n");
 	}
+
+	iwl3945_rfkill_set_hw_state(priv);
 	mutex_unlock(&priv->mutex);
 }

@@ -7409,37 +7413,6 @@ static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,

 #endif /* CONFIG_IWL3945_DEBUG */

-static ssize_t show_rf_kill(struct device *d,
-			    struct device_attribute *attr, char *buf)
-{
-	/*
-	 * 0 - RF kill not enabled
-	 * 1 - SW based RF kill active (sysfs)
-	 * 2 - HW based RF kill active
-	 * 3 - Both HW and SW based RF kill active
-	 */
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
-	int val = (test_bit(STATUS_RF_KILL_SW, &priv->status) ? 0x1 : 0x0) |
-		  (test_bit(STATUS_RF_KILL_HW, &priv->status) ? 0x2 : 0x0);
-
-	return sprintf(buf, "%i\n", val);
-}
-
-static ssize_t store_rf_kill(struct device *d,
-			     struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
-
-	mutex_lock(&priv->mutex);
-	iwl3945_radio_kill_sw(priv, buf[0] == '1');
-	mutex_unlock(&priv->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(rf_kill, S_IWUSR | S_IRUGO, show_rf_kill, store_rf_kill);
-
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
@@ -7925,7 +7898,6 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 #endif
 	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
-	&dev_attr_rf_kill.attr,
 	&dev_attr_rs_window.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
@@ -8166,6 +8138,11 @@ static int iwl3945_pci_probe(struct pci_dev
*pdev, const struct pci_device_id *e
 	pci_save_state(pdev);
 	pci_disable_device(pdev);

+	err = iwl3945_rfkill_init(priv);
+	if (err)
+		IWL_ERROR("Unable to initialize RFKILL system. "
+				  "Ignoring error: %d\n", err);
+
 	return 0;

  out_free_geos:
@@ -8228,6 +8205,7 @@ static void __devexit iwl3945_pci_remove(struct
pci_dev *pdev)

 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);

+	iwl3945_rfkill_unregister(priv);
 	iwl3945_dealloc_ucode_pci(priv);

 	if (priv->rxq.bd)
@@ -8296,6 +8274,141 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)

 #endif /* CONFIG_PM */

+
+/*************** RFKILL FUNCTIONS **********/
+
+/* software rf-kill from user */
+static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
+{
+	struct iwl3945_priv *priv = data;
+	int err = 0;
+
+	if (!priv->rfkill_mngr.rfkill)
+		return 0;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return 0;
+
+	IWL_DEBUG_RF_KILL("we recieved soft RFKILL set to state %d\n", state);
+	mutex_lock(&priv->mutex);
+
+	switch (state) {
+	case RFKILL_STATE_ON:
+		iwl3945_radio_kill_sw(priv, 0);
+		/* if HW rf-kill is set dont allow ON state */
+		if (iwl3945_is_rfkill(priv))
+			err = -EBUSY;
+		break;
+	case RFKILL_STATE_OFF:
+		iwl3945_radio_kill_sw(priv, 1);
+		if (!iwl3945_is_rfkill(priv))
+			err = -EBUSY;
+		break;
+	}
+	mutex_unlock(&priv->mutex);
+
+	return err;
+}
+
+int iwl3945_rfkill_init(struct iwl3945_priv *priv)
+{
+	struct device *device = wiphy_dev(priv->hw->wiphy);
+	int ret = 0;
+
+	BUG_ON(device == NULL);
+
+	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
+	priv->rfkill_mngr.rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
+	if (!priv->rfkill_mngr.rfkill) {
+		IWL_ERROR("Unable to allocate rfkill device.\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
+	priv->rfkill_mngr.rfkill->data = priv;
+	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	priv->rfkill_mngr.rfkill->toggle_radio = iwl3945_rfkill_soft_rf_kill;
+	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;
+
+	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
+	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
+
+	priv->rfkill_mngr.input_dev = input_allocate_device();
+	if (!priv->rfkill_mngr.input_dev) {
+		IWL_ERROR("Unable to allocate rfkill input device.\n");
+		ret = -ENOMEM;
+		goto freed_rfkill;
+	}
+
+	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
+	priv->rfkill_mngr.input_dev->phys = wiphy_name(priv->hw->wiphy);
+	priv->rfkill_mngr.input_dev->id.bustype = BUS_HOST;
+	priv->rfkill_mngr.input_dev->id.vendor = priv->pci_dev->vendor;
+	priv->rfkill_mngr.input_dev->dev.parent = device;
+	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
+
+	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		goto free_input_dev;
+	}
+
+	ret = input_register_device(priv->rfkill_mngr.input_dev);
+	if (ret) {
+		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
+		goto unregister_rfkill;
+	}
+
+	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
+	return ret;
+
+unregister_rfkill:
+	rfkill_unregister(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+
+free_input_dev:
+	input_free_device(priv->rfkill_mngr.input_dev);
+	priv->rfkill_mngr.input_dev = NULL;
+
+freed_rfkill:
+	if (priv->rfkill_mngr.rfkill != NULL)
+		rfkill_free(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+
+error:
+	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
+	return ret;
+}
+
+void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
+{
+
+	if (priv->rfkill_mngr.input_dev)
+		input_unregister_device(priv->rfkill_mngr.input_dev);
+
+	if (priv->rfkill_mngr.rfkill)
+		rfkill_unregister(priv->rfkill_mngr.rfkill);
+
+	priv->rfkill_mngr.input_dev = NULL;
+	priv->rfkill_mngr.rfkill = NULL;
+}
+
+/* set rf-kill to the right state. */
+void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv)
+{
+
+	if (!priv->rfkill_mngr.rfkill)
+		return;
+
+	if (!iwl3945_is_rfkill(priv))
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	else
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_OFF;
+}
+
+
 /*****************************************************************************
  *
  * driver and module entry point
