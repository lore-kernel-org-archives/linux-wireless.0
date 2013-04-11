Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2376 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab3DKL3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/15] brcmfmac: Add drive strength programming for SDIO
 43143.
Date: Thu, 11 Apr 2013 13:28:55 +0200
Message-ID: <1365679740-25679-11-git-send-email-arend@broadcom.com> (sfid-20130411_132934_656470_3710B3BB)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   53 +++++++++++++-------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 0ac048d..ca72177 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -82,6 +82,14 @@ static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
 	{0, 0x1}
 };
 
+/* SDIO Drive Strength to sel value table for 43143 PMU Rev 17 (3.3V) */
+static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
+	{16, 0x7},
+	{12, 0x5},
+	{8,  0x3},
+	{4,  0x1}
+};
+
 u8
 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid)
 {
@@ -702,21 +710,37 @@ void
 brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info *ci, u32 drivestrength)
 {
-	struct sdiod_drive_str *str_tab = NULL;
-	u32 str_mask = 0;
-	u32 str_shift = 0;
+	const struct sdiod_drive_str *str_tab = NULL;
+	u32 str_mask;
+	u32 str_shift;
 	char chn[8];
 	u32 base = ci->c_inf[0].base;
+	u32 i;
+	u32 drivestrength_sel = 0;
+	u32 cc_data_temp;
+	u32 addr;
 
 	if (!(ci->c_inf[0].caps & CC_CAP_PMU))
 		return;
 
 	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
 	case SDIOD_DRVSTR_KEY(BCM4330_CHIP_ID, 12):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drvstr_tab1_1v8;
+		str_tab = sdiod_drvstr_tab1_1v8;
 		str_mask = 0x00003800;
 		str_shift = 11;
 		break;
+	case SDIOD_DRVSTR_KEY(BCM43143_CHIP_ID, 17):
+		/* note: 43143 does not support tristate */
+		i = ARRAY_SIZE(sdiod_drvstr_tab2_3v3) - 1;
+		if (drivestrength >= sdiod_drvstr_tab2_3v3[i].strength) {
+			str_tab = sdiod_drvstr_tab2_3v3;
+			str_mask = 0x00000007;
+			str_shift = 0;
+		} else
+			brcmf_err("Invalid SDIO Drive strength for chip %s, strength=%d\n",
+				  brcmf_sdio_chip_name(ci->chip, chn, 8),
+				  drivestrength);
+		break;
 	default:
 		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
 			  brcmf_sdio_chip_name(ci->chip, chn, 8),
@@ -725,31 +749,22 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	}
 
 	if (str_tab != NULL) {
-		u32 drivestrength_sel = 0;
-		u32 cc_data_temp;
-		int i;
-
 		for (i = 0; str_tab[i].strength != 0; i++) {
 			if (drivestrength >= str_tab[i].strength) {
 				drivestrength_sel = str_tab[i].sel;
 				break;
 			}
 		}
-
-		brcmf_sdio_regwl(sdiodev, CORE_CC_REG(base, chipcontrol_addr),
-				 1, NULL);
-		cc_data_temp =
-			brcmf_sdio_regrl(sdiodev,
-					 CORE_CC_REG(base, chipcontrol_addr),
-					 NULL);
+		addr = CORE_CC_REG(base, chipcontrol_addr);
+		brcmf_sdio_regwl(sdiodev, addr, 1, NULL);
+		cc_data_temp = brcmf_sdio_regrl(sdiodev, addr, NULL);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		brcmf_sdio_regwl(sdiodev, CORE_CC_REG(base, chipcontrol_addr),
-				 cc_data_temp, NULL);
+		brcmf_sdio_regwl(sdiodev, addr, cc_data_temp, NULL);
 
-		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
-			  drivestrength, cc_data_temp);
+		brcmf_dbg(INFO, "SDIO: %d mA (req=%d mA) drive strength selected, set to 0x%08x\n",
+			  str_tab[i].strength, drivestrength, cc_data_temp);
 	}
 }
 
-- 
1.7.10.4


