Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:41323 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752869AbbCMMRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 08:17:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Mar 2015 14:17:06 +0200
Message-Id: <1426249027-22165-2-git-send-email-luca@coelho.fi> (sfid-20150313_131726_702652_1575ACC6)
In-Reply-To: <1426249027-22165-1-git-send-email-luca@coelho.fi>
References: <1426249027-22165-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw 1/2] update nl80211.h
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 nl80211.h | 207 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 176 insertions(+), 31 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index c0383e9..ae16ba9 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -25,10 +25,30 @@
  *
  */
 
+/*
+ * This header file defines the userspace API to the wireless stack. Please
+ * be careful not to break things - i.e. don't move anything around or so
+ * unless you can demonstrate that it breaks neither API nor ABI.
+ *
+ * Additions to the API should be accompanied by actual implementations in
+ * an upstream driver, so that example implementations exist in case there
+ * are ever concerns about the precise semantics of the API or changes are
+ * needed, and to ensure that code for dead (no longer implemented) API
+ * can actually be identified and removed.
+ * Nonetheless, semantics should also be documented carefully in this file.
+ */
+
 #include <linux/types.h>
 
 #define NL80211_GENL_NAME "nl80211"
 
+#define NL80211_MULTICAST_GROUP_CONFIG		"config"
+#define NL80211_MULTICAST_GROUP_SCAN		"scan"
+#define NL80211_MULTICAST_GROUP_REG		"regulatory"
+#define NL80211_MULTICAST_GROUP_MLME		"mlme"
+#define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
+#define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
+
 /**
  * DOC: Station handling
  *
@@ -173,8 +193,8 @@
  *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME.
  *
  * @NL80211_CMD_GET_INTERFACE: Request an interface's configuration;
- *	either a dump request on a %NL80211_ATTR_WIPHY or a specific get
- *	on an %NL80211_ATTR_IFINDEX is supported.
+ *	either a dump request for all interfaces or a specific get with a
+ *	single %NL80211_ATTR_IFINDEX is supported.
  * @NL80211_CMD_SET_INTERFACE: Set type of a virtual interface, requires
  *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_IFTYPE.
  * @NL80211_CMD_NEW_INTERFACE: Newly created virtual interface or response
@@ -317,7 +337,9 @@
  *	if passed, define which channels should be scanned; if not
  *	passed, all channels allowed for the current regulatory domain
  *	are used.  Extra IEs can also be passed from the userspace by
- *	using the %NL80211_ATTR_IE attribute.
+ *	using the %NL80211_ATTR_IE attribute.  The first cycle of the
+ *	scheduled scan can be delayed by %NL80211_ATTR_SCHED_SCAN_DELAY
+ *	is supplied.
  * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan. Returns -ENOENT if
  *	scheduled scan is not running. The caller may assume that as soon
  *	as the call returns, it is safe to start a new scheduled scan again.
@@ -1675,6 +1697,10 @@ enum nl80211_commands {
  *	If set during scheduled scan start then the new scan req will be
  *	owned by the netlink socket that created it and the scheduled scan will
  *	be stopped when the socket is closed.
+ *	If set during configuration of regulatory indoor operation then the
+ *	regulatory indoor configuration would be owned by the netlink socket
+ *	that configured the indoor setting, and the indoor operation would be
+ *	cleared when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
@@ -1713,6 +1739,27 @@ enum nl80211_commands {
  *	obtained from it is coming from the device's wiphy and not the global
  *	cfg80211 regdomain.
  *
+ * @NL80211_ATTR_EXT_FEATURES: extended feature flags contained in a byte
+ *	array. The feature flags are identified by their bit index (see &enum
+ *	nl80211_ext_feature_index). The bit index is ordered starting at the
+ *	least-significant bit of the first byte in the array, ie. bit index 0
+ *	is located at bit 0 of byte 0. bit index 25 would be located at bit 1
+ *	of byte 3 (u8 array).
+ *
+ * @NL80211_ATTR_SURVEY_RADIO_STATS: Request overall radio statistics to be
+ *	returned along with other survey data. If set, @NL80211_CMD_GET_SURVEY
+ *	may return a survey entry without a channel indicating global radio
+ *	statistics (only some values are valid and make sense.)
+ *	For devices that don't return such an entry even then, the information
+ *	should be contained in the result as the sum of the respective counters
+ *	over all channels.
+ *
+ * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
+ *	WoWLAN net-detect scan) is started, u32 in seconds.
+
+ * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
+ *      is operating in an indoor environment.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2072,6 +2119,16 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
 
+	NL80211_ATTR_EXT_FEATURES,
+
+	NL80211_ATTR_SURVEY_RADIO_STATS,
+
+	NL80211_ATTR_NETNS_FD,
+
+	NL80211_ATTR_SCHED_SCAN_DELAY,
+
+	NL80211_ATTR_REG_INDOOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2112,7 +2169,7 @@ enum nl80211_attrs {
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
-#define NL80211_MAX_SUPP_REG_RULES		32
+#define NL80211_MAX_SUPP_REG_RULES		64
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
@@ -2252,8 +2309,15 @@ struct nl80211_sta_flag_update {
  * @NL80211_RATE_INFO_VHT_MCS: MCS index for VHT (u8)
  * @NL80211_RATE_INFO_VHT_NSS: number of streams in VHT (u8)
  * @NL80211_RATE_INFO_80_MHZ_WIDTH: 80 MHz VHT rate
- * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: 80+80 MHz VHT rate
+ * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: unused - 80+80 is treated the
+ *	same as 160 for purposes of the bitrates
  * @NL80211_RATE_INFO_160_MHZ_WIDTH: 160 MHz VHT rate
+ * @NL80211_RATE_INFO_10_MHZ_WIDTH: 10 MHz width - note that this is
+ *	a legacy rate and will be reported as the actual bitrate, i.e.
+ *	half the base (20 MHz) rate
+ * @NL80211_RATE_INFO_5_MHZ_WIDTH: 5 MHz width - note that this is
+ *	a legacy rate and will be reported as the actual bitrate, i.e.
+ *	a quarter of the base (20 MHz) rate
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
 enum nl80211_rate_info {
@@ -2268,6 +2332,8 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_80_MHZ_WIDTH,
 	NL80211_RATE_INFO_80P80_MHZ_WIDTH,
 	NL80211_RATE_INFO_160_MHZ_WIDTH,
+	NL80211_RATE_INFO_10_MHZ_WIDTH,
+	NL80211_RATE_INFO_5_MHZ_WIDTH,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
@@ -2312,18 +2378,24 @@ enum nl80211_sta_bss_param {
  *
  * @__NL80211_STA_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
- * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
- * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
- * @NL80211_STA_INFO_RX_BYTES64: total received bytes (u64, from this station)
- * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (u64, to this station)
+ * @NL80211_STA_INFO_RX_BYTES: total received bytes (MPDU length)
+ *	(u32, from this station)
+ * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (MPDU length)
+ *	(u32, to this station)
+ * @NL80211_STA_INFO_RX_BYTES64: total received bytes (MPDU length)
+ *	(u64, from this station)
+ * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (MPDU length)
+ *	(u64, to this station)
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_rate_info
- * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
- * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
- *	station)
- * @NL80211_STA_INFO_TX_RETRIES: total retries (u32, to this station)
- * @NL80211_STA_INFO_TX_FAILED: total failed packets (u32, to this station)
+ * @NL80211_STA_INFO_RX_PACKETS: total received packet (MSDUs and MMPDUs)
+ *	(u32, from this station)
+ * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (MSDUs and MMPDUs)
+ *	(u32, to this station)
+ * @NL80211_STA_INFO_TX_RETRIES: total retries (MPDUs) (u32, to this station)
+ * @NL80211_STA_INFO_TX_FAILED: total failed packets (MPDUs)
+ *	(u32, to this station)
  * @NL80211_STA_INFO_SIGNAL_AVG: signal strength average (u8, dBm)
  * @NL80211_STA_INFO_LLID: the station's mesh LLID
  * @NL80211_STA_INFO_PLID: the station's mesh PLID
@@ -2347,6 +2419,16 @@ enum nl80211_sta_bss_param {
  *	Same format as NL80211_STA_INFO_CHAIN_SIGNAL.
  * @NL80211_STA_EXPECTED_THROUGHPUT: expected throughput considering also the
  *	802.11 header (u32, kbps)
+ * @NL80211_STA_INFO_RX_DROP_MISC: RX packets dropped for unspecified reasons
+ *	(u64)
+ * @NL80211_STA_INFO_BEACON_RX: number of beacons received from this peer (u64)
+ * @NL80211_STA_INFO_BEACON_SIGNAL_AVG: signal strength average
+ *	for beacons only (u8, dBm)
+ * @NL80211_STA_INFO_TID_STATS: per-TID statistics (see &enum nl80211_tid_stats)
+ *	This is a nested attribute where each the inner attribute number is the
+ *	TID+1 and the special TID 16 (i.e. value 17) is used for non-QoS frames;
+ *	each one of those is again nested with &enum nl80211_tid_stats
+ *	attributes carrying the actual values.
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2379,6 +2461,10 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CHAIN_SIGNAL,
 	NL80211_STA_INFO_CHAIN_SIGNAL_AVG,
 	NL80211_STA_INFO_EXPECTED_THROUGHPUT,
+	NL80211_STA_INFO_RX_DROP_MISC,
+	NL80211_STA_INFO_BEACON_RX,
+	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
+	NL80211_STA_INFO_TID_STATS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2386,6 +2472,31 @@ enum nl80211_sta_info {
 };
 
 /**
+ * enum nl80211_tid_stats - per TID statistics attributes
+ * @__NL80211_TID_STATS_INVALID: attribute number 0 is reserved
+ * @NL80211_TID_STATS_RX_MSDU: number of MSDUs received (u64)
+ * @NL80211_TID_STATS_TX_MSDU: number of MSDUs transmitted (or
+ *	attempted to transmit; u64)
+ * @NL80211_TID_STATS_TX_MSDU_RETRIES: number of retries for
+ *	transmitted MSDUs (not counting the first attempt; u64)
+ * @NL80211_TID_STATS_TX_MSDU_FAILED: number of failed transmitted
+ *	MSDUs (u64)
+ * @NUM_NL80211_TID_STATS: number of attributes here
+ * @NL80211_TID_STATS_MAX: highest numbered attribute here
+ */
+enum nl80211_tid_stats {
+	__NL80211_TID_STATS_INVALID,
+	NL80211_TID_STATS_RX_MSDU,
+	NL80211_TID_STATS_TX_MSDU,
+	NL80211_TID_STATS_TX_MSDU_RETRIES,
+	NL80211_TID_STATS_TX_MSDU_FAILED,
+
+	/* keep last */
+	NUM_NL80211_TID_STATS,
+	NL80211_TID_STATS_MAX = NUM_NL80211_TID_STATS - 1
+};
+
+/**
  * enum nl80211_mpath_flags - nl80211 mesh path flags
  *
  * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
@@ -2799,16 +2910,18 @@ enum nl80211_user_reg_hint_type {
  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
  * @NL80211_SURVEY_INFO_IN_USE: channel is currently being used
- * @NL80211_SURVEY_INFO_CHANNEL_TIME: amount of time (in ms) that the radio
- *	spent on this channel
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY: amount of the time the primary
+ * @NL80211_SURVEY_INFO_TIME: amount of time (in ms) that the radio
+ *	was turned on (on channel or globally)
+ * @NL80211_SURVEY_INFO_TIME_BUSY: amount of the time the primary
  *	channel was sensed busy (either due to activity or energy detect)
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY: amount of time the extension
+ * @NL80211_SURVEY_INFO_TIME_EXT_BUSY: amount of time the extension
  *	channel was sensed busy
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_RX: amount of time the radio spent
- *	receiving data
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_TX: amount of time the radio spent
- *	transmitting data
+ * @NL80211_SURVEY_INFO_TIME_RX: amount of time the radio spent
+ *	receiving data (on channel or globally)
+ * @NL80211_SURVEY_INFO_TIME_TX: amount of time the radio spent
+ *	transmitting data (on channel or globally)
+ * @NL80211_SURVEY_INFO_TIME_SCAN: time the radio spent for scan
+ *	(on this channel or globally)
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
  * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
@@ -2818,17 +2931,25 @@ enum nl80211_survey_info {
 	NL80211_SURVEY_INFO_FREQUENCY,
 	NL80211_SURVEY_INFO_NOISE,
 	NL80211_SURVEY_INFO_IN_USE,
-	NL80211_SURVEY_INFO_CHANNEL_TIME,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_RX,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_TX,
+	NL80211_SURVEY_INFO_TIME,
+	NL80211_SURVEY_INFO_TIME_BUSY,
+	NL80211_SURVEY_INFO_TIME_EXT_BUSY,
+	NL80211_SURVEY_INFO_TIME_RX,
+	NL80211_SURVEY_INFO_TIME_TX,
+	NL80211_SURVEY_INFO_TIME_SCAN,
 
 	/* keep last */
 	__NL80211_SURVEY_INFO_AFTER_LAST,
 	NL80211_SURVEY_INFO_MAX = __NL80211_SURVEY_INFO_AFTER_LAST - 1
 };
 
