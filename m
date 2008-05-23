Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759406AbYEWCLh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: move iwl_dump_nic_error_log to iwlcore module
Date: Fri, 23 May 2008 10:09:05 +0800
Message-Id: <1211508569-3163-28-git-send-email-yi.zhu@intel.com> (sfid-20080523_042834_839170_27AB91E6)
In-Reply-To: <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch moves the function iwl_dump_nic_error_log to iwlcore.
Remove sysfs entry it cannot be really triggered.

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   72 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   87 +--------------------------
 3 files changed, 74 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7e25ca4..785396f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1056,6 +1056,78 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_verify_ucode);
 
 
+static const char *desc_lookup(int i)
+{
+	switch (i) {
+	case 1:
+		return "FAIL";
+	case 2:
+		return "BAD_PARAM";
+	case 3:
+		return "BAD_CHECKSUM";
+	case 4:
+		return "NMI_INTERRUPT";
+	case 5:
+		return "SYSASSERT";
+	case 6:
+		return "FATAL_ERROR";
+	}
+
+	return "UNKNOWN";
+}
+
+#define ERROR_START_OFFSET  (1 * sizeof(u32))
+#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
+
+void iwl_dump_nic_error_log(struct iwl_priv *priv)
+{
+	u32 data2, line;
+	u32 desc, time, count, base, data1;
+	u32 blink1, blink2, ilink1, ilink2;
+	int rc;
+
+	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
+
+	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
+		return;
+	}
+
+	rc = iwl_grab_nic_access(priv);
+	if (rc) {
+		IWL_WARNING("Can not read from adapter at this time.\n");
+		return;
+	}
+
+	count = iwl_read_targ_mem(priv, base);
+
+	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
+		IWL_ERROR("Start IWL Error Log Dump:\n");
+		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
+	}
+
+	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
+	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
+	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
+	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
+	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
+	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
+	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
+	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
+
+	IWL_ERROR("Desc        Time       "
+		"data1      data2      line\n");
+	IWL_ERROR("%-13s (#%d) %010u 0x%08X 0x%08X %u\n",
+		desc_lookup(desc), desc, time, data1, data2, line);
+	IWL_ERROR("blink1  blink2  ilink1  ilink2\n");
+	IWL_ERROR("0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
+		ilink1, ilink2);
+
+	iwl_release_nic_access(priv);
+}
+EXPORT_SYMBOL(iwl_dump_nic_error_log);
+
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a8d062f..e75bf34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -238,6 +238,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 ******************************************************/
 void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 			 u32 num_events, u32 mode);
+void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 48c59cb..038eea0 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2621,76 +2621,6 @@ static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
 	IWL_DEBUG_ISR("Disabled interrupts\n");
 }
 
-static const char *desc_lookup(int i)
-{
-	switch (i) {
-	case 1:
-		return "FAIL";
-	case 2:
-		return "BAD_PARAM";
-	case 3:
-		return "BAD_CHECKSUM";
-	case 4:
-		return "NMI_INTERRUPT";
-	case 5:
-		return "SYSASSERT";
-	case 6:
-		return "FATAL_ERROR";
-	}
-
-	return "UNKNOWN";
-}
-
-#define ERROR_START_OFFSET  (1 * sizeof(u32))
-#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
-
-static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
-{
-	u32 data2, line;
-	u32 desc, time, count, base, data1;
-	u32 blink1, blink2, ilink1, ilink2;
-	int rc;
-
-	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
-
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
-		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
-		return;
-	}
-
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
-		return;
-	}
-
-	count = iwl_read_targ_mem(priv, base);
-
-	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
-		IWL_ERROR("Start IWL Error Log Dump:\n");
-		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
-	}
-
-	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
-	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
-	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
-	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
-	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
-	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
-	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
-	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
-	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
-
-	IWL_ERROR("Desc               Time       "
-		  "data1      data2      line\n");
-	IWL_ERROR("%-13s (#%d) %010u 0x%08X 0x%08X %u\n",
-		  desc_lookup(desc), desc, time, data1, data2, line);
-	IWL_ERROR("blink1  blink2  ilink1  ilink2\n");
-	IWL_ERROR("0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
-		  ilink1, ilink2);
-
-	iwl_release_nic_access(priv);
-}
 
 /**
  * iwl4965_irq_handle_error - called for HW or SW error interrupt from card
@@ -2705,7 +2635,7 @@ static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & IWL_DL_FW_ERRORS) {
-		iwl4965_dump_nic_error_log(priv);
+		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
 		iwl4965_print_rx_config_cmd(priv);
 	}
@@ -5529,20 +5459,6 @@ static ssize_t show_status(struct device *d,
 
 static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
-static ssize_t dump_error_log(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	char *p = (char *)buf;
-
-	if (p[0] == '1')
-		iwl4965_dump_nic_error_log((struct iwl_priv *)d->driver_data);
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(dump_errors, S_IWUSR, NULL, dump_error_log);
-
 /*****************************************************************************
  *
  * driver setup and teardown
@@ -5588,7 +5504,6 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 
 static struct attribute *iwl4965_sysfs_entries[] = {
 	&dev_attr_channels.attr,
-	&dev_attr_dump_errors.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
-- 
1.5.3.6

