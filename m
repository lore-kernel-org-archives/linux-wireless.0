Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59388 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab0LUEAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 23:00:32 -0500
Date: Tue, 21 Dec 2010 07:00:13 +0300
From: Dan Carpenter <error27@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] wl12xx: use after free in debug code
Message-ID: <20101221040012.GD1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If debugging is turned on, then wl1271_dump() dereferences a freed
variable.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 4671491..8f7ea2c 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -110,9 +110,9 @@ static void wl1271_spi_reset(struct wl1271 *wl)
 	spi_message_add_tail(&t, &m);
 
 	spi_sync(wl_to_spi(wl), &m);
-	kfree(cmd);
 
 	wl1271_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
+	kfree(cmd);
 }
 
 static void wl1271_spi_init(struct wl1271 *wl)
