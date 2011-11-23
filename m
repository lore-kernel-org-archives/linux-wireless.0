Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46410 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab1KWOKN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:10:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: do not pass AP VLAN vif pointers to drivers
Date: Wed, 23 Nov 2011 21:09:49 +0700
Message-Id: <1322057389-22421-1-git-send-email-nbd@openwrt.org> (sfid-20111123_151017_863524_3473A0EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes frequent WARN_ONs when using AP VLAN + aggregation, as these vifs
are virtual and not registered with drivers.
Use sta_info_get_bss instead of sta_info_get in aggregation callbacks, so
that these callbacks can find the station entry when called with the AP vif.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/agg-rx.c     |    2 +-
 net/mac80211/agg-tx.c     |    4 ++--
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/sta_info.c   |    4 ----
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 476b106..06e92da 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -109,7 +109,7 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 	int i;
 
 	rcu_read_lock();
-	sta = sta_info_get(sdata, addr);
+	sta = sta_info_get_bss(sdata, addr);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..94154b6 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -527,7 +527,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 	}
 
 	mutex_lock(&local->sta_mtx);
-	sta = sta_info_get(sdata, ra);
+	sta = sta_info_get_bss(sdata, ra);
 	if (!sta) {
 		mutex_unlock(&local->sta_mtx);
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -656,7 +656,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 
 	mutex_lock(&local->sta_mtx);
 
-	sta = sta_info_get(sdata, ra);
+	sta = sta_info_get_bss(sdata, ra);
 	if (!sta) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find station: %pM\n", ra);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 49cc5e0..e8960ae 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -10,6 +10,16 @@ static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
 	WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
 }
 
+static inline struct ieee80211_sub_if_data *
+get_bss_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
+				     u.ap);
+
+	return sdata;
+}
+
 static inline void drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
 {
 	local->ops->tx(&local->hw, skb);
@@ -421,6 +431,7 @@ static inline void drv_sta_notify(struct ieee80211_local *local,
 				  enum sta_notify_cmd cmd,
 				  struct ieee80211_sta *sta)
 {
+	sdata = get_bss_sdata(sdata);
 	check_sdata_in_driver(sdata);
 
 	trace_drv_sta_notify(local, sdata, cmd, sta);
@@ -437,6 +448,7 @@ static inline int drv_sta_add(struct ieee80211_local *local,
 
 	might_sleep();
 
+	sdata = get_bss_sdata(sdata);
 	check_sdata_in_driver(sdata);
 
 	trace_drv_sta_add(local, sdata, sta);
@@ -454,6 +466,7 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
 {
 	might_sleep();
 
+	sdata = get_bss_sdata(sdata);
 	check_sdata_in_driver(sdata);
 
 	trace_drv_sta_remove(local, sdata, sta);
@@ -547,6 +560,7 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 
 	might_sleep();
 
+	sdata = get_bss_sdata(sdata);
 	check_sdata_in_driver(sdata);
 
 	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8eaa746..f982352 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -351,10 +351,6 @@ static int sta_info_finish_insert(struct sta_info *sta,
 
 	if (!sta->dummy || dummy_reinsert) {
 		/* notify driver */
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-			sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
 		err = drv_sta_add(local, sdata, &sta->sta);
 		if (err) {
 			if (!async)
-- 
1.7.3.2

