Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36179 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756264AbdETUeC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 16:34:02 -0400
Received: by mail-lf0-f68.google.com with SMTP id h4so2393485lfj.3
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 13:34:01 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 2/3] ath10k: different fw file names for usb
Date: Sat, 20 May 2017 22:33:29 +0200
Message-Id: <1495312410-9937-3-git-send-email-erik.stromdahl@gmail.com> (sfid-20170520_223413_022397_507645B0)
In-Reply-To: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com>
References: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB firmware will be named in the same way as SDIO files,
i.e, the bus type will be added to the firmware file name.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index eea111d..46ce263 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1412,6 +1412,7 @@ static void ath10k_core_get_fw_name(struct ath10k *ar, char *fw_name,
 {
 	switch (ar->hif.bus) {
 	case ATH10K_BUS_SDIO:
+	case ATH10K_BUS_USB:
 		scnprintf(fw_name, fw_name_len, "%s-%s-%d.bin",
 			  ATH10K_FW_FILE_BASE, ath10k_bus_str(ar->hif.bus),
 			  fw_api);
-- 
2.7.4
