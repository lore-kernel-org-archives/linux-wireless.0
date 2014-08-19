Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:32844 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaHSIXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 04:23:31 -0400
Subject: [PATCH v7 6/8] ath10k: save firmware RAM and ROM BSS sections on crash
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Aug 2014 11:23:25 +0300
Message-ID: <20140819082325.16842.18721.stgit@potku.adurom.net> (sfid-20140819_102405_527574_3C434587)
In-Reply-To: <20140819082038.16842.46876.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
 drivers/net/wireless/ath/ath10k/core.c  |   54 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  |   16 +++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   28 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |    4 ++
 drivers/net/wireless/ath/ath10k/pci.c   |   43 +++++++++++++++++++++++++
 5 files changed, 145 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ba2e87ab19bd..1472c0a767e2 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -479,6 +479,60 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->otp_len = ie_len;
 
 			break;
+		case ATH10K_FW_IE_RAM_BSS_ADDR:
+			if (ie_len != sizeof(u32))
+				break;
+
+			ar->fw.ram_bss_addr = le32_to_cpup((__le32 *)data);
+
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found RAM BSS address 0x%x\n",
+				   ar->fw.ram_bss_addr);
+			break;
+		case ATH10K_FW_IE_RAM_BSS_LEN:
+			if (ie_len != sizeof(u32))
+				break;
+
+			ar->fw.ram_bss_len = le32_to_cpup((__le32 *)data);
+
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found RAM BSS length 0x%x\n",
+				   ar->fw.ram_bss_len);
+
+			if (ar->fw.ram_bss_len > ATH10K_RAM_BSS_BUF_LEN) {
+				ath10k_warn("too long firmware RAM BSS length: %d\n",
+					    ar->fw.ram_bss_len);
+				ar->fw.ram_bss_len = 0;
+			}
+
+			break;
+		case ATH10K_FW_IE_ROM_BSS_ADDR:
+			if (ie_len != sizeof(u32))
+				break;
+
+			ar->fw.rom_bss_addr = le32_to_cpup((__le32 *)data);
+
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found ROM BSS address 0x%x\n",
+				   ar->fw.rom_bss_addr);
+			break;
+		case ATH10K_FW_IE_ROM_BSS_LEN:
+			if (ie_len != sizeof(u32))
+				break;
+
+			ar->fw.rom_bss_len = le32_to_cpup((__le32 *)data);
+
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found ROM BSS length 0x%x\n",
+				   ar->fw.rom_bss_len);
+
+			if (ar->fw.ram_bss_len > ATH10K_RAM_BSS_BUF_LEN) {
+				ath10k_warn("too long firmware RAM BSS length: %d\n",
+					    ar->fw.ram_bss_len);
+				ar->fw.rom_bss_len = 0;
+			}
+
+			break;
 		default:
 			ath10k_warn("Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 34d6d255cca7..31bf18c588c7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -293,6 +293,10 @@ struct ath10k_dbglog_entry_storage {
 	u8 data[ATH10K_DBGLOG_DATA_LEN];
 };
 
+/* estimated values, hopefully these are enough */
+#define ATH10K_ROM_BSS_BUF_LEN 10000
+#define ATH10K_RAM_BSS_BUF_LEN 30000
+
 /* used for crash-dump storage, protected by data-lock */
 struct ath10k_fw_crash_data {
 	bool crashed_since_read;
@@ -303,6 +307,9 @@ struct ath10k_fw_crash_data {
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 	u8 stack_buf[ATH10K_FW_STACK_SIZE];
 	u8 exc_stack_buf[ATH10K_FW_STACK_SIZE];
+
+	u8 rom_bss_buf[ATH10K_ROM_BSS_BUF_LEN];
+	u8 ram_bss_buf[ATH10K_RAM_BSS_BUF_LEN];
 };
 
 struct ath10k_debug {
@@ -450,6 +457,15 @@ struct ath10k {
 		} fw;
 	} hw_params;
 
+	/* These are written to only during first firmware load from user
+	 * space so no need for any locking. */
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
index 3a24b4fec6ce..67bb53c64ead 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -35,12 +35,16 @@
  * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
  * @ATH10K_FW_CRASH_DUMP_STACK:   Stack memory contents.
  * @ATH10K_FW_CRASH_DUMP_EXC_STACK:  Exception stack contents
+ * @ATH10K_FW_CRASH_DUMP_RAM_BSS:  BSS area for RAM code
+ * @ATH10K_FW_CRASH_DUMP_ROM_BSS:  BSS area for ROM code
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_DBGLOG = 0,
 	ATH10K_FW_CRASH_DUMP_REGDUMP = 1,
 	ATH10K_FW_CRASH_DUMP_STACK = 2,
 	ATH10K_FW_CRASH_DUMP_EXC_STACK = 3,
+	ATH10K_FW_CRASH_DUMP_RAM_BSS = 4,
+	ATH10K_FW_CRASH_DUMP_ROM_BSS = 5,
 
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
@@ -728,6 +732,12 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
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
@@ -809,6 +819,24 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	       sizeof(crash_data->exc_stack_buf));
 	sofar += sizeof(*dump_tlv) + sizeof(crash_data->exc_stack_buf);
 
