Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52921 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFDSBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 14:01:53 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/4] ath10k:  save firmware stack upon firmware crash.
Date: Wed,  4 Jun 2014 11:01:41 -0700
Message-Id: <1401904902-5842-3-git-send-email-greearb@candelatech.com> (sfid-20140604_200157_106948_D9BF886E)
In-Reply-To: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help debug firmware crashes, and give users a way
to provide some useful debug reports to firmware developers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  3 +++
 drivers/net/wireless/ath/ath10k/debug.c | 11 ++++++++++-
 drivers/net/wireless/ath/ath10k/pci.c   | 35 +++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a8866d3..f2c256b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -45,6 +45,7 @@
  * get a compile error.  Cannot just include pci.h here.
  */
 #define REG_DUMP_COUNT_QCA988X 60
+#define ATH10K_FW_STACK_SIZE 4096
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
@@ -351,6 +352,7 @@ enum ath10k_dev_flags {
 enum ath10k_fw_error_dump_type {
 	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
 	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
+	ATH10K_FW_ERROR_DUMP_STACK = 2,
 
 	ATH10K_FW_ERROR_DUMP_MAX,
 };
@@ -560,6 +562,7 @@ struct ath10k {
 	bool crashed_since_read;
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
+	unsigned char stack_buf[ATH10K_FW_STACK_SIZE];
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index a7d7877..9c9fc10 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -601,6 +601,7 @@ EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
 static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 {
 	unsigned int len = (sizeof(ar->dbglog_entry_data)
+			    + sizeof(ar->stack_buf)
 			    + sizeof(ar->reg_dump_values));
 	unsigned int sofar = 0;
 	char *buf;
@@ -614,7 +615,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	sofar += hdr_len;
 
 	/* So we can add headers to the data dump */
-	len += 2 * sizeof(*dump_tlv);
+	len += 3 * sizeof(*dump_tlv);
 
 	/* This is going to get big when we start dumping FW RAM and such,
 	 * so go ahead and use vmalloc.
@@ -662,6 +663,14 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, &ar->reg_dump_values, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	/* Gather firmware stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_STACK;
+	dump_tlv->tlv_len = sizeof(ar->stack_buf);
+	memcpy(dump_tlv->tlv_data, &ar->stack_buf, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
+	WARN_ON(sofar != len);
 	return dump_data;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f2cfe69..e709c02 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -833,6 +833,38 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
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
+	BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 8);
+	ath10k_save_firmware_mem_helper(ar, ATH10K_FW_STACK_SIZE,
+					ar->stack_buf, HI_ITEM(hi_stack));
+}
+
+
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 {
 	u32 reg_dump_area = 0;
@@ -877,6 +909,9 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+	if (!ar->crashed_since_read)
+		ath10k_save_firmware_stack(ar);
+
 	/* Dump the debug logs on the target */
 	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
 	if (ath10k_pci_diag_read_mem(ar, host_addr,
-- 
1.7.11.7

