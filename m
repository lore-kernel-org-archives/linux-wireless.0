Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:42873 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1GZVbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 17:31:24 -0400
Received: by eye22 with SMTP id 22so1213655eye.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 14:31:22 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: refactor sta_info_insert_rcu to 3 main stages
Date: Wed, 27 Jul 2011 00:29:31 +0300
Message-Id: <1311715772-8855-1-git-send-email-guy@wizery.com> (sfid-20110726_233128_084810_E74F1BB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Divided the sta_info_insert_rcu function to 3 mini-functions:
sta_info_insert_check - the initial checks done when inserting
a new station
sta_info_insert_adhoc - the function that handles the station
addition in ad-hoc mode
sta_info_insert_mgd - the function that handles the station
addition in the other modes

The outer API was not changed.
The refactoring was done for better usage of the different
stages in the station addition in new scenarios added
in the next commit

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 net/mac80211/sta_info.c |  144 +++++++++++++++++++++++++++++-----------------
 1 files changed, 91 insertions(+), 53 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b83870b..b4549f2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -371,93 +371,91 @@ static void sta_info_finish_work(struct work_struct *work)
 	mutex_unlock(&local->sta_mtx);
 }
 
-int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
+static int sta_info_insert_check(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	unsigned long flags;
-	int err = 0;
 
 	/*
 	 * Can't be a WARN_ON because it can be triggered through a race:
 	 * something inserts a STA (on one CPU) without holding the RTNL
 	 * and another CPU turns off the net device.
 	 */
-	if (unlikely(!ieee80211_sdata_running(sdata))) {
-		err = -ENETDOWN;
-		rcu_read_lock();
-		goto out_free;
-	}
+	if (unlikely(!ieee80211_sdata_running(sdata)))
+		return -ENETDOWN;
 
 	if (WARN_ON(compare_ether_addr(sta->sta.addr, sdata->vif.addr) == 0 ||
-		    is_multicast_ether_addr(sta->sta.addr))) {
-		err = -EINVAL;
+		    is_multicast_ether_addr(sta->sta.addr)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int sta_info_insert_adhoc(struct sta_info *sta) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	/* check if STA exists already */
+	if (sta_info_get_bss(sdata, sta->sta.addr)) {
+		spin_unlock_irqrestore(&local->sta_lock, flags);
 		rcu_read_lock();
-		goto out_free;
+		__sta_info_free(local, sta);
+		return -EEXIST;
 	}
 
-	/*
-	 * In ad-hoc mode, we sometimes need to insert stations
-	 * from tasklet context from the RX path. To avoid races,
-	 * always do so in that case -- see the comment below.
-	 */
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		spin_lock_irqsave(&local->sta_lock, flags);
-		/* check if STA exists already */
-		if (sta_info_get_bss(sdata, sta->sta.addr)) {
-			spin_unlock_irqrestore(&local->sta_lock, flags);
-			rcu_read_lock();
-			err = -EEXIST;
-			goto out_free;
-		}
-
-		local->num_sta++;
-		local->sta_generation++;
-		smp_mb();
-		sta_info_hash_add(local, sta);
+	local->num_sta++;
+	local->sta_generation++;
+	smp_mb();
+	sta_info_hash_add(local, sta);
 
-		list_add_tail(&sta->list, &local->sta_pending_list);
+	list_add_tail(&sta->list, &local->sta_pending_list);
 
-		rcu_read_lock();
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+	rcu_read_lock();
+	spin_unlock_irqrestore(&local->sta_lock, flags);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		wiphy_debug(local->hw.wiphy, "Added IBSS STA %pM\n",
-			    sta->sta.addr);
+	wiphy_debug(local->hw.wiphy, "Added IBSS STA %pM\n",
+			sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-		ieee80211_queue_work(&local->hw, &local->sta_finish_work);
+	ieee80211_queue_work(&local->hw, &local->sta_finish_work);
 
-		return 0;
-	}
+	return 0;
+}
+
+/*
+ * should be called with sta_mtx locked
+ * this function replaces the mutex lock
+ * with a RCU lock
+ */
+static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	unsigned long flags;
+	int err = 0;
+
+	lockdep_assert_held(&local->sta_mtx);
 
 	/*
 	 * On first glance, this will look racy, because the code
-	 * below this point, which inserts a station with sleeping,
+	 * in this function, which inserts a station with sleeping,
 	 * unlocks the sta_lock between checking existence in the
 	 * hash table and inserting into it.
 	 *
 	 * However, it is not racy against itself because it keeps
-	 * the mutex locked. It still seems to race against the
-	 * above code that atomically inserts the station... That,
-	 * however, is not true because the above code can only
-	 * be invoked for IBSS interfaces, and the below code will
-	 * not be -- and the two do not race against each other as
-	 * the hash table also keys off the interface.
+	 * the mutex locked.
 	 */
 
-	might_sleep();
-
-	mutex_lock(&local->sta_mtx);
-
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
 	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
-		err = -EEXIST;
-		goto out_free;
+		return -EEXIST;
 	}
 
 	spin_unlock_irqrestore(&local->sta_lock, flags);
@@ -466,7 +464,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 	if (err) {
 		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
-		goto out_free;
+		return err;
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -481,6 +479,46 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 		mesh_accept_plinks_update(sdata);
 
 	return 0;
+}
+
+int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	int err = 0;
+
+	err = sta_info_insert_check(sta);
+	if (err) {
+		rcu_read_lock();
+		goto out_free;
+	}
+
+	/*
+	 * In ad-hoc mode, we sometimes need to insert stations
+	 * from tasklet context from the RX path. To avoid races,
+	 * always do so in that case -- see the comment below.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return sta_info_insert_adhoc(sta);
+
+	/*
+	 * It might seem that the function called below is in race against
+	 * the function call above that atomically inserts the station... That,
+	 * however, is not true because the above code can only
+	 * be invoked for IBSS interfaces, and the below code will
+	 * not be -- and the two do not race against each other as
+	 * the hash table also keys off the interface.
+	 */
+
+	might_sleep();
+
+	mutex_lock(&local->sta_mtx);
+
+	err = sta_info_insert_mgd(sta);
+	if (err)
+		goto out_free;
+
+	return 0;
  out_free:
 	BUG_ON(!err);
 	__sta_info_free(local, sta);
-- 
1.7.4.1

