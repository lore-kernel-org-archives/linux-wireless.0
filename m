Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:57360 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1A3KgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 05:36:07 -0500
From: Mathias Krause <minipli@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] wl12xx: fix use after free
Date: Sun, 30 Jan 2011 11:29:47 +0100
Message-Id: <1296383387-20151-1-git-send-email-minipli@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When DEBUG_SPI is included in the debug log level wl1271_spi_reset()
will dump the already freed memory instead of the SPI buffer.

This bug was spotted by the semantic patch tool coccinelle using the
script found at scripts/coccinelle/free/kfree.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 drivers/net/wireless/wl12xx/spi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 4671491..7145ea5 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -110,9 +110,8 @@ static void wl1271_spi_reset(struct wl1271 *wl)
 	spi_message_add_tail(&t, &m);
 
 	spi_sync(wl_to_spi(wl), &m);
-	kfree(cmd);
-
 	wl1271_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
+	kfree(cmd);
 }
 
 static void wl1271_spi_init(struct wl1271 *wl)
-- 
1.5.6.5

