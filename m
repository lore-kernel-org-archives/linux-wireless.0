Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35235 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcDRTtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 15:49:14 -0400
Received: by mail-qg0-f47.google.com with SMTP id f74so2575365qge.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 12:49:14 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, mgreer@animalcreek.com, justin@kuvee.com,
	Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH 3/4] NFC: trf7970a: add device tree option for 27MHz clock
Date: Mon, 18 Apr 2016 15:48:40 -0400
Message-Id: <1461008921-15100-4-git-send-email-geoff@kuvee.com> (sfid-20160418_214917_829113_288E2DA1)
In-Reply-To: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
---
 .../devicetree/bindings/net/nfc/trf7970a.txt       |  2 ++
 drivers/nfc/trf7970a.c                             | 28 +++++++++++++---------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
index 09c5056..bf25f39 100644
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -22,6 +22,7 @@ Optional SoC Specific Properties:
 - t5t-rmb-extra-byte-quirk: Specify that the trf7970a has the erratum
   where an extra byte is returned by Read Multiple Block commands issued
   to Type 5 tags.
+- crystal_27mhz: Set to specify that the input frequency to the trf7970a is 27.12MHz
 
 Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 
@@ -45,6 +46,7 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 		irq-status-read-quirk;
 		en2-rf-quirk;
 		t5t-rmb-extra-byte-quirk;
+		crystal_27mhz;
 		status = "okay";
 	};
 };
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 447b6c9..74210f9 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1072,12 +1072,11 @@ static int trf7970a_init(struct trf7970a *trf)
 
 	trf->chip_status_ctrl &= ~TRF7970A_CHIP_STATUS_RF_ON;
 
-	ret = trf7970a_write(trf, TRF7970A_MODULATOR_SYS_CLK_CTRL, 0);
+	ret = trf7970a_write(trf, TRF7970A_MODULATOR_SYS_CLK_CTRL,
+			trf->modulator_sys_clk_ctrl);
 	if (ret)
 		goto err_out;
 
-	trf->modulator_sys_clk_ctrl = 0;
-
 	ret = trf7970a_write(trf, TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS,
 			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLH_96 |
 			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLL_32);
@@ -1194,30 +1193,32 @@ static int trf7970a_in_config_rf_tech(struct trf7970a *trf, int tech)
 
 	dev_dbg(trf->dev, "rf technology: %d\n", tech);
 
+	trf->modulator_sys_clk_ctrl = (trf->modulator_sys_clk_ctrl&0xF8);
+
 	switch (tech) {
 	case NFC_DIGITAL_RF_TECH_106A:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_14443A_106;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_OOK;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_OOK;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCA;
 		break;
 	case NFC_DIGITAL_RF_TECH_106B:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_14443B_106;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_ASK10;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_ASK10;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCB;
 		break;
 	case NFC_DIGITAL_RF_TECH_212F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_FELICA_212;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_ASK10;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_ASK10;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCF;
 		break;
 	case NFC_DIGITAL_RF_TECH_424F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_FELICA_424;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_ASK10;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_ASK10;
 		trf->guard_time = TRF7970A_GUARD_TIME_NFCF;
 		break;
 	case NFC_DIGITAL_RF_TECH_ISO15693:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_15693_SGL_1OF4_2648;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_OOK;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_OOK;
 		trf->guard_time = TRF7970A_GUARD_TIME_15693;
 		break;
 	default:
@@ -1582,22 +1583,24 @@ static int trf7970a_tg_config_rf_tech(struct trf7970a *trf, int tech)
 
 	dev_dbg(trf->dev, "rf technology: %d\n", tech);
 
+	trf->modulator_sys_clk_ctrl = (trf->modulator_sys_clk_ctrl&0xF8);
+
 	switch (tech) {
 	case NFC_DIGITAL_RF_TECH_106A:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_NFC_NFC_CE_MODE |
 			TRF7970A_ISO_CTRL_NFC_CE |
 			TRF7970A_ISO_CTRL_NFC_CE_14443A;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_OOK;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_OOK;
 		break;
 	case NFC_DIGITAL_RF_TECH_212F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_NFC_NFC_CE_MODE |
 			TRF7970A_ISO_CTRL_NFC_NFCF_212;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_ASK10;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_ASK10;
 		break;
 	case NFC_DIGITAL_RF_TECH_424F:
 		trf->iso_ctrl_tech = TRF7970A_ISO_CTRL_NFC_NFC_CE_MODE |
 			TRF7970A_ISO_CTRL_NFC_NFCF_424;
-		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_DEPTH_ASK10;
+		trf->modulator_sys_clk_ctrl |= TRF7970A_MODULATOR_DEPTH_ASK10;
 		break;
 	default:
 		dev_dbg(trf->dev, "Unsupported rf technology: %d\n", tech);
@@ -2072,6 +2075,9 @@ static int trf7970a_probe(struct spi_device *spi)
 		return ret;
 	}
 
+	if (of_property_read_bool(np, "crystal_27MHz"))
+		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
+
 	if (of_property_read_bool(np, "en2-rf-quirk"))
 		trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
 
-- 
1.9.1

