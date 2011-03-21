Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1CUViP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:38:15 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p2LLcDAH031517
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:14 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz21.hot.corp.google.com with ESMTP id p2LLcCYl023055
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:13 -0700
From: Paul Stewart <pstew@google.com>
Date: Mon, 21 Mar 2011 14:14:25 -0700
Subject: [PATCH 1/4] nl80211: Add station info flags and intervals
To: linux-wireless@vger.kernel.org
Message-Id: <20110321213812.A142420DA9@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Paul Stewart <pstew@google.com>
---
 include/linux/nl80211.h |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3002218..16eea72 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1222,6 +1222,36 @@ enum nl80211_rate_info {
 };
 
 /**
+ * enum nl80211_sta_bss_param - BSS information collected by STA
+ *
+ * These attribute types are used with %NL80211_STA_INFO_BSS_PARAM
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_STA_BSS_PARAM_INVALID: attribute number 0 is reserved
+ * @NL80211_STA_BSS_PARAM_CTS_PROT: whether CTS protection is enabled (flag)
+ * @NL80211_STA_BSS_PARAM_SHORT_PREAMBLE:  whether short preamble is enabled
+ *	(flag)
+ * @NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME:  whether short slot time is enabled
+ *	(flag)
+ * @NL80211_STA_BSS_PARAM_DTIM_PERIOD: DTIM period for beaconing (u8)
+ * @NL80211_STA_BSS_PARAM_BEACON_INTERVAL: Beacon interval (u16)
+ * @NL80211_STA_BSS_PARAM_MAX: highest sta_bss_param number currently defined
+ * @__NL80211_STA_BSS_PARAM_AFTER_LAST: internal use
+ */
+enum nl80211_sta_bss_param {
+	__NL80211_STA_BSS_PARAM_INVALID,
+	NL80211_STA_BSS_PARAM_CTS_PROT,
+	NL80211_STA_BSS_PARAM_SHORT_PREAMBLE,
+	NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME,
+	NL80211_STA_BSS_PARAM_DTIM_PERIOD,
+	NL80211_STA_BSS_PARAM_BEACON_INTERVAL,
+
+	/* keep last */
+	__NL80211_STA_BSS_PARAM_AFTER_LAST,
+	NL80211_STA_BSS_PARAM_MAX = __NL80211_STA_BSS_PARAM_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_sta_info - station information
  *
  * These attribute types are used with %NL80211_ATTR_STA_INFO
@@ -1233,7 +1263,7 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
- * 	containing info as possible, see &enum nl80211_sta_info_txrate.
+ * 	containing info as possible, see &enum nl80211_rate_info
  * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
  * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
  *	station)
@@ -1245,6 +1275,8 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_PLINK_STATE: peer link state for the station
  * @NL80211_STA_INFO_RX_BITRATE: last unicast data frame rx rate, nested
  *	attribute, like NL80211_STA_INFO_TX_BITRATE.
+ * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
+ *     containing info as possible, see &enum nl80211_sta_bss_param
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1264,6 +1296,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TX_FAILED,
 	NL80211_STA_INFO_SIGNAL_AVG,
 	NL80211_STA_INFO_RX_BITRATE,
+	NL80211_STA_INFO_BSS_PARAM,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
-- 
1.7.3.1

