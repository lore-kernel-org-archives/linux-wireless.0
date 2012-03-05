Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000Ab2CEUiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 12/33] iwlwifi: remove per-device debug level
Date: Mon,  5 Mar 2012 11:24:30 -0800
Message-Id: <1330975491-19680-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213849_122739_64DBE98A)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the per-device debug
level that we expose in debugfs since the
module parameter is writable in sysfs.

At the same time, simplify code by changing
    iwl_get_debug_level(shrd) & IWL_DL_ISR)
to
    iwl_have_debug_level(IWL_DL_ISR)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c          |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h         |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   55 +---------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   27 +----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   10 ++--
 6 files changed, 22 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 275e089..67c82a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -836,7 +836,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	unsigned long reload_jiffies;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
+	if (iwl_have_debug_level(IWL_DL_FW_ERRORS))
 		iwl_print_rx_config_cmd(priv, IWL_RXON_CTX_BSS);
 #endif
 
@@ -1004,7 +1004,7 @@ int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 {
 	u32 traffic_size = IWL_TRAFFIC_DUMP_SIZE;
 
-	if (iwl_get_debug_level(priv->shrd) & IWL_DL_TX) {
+	if (iwl_have_debug_level(IWL_DL_TX)) {
 		if (!priv->tx_traffic) {
 			priv->tx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1012,7 +1012,7 @@ int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 				return -ENOMEM;
 		}
 	}
-	if (iwl_get_debug_level(priv->shrd) & IWL_DL_RX) {
+	if (iwl_have_debug_level(IWL_DL_RX)) {
 		if (!priv->rx_traffic) {
 			priv->rx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1039,7 +1039,7 @@ void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)))
+	if (likely(!iwl_have_debug_level(IWL_DL_TX)))
 		return;
 
 	if (!priv->tx_traffic)
@@ -1063,7 +1063,7 @@ void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)))
+	if (likely(!iwl_have_debug_level(IWL_DL_RX)))
 		return;
 
 	if (!priv->rx_traffic)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
