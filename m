Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50677 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab1CUViP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:38:15 -0400
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com [172.25.105.78])
	by smtp-out.google.com with ESMTP id p2LLcD44002547
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:14 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by kpbe14.cbf.corp.google.com with ESMTP id p2LLcCMb022280
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:13 -0700
From: Paul Stewart <pstew@google.com>
Date: Mon, 21 Mar 2011 14:16:02 -0700
Subject: [PATCH 2/4] cfg80211: Add station info to station struct
To: linux-wireless@vger.kernel.org
Message-Id: <20110321213812.991BF1FFB0@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Paul Stewart <pstew@google.com>
---
 include/net/cfg80211.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b2b9d28..4299a38 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -422,6 +422,7 @@ struct station_parameters {
  * @STATION_INFO_RX_DROP_MISC: @rx_dropped_misc filled
  * @STATION_INFO_SIGNAL_AVG: @signal_avg filled
  * @STATION_INFO_RX_BITRATE: @rxrate fields are filled
+ * @STATION_INFO_BSS_PARAM: @bss_param filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -439,6 +440,7 @@ enum station_info_flags {
 	STATION_INFO_RX_DROP_MISC	= 1<<12,
 	STATION_INFO_SIGNAL_AVG		= 1<<13,
 	STATION_INFO_RX_BITRATE		= 1<<14,
+	STATION_INFO_BSS_PARAM          = 1<<15,
 };
 
 /**
@@ -473,6 +475,37 @@ struct rate_info {
 };
 
 /**
+ * enum station_info_rate_flags - bitrate info flags
+ *
+ * Used by the driver to indicate the specific rate transmission
+ * type for 802.11n transmissions.
+ *
+ * @BSS_PARAM_FLAGS_CTS_PROT: whether CTS protection is enabled
+ * @BSS_PARAM_FLAGS_SHORT_PREAMBLE: whether short preamble is enabled
+ * @BSS_PARAM_FLAGS_SHORT_SLOT_TIME: whether short slot time is enabled
+ */
+enum bss_param_flags {
+	BSS_PARAM_FLAGS_CTS_PROT	= 1<<0,
+	BSS_PARAM_FLAGS_SHORT_PREAMBLE	= 1<<1,
+	BSS_PARAM_FLAGS_SHORT_SLOT_TIME	= 1<<2,
+};
+
+/**
+ * struct sta_bss_parameters - BSS parameters for the attached station
+ *
+ * Information about the currently associated BSS
+ *
+ * @flags: bitflag of flags from &enum bss_param_flags
+ * @dtim_period: DTIM period for the BSS
+ * @beacon_interval: beacon interval
+ */
+struct sta_bss_parameters {
+	u8 flags;
+	u8 dtim_period;
+	u16 beacon_interval;
+};
+
+/**
  * struct station_info - station information
  *
  * Station information filled by driver for get_station() and dump_station.
@@ -515,6 +548,7 @@ struct station_info {
 	u32 tx_retries;
 	u32 tx_failed;
 	u32 rx_dropped_misc;
+	struct sta_bss_parameters bss_param;
 
 	int generation;
 };
-- 
1.7.3.1

