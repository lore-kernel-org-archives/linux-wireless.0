Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53951 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbcEKRCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:43 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH v2 07/21] ath10k: save firmware RAM and ROM BSS sections on crash
Date: Wed, 11 May 2016 10:02:19 -0700
Message-Id: <1462986153-16318-8-git-send-email-greearb@candelatech.com> (sfid-20160511_192231_441705_28B0508D)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This can be used to get a useful back trace out of a firmware
crash that involves an interrupt handler.  For instance, a
null-pointer-exception would be this kind of trace.  A user-space
tool can read the debugfs file and decode things as wished.

This requires a packaged firmware with a new IE to describe the
BSS section starts and length.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 48 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  | 14 +++++++++
 drivers/net/wireless/ath/ath10k/debug.c | 40 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h    |  2 ++
 drivers/net/wireless/ath/ath10k/pci.c   | 54 +++++++++++++++++++++++++++++++++
 5 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b7318b8..3f1786c 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -922,6 +922,13 @@ err:
 	return ret;
 }
 
+struct ath10k_bss_rom_ie {
+	__le32 ram_addr;
+	__le32 ram_len;
+	__le32 rom_addr;
+	__le32 rom_len;
+} __packed;
+
 static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 					 size_t name_len)
 {
@@ -983,6 +990,7 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 	struct ath10k_fw_ie *hdr;
 	const u8 *data;
 	__le32 *timestamp, *version;
+	struct ath10k_bss_rom_ie *bss;
 
 	/* first fetch the firmware file (firmware-*.bin) */
 	fw_file->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir,
@@ -1100,6 +1108,12 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 
 			break;
 		case ATH10K_FW_IE_WMI_OP_VERSION:
+			/* Upstream stole the ID CT firmware was using, so add
+			 * hack-around to deal with backwards-compat. --Ben
+			 */
+			if (ie_len >= sizeof(*bss))
+				goto fw_ie_bss_info_ct;
+
 			if (ie_len != sizeof(u32))
 				break;
 
@@ -1128,6 +1142,40 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 			fw_file->codeswap_data = data;
 			fw_file->codeswap_len = ie_len;
 			break;
+		case ATH10K_FW_IE_BSS_INFO_CT:
+fw_ie_bss_info_ct:
+			if (ie_len < sizeof(*bss)) {
+				ath10k_warn(ar, "invalid ie len for bss-info (%zd)\n",
+					    ie_len);
+				break;
+			}
+			bss = (struct ath10k_bss_rom_ie *)(data);
+
+			fw_file->ram_bss_addr = le32_to_cpu(bss->ram_addr);
+			fw_file->ram_bss_len = le32_to_cpu(bss->ram_len);
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "found RAM BSS addr 0x%x length %d\n",
+				   fw_file->ram_bss_addr, fw_file->ram_bss_len);
+
+			if (fw_file->ram_bss_len > ATH10K_RAM_BSS_BUF_LEN) {
+				ath10k_warn(ar, "too long firmware RAM BSS length: %d\n",
+					    fw_file->ram_bss_len);
+				fw_file->ram_bss_len = 0;
+			}
+
+			fw_file->rom_bss_addr = le32_to_cpu(bss->rom_addr);
+			fw_file->rom_bss_len = le32_to_cpu(bss->rom_len);
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "found ROM BSS addr 0x%x length %d\n",
+				   fw_file->rom_bss_addr, fw_file->rom_bss_len);
+
+			if (fw_file->rom_bss_len > ATH10K_ROM_BSS_BUF_LEN) {
+				ath10k_warn(ar, "too long firmware ROM BSS length: %d\n",
+					    fw_file->rom_bss_len);
+				fw_file->rom_bss_len = 0;
+			}
+
+			break;
 		default:
 			ath10k_warn(ar, "Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 644d077..6aa7a14 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -420,6 +420,10 @@ struct ath10k_dbglog_entry_storage {
 #define DBGLOG_NUM_ARGS_MASK             0xFC000000 /* Bit 26-31 */
 #define DBGLOG_NUM_ARGS_MAX              5 /* firmware tool chain limit */
 
+/* estimated values, hopefully these are enough */
+#define ATH10K_ROM_BSS_BUF_LEN 30000
+#define ATH10K_RAM_BSS_BUF_LEN 10000
+
 /* used for crash-dump storage, protected by data-lock */
 struct ath10k_fw_crash_data {
 	bool crashed_since_read;
@@ -431,6 +435,8 @@ struct ath10k_fw_crash_data {
 	__le32 exc_stack_buf[ATH10K_FW_STACK_SIZE / sizeof(__le32)];
 	__le32 stack_addr;
 	__le32 exc_stack_addr;
+	__le32 rom_bss_buf[ATH10K_ROM_BSS_BUF_LEN / sizeof(__le32)];
+	__le32 ram_bss_buf[ATH10K_RAM_BSS_BUF_LEN / sizeof(__le32)];
 };
 
 struct ath10k_debug {
@@ -666,6 +672,14 @@ struct ath10k_fw_file {
 
 	const void *codeswap_data;
 	size_t codeswap_len;
+
+	/* These are written to only during first firmware load from user
+	 * space so no need for any locking.
+	 */
+	u32 ram_bss_addr;
+	u32 ram_bss_len;
+	u32 rom_bss_addr;
+	u32 rom_bss_len;
 };
 
 struct ath10k_fw_components {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ec6db04..c7bff1e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -38,12 +38,16 @@
  * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
  * @ATH10K_FW_CRASH_DUMP_STACK:   Stack memory contents.
  * @ATH10K_FW_CRASH_DUMP_EXC_STACK:   Exception stack memory contents.
+ * @ATH10K_FW_CRASH_DUMP_RAM_BSS:  BSS area for RAM code
+ * @ATH10K_FW_CRASH_DUMP_ROM_BSS:  BSS area for ROM code
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
 	ATH10K_FW_CRASH_DUMP_DBGLOG = 1,
 	ATH10K_FW_CRASH_DUMP_STACK = 2,
 	ATH10K_FW_CRASH_DUMP_EXC_STACK = 3,
+	ATH10K_FW_CRASH_DUMP_RAM_BSS = 4,
+	ATH10K_FW_CRASH_DUMP_ROM_BSS = 5,
 
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
@@ -110,9 +114,11 @@ struct ath10k_dump_file_data {
 
 	__le32 stack_addr;
 	__le32 exc_stack_addr;
+	__le32 rom_bss_addr;
+	__le32 ram_bss_addr;
 
 	/* room for growth w/out changing binary format */
-	u8 unused[120];
+	u8 unused[112];
 
 	/* struct ath10k_tlv_dump_data + more */
 	u8 data[0];
@@ -803,6 +809,14 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
 	len += sizeof(*dump_tlv) + sizeof(crash_data->exc_stack_buf);
 
+	if (ar->running_fw->fw_file.ram_bss_addr &&
+	    ar->running_fw->fw_file.ram_bss_len)
+		len += sizeof(*dump_tlv) + ar->running_fw->fw_file.ram_bss_len;
+
+	if (ar->running_fw->fw_file.rom_bss_addr &&
+	    ar->running_fw->fw_file.rom_bss_len)
+		len += sizeof(*dump_tlv) + ar->running_fw->fw_file.rom_bss_len;
+
 	sofar += hdr_len;
 
 	/* This is going to get big when we start dumping FW RAM and such,
@@ -843,6 +857,10 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
 	dump_data->stack_addr = cpu_to_le32(crash_data->stack_addr);
 	dump_data->exc_stack_addr = cpu_to_le32(crash_data->exc_stack_addr);
+	dump_data->rom_bss_addr =
+		cpu_to_le32(ar->running_fw->fw_file.rom_bss_addr);
+	dump_data->ram_bss_addr =
+		cpu_to_le32(ar->running_fw->fw_file.ram_bss_addr);
 
 	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
@@ -893,6 +911,26 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, crash_data->exc_stack_buf, tmp);
 	sofar += sizeof(*dump_tlv) + tmp;
 
+	if (ar->running_fw->fw_file.ram_bss_addr &&
+	    ar->running_fw->fw_file.ram_bss_len) {
+		tmp = ar->running_fw->fw_file.ram_bss_len;
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_RAM_BSS);
+		dump_tlv->tlv_len = cpu_to_le32(tmp);
+		memcpy(dump_tlv->tlv_data, crash_data->ram_bss_buf, tmp);
+		sofar += sizeof(*dump_tlv) + tmp;
+	}
+
+	if (ar->running_fw->fw_file.rom_bss_addr &&
+	    ar->running_fw->fw_file.rom_bss_len) {
+		tmp = ar->running_fw->fw_file.rom_bss_len;
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_ROM_BSS);
+		dump_tlv->tlv_len = cpu_to_le32(tmp);
+		memcpy(dump_tlv->tlv_data, crash_data->rom_bss_buf, tmp);
+		sofar += sizeof(*dump_tlv) + tmp;
+	}
+
 	ar->debug.fw_crash_data->crashed_since_read = false;
 
 	WARN_ON(sofar != len);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index e86ebf0..7b80e29 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -149,6 +149,8 @@ enum ath10k_fw_ie_type {
 
 	/* Code swap image for firmware binary */
 	ATH10K_FW_IE_FW_CODE_SWAP_IMAGE = 7,
+
+	ATH10K_FW_IE_BSS_INFO_CT = 30,
 };
 
 enum ath10k_fw_wmi_op_version {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 62dd167..e6315ec 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1424,6 +1424,58 @@ u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
+static void ath10k_pci_dump_bss_ram(struct ath10k *ar,
+				    struct ath10k_fw_crash_data *crash_data)
+{
+	int ret;
+
+	if (!crash_data)
+		return;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	if (!ar->running_fw->fw_file.ram_bss_addr)
+		return;
+
+	if (!ar->running_fw->fw_file.ram_bss_len)
+		return;
+
+	ret = ath10k_pci_diag_read_mem(ar, ar->running_fw->fw_file.ram_bss_addr,
+				       crash_data->ram_bss_buf,
+				       ar->running_fw->fw_file.ram_bss_len);
+	if (ret)
+		ath10k_warn(ar,
+			    "failed to read firmware RAM BSS memory from %d (%d B): %d\n",
+			    ar->running_fw->fw_file.ram_bss_addr,
+			    ar->running_fw->fw_file.ram_bss_len, ret);
+}
+
+static void ath10k_pci_dump_bss_rom(struct ath10k *ar,
+				    struct ath10k_fw_crash_data *crash_data)
+{
+	int ret;
+
+	if (!crash_data)
+		return;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	if (!ar->running_fw->fw_file.rom_bss_addr)
+		return;
+
+	if (!ar->running_fw->fw_file.rom_bss_len)
+		return;
+
+	ret = ath10k_pci_diag_read_mem(ar, ar->running_fw->fw_file.rom_bss_addr,
+				       crash_data->rom_bss_buf,
+				       ar->running_fw->fw_file.rom_bss_len);
+	if (ret)
+		ath10k_warn(ar,
+			    "failed to read firmware ROM BSS memory from %d (%d B): %d\n",
+			    ar->running_fw->fw_file.rom_bss_addr,
+			    ar->running_fw->fw_file.rom_bss_len, ret);
+}
+
 /* Save the main firmware stack */
 static void ath10k_pci_dump_stack(struct ath10k *ar,
 				  struct ath10k_fw_crash_data *crash_data)
@@ -1607,6 +1659,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_pci_dump_dbglog(ar);
 	ath10k_pci_dump_stack(ar, crash_data);
 	ath10k_pci_dump_exc_stack(ar, crash_data);
+	ath10k_pci_dump_bss_ram(ar, crash_data);
+	ath10k_pci_dump_bss_rom(ar, crash_data);
 	if (crash_data)
 		crash_data->crashed_since_read = true;
 
-- 
2.4.3

