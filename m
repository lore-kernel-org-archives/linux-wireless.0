Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbbJYJAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:08 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/10] mac80211: allow driver to prevent two stations w/ same address
Date: Sun, 25 Oct 2015 10:59:39 +0200
Message-Id: <1445763582-11421-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100031_529858_E8E5A43C)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some devices or drivers cannot deal with having the same station
address for different virtual interfaces, say as a client to two
virtual AP interfaces. Rather than requiring each driver with a
limitation like that to enforce it, add a hardware flag for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h  |  6 ++++++
 net/mac80211/debugfs.c  |  1 +
 net/mac80211/sta_info.c | 18 ++++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4b9dd07..e2dafad 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1899,6 +1899,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_BEACON_TX_STATUS: The device/driver provides TX status
  *	for sent beacons.
  *
+ * @IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR: Hardware (or driver) requires that each
+ *	station has a unique address, i.e. each station entry can be identified
+ *	by just its MAC address; this prevents, for example, the same station
+ *	from connecting to two virtual AP interfaces at the same time.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1934,6 +1939,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TDLS_WIDER_BW,
 	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 	IEEE80211_HW_BEACON_TX_STATUS,
+	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 4d2aaeb..abbdff0 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -125,6 +125,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(TDLS_WIDER_BW),
 	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 	FLAG(BEACON_TX_STATUS),
+	FLAG(NEEDS_UNIQUE_STA_ADDR),
 
 	/* keep last for the build bug below */
 	(void *)0x1
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f91d187..8f630f5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -435,6 +435,19 @@ static int sta_info_insert_check(struct sta_info *sta)
 		    is_multicast_ether_addr(sta->sta.addr)))
 		return -EINVAL;
 
+	/* Strictly speaking this isn't necessary as we hold the mutex, but
+	 * the rhashtable code can't really deal with that distinction. We
+	 * do require the mutex for correctness though.
+	 */
+	rcu_read_lock();
+	lockdep_assert_held(&sdata->local->sta_mtx);
+	if (ieee80211_hw_check(&sdata->local->hw, NEEDS_UNIQUE_STA_ADDR) &&
+	    ieee80211_find_sta_by_ifaddr(&sdata->local->hw, sta->addr, NULL)) {
+		rcu_read_unlock();
+		return -ENOTUNIQ;
+	}
+	rcu_read_unlock();
+
 	return 0;
 }
 
@@ -554,14 +567,15 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 
 	might_sleep();
 
+	mutex_lock(&local->sta_mtx);
+
 	err = sta_info_insert_check(sta);
 	if (err) {
+		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
 		goto out_free;
 	}
 
-	mutex_lock(&local->sta_mtx);
-
 	err = sta_info_insert_finish(sta);
 	if (err)
 		goto out_free;
-- 
2.1.4