index 4bc2e70..059efab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
@@ -104,7 +104,7 @@ void __iwl_err(struct device *dev, bool rfkill_prefix, bool trace_only,
 }
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
-void __iwl_dbg(struct iwl_shared *shared, struct device *dev,
+void __iwl_dbg(struct device *dev,
 	       u32 level, bool limit, const char *function,
 	       const char *fmt, ...)
 {
@@ -116,7 +116,7 @@ void __iwl_dbg(struct iwl_shared *shared, struct device *dev,
 	va_start(args, fmt);
 	vaf.va = &args;
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(shared) & level &&
+	if (iwl_have_debug_level(level) &&
 	    (!limit || net_ratelimit()))
 		dev_err(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
 			function, &vaf);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 01b2330..163d259 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -47,12 +47,12 @@ void __iwl_crit(struct device *dev, const char *fmt, ...);
 #define IWL_CRIT(m, f, a...) __iwl_crit(trans(m)->dev, f, ## a)
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
-void __iwl_dbg(struct iwl_shared *shared, struct device *dev,
+void __iwl_dbg(struct device *dev,
 	       u32 level, bool limit, const char *function,
 	       const char *fmt, ...);
 #else
 static inline void
-__iwl_dbg(struct iwl_shared *shared, struct device *dev,
+__iwl_dbg(struct device *dev,
 	  u32 level, bool limit, const char *function,
 	  const char *fmt, ...)
 {}
@@ -65,14 +65,14 @@ do {									\
 } while (0)
 
 #define IWL_DEBUG(m, level, fmt, args...)				\
-	__iwl_dbg((m)->shrd, trans(m)->dev, level, false, __func__, fmt, ##args)
+	__iwl_dbg(trans(m)->dev, level, false, __func__, fmt, ##args)
 #define IWL_DEBUG_LIMIT(m, level, fmt, args...)				\
-	__iwl_dbg((m)->shrd, trans(m)->dev, level, true, __func__, fmt, ##args)
+	__iwl_dbg(trans(m)->dev, level, true, __func__, fmt, ##args)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define iwl_print_hex_dump(m, level, p, len)				\
 do {                                            			\
-	if (iwl_get_debug_level((m)->shrd) & level)			\
+	if (iwl_have_debug_level(level))				\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
@@ -82,7 +82,7 @@ do {									\
 		IWL_ERR(m, fmt, ##args);				\
 	else								\
 		__iwl_err(trans(m)->dev, true,				\
-			  !(iwl_get_debug_level((m)->shrd) & IWL_DL_RADIO),\
+			  !iwl_have_debug_level(IWL_DL_RADIO),		\
 			  fmt, ##args);					\
 } while (0)
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 628af56..dd502e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -845,8 +845,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 		IWL_ERR(priv, "Can not allocate buffer\n");
 		return -ENOMEM;
 	}
-	if (priv->tx_traffic &&
-		(iwl_get_debug_level(priv->shrd) & IWL_DL_TX)) {
+	if (priv->tx_traffic && iwl_have_debug_level(IWL_DL_TX)) {
 		ptr = priv->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Tx Traffic idx: %u\n", priv->tx_traffic_idx);
@@ -864,8 +863,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 		}
 	}
 
-	if (priv->rx_traffic &&
-		(iwl_get_debug_level(priv->shrd) & IWL_DL_RX)) {
+	if (priv->rx_traffic && iwl_have_debug_level(IWL_DL_RX)) {
 		ptr = priv->rx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Rx Traffic idx: %u\n", priv->rx_traffic_idx);
@@ -2507,52 +2505,6 @@ DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
 DEBUGFS_WRITE_FILE_OPS(echo_test);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static ssize_t iwl_dbgfs_debug_level_read(struct file *file,
-					  char __user *user_buf,
-					  size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	struct iwl_shared *shrd = priv->shrd;
-	char buf[11];
-	int len;
-
-	len = scnprintf(buf, sizeof(buf), "0x%.8x",
-			iwl_get_debug_level(shrd));
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t iwl_dbgfs_debug_level_write(struct file *file,
-					   const char __user *user_buf,
-					   size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	struct iwl_shared *shrd = priv->shrd;
-	char buf[11];
-	unsigned long val;
-	int ret;
-
-	if (count > sizeof(buf))
-		return -EINVAL;
-
-	memset(buf, 0, sizeof(buf));
-	if (copy_from_user(buf, user_buf, count))
-		return -EFAULT;
-
-	ret = strict_strtoul(buf, 0, &val);
-	if (ret)
-		return ret;
-
-	shrd->dbg_level_dev = val;
-	if (iwl_alloc_traffic_mem(priv))
-		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
-
-	return count;
-}
-DEBUGFS_READ_WRITE_FILE_OPS(debug_level);
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
 /*
  * Create the debugfs files and directories
  *
@@ -2617,9 +2569,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(echo_test, dir_debug, S_IWUSR);
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
-#ifdef CONFIG_IWLWIFI_DEBUG
-	DEBUGFS_ADD_FILE(debug_level, dir_debug, S_IRUSR | S_IWUSR);
-#endif
 
 	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 			 &priv->disable_sens_cal);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 7720fc3..239dfbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -346,8 +346,6 @@ struct iwl_cfg {
 /**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
- * @dbg_level_dev: dbg level set per device. Prevails on
- *	iwlagn_mod_params.debug_level if set (!= 0)
  * @ucode_owner: IWL_OWNERSHIP_*
  * @cmd_queue: command queue number
  * @status: STATUS_*
@@ -370,10 +368,6 @@ struct iwl_cfg {
  * @device_pointers: pointers to ucode event tables
  */
 struct iwl_shared {
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u32 dbg_level_dev;
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
 #define IWL_OWNERSHIP_DRIVER	0
 #define IWL_OWNERSHIP_TM	1
 	u8 ucode_owner;
@@ -417,27 +411,10 @@ struct iwl_shared {
 #define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-/*
- * iwl_get_debug_level: Return active debug level for device
- *
- * Using sysfs it is possible to set per device debug level. This debug
- * level will be used if set, otherwise the global debug level which can be
- * set via module parameter is used.
- */
-static inline u32 iwl_get_debug_level(struct iwl_shared *shrd)
-{
-	if (shrd->dbg_level_dev)
-		return shrd->dbg_level_dev;
-	else
-		return iwlagn_mod_params.debug_level;
-}
-#else
-static inline u32 iwl_get_debug_level(struct iwl_shared *shrd)
+static inline bool iwl_have_debug_level(u32 level)
 {
-	return iwlagn_mod_params.debug_level;
+	return iwlagn_mod_params.debug_level & level;
 }
-#endif
 
 static inline void iwl_free_pages(struct iwl_shared *shrd, unsigned long page)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 2c910fd..6495945 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -881,7 +881,7 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) && !full_log)
+	if (!(iwl_have_debug_level(IWL_DL_FW_ERRORS)) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
 			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
 #else
@@ -901,7 +901,7 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 		if (!*buf)
 			return -ENOMEM;
 	}
-	if ((iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) || full_log) {
+	if (iwl_have_debug_level(IWL_DL_FW_ERRORS) || full_log) {
 		/*
 		 * if uCode has wrapped back to top of log,
 		 * start at the oldest entry,
@@ -960,7 +960,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	inta = trans_pcie->inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & IWL_DL_ISR) {
+	if (iwl_have_debug_level(IWL_DL_ISR)) {
 		/* just for debug */
 		inta_mask = iwl_read32(trans, CSR_INT_MASK);
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
@@ -989,7 +989,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
+	if (iwl_have_debug_level(IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(trans, "Scheduler finished to transmit "
@@ -1301,7 +1301,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
+	if (iwl_have_debug_level(IWL_DL_ISR)) {
 		inta_fh = iwl_read32(trans, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
-- 
1.7.0.4

