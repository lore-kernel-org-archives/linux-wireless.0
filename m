Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:43934 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaC3Ufj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 16:35:39 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFCv2 1/6] cfg80211: export expected throughput through get_station()
Date: Sun, 30 Mar 2014 22:34:59 +0200
Message-Id: <1396211704-4677-2-git-send-email-antonio@meshcoding.com> (sfid-20140330_223552_003623_B91E41E0)
In-Reply-To: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Users may need information about the expected throughput
towards a given peer computed by the RC algorithm.
Export such value through the get_station() API.

This information is useful to the batman-adv module which
will use it for its new metric computation.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/cfg80211.h | 63 ++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fb8afce..4c8ebe9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -862,36 +862,38 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  * @STATION_INFO_NONPEER_PM: @nonpeer_pm filled
  * @STATION_INFO_CHAIN_SIGNAL: @chain_signal filled
  * @STATION_INFO_CHAIN_SIGNAL_AVG: @chain_signal_avg filled
+ * @STATION_INFO_EXPECTED_THROUGHPUT: @expected_throughput filled
  */
 enum station_info_flags {
-	STATION_INFO_INACTIVE_TIME	= 1<<0,
-	STATION_INFO_RX_BYTES		= 1<<1,
-	STATION_INFO_TX_BYTES		= 1<<2,
-	STATION_INFO_LLID		= 1<<3,
-	STATION_INFO_PLID		= 1<<4,
-	STATION_INFO_PLINK_STATE	= 1<<5,
-	STATION_INFO_SIGNAL		= 1<<6,
-	STATION_INFO_TX_BITRATE		= 1<<7,
-	STATION_INFO_RX_PACKETS		= 1<<8,
-	STATION_INFO_TX_PACKETS		= 1<<9,
-	STATION_INFO_TX_RETRIES		= 1<<10,
-	STATION_INFO_TX_FAILED		= 1<<11,
-	STATION_INFO_RX_DROP_MISC	= 1<<12,
-	STATION_INFO_SIGNAL_AVG		= 1<<13,
-	STATION_INFO_RX_BITRATE		= 1<<14,
-	STATION_INFO_BSS_PARAM          = 1<<15,
-	STATION_INFO_CONNECTED_TIME	= 1<<16,
-	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
-	STATION_INFO_STA_FLAGS		= 1<<18,
-	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
-	STATION_INFO_T_OFFSET		= 1<<20,
-	STATION_INFO_LOCAL_PM		= 1<<21,
-	STATION_INFO_PEER_PM		= 1<<22,
-	STATION_INFO_NONPEER_PM		= 1<<23,
-	STATION_INFO_RX_BYTES64		= 1<<24,
-	STATION_INFO_TX_BYTES64		= 1<<25,
-	STATION_INFO_CHAIN_SIGNAL	= 1<<26,
-	STATION_INFO_CHAIN_SIGNAL_AVG	= 1<<27,
+	STATION_INFO_INACTIVE_TIME		= 1<<0,
+	STATION_INFO_RX_BYTES			= 1<<1,
+	STATION_INFO_TX_BYTES			= 1<<2,
+	STATION_INFO_LLID			= 1<<3,
+	STATION_INFO_PLID			= 1<<4,
+	STATION_INFO_PLINK_STATE		= 1<<5,
+	STATION_INFO_SIGNAL			= 1<<6,
+	STATION_INFO_TX_BITRATE			= 1<<7,
+	STATION_INFO_RX_PACKETS			= 1<<8,
+	STATION_INFO_TX_PACKETS			= 1<<9,
+	STATION_INFO_TX_RETRIES			= 1<<10,
+	STATION_INFO_TX_FAILED			= 1<<11,
+	STATION_INFO_RX_DROP_MISC		= 1<<12,
+	STATION_INFO_SIGNAL_AVG			= 1<<13,
+	STATION_INFO_RX_BITRATE			= 1<<14,
+	STATION_INFO_BSS_PARAM			= 1<<15,
+	STATION_INFO_CONNECTED_TIME		= 1<<16,
+	STATION_INFO_ASSOC_REQ_IES		= 1<<17,
+	STATION_INFO_STA_FLAGS			= 1<<18,
+	STATION_INFO_BEACON_LOSS_COUNT		= 1<<19,
+	STATION_INFO_T_OFFSET			= 1<<20,
+	STATION_INFO_LOCAL_PM			= 1<<21,
+	STATION_INFO_PEER_PM			= 1<<22,
+	STATION_INFO_NONPEER_PM			= 1<<23,
+	STATION_INFO_RX_BYTES64			= 1<<24,
+	STATION_INFO_TX_BYTES64			= 1<<25,
+	STATION_INFO_CHAIN_SIGNAL		= 1<<26,
+	STATION_INFO_CHAIN_SIGNAL_AVG		= 1<<27,
+	STATION_INFO_EXPECTED_THROUGHPUT	= 1<<28,
 };
 
 /**
@@ -1013,6 +1015,9 @@ struct sta_bss_parameters {
  * @local_pm: local mesh STA power save mode
  * @peer_pm: peer mesh STA power save mode
  * @nonpeer_pm: non-peer mesh STA power save mode
+ * @expected_throughput: expected throughput as reported by the RC algorithm
+ *  about the bitrate having the maximum throughput. This field can be filled
+ *  only by drivers using Minstrel
  */
 struct station_info {
 	u32 filled;
@@ -1051,6 +1056,8 @@ struct station_info {
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
 
+	u32 expected_throughput;
+
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
 	 * use it to check which fields are initialized.
-- 
1.8.3.2

