Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55147 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaGFJge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:34 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so14614276wiv.15
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/40] iwlwifi: rename iwl_fw_error_fw_mon to iwl_fw_error_dump_fw_mon
Date: Sun,  6 Jul 2014 12:35:44 +0300
Message-Id: <1404639376-3792-8-git-send-email-egrumbach@gmail.com> (sfid-20140706_113637_665933_490B9169)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is matches the convention of the other structures.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 4 ++--
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 9fd860f..c39a0b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -147,14 +147,14 @@ struct iwl_fw_error_dump_info {
 } __packed;
 
 /**
- * struct iwl_fw_error_fw_mon - FW monitor data
+ * struct iwl_fw_error_dump_fw_mon - FW monitor data
  * @fw_mon_wr_ptr: the position of the write pointer in the cyclic buffer
  * @fw_mon_base_ptr: base pointer of the data
  * @fw_mon_cycle_cnt: number of wrap arounds
  * @reserved: for future use
  * @data: captured data
  */
-struct iwl_fw_error_fw_mon {
+struct iwl_fw_error_dump_fw_mon {
 	__le32 fw_mon_wr_ptr;
 	__le32 fw_mon_base_ptr;
 	__le32 fw_mon_cycle_cnt;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5703a3d..5b5b0d8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1787,7 +1787,7 @@ static u32 iwl_trans_pcie_dump_data(struct iwl_trans *trans,
 		cmdq->q.n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
 	if (trans_pcie->fw_mon_page)
-		len += sizeof(*data) + sizeof(struct iwl_fw_error_fw_mon) +
+		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
 			trans_pcie->fw_mon_size;
 
 	if (!buf)
@@ -1822,7 +1822,7 @@ static u32 iwl_trans_pcie_dump_data(struct iwl_trans *trans,
 	len += sizeof(*data);
 
 	if (trans_pcie->fw_mon_page) {
-		struct iwl_fw_error_fw_mon *fw_mon_data;
+		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
 
 		data = iwl_fw_error_next_data(data);
 		data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
-- 
1.8.3.2

