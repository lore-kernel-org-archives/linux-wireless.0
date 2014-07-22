Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60456 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbaGVXCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 19:02:45 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 5/5] ath10k:  save firmware RAM and ROM BSS sections on crash.
Date: Tue, 22 Jul 2014 16:02:34 -0700
Message-Id: <1406070154-6614-5-git-send-email-greearb@candelatech.com> (sfid-20140723_010250_496349_577A721D)
In-Reply-To: <1406070154-6614-1-git-send-email-greearb@candelatech.com>
References: <1406070154-6614-1-git-send-email-greearb@candelatech.com>
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
---
 drivers/net/wireless/ath/ath10k/core.c  | 62 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  | 11 ++++++
 drivers/net/wireless/ath/ath10k/debug.c | 32 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |  1 +
 drivers/net/wireless/ath/ath10k/pci.c   | 37 ++++++++++++++++++++
 5 files changed, 143 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 93adb8c..08e96e7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -365,6 +365,12 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	struct ath10k_fw_ie *hdr;
 	const u8 *data;
 	__le32 *timestamp;
+#ifdef CONFIG_ATH10K_DEBUGFS
+	u32 old_ram_bss_len = ar->debug.fw_ram_bss_len;
+	u32 old_rom_bss_len = ar->debug.fw_rom_bss_len;
+	unsigned char *t1, *t2;
+	unsigned long flags;
+#endif
 
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
@@ -479,6 +485,38 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->otp_len = ie_len;
 
 			break;
+		case ATH10K_FW_IE_BSS_INFO:
+#ifdef CONFIG_ATH10K_DEBUGFS
+			spin_lock_irqsave(&ar->data_lock, flags);
+
+			ar->debug.fw_ram_bss_addr = le32_to_cpu(((u32 *)(data))[0]);
+			ar->debug.fw_ram_bss_len = le32_to_cpu(((u32 *)(data))[1]);
+			ar->debug.fw_rom_bss_addr = le32_to_cpu(((u32 *)(data))[2]);
+			ar->debug.fw_rom_bss_len = le32_to_cpu(((u32 *)(data))[3]);
+			t1 = t2 = NULL;
+			if ((old_ram_bss_len < ar->debug.fw_ram_bss_len) &&
+			    ar->debug.ram_bss_buf) {
+				t1 = ar->debug.ram_bss_buf;
+				ar->debug.ram_bss_buf = NULL;
+			}
+			if ((old_rom_bss_len < ar->debug.fw_rom_bss_len) &&
+			    ar->debug.rom_bss_buf) {
+				t2 = ar->debug.rom_bss_buf;
+				ar->debug.rom_bss_buf = NULL;
+			}
+			spin_unlock_irqrestore(&ar->data_lock, flags);
+			if (t1)
+				vfree(t1);
+			if (t2)
+				vfree(t2);
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found FW bss info, RAM: addr 0x%x len 0x%x  ROM: addr 0x%x len 0x%x\n",
+				   ar->debug.fw_ram_bss_addr,
+				   ar->debug.fw_ram_bss_len,
+				   ar->debug.fw_rom_bss_addr,
+				   ar->debug.fw_rom_bss_len);
+#endif
+			break;
 		default:
 			ath10k_warn("Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
@@ -1094,9 +1132,33 @@ EXPORT_SYMBOL(ath10k_core_create);
 
 void ath10k_core_destroy(struct ath10k *ar)
 {
+#ifdef CONFIG_ATH10K_DEBUGFS
+	unsigned long flags;
+	unsigned char *t1 = NULL;
+	unsigned char *t2 = NULL;
+#endif
+
 	flush_workqueue(ar->workqueue);
 	destroy_workqueue(ar->workqueue);
 
+#ifdef CONFIG_ATH10K_DEBUGFS
+	spin_lock_irqsave(&ar->data_lock, flags);
+	if (ar->debug.rom_bss_buf) {
+		t1 = ar->debug.rom_bss_buf;
+		ar->debug.rom_bss_buf = NULL;
+	}
+	if (ar->debug.ram_bss_buf) {
+		t2 = ar->debug.ram_bss_buf;
+		ar->debug.ram_bss_buf = NULL;
+	}
+	spin_unlock_irqrestore(&ar->data_lock, flags);
+
+	if (t1)
+		vfree(t1);
+	if (t2)
+		vfree(t2);
+#endif
+
 	ath10k_mac_destroy(ar);
 }
 EXPORT_SYMBOL(ath10k_core_destroy);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f122eae..f44957f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -282,12 +282,16 @@ struct ath10k_vif_iter {
  * @ATH10K_FW_ERROR_DUMP_REGDUMP: Register crash dump in binary format
  * @ATH10K_FW_ERROR_DUMP_STACK:   Stack memory contents.
  * @ATH10K_FW_ERROR_DUMP_EXC_STACK:  Exception stack contents
+ * @ATH10K_FW_ERROR_DUMP_RAM_BSS:  BSS area for RAM code
+ * @ATH10K_FW_ERROR_DUMP_ROM_BSS:  BSS area for ROM code
  */
 enum ath10k_fw_error_dump_type {
 	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
 	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
 	ATH10K_FW_ERROR_DUMP_STACK = 2,
 	ATH10K_FW_ERROR_DUMP_EXC_STACK = 3,
+	ATH10K_FW_ERROR_DUMP_RAM_BSS = 4,
+	ATH10K_FW_ERROR_DUMP_ROM_BSS = 5,
 
 	ATH10K_FW_ERROR_DUMP_MAX,
 };
@@ -370,6 +374,13 @@ struct ath10k_debug {
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 	unsigned char stack_buf[ATH10K_FW_STACK_SIZE];
 	unsigned char exc_stack_buf[ATH10K_FW_STACK_SIZE];
+
+	unsigned char *rom_bss_buf;
+	unsigned char *ram_bss_buf;
+	unsigned int fw_ram_bss_addr;
+	unsigned int fw_ram_bss_len;
+	unsigned int fw_rom_bss_addr;
+	unsigned int fw_rom_bss_len;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1cbc175..450b31d 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -618,6 +618,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	int hdr_len = sizeof(*dump_data);
 	unsigned long flags;
 	struct timespec timestamp;
+	int rom_bss_len = 0;
+	int ram_bss_len = 0;
 
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.reg_dump_values);
@@ -625,6 +627,19 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.stack_buf);
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.exc_stack_buf);
 
