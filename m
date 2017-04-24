Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51710 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171578AbdDXNgG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 09:36:06 -0400
From: Colin King <colin.king@canonical.com>
To: Geoff Lansberry <geoff@kuvee.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: trf7970a: fix check of clock frequencies, use && instead of ||
Date: Mon, 24 Apr 2017 14:36:02 +0100
Message-Id: <20170424133603.3697-1-colin.king@canonical.com> (sfid-20170424_153640_105544_43593ABF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The "or" condition (clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUE) will always be true because
clk_freq cannot be equal to two different values at the same time. Use
the  && operator instead of || to fix this.

Detected by CoverityScan, CID#1430468 ("Constant expression result")

Fixes: 837eb4d21ecde7 ("NFC: trf7970a: add device tree option for 27MHz clock")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/trf7970a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 2d1c8ca6e679..00eb6cd2b22f 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2071,8 +2071,8 @@ static int trf7970a_probe(struct spi_device *spi)
 	}
 
 	of_property_read_u32(np, "clock-frequency", &clk_freq);
-	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
-		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
+	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) &&
+		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
 		dev_err(trf->dev,
 			"clock-frequency (%u Hz) unsupported\n",
 			clk_freq);
-- 
2.11.0
