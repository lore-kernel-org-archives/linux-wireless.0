Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26111 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbE1G0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 02:26:37 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 2/2] mac80211: store low ack threshold in bss config
Date: Thu, 28 May 2015 11:55:55 +0530
Message-ID: <1432794355-3639-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150528_082648_997979_3CB71749)
In-Reply-To: <1432794355-3639-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1432794355-3639-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store the low ack threshold configured by user in BSS config.
This will be used by driver for triggering low ack event whenever
the station is not ACKing the number of frames mentioned in
threshold.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 net/mac80211/cfg.c      | 1 +
 net/mac80211/sta_info.h | 3 +++
 net/mac80211/status.c   | 4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ff347a0..be0e310 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1145,6 +1145,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					      params->opmode_notif,
 					      band, false);
 	}
+	sta->low_ack_threshold = params->low_ack_threshold;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5c164fb..ab6af72 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -338,6 +338,8 @@ struct sta_ampdu_mlme {
  *	using IEEE80211_NUM_TID entry for non-QoS frames
  * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
  *	entry for non-QoS frames
+ * @low_ack_threshold: Number of consecutive packet loss to trigger low ack
+ *	event by driver.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -459,6 +461,7 @@ struct sta_info {
 	unsigned long last_tdls_pkt_time;
 
 	u8 reserved_tid;
+	u16 low_ack_threshold;
 
 	/* keep last! */
 	struct ieee80211_sta sta;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 005fdbe..f78f8f1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -520,7 +520,6 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
  *  - on # of retransmissions
  *  - current throughput (higher value for higher tpt)?
  */
-#define STA_LOST_PKT_THRESHOLD	50
 #define STA_LOST_TDLS_PKT_THRESHOLD	10
 #define STA_LOST_TDLS_PKT_TIME		(10*HZ) /* 10secs since last ACK */
 
@@ -533,7 +532,8 @@ static void ieee80211_lost_packet(struct sta_info *sta,
 		return;
 
 	sta->lost_packets++;
-	if (!sta->sta.tdls && sta->lost_packets < STA_LOST_PKT_THRESHOLD)
+	if (!sta->sta.tdls &&
+	    sta->lost_packets < sta->low_ack_threshold)
 		return;
 
 	/*
-- 
2.4.1

