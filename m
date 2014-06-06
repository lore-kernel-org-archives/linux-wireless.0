Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45553 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaFFTIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 15:08:49 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 4/4] ath10k:  Dump exception stack contents on firmware crash.
Date: Fri,  6 Jun 2014 12:08:43 -0700
Message-Id: <1402081723-30040-4-git-send-email-greearb@candelatech.com> (sfid-20140606_210854_778571_4D2F7785)
In-Reply-To: <1402081723-30040-1-git-send-email-greearb@candelatech.com>
References: <1402081723-30040-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Firmware developers can decode this and maybe figure out
why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c |  8 ++++++++
 drivers/net/wireless/ath/ath10k/pci.c   | 11 ++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ea91847..0cb0f2e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -347,6 +347,7 @@ enum ath10k_fw_error_dump_type {
 	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
 	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
 	ATH10K_FW_ERROR_DUMP_STACK = 2,
+	ATH10K_FW_ERROR_DUMP_EXC_STACK = 3,
 
 	ATH10K_FW_ERROR_DUMP_MAX,
 };
@@ -560,6 +561,7 @@ struct ath10k {
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 	unsigned char stack_buf[ATH10K_FW_STACK_SIZE];
+	unsigned char exc_stack_buf[ATH10K_FW_STACK_SIZE];
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 837ca17..3f4a024 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -620,6 +620,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len += sizeof(*dump_tlv) + sizeof(ar->reg_dump_values);
 	len += sizeof(*dump_tlv) + sizeof(ar->dbglog_entry_data);
 	len += sizeof(*dump_tlv) + sizeof(ar->stack_buf);
+	len += sizeof(*dump_tlv) + sizeof(ar->exc_stack_buf);
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -693,6 +694,13 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, &ar->stack_buf, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	/* Gather firmware exception (irq) stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_EXC_STACK;
+	dump_tlv->tlv_len = sizeof(ar->exc_stack_buf);
+	memcpy(dump_tlv->tlv_data, &ar->exc_stack_buf, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
 	spin_unlock_irqrestore(&ar->crash_data_lock, flags);
 
 	WARN_ON(sofar != len);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e26f1f8..2089844 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -865,6 +865,13 @@ static void ath10k_save_firmware_stack(struct ath10k *ar)
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
@@ -915,8 +922,10 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 
 	spin_lock_irqsave(&ar->crash_data_lock, flags);
 
-	if (!ar->crashed_since_read)
+	if (!ar->crashed_since_read) {
 		ath10k_save_firmware_stack(ar);
+		ath10k_save_firmware_exc_stack(ar);
+	}
 
 	spin_unlock_irqrestore(&ar->crash_data_lock, flags);
 
-- 
1.7.11.7

