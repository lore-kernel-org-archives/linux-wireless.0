Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab2LNN5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 08:57:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: optimise AP stop RCU handling
Date: Fri, 14 Dec 2012 14:57:56 +0100
Message-Id: <1355493476-2927-1-git-send-email-johannes@sipsolutions.net> (sfid-20121214_145817_787355_201B178C)
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are VLANs, stopping an AP is inefficient as it
calls rcu_barrier() once for each interface (the VLANs
and the AP itself). Optimise this by moving rcu_barrier()
out of the station cleanups and calling it only once for
all interfaces combined.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      |  8 ++++++--
 net/mac80211/iface.c    | 13 ++++++++-----
 net/mac80211/sta_info.c |  2 --
 net/mac80211/sta_info.h | 14 ++++++++++++++
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8576723..c485b36 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1014,8 +1014,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		kfree_rcu(old_probe_resp, rcu_head);
 
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		sta_info_flush(vlan);
-	sta_info_flush(sdata);
+		sta_info_flush_defer(vlan);
+	sta_info_flush_defer(sdata);
+	rcu_barrier();
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		sta_info_flush_cleanup(vlan);
+	sta_info_flush_cleanup(sdata);
 
 	sdata->vif.bss_conf.enable_beacon = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dcf943e..e02f7a0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -872,12 +872,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		cancel_work_sync(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
-		 * sta_info_flush_cleanup() calls rcu_barrier to
-		 * wait for the station call_rcu() calls to complete,
-		 * here we require it to wait for the RX path in case
-		 * it is using the interface and enqueuing frames at
-		 * this very time on another CPU.
+		 *
+		 * sta_info_flush_cleanup() requires rcu_barrier()
+		 * first to wait for the station call_rcu() calls
+		 * to complete, here we need at least sychronize_rcu()
+		 * it to wait for the RX path in case it is using the
+		 * interface and enqueuing frames at this very time on
+		 * another CPU.
 		 */
+		rcu_barrier();
 		sta_info_flush_cleanup(sdata);
 
 		skb_queue_purge(&sdata->skb_queue);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2f74031..f61bb46 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -920,8 +920,6 @@ int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata)
 
 void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata)
 {
-	rcu_barrier();
-
 	ieee80211_cleanup_sdata_stas(sdata);
 	cancel_work_sync(&sdata->cleanup_stations_wk);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c3266aed..031e4a5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -549,6 +549,19 @@ void sta_info_recalc_tim(struct sta_info *sta);
 void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata);
+
+/**
+ * sta_info_flush_cleanup - flush the sta_info cleanup queue
+ * @sdata: the interface
+ *
+ * Flushes the sta_info cleanup queue for a given interface;
+ * this is necessary before the interface is removed or, for
+ * AP/mesh interfaces, before it is deconfigured.
+ *
+ * Note an rcu_barrier() must precede the function, after all
+ * stations have been flushed/removed to ensure the call_rcu()
+ * calls that add stations to the cleanup queue have completed.
+ */
 void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata);
 
 /**
@@ -562,6 +575,7 @@ static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 {
 	int ret = sta_info_flush_defer(sdata);
 
+	rcu_barrier();
 	sta_info_flush_cleanup(sdata);
 
 	return ret;
-- 
1.8.0

