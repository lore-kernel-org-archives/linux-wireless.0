Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56123 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbbENKtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 06:49:03 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] mac80211: store low ack threshold in bss config
Date: Thu, 14 May 2015 16:17:36 +0530
Message-ID: <1431600456-10697-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150514_124917_748426_511497C8)
In-Reply-To: <1431600456-10697-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1431600456-10697-1-git-send-email-rmanohar@qti.qualcomm.com>
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
 include/net/mac80211.h | 3 +++
 net/mac80211/cfg.c     | 1 +
 net/mac80211/status.c  | 4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8e3668b..76cb0e4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -488,6 +488,8 @@ struct ieee80211_event {
  *	userspace), whereas TPC is disabled if %txpower_type is set to
  *	NL80211_TX_POWER_FIXED (use value configured from userspace)
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
+ * @low_ack_threshold: Number of consecutive packet loss to trigger low ack
+ *	event by driver.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -524,6 +526,7 @@ struct ieee80211_bss_conf {
 	int txpower;
 	enum nl80211_tx_power_setting txpower_type;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
+	u16 low_ack_threshold;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 265e427..b207e46 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -773,6 +773,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
 	sdata->vif.bss_conf.enable_beacon = true;
+	sdata->vif.bss_conf.low_ack_threshold = params->low_ack_threshold;
 
 	sdata->vif.bss_conf.ssid_len = params->ssid_len;
 	if (params->ssid_len)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 005fdbe..2a8cdac 100644
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
+	    sta->lost_packets < sta->sdata->vif.bss_conf.low_ack_threshold)
 		return;
 
 	/*
-- 
2.4.0

