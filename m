Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:34677 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbbLTVrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 16:47:09 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] staging: wilc1000: fix double mutex_unlock on failure path in wilc_wlan_cleanup()
Date: Mon, 21 Dec 2015 00:46:51 +0300
Message-Id: <1450648011-1381-1-git-send-email-khoroshilov@ispras.ru> (sfid-20151220_224836_720113_D8A46B70)
In-Reply-To: <20151218225010.GA26812@kroah.com>
References: <20151218225010.GA26812@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If hif_read_reg() or hif_write_reg() fail in wilc_wlan_cleanup(),
it calls release_bus() and continues execution. But it leads to double
release_bus() call that means double unlock of g_linux_wlan->hif_cs mutex.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a73e99f..4b7c8e9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1459,15 +1459,16 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	ret = p->hif_func.hif_read_reg(wilc, WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		goto _unlock;
 	}
 	PRINT_ER("Writing ABORT reg\n");
 	ret = p->hif_func.hif_write_reg(wilc, WILC_GP_REG_0,
 					(reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		goto _unlock;
 	}
+_unlock:
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	p->hif_func.hif_deinit(NULL);
 }
-- 
1.9.1

