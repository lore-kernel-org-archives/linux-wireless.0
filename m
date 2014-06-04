Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52927 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaFDSBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 14:01:54 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 4/4] ath10k:  Dump exception stack contents on firmware crash.
Date: Wed,  4 Jun 2014 11:01:42 -0700
Message-Id: <1401904902-5842-4-git-send-email-greearb@candelatech.com> (sfid-20140604_200200_361287_BC837815)
In-Reply-To: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Firmware developers can decode this and maybe figure out
why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c | 10 +++++++++-
 drivers/net/wireless/ath/ath10k/pci.c   | 11 ++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f2c256b..f2e8690 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -353,6 +353,7 @@ enum ath10k_fw_error_dump_type {
 	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
 	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
 	ATH10K_FW_ERROR_DUMP_STACK = 2,
+	ATH10K_FW_ERROR_DUMP_EXC_STACK = 3,
 
 	ATH10K_FW_ERROR_DUMP_MAX,
 };
@@ -563,6 +564,7 @@ struct ath10k {
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 	unsigned char stack_buf[ATH10K_FW_STACK_SIZE];
+	unsigned char exc_stack_buf[ATH10K_FW_STACK_SIZE];
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 9c9fc10..a8d3978 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -602,6 +602,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 {
 	unsigned int len = (sizeof(ar->dbglog_entry_data)
 			    + sizeof(ar->stack_buf)
+			    + sizeof(ar->exc_stack_buf)
 			    + sizeof(ar->reg_dump_values));
 	unsigned int sofar = 0;
 	char *buf;
@@ -615,7 +616,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	sofar += hdr_len;
 
 	/* So we can add headers to the data dump */
-	len += 3 * sizeof(*dump_tlv);
+	len += 4 * sizeof(*dump_tlv);
 
 	/* This is going to get big when we start dumping FW RAM and such,
 	 * so go ahead and use vmalloc.
@@ -670,6 +671,13 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, &ar->stack_buf, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	/* Gather firmware exception (irq) stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_EXC_STACK;
+	dump_tlv->tlv_len = sizeof(ar->exc_stack_buf);
+	memcpy(dump_tlv->tlv_data, &ar->exc_stack_buf, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
 	WARN_ON(sofar != len);
 	return dump_data;
 }
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e709c02..cf1cc41 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -864,6 +864,13 @@ static void ath10k_save_firmware_stack(struct ath10k *ar)
 					ar->stack_buf, HI_ITEM(hi_stack));
 }
 
+/* Save the firmware exception stack */
+static void ath10k_save_firmware_exc_stack(struct ath10k *ar)
+{
+	ath10k_save_firmware_mem_helper(ar, ATH10K_FW_STACK_SIZE,
+					ar->exc_stack_buf,
+					HI_ITEM(hi_err_stack));
+}
 
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 {
@@ -909,8 +916,10 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
-	if (!ar->crashed_since_read)
+	if (!ar->crashed_since_read) {
 		ath10k_save_firmware_stack(ar);
+		ath10k_save_firmware_exc_stack(ar);
+	}
 
 	/* Dump the debug logs on the target */
 	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
-- 
1.7.11.7

