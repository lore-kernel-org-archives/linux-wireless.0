Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:3989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab1CaQaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:30:07 -0400
Message-Id: <93050f66a5b9e4b9dd27f8ba80add6b8d33310cc.1301588873.git.pstew@chromium.org>
From: Paul Stewart <pstew@chromium.org>
Date: Thu, 31 Mar 2011 09:25:41 -0700
Subject: [PATCH] nl80211: Add BSS parameters to station (resend)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user-space monitoring of BSS parameters for the associated
station.  This is useful for debugging and verifying that the paramaters
are as expected.

[Exactly the same as before but bundled into a single message]

Signed-off-by: Paul Stewart <pstew@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   35 ++++++++++++++++++++++++++++++++++-
 include/net/cfg80211.h  |   34 ++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c      |   13 ++++++++++++-
 net/wireless/nl80211.c  |   21 ++++++++++++++++++++-
 4 files changed, 100 insertions(+), 3 deletions(-)

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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2c45304..ba7384a 100644
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
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3342135..bf5d28d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -342,7 +342,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			STATION_INFO_TX_FAILED |
 			STATION_INFO_TX_BITRATE |
 			STATION_INFO_RX_BITRATE |
-			STATION_INFO_RX_DROP_MISC;
+			STATION_INFO_RX_DROP_MISC |
+			STATION_INFO_BSS_PARAM;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes = sta->rx_bytes;
@@ -389,6 +390,16 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->plink_state = sta->plink_state;
 #endif
 	}
+
+	sinfo->bss_param.flags = 0;
+	if (sdata->vif.bss_conf.use_cts_prot)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+	if (sdata->vif.bss_conf.use_short_preamble)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+	if (sdata->vif.bss_conf.use_short_slot)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
+	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
 }
 
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 40c90fb..297d7ce 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2002,7 +2002,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				const u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
-	struct nlattr *sinfoattr;
+	struct nlattr *sinfoattr, *bss_param;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -2062,6 +2062,25 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_TX_FAILED)
 		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_FAILED,
 			    sinfo->tx_failed);
+	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
+		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
+		if (!bss_param)
+			goto nla_put_failure;
+
+		if (sinfo->bss_param.flags & BSS_PARAM_FLAGS_CTS_PROT)
+			NLA_PUT_FLAG(msg, NL80211_STA_BSS_PARAM_CTS_PROT);
+		if (sinfo->bss_param.flags & BSS_PARAM_FLAGS_SHORT_PREAMBLE)
+			NLA_PUT_FLAG(msg, NL80211_STA_BSS_PARAM_SHORT_PREAMBLE);
+		if (sinfo->bss_param.flags & BSS_PARAM_FLAGS_SHORT_SLOT_TIME)
+			NLA_PUT_FLAG(msg,
+				     NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME);
+		NLA_PUT_U8(msg, NL80211_STA_BSS_PARAM_DTIM_PERIOD,
+			   sinfo->bss_param.dtim_period);
+		NLA_PUT_U16(msg, NL80211_STA_BSS_PARAM_BEACON_INTERVAL,
+			    sinfo->bss_param.beacon_interval);
+
+		nla_nest_end(msg, bss_param);
+	}
 	nla_nest_end(msg, sinfoattr);
 
 	return genlmsg_end(msg, hdr);
-- 
1.7.3.1

