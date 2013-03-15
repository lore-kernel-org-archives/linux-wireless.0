Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56231 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3COVN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 17:13:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] mac80211:  Optimize sta lookup for many VIFs
Date: Fri, 15 Mar 2013 14:13:13 -0700
Message-Id: <1363381993-31496-2-git-send-email-greearb@candelatech.com> (sfid-20130315_221333_293041_95169062)
In-Reply-To: <1363381993-31496-1-git-send-email-greearb@candelatech.com>
References: <1363381993-31496-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The sta_info hash is designed to deal with an AP
with lots of stations associated, or a station interface
connected to a single AP.

However, when you have lots of station VIFs connected
to the same AP, the sta_info hash becomes worthless
as there is a single hash bucket that contains all the
entries in a linked list.

So, have the sdata object cache one of it's station
interfaces.  If we are a station VIF with a single
sta_info, then this means we can ignore the sta_info
hash entirely.

On a test case with 128 stations and 50 TCP streams,
tx performance went from around 80Mbps to 124Mbps.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 a618bda... 5288a4f... M	net/mac80211/cfg.c
:100644 100644 493e2e8... fe5d35b... M	net/mac80211/ieee80211_i.h
:100644 100644 415f9c6... 74d58f4... M	net/mac80211/sta_info.c
 net/mac80211/cfg.c         |    5 +++++
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/sta_info.c    |   18 +++++++++++++++++-
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a618bda..5288a4f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1287,6 +1287,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		bool prev_4addr = false;
 		bool new_4addr = false;
+		struct sta_info *some_sta;
 
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
@@ -1312,7 +1313,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 			prev_4addr = true;
 		}
 
+		some_sta = rcu_dereference(sta->sdata->some_sta);
+		if (some_sta == sta)
+			rcu_assign_pointer(sta->sdata->some_sta, NULL);
 		sta->sdata = vlansdata;
+		rcu_assign_pointer(sta->sdata->some_sta, sta);
 
 		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
 		    prev_4addr != new_4addr) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 493e2e8..fe5d35b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -669,6 +669,12 @@ struct ieee80211_sub_if_data {
 	/* count for keys needing tailroom space allocation */
 	int crypto_tx_tailroom_needed_cnt;
 
+	/* A pointer to some station associated with this interface, or
+	 * NULL.  This aids oportunistic lookup for sta_info objects when
+	 * sdata is a station with a single sta_info.
+	 */
+	struct sta_info __rcu *some_sta;
+
 	struct net_device *dev;
 	struct ieee80211_local *local;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 415f9c6..74d58f4 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -193,7 +193,17 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
+	struct sta_info *sta, *some_sta;
+
+	/* Shortcut for finding station entries when sdata is a station */
+	some_sta = rcu_dereference(sdata->some_sta);
+	if (some_sta) {
+		if (WARN_ON(some_sta->sdata != sdata))
+			rcu_assign_pointer(sdata->some_sta, NULL);
+		else
+			if (ether_addr_equal(some_sta->sta.addr, addr))
+				return some_sta;
+	}
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
 				    lockdep_is_held(&local->sta_mtx));
@@ -263,10 +273,14 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  */
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
+	struct sta_info* some_sta;
 	if (sta->rate_ctrl)
 		rate_control_free_sta(sta);
 
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
+	some_sta = rcu_dereference(sta->sdata->some_sta);
+	if (some_sta == sta)
+		rcu_assign_pointer(sta->sdata->some_sta, NULL);
 
 	kfree(sta);
 }
@@ -373,6 +387,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
+	rcu_assign_pointer(sta->sdata->some_sta, sta);
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 #ifdef CONFIG_MAC80211_MESH
-- 
1.7.3.4

