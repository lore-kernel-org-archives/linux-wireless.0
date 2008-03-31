Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYDALs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:57 -0400
Message-Id: <20080331172434.975113000@sipsolutions.net> (sfid-20080401_124932_647219_CD02437C)
References: <20080331172258.541914000@sipsolutions.net>
Date: Mon, 31 Mar 2008 19:23:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6] mac80211: automatically free sta struct when insertion
	fails
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When STA structure insertion fails, it has been allocated but isn't
really alive yet, it isn't reachable by any other code and also can't
yet have much configured. This patch changes the code so that when
the insertion fails, the resulting STA pointer is no longer valid
because it is freed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I'm open to not doing that and instead showing sta_info_free() in the
API but I fear that would be more prone to mis-use than this clearly
documented restriction.

 net/mac80211/cfg.c           |    2 -
 net/mac80211/ieee80211.c     |    2 -
 net/mac80211/ieee80211_sta.c |    5 --
 net/mac80211/mesh_plink.c    |    6 ++-
 net/mac80211/sta_info.c      |   79 +++++++++++++++++++++++++++++++------------
 5 files changed, 64 insertions(+), 30 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-03-31 18:21:57.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-03-31 18:22:24.000000000 +0200
@@ -672,7 +672,7 @@ static int ieee80211_add_station(struct 
 
 	err = sta_info_insert(sta);
 	if (err) {
-		sta_info_destroy(sta);
+		/* STA has been freed */
 		rcu_read_unlock();
 		return err;
 	}
--- everything.orig/net/mac80211/ieee80211.c	2008-03-31 18:21:57.000000000 +0200
+++ everything/net/mac80211/ieee80211.c	2008-03-31 18:22:24.000000000 +0200
@@ -268,7 +268,7 @@ static int ieee80211_open(struct net_dev
 
 		res = sta_info_insert(sta);
 		if (res) {
-			sta_info_destroy(sta);
+			/* STA has been freed */
 			return res;
 		}
 		break;
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:23.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:24.000000000 +0200
@@ -1920,7 +1920,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 		if (err) {
 			printk(KERN_DEBUG "%s: failed to insert STA entry for"
 			       " the AP (error %d)\n", dev->name, err);
-			sta_info_destroy(sta);
 			rcu_read_unlock();
 			return;
 		}
@@ -4150,10 +4149,8 @@ struct sta_info * ieee80211_ibss_add_sta
 
 	rate_control_rate_init(sta, local);
 
-	if (sta_info_insert(sta)) {
-		sta_info_destroy(sta);
+	if (sta_info_insert(sta))
 		return NULL;
-	}
 
 	return sta;
 }
--- everything.orig/net/mac80211/mesh_plink.c	2008-03-31 18:21:57.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-03-31 18:22:24.000000000 +0200
@@ -89,6 +89,10 @@ static inline void mesh_plink_fsm_restar
 	sta->plink_retries = 0;
 }
 
+/*
+ * NOTE: This is just an alias for sta_info_alloc(), see notes
+ *       on it in the lifecycle management section!
+ */
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 					 u8 *hw_addr, u64 rates)
 {
@@ -235,7 +239,6 @@ void mesh_neighbour_update(u8 *hw_addr, 
 			return;
 		}
 		if (sta_info_insert(sta)) {
-			sta_info_destroy(sta);
 			rcu_read_unlock();
 			return;
 		}
@@ -506,7 +509,6 @@ void mesh_rx_plink_frame(struct net_devi
 			return;
 		}
 		if (sta_info_insert(sta)) {
-			sta_info_destroy(sta);
 			rcu_read_unlock();
 			return;
 		}
--- everything.orig/net/mac80211/sta_info.c	2008-03-31 18:22:24.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-03-31 18:22:24.000000000 +0200
@@ -36,16 +36,23 @@
  * (which is pretty useless) or insert it into the hash table using
  * sta_info_insert() which demotes the reference from ownership to a regular
  * RCU-protected reference; if the function is called without protection by an
- * RCU critical section the reference is instantly invalidated.
+ * RCU critical section the reference is instantly invalidated. Note that the
+ * caller may not do much with the STA info before inserting it, in particular,
+ * it may not start any mesh peer link management or add encryption keys.
+ *
+ * When the insertion fails (sta_info_insert()) returns non-zero), the
+ * structure will have been freed by sta_info_insert()!
  *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
  * that means it can be removed from the hash table but not be freed.
