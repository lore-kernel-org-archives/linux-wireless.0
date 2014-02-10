Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57661 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaBJLsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:07 -0500
Received: by mail-wg0-f41.google.com with SMTP id n12so2466313wgh.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:06 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/18] wlcore: decrease warning verbosity during recovery
Date: Mon, 10 Feb 2014 13:47:31 +0200
Message-Id: <1392032854-28126-16-git-send-email-eliad@wizery.com> (sfid-20140210_130006_987049_BB872BC7)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Silently ignore repetitive scheduling of recovery work and commands
being passed to the bus when the HW is not available. This can happen
many times during recovery and slow it down. It also spams the kernel
logs.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c  | 4 ++--
 drivers/net/wireless/ti/wlcore/main.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 3463a67..40dc30f 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -60,8 +60,8 @@ static int __wlcore_cmd_send(struct wl1271 *wl, u16 id, void *buf,
 	u16 status;
 	u16 poll_count = 0;
 
-	if (WARN_ON(wl->state == WLCORE_STATE_RESTARTING &&
-		    id != CMD_STOP_FWLOGGER))
+	if (unlikely(wl->state == WLCORE_STATE_RESTARTING &&
+		     id != CMD_STOP_FWLOGGER))
 		return -EIO;
 
 	cmd = buf;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8106c96..a2348b9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -782,10 +782,11 @@ out:
 
 void wl12xx_queue_recovery_work(struct wl1271 *wl)
 {
-	WARN_ON(!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
-
 	/* Avoid a recursive recovery */
 	if (wl->state == WLCORE_STATE_ON) {
+		WARN_ON(!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY,
+				  &wl->flags));
+
 		wl->state = WLCORE_STATE_RESTARTING;
 		set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 		wl1271_ps_elp_wakeup(wl);
-- 
1.8.5.2.229.g4448466.dirty

