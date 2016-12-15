Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33975 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755545AbcLOWa4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 17:30:56 -0500
Received: by mail-qk0-f171.google.com with SMTP id q130so73041249qke.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 14:30:55 -0800 (PST)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgreer@animalcreek.com,
        justin@kuvee.com, Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH 2/3] NFC: trf7970a: Add device tree option of 1.8 Volt IO voltage
Date: Thu, 15 Dec 2016 17:30:43 -0500
Message-Id: <1481841044-4314-2-git-send-email-glansberry@gmail.com> (sfid-20161215_233127_407142_52A28928)
In-Reply-To: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geoff Lansberry <geoff@kuvee.com>

---
 Documentation/devicetree/bindings/net/nfc/trf7970a.txt |  2 ++
 drivers/nfc/trf7970a.c                                 | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
index 9dda879..208f045 100644
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -21,6 +21,7 @@ Optional SoC Specific Properties:
 - t5t-rmb-extra-byte-quirk: Specify that the trf7970a has the erratum
   where an extra byte is returned by Read Multiple Block commands issued
   to Type 5 tags.
+- vdd_io_1v8: Set to specify that the trf7970a io voltage should be set to 1.8V
 - crystal_27mhz: Set to specify that the input frequency to the trf7970a is 27.12MHz
 
 
@@ -45,6 +46,7 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 		irq-status-read-quirk;
 		en2-rf-quirk;
 		t5t-rmb-extra-byte-quirk;
+		vdd_io_1v8;
 		crystal_27mhz;
 		status = "okay";
 	};
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 2d2a077..b4c37ab 100644
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
@@ -1048,6 +1049,11 @@ static int trf7970a_init(struct trf7970a *trf)
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
@@ -1764,7 +1770,7 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 		goto out_err;
 
 	ret = trf7970a_write(trf, TRF7970A_REG_IO_CTRL,
-			TRF7970A_REG_IO_CTRL_VRS(0x1));
+			trf->io_ctrl|TRF7970A_REG_IO_CTRL_VRS(0x1));
 	if (ret)
 		goto out_err;
 
@@ -2058,6 +2064,11 @@ static int trf7970a_probe(struct spi_device *spi)
 		return ret;
 	}
 
+	if (of_property_read_bool(np, "vdd_io_1v8")) {
+		trf->io_ctrl = TRF7970A_REG_IO_CTRL_IO_LOW;
+		dev_dbg(trf->dev, "trf7970a config vdd_io_1v8\n");
+	}
+
 	if (of_property_read_bool(np, "crystal_27mhz")) {
 		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
 		dev_dbg(trf->dev, "trf7970a configure crystal_27mhz\n");
-- 
Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
