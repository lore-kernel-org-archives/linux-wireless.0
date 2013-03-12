Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59611 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab3CLNpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:41 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/13] wlcore: change warn on missing lock in wlcore_queue_xx funcs
Date: Tue, 12 Mar 2013 15:44:18 +0200
Message-ID: <1363095864-24422-8-git-send-email-coelho@ti.com> (sfid-20130312_144552_657816_9F740142)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

On !CONFIG_SMP builds spin_is_locked always returns 0. Assert the
locking using assert_spin_locked, which is written to behave correctly
in all cases.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 8599556..e0d9504 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
+#include <linux/spinlock.h>
 
 #include "wlcore.h"
 #include "debug.h"
@@ -1289,7 +1290,7 @@ bool wlcore_is_queue_stopped_by_reason_locked(struct wl1271 *wl,
 {
 	int hwq = wlcore_tx_get_mac80211_queue(wlvif, queue);
 
-	WARN_ON_ONCE(!spin_is_locked(&wl->wl_lock));
+	assert_spin_locked(&wl->wl_lock);
 	return test_bit(reason, &wl->queue_stop_reasons[hwq]);
 }
 
@@ -1298,6 +1299,6 @@ bool wlcore_is_queue_stopped_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 {
 	int hwq = wlcore_tx_get_mac80211_queue(wlvif, queue);
 
-	WARN_ON_ONCE(!spin_is_locked(&wl->wl_lock));
+	assert_spin_locked(&wl->wl_lock);
 	return !!wl->queue_stop_reasons[hwq];
 }
-- 
1.7.10.4

