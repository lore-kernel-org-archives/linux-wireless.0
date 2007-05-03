Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46622 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754776AbXECXmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2007 19:42:03 -0400
Date: Fri, 4 May 2007 01:41:59 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: Jan Kiszka <jan.kiszka@web.de>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: don't break without 802.11 qdisc
Message-ID: <20070504014159.3ed9d594@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan, could you test if this patch fixes your problems with removing of
802.11 qdisc? (It applies on top of the patch
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=commitdiff_plain;h=00a908826e778b39a802013729f7826c2d575360 )

Thanks,

 Jiri

---

This patch prevents things from going crazy when the 802.11 qdisc is not
installed (because it is removed using tc or because CONFIG_NET_SCHED is not
set).

Co-author: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/ieee80211.c |   30 +++++++++++++++++++++---------
 net/mac80211/wme.h       |    2 +-
 2 files changed, 22 insertions(+), 10 deletions(-)

--- mac80211.orig/net/mac80211/ieee80211.c
+++ mac80211/net/mac80211/ieee80211.c
@@ -1215,6 +1215,11 @@ static int __ieee80211_tx(struct ieee802
 	struct ieee80211_tx_control *control = tx->u.tx.control;
 	int ret, i;
 
+	if (!ieee80211_qdisc_installed(local->mdev) &&
+	    __ieee80211_queue_stopped(local, 0)) {
+		netif_stop_queue(local->mdev);
+		return IEEE80211_TX_AGAIN;
+	}
 	if (skb) {
 		ieee80211_dump_frame(local->mdev->name, "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb, control);
@@ -1404,8 +1409,13 @@ static void ieee80211_tx_pending(unsigne
 		}
 	}
 	netif_tx_unlock_bh(dev);
-	if (reschedule)
-		netif_schedule(dev);
+	if (reschedule) {
+		if (!ieee80211_qdisc_installed(dev)) {
+			if (!__ieee80211_queue_stopped(local, 0))
+				netif_wake_queue(dev);
+		} else
+			netif_schedule(dev);
+	}
 }
 
 static void ieee80211_clear_tx_pending(struct ieee80211_local *local)
@@ -2304,12 +2314,6 @@ static int ieee80211_master_open(struct 
 	struct ieee80211_sub_if_data *sdata;
 	int res = -EOPNOTSUPP;
 
-	if (!ieee80211_qdisc_installed(dev)) {
-		printk(KERN_ERR "%s: ieee80211 qdisc not installed\n",
-		       dev->name);
-		return res;
-	}
-
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev != dev && netif_running(sdata->dev)) {
@@ -5026,7 +5030,11 @@ void ieee80211_wake_queue(struct ieee802
 			     &local->state[queue]))
 			tasklet_schedule(&local->tx_pending_tasklet);
 		else
-			__netif_schedule(local->mdev);
+			if (!ieee80211_qdisc_installed(local->mdev)) {
+				if (queue == 0)
+					netif_wake_queue(local->mdev);
+			} else
+				__netif_schedule(local->mdev);
 	}
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
@@ -5035,6 +5043,8 @@ void ieee80211_stop_queue(struct ieee802
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	if (!ieee80211_qdisc_installed(local->mdev) && queue == 0)
+		netif_stop_queue(local->mdev);
 	set_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
@@ -5046,6 +5056,8 @@ void ieee80211_start_queues(struct ieee8
 
 	for (i = 0; i < local->hw.queues; i++)
 		clear_bit(IEEE80211_LINK_STATE_XOFF, &local->state[i]);
+	if (!ieee80211_qdisc_installed(local->mdev))
+		netif_start_queue(local->mdev);
 }
 EXPORT_SYMBOL(ieee80211_start_queues);
 
--- mac80211.orig/net/mac80211/wme.h
+++ mac80211/net/mac80211/wme.h
@@ -42,7 +42,7 @@ static inline void ieee80211_install_qdi
 }
 static inline int ieee80211_qdisc_installed(struct net_device *dev)
 {
-	return 1;
+	return 0;
 }
 
 static inline int ieee80211_wme_register(void)


-- 
Jiri Benc
SUSE Labs
