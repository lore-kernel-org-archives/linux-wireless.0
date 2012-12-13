Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab2LMW7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:59:21 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/5] mac80211: optimise roaming time again
Date: Thu, 13 Dec 2012 23:59:33 +0100
Message-Id: <1355439573-13206-6-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235927_811450_BFD3642F)
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The last fixes re-added the RCU synchronize penalty
on roaming to fix the races. Split up sta_info_flush()
now to get rid of that again, and let managed mode
(and only it) delay the actual destruction.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c    | 15 ++++++++++-----
 net/mac80211/mlme.c     |  2 +-
 net/mac80211/sta_info.c | 27 +++++++++++++++++----------
 net/mac80211/sta_info.h | 21 ++++++++++++++++++++-
 4 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9dacc3a..ab47df0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -784,8 +784,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	 * This is relevant only in WDS mode, in all other modes we've
 	 * already removed all stations when disconnecting or similar,
 	 * so warn otherwise.
+	 *
+	 * We call sta_info_flush_cleanup() later, to combine RCU waits.
 	 */
-	flushed = sta_info_flush(sdata);
+	flushed = sta_info_flush_defer(sdata);
 	WARN_ON_ONCE((sdata->vif.type != NL80211_IFTYPE_WDS && flushed > 0) ||
 		     (sdata->vif.type == NL80211_IFTYPE_WDS && flushed != 1));
 
@@ -870,11 +872,14 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		cancel_work_sync(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
-		 * Call synchronize_rcu() to wait for the RX path
-		 * should it be using the interface and enqueuing
-		 * frames at this very time on another CPU.
+		 * sta_info_flush_cleanup() calls rcu_barrier to
+		 * wait for the station call_rcu() calls to complete,
+		 * here we require it to wait for the RX path in case
+		 * it is using the interface and enqueuing frames at
+		 * this very time on another CPU.
 		 */
-		synchronize_rcu();
+		sta_info_flush_cleanup(sdata);
+
 		skb_queue_purge(&sdata->skb_queue);
 
 		/*
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7cbb4cb..964c33e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1518,7 +1518,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
 	/* remove AP and TDLS peers */
-	sta_info_flush(sdata);
+	sta_info_flush_defer(sdata);
 
 	/* finally reset all BSS / config parameters */
 	changed |= ieee80211_reset_erp_info(sdata);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1a84a52..2f74031 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -104,6 +104,16 @@ static void cleanup_single_sta(struct sta_info *sta)
 	 * neither mac80211 nor the driver can reference this
 	 * sta struct any more except by still existing timers
 	 * associated with this station that we clean up below.
+	 *
+	 * Note though that this still uses the sdata and even
+	 * calls the driver in AP and mesh mode, so interfaces
+	 * of those types mush use call sta_info_flush_cleanup()
+	 * (typically via sta_info_flush()) before deconfiguring
+	 * the driver.
+	 *
+	 * In station mode, nothing happens here so it doesn't
+	 * have to (and doesn't) do that, this is intentional to
+	 * speed up roaming.
 	 */
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
@@ -887,14 +897,8 @@ void sta_info_stop(struct ieee80211_local *local)
 	del_timer_sync(&local->sta_cleanup);
 }
 
-/**
- * sta_info_flush - flush matching STA entries from the STA table
- *
- * Returns the number of removed STA entries.
- *
- * @sdata: sdata to remove all stations from
- */
-int sta_info_flush(struct ieee80211_sub_if_data *sdata)
+
+int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
@@ -911,12 +915,15 @@ int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 	}
 	mutex_unlock(&local->sta_mtx);
 
+	return ret;
+}
+
+void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata)
+{
 	rcu_barrier();
 
 	ieee80211_cleanup_sdata_stas(sdata);
 	cancel_work_sync(&sdata->cleanup_stations_wk);
-
-	return ret;
 }
 
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 13698da..93e8ae7 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -548,7 +548,26 @@ void sta_info_recalc_tim(struct sta_info *sta);
 
 void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
-int sta_info_flush(struct ieee80211_sub_if_data *sdata);
+int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata);
+void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata);
+
+/**
+ * sta_info_flush - flush matching STA entries from the STA table
+ *
+ * Returns the number of removed STA entries.
+ *
+ * @sdata: sdata to remove all stations from
+ */
+static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
+{
+	int ret = sta_info_flush_defer(sdata);
+
+	if (ret)
+		sta_info_flush_cleanup(sdata);
+
+	return ret;
+}
+
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo);
-- 
1.8.0

