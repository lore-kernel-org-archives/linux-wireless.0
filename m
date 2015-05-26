Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbbEZTSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:34 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/39] iwlwifi: mvm: add UMAC scan iteration complete notification
Date: Tue, 26 May 2015 22:17:32 +0300
Message-Id: <1432667872-18092-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213348_737916_9EF19B8B)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add UMAC scan iteration complete notification. This notification can
be enabled by setting scan_iter_notif_enabled through debugfs.
Upon receiving this notification, print the list of channels that
have been scanned in this iteration. This is useful for debugging.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |  5 +++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  3 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  3 +++
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 21 +++++++++++++++++++++
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index be1a0a1..0228693 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -837,4 +837,27 @@ struct iwl_scan_offload_profiles_query {
 	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES];
 } __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_2 */
 
+/**
+ * struct iwl_umac_scan_iter_complete_notif - notifies end of scanning iteration
+ * @uid: scan id, &enum iwl_umac_scan_uid_offsets
+ * @scanned_channels: number of channels scanned and number of valid elements in
+ *	results array
+ * @status: one of SCAN_COMP_STATUS_*
+ * @bt_status: BT on/off status
+ * @last_channel: last channel that was scanned
+ * @tsf_low: TSF timer (lower half) in usecs
+ * @tsf_high: TSF timer (higher half) in usecs
+ * @results: array of scan results, only "scanned_channels" of them are valid
+ */
+struct iwl_umac_scan_iter_complete_notif {
+	__le32 uid;
+	u8 scanned_channels;
+	u8 status;
+	u8 bt_status;
+	u8 last_channel;
+	__le32 tsf_low;
+	__le32 tsf_high;
+	struct iwl_scan_results_notif results[];
+} __packed; /* SCAN_ITER_COMPLETE_NTF_UMAC_API_S_VER_1 */
+
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 56db2ba..0ed7675 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -108,6 +108,7 @@ enum {
 	ANTENNA_COUPLING_NOTIFICATION = 0xa,
 
 	/* UMAC scan commands */
+	SCAN_ITERATION_COMPLETE_UMAC = 0xb5,
 	SCAN_CFG_CMD = 0xc,
 	SCAN_REQ_UMAC = 0xd,
 	SCAN_ABORT_UMAC = 0xe,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index dde83ef..d4e0cab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1150,6 +1150,9 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm);
 int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 					struct iwl_rx_cmd_buffer *rxb,
 					struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					     struct iwl_rx_cmd_buffer *rxb,
+					     struct iwl_device_cmd *cmd);
 
 /* MVM debugfs */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 534a9fd..4935caf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -245,6 +245,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   false),
 	RX_HANDLER(SCAN_COMPLETE_UMAC, iwl_mvm_rx_umac_scan_complete_notif,
 		   true),
+	RX_HANDLER(SCAN_ITERATION_COMPLETE_UMAC,
+		   iwl_mvm_rx_umac_scan_iter_complete_notif, false),
 
 	RX_HANDLER(CARD_STATE_NOTIFICATION, iwl_mvm_rx_card_state_notif, false),
 
@@ -356,6 +358,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(TDLS_CHANNEL_SWITCH_NOTIFICATION),
 	CMD(TDLS_CONFIG_CMD),
 	CMD(MCC_UPDATE_CMD),
+	CMD(SCAN_ITERATION_COMPLETE_UMAC),
 };
 #undef CMD
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index e859584..81ea9f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1181,6 +1181,10 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (iwl_mvm_scan_total_iterations(params) > 1)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvm->scan_iter_notif_enabled)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE;
+#endif
 	return flags;
 }
 
@@ -1522,6 +1526,23 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
+int iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					     struct iwl_rx_cmd_buffer *rxb,
+					     struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_umac_scan_iter_complete_notif *notif = (void *)pkt->data;
+	u8 buf[256];
+
+	IWL_DEBUG_SCAN(mvm,
+		       "UMAC Scan iteration complete: status=0x%x scanned_channels=%d channels list: %s\n",
+		       notif->status, notif->scanned_channels,
+		       iwl_mvm_dump_channel_list(notif->results,
+						 notif->scanned_channels, buf,
+						 sizeof(buf)));
+	return 0;
+}
+
 static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
 				     struct iwl_rx_packet *pkt, void *data)
 {
-- 
2.1.4

