Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53950 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbcEKRCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:43 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH v2 06/21] ath10k: save firmware stacks upon firmware crash
Date: Wed, 11 May 2016 10:02:18 -0700
Message-Id: <1462986153-16318-7-git-send-email-greearb@candelatech.com> (sfid-20160511_192230_599476_ACAE2F11)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help debug firmware crashes, and give users a way
to provide some useful debug reports to firmware developers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  4 +++
 drivers/net/wireless/ath/ath10k/debug.c | 29 +++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h    |  2 ++
 drivers/net/wireless/ath/ath10k/pci.c   | 52 +++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7f9f460..644d077 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -427,6 +427,10 @@ struct ath10k_fw_crash_data {
 	uuid_le uuid;
 	struct timespec timestamp;
 	__le32 registers[REG_DUMP_COUNT_QCA988X];
+	__le32 stack_buf[ATH10K_FW_STACK_SIZE / sizeof(__le32)];
+	__le32 exc_stack_buf[ATH10K_FW_STACK_SIZE / sizeof(__le32)];
+	__le32 stack_addr;
+	__le32 exc_stack_addr;
 };
 
 struct ath10k_debug {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1739687..ec6db04 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -36,10 +36,15 @@
  * enum ath10k_fw_crash_dump_type - types of data in the dump file
  * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
  * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
+ * @ATH10K_FW_CRASH_DUMP_STACK:   Stack memory contents.
+ * @ATH10K_FW_CRASH_DUMP_EXC_STACK:   Exception stack memory contents.
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
 	ATH10K_FW_CRASH_DUMP_DBGLOG = 1,
+	ATH10K_FW_CRASH_DUMP_STACK = 2,
+	ATH10K_FW_CRASH_DUMP_EXC_STACK = 3,
+
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
 
@@ -103,8 +108,11 @@ struct ath10k_dump_file_data {
 	/* VERMAGIC_STRING */
 	char kernel_ver[64];
 
+	__le32 stack_addr;
+	__le32 exc_stack_addr;
+
 	/* room for growth w/out changing binary format */
-	u8 unused[128];
+	u8 unused[120];
 
 	/* struct ath10k_tlv_dump_data + more */
 	u8 data[0];
@@ -792,6 +800,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->exc_stack_buf);
 
 	sofar += hdr_len;
 
@@ -831,6 +841,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	dump_data->ht_cap_info = cpu_to_le32(ar->ht_cap_info);
 	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
 	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
+	dump_data->stack_addr = cpu_to_le32(crash_data->stack_addr);
+	dump_data->exc_stack_addr = cpu_to_le32(crash_data->exc_stack_addr);
 
 	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
@@ -863,7 +875,22 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 		cpu_to_le32(ar->debug.dbglog_entry_data.head_idx);
 	dbglog_storage->tail_idx =
 		cpu_to_le32(ar->debug.dbglog_entry_data.tail_idx);
+	sofar += sizeof(*dump_tlv) + tmp;
 
+	/* Gather firmware stack dump */
+	tmp = sizeof(crash_data->stack_buf);
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_STACK);
+	dump_tlv->tlv_len = cpu_to_le32(tmp);
+	memcpy(dump_tlv->tlv_data, crash_data->stack_buf, tmp);
+	sofar += sizeof(*dump_tlv) + tmp;
+
+	/* Gather firmware exception stack dump */
+	tmp = sizeof(crash_data->exc_stack_buf);
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_EXC_STACK);
+	dump_tlv->tlv_len = cpu_to_le32(tmp);
+	memcpy(dump_tlv->tlv_data, crash_data->exc_stack_buf, tmp);
 	sofar += sizeof(*dump_tlv) + tmp;
 
 	ar->debug.fw_crash_data->crashed_since_read = false;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5bbef4b..e86ebf0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -122,6 +122,8 @@ enum qca9377_chip_id_rev {
 
 #define REG_DUMP_COUNT_QCA988X 60
 
+#define ATH10K_FW_STACK_SIZE 4096
+
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 16e32d0..62dd167 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -985,6 +985,22 @@ static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
 	return ret;
 }
 
+static int __ath10k_pci_diag_read_hi_addr(struct ath10k *ar, __le32 *dest,
+					  u32 src)
+{
+	u32 host_addr;
+	int ret;
+
+	host_addr = host_interest_item_address(src);
+
+	ret = ath10k_pci_diag_read32(ar, host_addr, dest);
+	if (ret != 0) {
+		ath10k_warn(ar, "failed to get memcpy hi address for firmware address %d: %d\n",
+			    src, ret);
+	}
+	return ret;
+}
+
 static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
 				     u32 src, u32 len)
 {
@@ -1013,6 +1029,9 @@ static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
 #define ath10k_pci_diag_read_hi(ar, dest, src, len)		\
 	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len)
 
+#define ath10k_pci_diag_read_hi_addr(ar, dest, src)		\
+	__ath10k_pci_diag_read_hi_addr(ar, dest, HI_ITEM(src))
+
 int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 			      const void *data, int nbytes)
 {
@@ -1405,6 +1424,37 @@ u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
+/* Save the main firmware stack */
+static void ath10k_pci_dump_stack(struct ath10k *ar,
+				  struct ath10k_fw_crash_data *crash_data)
+{
+	if (!crash_data)
+		return;
+
+	lockdep_assert_held(&ar->data_lock);
+	BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 4);
+
+	ath10k_pci_diag_read_hi(ar, crash_data->stack_buf,
+				hi_stack, ATH10K_FW_STACK_SIZE);
+	ath10k_pci_diag_read_hi_addr(ar, &crash_data->stack_addr, hi_stack);
+}
+
+/* Save the exception firmware stack */
+static void ath10k_pci_dump_exc_stack(struct ath10k *ar,
+				      struct ath10k_fw_crash_data *crash_data)
+{
+	if (!crash_data)
+		return;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	ath10k_pci_diag_read_hi(ar, crash_data->exc_stack_buf,
+				hi_err_stack, ATH10K_FW_STACK_SIZE);
+
+	ath10k_pci_diag_read_hi_addr(ar, &crash_data->exc_stack_addr,
+				     hi_err_stack);
+}
+
 static void ath10k_pci_dump_registers(struct ath10k *ar,
 				      struct ath10k_fw_crash_data *crash_data)
 {
@@ -1555,6 +1605,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_print_driver_info(ar);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_pci_dump_dbglog(ar);
+	ath10k_pci_dump_stack(ar, crash_data);
+	ath10k_pci_dump_exc_stack(ar, crash_data);
 	if (crash_data)
 		crash_data->crashed_since_read = true;
 
-- 
2.4.3

