Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34504 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcDRTtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 15:49:17 -0400
Received: by mail-qg0-f50.google.com with SMTP id c6so124735545qga.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 12:49:17 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, mgreer@animalcreek.com, justin@kuvee.com,
	Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH 4/4] NFC: trf7970a: Add device tree option of 1.8 Volt IO voltage
Date: Mon, 18 Apr 2016 15:48:41 -0400
Message-Id: <1461008921-15100-5-git-send-email-geoff@kuvee.com> (sfid-20160418_214920_326517_916563F5)
In-Reply-To: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
---
 Documentation/devicetree/bindings/net/nfc/trf7970a.txt |  8 ++++++++
 drivers/nfc/trf7970a.c                                 | 11 ++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
index bf25f39..e605ebd 100644
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -19,9 +19,13 @@ Optional SoC Specific Properties:
   "IRQ Status Read" erratum.
 - en2-rf-quirk: Specify that the trf7970a being used has the "EN2 RF"
   erratum.
+<<<<<<< HEAD
 - t5t-rmb-extra-byte-quirk: Specify that the trf7970a has the erratum
   where an extra byte is returned by Read Multiple Block commands issued
   to Type 5 tags.
+=======
+- vdd_io_1v8: Set to specify that the trf7970a io voltage should be set to 1.8V
+>>>>>>> e7ea4dd... NFC: trf7970a: Add device tree option of 1.8 Volt IO voltage
 - crystal_27mhz: Set to specify that the input frequency to the trf7970a is 27.12MHz
 
 Example (for ARM-based BeagleBone with TRF7970A on SPI1):
@@ -45,7 +49,11 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 		autosuspend-delay = <30000>;
 		irq-status-read-quirk;
 		en2-rf-quirk;
+<<<<<<< HEAD
 		t5t-rmb-extra-byte-quirk;
+=======
+		vdd_io_1v8;
+>>>>>>> e7ea4dd... NFC: trf7970a: Add device tree option of 1.8 Volt IO voltage
 		crystal_27mhz;
 		status = "okay";
 	};
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 74210f9..be56897 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -441,6 +441,7 @@ struct trf7970a {
 	u8				iso_ctrl_tech;
 	u8				modulator_sys_clk_ctrl;
 	u8				special_fcn_reg1;
+	u8				io_ctrl;
 	unsigned int			guard_time;
 	int				technology;
 	int				framing;
@@ -1064,6 +1065,11 @@ static int trf7970a_init(struct trf7970a *trf)
 	if (ret)
 		goto err_out;
 
+	ret = trf7970a_write(trf, TRF7970A_REG_IO_CTRL,
+			trf->io_ctrl|TRF7970A_REG_IO_CTRL_VRS(0x1));
+	if (ret)
+		goto err_out;
+
 	ret = trf7970a_write(trf, TRF7970A_NFC_TARGET_LEVEL, 0);
 	if (ret)
 		goto err_out;
@@ -1768,7 +1774,7 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 		goto out_err;
 
 	ret = trf7970a_write(trf, TRF7970A_REG_IO_CTRL,
-			TRF7970A_REG_IO_CTRL_VRS(0x1));
+			trf->io_ctrl|TRF7970A_REG_IO_CTRL_VRS(0x1));
 	if (ret)
 		goto out_err;
 
@@ -2075,6 +2081,9 @@ static int trf7970a_probe(struct spi_device *spi)
 		return ret;
 	}
 
+	if (of_property_read_bool(np, "vdd_io_1v8"))
+		trf->io_ctrl = TRF7970A_REG_IO_CTRL_IO_LOW;
+
 	if (of_property_read_bool(np, "crystal_27MHz"))
 		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
 
-- 
1.9.1

