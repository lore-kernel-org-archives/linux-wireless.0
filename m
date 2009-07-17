Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40544 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbZGQQad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/14] iwlwifi: make debug level more user friendly
Date: Fri, 17 Jul 2009 09:30:24 -0700
Message-Id: <1247848227-24031-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-11-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

* Deprecate the "debug50" module parameter used to obtain
  5000 series and up debugging. Replace it with "debug" module
  parameter to match with original driver and be consistent
  between them. The "debug50" module parameter can still be used,
  except that the module parameter is not writable in keeping
  with its previous state. We currently just mark it as "deprecated"
  and do not have it in the feature-removal-schedule. Some more
  cleanup of module parameters needs to be done and can then be
  entered together.

* Only make "debug" module parameters visible if the driver
  is compiled with CONFIG_IWLWIFI_DEBUG. This will eliminate
  a lot of confusion where users think they have set debug flags
  but yet cannot see any debug output.

* Make module parameters writable. This eliminates the need for the
  "debug_level" sysfs file, which can now also be deprecated and
  added to feature-removal-schedule. This file is in significant
  use though with many iwlwifi documents and text referring users
  to it. We can thus not take its removal lightly and keep it around.

With iwlcore shared between iwlagn and iwl3945 we really do not need
debug module parameters for each but can instead have one debug
module parameter for the iwlcore module. The same issue is here as
with the sysfs file - a lot of iwlwifi documentation and text (like
bug reports) rely on iwlagn and iwl3945 having this module parameter,
so changing this to a module parameter of iwlcore will have significant
impact and we do not do this for that reason.

One consequence of this patch is that if a user is running a system
with both 3945 and later hardware then the setting of the one module
parameter will affect the value of the other. The likelihood of this
seems low - and even if this setup is present it does not seem like an
issue for both modules to run with the same debug level.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   31 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   11 ++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   12 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   25 ++++++++++++---------
 12 files changed, 55 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 14a47c0..8ee403c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -502,14 +502,14 @@ static void _iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
+		iwl_print_hex_dump(IWL_DL_RX, data, length);
 }
 
 static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
-	if (priv->debug_level & IWL_DL_RX)
+	if (iwl_debug_level & IWL_DL_RX)
 		_iwl3945_dbg_report_frame(priv, pkt, header, group100);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 272409c..c30a1b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2376,8 +2376,6 @@ module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(debug, iwl4965_mod_params.debug, uint, 0444);
-MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(
 	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 74103cf..702db07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1745,8 +1745,6 @@ MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
 module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, 0444);
 MODULE_PARM_DESC(swcrypto50,
 		  "using software crypto engine (default 0 [hardware])\n");
