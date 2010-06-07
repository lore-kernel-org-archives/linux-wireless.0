Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33503 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0FGNGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 09:06:20 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com
Subject: [RFC PATCH] mac80211: Fix circular locking dependency in ARP filter handling
Date: Mon,  7 Jun 2010 16:06:05 +0300
Message-Id: <1275915965-10124-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a circular locking dependency when configuring the
hardware ARP filters on association, occurring when flushing the mac80211
workqueue. This is what happens:

[   92.026800] =======================================================
[   92.030507] [ INFO: possible circular locking dependency detected ]
[   92.030507] 2.6.34-04781-g2b2c009 #85
[   92.030507] -------------------------------------------------------
[   92.030507] modprobe/5225 is trying to acquire lock:
[   92.030507]  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff8105b5c0>] flush_workq
ueue+0x0/0xb0
[   92.030507]
[   92.030507] but task is already holding lock:
[   92.030507]  (rtnl_mutex){+.+.+.}, at: [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
[   92.030507]
[   92.030507] which lock already depends on the new lock.
[   92.030507]
[   92.030507]
[   92.030507] the existing dependency chain (in reverse order) is:
[   92.030507]
[   92.030507] -> #2 (rtnl_mutex){+.+.+.}:
[   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
[   92.030507]        [<ffffffff81341754>] mutex_lock_nested+0x44/0x300
[   92.030507]        [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
[   92.030507]        [<ffffffffa022d47c>] ieee80211_assoc_done+0x6c/0xe0 [mac80211]
[   92.030507]        [<ffffffffa022f2ad>] ieee80211_work_work+0x31d/0x1280 [mac80211]

[   92.030507] -> #1 ((&local->work_work)){+.+.+.}:
[   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
[   92.030507]        [<ffffffff8105a51a>] worker_thread+0x22a/0x370
[   92.030507]        [<ffffffff8105ecc6>] kthread+0x96/0xb0
[   92.030507]        [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[   92.030507]
[   92.030507] -> #0 ((wiphy_name(local->hw.wiphy))){+.+.+.}:
[   92.030507]        [<ffffffff81075fdc>] __lock_acquire+0x1c0c/0x1d50
[   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
[   92.030507]        [<ffffffff8105b60e>] flush_workqueue+0x4e/0xb0
[   92.030507]        [<ffffffffa023ff7b>] ieee80211_stop_device+0x2b/0xb0 [mac80211]
[   92.030507]        [<ffffffffa0231635>] ieee80211_stop+0x3e5/0x680 [mac80211]

Fix the problem by moving the hardware ARP filter configuration to a
workqueue function.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    3 +++
 net/mac80211/main.c        |    3 ++-
 net/mac80211/mlme.c        |   41 +++++++++++++++++++++++++++++------------
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4d3883e..893a5cc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -329,6 +329,9 @@ struct ieee80211_if_managed {
 	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
+#ifdef CONFIG_INET
+	struct work_struct arp_config_work;
+#endif
 
 	unsigned long probe_timeout;
 	int probe_send_count;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1afa9ec..44bf800 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -477,6 +477,9 @@ static int ieee80211_stop(struct net_device *dev)
 		cancel_work_sync(&sdata->u.mgd.chswitch_work);
 		cancel_work_sync(&sdata->u.mgd.monitor_work);
 		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
+#ifdef CONFIG_INET
+		cancel_work_sync(&sdata->u.mgd.arp_config_work);
+#endif
 
 		/*
 		 * When we get here, the interface is marked down.
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 88b671a..5583980 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -379,7 +379,8 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	ifmgd = &sdata->u.mgd;
 	mutex_lock(&ifmgd->mtx);
 	if (ifmgd->associated)
-		ieee80211_set_arp_filter(sdata);
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.mgd.arp_config_work);
 	mutex_unlock(&ifmgd->mtx);
 
 	return NOTIFY_DONE;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ac68c41..c3bf0a2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -853,6 +853,11 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
+#ifdef CONFIG_INET
+	/* Configure hardware ARP filter with current IPv4 config */
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.arp_config_work);
+#endif
+
 	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_ps(local, -1);
 	ieee80211_recalc_smps(local, sdata);
@@ -1767,6 +1772,26 @@ static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	kfree_skb(skb);
 }
 
+#ifdef CONFIG_INET
+void ieee80211_arp_config_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.arp_config_work);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	rtnl_lock();
+	mutex_lock(&ifmgd->mtx);
+	if (ifmgd->associated)
+		ieee80211_set_arp_filter(sdata);
+	mutex_unlock(&ifmgd->mtx);
+	rtnl_unlock();
+}
+#endif
+
 static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -1959,6 +1984,9 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
 		  ieee80211_beacon_connection_loss_work);
+#ifdef CONFIG_INET
+	INIT_WORK(&ifmgd->arp_config_work, ieee80211_arp_config_work);
+#endif
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
@@ -2116,19 +2144,8 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 			cfg80211_send_assoc_timeout(wk->sdata->dev,
 						    wk->filter_ta);
 			return WORK_DONE_DESTROY;
-#ifdef CONFIG_INET
-		} else {
-			mutex_unlock(&wk->sdata->u.mgd.mtx);
-
-			/*
-			 * configure ARP filter IP addresses to the driver,
-			 * intentionally outside the mgd mutex.
-			 */
-			rtnl_lock();
-			ieee80211_set_arp_filter(wk->sdata);
-			rtnl_unlock();
-#endif
 		}
+		mutex_unlock(&wk->sdata->u.mgd.mtx);
 	}
 
 	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
-- 
1.6.3.3

