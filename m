Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35015 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938062AbdD0BmO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 21:42:14 -0400
Received: by mail-qt0-f182.google.com with SMTP id y33so15442314qta.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 18:42:13 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org, sameo@linux.intel.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com,
        wharms@bfs.de, Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH v2] NFC: trf7970a: Correct register settings for 27MHz clock
Date: Wed, 26 Apr 2017 21:41:48 -0400
Message-Id: <1493257308-32503-1-git-send-email-geoff@kuvee.com> (sfid-20170427_034244_242032_7569F044)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In prior commits the selected clock frequency does not propagate
correctly to what is written the the TRF7970A_MODULATOR_SYS_CLK_CTRL
register.

Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
---
 drivers/nfc/trf7970a.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 5f040e6..c278b0e 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
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