- * See the comment in __sta_info_unlink() for more information.
+ * See the comment in __sta_info_unlink() for more information, this is
+ * an internal capability only.
  *
  * In order to remove a STA info structure, the caller needs to first
  * unlink it (sta_info_unlink()) from the list and hash tables and
- * then wait for an RCU synchronisation before it can be freed. Due to
+ * then destroy it while holding the RTNL; sta_info_destroy() will wait
+ * for an RCU grace period to elapse before actually freeing it. Due to
  * the pinning and the possibility of multiple callers trying to remove
  * the same STA info at the same time, sta_info_unlink() can clear the
  * STA info pointer it is passed to indicate that the STA info is owned
@@ -127,12 +134,35 @@ struct sta_info *sta_info_get_by_idx(str
 	return NULL;
 }
 
+/**
+ * __sta_info_free - internal STA free helper
+ *
+ * @sta: STA info to free
+ *
+ * This function must undo everything done by sta_info_alloc()
+ * that may happen before sta_info_insert().
+ */
+static void __sta_info_free(struct ieee80211_local *local,
+			    struct sta_info *sta)
+{
+	DECLARE_MAC_BUF(mbuf);
+
+	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
+	rate_control_put(sta->rate_ctrl);
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Destroyed STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
+	kfree(sta);
+}
+
 void sta_info_destroy(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct sk_buff *skb;
 	int i;
-	DECLARE_MAC_BUF(mbuf);
 
 	ASSERT_RTNL();
 	might_sleep();
@@ -175,15 +205,8 @@ void sta_info_destroy(struct sta_info *s
 		del_timer_sync(&sta->ampdu_mlme.tid_rx[i].session_timer);
 		del_timer_sync(&sta->ampdu_mlme.tid_tx[i].addba_resp_timer);
 	}
-	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
-	rate_control_put(sta->rate_ctrl);
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Destroyed STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-	kfree(sta);
+	__sta_info_free(local, sta);
 }
 
 
@@ -264,6 +287,7 @@ int sta_info_insert(struct sta_info *sta
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	unsigned long flags;
+	int err = 0;
 	DECLARE_MAC_BUF(mac);
 
 	/*
@@ -271,20 +295,23 @@ int sta_info_insert(struct sta_info *sta
 	 * something inserts a STA (on one CPU) without holding the RTNL
 	 * and another CPU turns off the net device.
 	 */
-	if (unlikely(!netif_running(sdata->dev)))
-		return -ENETDOWN;
-
-	if (WARN_ON(compare_ether_addr(sta->addr, sdata->dev->dev_addr) == 0))
-		return -EINVAL;
+	if (unlikely(!netif_running(sdata->dev))) {
+		err = -ENETDOWN;
+		goto out_free;
+	}
 
-	if (WARN_ON(is_multicast_ether_addr(sta->addr)))
-		return -EINVAL;
+	if (WARN_ON(compare_ether_addr(sta->addr, sdata->dev->dev_addr) == 0 ||
+	            is_multicast_ether_addr(sta->addr))) {
+		err = -EINVAL;
+		goto out_free;
+	}
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
 	if (__sta_info_find(local, sta->addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
-		return -EEXIST;
+		err = -EEXIST;
+		goto out_free;
 	}
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
@@ -307,9 +334,13 @@ int sta_info_insert(struct sta_info *sta
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	/* debugfs entry adding might sleep, so schedule process
+	/*
+	 * Debugfs entry adding might sleep, so schedule process
 	 * context task for adding entry for STAs that do not yet
-	 * have one. */
+	 * have one.
+	 * NOTE: due to auto-freeing semantics this may only be done
+	 *       if the insertion is successful!
+	 */
 	queue_work(local->hw.workqueue, &local->sta_debugfs_add);
 #endif
 
@@ -317,6 +348,10 @@ int sta_info_insert(struct sta_info *sta
 		mesh_accept_plinks_update(sdata);
 
 	return 0;
+ out_free:
+	BUG_ON(!err);
+ 	__sta_info_free(local, sta);
+	return err;
 }
 
 static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)

-- 

