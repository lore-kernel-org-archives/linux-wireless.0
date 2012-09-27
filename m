Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47746 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab2I0Kio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:44 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 22/31] wlcore: Don't recover during boot
Date: Thu, 27 Sep 2012 13:38:00 +0300
Message-Id: <1348742289-6587-23-git-send-email-luca@coelho.fi> (sfid-20120927_123859_792956_017B8731)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

While recursive recovery is avoided during shutdown, a new recovery may
be queued when the FW boots. The recovery work will then try to stop an
already stopped hardware, which will most likely result in a kernel
panic.

Fix this by verifying that wl->state is on before queueing a new
recovery.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7b825e8..3f5d87e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -775,8 +775,9 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
 	WARN_ON(!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
 
 	/* Avoid a recursive recovery */
-	if (!test_and_set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
+	if (wl->state == WLCORE_STATE_ON) {
 		wl->state = WLCORE_STATE_RESTARTING;
+		set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 		wlcore_disable_interrupts_nosync(wl);
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	}
-- 
1.7.10.4

