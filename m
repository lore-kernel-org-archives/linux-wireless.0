Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35479 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0LRIw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 03:52:27 -0500
Date: Sat, 18 Dec 2010 11:52:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] wl1251: wl12xx_get_platform_data() returns an ERR_PTR
Message-ID: <20101218085210.GO1639@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx_get_platform_data() returns an ERR_PTR on failure and it never
returns a NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index 596d90e..d550b5e 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -252,7 +252,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	wl->if_ops = &wl1251_sdio_ops;
 
 	wl12xx_board_data = wl12xx_get_platform_data();
-	if (wl12xx_board_data != NULL) {
+	if (!IS_ERR(wl12xx_board_data)) {
 		wl->set_power = wl12xx_board_data->set_power;
 		wl->irq = wl12xx_board_data->irq;
 		wl->use_eeprom = wl12xx_board_data->use_eeprom;
