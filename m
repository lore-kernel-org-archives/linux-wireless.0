Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18640 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753368AbdCOPq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 11:46:56 -0400
Subject: [PATCH v6 09/10] ath10k: different fw file names for usb and sdio
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 15 Mar 2017 17:46:44 +0200
Message-ID: <148959280431.31432.16087997710973721077.stgit@potku.adurom.net> (sfid-20170315_164951_337743_9E617FC3)
In-Reply-To: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Since both SDIO and USB based chipsets will use different
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
index d7fb11107df4..d2648d09a772 100644
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
