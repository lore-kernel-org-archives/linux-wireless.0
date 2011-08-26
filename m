Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1HZGx0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/60] iwlagn: debug_level moves to struct iwl_shared
Date: Thu, 25 Aug 2011 23:10:38 -0700
Message-Id: <1314339092-20797-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085537_977740_62568875)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow all the modules to look at it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   10 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.c          |   10 ++++----
 drivers/net/wireless/iwlwifi/iwl-debug.h         |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   29 ----------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   28 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |    6 ++--
 7 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 39e7bdb..637c542 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -474,7 +474,7 @@ static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_shared *shrd = dev_get_drvdata(d);
-	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(shrd->priv));
+	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(shrd));
 }
 static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
@@ -489,9 +489,9 @@ static ssize_t store_debug_level(struct device *d,
 	if (ret)
 		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
 	else {
-		priv->debug_level = val;
+		shrd->dbg_level_dev = val;
 		if (iwl_alloc_traffic_mem(priv))
-			IWL_ERR(priv,
+			IWL_ERR(shrd->priv,
 				"Not enough memory to generate traffic log\n");
 	}
 	return strnlen(buf, count);
@@ -1621,7 +1621,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
+	if (!(iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
 			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
 #else
@@ -1641,7 +1641,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		if (!*buf)
 			return -ENOMEM;
 	}
-	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
+	if ((iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS) || full_log) {
 		/*
 		 * if uCode has wrapped back to top of log,
 		 * start at the oldest entry,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6c11f0d..2b3d052 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -931,7 +931,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	iwl_dump_fh(priv, NULL, false);
 	iwl_dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
+	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
 		iwl_print_rx_config_cmd(priv,
 					&priv->contexts[IWL_RXON_CTX_BSS]);
 #endif
@@ -1397,7 +1397,7 @@ int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 {
 	u32 traffic_size = IWL_TRAFFIC_DUMP_SIZE;
 
-	if (iwl_get_debug_level(priv) & IWL_DL_TX) {
+	if (iwl_get_debug_level(priv->shrd) & IWL_DL_TX) {
 		if (!priv->tx_traffic) {
 			priv->tx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1405,7 +1405,7 @@ int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 				return -ENOMEM;
 		}
 	}
-	if (iwl_get_debug_level(priv) & IWL_DL_RX) {
+	if (iwl_get_debug_level(priv->shrd) & IWL_DL_RX) {
 		if (!priv->rx_traffic) {
 			priv->rx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1432,7 +1432,7 @@ void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_TX)))
+	if (likely(!(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)))
 		return;
 
 	if (!priv->tx_traffic)
@@ -1456,7 +1456,7 @@ void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_RX)))
+	if (likely(!(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)))
 		return;
 
 	if (!priv->rx_traffic)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 0869eaa..225ae72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -45,7 +45,7 @@ do {									\
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG(__priv, level, fmt, args...)				\
 do {									\
-	if (iwl_get_debug_level(__priv) & (level))					\
+	if (iwl_get_debug_level(__priv->shrd) & (level))		\
 		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
 			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			__func__ , ## args);				\
@@ -53,7 +53,7 @@ do {									\
 
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)			\
 do {									\
-	if ((iwl_get_debug_level(__priv) & (level)) && net_ratelimit())		\
+	if ((iwl_get_debug_level(__priv->shrd) & (level)) && net_ratelimit())\
 		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
 			"%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			 __func__ , ## args);				\
@@ -61,7 +61,7 @@ do {									\
 
 #define iwl_print_hex_dump(priv, level, p, len) 			\
 do {                                            			\
-	if (iwl_get_debug_level(priv) & level) 				\
+	if (iwl_get_debug_level(priv->shrd) & level)			\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 08fc2b2..c798c68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -915,7 +915,8 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 				"q[%d]: read_ptr: %u, write_ptr: %u\n",
 				cnt, q->read_ptr, q->write_ptr);
 	}
-	if (priv->tx_traffic && (iwl_get_debug_level(priv) & IWL_DL_TX)) {
+	if (priv->tx_traffic &&
+		(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)) {
 		ptr = priv->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Tx Traffic idx: %u\n",	priv->tx_traffic_idx);
@@ -938,7 +939,8 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 			"read: %u, write: %u\n",
 			 rxq->read, rxq->write);
 
-	if (priv->rx_traffic && (iwl_get_debug_level(priv) & IWL_DL_RX)) {
+	if (priv->rx_traffic &&
+		(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)) {
 		ptr = priv->rx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Rx Traffic idx: %u\n",	priv->rx_traffic_idx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 85295b0..e01caf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1514,12 +1514,6 @@ struct iwl_priv {
 	s8 tx_power_lmt_in_half_dbm; /* max tx power in half-dBm format */
 	s8 tx_power_next;
 
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	/* debugging info */
-	u32 debug_level; /* per device debugging will override global
-			    iwlagn_mod_params.debug_level if set */
-#endif /* CONFIG_IWLWIFI_DEBUG */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
 	u16 tx_traffic_idx;
@@ -1569,29 +1563,6 @@ static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 
 extern struct iwl_mod_params iwlagn_mod_params;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-/*
- * iwl_get_debug_level: Return active debug level for device
- *
- * Using sysfs it is possible to set per device debug level. This debug
- * level will be used if set, otherwise the global debug level which can be
- * set via module parameter is used.
- */
-static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
-{
-	if (priv->debug_level)
-		return priv->debug_level;
-	else
-		return iwlagn_mod_params.debug_level;
-}
-#else
-static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
-{
-	return iwlagn_mod_params.debug_level;
-}
-#endif
-
-
 static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
 							 int txq_id, int idx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 32744a7..a7c0315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -93,10 +93,16 @@ struct iwl_mod_params {
 /**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
+ * @dbg_level_dev: dbg level set per device. Prevails on
+ *	iwlagn_mod_params.debug_level if set (!= 0)
  * @bus: pointer to the bus layer data
  * @priv: pointer to the upper layer data
  */
 struct iwl_shared {
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 dbg_level_dev;
+#endif /* CONFIG_IWLWIFI_DEBUG */
+
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
 };
@@ -105,6 +111,28 @@ struct iwl_shared {
 #define priv(_m)	((_m)->shrd->priv)
 #define bus(_m)		((_m)->shrd->bus)
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+/*
+ * iwl_get_debug_level: Return active debug level for device
+ *
+ * Using sysfs it is possible to set per device debug level. This debug
+ * level will be used if set, otherwise the global debug level which can be
+ * set via module parameter is used.
+ */
+static inline u32 iwl_get_debug_level(struct iwl_shared *shrd)
+{
+	if (shrd->dbg_level_dev)
+		return shrd->dbg_level_dev;
+	else
+		return iwlagn_mod_params.debug_level;
+}
+#else
+static inline u32 iwl_get_debug_level(struct iwl_shared *shrd)
+{
+	return iwlagn_mod_params.debug_level;
+}
+#endif
+
 #ifdef CONFIG_PM
 int iwl_suspend(struct iwl_priv *priv);
 int iwl_resume(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 4748602..846db8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -515,7 +515,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	inta = priv->inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
+	if (iwl_get_debug_level(priv->shrd) & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
@@ -544,7 +544,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv->shrd) & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
@@ -845,7 +845,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(priv->shrd) & (IWL_DL_ISR)) {
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
-- 
1.7.0.4

