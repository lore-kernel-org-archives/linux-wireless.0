Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:33456 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 14:08:34 -0400
Subject: [PATCH v6 5/8] ath10k: dump exception stack contents on firmware crash
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 09 Aug 2014 21:08:30 +0300
Message-ID: <20140809180830.29215.74133.stgit@potku.adurom.net> (sfid-20140809_200836_666544_C2B567BD)
In-Reply-To: <20140809180552.29215.58612.stgit@potku.adurom.net>
References: <20140809180552.29215.58612.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Firmware developers can decode this and maybe figure out
why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    1 +
 drivers/net/wireless/ath/ath10k/debug.c |   11 +++++++++++
 drivers/net/wireless/ath/ath10k/pci.c   |   13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a7634adea320..ffee2b5cdf78 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -302,6 +302,7 @@ struct ath10k_fw_crash_data {
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 	u8 stack_buf[ATH10K_FW_STACK_SIZE];
+	u8 exc_stack_buf[ATH10K_FW_STACK_SIZE];
 };
 
 struct ath10k_debug {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 66bec22d6bc3..06e72e799883 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -32,11 +32,13 @@
  * @ATH10K_FW_CRASH_DUMP_DBGLOG:  Recent firmware debug log entries
  * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
  * @ATH10K_FW_CRASH_DUMP_STACK:   Stack memory contents.
+ * @ATH10K_FW_CRASH_DUMP_EXC_STACK:  Exception stack contents
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_DBGLOG = 0,
 	ATH10K_FW_CRASH_DUMP_REGDUMP = 1,
 	ATH10K_FW_CRASH_DUMP_STACK = 2,
+	ATH10K_FW_CRASH_DUMP_EXC_STACK = 3,
 
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
@@ -727,6 +729,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	len += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
 	len += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
 	len += sizeof(*dump_tlv) + sizeof(crash_data->stack_buf);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->exc_stack_buf);
 
 	sofar += hdr_len;
 
@@ -800,6 +803,14 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	memcpy(dump_tlv->tlv_data, crash_data->stack_buf, dump_tlv->tlv_len);
 	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
 
+	/* Gather firmware exception (irq) stack dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_CRASH_DUMP_EXC_STACK;
+	dump_tlv->tlv_len = sizeof(crash_data->exc_stack_buf);
+	memcpy(dump_tlv->tlv_data, &crash_data->exc_stack_buf,
+	       dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
 	spin_unlock_bh(&ar->data_lock);
 
 	WARN_ON(sofar != len);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8fcc219cd1e9..7ffa2ebffc94 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -879,6 +879,18 @@ static void ath10k_pci_dump_stack(struct ath10k *ar,
 				hi_stack, ATH10K_FW_STACK_SIZE);
 }
 
+/* Save the firmware exception stack */
+static void ath10k_pci_dump_exc_stack(struct ath10k *ar,
+				      struct ath10k_fw_crash_data *crash_data)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	BUILD_BUG_ON(ATH10K_FW_STACK_SIZE % 4);
+
+	ath10k_pci_diag_read_hi(ar, crash_data->exc_stack_buf,
+				hi_err_stack, ATH10K_FW_STACK_SIZE);
+}
+
 static void ath10k_pci_dump_dbglog(struct ath10k *ar,
 				   struct ath10k_fw_crash_data *crash_data)
 {
@@ -1023,6 +1035,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 		goto exit;
 
 	ath10k_pci_dump_stack(ar, crash_data);
+	ath10k_pci_dump_exc_stack(ar, crash_data);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_pci_dump_dbglog(ar, crash_data);
 

