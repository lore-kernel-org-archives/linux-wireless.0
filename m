Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340Ab3BSQs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 11:48:29 -0500
Date: Tue, 19 Feb 2013 17:48:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] mac80211: sync suspend and stop interface
Message-ID: <20130219164831.GB27140@redhat.com> (sfid-20130219_174832_792739_C14867A8)
References: <20130219164714.GA27140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130219164714.GA27140@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that we close interface while we are suspended, that
results in warning like below (and some other similar):

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

To fix check if interface was removed during suspend in
ieee80211_do_stop() before perform any action that require operation
on the interface.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/iface.c | 21 ++++++++++++---------
 net/mac80211/pm.c    |  2 ++
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2c059e5..7703141 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -419,7 +419,8 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 
 	ieee80211_vif_release_channel(sdata);
 
-	drv_remove_interface(local, sdata);
+	if (!local->suspended || local->wowlan)
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
+		if (!local->suspended || local->wowlan) {
+			/*
+			 * Free all remaining keys, there shouldn't be any,
+			 * except maybe group keys in AP more or WDS?
+			 */
+			ieee80211_free_keys(sdata);
+
+			if (going_down)
+				drv_remove_interface(local, sdata);
+		}
 	}
 
 	sdata->bss = NULL;
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d0275f3..51b4ec7 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -182,6 +182,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 			mutex_unlock(&local->chanctx_mtx);
 		}
+
+		ieee80211_free_keys(sdata);
 		drv_remove_interface(local, sdata);
 	}
 
-- 
1.7.11.7