+/* keep old names for compatibility */
+#define NL80211_SURVEY_INFO_CHANNEL_TIME		NL80211_SURVEY_INFO_TIME
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY		NL80211_SURVEY_INFO_TIME_BUSY
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY	NL80211_SURVEY_INFO_TIME_EXT_BUSY
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_RX		NL80211_SURVEY_INFO_TIME_RX
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_TX		NL80211_SURVEY_INFO_TIME_TX
+
 /**
  * enum nl80211_mntr_flags - monitor configuration flags
  *
@@ -2993,7 +3114,8 @@ enum nl80211_mesh_power_mode {
  *
  * @NL80211_MESHCONF_PLINK_TIMEOUT: If no tx activity is seen from a STA we've
  *	established peering with for longer than this time (in seconds), then
- *	remove it from the STA's list of peers.  Default is 30 minutes.
+ *	remove it from the STA's list of peers. You may set this to 0 to disable
+ *	the removal of the STA. Default is 30 minutes.
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
@@ -3265,6 +3387,9 @@ enum nl80211_bss {
 /**
  * enum nl80211_bss_status - BSS "status"
  * @NL80211_BSS_STATUS_AUTHENTICATED: Authenticated with this BSS.
+ *	Note that this is no longer used since cfg80211 no longer
+ *	keeps track of whether or not authentication was done with
+ *	a given BSS.
  * @NL80211_BSS_STATUS_ASSOCIATED: Associated with this BSS.
  * @NL80211_BSS_STATUS_IBSS_JOINED: Joined to this IBSS.
  *
@@ -3592,6 +3717,8 @@ struct nl80211_pattern_support {
  * @NL80211_WOWLAN_TRIG_ANY: wake up on any activity, do not really put
  *	the chip into a special state -- works best with chips that have
  *	support for low-power operation already (flag)
+ *	Note that this mode is incompatible with all of the others, if
+ *	any others are even supported by the device.
  * @NL80211_WOWLAN_TRIG_DISCONNECT: wake up on disconnect, the way disconnect
  *	is detected is implementation-specific (flag)
  * @NL80211_WOWLAN_TRIG_MAGIC_PKT: wake up on magic packet (6x 0xff, followed
@@ -3648,9 +3775,12 @@ struct nl80211_pattern_support {
  * @NL80211_WOWLAN_TRIG_NET_DETECT: wake up when a configured network
  *	is detected.  This is a nested attribute that contains the
  *	same attributes used with @NL80211_CMD_START_SCHED_SCAN.  It
- *	specifies how the scan is performed (e.g. the interval and the
- *	channels to scan) as well as the scan results that will
- *	trigger a wake (i.e. the matchsets).
+ *	specifies how the scan is performed (e.g. the interval, the
+ *	channels to scan and the initial delay) as well as the scan
+ *	results that will trigger a wake (i.e. the matchsets).  This
+ *	attribute is also sent in a response to
+ *	@NL80211_CMD_GET_WIPHY, indicating the number of match sets
+ *	supported by the driver (u32).
  * @NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS: nested attribute
  *	containing an array with information about what triggered the
  *	wake up.  If no elements are present in the array, it means
@@ -4221,6 +4351,21 @@ enum nl80211_feature_flags {
 };
 
 /**
+ * enum nl80211_ext_feature_index - bit index of extended features.
+ * @NL80211_EXT_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
+ *
+ * @NUM_NL80211_EXT_FEATURES: number of extended features.
+ * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
+ */
+enum nl80211_ext_feature_index {
+	NL80211_EXT_FEATURE_VHT_IBSS,
+
+	/* add new features before the definition below */
+	NUM_NL80211_EXT_FEATURES,
+	MAX_NL80211_EXT_FEATURES = NUM_NL80211_EXT_FEATURES - 1
+};
+
+/**
  * enum nl80211_probe_resp_offload_support_attr - optional supported
  *	protocols for probe-response offloading by the driver/FW.
  *	To be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD attribute.
-- 
2.1.4

