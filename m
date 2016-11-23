Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:53049 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933573AbcKWKft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:35:49 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: add support for 43341 chip
Date: Wed, 23 Nov 2016 10:25:21 +0000
Message-Id: <1479896731-5091-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_113559_723557_609AF772)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This chip was already supported, but seems a device came up giving
a different chip identifier. So adding that effectively mapping to
the same firmware file as for 43340 chip.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       | 1 +
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b892dac..dfb0658 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -621,6 +621,7 @@ struct sdiod_drive_str {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4330_CHIP_ID, 0xFFFFFFFF, 4330),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4334_CHIP_ID, 0xFFFFFFFF, 4334),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43340_CHIP_ID, 0xFFFFFFFF, 43340),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43341_CHIP_ID, 0xFFFFFFFF, 43340),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, 4335),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, 43362),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index d0407d9..f1fb8a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -36,6 +36,7 @@
 #define BRCM_CC_4330_CHIP_ID		0x4330
 #define BRCM_CC_4334_CHIP_ID		0x4334
 #define BRCM_CC_43340_CHIP_ID		43340
+#define BRCM_CC_43341_CHIP_ID		43341
 #define BRCM_CC_43362_CHIP_ID		43362
 #define BRCM_CC_4335_CHIP_ID		0x4335
 #define BRCM_CC_4339_CHIP_ID		0x4339
-- 
1.9.1
