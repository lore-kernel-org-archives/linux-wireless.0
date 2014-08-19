Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:59175 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaHSIXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 04:23:13 -0400
Subject: [PATCH v7 4/8] ath10k: save firmware stack upon firmware crash
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Aug 2014 11:23:07 +0300
Message-ID: <20140819082307.16842.21519.stgit@potku.adurom.net> (sfid-20140819_102316_843302_AC653D59)
In-Reply-To: <20140819082038.16842.46876.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help debug firmware crashes, and give users a way
to provide some useful debug reports to firmware developers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    1 +
 drivers/net/wireless/ath/ath10k/debug.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |    1 +
 drivers/net/wireless/ath/ath10k/pci.c   |   13 +++++++++++++
 4 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 09c0a109368a..c397b064b72d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -301,6 +301,7 @@ struct ath10k_fw_crash_data {
 	struct timespec timestamp;
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
+	u8 stack_buf[ATH10K_FW_STACK_SIZE];
 };
 
 struct ath10k_debug {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8c3f9acd6492..faf3d36dbdeb 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -33,10 +33,12 @@
  * enum ath10k_fw_crash_dump_type - types of data in the dump file
  * @ATH10K_FW_CRASH_DUMP_DBGLOG:  Recent firmware debug log entries
  * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
+ * @ATH10K_FW_CRASH_DUMP_STACK:   Stack memory contents.
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_DBGLOG = 0,
 	ATH10K_FW_CRASH_DUMP_REGDUMP = 1,
+	ATH10K_FW_CRASH_DUMP_STACK = 2,
 
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
@@ -721,6 +723,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
 	len += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
 
 	sofar += hdr_len;
 
@@ -787,10 +790,19 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	       sizeof(crash_data->reg_dump_values));
 	sofar += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
 
+	/* Gather firmware stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_STACK);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->stack_buf));
+	memcpy(dump_tlv->tlv_data, crash_data->stack_buf,
+	       sizeof(crash_data->stack_buf));
+	sofar += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
+
 	ar->debug.fw_crash_data->crashed_since_read = false;
 
 	spin_unlock_bh(&ar->data_lock);
 
+	WARN_ON(sofar != len);
 	return dump_data;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index c931cce17063..db52a55e5bd1 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -40,6 +40,7 @@
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
 
 #define REG_DUMP_COUNT_QCA988X 60
+#define ATH10K_FW_STACK_SIZE 4096
 
 struct ath10k_fw_ie {
 	__le32 id;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 41ff620e1af2..81897b2db49f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -832,6 +832,18 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
+/* Save the main firmware stack */
+static void ath10k_pci_dump_stack(struct ath10k *ar,
+				  struct ath10k_fw_crash_data *crash_data)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 4);
+
+	ath10k_pci_diag_read_hi(ar, crash_data->stack_buf,
+				hi_stack, ATH10K_FW_STACK_SIZE);
+}
+
 static void ath10k_pci_dump_dbglog(struct ath10k *ar,
 				   struct ath10k_fw_crash_data *crash_data)
 {
@@ -975,6 +987,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	if (!crash_data)
 		goto exit;
 
+	ath10k_pci_dump_stack(ar, crash_data);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_pci_dump_dbglog(ar, crash_data);
 

