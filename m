Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47847 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755383Ab2AXJGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:48 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id c1so2152295lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:47 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 4/8] wl12xx: cancel delayed elp work and clear flags when stopping PLT
Date: Tue, 24 Jan 2012 11:06:25 +0200
Message-Id: <1327395989-29663-5-git-send-email-coelho@ti.com> (sfid-20120124_100657_403088_58F5D109)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases a race condition can happen if we don't cancel any
pending ELP work before stopping PLT.  With this commit we cancel ELP
work and clear the wl->flags bitmask.  Also clean up the wl elements
after powering off.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 27ca324..6ec22b3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1420,17 +1420,18 @@ int wl1271_plt_stop(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl->state = WL1271_STATE_OFF;
-	wl->rx_counter = 0;
-
 	mutex_unlock(&wl->mutex);
 
 	wl1271_flush_deferred_work(wl);
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->recovery_work);
+	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
 	wl1271_power_off(wl);
+	wl->flags = 0;
+	wl->state = WL1271_STATE_OFF;
+	wl->rx_counter = 0;
 	mutex_unlock(&wl->mutex);
 
 out:
-- 
1.7.4.1