+	if (ar->fw.ram_bss_addr && ar->fw.ram_bss_len) {
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_RAM_BSS);
+		dump_tlv->tlv_len = cpu_to_le32(ar->fw.ram_bss_len);
+		memcpy(dump_tlv->tlv_data, crash_data->ram_bss_buf,
+		       ar->fw.ram_bss_len);
+		sofar += sizeof(*dump_tlv) + ar->fw.ram_bss_len;
+	}
+
+	if (ar->fw.rom_bss_addr && ar->fw.rom_bss_len) {
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_ROM_BSS);
+		dump_tlv->tlv_len = cpu_to_le32(ar->fw.rom_bss_len);
+		memcpy(dump_tlv->tlv_data, crash_data->rom_bss_buf,
+		       ar->fw.rom_bss_len);
+		sofar += sizeof(*dump_tlv) + ar->fw.rom_bss_len;
+	}
+
 	ar->debug.fw_crash_data->crashed_since_read = false;
 
 	spin_unlock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index db52a55e5bd1..90fa4b0f56a4 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -54,6 +54,10 @@ enum ath10k_fw_ie_type {
 	ATH10K_FW_IE_FEATURES = 2,
 	ATH10K_FW_IE_FW_IMAGE = 3,
 	ATH10K_FW_IE_OTP_IMAGE = 4,
+	ATH10K_FW_IE_RAM_BSS_ADDR = 5,
+	ATH10K_FW_IE_RAM_BSS_LEN = 6,
+	ATH10K_FW_IE_ROM_BSS_ADDR = 7,
+	ATH10K_FW_IE_ROM_BSS_LEN = 8,
 };
 
 /* Known pecularities:
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8266cc94f718..4825cef69c6e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -856,6 +856,47 @@ static void ath10k_pci_dump_exc_stack(struct ath10k *ar,
 				hi_err_stack, ATH10K_FW_STACK_SIZE);
 }
 
+static void ath10k_pci_dump_bss_ram(struct ath10k *ar,
+				    struct ath10k_fw_crash_data *crash_data) {
+	int ret;
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
+		ath10k_warn("failed to read firmware RAM BSS memory from %d (%d B): %d\n",
+			    ar->fw.ram_bss_addr, ar->fw.ram_bss_len, ret);
+}
+
+static void ath10k_pci_dump_bss_rom(struct ath10k *ar,
+				    struct ath10k_fw_crash_data *crash_data)
+{
+	int ret;
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
+		ath10k_warn("failed to read firmware ROM BSS memory from %d (%d B): %d\n",
+			    ar->fw.rom_bss_addr, ar->fw.rom_bss_len, ret);
+}
+
 static void ath10k_pci_dump_dbglog(struct ath10k *ar,
 				   struct ath10k_fw_crash_data *crash_data)
 {
@@ -1001,6 +1042,8 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 
 	ath10k_pci_dump_stack(ar, crash_data);
 	ath10k_pci_dump_exc_stack(ar, crash_data);
+	ath10k_pci_dump_bss_ram(ar, crash_data);
+	ath10k_pci_dump_bss_rom(ar, crash_data);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_pci_dump_dbglog(ar, crash_data);
 

