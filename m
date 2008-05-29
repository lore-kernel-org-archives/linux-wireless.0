Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbYE2IhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/43] iwlwifi: use uCode error and event tables pointer w.r.t loaded image
Date: Thu, 29 May 2008 16:34:48 +0800
Message-Id: <1212050128-17132-4-git-send-email-yi.zhu@intel.com> (sfid-20080529_103717_162839_276EF32A)
In-Reply-To: <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
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

