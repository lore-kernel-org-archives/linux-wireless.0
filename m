Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51127 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaIEQeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 12:34:13 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/2] ath10k: save firmware stacks upon firmware crash
Date: Fri,  5 Sep 2014 09:34:08 -0700
Message-Id: <1409934849-23078-1-git-send-email-greearb@candelatech.com> (sfid-20140905_183416_977063_07C5922E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help debug firmware crashes, and give users a way
to provide some useful debug reports to firmware developers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

This is a merge/rework of previously posted stack-dump patches.
This is on top of the debug-log dumping patch and the
firmware crash-by-assert patch.  It has been tested.

 drivers/net/wireless/ath/ath10k/core.h  |  4 +++
 drivers/net/wireless/ath/ath10k/debug.c | 29 +++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h    |  1 +
 drivers/net/wireless/ath/ath10k/pci.c   | 54 ++++++++++++++++++++++++++++++++-
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fc39995..0ca52e0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -303,6 +303,10 @@ struct ath10k_fw_crash_data {
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
index 229573e..5c11966 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -33,10 +33,15 @@
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
 
@@ -100,8 +105,11 @@ struct ath10k_dump_file_data {
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
@@ -774,6 +782,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->exc_stack_buf);
 
 	sofar += hdr_len;
 
@@ -813,6 +823,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	dump_data->ht_cap_info = cpu_to_le32(ar->ht_cap_info);
 	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
 	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
+	dump_data->stack_addr = cpu_to_le32(crash_data->stack_addr);
+	dump_data->exc_stack_addr = cpu_to_le32(crash_data->exc_stack_addr);
 
 	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
@@ -845,7 +857,22 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
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
index 28fedba..c7ec412 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -40,6 +40,7 @@
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
 
 #define REG_DUMP_COUNT_QCA988X 60
+#define ATH10K_FW_STACK_SIZE 4096
 
 struct ath10k_fw_ie {
 	__le32 id;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 09990f0..71d01fd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -604,6 +604,22 @@ static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
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
@@ -630,7 +646,10 @@ static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
 }
 
 #define ath10k_pci_diag_read_hi(ar, dest, src, len)		\
-	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len);
+	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len)
+
+#define ath10k_pci_diag_read_hi_addr(ar, dest, src)		\
+	__ath10k_pci_diag_read_hi_addr(ar, dest, HI_ITEM(src))
 
 static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 				     const void *data, int nbytes)
@@ -944,6 +963,37 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
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
@@ -1092,6 +1142,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_print_driver_info(ar);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_pci_dump_dbglog(ar);
+	ath10k_pci_dump_stack(ar, crash_data);
+	ath10k_pci_dump_exc_stack(ar, crash_data);
 	if (crash_data)
 		crash_data->crashed_since_read = true;
 
-- 
1.7.11.7

