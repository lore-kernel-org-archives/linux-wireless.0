Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:49835 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbbLVRkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 12:40:03 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH v3] staging: wilc1000: fix double mutex_unlock on failure path in wilc_wlan_cleanup()
Date: Tue, 22 Dec 2015 20:39:26 +0300
Message-Id: <1450805966-9193-1-git-send-email-khoroshilov@ispras.ru> (sfid-20151222_184029_824908_18F8D2F4)
In-Reply-To: <20151221212202.GA11670@kroah.com>
References: <20151221212202.GA11670@kroah.com>
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
index 83af51b..b8c4a63 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1381,15 +1381,16 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		goto unlock;
 	}
 	PRINT_ER("Writing ABORT reg\n");
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_0,
 					(reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		goto unlock;
 	}
+unlock:
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	wilc->hif_func->hif_deinit(NULL);
 }
-- 
1.9.1

