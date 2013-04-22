Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53673 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab3DVO3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 1/2] cfg80211: add support for per-chain signal strength reporting
Date: Mon, 22 Apr 2013 16:29:30 +0200
Message-Id: <1366640971-12872-1-git-send-email-nbd@openwrt.org> (sfid-20130422_164957_842188_FC533599)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h       | 14 ++++++++++++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dff96d8..0c51500 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -753,6 +753,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  * @STATION_INFO_LOCAL_PM: @local_pm filled
  * @STATION_INFO_PEER_PM: @peer_pm filled
  * @STATION_INFO_NONPEER_PM: @nonpeer_pm filled
+ * @STATION_INFO_CHAIN_SIGNAL: @chain_signal filled
+ * @STATION_INFO_CHAIN_SIGNAL_AVG: @chain_signal_avg filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -781,6 +783,8 @@ enum station_info_flags {
 	STATION_INFO_NONPEER_PM		= 1<<23,
 	STATION_INFO_RX_BYTES64		= 1<<24,
 	STATION_INFO_TX_BYTES64		= 1<<25,
+	STATION_INFO_CHAIN_SIGNAL	= 1<<26,
+	STATION_INFO_CHAIN_SIGNAL_AVG	= 1<<27,
 };
 
 /**
@@ -857,6 +861,8 @@ struct sta_bss_parameters {
 	u16 beacon_interval;
 };
 
+#define IEEE80211_MAX_CHAINS	4
+
 /**
  * struct station_info - station information
  *
@@ -874,6 +880,9 @@ struct sta_bss_parameters {
  *	For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
  * @signal_avg: Average signal strength, type depends on the wiphy's signal_type.
  *	For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
+ * @chains: bitmask for filled values in @chain_signal, @chain_signal_avg
+ * @chain_signal: per-chain signal strength of last received packet in dBm
+ * @chain_signal_avg: per-chain signal strength average in dBm
  * @txrate: current unicast bitrate from this station
  * @rxrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
@@ -909,6 +918,11 @@ struct station_info {
 	u8 plink_state;
 	s8 signal;
 	s8 signal_avg;
+
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
+	s8 chain_signal_avg[IEEE80211_MAX_CHAINS];
+
 	struct rate_info txrate;
 	struct rate_info rxrate;
 	u32 rx_packets;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 79da871..2f9c380 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1973,6 +1973,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_PEER_PM: peer mesh STA link-specific power mode
  * @NL80211_STA_INFO_NONPEER_PM: neighbor mesh STA power save mode towards
  *	non-peer STA
+ * @NL80211_STA_INFO_CHAIN_SIGNAL: per-chain signal strength of last PPDU
+ *	Contains a nested array of signal strength attributes (u8, dBm)
+ * @NL80211_STA_INFO_CHAIN_SIGNAL_AVG: per-chain signal strength average
+ *	Same format as NL80211_STA_INFO_CHAIN_SIGNAL.
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2002,6 +2006,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_NONPEER_PM,
 	NL80211_STA_INFO_RX_BYTES64,
 	NL80211_STA_INFO_TX_BYTES64,
+	NL80211_STA_INFO_CHAIN_SIGNAL,
+	NL80211_STA_INFO_CHAIN_SIGNAL_AVG,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 671b69a..c09a84e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3365,6 +3365,32 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 	return true;
 }
 
+static bool nl80211_put_signal(struct sk_buff *msg, u8 mask, s8 *signal,
+			       int id)
+{
+	void *attr;
+	int i = 0;
+
+	if (!mask)
+		return true;
+
+	attr = nla_nest_start(msg, id);
+	if (!attr)
+		return false;
+
+	for (i = 0; i < IEEE80211_MAX_CHAINS; i++) {
+		if (!(mask & BIT(i)))
+			continue;
+
+		if (nla_put_u8(msg, i, signal[i]))
+			return false;
+	}
+
+	nla_nest_end(msg, attr);
+
+	return true;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 				int flags,
 				struct cfg80211_registered_device *rdev,
@@ -3436,6 +3462,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 	default:
 		break;
 	}
+	if (sinfo->filled & STATION_INFO_CHAIN_SIGNAL) {
+		if (!nl80211_put_signal(msg, sinfo->chains,
+					sinfo->chain_signal,
+					NL80211_STA_INFO_CHAIN_SIGNAL))
+			goto nla_put_failure;
+	}
+	if (sinfo->filled & STATION_INFO_CHAIN_SIGNAL_AVG) {
+		if (!nl80211_put_signal(msg, sinfo->chains,
+					sinfo->chain_signal_avg,
+					NL80211_STA_INFO_CHAIN_SIGNAL_AVG))
+			goto nla_put_failure;
+	}
 	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->txrate,
 					  NL80211_STA_INFO_TX_BITRATE))
-- 
1.8.0.2

