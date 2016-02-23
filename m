Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16813 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbcBWMNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 07:13:31 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/2] staging: wilc1000: removes unnecessary retry 3 times
Date: Tue, 23 Feb 2016 21:10:53 +0900
Message-ID: <1456229454-16649-1-git-send-email-leo.kim@atmel.com> (sfid-20160223_131341_293979_493552F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary retry 3 times and related variable.
Actually the retry 3 times sentence, don't retry at all.
Repeats conditions are that until read a chip-id and written a register.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d50ddc6..e5a83cc 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -477,7 +477,7 @@ EXPORT_SYMBOL_GPL(chip_allow_sleep);
 
 void chip_wakeup(struct wilc *wilc)
 {
-	u32 reg, clk_status_reg, trials = 0;
+	u32 reg, clk_status_reg;
 
 	if ((wilc->io_type & 0x1) == HIF_SPI) {
 		do {
@@ -488,8 +488,7 @@ void chip_wakeup(struct wilc *wilc)
 			do {
 				usleep_range(2 * 1000, 2 * 1000);
 				wilc_get_chipid(wilc, true);
-			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
-
+			} while (wilc_get_chipid(wilc, true) == 0);
 		} while (wilc_get_chipid(wilc, true) == 0);
 	} else if ((wilc->io_type & 0x1) == HIF_SDIO)	 {
 		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
@@ -501,7 +500,7 @@ void chip_wakeup(struct wilc *wilc)
 			wilc->hif_func->hif_read_reg(wilc, 0xf1,
 						     &clk_status_reg);
 
-			while (((clk_status_reg & 0x1) == 0) && (((++trials) % 3) == 0)) {
+			while ((clk_status_reg & 0x1) == 0) {
 				usleep_range(2 * 1000, 2 * 1000);
 
 				wilc->hif_func->hif_read_reg(wilc, 0xf1,
-- 
1.9.1

