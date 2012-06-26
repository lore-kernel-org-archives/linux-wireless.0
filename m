Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55647 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab2FZUDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:03:17 -0400
Received: by lbbgj10 with SMTP id gj10so664583lbb.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:03:14 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 5/5] wlcore: print stack trace in every recovery
Date: Tue, 26 Jun 2012 23:03:00 +0300
Message-Id: <1340740980-22284-6-git-send-email-coelho@ti.com> (sfid-20120626_220321_158811_CE834B52)
In-Reply-To: <1340740980-22284-1-git-send-email-coelho@ti.com>
References: <1340740980-22284-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

As recovery queuing can now occur from multiple code paths
it's convenient to know what triggered it in all cases
other than an intended recovery which is part of the
switch between single role to multi role.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c  |    1 -
 drivers/net/wireless/ti/wlcore/main.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index ef13938..56c7a23 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -124,7 +124,6 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	return 0;
 
 fail:
-	WARN_ON(1);
 	wl12xx_queue_recovery_work(wl);
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c5a9ffe..2240cca 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -772,6 +772,8 @@ out:
 
 void wl12xx_queue_recovery_work(struct wl1271 *wl)
 {
+	WARN_ON(!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
+
 	/* Avoid a recursive recovery */
 	if (!test_and_set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
 		wlcore_disable_interrupts_nosync(wl);
-- 
1.7.10

