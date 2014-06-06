Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45552 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaFFTIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 15:08:49 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 3/4] ath10k:  save firmware stack upon firmware crash.
Date: Fri,  6 Jun 2014 12:08:42 -0700
Message-Id: <1402081723-30040-3-git-send-email-greearb@candelatech.com> (sfid-20140606_210913_904510_A6DD612C)
In-Reply-To: <1402081723-30040-1-git-send-email-greearb@candelatech.com>
References: <1402081723-30040-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help debug firmware crashes, and give users a way
to provide some useful debug reports to firmware developers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c |  9 ++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |  1 +
 drivers/net/wireless/ath/ath10k/pci.c   | 39 +++++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a86a5f9..ea91847 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -346,6 +346,7 @@ enum ath10k_dev_flags {
 enum ath10k_fw_error_dump_type {
 	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
 	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
+	ATH10K_FW_ERROR_DUMP_STACK = 2,
 
 	ATH10K_FW_ERROR_DUMP_MAX,
 };
@@ -558,6 +559,7 @@ struct ath10k {
 	bool crashed_since_read;
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
+	unsigned char stack_buf[ATH10K_FW_STACK_SIZE];
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6da7e3c..837ca17 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -619,6 +619,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(ar->reg_dump_values);
 	len += sizeof(*dump_tlv) + sizeof(ar->dbglog_entry_data);
+	len += sizeof(*dump_tlv) + sizeof(ar->stack_buf);
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -685,8 +686,16 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, &ar->reg_dump_values, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	/* Gather firmware stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_STACK;
+	dump_tlv->tlv_len = sizeof(ar->stack_buf);
+	memcpy(dump_tlv->tlv_data, &ar->stack_buf, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
 	spin_unlock_irqrestore(&ar->crash_data_lock, flags);
 
+	WARN_ON(sofar != len);
 	return dump_data;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d4df3f0..38a03e4 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -39,6 +39,7 @@
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
 
 #define REG_DUMP_COUNT_QCA988X 60
+#define ATH10K_FW_STACK_SIZE 4096
 
 struct ath10k_fw_ie {
 	__le32 id;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a7df582..e26f1f8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -834,6 +834,38 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
+static void ath10k_save_firmware_mem_helper(struct ath10k *ar, u32 sz,
+					    unsigned char *to, u32 addr)
+{
+	u32 host_addr;
+	u32 reg_dump_area;
+	int ret;
+
+	host_addr = host_interest_item_address(addr);
+
+	ret = ath10k_pci_diag_read_mem(ar, host_addr, &reg_dump_area,
+				       sizeof(u32));
+	if (ret != 0) {
+		ath10k_warn("failed to read FW addr: %d (addr %d)\n",
+			    ret, addr);
+		return;
+	}
+
+	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area, to, sz);
+	if (ret != 0)
+		ath10k_err("failed to read FW memory: %d (addr %d sz %d)\n",
+			   ret, reg_dump_area, sz);
+}
+
+/* Save the main firmware stack */
+static void ath10k_save_firmware_stack(struct ath10k *ar)
+{
+	BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 4);
+	ath10k_save_firmware_mem_helper(ar, ATH10K_FW_STACK_SIZE,
+					ar->stack_buf, HI_ITEM(hi_stack));
+}
+
+
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 {
 	u32 reg_dump_area = 0;
@@ -881,6 +913,13 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+	spin_lock_irqsave(&ar->crash_data_lock, flags);
+
+	if (!ar->crashed_since_read)
+		ath10k_save_firmware_stack(ar);
+
+	spin_unlock_irqrestore(&ar->crash_data_lock, flags);
+
 	/* Dump the debug logs on the target */
 	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
 	ret = ath10k_pci_diag_read_mem(ar, host_addr,
-- 
1.7.11.7

