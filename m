Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61266 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaKXO3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:29:39 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so5930922wiv.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:29:37 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
Date: Mon, 24 Nov 2014 15:17:24 +0100
Message-Id: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com> (sfid-20141124_152942_472047_415F3649)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make it easier to extend and maintain
list of supported hardware.

As a requirement this moves chip_id checking a
little later because target_version isn't known
until BMI can be queried.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 72 ++++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/core.h |  3 +-
 2 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f660553..3904ce3 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -43,11 +43,21 @@ MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(p2p, "Enable ath10k P2P support");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
 
+static u32 qca988x_supported_chips[] = {
+	/* QCA988X_HW_1_0_CHIP_ID_REV is not supported. It's way too buggy and
+	 * crashes because ath10k doesn't have hacks and workarounds for it.
+	 */
+
+	QCA988X_HW_2_0_CHIP_ID_REV
+};
+
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA988X_HW_2_0_VERSION,
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
+		.supported_chips = qca988x_supported_chips,
+		.num_supported_chips = ARRAY_SIZE(qca988x_supported_chips),
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -719,10 +729,26 @@ static int ath10k_init_uart(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_core_check_chip_id(struct ath10k *ar, u32 chip_id,
+				     const struct ath10k_hw_params *hw_params)
+{
+	u32 hw_revision = MS(chip_id, SOC_CHIP_ID_REV);
+	int i;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip_id 0x%08x hw_revision 0x%x\n",
+		   chip_id, hw_revision);
+
+	for (i = 0; i < hw_params->num_supported_chips; i++)
+		if (hw_params->supported_chips[i] == hw_revision)
+			return 0;
+
+	return -ENOTSUPP;
+}
+
 static int ath10k_init_hw_params(struct ath10k *ar)
 {
 	const struct ath10k_hw_params *uninitialized_var(hw_params);
-	int i;
+	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
 		hw_params = &ath10k_hw_params_list[i];
@@ -737,6 +763,13 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 		return -EINVAL;
 	}
 
+	ret = ath10k_core_check_chip_id(ar, ar->chip_id, hw_params);
+	if (ret) {
+		ath10k_err(ar, "unsupported hardware %s chip_id 0x%08x\n",
+			   hw_params->name, ar->chip_id);
+		return ret;
+	}
+
 	ar->hw_params = *hw_params;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "Hardware name %s version 0x%x\n",
@@ -1055,34 +1088,6 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_core_check_chip_id(struct ath10k *ar)
-{
-	u32 hw_revision = MS(ar->chip_id, SOC_CHIP_ID_REV);
-
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip_id 0x%08x hw_revision 0x%x\n",
-		   ar->chip_id, hw_revision);
-
-	/* Check that we are not using hw1.0 (some of them have same pci id
-	 * as hw2.0) before doing anything else as ath10k crashes horribly
-	 * due to missing hw1.0 workarounds. */
-	switch (hw_revision) {
-	case QCA988X_HW_1_0_CHIP_ID_REV:
-		ath10k_err(ar, "ERROR: qca988x hw1.0 is not supported\n");
-		return -EOPNOTSUPP;
-
-	case QCA988X_HW_2_0_CHIP_ID_REV:
-		/* known hardware revision, continue normally */
-		return 0;
-
-	default:
-		ath10k_warn(ar, "Warning: hardware revision unknown (0x%x), expect problems\n",
-			    ar->chip_id);
-		return 0;
-	}
-
-	return 0;
-}
-
 static void ath10k_core_register_work(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, register_work);
@@ -1130,16 +1135,7 @@ err:
 
 int ath10k_core_register(struct ath10k *ar, u32 chip_id)
 {
-	int status;
-
 	ar->chip_id = chip_id;
-
-	status = ath10k_core_check_chip_id(ar);
-	if (status) {
-		ath10k_err(ar, "Unsupported chip id 0x%08x\n", ar->chip_id);
-		return status;
-	}
-
 	queue_work(ar->workqueue, &ar->register_work);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd3..d37ffd6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -475,7 +475,8 @@ struct ath10k {
 		u32 id;
 		const char *name;
 		u32 patch_load_addr;
-
+		const u32 *supported_chips;
+		int num_supported_chips;
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
-- 
1.8.5.3

