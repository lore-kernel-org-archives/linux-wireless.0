Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16710 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbbCRMZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: only support the BCM43455/7 device
Date: Wed, 18 Mar 2015 13:25:27 +0100
Message-ID: <1426681528-15831-8-git-send-email-arend@broadcom.com> (sfid-20150318_132557_574757_C5436643)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently support was added for the BCM4345 SDIO chipset by
commit 9c51026509d7 ("brcmfmac: Add support for BCM4345 SDIO chipset")
however this was verified using a BCM43455 device, which is
a more recent revision of the chip. This patch assure that
older revisions are not probed as they would fail.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Syed Asifful Dayyan <syedd@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index e162860..ab0c898 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -617,8 +617,8 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 #define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
 #define BCM43430_FIRMWARE_NAME		"brcm/brcmfmac43430-sdio.bin"
 #define BCM43430_NVRAM_NAME		"brcm/brcmfmac43430-sdio.txt"
-#define BCM4345_FIRMWARE_NAME		"brcm/brcmfmac4345-sdio.bin"
-#define BCM4345_NVRAM_NAME		"brcm/brcmfmac4345-sdio.txt"
+#define BCM43455_FIRMWARE_NAME		"brcm/brcmfmac43455-sdio.bin"
+#define BCM43455_NVRAM_NAME		"brcm/brcmfmac43455-sdio.txt"
 #define BCM4354_FIRMWARE_NAME		"brcm/brcmfmac4354-sdio.bin"
 #define BCM4354_NVRAM_NAME		"brcm/brcmfmac4354-sdio.txt"
 
@@ -644,8 +644,8 @@ MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
 MODULE_FIRMWARE(BCM43430_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43430_NVRAM_NAME);
-MODULE_FIRMWARE(BCM4345_FIRMWARE_NAME);
-MODULE_FIRMWARE(BCM4345_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43455_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43455_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4354_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4354_NVRAM_NAME);
 
@@ -676,7 +676,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
 	{ BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
 	{ BRCM_CC_43430_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43430) },
-	{ BRCM_CC_4345_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4345) },
+	{ BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, BRCMF_FIRMWARE_NVRAM(BCM43455) },
 	{ BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
 
-- 
1.9.1

