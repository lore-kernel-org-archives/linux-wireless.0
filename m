Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:37404 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaAULLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 06:11:08 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 1/5] cfg80211: export minstrel best rate information through get_station()
Date: Tue, 21 Jan 2014 12:09:47 +0100
Message-Id: <1390302591-3352-2-git-send-email-antonio@meshcoding.com> (sfid-20140121_121112_007146_3431ABD1)
In-Reply-To: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Users may need information about the best rate used by
minstrel for a particular wireless device.
Export such rate and its success probability through the
get_station() API.

The exported information is Minstrel specific only,
therefore drivers not using such RC algorithm should not
report this data.

This information is useful to the batman-adv module which
will use it for its new metric computation.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/cfg80211.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e57bf..51d5d94 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -854,6 +854,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  * @STATION_INFO_NONPEER_PM: @nonpeer_pm filled
  * @STATION_INFO_CHAIN_SIGNAL: @chain_signal filled
  * @STATION_INFO_CHAIN_SIGNAL_AVG: @chain_signal_avg filled
+ * @STATION_INFO_MINSTREL_BEST_RATE: @minstrel_best_rate filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -884,6 +885,7 @@ enum station_info_flags {
 	STATION_INFO_TX_BYTES64		= 1<<25,
 	STATION_INFO_CHAIN_SIGNAL	= 1<<26,
 	STATION_INFO_CHAIN_SIGNAL_AVG	= 1<<27,
+	STATION_INFO_MINSTREL_BEST_RATE	= 1<<28,
 };
 
 /**
@@ -963,6 +965,16 @@ struct sta_bss_parameters {
 #define IEEE80211_MAX_CHAINS	4
 
 /**
+ * struct cfg80211_minstral_rate_info - exported minstrel rate information
+ * @bitrate: current chosen TX bitrate
+ * @prob: probability of success of this birate
+ */
+struct cfg80211_minstrel_rate_info {
+	u32 bitrate;
+	u32 prob;
+};
+
+/**
  * struct station_info - station information
  *
  * Station information filled by driver for get_station() and dump_station.
@@ -1005,6 +1017,9 @@ struct sta_bss_parameters {
  * @local_pm: local mesh STA power save mode
  * @peer_pm: peer mesh STA power save mode
  * @nonpeer_pm: non-peer mesh STA power save mode
+ * @minstrel_best_rate: information extracted from the Minstrel RC algorithm
+ *  about the bitrate having the maximum throughput. This field can be filled
+ *  only by drivers using Minstrel
  */
 struct station_info {
 	u32 filled;
@@ -1043,6 +1058,8 @@ struct station_info {
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
 
+	struct cfg80211_minstrel_rate_info minstrel_best_rate;
+
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
 	 * use it to check which fields are initialized.
-- 
1.8.5.3

