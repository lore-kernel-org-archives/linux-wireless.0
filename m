Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36830 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLQN6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/9] cfg80211: add nl80211 beacon-only statistics
Date: Wed, 17 Dec 2014 14:57:58 +0100
Message-Id: <1418824679-31530-9-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145817_438802_F7875A51)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add these two values:
 * BEACON_RX: number of beacons received from this peer
 * BEACON_SIGNAL_AVG: signal strength average for beacons only

These can then be used for Android Lollipop's statistics request.

Change-Id: Idab5309c15858c525b01b0202361faf93ea93fa8
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 6 ++++++
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/nl80211.c       | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4f5aa80edcf1..1c77d02efc06 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -986,6 +986,9 @@ struct sta_bss_parameters {
  * @nonpeer_pm: non-peer mesh STA power save mode
  * @expected_throughput: expected throughput in kbps (including 802.11 headers)
  *	towards this station.
+ * @rx_beacon: number of beacons received from this peer
+ * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
+ *	from this peer
  */
 struct station_info {
 	u32 filled;
@@ -1025,6 +1028,9 @@ struct station_info {
 	enum nl80211_mesh_power_mode nonpeer_pm;
 
 	u32 expected_throughput;
+
+	u64 rx_beacon;
+	u8 rx_beacon_signal_avg;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c747657b035a..b1b00164de9a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2356,6 +2356,9 @@ enum nl80211_sta_bss_param {
  *	802.11 header (u32, kbps)
  * @NL80211_STA_INFO_RX_DROP_MISC: RX packets dropped for unspecified reasons
  *	(u64)
+ * @NL80211_STA_INFO_BEACON_RX: number of beacons received from this peer (u64)
+ * @NL80211_STA_INFO_BEACON_SIGNAL_AVG: signal strength average
+ *	for beacons only (u8, dBm)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2389,6 +2392,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CHAIN_SIGNAL_AVG,
 	NL80211_STA_INFO_EXPECTED_THROUGHPUT,
 	NL80211_STA_INFO_RX_DROP_MISC,
+	NL80211_STA_INFO_BEACON_RX,
+	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 906f9384a7cf..d7e21a27aef3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3763,6 +3763,8 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	PUT_SINFO(T_OFFSET, t_offset, u64);
 	PUT_SINFO(RX_DROP_MISC, rx_dropped_misc, u64);
+	PUT_SINFO(BEACON_RX, rx_beacon, u64);
+	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
 
 #undef PUT_SINFO
 	nla_nest_end(msg, sinfoattr);
-- 
2.1.1

