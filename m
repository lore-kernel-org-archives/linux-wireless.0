Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30006 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755550AbdDMIa6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 04:30:58 -0400
Subject: [PATCH v7 09/10] ath10k: different fw file name for sdio
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 13 Apr 2017 11:30:46 +0300
Message-ID: <149207224665.4590.10421467367917959312.stgit@potku.adurom.net> (sfid-20170413_103102_024076_79397424)
In-Reply-To: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
References: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Since both SDIO based chipsets will use different
firmware from the PCIe and AHB chipsets, the fw file name
must be different depending on bus type.

The new firmware names are:

For PCIe and AHB:
firmware-<api_version>.bin (same as before)

For SDIO:
firmware-sdio-<api_version>.bin

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 23cf6b191770..9ae20680bcb6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1398,7 +1398,18 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 static void ath10k_core_get_fw_name(struct ath10k *ar, char *fw_name,
 				    size_t fw_name_len, int fw_api)
 {
-	scnprintf(fw_name, fw_name_len, "%s-%d.bin", ATH10K_FW_FILE_BASE, fw_api);
+	switch (ar->hif.bus) {
+	case ATH10K_BUS_SDIO:
+		scnprintf(fw_name, fw_name_len, "%s-%s-%d.bin",
+			  ATH10K_FW_FILE_BASE, ath10k_bus_str(ar->hif.bus),
+			  fw_api);
+		break;
+	case ATH10K_BUS_PCI:
+	case ATH10K_BUS_AHB:
+		scnprintf(fw_name, fw_name_len, "%s-%d.bin",
+			  ATH10K_FW_FILE_BASE, fw_api);
+		break;
+	}
 }
 
 static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
