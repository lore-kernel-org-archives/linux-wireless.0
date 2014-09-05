Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51130 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaIEQeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 12:34:14 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 2/2] ath10k: save firmware RAM and ROM BSS sections on crash
Date: Fri,  5 Sep 2014 09:34:09 -0700
Message-Id: <1409934849-23078-2-git-send-email-greearb@candelatech.com> (sfid-20140905_183418_412597_77E25817)
In-Reply-To: <1409934849-23078-1-git-send-email-greearb@candelatech.com>
References: <1409934849-23078-1-git-send-email-greearb@candelatech.com>
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

This is a re-work and consolidation of previously posted patches.
It uses a single IE with 4 members:  My CT firmware already uses this,
and no other firmware has any support at all for this IE, so I would
like to be compatible.  I use a well-defined struct now, so hopefully
that is more acceptable than my first patches.

Using one IE decreases code and makes code easier to maintain.

Fix several bugs in earlier versions (copy-paste error in IE
handling, inversion of ROM v/s RAM bss sizes)

This has been tested.

 drivers/net/wireless/ath/ath10k/core.c  | 41 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  | 16 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c | 34 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h    |  1 +
 drivers/net/wireless/ath/ath10k/pci.c   | 52 +++++++++++++++++++++++++++++++++
 5 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 651a6da..9828a79 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -360,6 +360,13 @@ err:
 	return ret;
 }
 