+	/* Need to store local copies to detect races */
+	spin_lock_irqsave(&ar->data_lock, flags);
+
+	ram_bss_len = ar->debug.fw_ram_bss_len;
+	rom_bss_len = ar->debug.fw_ram_bss_len;
+
+	if (ram_bss_len && ar->debug.ram_bss_buf)
+		len += sizeof(*dump_tlv) + ram_bss_len;
+	if (rom_bss_len && ar->debug.rom_bss_buf)
+		len += sizeof(*dump_tlv) + rom_bss_len;
+
+	spin_unlock_irqrestore(&ar->data_lock, flags);
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	sofar += hdr_len;
@@ -704,6 +719,23 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, &ar->debug.exc_stack_buf, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	if (ram_bss_len >= ar->debug.fw_ram_bss_len &&
+	    ar->debug.fw_ram_bss_len && ar->debug.ram_bss_buf) {
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = ATH10K_FW_ERROR_DUMP_RAM_BSS;
+		dump_tlv->tlv_len = ar->debug.fw_ram_bss_len;
+		memcpy(dump_tlv->tlv_data, ar->debug.ram_bss_buf, dump_tlv->tlv_len);
+		sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+	}
+	if (rom_bss_len >= ar->debug.fw_rom_bss_len &&
+	    ar->debug.fw_rom_bss_len && ar->debug.rom_bss_buf) {
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = ATH10K_FW_ERROR_DUMP_ROM_BSS;
+		dump_tlv->tlv_len = ar->debug.fw_rom_bss_len;
+		memcpy(dump_tlv->tlv_data, ar->debug.rom_bss_buf, dump_tlv->tlv_len);
+		sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+	}
+
 	spin_unlock_irqrestore(&ar->data_lock, flags);
 
 	WARN_ON(sofar != len);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 38a03e4..724bd94 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -53,6 +53,7 @@ enum ath10k_fw_ie_type {
 	ATH10K_FW_IE_FEATURES = 2,
 	ATH10K_FW_IE_FW_IMAGE = 3,
 	ATH10K_FW_IE_OTP_IMAGE = 4,
+	ATH10K_FW_IE_BSS_INFO = 5,
 };
 
 /* Known pecularities:
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d298e14..6d43845 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -872,6 +872,37 @@ static void ath10k_save_firmware_exc_stack(struct ath10k *ar)
 					ar->debug.exc_stack_buf,
 					HI_ITEM(hi_err_stack));
 }
+
+static void ath10k_check_dump_fw_bss(struct ath10k *ar, u32 addr, u32 len,
+				     bool is_rom) {
+	int ret;
+
+	if (!addr)
+		return;
+	if (is_rom) {
+		if (!ar->debug.rom_bss_buf)
+			ar->debug.rom_bss_buf = kmalloc(len, GFP_ATOMIC);
+		if (!ar->debug.rom_bss_buf)
+			return;
+
+		ret = ath10k_pci_diag_read_mem(ar, addr, ar->debug.rom_bss_buf,
+					       len);
+		if (ret != 0)
+			ath10k_err("failed to read FW ROM BSS memory: %d (addr %d sz %d)\n",
+				   ret, addr, len);
+	} else {
+		if (!ar->debug.ram_bss_buf)
+			ar->debug.ram_bss_buf = kmalloc(len, GFP_ATOMIC);
+		if (!ar->debug.ram_bss_buf)
+			return;
+
+		ret = ath10k_pci_diag_read_mem(ar, addr, ar->debug.ram_bss_buf,
+					       len);
+		if (ret != 0)
+			ath10k_err("failed to read FW RAM BSS memory: %d (addr %d sz %d)\n",
+				   ret, addr, len);
+	}
+}
 #endif
 
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
@@ -928,6 +959,12 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	if (!ar->debug.crashed_since_read) {
 		ath10k_save_firmware_stack(ar);
 		ath10k_save_firmware_exc_stack(ar);
+
+		/* And the RAM BSS region, if we know it. */
+		ath10k_check_dump_fw_bss(ar, ar->debug.fw_ram_bss_addr,
+					 ar->debug.fw_ram_bss_len, false);
+		ath10k_check_dump_fw_bss(ar, ar->debug.fw_rom_bss_addr,
+					 ar->debug.fw_rom_bss_len, true);
 	}
 
 	spin_unlock_bh(&ar->data_lock);
-- 
1.7.11.7

