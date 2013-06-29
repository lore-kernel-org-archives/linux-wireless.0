Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47103 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3F2W7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 18:59:41 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata hash.
Date: Sat, 29 Jun 2013 15:58:56 -0700
Message-Id: <1372546738-25827-4-git-send-email-greearb@candelatech.com> (sfid-20130630_005944_514926_D21D8724)
In-Reply-To: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add sdata hash (based on sdata->vif.addr) to local
structure.

Add sta_vhash (based on sta->sta.addr) to sdata struct.

Make STA_HASH give a better hash spread more often.

Use new hashes where we can.  Might be able to completely
get rid of the local->sta_hash, but didn't want to try that
quite yet.

This significantly improves performance when using lots
of station VIFs connected to the same AP.  It will likely
help other cases where the old hash logic failed to create
a decent spread.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ieee80211_i.h |   34 +++++++++++++++
 net/mac80211/iface.c       |   50 ++++++++++++++++++++++-
 net/mac80211/rx.c          |   16 +++++++
 net/mac80211/sta_info.c    |   97 +++++++++++++++++++++++++++++++++++---------
 net/mac80211/sta_info.h    |   18 +++++++-
 net/mac80211/status.c      |    6 +++
 6 files changed, 198 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8412a30..f36f120 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -670,6 +670,10 @@ struct ieee80211_chanctx {
 
 struct ieee80211_sub_if_data {
 	struct list_head list;
+	struct ieee80211_sub_if_data *hnext; /* sdata hash list pointer */
+
+	/* Protected by local->sta_mtx */
+	struct sta_info __rcu *sta_vhash[STA_HASH_SIZE]; /* By station addr */
 
 	struct wireless_dev wdev;
 
@@ -794,6 +798,34 @@ sdata_assert_lock(struct ieee80211_sub_if_data *sdata)
 	lockdep_assert_held(&sdata->wdev.mtx);
 }
 
+static inline
+void for_each_sdata_type_check(struct ieee80211_local *local,
+			       const u8 *addr,
+			       struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_sub_if_data *nxt)
+{
+}
+
+/* This deals with multiple sdata having same MAC */
+#define for_each_sdata(local, _addr, _sdata, nxt)			\
+	for (   /* initialise loop */					\
+		_sdata = rcu_dereference(local->sdata_hash[STA_HASH(_addr)]), \
+			nxt = _sdata ? rcu_dereference(_sdata->hnext) : NULL; \
+		/* typecheck */						\
+		for_each_sdata_type_check(local, (_addr), _sdata, nxt), \
+			/* continue condition */			\
+			_sdata;						\
+		/* advance loop */					\
+		_sdata = nxt,						\
+			nxt = _sdata ? rcu_dereference(_sdata->hnext) : NULL \
+		)							\
+		/* compare address and run code only if it matches */	\
+		if (ether_addr_equal(_sdata->vif.addr, (_addr)))
+
+
+struct ieee80211_sub_if_data*
+ieee80211_find_sdata(struct ieee80211_local *local, const u8 *vif_addr);
+
 static inline enum ieee80211_band
 ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 {
@@ -1009,6 +1041,8 @@ struct ieee80211_local {
 	u32 wep_iv;
 
 	/* see iface.c */
+	/* Hash interfaces by VIF mac addr */
+	struct ieee80211_sub_if_data __rcu *sdata_hash[STA_HASH_SIZE];
 	struct list_head interfaces;
 	struct mutex iflist_mtx;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a2a8250..1bf7996 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -208,6 +208,47 @@ static int ieee80211_verify_mac(struct ieee80211_sub_if_data *sdata, u8 *addr,
 	return ret;
 }
 
+
+static void __ieee80211_if_add_hash(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	int idx = STA_HASH(sdata->vif.addr);
+
+	lockdep_assert_held(&local->iflist_mtx);
+	sdata->hnext = local->sdata_hash[idx];
+	rcu_assign_pointer(local->sdata_hash[idx], sdata);
+}
+
+static int __ieee80211_if_remove_hash(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_sub_if_data *s;
+	struct ieee80211_local *local = sdata->local;
+	int idx = STA_HASH(sdata->vif.addr);
+
+	lockdep_assert_held(&local->iflist_mtx);
+	s = rcu_dereference_protected(local->sdata_hash[idx],
+				      lockdep_is_held(&local->iflist_mtx));
+	if (!s)
+		return -ENOENT;
+
+	if (s == sdata) {
+		rcu_assign_pointer(local->sdata_hash[idx], s->hnext);
+		return 0;
+	}
+
+	while (rcu_access_pointer(s->hnext) &&
+	       rcu_access_pointer(s->hnext) != sdata)
+		s = rcu_dereference_protected(s->hnext,
+					lockdep_is_held(&local->iflist_mtx));
+
+	if (rcu_access_pointer(s->hnext)) {
+		rcu_assign_pointer(s->hnext, sdata->hnext);
+		return 0;
+	}
+	return -ENOENT;
+}
+
+
 static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -228,8 +269,13 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 
 	ret = eth_mac_addr(dev, sa);
 
-	if (ret == 0)
+	if (ret == 0) {
+		mutex_lock(&sdata->local->iflist_mtx);
+		__ieee80211_if_remove_hash(sdata);
 		memcpy(sdata->vif.addr, sa->sa_data, ETH_ALEN);
+		__ieee80211_if_add_hash(sdata);
+		mutex_unlock(&sdata->local->iflist_mtx);
+	}
 
 	return ret;
 }
@@ -1688,6 +1734,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
+	__ieee80211_if_add_hash(sdata);
 	mutex_unlock(&local->iflist_mtx);
 
 	if (new_wdev)
@@ -1702,6 +1749,7 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->iflist_mtx);
 	list_del_rcu(&sdata->list);
+	__ieee80211_if_remove_hash(sdata);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
 	synchronize_rcu();
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23dbcfc..67efa59 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3172,6 +3172,21 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
 
+		/* Check for Station VIFS by hashing on the destination MAC
+		 * (ie, local sdata MAC).  This changes 'promisc' behaviour,
+		 * but not sure that is a bad thing.
+		 */
+		if ((!is_multicast_ether_addr(hdr->addr1)) &&
+		    (local->monitors == 0) && (local->cooked_mntrs == 0)) {
+			sta = sta_info_get_by_vif(local, hdr->addr1,
+						  hdr->addr2);
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
@@ -3189,6 +3204,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			rx.sta = prev_sta;
 			rx.sdata = prev_sta->sdata;
 
+rx_and_done:
 			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
 				return;
 			goto out;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aeb967a..44bb89b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -68,27 +68,54 @@ static int sta_info_hash_del(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
 	struct sta_info *s;
+	int rv = -ENOENT;
+	int idx = STA_HASH(sta->sta.addr);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
+	s = rcu_dereference_protected(local->sta_hash[idx],
 				      lockdep_is_held(&local->sta_mtx));
 	if (!s)
-		return -ENOENT;
+		/* If station is not in the main hash, then it definitely
+		 * should not be in the vhash, so we can just return.
+		 */
+		return rv;
+
 	if (s == sta) {
-		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)],
-				   s->hnext);
-		return 0;
+		rcu_assign_pointer(local->sta_hash[idx], s->hnext);
+		rv = 0;
+		goto try_vhash;
 	}
 
 	while (rcu_access_pointer(s->hnext) &&
 	       rcu_access_pointer(s->hnext) != sta)
 		s = rcu_dereference_protected(s->hnext,
-					lockdep_is_held(&local->sta_mtx));
+					      lockdep_is_held(&local->sta_mtx));
 	if (rcu_access_pointer(s->hnext)) {
 		rcu_assign_pointer(s->hnext, sta->hnext);
-		return 0;
+		rv = 0;
+		goto try_vhash;
 	}
