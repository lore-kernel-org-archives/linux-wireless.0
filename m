Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr40091.outbound.protection.outlook.com ([40.107.4.91]:41056
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754837AbeFNKLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 06:11:10 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH v2 1/5] cfg80211: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Thu, 14 Jun 2018 13:11:03 +0300
Message-Id: <1528971063-32764-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121121_151470_A6E7ECB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with NL80211_STA_INFO_* attribute types instead of BIT.

The BIT macro uses unsigned long type which some architectures handle as 32bit
and this results in compilation warnings such as:

net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
  sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
  ^

Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
---
 net/wireless/nl80211.c     | 22 +++++++++++-----------
 net/wireless/wext-compat.c | 10 +++++-----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07514ca..abe838f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4561,14 +4561,14 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
 	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
 
-	if (sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES) |
-			     BIT(NL80211_STA_INFO_RX_BYTES64)) &&
+	if (sinfo->filled & (BIT_ULL(NL80211_STA_INFO_RX_BYTES) |
+			     BIT_ULL(NL80211_STA_INFO_RX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
 			(u32)sinfo->rx_bytes))
 		goto nla_put_failure;
 
-	if (sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES) |
-			     BIT(NL80211_STA_INFO_TX_BYTES64)) &&
+	if (sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES) |
+			     BIT_ULL(NL80211_STA_INFO_TX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
 			(u32)sinfo->tx_bytes))
 		goto nla_put_failure;
@@ -4588,24 +4588,24 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	default:
 		break;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_CHAIN_SIGNAL)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL)) {
 		if (!nl80211_put_signal(msg, sinfo->chains,
 					sinfo->chain_signal,
 					NL80211_STA_INFO_CHAIN_SIGNAL))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)) {
 		if (!nl80211_put_signal(msg, sinfo->chains,
 					sinfo->chain_signal_avg,
 					NL80211_STA_INFO_CHAIN_SIGNAL_AVG))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->txrate,
 					  NL80211_STA_INFO_TX_BITRATE))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_BITRATE)) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->rxrate,
 					  NL80211_STA_INFO_RX_BITRATE))
 			goto nla_put_failure;
@@ -4621,7 +4621,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(PEER_PM, peer_pm, u32);
 	PUT_SINFO(NONPEER_PM, nonpeer_pm, u32);
 
-	if (sinfo->filled & BIT(NL80211_STA_INFO_BSS_PARAM)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_BSS_PARAM)) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
 			goto nla_put_failure;
@@ -4640,7 +4640,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 
 		nla_nest_end(msg, bss_param);
 	}
-	if ((sinfo->filled & BIT(NL80211_STA_INFO_STA_FLAGS)) &&
+	if ((sinfo->filled & BIT_ULL(NL80211_STA_INFO_STA_FLAGS)) &&
 	    nla_put(msg, NL80211_STA_INFO_STA_FLAGS,
 		    sizeof(struct nl80211_sta_flag_update),
 		    &sinfo->sta_flags))
@@ -10160,7 +10160,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 		if (err)
 			return err;
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
 			wdev->cqm_config->last_rssi_event_value =
 				(s8) sinfo.rx_beacon_signal_avg;
 	}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 05186a4..167f702 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1278,7 +1278,7 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 	if (err)
 		return err;
 
-	if (!(sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE)))
+	if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
 		return -EOPNOTSUPP;
 
 	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
@@ -1320,7 +1320,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			int sig = sinfo.signal;
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
@@ -1334,7 +1334,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			break;
 		}
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
 			wstats.qual.level = sinfo.signal;
@@ -1347,9 +1347,9 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	}
 
 	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
-	if (sinfo.filled & BIT(NL80211_STA_INFO_RX_DROP_MISC))
+	if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC))
 		wstats.discard.misc = sinfo.rx_dropped_misc;
-	if (sinfo.filled & BIT(NL80211_STA_INFO_TX_FAILED))
+	if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_FAILED))
 		wstats.discard.retries = sinfo.tx_failed;
 
 	return &wstats;
-- 
2.7.4
