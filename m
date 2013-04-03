Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58852 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227Ab3DCQsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:48:47 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] mac80211:  Add vif hash for multi-station RX performance.
Date: Wed,  3 Apr 2013 09:48:17 -0700
Message-Id: <1365007698-25295-1-git-send-email-greearb@candelatech.com> (sfid-20130403_184908_772897_29241D1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When one has multiple station VIFS all connected to the same
AP, the rx logic becomes a linear walk of all stations.  To
improve performance in this case, hash the station VIFs on
the VIF MAC.  This significantly improves performance:  70Mbps
without the patch, 190Mbps with patch, when using 50 stations
receiving TCP traffic.

Probably not many people doing this, so not worth pushing upstream
at this time.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Think I fixed the station matching issues Johannes mentioned.

:100644 100644 b985722... 84f1b73... M	net/mac80211/ieee80211_i.h
:100644 100644 c6844ad... a23a103... M	net/mac80211/rx.c
:100644 100644 c465b1d... 34351dd... M	net/mac80211/sta_info.c
:100644 100644 4947341... 227fce7... M	net/mac80211/sta_info.h
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/rx.c          |   15 +++++++++++++
 net/mac80211/sta_info.c    |   51 +++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/sta_info.h    |    7 +++++-
 4 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b985722..84f1b73 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -985,7 +985,8 @@ struct ieee80211_local {
 	spinlock_t tim_lock;
 	unsigned long num_sta;
 	struct list_head sta_list;
-	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
+	struct sta_info __rcu *sta_hash[STA_HASH_SIZE]; /* By station addr */
+	struct sta_info __rcu *sta_vhash[STA_HASH_SIZE]; /* By VIF mac addr */
 	struct timer_list sta_cleanup;
 	int sta_generation;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c6844ad..a23a103 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3152,6 +3152,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
 
+		/* Check for Station VIFS by hashing on the destination MAC
+		 * (ie, local sdata MAC).  This changes 'promisc' behaviour,
+		 * but not sure that is a bad thing.
+		 */
+		if ((!is_multicast_ether_addr(hdr->addr1)) &&
+		    (local->monitors == 0) && (local->cooked_mntrs == 0)) {
+			sta = sta_info_get_by_vif(local, hdr->addr1, hdr->addr2);
+			if (sta) {
+				rx.sta = sta;
+				rx.sdata = sta->sdata;
+				goto rx_and_done;
+			}
+		}
+
 		for_each_sta_info(local, hdr->addr2, sta, tmp) {
 			if (!prev_sta) {
 				prev_sta = sta;
@@ -3169,6 +3183,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			rx.sta = prev_sta;
 			rx.sdata = prev_sta->sdata;
 
+		rx_and_done:
 			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
 				return;
 			goto out;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c465b1d..34351dd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -77,19 +77,42 @@ static int sta_info_hash_del(struct ieee80211_local *local,
 	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
 				      lockdep_is_held(&local->sta_mtx));
 	if (!s)
-		return -ENOENT;
+		goto try_lhash;
+	
 	if (s == sta) {
 		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)],
 				   s->hnext);
-		return 0;
+		goto try_lhash;
 	}
 
 	while (rcu_access_pointer(s->hnext) &&
 	       rcu_access_pointer(s->hnext) != sta)
 		s = rcu_dereference_protected(s->hnext,
-					lockdep_is_held(&local->sta_mtx));
+					      lockdep_is_held(&local->sta_mtx));
 	if (rcu_access_pointer(s->hnext)) {
 		rcu_assign_pointer(s->hnext, sta->hnext);
+		goto try_lhash;
+	}
+
+	/* Remove from the local VIF addr hash */
+try_lhash:
+	s = rcu_dereference_protected(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)],
+				      lockdep_is_held(&local->sta_mtx));
+	if (!s)
+		return -ENONET;
+	
+	if (s == sta) {
+		rcu_assign_pointer(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)],
+				   s->vnext);
+		return 0;
+	}
+
+	while (rcu_access_pointer(s->vnext) &&
+	       rcu_access_pointer(s->vnext) != sta)
+		s = rcu_dereference_protected(s->vnext,
+					      lockdep_is_held(&local->sta_mtx));
+	if (rcu_access_pointer(s->vnext)) {
+		rcu_assign_pointer(s->vnext, sta->vnext);
 		return 0;
 	}
 
@@ -251,6 +274,23 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
+struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
+				     const u8 *vif_addr, const u8 * sta_addr) {
+	struct sta_info *sta;
+
+	sta = rcu_dereference_check(local->sta_vhash[STA_HASH(vif_addr)],
+				    lockdep_is_held(&local->sta_mtx));
+	while (sta) {
+		if (ether_addr_equal(sta->sdata->vif.addr, vif_addr) &&
+		    ether_addr_equal(sta->sta.addr, sta_addr))
+			break;
+		sta = rcu_dereference_check(sta->vnext,
+					    lockdep_is_held(&local->sta_mtx));
+	}
+	return sta;
+}
+
+
 struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 				     int idx)
 {
@@ -300,6 +340,11 @@ static void sta_info_hash_add(struct ieee80211_local *local,
 	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
 	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
 
+	if (sta->sdata->vif.type == NL80211_IFTYPE_STATION) {
+		sta->vnext = local->sta_vhash[STA_HASH(sta->sdata->vif.addr)];
+		rcu_assign_pointer(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)], sta);
+	}
+
 	rcu_assign_pointer(sta->sdata->some_sta, sta);
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4947341..227fce7 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -227,7 +227,8 @@ struct sta_ampdu_mlme {
  * mac80211 is communicating with.
  *
  * @list: global linked list entry
- * @hnext: hash table linked list pointer
+ * @hnext: hash table linked list pointer, by (remote) station MAC
+ * @vnext: hash table linked list pointer, by VIF MAC
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer key negotiated with this station, if any
@@ -304,6 +305,7 @@ struct sta_info {
 	struct list_head list;
 	struct rcu_head rcu_head;
 	struct sta_info __rcu *hnext;
+	struct sta_info __rcu *vnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -507,6 +509,9 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
+struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
+				     const u8 *vif_addr, const u8 *sta_addr);
+
 static inline
 void for_each_sta_info_type_check(struct ieee80211_local *local,
 				  const u8 *addr,
-- 
1.7.3.4

