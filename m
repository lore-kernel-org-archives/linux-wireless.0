Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34554 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab1LNNcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 08:32:31 -0500
Received: by lagp5 with SMTP id p5so297214lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 05:32:29 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Set wlvif->ps_compl to NULL in before return
Date: Wed, 14 Dec 2011 14:32:23 +0100
Message-Id: <1323869543-2846-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20111214_143234_687012_A874B55E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271_configure_suspend_sta leaves a stale stack declared
completion in wlvif->ps_compl. Set it to NULL before returning.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/wl12xx/main.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2f7bfa8..b9e506d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1585,24 +1585,24 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 
 		ret = wait_for_completion_timeout(
 			&compl, msecs_to_jiffies(WL1271_PS_COMPLETE_TIMEOUT));
+
+		mutex_lock(&wl->mutex);
 		if (ret <= 0) {
 			wl1271_warning("couldn't enter ps mode!");
 			ret = -EBUSY;
-			goto out;
+			goto out_cleanup;
 		}
 
-		/* take mutex again, and wakeup */
-		mutex_lock(&wl->mutex);
-
 		ret = wl1271_ps_elp_wakeup(wl);
 		if (ret < 0)
-			goto out_unlock;
+			goto out_cleanup;
 	}
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
+out_cleanup:
+	wl->ps_compl = NULL;
 out_unlock:
 	mutex_unlock(&wl->mutex);
-out:
 	return ret;
 
 }
-- 
1.7.5.4

