Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:34534 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3000669AbdDZNtP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 09:49:15 -0400
Received: by mail-qt0-f170.google.com with SMTP id c45so851088qtb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 06:49:15 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org, sameo@linux.intel.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com,
        Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH] NFC: trf7970a: Correct register settings for 27MHz clock
Date: Wed, 26 Apr 2017 09:48:33 -0400
Message-Id: <1493214513-12245-1-git-send-email-geoff@kuvee.com> (sfid-20170426_154943_948695_D0F78EFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In prior commits the selected clock frequency does not propagate
correctly to what is written the the TRF7970A_MODULATOR_SYS_CLK_CTRL
register.
Also fixes a bug that causes the device tree property check to always
pass.

Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
---
 drivers/nfc/trf7970a.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 2d1c8ca..c278b0e 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2071,7 +2071,7 @@ static int trf7970a_probe(struct spi_device *spi)
 	}
 
 	of_property_read_u32(np, "clock-frequency", &clk_freq);
-	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
+	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) &&
 		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
 		dev_err(trf->dev,
 			"clock-frequency (%u Hz) unsupported\n",
@@ -2079,6 +2079,13 @@ static int trf7970a_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
+	if (clk_freq == TRF7970A_27MHZ_CLOCK_FREQUENCY) {
+		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
+		dev_dbg(trf->dev, "trf7970a configured for 27MHz crystal\n");
+	} else {
+		trf->modulator_sys_clk_ctrl = 0;
+	}
+
 	if (of_property_read_bool(np, "en2-rf-quirk"))
 		trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
 
-- 
2.7.4
