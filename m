Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2K0Gp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:29 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:28 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/20] wlcore: take the mutex before resetting Tx queues
Date: Tue, 27 Nov 2012 08:44:53 +0200
Message-Id: <1353998701-18171-13-git-send-email-arik@wizery.com> (sfid-20121127_074612_902307_B1AF6F59)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise we risk contention for private members of our global structure
while op_stop_locked is running.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8932cca..24d5458 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1867,8 +1867,8 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	cancel_delayed_work_sync(&wl->tx_watchdog_work);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl12xx_tx_reset(wl);
 	mutex_lock(&wl->mutex);
+	wl12xx_tx_reset(wl);
 
 	wl1271_power_off(wl);
 	/*
-- 
1.7.9.5

