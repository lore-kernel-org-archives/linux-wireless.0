Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:43086 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbbLDWEx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 17:04:53 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: wilc1000: fix double mutex_unlock on failure path in wilc_wlan_cleanup()
Date: Sat,  5 Dec 2015 01:04:34 +0300
Message-Id: <1449266674-6642-1-git-send-email-khoroshilov@ispras.ru> (sfid-20151204_230552_909745_6007C419)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If hif_read_reg() or hif_write_reg() fail in wilc_wlan_cleanup(),
it calls release_bus() and continues execution. But it leads to double
release_bus() call that means double unlock of g_linux_wlan->hif_cs mutex.

The patch adds return in case of failure.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c02665747705..cd7f52a51173 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1703,12 +1703,14 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
 		release_bus(RELEASE_ALLOW_SLEEP);
+		return;
 	}
 	PRINT_ER("Writing ABORT reg\n");
 	ret = p->hif_func.hif_write_reg(WILC_GP_REG_0, (reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
 		release_bus(RELEASE_ALLOW_SLEEP);
+		return;
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
 	/**
-- 
1.9.1

