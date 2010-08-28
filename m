Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0H1HNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 03:13:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 2/3] mac80211: allow drivers to specify sw scan wait constraints
Date: Sat, 28 Aug 2010 03:13:09 -0400
Message-Id: <1282979590-31113-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's scan implementation puts the burden of processing the DTIM
count, ensuring all the device has recevied all broadcast and multicast
frames, and ensuring the AP has received or nullfunc frame prior to
allowing the driver to go to scan. This patch enables drivers to inform
mac80211 of any of these time constraints prior to scanning on the next
channel. If a time constraint is reached mac80211 will move to the home
operating channel and delay scanning on the next channel until the time
constraints are removed.

We handle the nullfunc frame specially on the allowed callback. If
we know that the nullfunc frame has not yet been ACK'd by the AP
we can inform mac80211 so it can do a software retry on it. After
a few failed retries we simply give up and move on with the scan.

Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h      |   12 ++++++++++++
 net/mac80211/driver-ops.h   |   16 ++++++++++++++++
 net/mac80211/driver-trace.h |   18 ++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    2 ++
 net/mac80211/scan.c         |   42 ++++++++++++++++++++++++++++++++++++++----
 5 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dcc8c2b..fa455d6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1600,6 +1600,17 @@ enum ieee80211_ampdu_mlme_action {
  *	is started. Can be NULL, if the driver doesn't need this notification.
  *	The callback can sleep.
  *
+ * @sw_scan_wait_constraints: used by mac80211 to query for scan wait constraints.
+ *	The sw scan implementation in mac80211 assumes drivers take care of
+ *	processing an associated station's DTIM count, ensuring we received all
+ *	buffered broadcast and multicast frames, and ensuring the we have received
+ *	an ACK from the AP that that we are going into power save. Drivers can
+ *	implement this callback to let mac80211 query for these wait constraints
+ *	on scan prior to moving on to the next channel in the scan list. The
+ *	callback returns 0 if there are no wait constraints. If non zero is
+ *	returned mac80211 will return to the home channel and delay the scan
+ *	on the next channel some more. This callback is optional and can sleep.
+ *
  * @sw_scan_complete: Notifier function that is called just after a
  *	software scan finished. Can be NULL, if the driver doesn't need
  *	this notification.
@@ -1719,6 +1730,7 @@ struct ieee80211_ops {
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
+	int (*sw_scan_wait_constraints)(struct ieee80211_hw *hw);
 	void (*sw_scan_complete)(struct ieee80211_hw *hw);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 14123dc..5025950 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -187,6 +187,22 @@ static inline void drv_sw_scan_start(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
+static inline int drv_sw_scan_wait_constraints(struct ieee80211_local *local)
+{
+	bool wait_constraints = false;
+
+	might_sleep();
+
+	trace_drv_sw_scan_wait_constraints(local);
+	if (local->ops->sw_scan_start)
+		wait_constraints =
+			local->ops->sw_scan_wait_constraints(&local->hw);
+	trace_drv_return_int(local, wait_constraints);
+
+	return wait_constraints;
+}
+
+
 static inline void drv_sw_scan_complete(struct ieee80211_local *local)
 {
 	might_sleep();
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index b5a9558..f822f0f 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -427,6 +427,24 @@ TRACE_EVENT(drv_sw_scan_start,
 	)
 );
 
+TRACE_EVENT(drv_sw_scan_wait_constraints,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
 TRACE_EVENT(drv_sw_scan_complete,
 	TP_PROTO(struct ieee80211_local *local),
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e73ae51..b50e4b5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -757,6 +757,8 @@ struct ieee80211_local {
 
 	/* Scanning and BSS list */
 	unsigned long scanning;
+	u32 scan_nullfunc_retries;
+	u32 scan_oper_chan_waits;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
 	struct cfg80211_scan_request *scan_req, *hw_scan_req;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2c7e376..1d24002 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -512,7 +512,8 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 				local->hw.conf.listen_interval);
 
 		if (associated && ( !tx_empty || bad_latency ||
-		    listen_int_exceeded))
+		    listen_int_exceeded ||
+		    drv_sw_scan_wait_constraints(local)))
 			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
 			local->next_scan_state = SCAN_SET_CHANNEL;
@@ -520,23 +521,38 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 		/*
 		 * we're on the operating channel currently, let's
 		 * leave that channel now to scan another one
+		 * unless the driver has other wait time constraints
 		 */
-		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+		if (drv_sw_scan_wait_constraints(local) &&
+		    local->scan_oper_chan_waits < 2) {
+			local->next_scan_state = SCAN_DECISION;
+			local->scan_oper_chan_waits++;
+		} else {
+			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+			local->scan_oper_chan_waits = 0;
+		}
 	}
 
-	*next_delay = 0;
+	if (local->next_scan_state == SCAN_DECISION)
+		*next_delay = HZ / 5;
+	else
+		*next_delay = 0;
+
 	return 0;
 }
 
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
+	int r;
+
 	ieee80211_offchannel_stop_station(local);
 
 	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
 	/*
-	 * What if the nullfunc frames didn't arrive?
+	 * Drivers are responsible for ensuring their nullfunc frame
+	 * was ACKed by the AP.
 	 */
 	drv_flush(local, false);
 	if (local->ops->flush)
@@ -544,8 +560,26 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 	else
 		*next_delay = HZ / 10;
 
+	/*
+	 * If we're not getting ACKs for our nullfuncs we're likely in bad
+	 * shape so we should not care about missed data as we can't even
+	 * hear the AP. We want to help roam away if we can so just go
+	 * ahead and scan. Try getting the ACK just 3 times.
+	 */
+	r = drv_sw_scan_wait_constraints(local);
+	if (r == -EAGAIN) {
+		local->scan_nullfunc_retries++;
+		*next_delay = HZ / 10;
+
+		if (local->scan_nullfunc_retries < 3) {
+			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+			return;
+		}
+	}
+
 	/* remember when we left the operating channel */
 	local->leave_oper_channel_time = jiffies;
+	local->scan_nullfunc_retries = 0;
 
 	/* advance to the next channel to be scanned */
 	local->next_scan_state = SCAN_SET_CHANNEL;
-- 
1.7.0.4