+	return rv;
 
-	return -ENOENT;
+try_vhash:
+	s = rcu_dereference_protected(sdata->sta_vhash[idx],
+				      lockdep_is_held(&local->sta_mtx));
+	if (!s)
+		return rv;
+
+	if (s == sta) {
+		rcu_assign_pointer(sdata->sta_vhash[idx], s->vnext);
+		return rv;
+	}
+
+	while (rcu_access_pointer(s->vnext) &&
+	       rcu_access_pointer(s->vnext) != sta)
+		s = rcu_dereference_protected(s->vnext,
+					      lockdep_is_held(&local->sta_mtx));
+	if (rcu_access_pointer(s->vnext))
+		rcu_assign_pointer(s->vnext, sta->vnext);
+
+	return rv;
 }
 
 static void cleanup_single_sta(struct sta_info *sta)
@@ -195,17 +222,15 @@ static void free_sta_rcu(struct rcu_head *h)
 struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_mtx));
+	sta = rcu_dereference_check(sdata->sta_vhash[STA_HASH(addr)],
+				    lockdep_is_held(&sdata->local->sta_mtx));
 	while (sta) {
-		if (sta->sdata == sdata &&
-		    ether_addr_equal(sta->sta.addr, addr))
+		if (ether_addr_equal(sta->sta.addr, addr))
 			break;
-		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_mtx));
+		sta = rcu_dereference_check(sta->vnext,
+				lockdep_is_held(&sdata->local->sta_mtx));
 	}
 	return sta;
 }
