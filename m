Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35232 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdFPO5q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:57:46 -0400
Received: by mail-pg0-f66.google.com with SMTP id f127so6641016pgc.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:57:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 04/20] rsi: correct SDIO disconnect path handling
Date: Fri, 16 Jun 2017 20:24:25 +0530
Message-Id: <1497624881-2315-5-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165749_231772_19D4F90E)
In-Reply-To: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

Sometimes it's observed that we get interrupt/Rx frame when device is
already detached from mac80211. In this case couple of error messages
are displayed in dmesg log. This patch corrects the order so that
disconnection will happen cleanly

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index ebfd29c..f1ba8ac 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1026,17 +1026,26 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 		return;
 
 	dev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	sdio_claim_host(pfunction);
+	sdio_release_irq(pfunction);
+	sdio_release_host(pfunction);
+	mdelay(10);
 
-	dev->write_fail = 2;
 	rsi_mac80211_detach(adapter);
+	mdelay(10);
 
-	sdio_claim_host(pfunction);
-	sdio_release_irq(pfunction);
-	sdio_disable_func(pfunction);
-	rsi_91x_deinit(adapter);
+	/* Reset Chip */
 	rsi_reset_chip(adapter);
+
+	/* Resetting to take care of the case, where-in driver is re-loaded */
+	sdio_claim_host(pfunction);
 	rsi_reset_card(pfunction);
+	sdio_disable_func(pfunction);
 	sdio_release_host(pfunction);
+	dev->write_fail = 2;
+	rsi_91x_deinit(adapter);
+	rsi_dbg(ERR_ZONE, "##### RSI SDIO device disconnected #####\n");
+
 }
 
 #ifdef CONFIG_PM
-- 
2.7.4
