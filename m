Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44266 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283Ab2AXJGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:44 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id g1so1035036lah.29
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:43 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/8] wl12xx: Power off after flushing work
Date: Tue, 24 Jan 2012 11:06:23 +0200
Message-Id: <1327395989-29663-3-git-send-email-coelho@ti.com> (sfid-20120124_100650_166378_527319CF)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

When stopping plt, the chip is powered off before all current work items
are flushed and interrupts are disabled. This might introduce a race in
which the driver tries to communicate with a powered off chip.

Fix this by powering off the device only after interrupts are disabled
and all work items are flushed.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fc4d4d5..bf356a8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1406,8 +1406,6 @@ int wl1271_plt_stop(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl1271_power_off(wl);
-
 	wl->state = WL1271_STATE_OFF;
 	wl->rx_counter = 0;
 
@@ -1417,6 +1415,11 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	wl1271_flush_deferred_work(wl);
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->recovery_work);
+
+	mutex_lock(&wl->mutex);
+	wl1271_power_off(wl);
+	mutex_unlock(&wl->mutex);
+
 out:
 	return ret;
 }
-- 
1.7.4.1