@@ -220,6 +245,13 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
+	sta = sta_info_get(sdata, addr);
+	if (sta)
+		return sta;
+
+	/* Maybe it's on some other sdata matching the bss, try
+	 * a bit harder.
+	 */
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
@@ -233,6 +265,22 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
+struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
+				     const u8 *vif_addr, const u8 *sta_addr)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *nxt;
+	struct sta_info *sta;
+
+	for_each_sdata(local, vif_addr, sdata, nxt) {
+		sta = sta_info_get(sdata, sta_addr);
+		if (sta)
+			return sta;
+	}
+	return NULL;
+}
+
+
 struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 				     int idx)
 {
@@ -278,9 +326,14 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 static void sta_info_hash_add(struct ieee80211_local *local,
 			      struct sta_info *sta)
 {
+	int idx = STA_HASH(sta->sta.addr);
+
 	lockdep_assert_held(&local->sta_mtx);
-	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
-	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
+	sta->hnext = local->sta_hash[idx];
+	rcu_assign_pointer(local->sta_hash[idx], sta);
+
+	sta->vnext = sta->sdata->sta_vhash[idx];
+	rcu_assign_pointer(sta->sdata->sta_vhash[idx], sta);
 }
 
 static void sta_unblock(struct work_struct *wk)
@@ -975,14 +1028,18 @@ struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
 {
 	struct sta_info *sta, *nxt;
 
+	if (localaddr) {
+		sta = sta_info_get_by_vif(hw_to_local(hw), localaddr, addr);
+		if (sta && sta->uploaded)
+			return &sta->sta;
+		return NULL;
+	}
+
 	/*
 	 * Just return a random station if localaddr is NULL
 	 * ... first in list.
 	 */
 	for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
-		if (localaddr &&
-		    !ether_addr_equal(sta->sdata->vif.addr, localaddr))
-			continue;
 		if (!sta->uploaded)
 			return NULL;
 		return &sta->sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4208dbd..963de5e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/average.h>
 #include <linux/etherdevice.h>
+#include <linux/hash.h>
 #include "key.h"
 
 /**
@@ -228,7 +229,8 @@ struct sta_ampdu_mlme {
  * mac80211 is communicating with.
  *
  * @list: global linked list entry
- * @hnext: hash table linked list pointer
+ * @hnext: hash table linked list pointer, used by local->sta_hash
+ * @vnext: hash table linked list pointer, used by sdata->sta_vhash.
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer key negotiated with this station, if any
@@ -307,6 +309,7 @@ struct sta_info {
 	struct list_head list;
 	struct rcu_head rcu_head;
 	struct sta_info __rcu *hnext;
+	struct sta_info __rcu *vnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -492,7 +495,12 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
 }
 
 #define STA_HASH_SIZE 256
-#define STA_HASH(sta) (sta[5])
+static inline u32 STA_HASH(const unsigned char *addr)
+{
+	u32 v = (addr[0] << 8) | addr[1];
+	v ^= (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) | addr[5];
+	return hash_32(v, 8);
+}
 
 
 /* Maximum number of frames to buffer per power saving station per AC */
@@ -514,6 +522,12 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
+/*
+ * Uses the local->sdata hash and sdata->sta_hash for fast lookup
+ * base on VIF (sdata) address and remote station address.
+ */
+struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
+				     const u8 *vif_addr, const u8 *sta_addr);
 
 static inline
 void for_each_sta_info_type_check(struct ieee80211_local *local,
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4343920..0ecab1a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -453,11 +453,16 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	sband = local->hw.wiphy->bands[info->band];
 	fc = hdr->frame_control;
 
+	sta = sta_info_get_by_vif(local, hdr->addr2, hdr->addr1);
+	if (sta)
+		goto found_it;
+
 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
 		/* skip wrong virtual interface */
 		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
 			continue;
 
+found_it:
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
 			clear_sta_flag(sta, WLAN_STA_SP);
 
@@ -553,6 +558,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		if (acked)
 			sta->last_ack_signal = info->status.ack_signal;
+		break;
 	}
 
 	rcu_read_unlock();
-- 
1.7.3.4

