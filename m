Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51413 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3IHOzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:55:35 -0400
Subject: [PATCH 1/8] ath10k: add BMI log level
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:55:32 +0300
Message-ID: <20130908145532.3136.17406.stgit@localhost6.localdomain6> (sfid-20130908_165541_965247_ABE40882)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also clean BMI log messages and add few more.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c   |   42 ++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/debug.h |    1 +
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 744da6d..a1f0996 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -22,7 +22,8 @@
 
 void ath10k_bmi_start(struct ath10k *ar)
 {
-	ath10k_dbg(ATH10K_DBG_CORE, "BMI started\n");
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi start\n");
+
 	ar->bmi.done_sent = false;
 }
 
@@ -32,8 +33,10 @@ int ath10k_bmi_done(struct ath10k *ar)
 	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.done);
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi done\n");
+
 	if (ar->bmi.done_sent) {
-		ath10k_dbg(ATH10K_DBG_CORE, "%s skipped\n", __func__);
+		ath10k_dbg(ATH10K_DBG_BMI, "bmi skipped\n");
 		return 0;
 	}
 
@@ -46,7 +49,6 @@ int ath10k_bmi_done(struct ath10k *ar)
 		return ret;
 	}
 
-	ath10k_dbg(ATH10K_DBG_CORE, "BMI done\n");
 	return 0;
 }
 
@@ -59,6 +61,8 @@ int ath10k_bmi_get_target_info(struct ath10k *ar,
 	u32 resplen = sizeof(resp.get_target_info);
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi get target info\n");
+
 	if (ar->bmi.done_sent) {
 		ath10k_warn("BMI Get Target Info Command disallowed\n");
 		return -EBUSY;
@@ -80,6 +84,7 @@ int ath10k_bmi_get_target_info(struct ath10k *ar,
 
 	target_info->version = __le32_to_cpu(resp.get_target_info.version);
 	target_info->type    = __le32_to_cpu(resp.get_target_info.type);
+
 	return 0;
 }
 
@@ -92,15 +97,14 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
 	u32 rxlen;
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi read address 0x%x length %d\n",
+		   address, length);
+
 	if (ar->bmi.done_sent) {
 		ath10k_warn("command disallowed\n");
 		return -EBUSY;
 	}
 
-	ath10k_dbg(ATH10K_DBG_CORE,
-		   "%s: (device: 0x%p, address: 0x%x, length: %d)\n",
-		   __func__, ar, address, length);
-
 	while (length) {
 		rxlen = min_t(u32, length, BMI_MAX_DATA_SIZE);
 
@@ -133,15 +137,14 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 	u32 txlen;
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi write address 0x%x length %d\n",
+		   address, length);
+
 	if (ar->bmi.done_sent) {
 		ath10k_warn("command disallowed\n");
 		return -EBUSY;
 	}
 
-	ath10k_dbg(ATH10K_DBG_CORE,
-		   "%s: (device: 0x%p, address: 0x%x, length: %d)\n",
-		   __func__, ar, address, length);
-
 	while (length) {
 		txlen = min(length, BMI_MAX_DATA_SIZE - hdrlen);
 
@@ -180,15 +183,14 @@ int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 *param)
 	u32 resplen = sizeof(resp.execute);
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi execute address 0x%x param 0x%x\n",
+		   address, *param);
+
 	if (ar->bmi.done_sent) {
 		ath10k_warn("command disallowed\n");
 		return -EBUSY;
 	}
 
-	ath10k_dbg(ATH10K_DBG_CORE,
-		   "%s: (device: 0x%p, address: 0x%x, param: %d)\n",
-		   __func__, ar, address, *param);
-
 	cmd.id            = __cpu_to_le32(BMI_EXECUTE);
 	cmd.execute.addr  = __cpu_to_le32(address);
 	cmd.execute.param = __cpu_to_le32(*param);
@@ -216,6 +218,9 @@ int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length)
 	u32 txlen;
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi lz data buffer 0x%p length %d\n",
+		   buffer, length);
+
 	if (ar->bmi.done_sent) {
 		ath10k_warn("command disallowed\n");
 		return -EBUSY;
@@ -250,6 +255,9 @@ int ath10k_bmi_lz_stream_start(struct ath10k *ar, u32 address)
 	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.lz_start);
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi lz stream start address 0x%x\n",
+		   address);
+
 	if (ar->bmi.done_sent) {
 		ath10k_warn("command disallowed\n");
 		return -EBUSY;
@@ -275,6 +283,10 @@ int ath10k_bmi_fast_download(struct ath10k *ar,
 	u32 trailer_len = length - head_len;
 	int ret;
 
+	ath10k_dbg(ATH10K_DBG_BMI,
+		   "bmi fast download address 0x%x buffer 0x%p length %d\n",
+		   address, buffer, length);
+
 	ret = ath10k_bmi_lz_stream_start(ar, address);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 9c442a8..dfa3070 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -32,6 +32,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_HTT_DUMP	= 0x00000080,
 	ATH10K_DBG_MGMT		= 0x00000100,
 	ATH10K_DBG_DATA		= 0x00000200,
+	ATH10K_DBG_BMI		= 0x00000400,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 

