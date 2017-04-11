Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50668 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753029AbdDKMjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Golan Ben-Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:37 +0300
Message-Id: <20170411123742.12214-21-luca@coelho.fi> (sfid-20170411_144107_296843_09364D34)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: mvm: support MFUART dump in case of MFUART assert
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

In case of a MFUART assert, get a notification from the fw
that consists of the assert id and debug data.

The notification may be divided to multiple chunks, depending
on the size of the debug data sent to the driver, which would
be up to 1KB.

Get the notification, and if the debug info flag is enabled,
print the debug data to the dmesg.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 26 ++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 24 ++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    |  9 +++++++++
 4 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 248373a0990a..dd2bd7c3587c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -345,9 +345,10 @@ enum iwl_regulatory_and_nvm_subcmd_ids {
 	NVM_ACCESS_COMPLETE = 0x0,
 };
 
-enum iwl_fmac_debug_cmds {
+enum iwl_debug_cmds {
 	LMAC_RD_WR = 0x0,
 	UMAC_RD_WR = 0x1,
+	MFU_ASSERT_DUMP_NTF = 0xFE,
 };
 
 /* command groups */
@@ -1239,6 +1240,25 @@ struct iwl_mfuart_load_notif {
 } __packed; /*MFU_LOADER_NTFY_API_S_VER_2*/
 
 /**
+ * struct iwl_mfu_assert_dump_notif - mfuart dump logs
+ * ( MFU_ASSERT_DUMP_NTF = 0xfe )
+ * @assert_id: mfuart assert id that cause the notif
+ * @curr_reset_num: number of asserts since uptime
+ * @index_num: current chunk id
+ * @parts_num: total number of chunks
+ * @data_size: number of data bytes sent
+ * @data: data buffer
+ */
+struct iwl_mfu_assert_dump_notif {
+	__le32   assert_id;
+	__le32   curr_reset_num;
+	__le16   index_num;
+	__le16   parts_num;
+	__le32   data_size;
+	__le32   data[0];
+} __packed; /*MFU_DUMP_ASSERT_API_S_VER_1*/
+
+/**
  * struct iwl_set_calib_default_cmd - set default value for calibration.
  * ( SET_CALIB_DEFAULT_CMD = 0x8e )
  * @calib_index: the calibration to set value for
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 45cb4f476e76..286f18609729 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -271,6 +272,27 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 	return 0;
 }
 
+void iwl_mvm_mfu_assert_dump_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mfu_assert_dump_notif *mfu_dump_notif = (void *)pkt->data;
+	__le32 *dump_data = mfu_dump_notif->data;
+	int n_words = le32_to_cpu(mfu_dump_notif->data_size) / sizeof(__le32);
+	int i;
+
+	if (mfu_dump_notif->index_num == 0)
+		IWL_INFO(mvm, "MFUART assert id 0x%x occurred\n",
+			 le32_to_cpu(mfu_dump_notif->assert_id));
+
+	for (i = 0; i < n_words; i++)
+		IWL_DEBUG_INFO(mvm,
+			       "MFUART assert dump, dword %u: 0x%08x\n",
+			       le16_to_cpu(mfu_dump_notif->index_num) *
+			       n_words + i,
+			       le32_to_cpu(dump_data[i]));
+}
+
 static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 				   const struct fw_img *image)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b58ac2aa9999..b3f67fe98203 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1395,6 +1395,8 @@ int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
 void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			    int queue);
 void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_mfu_assert_dump_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 				   struct iwl_rx_cmd_buffer *rxb);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 600af8a31200..72afccfe4282 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -302,6 +302,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   RX_HANDLER_SYNC),
 	RX_HANDLER(TOF_NOTIFICATION, iwl_mvm_tof_resp_handler,
 		   RX_HANDLER_ASYNC_LOCKED),
+	RX_HANDLER_GRP(DEBUG_GROUP, MFU_ASSERT_DUMP_NTF,
+		       iwl_mvm_mfu_assert_dump_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(PROT_OFFLOAD_GROUP, STORED_BEACON_NTF,
 		       iwl_mvm_rx_stored_beacon_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(DATA_PATH_GROUP, MU_GROUP_MGMT_NOTIF,
@@ -463,6 +465,13 @@ static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 /* Please keep this array *SORTED* by hex value.
  * Access is done through binary search
  */
+static const struct iwl_hcmd_names iwl_mvm_debug_names[] = {
+	HCMD_NAME(MFU_ASSERT_DUMP_NTF),
+};
+
+/* Please keep this array *SORTED* by hex value.
+ * Access is done through binary search
+ */
 static const struct iwl_hcmd_names iwl_mvm_prot_offload_names[] = {
 	HCMD_NAME(STORED_BEACON_NTF),
 };
-- 
2.11.0
