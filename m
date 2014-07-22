Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60454 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbaGVXCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 19:02:44 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 4/5] ath10k:  Dump exception stack contents on firmware crash.
Date: Tue, 22 Jul 2014 16:02:33 -0700
Message-Id: <1406070154-6614-4-git-send-email-greearb@candelatech.com> (sfid-20140723_010252_150716_43192601)
In-Reply-To: <1406070154-6614-1-git-send-email-greearb@candelatech.com>
References: <1406070154-6614-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Firmware developers can decode this and maybe figure out
why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  3 +++
 drivers/net/wireless/ath/ath10k/debug.c |  8 ++++++++
 drivers/net/wireless/ath/ath10k/pci.c   | 13 +++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2f200f6..f122eae 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -281,11 +281,13 @@ struct ath10k_vif_iter {
  * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
  * @ATH10K_FW_ERROR_DUMP_REGDUMP: Register crash dump in binary format
  * @ATH10K_FW_ERROR_DUMP_STACK:   Stack memory contents.
+ * @ATH10K_FW_ERROR_DUMP_EXC_STACK:  Exception stack contents
  */
 enum ath10k_fw_error_dump_type {
 	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
 	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
 	ATH10K_FW_ERROR_DUMP_STACK = 2,
+	ATH10K_FW_ERROR_DUMP_EXC_STACK = 3,
 
 	ATH10K_FW_ERROR_DUMP_MAX,
 };
@@ -367,6 +369,7 @@ struct ath10k_debug {
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 	unsigned char stack_buf[ATH10K_FW_STACK_SIZE];
+	unsigned char exc_stack_buf[ATH10K_FW_STACK_SIZE];
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index befdc60..1cbc175 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -623,6 +623,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.reg_dump_values);
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
 	len += sizeof(*dump_tlv) + sizeof(ar->debug.stack_buf);
+	len += sizeof(*dump_tlv) + sizeof(ar->debug.exc_stack_buf);
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -696,6 +697,13 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, &ar->debug.stack_buf, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	/* Gather firmware exception (irq) stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_EXC_STACK;
+	dump_tlv->tlv_len = sizeof(ar->debug.exc_stack_buf);
+	memcpy(dump_tlv->tlv_data, &ar->debug.exc_stack_buf, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
 	spin_unlock_irqrestore(&ar->data_lock, flags);
 
 	WARN_ON(sofar != len);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b58f1a1..d298e14 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -864,8 +864,15 @@ static void ath10k_save_firmware_stack(struct ath10k *ar)
 	ath10k_save_firmware_mem_helper(ar, ATH10K_FW_STACK_SIZE,
 					ar->debug.stack_buf, HI_ITEM(hi_stack));
 }
-#endif
 
+/* Save the firmware exception stack */
+static void ath10k_save_firmware_exc_stack(struct ath10k *ar)
+{
+	ath10k_save_firmware_mem_helper(ar, ATH10K_FW_STACK_SIZE,
+					ar->debug.exc_stack_buf,
+					HI_ITEM(hi_err_stack));
+}
+#endif
 
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 {
@@ -918,8 +925,10 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 #ifdef CONFIG_ATH10K_DEBUGFS
 	spin_lock_bh(&ar->data_lock);
 
-	if (!ar->debug.crashed_since_read)
+	if (!ar->debug.crashed_since_read) {
 		ath10k_save_firmware_stack(ar);
+		ath10k_save_firmware_exc_stack(ar);
+	}
 
 	spin_unlock_bh(&ar->data_lock);
 
-- 
1.7.11.7

