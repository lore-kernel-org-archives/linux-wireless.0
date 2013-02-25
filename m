Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab3BYLuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 06:50:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/6] mac80211: sync suspend and stop interface
Date: Mon, 25 Feb 2013 12:50:04 +0100
Message-Id: <1361793008-2857-2-git-send-email-sgruszka@redhat.com> (sfid-20130225_125024_855907_D7999242)
In-Reply-To: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that we close interface while we are suspended, that
results in warning like below (and some others similar):

WARNING: at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0x62e/0x670 [mac80211]()
wlan0:  Failed check-sdata-in-driver check, flags: 0x4
Call Trace:
 [<ffffffff8105c9d6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa045d46e>] ieee80211_do_stop+0x62e/0x670 [mac80211]
 [<ffffffffa045d4ca>] ieee80211_stop+0x1a/0x20 [mac80211]
 [<ffffffff815122ed>] __dev_close_many+0x7d/0xc0
 [<ffffffff81513af8>] dev_close_many+0x88/0x100
 [<ffffffff81513f2a>] dev_close+0x3a/0x50
 [<ffffffffa03c90ae>] cfg80211_rfkill_set_block+0x6e/0xa0 [cfg80211]
 [<ffffffffa03c9106>] cfg80211_rfkill_sync_work+0x26/0x30 [cfg80211]

Check for local->suspended in ieee80211_do_stop() before perform
any action that require operation on interface that was removed
from the driver.

All keys should be freed, so remove ieee80211_free_keys() and
add corresponding WARN_ON().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/iface.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2c059e5..370b86b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -419,7 +419,8 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 
 	ieee80211_vif_release_channel(sdata);
 
-	drv_remove_interface(local, sdata);
+	if (!local->suspended)
+		drv_remove_interface(local, sdata);
 
 	kfree(sdata);
  out_unlock:
@@ -834,16 +835,18 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		skb_queue_purge(&sdata->skb_queue);
 
-		/*
-		 * Free all remaining keys, there shouldn't be any,
-		 * except maybe group keys in AP more or WDS?
-		 */
-		ieee80211_free_keys(sdata);
-
 		drv_remove_interface_debugfs(local, sdata);
 
-		if (going_down)
-			drv_remove_interface(local, sdata);
+		if (!local->suspended) {
+			/*
+			 * There shouldn't be any kays, sice we disconnected
+			 * before suspend.
+			 */
+			WARN_ON(!list_empty(&sdata->key_list));
+
+			if (going_down)
+				drv_remove_interface(local, sdata);
+		}
 	}
 
 	sdata->bss = NULL;
-- 
1.7.11.7

