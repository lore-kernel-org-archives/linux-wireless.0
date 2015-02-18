Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:38019 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbBRMQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 07:16:42 -0500
Received: by wesw55 with SMTP id w55so788125wes.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 04:16:41 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: update MODULE_FIRMWARE definitions for QCA6174
Date: Wed, 18 Feb 2015 13:16:37 +0100
Message-Id: <1424261797-9474-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20150218_131647_002643_E9A7ED59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has been missed while adding the QCA6174 support.
As in the last time, without advertising the firmware files
as needed (or optional) for ath10k, these won't be built into
ram disk for instance.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 631b026a487b..a238a141b22a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2770,7 +2770,18 @@ module_exit(ath10k_pci_exit);
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_DESCRIPTION("Driver support for Atheros QCA988X PCIe devices");
 MODULE_LICENSE("Dual BSD/GPL");
+
+/* QCA988x 2.0 firmware files */
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_FW_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API2_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API3_FILE);
+MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API4_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
+
+/* QCA6174 2.1 firmware files */
+MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" QCA6174_HW_2_1_BOARD_DATA_FILE);
+
+/* QCA6174 3.1 firmware files */
+MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" QCA6174_HW_3_0_BOARD_DATA_FILE);
-- 
2.1.2

