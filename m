Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2132 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/23] brcm80211: fmac: remove drive strength code for
 unsupported chips
Date: Thu, 8 Dec 2011 15:06:40 -0800
Message-ID: <1323385619-7454-5-git-send-email-frankyl@broadcom.com> (sfid-20111209_000730_750124_C0571E3F)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcm4325 and bcm4336 are not supported by brcmfmac. Remove the
drive strength setting code specific for these chips.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   52 +-------------------
 1 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index d299059..a6048d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -59,40 +59,8 @@ struct sdiod_drive_str {
 	u8 strength;	/* Pad Drive Strength in mA */
 	u8 sel;		/* Chip-specific select value */
 };
-/* SDIO Drive Strength to sel value table for PMU Rev 1 */
-static const struct sdiod_drive_str sdiod_drive_strength_tab1[] = {
-	{
-	4, 0x2}, {
-	2, 0x3}, {
-	1, 0x0}, {
-	0, 0x0}
-	};
-/* SDIO Drive Strength to sel value table for PMU Rev 2, 3 */
-static const struct sdiod_drive_str sdiod_drive_strength_tab2[] = {
-	{
-	12, 0x7}, {
-	10, 0x6}, {
-	8, 0x5}, {
-	6, 0x4}, {
-	4, 0x2}, {
-	2, 0x1}, {
-	0, 0x0}
-	};
-/* SDIO Drive Strength to sel value table for PMU Rev 8 (1.8V) */
-static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
-	{
-	32, 0x7}, {
-	26, 0x6}, {
-	22, 0x5}, {
-	16, 0x4}, {
-	12, 0x3}, {
-	8, 0x2}, {
-	4, 0x1}, {
-	0, 0x0}
-	};
-
 /* SDIO Drive Strength to sel value table for PMU Rev 11 (1.8V) */
-static const struct sdiod_drive_str sdiod_drvstr_tab4_1v8[] = {
+static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
 	{32, 0x6},
 	{26, 0x7},
 	{22, 0x4},
@@ -598,24 +566,8 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		return;
 
 	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 1):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab1;
-		str_mask = 0x30000000;
-		str_shift = 28;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 2):
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 3):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab2;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4336_CHIP_ID, 8):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab3;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
 	case SDIOD_DRVSTR_KEY(BCM4330_CHIP_ID, 12):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drvstr_tab4_1v8;
+		str_tab = (struct sdiod_drive_str *)&sdiod_drvstr_tab1_1v8;
 		str_mask = 0x00003800;
 		str_shift = 11;
 		break;
-- 
1.7.5.4


