Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46871 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933847AbdDFJid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 05:38:33 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v3] mac80211: Dynamically set CoDel parameters per station
Date: Thu,  6 Apr 2017 11:38:26 +0200
Message-Id: <20170406093826.16626-1-toke@toke.dk> (sfid-20170406_113851_927923_E0E6B713)
In-Reply-To: <20170405161810.30671-1-toke@toke.dk>
References: <20170405161810.30671-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CoDel can be too aggressive if a station sends at a very low rate,
leading reduced throughput. This gets worse the more stations are
present, as each station gets more bursty the longer the round-robin
scheduling between stations takes.

This adds dynamic adjustment of CoDel parameters per station. It uses
the rate selection information to estimate throughput and sets more
lenient CoDel parameters if the estimated throughput is below a
threshold (modified by the number of active stations).

A new callback is added that drivers can use to notify mac80211 about
changes in expected throughput, so the same adjustment can be made for
cards that implement rate control in firmware. Drivers that don't use
this will just get the default parameters.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
Changes since v2:
 - Messed up the rebase and squash in v2; this one actually compiles...
 
 include/net/mac80211.h     | 17 +++++++++++++++++
 net/mac80211/debugfs_sta.c |  6 ++++++
 net/mac80211/rate.c        |  3 ++-
 net/mac80211/sta_info.c    | 31 +++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    | 11 +++++++++++
 net/mac80211/tx.c          |  9 ++++++++-
 6 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a3bab3c5ecfb..8cd546cbcabc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4181,6 +4181,23 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 			    int max_rates);
 
 /**
+ * ieee80211_sta_set_expected_throughput - set the expected throughput for a
+ * station
+ *
+ * Call this function to notify mac80211 about a change in expected throughput
+ * to a station. A driver for a device that does rate control in firmware can
+ * call this function when the expected throughput estimate towards a station
+ * changes. The information is used to tune the CoDel AQM applied to traffic
+ * going towards that station (which can otherwise be too aggressive and cause
+ * slow stations to starve).
+ *
+ * @pubsta: the station to set throughput for.
+ * @thr: the current expected throughput in kbps.
+ */
+void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
+					   u32 thr);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 42601820db20..b15412c21ac9 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -154,6 +154,12 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 
 	p += scnprintf(p,
 		       bufsz+buf-p,
+		       "target %uus interval %uus ecn %s\n",
+		       codel_time_to_us(sta->cparams.target),
+		       codel_time_to_us(sta->cparams.interval),
+		       sta->cparams.ecn ? "yes" : "no");
+	p += scnprintf(p,
+		       bufsz+buf-p,
 		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n");
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 206698bc93f4..233c23ba2b98 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -890,6 +890,8 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 
 	drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
 
+	ieee80211_sta_set_expected_throughput(pubsta, sta_get_expected_throughput(sta));
+
 	return 0;
 }
 EXPORT_SYMBOL(rate_control_set_rates);
@@ -938,4 +940,3 @@ void rate_control_deinitialize(struct ieee80211_local *local)
 	local->rate_ctrl = NULL;
 	rate_control_free(ref);
 }
-
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3323a2fb289b..d5d54e84620f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -20,6 +20,7 @@
 #include <linux/timer.h>
 #include <linux/rtnetlink.h>
 
+#include <net/codel.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -420,6 +421,11 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->sta.max_rc_amsdu_len = IEEE80211_MAX_MPDU_LEN_HT_BA;
 
+	sta->cparams.ce_threshold = CODEL_DISABLED_THRESHOLD;
+	sta->cparams.target = MS2TIME(20);
+	sta->cparams.interval = MS2TIME(100);
+	sta->cparams.ecn = true;
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
@@ -2298,3 +2304,28 @@ unsigned long ieee80211_sta_last_active(struct sta_info *sta)
 		return stats->last_rx;
 	return sta->status_stats.last_ack;
 }
+
+static inline void sta_update_codel_params(struct sta_info *sta, u32 thr)
+{
+	if (!sta->sdata->local->ops->wake_tx_queue)
+		return;
+
+	if (thr && thr < STA_SLOW_THRESHOLD * sta->local->num_sta) {
+		sta->cparams.target = MS2TIME(50);
+		sta->cparams.interval = MS2TIME(300);
+		sta->cparams.ecn = false;
+	} else {
+		sta->cparams.target = MS2TIME(20);
+		sta->cparams.interval = MS2TIME(100);
+		sta->cparams.ecn = true;
+	}
+}
+
+void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
+					   u32 thr)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+
+	sta_update_codel_params(sta, thr);
+}
+EXPORT_SYMBOL(ieee80211_sta_set_expected_throughput);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e65cda34d2bc..e3b07e019df1 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -390,6 +390,14 @@ struct ieee80211_sta_rx_stats {
 };
 
 /**
+ * The bandwidth threshold below which the per-station CoDel parameters will be
+ * scaled to be more lenient (to prevent starvation of slow stations). This
+ * value will be scaled by the number of active stations when it is being
+ * applied.
+ */
+#define STA_SLOW_THRESHOLD 6000 /* 6 Mbps */
+
+/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that
@@ -442,6 +450,7 @@ struct ieee80211_sta_rx_stats {
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant for
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
+ * @cparams: CoDel parameters for this station.
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
  * @fast_tx: TX fastpath information
  * @fast_rx: RX fastpath information
@@ -545,6 +554,8 @@ struct sta_info {
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
 
+	struct codel_params cparams;
+
 	u8 reserved_tid;
 
 	struct cfg80211_chan_def tdls_chandef;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ba8d7db0a071..dab60a165059 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1344,9 +1344,16 @@ static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
 
 	local = container_of(fq, struct ieee80211_local, fq);
 	txqi = container_of(tin, struct txq_info, tin);
-	cparams = &local->cparams;
 	cstats = &txqi->cstats;
 
+	if (txqi->txq.sta) {
+		struct sta_info *sta = container_of(txqi->txq.sta,
+						    struct sta_info, sta);
+		cparams = &sta->cparams;
+	} else {
+		cparams = &local->cparams;
+	}
+
 	if (flow == &txqi->def_flow)
 		cvars = &txqi->def_cvars;
 	else
-- 
2.12.1
