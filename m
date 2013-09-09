Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:44301 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3IIJZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:07 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so4061037wes.29
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:25:06 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/13] wlcore: wakeup from ELP before starting recovery
Date: Mon,  9 Sep 2013 12:24:41 +0300
Message-Id: <1378718684-14430-10-git-send-email-eliad@wizery.com> (sfid-20130909_112516_137233_8D3DE1F5)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Barak Bercovitz <barak@wizery.com>

Make sure the FW is awake when entering recovery. This is useful for
reading the FW panic log and also some FW registers giving us crash
report stats.

We must do this before interrupts are disabled since we rely on an
interrupt to complete the wakeup.

If the wakeup fails, continue recovery normally. All read/writes will be
blocked and won't do any harm.

Signed-off-by: Barak Bercovitz <barak@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8639ea9..60b2113 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -793,6 +793,7 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
 	if (wl->state == WLCORE_STATE_ON) {
 		wl->state = WLCORE_STATE_RESTARTING;
 		set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
+		wl1271_ps_elp_wakeup(wl);
 		wlcore_disable_interrupts_nosync(wl);
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	}
-- 
1.8.3.rc1.35.g9b79519

