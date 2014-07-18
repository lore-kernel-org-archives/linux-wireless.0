Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43432 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaGRIA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 04:00:56 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so4226813wes.34
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 01:00:54 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: bzhao@marvell.com, daniel@zonque.org,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH] mwifiex: card reset: enable rescan of non-removable card
Date: Fri, 18 Jul 2014 10:00:37 +0200
Message-Id: <1405670437-18723-1-git-send-email-afenkart@gmail.com> (sfid-20140718_100059_732115_F3546AEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mmc_rescan will scan for non-removable cards only once, hence the card
will not be rediscovered.

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4ce3d7b..eff3d6e 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1931,6 +1931,7 @@ static void sdio_card_reset_worker(struct work_struct *work)
 	mmc_remove_host(target);
 	/* 20ms delay is based on experiment with sdhci controller */
 	mdelay(20);
+	reset_host->rescan_entered = 0; /* rescan non-removable cards */
 	mmc_add_host(target);
 }
 static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
-- 
2.0.1

