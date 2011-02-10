Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60102 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab1BJPaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 10:30:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/2] cfg80211: add a field for the bitrate of the last rx data packet from a station
Date: Thu, 10 Feb 2011 16:29:56 +0100
Message-Id: <1297351797-35031-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also fix a typo in the STATION_INFO_TX_BITRATE description

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/nl80211.h |    3 ++
 include/net/cfg80211.h  |    5 +++-
 net/wireless/nl80211.c  |   56 +++++++++++++++++++++++++++++++----------------
 3 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 821ffb9..35bfec2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1243,6 +1243,8 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_LLID: the station's mesh LLID
  * @NL80211_STA_INFO_PLID: the station's mesh PLID
  * @NL80211_STA_INFO_PLINK_STATE: peer link state for the station
+ * @NL80211_STA_INFO_RX_BITRATE: last unicast rx rate, nested attribute
+ * 	containing info as possible, see &enum nl80211_sta_info_txrate.
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1261,6 +1263,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TX_RETRIES,
 	NL80211_STA_INFO_TX_FAILED,
 	NL80211_STA_INFO_SIGNAL_AVG,
+	NL80211_STA_INFO_RX_BITRATE,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 679a049..1ac5786 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -413,7 +413,7 @@ struct station_parameters {
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
  * @STATION_INFO_SIGNAL: @signal filled
- * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
+ * @STATION_INFO_TX_BITRATE: @txrate fields are filled
  *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  * @STATION_INFO_RX_PACKETS: @rx_packets filled
  * @STATION_INFO_TX_PACKETS: @tx_packets filled
@@ -421,6 +421,7 @@ struct station_parameters {
  * @STATION_INFO_TX_FAILED: @tx_failed filled
  * @STATION_INFO_RX_DROP_MISC: @rx_dropped_misc filled
  * @STATION_INFO_SIGNAL_AVG: @signal_avg filled
+ * @STATION_INFO_RX_BITRATE: @rxrate fields are filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -437,6 +438,7 @@ enum station_info_flags {
 	STATION_INFO_TX_FAILED		= 1<<11,
 	STATION_INFO_RX_DROP_MISC	= 1<<12,
 	STATION_INFO_SIGNAL_AVG		= 1<<13,
+	STATION_INFO_RX_BITRATE		= 1<<14,
 };
 
 /**
@@ -506,6 +508,7 @@ struct station_info {
 	s8 signal;
 	s8 signal_avg;
 	struct rate_info txrate;
+	struct rate_info rxrate;
 	u32 rx_packets;
 	u32 tx_packets;
 	u32 tx_retries;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 864ddfb..4ebce42 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1968,13 +1968,41 @@ static int parse_station_flags(struct genl_info *info,
 	return 0;
 }
 
+static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
+				 int attr)
+{
+	struct nlattr *rate;
+	u16 bitrate;
+
+	rate = nla_nest_start(msg, attr);
+	if (!rate)
+		goto nla_put_failure;
+
+	/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
+	bitrate = cfg80211_calculate_bitrate(info);
+	if (bitrate > 0)
+		NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
+
+	if (info->flags & RATE_INFO_FLAGS_MCS)
+		NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS, info->mcs);
+	if (info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
+		NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
+	if (info->flags & RATE_INFO_FLAGS_SHORT_GI)
+		NLA_PUT_FLAG(msg, NL80211_RATE_INFO_SHORT_GI);
+
+	nla_nest_end(msg, rate);
+	return true;
+
+nla_put_failure:
+	return false;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				const u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
-	struct nlattr *sinfoattr, *txrate;
-	u16 bitrate;
+	struct nlattr *sinfoattr;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -2013,24 +2041,14 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL_AVG,
 			   sinfo->signal_avg);
 	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
-		txrate = nla_nest_start(msg, NL80211_STA_INFO_TX_BITRATE);
-		if (!txrate)
+		if (!nl80211_put_sta_rate(msg, &sinfo->txrate,
+					  NL80211_STA_INFO_TX_BITRATE))
+			goto nla_put_failure;
+	}
+	if (sinfo->filled & STATION_INFO_RX_BITRATE) {
+		if (!nl80211_put_sta_rate(msg, &sinfo->rxrate,
+					  NL80211_STA_INFO_RX_BITRATE))
 			goto nla_put_failure;
-
-		/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
-		bitrate = cfg80211_calculate_bitrate(&sinfo->txrate);
-		if (bitrate > 0)
-			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
-
-		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
-			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
-				    sinfo->txrate.mcs);
-		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
-			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
-		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)
-			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_SHORT_GI);
-
-		nla_nest_end(msg, txrate);
 	}
 	if (sinfo->filled & STATION_INFO_RX_PACKETS)
 		NLA_PUT_U32(msg, NL80211_STA_INFO_RX_PACKETS,
-- 
1.7.3.2

