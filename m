Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759650AbYEWCLk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:40 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: use uCode error and event tables pointer w.r.t loaded image
Date: Fri, 23 May 2008 10:09:07 +0800
Message-Id: <1211508569-3163-30-git-send-email-yi.zhu@intel.com> (sfid-20080523_042834_582951_901E54E8)
In-Reply-To: <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
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
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch updates the usage of the pointers to error and log tables
received in alive response w.r.t. the current uCode image.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 785396f..373e984 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1084,17 +1084,20 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 data2, line;
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
-	int rc;
+	int ret;
 
-	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
 		return;
 	}
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
@@ -1146,8 +1149,10 @@ void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	if (num_events == 0)
 		return;
-
-	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 
 	if (mode == 0)
 		event_size = 2 * sizeof(u32);
@@ -1177,7 +1182,7 @@ EXPORT_SYMBOL(iwl_print_event_log);
 
 void iwl_dump_nic_event_log(struct iwl_priv *priv)
 {
-	int rc;
+	int ret;
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
 	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
@@ -1185,14 +1190,18 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	u32 next_entry; /* index of next entry to be written by uCode */
 	u32 size;       /* # entries that we'll print */
 
-	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+	if (priv->ucode_type == UCODE_INIT)
+		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
-- 
1.5.3.6

