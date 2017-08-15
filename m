Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:52491 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751544AbdHOIXq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 04:23:46 -0400
Subject: [PATCH 4/6] ath10k: add coredump_mask module parameter
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 15 Aug 2017 11:23:32 +0300
Message-ID: <150278541205.22482.5490688683381037150.stgit@potku.adurom.net> (sfid-20170815_102351_014619_6D3F3F15)
In-Reply-To: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
References: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For memory dump support (it consumes quite a lot of memory) we need to control
what is exactly stored to the crash dump. Add a module parameter call
coredump_mask to do that. It's a bit mask of these values:

enum ath10k_fw_crash_dump_type {
	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
	ATH10K_FW_CRASH_DUMP_CE_DATA = 1,

	ATH10K_FW_CRASH_DUMP_MAX,
};

For example, if we only want to store CE_DATA we would enable bit 2:

modprobe ath10k_core coredump_mask=0x2

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |    8 ++++
 drivers/net/wireless/ath/ath10k/core.h     |    2 +
 drivers/net/wireless/ath/ath10k/coredump.c |   63 ++++++++++++++++++----------
 3 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7b465973d2ca..ad3cad84fd22 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -40,17 +40,25 @@ static bool uart_print;
 static bool skip_otp;
 static bool rawmode;
 
+/* Enable ATH10K_FW_CRASH_DUMP_REGISTERS and ATH10K_FW_CRASH_DUMP_CE_DATA
+ * by default.
+ */
+unsigned long ath10k_coredump_mask = 0x3;
+
+/* FIXME: most of these should be readonly */
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
 module_param_named(cryptmode, ath10k_cryptmode_param, uint, 0644);
 module_param(uart_print, bool, 0644);
 module_param(skip_otp, bool, 0644);
 module_param(rawmode, bool, 0644);
+module_param_named(coredump_mask, ath10k_coredump_mask, ulong, 0444);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
 MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
 MODULE_PARM_DESC(rawmode, "Use raw 802.11 frame datapath");
+MODULE_PARM_DESC(coredump_mask, "Bitfield of what to include in firmware crash file");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 06f85ae752fe..04c98f00ace2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1015,6 +1015,8 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 	return false;
 }
 
+extern unsigned long ath10k_coredump_mask;
+
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  enum ath10k_bus bus,
 				  enum ath10k_hw_rev hw_rev,
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 512d44fa5848..1a7df3d31b64 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -27,6 +27,10 @@ struct ath10k_fw_crash_data *ath10k_coredump_new(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->data_lock);
 
+	if (ath10k_coredump_mask == 0)
+		/* coredump disabled */
+		return NULL;
+
 	guid_gen(&crash_data->guid);
 	getnstimeofday(&crash_data->timestamp);
 
@@ -45,9 +49,13 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	unsigned char *buf;
 
 	len = hdr_len;
-	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
-	len += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
-		CE_COUNT * sizeof(ce_hdr->entries[0]);
+
+	if (test_bit(ATH10K_FW_CRASH_DUMP_REGISTERS, &ath10k_coredump_mask))
+		len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+
+	if (test_bit(ATH10K_FW_CRASH_DUMP_CE_DATA, &ath10k_coredump_mask))
+		len += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
+			CE_COUNT * sizeof(ce_hdr->entries[0]);
 
 	sofar += hdr_len;
 
@@ -92,25 +100,28 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
 	dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
 
-	/* Gather crash-dump */
-	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
-	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGISTERS);
-	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->registers));
-	memcpy(dump_tlv->tlv_data, &crash_data->registers,
-	       sizeof(crash_data->registers));
-	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
-
-	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
-	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_CE_DATA);
-	dump_tlv->tlv_len = cpu_to_le32(sizeof(*ce_hdr) +
-					CE_COUNT * sizeof(ce_hdr->entries[0]));
-	ce_hdr = (struct ath10k_ce_crash_hdr *)(dump_tlv->tlv_data);
-	ce_hdr->ce_count = cpu_to_le32(CE_COUNT);
-	memset(ce_hdr->reserved, 0, sizeof(ce_hdr->reserved));
-	memcpy(ce_hdr->entries, crash_data->ce_crash_data,
-	       CE_COUNT * sizeof(ce_hdr->entries[0]));
-	sofar += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
-		 CE_COUNT * sizeof(ce_hdr->entries[0]);
+	if (test_bit(ATH10K_FW_CRASH_DUMP_REGISTERS, &ath10k_coredump_mask)) {
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGISTERS);
+		dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->registers));
+		memcpy(dump_tlv->tlv_data, &crash_data->registers,
+		       sizeof(crash_data->registers));
+		sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+	}
+
+	if (test_bit(ATH10K_FW_CRASH_DUMP_CE_DATA, &ath10k_coredump_mask)) {
+		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_CE_DATA);
+		dump_tlv->tlv_len = cpu_to_le32(sizeof(*ce_hdr) +
+						CE_COUNT * sizeof(ce_hdr->entries[0]));
+		ce_hdr = (struct ath10k_ce_crash_hdr *)(dump_tlv->tlv_data);
+		ce_hdr->ce_count = cpu_to_le32(CE_COUNT);
+		memset(ce_hdr->reserved, 0, sizeof(ce_hdr->reserved));
+		memcpy(ce_hdr->entries, crash_data->ce_crash_data,
+		       CE_COUNT * sizeof(ce_hdr->entries[0]));
+		sofar += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
+			CE_COUNT * sizeof(ce_hdr->entries[0]);
+	}
 
 	spin_unlock_bh(&ar->data_lock);
 
@@ -121,6 +132,10 @@ int ath10k_coredump_submit(struct ath10k *ar)
 {
 	struct ath10k_dump_file_data *dump;
 
+	if (ath10k_coredump_mask == 0)
+		/* coredump disabled */
+		return 0;
+
 	dump = ath10k_coredump_build(ar);
 	if (!dump) {
 		ath10k_warn(ar, "no crash dump data found for devcoredump");
@@ -134,6 +149,10 @@ int ath10k_coredump_submit(struct ath10k *ar)
 
 int ath10k_coredump_create(struct ath10k *ar)
 {
+	if (ath10k_coredump_mask == 0)
+		/* coredump disabled */
+		return 0;
+
 	ar->coredump.fw_crash_data = vzalloc(sizeof(*ar->coredump.fw_crash_data));
 	if (!ar->coredump.fw_crash_data)
 		return -ENOMEM;