-module_param_named(debug50, iwl50_mod_params.debug, uint, 0444);
-MODULE_PARM_DESC(debug50, "50XX debug output mask");
 module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
 module_param_named(11n_disable50, iwl50_mod_params.disable_11n, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f61f653..ff4a546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -904,7 +904,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & IWL_DL_ISR) {
+	if (iwl_debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -939,7 +939,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & (IWL_DL_ISR)) {
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -1053,7 +1053,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 		iwl_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & (IWL_DL_ISR)) {
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
@@ -1084,7 +1084,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	inta = priv->inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & IWL_DL_ISR) {
+	if (iwl_debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
@@ -1112,7 +1112,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & (IWL_DL_ISR)) {
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -2456,14 +2456,16 @@ static int iwl_mac_get_stats(struct ieee80211_hw *hw,
  * used for controlling the debug level.
  *
  * See the level definitions in iwl for details.
+ *
+ * FIXME This file can be deprecated as the module parameter is
+ * writable and users can thus also change the debug level
+ * using the /sys/module/iwl3945/parameters/debug file.
  */
 
 static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	return sprintf(buf, "0x%08X\n", priv->debug_level);
+	return sprintf(buf, "0x%08X\n", iwl_debug_level);
 }
 static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
@@ -2477,7 +2479,7 @@ static ssize_t store_debug_level(struct device *d,
 	if (ret)
 		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
 	else
-		priv->debug_level = val;
+		iwl_debug_level = val;
 
 	return strnlen(buf, count);
 }
@@ -2829,7 +2831,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
 	if (cfg->mod_params->disable_hw_scan) {
-		if (cfg->mod_params->debug & IWL_DL_INFO)
+		if (iwl_debug_level & IWL_DL_INFO)
 			dev_printk(KERN_DEBUG, &(pdev->dev),
 				   "Disabling hw_scan\n");
 		iwl_hw_ops.hw_scan = NULL;
@@ -2851,7 +2853,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->inta_mask = CSR_INI_SET_MASK;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	priv->debug_level = priv->cfg->mod_params->debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
@@ -3211,3 +3212,11 @@ static void __exit iwl_exit(void)
 
 module_exit(iwl_exit);
 module_init(iwl_init);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+module_param_named(debug50, iwl_debug_level, uint, 0444);
+MODULE_PARM_DESC(debug50, "50XX debug output mask (deprecated)");
+module_param_named(debug, iwl_debug_level, uint, 0644);
+MODULE_PARM_DESC(debug, "debug output mask");
+#endif
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4013549..6989cbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -59,6 +59,9 @@ MODULE_LICENSE("GPL");
 				    IWL_RATE_##pp##M_INDEX,    \
 				    IWL_RATE_##np##M_INDEX }
 
+u32 iwl_debug_level;
+EXPORT_SYMBOL(iwl_debug_level);
+
 static irqreturn_t iwl_isr(int irq, void *data);
 
 /*
@@ -1275,7 +1278,7 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
 	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO(priv, "u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO(priv, "u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO(priv, "u32 filter_flags: 0x%08x\n",
@@ -1302,7 +1305,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & IWL_DL_FW_ERRORS) {
+	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
 		iwl_print_rx_config_cmd(priv);
@@ -1801,7 +1804,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & (IWL_DL_ISR)) {
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
@@ -2314,7 +2317,7 @@ void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 233127d..018030b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -190,7 +190,6 @@ struct iwl_ops {
 
 struct iwl_mod_params {
 	int sw_crypto;		/* def: 0 = using hardware encryption */
-	u32 debug;		/* def: 0 = minimal debug log messages */
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int num_of_ampdu_queues;/* def: HW dependent */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index e4a4dbd..9faf0c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -30,6 +30,7 @@
 #define __iwl_debug_h__
 
 struct iwl_priv;
+extern u32 iwl_debug_level;
 
 #define IWL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
 #define IWL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
@@ -45,7 +46,7 @@ do {									\
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG(__priv, level, fmt, args...)				\
 do {									\
-	if (__priv->debug_level & (level))				\
+	if (iwl_debug_level & (level))					\
 		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
 			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			__func__ , ## args);				\
@@ -53,15 +54,15 @@ do {									\
 
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)			\
 do {									\
-	if ((__priv->debug_level & (level)) && net_ratelimit())		\
+	if ((iwl_debug_level & (level)) && net_ratelimit())		\
 		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
 			"%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			 __func__ , ## args);				\
 } while (0)
 
-#define iwl_print_hex_dump(priv, level, p, len) 			\
+#define iwl_print_hex_dump(level, p, len) 				\
 do {                                            			\
-	if (priv->debug_level & level)          			\
+	if (iwl_debug_level & level)          				\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
@@ -103,8 +104,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #else
 #define IWL_DEBUG(__priv, level, fmt, args...)
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)
-static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
-				      void *p, u32 len)
+static inline void iwl_print_hex_dump(int level, void *p, u32 len)
 {}
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 926df3a..0751891 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1111,7 +1111,6 @@ struct iwl_priv {
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
-	u32 debug_level;
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index fc7edd1..5d5f215 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -646,7 +646,7 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 	u32 tsf_low;
 	int rssi;
 
-	if (likely(!(priv->debug_level & IWL_DL_RX)))
+	if (likely(!(iwl_debug_level & IWL_DL_RX)))
 		return;
 
 	/* MAC header */
@@ -742,7 +742,7 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(priv, IWL_DL_RX, header, length);
+		iwl_print_hex_dump(IWL_DL_RX, header, length);
 }
 #endif
 
@@ -1061,7 +1061,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 	/* Set "1" to report good data frames in groups of 100 */
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (unlikely(priv->debug_level & IWL_DL_RX))
+	if (unlikely(iwl_debug_level & IWL_DL_RX))
 		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 #endif
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index ffd5c61..6f04421 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1094,7 +1094,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
 			       "Defaulting to broadcast...\n",
 			       hdr->addr1);
-		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_params.bcast_sta_id;
 
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7073069..ef7e6bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -869,8 +869,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
 	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+	iwl_print_hex_dump(IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bd6a067..221a875 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -612,8 +612,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
 	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
+	iwl_print_hex_dump(IWL_DL_TX, tx, sizeof(*tx));
+	iwl_print_hex_dump(IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
 	/*
@@ -1644,7 +1644,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & IWL_DL_ISR) {
+	if (iwl_debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -1679,7 +1679,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & (IWL_DL_ISR)) {
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -1758,7 +1758,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		iwl_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & (IWL_DL_ISR)) {
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
@@ -3308,13 +3308,15 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
  * used for controlling the debug level.
  *
  * See the level definitions in iwl for details.
+ *
+ * FIXME This file can be deprecated as the module parameter is
+ * writable and users can thus also change the debug level
+ * using the /sys/module/iwl3945/parameters/debug file.
  */
 static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	return sprintf(buf, "0x%08X\n", priv->debug_level);
+	return sprintf(buf, "0x%08X\n", iwl_debug_level);
 }
 static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
@@ -3328,7 +3330,7 @@ static ssize_t store_debug_level(struct device *d,
 	if (ret)
 		IWL_INFO(priv, "%s is not in hex or decimal form.\n", buf);
 	else
-		priv->debug_level = val;
+		iwl_debug_level = val;
 
 	return strnlen(buf, count);
 }
@@ -3966,7 +3968,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->inta_mask = CSR_INI_SET_MASK;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	priv->debug_level = iwl3945_mod_params.debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
@@ -4262,8 +4263,10 @@ MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(swcrypto, iwl3945_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto,
 		 "using software crypto (default 1 [software])\n");
-module_param_named(debug, iwl3945_mod_params.debug, uint, 0444);
+#ifdef CONFIG_IWLWIFI_DEBUG
+module_param_named(debug, iwl_debug_level, uint, 0644);
 MODULE_PARM_DESC(debug, "debug output mask");
+#endif
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, 0444);
-- 
1.5.6.3

