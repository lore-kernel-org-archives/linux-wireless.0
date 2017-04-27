Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36436 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967709AbdD0V2v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 17:28:51 -0400
Received: by mail-qk0-f173.google.com with SMTP id u75so38780712qka.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 14:28:51 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org, sameo@linux.intel.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com,
        wharms@bfs.de, Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH v4] NFC: trf7970a: Correct register settings for 27MHz clock
Date: Thu, 27 Apr 2017 17:28:46 -0400
Message-Id: <1493328526-28395-1-git-send-email-geoff@kuvee.com> (sfid-20170427_233041_194224_2630557C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In prior commits the selected clock frequency does not propagate
correctly to what is written to the TRF7970A_MODULATOR_SYS_CLK_CTRL
register.

Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
---
 drivers/nfc/trf7970a.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 6ed5d7e..f7fee7d 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2067,6 +2067,13 @@ static int trf7970a_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
+	if (clk_freq == TRF7970A_27MHZ_CLOCK_FREQUENCY) {
+		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
+		dev_dbg(trf->dev, "trf7970a configured for 27MHz crystal\n");
+	} else {
+		trf->modulator_sys_clk_ctrl = 0;
+	}
+
 	ret = devm_request_threaded_irq(trf->dev, spi->irq, NULL,
 					trf7970a_irq,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-- 
2.7.4
