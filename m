Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38374 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbCSJRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 05:17:47 -0400
Subject: [PATCH] ath10k: bump up FW API to 5
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 19 Mar 2015 11:17:40 +0200
Message-ID: <20150319091740.21481.55203.stgit@potku.adurom.net> (sfid-20150319_101811_552357_1832FEBE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware 10.2.4.48-2 now supports management frames over HTT feature and has
ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX. But as 10.2.4 branch has conflicting HTT ids
patch "ath10k: fix htt t2h message conflicts among firmware revisions" is
needed to fix the issue. Older ath10k versions don't have that fix and to maintain
backwards compatibility we need bump up the FW API to 5 not break older
versions.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    7 +++++++
 drivers/net/wireless/ath/ath10k/hw.h   |    3 +++
 drivers/net/wireless/ath/ath10k/pci.c  |    1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 02da72ec99cf..8c68aa81c8f6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -730,6 +730,13 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	/* calibration file is optional, don't check for any errors */
 	ath10k_fetch_cal_file(ar);
 
+	ar->fw_api = 5;
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API5_FILE);
+	if (ret == 0)
+		goto success;
+
 	ar->fw_api = 4;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 22c993d4fdfc..d0177c05d952 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -78,6 +78,9 @@ enum qca6174_chip_id_rev {
 /* added support for ATH10K_FW_IE_WMI_OP_VERSION */
 #define ATH10K_FW_API4_FILE		"firmware-4.bin"
 
+/* HTT id conflict fix for management frames over HTT */
+#define ATH10K_FW_API5_FILE		"firmware-5.bin"
+
 #define ATH10K_FW_UTF_FILE		"utf.bin"
 
 /* includes also the null byte */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b4aacfad4b24..262a84f67f62 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2780,6 +2780,7 @@ MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_FW_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API2_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API3_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API5_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
 
 /* QCA6174 2.1 firmware files */

