Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b.mail.sonic.net ([64.142.19.5]:56673 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbYDBG5Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 02:57:25 -0400
From: Jason Riedy <jason@acm.org>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] Make IWLCORE a silent option not to confuse iwl3945 users.
Date: Tue, 01 Apr 2008 23:28:34 -0700
Message-ID: <874pakhist.fsf@sparse.dyndns.org> (sfid-20080402_075728_671212_FF0429BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwl3945 (currently?) does not use iwlcore.  Either the iwlcore
documentation should change or the option should be silent.  This
patch follows the latter route.  IWL4965 already SELECTs IWLCORE,
so there should be no new problems.  Note that IWLWIFI_DEBUGFS and
IWLCORE_RFKILL have no suboptions for 4965, so they are grouped
together and given a description that includes "4965+" to indicate
they're not for the 3945 adapters.

Signed-off-by: Jason Riedy <jason@acm.org>
---
   I don't really know what I'm doing here, but something needs
   done, and my code is better than my exposition right now.  BTW,
   I'm guilty of the same sub-par testing as Intel.  I haven't
   checked compiling the pieces separately, only together.

 drivers/net/wireless/iwlwifi/Kconfig        |   28 ++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   32 +++++++++++++-------------
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 4a5c8c0..09d872e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,19 +1,14 @@
 config IWLCORE
-	tristate "Intel Wireless Wifi Core"
+	tristate
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 
 config IWLWIFI_LEDS
-	bool "Enable LEDS features in iwlwifi driver"
+	bool
 	depends on IWLCORE && MAC80211_LEDS && LEDS_CLASS
-	---help---
-	  This option enables LEDS for the iwlwifi drivers
-
 
-config IWLCORE_RFKILL
-	boolean "IWLWIFI RF kill support"
+config IWLWIFI_DEBUG
+	bool
 	depends on IWLCORE
-	select RFKILL
-	select RFKILL_INPUT
 
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN"
@@ -52,9 +47,10 @@ config IWL4965_HT
 
 config IWL4965_LEDS
 	bool "Enable LEDS features in iwl4965 driver"
-	depends on IWL4965 && IWLWIFI_LEDS
+	depends on IWL4965
+	select IWLWIFI_LEDS
 	---help---
-	  This option enables LEDS for the iwlwifi drivers
+	  This option enables LEDS for the iwl4965 driver.
 
 
 config IWL4965_SPECTRUM_MEASUREMENT
@@ -70,7 +66,7 @@ config IWL4965_SENSITIVITY
 	  This option will enable sensitivity calibration for the iwl4965
 	  driver.
 
-config IWLWIFI_DEBUG
+config IWL4965_DEBUG
 	bool "Enable full debugging output in iwl4965 driver"
 	depends on IWL4965
 	---help---
@@ -96,8 +92,14 @@ config IWLWIFI_DEBUG
 	  as the debug information can assist others in helping you resolve
 	  any problems you may encounter.
 
+config IWLCORE_RFKILL
+	boolean "Iwlwifi (4965+) RF kill support"
+	depends on IWLCORE
+	select RFKILL
+	select RFKILL_INPUT
+
 config IWLWIFI_DEBUGFS
-        bool "Iwlwifi debugfs support"
+        bool "Iwlwifi (4965+) debugfs support"
         depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
         ---help---
 	  Enable creation of debugfs files for the iwlwifi drivers.
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 385ec7a..2bbdf64 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -67,7 +67,7 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link 4965AGN driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 #define VD "d"
 #else
 #define VD
@@ -2363,7 +2363,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
@@ -3335,7 +3335,7 @@ static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
 static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl4965_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -3381,7 +3381,7 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
 static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = iwl4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
@@ -3404,7 +3404,7 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl4965_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_scanreq_notification *notif =
 	    (struct iwl4965_scanreq_notification *)pkt->u.raw;
@@ -4255,7 +4255,7 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 	return rc;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static void iwl4965_print_rx_config_cmd(struct iwl4965_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
@@ -4486,7 +4486,7 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl4965_dump_nic_error_log(priv);
 		iwl4965_dump_nic_event_log(priv);
@@ -4535,7 +4535,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -4553,7 +4553,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -4587,7 +4587,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
@@ -4680,7 +4680,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl4965_enable_interrupts(priv);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -7443,7 +7443,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -7476,7 +7476,7 @@ static ssize_t store_debug_level(struct device_driver *d,
 static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWLWIFI_DEBUG */
+#endif /* CONFIG_IWL4965_DEBUG */
 
 
 static ssize_t show_temperature(struct device *d,
@@ -8035,7 +8035,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	iwl_debug_level = priv->cfg->mod_params->debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
@@ -8333,7 +8333,7 @@ static int __init iwl4965_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		goto error_register;
 	}
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	ret = driver_create_file(&iwl4965_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
@@ -8354,7 +8354,7 @@ error_register:
 
 static void __exit iwl4965_exit(void)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	driver_remove_file(&iwl4965_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl4965_driver);
-- 
1.5.5.rc1.121.g1594

