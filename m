Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZHGWlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/16] iwlwifi: re-introduce per device debugging
Date: Fri,  7 Aug 2009 15:41:37 -0700
Message-Id: <1249684912-22936-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Commit "iwlwifi: make debug level more user friendly" cleaned up the
debug level handling. In doing so it created a single global debug
level for all devices. Some setups do consits of more that one iwlwifi
device and in these setups there is a requirement that debug levels
should be unique per device.

We now re-introduce the per device debugging while maintaining the
cleanup effort of the previous patch.

The maintain the global debug level and now introduce a per-device debug
level that will be used if it (the per-device debug level) is set. The
per-device debug level can be controlled via the debug_level sysfs file
while the global debug level is controlled by the debug module parameter.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   22 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   11 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   21 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   21 +++++++++++----------
 10 files changed, 63 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e1b0ef3..7ad0207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -502,14 +502,14 @@ static void _iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(IWL_DL_RX, data, length);
+		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
 }
 
 static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
-	if (iwl_debug_level & IWL_DL_RX)
+	if (iwl_get_debug_level(priv) & IWL_DL_RX)
 		_iwl3945_dbg_report_frame(priv, pkt, header, group100);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6702148..62436a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -46,7 +46,7 @@
 #include "iwl-sta.h"
 
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
-static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
+static int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 
 /* Highest firmware API version supported */
 #define IWL4965_UCODE_API_MAX 2
@@ -1680,7 +1680,7 @@ static s32 sign_extend(u32 oper, int index)
  *
  * A return of <0 indicates bogus data in the statistics
  */
-static int iwl4965_hw_get_temperature(const struct iwl_priv *priv)
+static int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 {
 	s32 temperature;
 	s32 vt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index db580cb..24c1ae6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -896,7 +896,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & IWL_DL_ISR) {
+	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -931,7 +931,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -1045,7 +1045,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 		iwl_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
@@ -1076,7 +1076,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	inta = priv->inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & IWL_DL_ISR) {
+	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
@@ -1104,7 +1104,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -2455,15 +2455,15 @@ static int iwl_mac_get_stats(struct ieee80211_hw *hw,
  *
  * See the level definitions in iwl for details.
  *
- * FIXME This file can be deprecated as the module parameter is
- * writable and users can thus also change the debug level
- * using the /sys/module/iwl3945/parameters/debug file.
+ * The debug_level being managed using sysfs below is a per device debug
+ * level that is used instead of the global debug level if it (the per
+ * device debug level) is set.
  */
-
 static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "0x%08X\n", iwl_debug_level);
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(priv));
 }
 static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
@@ -2477,7 +2477,7 @@ static ssize_t store_debug_level(struct device *d,
 	if (ret)
 		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
 	else
-		iwl_debug_level = val;
+		priv->debug_level = val;
 
 	return strnlen(buf, count);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2ffbd27..30f1953 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1278,7 +1278,7 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
 	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
-	iwl_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO(priv, "u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO(priv, "u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO(priv, "u32 filter_flags: 0x%08x\n",
@@ -1508,7 +1508,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
+	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
 		iwl_print_rx_config_cmd(priv);
@@ -1985,7 +1985,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
@@ -2310,7 +2310,7 @@ void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index fbe1776..09af046 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -46,7 +46,7 @@ do {									\
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG(__priv, level, fmt, args...)				\
 do {									\
-	if (iwl_debug_level & (level))					\
+	if (iwl_get_debug_level(__priv) & (level))					\
 		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
 			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			__func__ , ## args);				\
@@ -54,15 +54,15 @@ do {									\
 
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)			\
 do {									\
-	if ((iwl_debug_level & (level)) && net_ratelimit())		\
+	if ((iwl_get_debug_level(__priv) & (level)) && net_ratelimit())		\
 		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
 			"%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			 __func__ , ## args);				\
 } while (0)
 
-#define iwl_print_hex_dump(level, p, len) 				\
+#define iwl_print_hex_dump(priv, level, p, len) 			\
 do {                                            			\
-	if (iwl_debug_level & level)          				\
+	if (iwl_get_debug_level(priv) & level) 				\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
@@ -106,7 +106,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #else
 #define IWL_DEBUG(__priv, level, fmt, args...)
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)
-static inline void iwl_print_hex_dump(int level, void *p, u32 len)
+static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
+				      void *p, u32 len)
 {}
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cab6255..1bf3e4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1175,6 +1175,8 @@ struct iwl_priv {
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
+	u32 debug_level; /* per device debugging will override global
+			    iwl_debug_level if set */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 	bool disable_ht40;
@@ -1211,8 +1213,27 @@ static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_get_tx_fail_reason(u32 status);
+/*
+ * iwl_get_debug_level: Return active debug level for device
+ *
+ * Using sysfs it is possible to set per device debug level. This debug
+ * level will be used if set, otherwise the global debug level which can be
+ * set via module parameter is used.
+ */
+static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
+{
+	if (priv->debug_level)
+		return priv->debug_level;
+	else
+		return iwl_debug_level;
+}
 #else
 static inline const char *iwl_get_tx_fail_reason(u32 status) { return ""; }
+
+static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
+{
+	return iwl_debug_level;
+}
 #endif
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index e002c8b..98f0142 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -645,7 +645,7 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 	u32 tsf_low;
 	int rssi;
 
-	if (likely(!(iwl_debug_level & IWL_DL_RX)))
+	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_RX)))
 		return;
 
 	/* MAC header */
@@ -741,7 +741,7 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(IWL_DL_RX, header, length);
+		iwl_print_hex_dump(priv, IWL_DL_RX, header, length);
 }
 #endif
 
@@ -1060,7 +1060,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 	/* Set "1" to report good data frames in groups of 100 */
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (unlikely(iwl_debug_level & IWL_DL_RX))
+	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
 		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 #endif
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index efcae0d..def1254 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1088,7 +1088,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
 			       "Defaulting to broadcast...\n",
 			       hdr->addr1);
-		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_params.bcast_sta_id;
 
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 288b871..0cac06c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -884,8 +884,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
 	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ea051b7..0babce2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -614,8 +614,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
 	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx->tx_flags));
-	iwl_print_hex_dump(IWL_DL_TX, tx, sizeof(*tx));
-	iwl_print_hex_dump(IWL_DL_TX, (u8 *)tx->hdr,
+	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
 	/*
@@ -1646,7 +1646,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & IWL_DL_ISR) {
+	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -1681,7 +1681,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -1760,7 +1760,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		iwl_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
@@ -3311,14 +3311,15 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
  *
  * See the level definitions in iwl for details.
  *
- * FIXME This file can be deprecated as the module parameter is
- * writable and users can thus also change the debug level
- * using the /sys/module/iwl3945/parameters/debug file.
+ * The debug_level being managed using sysfs below is a per device debug
+ * level that is used instead of the global debug level if it (the per
+ * device debug level) is set.
  */
 static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "0x%08X\n", iwl_debug_level);
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(priv));
 }
 static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
@@ -3332,7 +3333,7 @@ static ssize_t store_debug_level(struct device *d,
 	if (ret)
 		IWL_INFO(priv, "%s is not in hex or decimal form.\n", buf);
 	else
-		iwl_debug_level = val;
+		priv->debug_level = val;
 
 	return strnlen(buf, count);
 }
-- 
1.5.6.3

