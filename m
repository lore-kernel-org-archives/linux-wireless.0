Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34270 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753754AbdBUQQb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:31 -0500
Received: by mail-lf0-f66.google.com with SMTP id h67so3752237lfg.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:30 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 13/21] ath10k: different fw file names for usb and sdio
Date: Tue, 21 Feb 2017 17:15:33 +0100
Message-Id: <1487693741-10042-14-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_171706_415636_3AE11E59)
In-Reply-To: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since both SDIO and USB based chipsets will use different
firmware from the PCIe and AHB chipsets, the fw file name
must be different depending on bus type.

The new firmware names are:

For PCIe and AHB:
firmware-<api_version>.bin (same as before)

For SDIO:
firmware-sdio-<api_version>.bin

For USB:
firmware-usb-<api_version>.bin

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 39c407e..9d60f4b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1387,7 +1387,13 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 static void ath10k_core_get_fw_name(struct ath10k *ar, char *fw_name,
 				    size_t fw_name_len, int fw_api)
 {
-	scnprintf(fw_name, fw_name_len, "%s-%d.bin", ATH10K_FW_FILE_BASE, fw_api);
+	if ((ar->hif.bus != ATH10K_BUS_PCI) && (ar->hif.bus != ATH10K_BUS_AHB))
+		scnprintf(fw_name, fw_name_len, "%s-%s-%d.bin",
+			  ATH10K_FW_FILE_BASE, ath10k_bus_str(ar->hif.bus),
+			  fw_api);
+	else
+		scnprintf(fw_name, fw_name_len, "%s-%d.bin",
+			  ATH10K_FW_FILE_BASE, fw_api);
 }
 
 static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
-- 
2.7.4
