Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYIKAEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:04:05 -0400
Subject: [PATCH 19/18] mac80211: small rate control changes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 02:03:28 +0200
Message-Id: <1221091408.3804.58.camel@johannes.berg> (sfid-20080911_020408_173289_410A83FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes mac80211 to not rely on the rate control
algorithm to update sta->tx_retry_failed and sta->tx_retry_count
(even if we don't currently use them), removes a number of
completely unused values we don't even show in debugfs and
changes the code in ieee80211_tx_status() to not look up the
sta_info repeatedly.

The only behaviour change here would be not calling the rate
control function rate_control_tx_status() when no sta_info is
found, but all rate control algorithms ignore such calls anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Now we can also change it to pass in the actual rate control information
to the algorithm, saving all the lookups there and the cross-dir header
inclusion! :)

 net/mac80211/main.c             |   50 ++++++++++++++++++++--------------------
 net/mac80211/rc80211_pid_algo.c |   11 --------
 net/mac80211/sta_info.h         |    7 -----
 3 files changed, 25 insertions(+), 43 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-09-11 01:51:51.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-11 01:51:51.000000000 +0200
@@ -195,9 +195,6 @@ struct sta_ampdu_mlme {
  * @tx_filtered_count: TBD
  * @tx_retry_failed: TBD
  * @tx_retry_count: TBD
- * @tx_num_consecutive_failures: TBD
- * @tx_num_mpdu_ok: TBD
- * @tx_num_mpdu_fail: TBD
  * @fail_avg: moving percentage of failed MSDUs
  * @tx_packets: number of RX/TX MSDUs
  * @tx_bytes: TBD
@@ -273,10 +270,6 @@ struct sta_info {
 	/* Updated from TX status path only, no locking requirements */
 	unsigned long tx_filtered_count;
 	unsigned long tx_retry_failed, tx_retry_count;
-	/* TODO: update in generic code not rate control? */
-	u32 tx_num_consecutive_failures;
-	u32 tx_num_mpdu_ok;
-	u32 tx_num_mpdu_fail;
 	/* moving percentage of failed MSDUs */
 	unsigned int fail_avg;
 
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-09-11 01:51:50.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-09-11 01:51:51.000000000 +0200
@@ -282,17 +282,6 @@ static void rate_control_pid_tx_status(v
 		spinfo->tx_num_xmit++;
 	}
 
-	if (info->status.excessive_retries) {
-		sta->tx_retry_failed++;
-		sta->tx_num_consecutive_failures++;
-		sta->tx_num_mpdu_fail++;
-	} else {
-		sta->tx_num_consecutive_failures = 0;
-		sta->tx_num_mpdu_ok++;
-	}
-	sta->tx_retry_count += info->status.retry_count;
-	sta->tx_num_mpdu_fail += info->status.retry_count;
-
 	/* Update PID controller state. */
 	period = (HZ * pinfo->sampling_period + 500) / 1000;
 	if (!period)
--- everything.orig/net/mac80211/main.c	2008-09-11 01:51:51.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-11 01:51:51.000000000 +0200
@@ -546,29 +546,27 @@ void ieee80211_tx_status(struct ieee8021
 
 	rcu_read_lock();
 
-	if (info->status.excessive_retries) {
-		sta = sta_info_get(local, hdr->addr1);
-		if (sta) {
-			if (test_sta_flags(sta, WLAN_STA_PS)) {
-				/*
-				 * The STA is in power save mode, so assume
-				 * that this TX packet failed because of that.
-				 */
-				ieee80211_handle_filtered_frame(local, sta, skb);
-				rcu_read_unlock();
-				return;
-			}
+	sta = sta_info_get(local, hdr->addr1);
+
+	if (sta) {
+		if (info->status.excessive_retries &&
+		    test_sta_flags(sta, WLAN_STA_PS)) {
+			/*
+			 * The STA is in power save mode, so assume
+			 * that this TX packet failed because of that.
+			 */
+			ieee80211_handle_filtered_frame(local, sta, skb);
+			rcu_read_unlock();
+			return;
 		}
-	}
 
-	fc = hdr->frame_control;
+		fc = hdr->frame_control;
+
+		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
+		    (ieee80211_is_data_qos(fc))) {
+			u16 tid, ssn;
+			u8 *qc;
 
-	if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
-	    (ieee80211_is_data_qos(fc))) {
-		u16 tid, ssn;
-		u8 *qc;
-		sta = sta_info_get(local, hdr->addr1);
-		if (sta) {
 			qc = ieee80211_get_qos_ctl(hdr);
 			tid = qc[0] & 0xf;
 			ssn = ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
@@ -576,17 +574,19 @@ void ieee80211_tx_status(struct ieee8021
 			ieee80211_send_bar(sta->sdata, hdr->addr1,
 					   tid, ssn);
 		}
-	}
 
-	if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		sta = sta_info_get(local, hdr->addr1);
-		if (sta) {
+		if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
 			rcu_read_unlock();
 			return;
+		} else {
+			if (info->status.excessive_retries)
+				sta->tx_retry_failed++;
+			sta->tx_retry_count += info->status.retry_count;
 		}
-	} else
+
 		rate_control_tx_status(local->mdev, skb);
+	}
 
 	rcu_read_unlock();
 


