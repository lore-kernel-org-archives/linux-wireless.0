Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34252 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdIUMnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 08:43:14 -0400
From: Allen Pais <allen.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 1/1] wireless: broadcom: brcm80211: use setup_timer() helper
Date: Thu, 21 Sep 2017 18:13:06 +0530
Message-Id: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com> (sfid-20170921_144330_747713_90BFD356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    Use setup_timer function instead of initializing timer with the
    function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 613caca..5adce0e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4144,10 +4144,8 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	init_waitqueue_head(&bus->dcmd_resp_wait);
 
 	/* Set up the watchdog timer */
-	init_timer(&bus->timer);
-	bus->timer.data = (unsigned long)bus;
-	bus->timer.function = brcmf_sdio_watchdog;
-
+	setup_timer(&bus->timer, brcmf_sdio_watchdog,
+		    (unsigned long)bus);
 	/* Initialize watchdog thread */
 	init_completion(&bus->watchdog_wait);
 	bus->watchdog_tsk = kthread_run(brcmf_sdio_watchdog_thread,
-- 
2.7.4
