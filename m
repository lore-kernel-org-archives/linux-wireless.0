Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbbJVPfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 11:35:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: allow driver to prevent two stations w/ same address
Date: Thu, 22 Oct 2015 17:35:19 +0200
Message-Id: <1445528119-5472-1-git-send-email-johannes@sipsolutions.net> (sfid-20151022_173526_809892_63D20932)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some devices or drivers cannot deal with having the same station
address for different virtual interfaces, say as a client to two
virtual AP interfaces. Rather than requiring each driver with a
limitation like that to enforce it, add a hardware flag for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |  6 ++++++
 net/mac80211/debugfs.c  |  1 +
 net/mac80211/sta_info.c | 18 ++++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dac575c55c62..b6f9c39ae0c7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1901,6 +1901,11 @@ struct ieee80211_txq {
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
@@ -1936,6 +1941,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TDLS_WIDER_BW,
 	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 	IEEE80211_HW_BEACON_TX_STATUS,
+	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3636b45440ab..78fe7f611d6a 100644
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
index f91d1873218c..8f630f51d9bd 100644
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
2.5.1

