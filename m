Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbZAWVmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:53 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/15] iwlwifi: Remove IWL3945_DEBUG
Date: Fri, 23 Jan 2009 13:45:17 -0800
Message-Id: <1232747123-7261-10-git-send-email-reinette.chatre@intel.com> (sfid-20090123_230903_385657_F2B55E1A)
In-Reply-To: <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

IWL3945_DEBUG is pointless and obsolete. We already have an IWLWIFI_DEBUG
symbol, that needs to be set if we actually want to get 3945 debug (see
iwl-debug.h).
Thus, we can simply get rid of this symbol.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   29 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   22 ++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   30 +++++++++++++-------------
 4 files changed, 31 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index f38130a..7b3bad1 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -20,7 +20,7 @@ config IWLWIFI_RFKILL
 	depends on IWLCORE
 
 config IWLWIFI_DEBUG
-	bool "Enable full debugging output in iwlagn driver"
+	bool "Enable full debugging output in iwlagn and iwl3945 drivers"
 	depends on IWLCORE
 	---help---
 	  This option will enable debug tracing output for the iwlwifi drivers
@@ -144,30 +144,3 @@ config IWL3945_LEDS
 	depends on IWL3945
 	---help---
 	  This option enables LEDS for the iwl3945 driver.
-
-config IWL3945_DEBUG
-	bool "Enable full debugging output in iwl3945 driver"
-	depends on IWL3945
-	---help---
-	  This option will enable debug tracing output for the iwl3945
-	  driver.
-
-	  This will result in the kernel module being ~100k larger.  You can
-	  control which debug output is sent to the kernel log by setting the
-	  value in
-
-	          /sys/bus/pci/drivers/${DRIVER}/debug_level
-
-	  This entry will only exist if this option is enabled.
-
-	  To set a value, simply echo an 8-byte hex value to the same file:
-
-		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
-
-	  You can find the list of debug mask values in:
-		  drivers/net/wireless/iwlwifi/iwl-3945-debug.h
-
-	  If this is your first time using this driver, you should say Y here
-	  as the debug information can assist others in helping you resolve
-	  any problems you may encounter.
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 75e9553..b9c5cf9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -232,7 +232,7 @@ __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 	return 0;		/* "diversity" is default if error */
 }
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
 static const char *iwl3945_get_tx_fail_reason(u32 status)
@@ -412,7 +412,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *r
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 
 /**
  * iwl3945_report_frame - dump frame to syslog during debug sessions
@@ -421,7 +421,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *r
  * including selective frame dumps.
  * group100 parameter selects whether to show 1 out of 100 good frames.
  */
-static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
+static void _iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
@@ -548,6 +548,15 @@ static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
 	if (print_dump)
 		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
 }
+
+static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
+		      struct iwl_rx_packet *pkt,
+		      struct ieee80211_hdr *header, int group100)
+{
+	if (priv->debug_level & IWL_DL_RX)
+		_iwl3945_dbg_report_frame(priv, pkt, header, group100);
+}
+
 #else
 static inline void iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl_rx_packet *pkt,
@@ -711,11 +720,8 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 			      rx_status.signal, rx_status.signal,
 			      rx_status.noise, rx_status.rate_idx);
 
-#ifdef CONFIG_IWL3945_DEBUG
-	if (priv->debug_level & (IWL_DL_RX))
-		/* Set "1" to report good data frames in groups of 100 */
-		iwl3945_dbg_report_frame(priv, pkt, header, 1);
-#endif
+	/* Set "1" to report good data frames in groups of 100 */
+	iwl3945_dbg_report_frame(priv, pkt, header, 1);
 
 	if (network_packet) {
 		priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d4e0778..5dbab76 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1059,7 +1059,7 @@ struct iwl_priv {
 	s8 tx_power_channel_lmt;
 
 
-#if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWL3945_DEBUG)
+#ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
 	u32 debug_level;
 	u32 framecnt_to_us;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5fa5cb2..d832cb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -63,7 +63,7 @@
 #define DRV_DESCRIPTION	\
 "Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux"
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 #define VD "d"
 #else
 #define VD
@@ -1503,7 +1503,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	fc = hdr->frame_control;
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
@@ -2045,7 +2045,7 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl_priv *priv,
 static void iwl3945_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -2092,7 +2092,7 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
@@ -2115,7 +2115,7 @@ static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl3945_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
@@ -2788,7 +2788,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	iwl3945_rx_queue_restock(priv);
 }
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl3945_print_rx_config_cmd(struct iwl_priv *priv,
 					struct iwl3945_rxon_cmd *rxon)
 {
@@ -3028,7 +3028,7 @@ static void iwl3945_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & IWL_DL_FW_ERRORS) {
 		iwl3945_dump_nic_error_log(priv);
 		iwl3945_dump_nic_event_log(priv);
@@ -3077,7 +3077,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -3095,7 +3095,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -3129,7 +3129,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		return;
 	}
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
@@ -3200,7 +3200,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl3945_enable_interrupts(priv);
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -5414,7 +5414,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -5450,7 +5450,7 @@ static ssize_t store_debug_level(struct device *d,
 static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 			show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWL3945_DEBUG */
+#endif /* CONFIG_IWLWIFI_DEBUG */
 
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -5930,7 +5930,7 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	&dev_attr_debug_level.attr,
 #endif
 	NULL
@@ -6082,7 +6082,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
 
-#ifdef CONFIG_IWL3945_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	priv->debug_level = iwl3945_mod_params.debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
-- 
1.5.4.3

