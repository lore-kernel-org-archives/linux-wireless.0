Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:50368 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbDNSKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:10:41 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: add support for BCM4324 rev B5 chipset
Date: Tue, 14 Apr 2015 20:10:28 +0200
Message-ID: <1429035033-14076-6-git-send-email-arend@broadcom.com> (sfid-20150414_201056_253961_4131589E)
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the BCM4324 B5 revision. This device
is similar to BCM43241 from driver and firmware perspective. It
is known to be used in Lenovo Thinkpad Tablet devices.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index ab0c898..cbdda54 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -601,6 +601,8 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 #define BCM43241B0_NVRAM_NAME		"brcm/brcmfmac43241b0-sdio.txt"
 #define BCM43241B4_FIRMWARE_NAME	"brcm/brcmfmac43241b4-sdio.bin"
 #define BCM43241B4_NVRAM_NAME		"brcm/brcmfmac43241b4-sdio.txt"
+#define BCM43241B5_FIRMWARE_NAME	"brcm/brcmfmac43241b5-sdio.bin"
+#define BCM43241B5_NVRAM_NAME		"brcm/brcmfmac43241b5-sdio.txt"
 #define BCM4329_FIRMWARE_NAME		"brcm/brcmfmac4329-sdio.bin"
 #define BCM4329_NVRAM_NAME		"brcm/brcmfmac4329-sdio.txt"
 #define BCM4330_FIRMWARE_NAME		"brcm/brcmfmac4330-sdio.bin"
@@ -628,6 +630,8 @@ MODULE_FIRMWARE(BCM43241B0_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43241B0_NVRAM_NAME);
 MODULE_FIRMWARE(BCM43241B4_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43241B4_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43241B5_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43241B5_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4329_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4329_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4330_FIRMWARE_NAME);
@@ -667,7 +671,8 @@ enum brcmf_firmware_type {
 static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43143) },
 	{ BRCM_CC_43241_CHIP_ID, 0x0000001F, BRCMF_FIRMWARE_NVRAM(BCM43241B0) },
-	{ BRCM_CC_43241_CHIP_ID, 0xFFFFFFE0, BRCMF_FIRMWARE_NVRAM(BCM43241B4) },
+	{ BRCM_CC_43241_CHIP_ID, 0x00000020, BRCMF_FIRMWARE_NVRAM(BCM43241B4) },
+	{ BRCM_CC_43241_CHIP_ID, 0xFFFFFFC0, BRCMF_FIRMWARE_NVRAM(BCM43241B5) },
 	{ BRCM_CC_4329_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4329) },
 	{ BRCM_CC_4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
 	{ BRCM_CC_4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
-- 
1.9.1