+struct ath10k_bss_rom_ie {
+	__le32 ram_addr;
+	__le32 ram_len;
+	__le32 rom_addr;
+	__le32 rom_len;
+} __packed;
+
 static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 {
 	size_t magic_len, len, ie_len;
@@ -367,6 +374,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	struct ath10k_fw_ie *hdr;
 	const u8 *data;
 	__le32 *timestamp;
+	struct ath10k_bss_rom_ie *bss;
 
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
@@ -481,6 +489,39 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->otp_len = ie_len;
 
 			break;
+		case ATH10K_FW_IE_BSS_INFO:
+			if (ie_len < sizeof(*bss)) {
+				ath10k_warn(ar, "invalid ie len for bss-info (%zd)\n",
+					    ie_len);
+				break;
+			}
+			bss = (struct ath10k_bss_rom_ie *)(data);
+
+			ar->fw.ram_bss_addr = le32_to_cpu(bss->ram_addr);
+			ar->fw.ram_bss_len = le32_to_cpu(bss->ram_len);
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "found RAM BSS addr 0x%x length %d\n",
+				   ar->fw.ram_bss_addr, ar->fw.ram_bss_len);
+
+			if (ar->fw.ram_bss_len > ATH10K_RAM_BSS_BUF_LEN) {
+				ath10k_warn(ar, "too long firmware RAM BSS length: %d\n",
+					    ar->fw.ram_bss_len);
+				ar->fw.ram_bss_len = 0;
+			}
+
+			ar->fw.rom_bss_addr = le32_to_cpu(bss->rom_addr);
+			ar->fw.rom_bss_len = le32_to_cpu(bss->rom_len);
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "found ROM BSS addr 0x%x length %d\n",
+				   ar->fw.rom_bss_addr, ar->fw.rom_bss_len);
+
+			if (ar->fw.rom_bss_len > ATH10K_ROM_BSS_BUF_LEN) {
+				ath10k_warn(ar, "too long firmware ROM BSS length: %d\n",
+					    ar->fw.rom_bss_len);
+				ar->fw.rom_bss_len = 0;
+			}
+
+			break;
 		default:
 			ath10k_warn(ar, "Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0ca52e0..b16c0c5 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -296,6 +296,10 @@ struct ath10k_dbglog_entry_storage {
 #define DBGLOG_NUM_ARGS_MASK             0xFC000000 /* Bit 26-31 */
 #define DBGLOG_NUM_ARGS_MAX              5 /* firmware tool chain limit */
 
+/* estimated values, hopefully these are enough */
+#define ATH10K_ROM_BSS_BUF_LEN 30000
+#define ATH10K_RAM_BSS_BUF_LEN 10000
+
 /* used for crash-dump storage, protected by data-lock */
 struct ath10k_fw_crash_data {
 	bool crashed_since_read;
@@ -307,6 +311,8 @@ struct ath10k_fw_crash_data {
 	__le32 exc_stack_buf[ATH10K_FW_STACK_SIZE / sizeof(__le32)];
 	__le32 stack_addr;
 	__le32 exc_stack_addr;
+	__le32 rom_bss_buf[ATH10K_ROM_BSS_BUF_LEN / sizeof(__le32)];
+	__le32 ram_bss_buf[ATH10K_RAM_BSS_BUF_LEN / sizeof(__le32)];
 };
 
 struct ath10k_debug {
@@ -455,6 +461,16 @@ struct ath10k {
 		} fw;
 	} hw_params;
 
+	/* These are written to only during first firmware load from user
+	 * space so no need for any locking.
+	 */
+	struct {
+		u32 ram_bss_addr;
+		u32 ram_bss_len;
+		u32 rom_bss_addr;
+		u32 rom_bss_len;
+	} fw;
+
 	const struct firmware *board;
 	const void *board_data;
 	size_t board_len;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 5c11966..4a5e2e1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -35,12 +35,16 @@
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
@@ -107,9 +111,11 @@ struct ath10k_dump_file_data {
 
 	__le32 stack_addr;
 	__le32 exc_stack_addr;
+	__le32 rom_bss_addr;
+	__le32 ram_bss_addr;
 
 	/* room for growth w/out changing binary format */
-	u8 unused[120];
+	u8 unused[112];
 
 	/* struct ath10k_tlv_dump_data + more */
 	u8 data[0];
@@ -785,6 +791,12 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
 	len += sizeof(*dump_tlv) + sizeof(crash_data->exc_stack_buf);
 
+	if (ar->fw.ram_bss_addr && ar->fw.ram_bss_len)
+		len += sizeof(*dump_tlv) + ar->fw.ram_bss_len;
+
+	if (ar->fw.rom_bss_addr && ar->fw.rom_bss_len)
+		len += sizeof(*dump_tlv) + ar->fw.rom_bss_len;
+
 	sofar += hdr_len;
 
 	/* This is going to get big when we start dumping FW RAM and such,
@@ -825,6 +837,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
 	dump_data->stack_addr = cpu_to_le32(crash_data->stack_addr);
 	dump_data->exc_stack_addr = cpu_to_le32(crash_data->exc_stack_addr);
+	dump_data->rom_bss_addr = cpu_to_le32(ar->fw.rom_bss_addr);
+	dump_data->ram_bss_addr = cpu_to_le32(ar->fw.ram_bss_addr);
 
 	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
@@ -875,6 +889,24 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, crash_data->exc_stack_buf, tmp);
 	sofar += sizeof(*dump_tlv) + tmp;
 
+	if (ar->fw.ram_bss_addr && ar->fw.ram_bss_len) {
+		tmp = ar->fw.ram_bss_len;
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_RAM_BSS);
+		dump_tlv->tlv_len = cpu_to_le32(tmp);
+		memcpy(dump_tlv->tlv_data, crash_data->ram_bss_buf, tmp);
+		sofar += sizeof(*dump_tlv) + tmp;
+	}
+
+	if (ar->fw.rom_bss_addr && ar->fw.rom_bss_len) {
+		tmp = ar->fw.rom_bss_len;
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
index c7ec412..eb1a14b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -54,6 +54,7 @@ enum ath10k_fw_ie_type {
 	ATH10K_FW_IE_FEATURES = 2,
 	ATH10K_FW_IE_FW_IMAGE = 3,
 	ATH10K_FW_IE_OTP_IMAGE = 4,
+	ATH10K_FW_IE_BSS_INFO = 5,
 };
 
 /* Known pecularities:
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 71d01fd..5f2523c4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -963,6 +963,56 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
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
+	if (!ar->fw.ram_bss_addr)
+		return;
+
+	if (!ar->fw.ram_bss_len)
+		return;
+
+	ret = ath10k_pci_diag_read_mem(ar, ar->fw.ram_bss_addr,
+				       crash_data->ram_bss_buf,
+				       ar->fw.ram_bss_len);
+	if (ret)
+		ath10k_warn(ar,
+			    "failed to read firmware RAM BSS memory from %d (%d B): %d\n",
+			    ar->fw.ram_bss_addr, ar->fw.ram_bss_len, ret);
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
+	if (!ar->fw.rom_bss_addr)
+		return;
+
+	if (!ar->fw.rom_bss_len)
+		return;
+
+	ret = ath10k_pci_diag_read_mem(ar, ar->fw.rom_bss_addr,
+				       crash_data->rom_bss_buf,
+				       ar->fw.rom_bss_len);
+	if (ret)
+		ath10k_warn(ar,
+			    "failed to read firmware ROM BSS memory from %d (%d B): %d\n",
+			    ar->fw.rom_bss_addr, ar->fw.rom_bss_len, ret);
+}
+
 /* Save the main firmware stack */
 static void ath10k_pci_dump_stack(struct ath10k *ar,
 				  struct ath10k_fw_crash_data *crash_data)
@@ -1144,6 +1194,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_pci_dump_dbglog(ar);
 	ath10k_pci_dump_stack(ar, crash_data);
 	ath10k_pci_dump_exc_stack(ar, crash_data);
+	ath10k_pci_dump_bss_ram(ar, crash_data);
+	ath10k_pci_dump_bss_rom(ar, crash_data);
 	if (crash_data)
 		crash_data->crashed_since_read = true;
 
-- 
1.7.11.7

