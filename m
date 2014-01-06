Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:46431 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaAFLk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/15] brcmfmac: add sdio drive strength programming for bcm4334 chipset
Date: Mon, 6 Jan 2014 12:40:42 +0100
Message-ID: <1389008450-28529-8-git-send-email-arend@broadcom.com> (sfid-20140106_124129_154774_B94200B9)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The table for BCM4334 SDIO drive strength programming was missing
from the driver. Adding it with this patch set.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 5f39f28..6aa6ba0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -83,6 +83,13 @@ static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
 	{0, 0x1}
 };
 
+/* SDIO Drive Strength to sel value table for PMU Rev 17 (1.8v) */
+static const struct sdiod_drive_str sdiod_drvstr_tab6_1v8[] = {
+	{3, 0x3},
+	{2, 0x2},
+	{1, 0x1},
+	{0, 0x0} };
+
 /* SDIO Drive Strength to sel value table for 43143 PMU Rev 17 (3.3V) */
 static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 	{16, 0x7},
@@ -757,6 +764,11 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		str_mask = 0x00003800;
 		str_shift = 11;
 		break;
+	case SDIOD_DRVSTR_KEY(BCM4334_CHIP_ID, 17):
+		str_tab = sdiod_drvstr_tab6_1v8;
+		str_mask = 0x00001800;
+		str_shift = 11;
+		break;
 	case SDIOD_DRVSTR_KEY(BCM43143_CHIP_ID, 17):
 		/* note: 43143 does not support tristate */
 		i = ARRAY_SIZE(sdiod_drvstr_tab2_3v3) - 1;
-- 
1.7.10.4

