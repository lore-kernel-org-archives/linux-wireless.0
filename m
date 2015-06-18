Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54260 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbbFROVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 10:21:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: mesh: move fail_avg into mesh struct
Date: Thu, 18 Jun 2015 16:21:02 +0200
Message-Id: <1434637262-23604-1-git-send-email-johannes@sipsolutions.net> (sfid-20150618_162109_664682_A08908AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This value is only used in mesh, so move it into the new mesh
sub-struct of the station info.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_hwmp.c | 9 +++++----
 net/mac80211/sta_info.h  | 7 ++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index be635341c802..d80e0a4c16cf 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -308,8 +308,9 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
 	/* moving average, scaled to 100 */
-	sta->fail_avg = ((80 * sta->fail_avg + 5) / 100 + 20 * failed);
-	if (sta->fail_avg > 95)
+	sta->mesh->fail_avg =
+		((80 * sta->mesh->fail_avg + 5) / 100 + 20 * failed);
+	if (sta->mesh->fail_avg > 95)
 		mesh_plink_broken(sta);
 }
 
@@ -325,7 +326,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	u32 tx_time, estimated_retx;
 	u64 result;
 
-	if (sta->fail_avg >= 100)
+	if (sta->mesh->fail_avg >= 100)
 		return MAX_METRIC;
 
 	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
@@ -333,7 +334,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (WARN_ON(!rate))
 		return MAX_METRIC;
 
-	err = (sta->fail_avg << ARITH_SHIFT) / 100;
+	err = (sta->mesh->fail_avg << ARITH_SHIFT) / 100;
 
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4f4f32f08a90..013fa5ac36e2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -291,6 +291,7 @@ struct ieee80211_fast_tx {
  * @nonpeer_pm: STA power save mode towards non-peer neighbors
  * @processed_beacon: set to true after peer rates and capabilities are
  *	processed
+ * @fail_avg: moving percentage of failed MSDUs
  */
 struct mesh_sta {
 	struct timer_list plink_timer;
@@ -313,6 +314,9 @@ struct mesh_sta {
 	enum nl80211_mesh_power_mode local_pm;
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
+
+	/* moving percentage of failed MSDUs */
+	unsigned int fail_avg;
 };
 
 /**
@@ -370,7 +374,6 @@ struct mesh_sta {
  * @tx_filtered_count: number of frames the hardware filtered for this STA
  * @tx_retry_failed: number of frames that failed retry
  * @tx_retry_count: total number of retries for frames to this STA
- * @fail_avg: moving percentage of failed MSDUs
  * @tx_packets: number of RX/TX MSDUs
  * @tx_bytes: number of bytes transmitted to this STA
  * @tid_seq: per-TID sequence numbers for sending to this STA
@@ -474,8 +477,6 @@ struct sta_info {
 	/* Updated from TX status path only, no locking requirements */
 	unsigned long tx_filtered_count;
 	unsigned long tx_retry_failed, tx_retry_count;
-	/* moving percentage of failed MSDUs */
-	unsigned int fail_avg;
 
 	struct u64_stats_sync status_sync;
 	u64 tx_msdu_retries[IEEE80211_NUM_TIDS + 1];
-- 
2.1.4

