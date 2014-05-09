Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56112 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaEIIi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 04:38:59 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so2392861eek.23
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 01:38:57 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] crda: sync with latest nl80211.h
Date: Fri,  9 May 2014 10:38:42 +0200
Message-Id: <1399624723-9167-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140509_103910_302650_5474F2E4)
In-Reply-To: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync with latest nl80211.h wireless-testing.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 nl80211.h |  525 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 reglib.h  |    3 -
 2 files changed, 473 insertions(+), 55 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 79da871..1ba9d62 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -27,6 +27,8 @@
 
 #include <linux/types.h>
 
+#define NL80211_GENL_NAME "nl80211"
+
 /**
  * DOC: Station handling
  *
@@ -124,6 +126,31 @@
  */
 
 /**
+ * DOC: packet coalesce support
+ *
+ * In most cases, host that receives IPv4 and IPv6 multicast/broadcast
+ * packets does not do anything with these packets. Therefore the
+ * reception of these unwanted packets causes unnecessary processing
+ * and power consumption.
+ *
+ * Packet coalesce feature helps to reduce number of received interrupts
+ * to host by buffering these packets in firmware/hardware for some
+ * predefined time. Received interrupt will be generated when one of the
+ * following events occur.
+ * a) Expiration of hardware timer whose expiration time is set to maximum
+ * coalescing delay of matching coalesce rule.
+ * b) Coalescing buffer in hardware reaches it's limit.
+ * c) Packet doesn't match any of the configured coalesce rules.
+ *
+ * User needs to configure following parameters for creating a coalesce
+ * rule.
+ * a) Maximum coalescing delay
+ * b) List of packet patterns which needs to be matched
+ * c) Condition for coalescence. pattern 'match' or 'no match'
+ * Multiple such rules can be created.
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -276,8 +303,9 @@
  *	passed, all channels allowed for the current regulatory domain
  *	are used.  Extra IEs can also be passed from the userspace by
  *	using the %NL80211_ATTR_IE attribute.
- * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan.  Returns -ENOENT
- *	if scheduled scan is not running.
+ * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan. Returns -ENOENT if
+ *	scheduled scan is not running. The caller may assume that as soon
+ *	as the call returns, it is safe to start a new scheduled scan again.
  * @NL80211_CMD_SCHED_SCAN_RESULTS: indicates that there are scheduled scan
  *	results available.
  * @NL80211_CMD_SCHED_SCAN_STOPPED: indicates that the scheduled scan has
@@ -391,8 +419,18 @@
  *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
  *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_USE_MFP,
  *	%NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
- *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
- *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT, %NL80211_ATTR_MAC_HINT, and
+ *	%NL80211_ATTR_WIPHY_FREQ_HINT.
+ *	If included, %NL80211_ATTR_MAC and %NL80211_ATTR_WIPHY_FREQ are
+ *	restrictions on BSS selection, i.e., they effectively prevent roaming
+ *	within the ESS. %NL80211_ATTR_MAC_HINT and %NL80211_ATTR_WIPHY_FREQ_HINT
+ *	can be included to provide a recommendation of the initial BSS while
+ *	allowing the driver to roam to other BSSes within the ESS and also to
+ *	ignore this recommendation if the indicated BSS is not ideal. Only one
+ *	set of BSSID,frequency parameters is used (i.e., either the enforcing
+ *	%NL80211_ATTR_MAC,%NL80211_ATTR_WIPHY_FREQ or the less strict
+ *	%NL80211_ATTR_MAC_HINT and %NL80211_ATTR_WIPHY_FREQ_HINT).
  *	Background scan period can optionally be
  *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
  *	if not specified default background scan configuration
@@ -554,7 +592,14 @@
  *	operation, %NL80211_ATTR_MAC contains the peer MAC address, and
  *	%NL80211_ATTR_REASON_CODE the reason code to be used (only with
  *	%NL80211_TDLS_TEARDOWN).
- * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame. The
+ *	%NL80211_ATTR_TDLS_ACTION attribute determines the type of frame to be
+ *	sent. Public Action codes (802.11-2012 8.1.5.1) will be sent as
+ *	802.11 management frames, while TDLS action codes (802.11-2012
+ *	8.5.13.1) will be encapsulated and sent as data frames. The currently
+ *	supported Public Action code is %WLAN_PUB_ACTION_TDLS_DISCOVER_RES
+ *	and the currently supported TDLS actions codes are given in
+ *	&enum ieee80211_tdls_actioncode.
  *
  * @NL80211_CMD_UNEXPECTED_FRAME: Used by an application controlling an AP
  *	(or GO) interface (i.e. hostapd) to ask for unexpected frames to
@@ -639,6 +684,41 @@
  *	with the relevant Information Elements. This event is used to report
  *	received FT IEs (MDIE, FTIE, RSN IE, TIE, RICIE).
  *
+ * @NL80211_CMD_CRIT_PROTOCOL_START: Indicates user-space will start running
+ *	a critical protocol that needs more reliability in the connection to
+ *	complete.
+ *
+ * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
+ *	return back to normal.
+ *
+ * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
+ * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.
+ *
+ * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing the
+ *	the new channel information (Channel Switch Announcement - CSA)
+ *	in the beacon for some time (as defined in the
+ *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
+ *	new channel. Userspace provides the new channel information (using
+ *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel
+ *	width). %NL80211_ATTR_CH_SWITCH_BLOCK_TX may be supplied to inform
+ *	other station that transmission must be blocked until the channel
+ *	switch is complete.
+ *
+ * @NL80211_CMD_VENDOR: Vendor-specified command/event. The command is specified
+ *	by the %NL80211_ATTR_VENDOR_ID attribute and a sub-command in
+ *	%NL80211_ATTR_VENDOR_SUBCMD. Parameter(s) can be transported in
+ *	%NL80211_ATTR_VENDOR_DATA.
+ *	For feature advertisement, the %NL80211_ATTR_VENDOR_DATA attribute is
+ *	used in the wiphy data as a nested attribute containing descriptions
+ *	(&struct nl80211_vendor_cmd_info) of the supported vendor commands.
+ *	This may also be sent as an event with the same attributes.
+ *
+ * @NL80211_CMD_SET_QOS_MAP: Set Interworking QoS mapping for IP DSCP values.
+ *	The QoS mapping information is included in %NL80211_ATTR_QOS_MAP. If
+ *	that attribute is not included, QoS mapping is disabled. Since this
+ *	QoS mapping is relevant for IP packets, it is only valid during an
+ *	association. This is cleared on disassociation and AP restart.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -798,6 +878,18 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_FT_IES,
 	NL80211_CMD_FT_EVENT,
 
+	NL80211_CMD_CRIT_PROTOCOL_START,
+	NL80211_CMD_CRIT_PROTOCOL_STOP,
+
+	NL80211_CMD_GET_COALESCE,
+	NL80211_CMD_SET_COALESCE,
+
+	NL80211_CMD_CHANNEL_SWITCH,
+
+	NL80211_CMD_VENDOR,
+
+	NL80211_CMD_SET_QOS_MAP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -933,7 +1025,7 @@ enum nl80211_commands {
  * 	to query the CRDA to retrieve one regulatory domain. This attribute can
  * 	also be used by userspace to query the kernel for the currently set
  * 	regulatory domain. We chose an alpha2 as that is also used by the
- * 	IEEE-802.11d country information element to identify a country.
+ * 	IEEE-802.11 country information element to identify a country.
  * 	Users can also simply ask the wireless core to set regulatory domain
  * 	to a specific alpha2.
  * @NL80211_ATTR_REG_RULES: a nested array of regulatory domain regulatory
@@ -1414,6 +1506,79 @@ enum nl80211_commands {
  * @NL80211_ATTR_IE_RIC: Resource Information Container Information
  *	Element
  *
+ * @NL80211_ATTR_CRIT_PROT_ID: critical protocol identifier requiring increased
+ *	reliability, see &enum nl80211_crit_proto_id (u16).
+ * @NL80211_ATTR_MAX_CRIT_PROT_DURATION: duration in milliseconds in which
+ *      the connection should have increased reliability (u16).
+ *
+ * @NL80211_ATTR_PEER_AID: Association ID for the peer TDLS station (u16).
+ *	This is similar to @NL80211_ATTR_STA_AID but with a difference of being
+ *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
+ *	update a TDLS peer STA entry.
+ *
+ * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
+ *
+ * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number of TBTT's
+ *	until the channel switch event.
+ * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that transmission
+ *	must be blocked on the current channel (before the channel switch
+ *	operation).
+ * @NL80211_ATTR_CSA_IES: Nested set of attributes containing the IE information
+ *	for the time while performing a channel switch.
+ * @NL80211_ATTR_CSA_C_OFF_BEACON: Offset of the channel switch counter
+ *	field in the beacons tail (%NL80211_ATTR_BEACON_TAIL).
+ * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
+ *	field in the probe response (%NL80211_ATTR_PROBE_RESP).
+ *
+ * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
+ *	As specified in the &enum nl80211_rxmgmt_flags.
+ *
+ * @NL80211_ATTR_STA_SUPPORTED_CHANNELS: array of supported channels.
+ *
+ * @NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES: array of supported
+ *      supported operating classes.
+ *
+ * @NL80211_ATTR_HANDLE_DFS: A flag indicating whether user space
+ *	controls DFS operation in IBSS mode. If the flag is included in
+ *	%NL80211_CMD_JOIN_IBSS request, the driver will allow use of DFS
+ *	channels and reports radar events to userspace. Userspace is required
+ *	to react to radar events, e.g. initiate a channel switch or leave the
+ *	IBSS network.
+ *
+ * @NL80211_ATTR_SUPPORT_5_MHZ: A flag indicating that the device supports
+ *	5 MHz channel bandwidth.
+ * @NL80211_ATTR_SUPPORT_10_MHZ: A flag indicating that the device supports
+ *	10 MHz channel bandwidth.
+ *
+ * @NL80211_ATTR_OPMODE_NOTIF: Operating mode field from Operating Mode
+ *	Notification Element based on association request when used with
+ *	%NL80211_CMD_NEW_STATION; u8 attribute.
+ *
+ * @NL80211_ATTR_VENDOR_ID: The vendor ID, either a 24-bit OUI or, if
+ *	%NL80211_VENDOR_ID_IS_LINUX is set, a special Linux ID (not used yet)
+ * @NL80211_ATTR_VENDOR_SUBCMD: vendor sub-command
+ * @NL80211_ATTR_VENDOR_DATA: data for the vendor command, if any; this
+ *	attribute is also used for vendor command feature advertisement
+ * @NL80211_ATTR_VENDOR_EVENTS: used for event list advertising in the wiphy
+ *	info, containing a nested array of possible events
+ *
+ * @NL80211_ATTR_QOS_MAP: IP DSCP mapping for Interworking QoS mapping. This
+ *	data is in the format defined for the payload of the QoS Map Set element
+ *	in IEEE Std 802.11-2012, 8.4.2.97.
+ *
+ * @NL80211_ATTR_MAC_HINT: MAC address recommendation as initial BSS
+ * @NL80211_ATTR_WIPHY_FREQ_HINT: frequency of the recommended initial BSS
+ *
+ * @NL80211_ATTR_MAX_AP_ASSOC_STA: Device attribute that indicates how many
+ *	associated stations are supported in AP mode (including P2P GO); u32.
+ *	Since drivers may not have a fixed limit on the maximum number (e.g.,
+ *	other concurrent operations may affect this), drivers are allowed to
+ *	advertise values that cannot always be met. In such cases, an attempt
+ *	to add a new station entry with @NL80211_CMD_NEW_STATION may fail.
+ *
+ * @NL80211_ATTR_TDLS_PEER_CAPABILITY: flags for TDLS peer capabilities, u32.
+ *	As specified in the &enum nl80211_tdls_peer_capability.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1709,6 +1874,46 @@ enum nl80211_attrs {
 	NL80211_ATTR_MDID,
 	NL80211_ATTR_IE_RIC,
 
+	NL80211_ATTR_CRIT_PROT_ID,
+	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
+
+	NL80211_ATTR_PEER_AID,
+
+	NL80211_ATTR_COALESCE_RULE,
+
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CSA_IES,
+	NL80211_ATTR_CSA_C_OFF_BEACON,
+	NL80211_ATTR_CSA_C_OFF_PRESP,
+
+	NL80211_ATTR_RXMGMT_FLAGS,
+
+	NL80211_ATTR_STA_SUPPORTED_CHANNELS,
+
+	NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES,
+
+	NL80211_ATTR_HANDLE_DFS,
+
+	NL80211_ATTR_SUPPORT_5_MHZ,
+	NL80211_ATTR_SUPPORT_10_MHZ,
+
+	NL80211_ATTR_OPMODE_NOTIF,
+
+	NL80211_ATTR_VENDOR_ID,
+	NL80211_ATTR_VENDOR_SUBCMD,
+	NL80211_ATTR_VENDOR_DATA,
+	NL80211_ATTR_VENDOR_EVENTS,
+
+	NL80211_ATTR_QOS_MAP,
+
+	NL80211_ATTR_MAC_HINT,
+	NL80211_ATTR_WIPHY_FREQ_HINT,
+
+	NL80211_ATTR_MAX_AP_ASSOC_STA,
+
+	NL80211_ATTR_TDLS_PEER_CAPABILITY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1973,6 +2178,10 @@ enum nl80211_sta_bss_param {
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
@@ -2002,6 +2211,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_NONPEER_PM,
 	NL80211_STA_INFO_RX_BYTES64,
 	NL80211_STA_INFO_TX_BYTES64,
+	NL80211_STA_INFO_CHAIN_SIGNAL,
+	NL80211_STA_INFO_CHAIN_SIGNAL_AVG,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2103,10 +2314,9 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_FREQ: Frequency in MHz
  * @NL80211_FREQUENCY_ATTR_DISABLED: Channel is disabled in current
  *	regulatory domain.
- * @NL80211_FREQUENCY_ATTR_PASSIVE_SCAN: Only passive scanning is
- *	permitted on this channel in current regulatory domain.
- * @NL80211_FREQUENCY_ATTR_NO_IBSS: IBSS networks are not permitted
- *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_NO_IR: no mechanisms that initiate radiation
+ * 	are permitted on this channel, this includes sending probe
+ * 	requests, or modes of operation that require beaconing.
  * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
@@ -2125,6 +2335,7 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_DFS_CAC_TIME: DFS CAC time in milliseconds.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2133,8 +2344,8 @@ enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
 	NL80211_FREQUENCY_ATTR_FREQ,
 	NL80211_FREQUENCY_ATTR_DISABLED,
-	NL80211_FREQUENCY_ATTR_PASSIVE_SCAN,
-	NL80211_FREQUENCY_ATTR_NO_IBSS,
+	NL80211_FREQUENCY_ATTR_NO_IR,
+	__NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 	NL80211_FREQUENCY_ATTR_DFS_STATE,
@@ -2143,6 +2354,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -2150,6 +2362,9 @@ enum nl80211_frequency_attr {
 };
 
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
+#define NL80211_FREQUENCY_ATTR_PASSIVE_SCAN	NL80211_FREQUENCY_ATTR_NO_IR
+#define NL80211_FREQUENCY_ATTR_NO_IBSS		NL80211_FREQUENCY_ATTR_NO_IR
+#define NL80211_FREQUENCY_ATTR_NO_IR		NL80211_FREQUENCY_ATTR_NO_IR
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
@@ -2230,12 +2445,14 @@ enum nl80211_reg_type {
  * 	in KHz. This is not a center a frequency but an actual regulatory
  * 	band edge.
  * @NL80211_ATTR_FREQ_RANGE_MAX_BW: maximum allowed bandwidth for this
- * 	frequency range, in KHz.
+ *	frequency range, in KHz.
  * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed antenna gain
  * 	for a given frequency range. The value is in mBi (100 * dBi).
  * 	If you don't have one then don't send this.
  * @NL80211_ATTR_POWER_RULE_MAX_EIRP: the maximum allowed EIRP for
  * 	a given frequency range. The value is in mBm (100 * dBm).
+ * @NL80211_ATTR_DFS_CAC_TIME: DFS CAC time in milliseconds.
+ *	If not present or 0 default CAC time will be used.
  * @NL80211_REG_RULE_ATTR_MAX: highest regulatory rule attribute number
  *	currently defined
  * @__NL80211_REG_RULE_ATTR_AFTER_LAST: internal use
@@ -2251,6 +2468,8 @@ enum nl80211_reg_rule_attr {
 	NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
 	NL80211_ATTR_POWER_RULE_MAX_EIRP,
 
+	NL80211_ATTR_DFS_CAC_TIME,
+
 	/* keep last */
 	__NL80211_REG_RULE_ATTR_AFTER_LAST,
 	NL80211_REG_RULE_ATTR_MAX = __NL80211_REG_RULE_ATTR_AFTER_LAST - 1
@@ -2260,9 +2479,15 @@ enum nl80211_reg_rule_attr {
  * enum nl80211_sched_scan_match_attr - scheduled scan match attributes
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
- * only report BSS with matching SSID.
+ *	only report BSS with matching SSID.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_RSSI: RSSI threshold (in dBm) for reporting a
- *	BSS in scan results. Filtering is turned off if not specified.
+ *	BSS in scan results. Filtering is turned off if not specified. Note that
+ *	if this attribute is in a match set of its own, then it is treated as
+ *	the default value for all matchsets with an SSID, rather than being a
+ *	matchset of its own without an RSSI filter. This is due to problems with
+ *	how this API was implemented in the past. Also, due to the same problem,
+ *	the only way to create a matchset with only an RSSI filter (with this
+ *	attribute) is if there's only a single matchset with the RSSI attribute.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -2292,8 +2517,12 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_DFS: DFS support is required to be used
  * @NL80211_RRF_PTP_ONLY: this is only for Point To Point links
  * @NL80211_RRF_PTMP_ONLY: this is only for Point To Multi Point links
- * @NL80211_RRF_PASSIVE_SCAN: passive scan is required
- * @NL80211_RRF_NO_IBSS: no IBSS is allowed
+ * @NL80211_RRF_NO_IR: no mechanisms that initiate radiation are allowed,
+ * 	this includes probe requests or modes of operation that require
+ * 	beaconing.
+ * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
+ *	base on contiguous rules and wider channels will be allowed to cross
+ *	multiple contiguous/overlapping frequency ranges.
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2303,10 +2532,18 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_DFS			= 1<<4,
 	NL80211_RRF_PTP_ONLY		= 1<<5,
 	NL80211_RRF_PTMP_ONLY		= 1<<6,
-	NL80211_RRF_PASSIVE_SCAN	= 1<<7,
-	NL80211_RRF_NO_IBSS		= 1<<8,
+	NL80211_RRF_NO_IR		= 1<<7,
+	__NL80211_RRF_NO_IBSS		= 1<<8,
+	NL80211_RRF_AUTO_BW		= 1<<11,
 };
 
+#define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
+#define NL80211_RRF_NO_IBSS		NL80211_RRF_NO_IR
+#define NL80211_RRF_NO_IR		NL80211_RRF_NO_IR
+
+/* For backport compatibility with older userspace */
+#define NL80211_RRF_NO_IR_ALL		(NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
+
 /**
  * enum nl80211_dfs_regions - regulatory DFS regions
  *
@@ -2395,6 +2632,8 @@ enum nl80211_survey_info {
  * @NL80211_MNTR_FLAG_OTHER_BSS: disable BSSID filtering
  * @NL80211_MNTR_FLAG_COOK_FRAMES: report frames after processing.
  *	overrides all other flags.
+ * @NL80211_MNTR_FLAG_ACTIVE: use the configured MAC address
+ *	and ACK incoming unicast packets.
  *
  * @__NL80211_MNTR_FLAG_AFTER_LAST: internal use
  * @NL80211_MNTR_FLAG_MAX: highest possible monitor flag
@@ -2406,6 +2645,7 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_CONTROL,
 	NL80211_MNTR_FLAG_OTHER_BSS,
 	NL80211_MNTR_FLAG_COOK_FRAMES,
+	NL80211_MNTR_FLAG_ACTIVE,
 
 	/* keep last */
 	__NL80211_MNTR_FLAG_AFTER_LAST,
@@ -2541,6 +2781,10 @@ enum nl80211_mesh_power_mode {
  *
  * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
  *
+ * @NL80211_MESHCONF_PLINK_TIMEOUT: If no tx activity is seen from a STA we've
+ *	established peering with for longer than this time (in seconds), then
+ *	remove it from the STA's list of peers.  Default is 30 minutes.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2572,6 +2816,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	NL80211_MESHCONF_POWER_MODE,
 	NL80211_MESHCONF_AWAKE_WINDOW,
+	NL80211_MESHCONF_PLINK_TIMEOUT,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
@@ -2619,6 +2864,10 @@ enum nl80211_meshconf_params {
  * @NL80211_MESH_SETUP_USERSPACE_MPM: Enable this option if userspace will
  *	implement an MPM which handles peer allocation and state.
  *
+ * @NL80211_MESH_SETUP_AUTH_PROTOCOL: Inform the kernel of the authentication
+ *	method (u8, as defined in IEEE 8.4.2.100.6, e.g. 0x1 for SAE).
+ *	Default is no authentication method required.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
@@ -2632,6 +2881,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
 	NL80211_MESH_SETUP_USERSPACE_MPM,
+	NL80211_MESH_SETUP_AUTH_PROTOCOL,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
@@ -2712,6 +2962,8 @@ enum nl80211_channel_type {
  *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
  * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
  *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_5: 5 MHz OFDM channel
+ * @NL80211_CHAN_WIDTH_10: 10 MHz OFDM channel
  */
 enum nl80211_chan_width {
 	NL80211_CHAN_WIDTH_20_NOHT,
@@ -2720,6 +2972,23 @@ enum nl80211_chan_width {
 	NL80211_CHAN_WIDTH_80,
 	NL80211_CHAN_WIDTH_80P80,
 	NL80211_CHAN_WIDTH_160,
+	NL80211_CHAN_WIDTH_5,
+	NL80211_CHAN_WIDTH_10,
+};
+
+/**
+ * enum nl80211_bss_scan_width - control channel width for a BSS
+ *
+ * These values are used with the %NL80211_BSS_CHAN_WIDTH attribute.
+ *
+ * @NL80211_BSS_CHAN_WIDTH_20: control channel is 20 MHz wide or compatible
+ * @NL80211_BSS_CHAN_WIDTH_10: control channel is 10 MHz wide
+ * @NL80211_BSS_CHAN_WIDTH_5: control channel is 5 MHz wide
+ */
+enum nl80211_bss_scan_width {
+	NL80211_BSS_CHAN_WIDTH_20,
+	NL80211_BSS_CHAN_WIDTH_10,
+	NL80211_BSS_CHAN_WIDTH_5,
 };
 
 /**
@@ -2746,6 +3015,8 @@ enum nl80211_chan_width {
  * @NL80211_BSS_BEACON_IES: binary attribute containing the raw information
  *	elements from a Beacon frame (bin); not present if no Beacon frame has
  *	yet been received
+ * @NL80211_BSS_CHAN_WIDTH: channel width of the control channel
+ *	(u32, enum nl80211_bss_scan_width)
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -2762,6 +3033,7 @@ enum nl80211_bss {
 	NL80211_BSS_STATUS,
 	NL80211_BSS_SEEN_MS_AGO,
 	NL80211_BSS_BEACON_IES,
+	NL80211_BSS_CHAN_WIDTH,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
@@ -2902,21 +3174,43 @@ enum nl80211_key_attributes {
  *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values with
  *	1 = 500 kbps) but without the IE length restriction (at most
  *	%NL80211_MAX_SUPP_RATES in a single array).
- * @NL80211_TXRATE_MCS: HT (MCS) rates allowed for TX rate selection
+ * @NL80211_TXRATE_HT: HT (MCS) rates allowed for TX rate selection
  *	in an array of MCS numbers.
+ * @NL80211_TXRATE_VHT: VHT rates allowed for TX rate selection,
+ *	see &struct nl80211_txrate_vht
+ * @NL80211_TXRATE_GI: configure GI, see &enum nl80211_txrate_gi
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
 enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
-	NL80211_TXRATE_MCS,
+	NL80211_TXRATE_HT,
+	NL80211_TXRATE_VHT,
+	NL80211_TXRATE_GI,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
 	NL80211_TXRATE_MAX = __NL80211_TXRATE_AFTER_LAST - 1
 };
 
+#define NL80211_TXRATE_MCS NL80211_TXRATE_HT
+#define NL80211_VHT_NSS_MAX		8
+
+/**
+ * struct nl80211_txrate_vht - VHT MCS/NSS txrate bitmap
+ * @mcs: MCS bitmap table for each NSS (array index 0 for 1 stream, etc.)
+ */
+struct nl80211_txrate_vht {
+	__u16 mcs[NL80211_VHT_NSS_MAX];
+};
+
+enum nl80211_txrate_gi {
+	NL80211_TXRATE_DEFAULT_GI,
+	NL80211_TXRATE_FORCE_SGI,
+	NL80211_TXRATE_FORCE_LGI,
+};
+
 /**
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
@@ -3010,11 +3304,11 @@ enum nl80211_tx_power_setting {
 };
 
 /**
- * enum nl80211_wowlan_packet_pattern_attr - WoWLAN packet pattern attribute
- * @__NL80211_WOWLAN_PKTPAT_INVALID: invalid number for nested attribute
- * @NL80211_WOWLAN_PKTPAT_PATTERN: the pattern, values where the mask has
+ * enum nl80211_packet_pattern_attr - packet pattern attribute
+ * @__NL80211_PKTPAT_INVALID: invalid number for nested attribute
+ * @NL80211_PKTPAT_PATTERN: the pattern, values where the mask has
  *	a zero bit are ignored
- * @NL80211_WOWLAN_PKTPAT_MASK: pattern mask, must be long enough to have
+ * @NL80211_PKTPAT_MASK: pattern mask, must be long enough to have
  *	a bit for each byte in the pattern. The lowest-order bit corresponds
  *	to the first byte of the pattern, but the bytes of the pattern are
  *	in a little-endian-like format, i.e. the 9th byte of the pattern
@@ -3025,39 +3319,50 @@ enum nl80211_tx_power_setting {
  *	Note that the pattern matching is done as though frames were not
  *	802.11 frames but 802.3 frames, i.e. the frame is fully unpacked
  *	first (including SNAP header unpacking) and then matched.
- * @NL80211_WOWLAN_PKTPAT_OFFSET: packet offset, pattern is matched after
+ * @NL80211_PKTPAT_OFFSET: packet offset, pattern is matched after
  *	these fixed number of bytes of received packet
- * @NUM_NL80211_WOWLAN_PKTPAT: number of attributes
- * @MAX_NL80211_WOWLAN_PKTPAT: max attribute number
+ * @NUM_NL80211_PKTPAT: number of attributes
+ * @MAX_NL80211_PKTPAT: max attribute number
  */
-enum nl80211_wowlan_packet_pattern_attr {
-	__NL80211_WOWLAN_PKTPAT_INVALID,
-	NL80211_WOWLAN_PKTPAT_MASK,
-	NL80211_WOWLAN_PKTPAT_PATTERN,
-	NL80211_WOWLAN_PKTPAT_OFFSET,
-
-	NUM_NL80211_WOWLAN_PKTPAT,
-	MAX_NL80211_WOWLAN_PKTPAT = NUM_NL80211_WOWLAN_PKTPAT - 1,
+enum nl80211_packet_pattern_attr {
+	__NL80211_PKTPAT_INVALID,
+	NL80211_PKTPAT_MASK,
+	NL80211_PKTPAT_PATTERN,
+	NL80211_PKTPAT_OFFSET,
+
+	NUM_NL80211_PKTPAT,
+	MAX_NL80211_PKTPAT = NUM_NL80211_PKTPAT - 1,
 };
 
 /**
- * struct nl80211_wowlan_pattern_support - pattern support information
+ * struct nl80211_pattern_support - packet pattern support information
  * @max_patterns: maximum number of patterns supported
  * @min_pattern_len: minimum length of each pattern
  * @max_pattern_len: maximum length of each pattern
  * @max_pkt_offset: maximum Rx packet offset
  *
  * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
- * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
- * capability information given by the kernel to userspace.
+ * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED or in
+ * %NL80211_ATTR_COALESCE_RULE_PKT_PATTERN when that is part of
+ * %NL80211_ATTR_COALESCE_RULE in the capability information given
+ * by the kernel to userspace.
  */
-struct nl80211_wowlan_pattern_support {
+struct nl80211_pattern_support {
 	__u32 max_patterns;
 	__u32 min_pattern_len;
 	__u32 max_pattern_len;
 	__u32 max_pkt_offset;
 } __attribute__((packed));
 
+/* only for backward compatibility */
+#define __NL80211_WOWLAN_PKTPAT_INVALID __NL80211_PKTPAT_INVALID
+#define NL80211_WOWLAN_PKTPAT_MASK NL80211_PKTPAT_MASK
+#define NL80211_WOWLAN_PKTPAT_PATTERN NL80211_PKTPAT_PATTERN
+#define NL80211_WOWLAN_PKTPAT_OFFSET NL80211_PKTPAT_OFFSET
+#define NUM_NL80211_WOWLAN_PKTPAT NUM_NL80211_PKTPAT
+#define MAX_NL80211_WOWLAN_PKTPAT MAX_NL80211_PKTPAT
+#define nl80211_wowlan_pattern_support nl80211_pattern_support
+
 /**
  * enum nl80211_wowlan_triggers - WoWLAN trigger definitions
  * @__NL80211_WOWLAN_TRIG_INVALID: invalid number for nested attributes
@@ -3077,7 +3382,7 @@ struct nl80211_wowlan_pattern_support {
  *	pattern matching is done after the packet is converted to the MSDU.
  *
  *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
- *	carrying a &struct nl80211_wowlan_pattern_support.
+ *	carrying a &struct nl80211_pattern_support.
  *
  *	When reporting wakeup. it is a u32 attribute containing the 0-based
  *	index of the pattern that caused the wakeup, in the patterns passed
@@ -3234,7 +3539,7 @@ struct nl80211_wowlan_tcp_data_token_feature {
  * @NL80211_WOWLAN_TCP_WAKE_PAYLOAD: wake packet payload, for advertising a
  *	u32 attribute holding the maximum length
  * @NL80211_WOWLAN_TCP_WAKE_MASK: Wake packet payload mask, not used for
- *	feature advertising. The mask works like @NL80211_WOWLAN_PKTPAT_MASK
+ *	feature advertising. The mask works like @NL80211_PKTPAT_MASK
  *	but on the TCP payload only.
  * @NUM_NL80211_WOWLAN_TCP: number of TCP attributes
  * @MAX_NL80211_WOWLAN_TCP: highest attribute number
@@ -3259,6 +3564,55 @@ enum nl80211_wowlan_tcp_attrs {
 };
 
 /**
+ * struct nl80211_coalesce_rule_support - coalesce rule support information
+ * @max_rules: maximum number of rules supported
+ * @pat: packet pattern support information
+ * @max_delay: maximum supported coalescing delay in msecs
+ *
+ * This struct is carried in %NL80211_ATTR_COALESCE_RULE in the
+ * capability information given by the kernel to userspace.
+ */
+struct nl80211_coalesce_rule_support {
+	__u32 max_rules;
+	struct nl80211_pattern_support pat;
+	__u32 max_delay;
+} __attribute__((packed));
+
+/**
+ * enum nl80211_attr_coalesce_rule - coalesce rule attribute
+ * @__NL80211_COALESCE_RULE_INVALID: invalid number for nested attribute
+ * @NL80211_ATTR_COALESCE_RULE_DELAY: delay in msecs used for packet coalescing
+ * @NL80211_ATTR_COALESCE_RULE_CONDITION: condition for packet coalescence,
+ *	see &enum nl80211_coalesce_condition.
+ * @NL80211_ATTR_COALESCE_RULE_PKT_PATTERN: packet offset, pattern is matched
+ *	after these fixed number of bytes of received packet
+ * @NUM_NL80211_ATTR_COALESCE_RULE: number of attributes
+ * @NL80211_ATTR_COALESCE_RULE_MAX: max attribute number
+ */
+enum nl80211_attr_coalesce_rule {
+	__NL80211_COALESCE_RULE_INVALID,
+	NL80211_ATTR_COALESCE_RULE_DELAY,
+	NL80211_ATTR_COALESCE_RULE_CONDITION,
+	NL80211_ATTR_COALESCE_RULE_PKT_PATTERN,
+
+	/* keep last */
+	NUM_NL80211_ATTR_COALESCE_RULE,
+	NL80211_ATTR_COALESCE_RULE_MAX = NUM_NL80211_ATTR_COALESCE_RULE - 1
+};
+
+/**
+ * enum nl80211_coalesce_condition - coalesce rule conditions
+ * @NL80211_COALESCE_CONDITION_MATCH: coalaesce Rx packets when patterns
+ *	in a rule are matched.
+ * @NL80211_COALESCE_CONDITION_NO_MATCH: coalesce Rx packets when patterns
+ *	in a rule are not matched.
+ */
+enum nl80211_coalesce_condition {
+	NL80211_COALESCE_CONDITION_MATCH,
+	NL80211_COALESCE_CONDITION_NO_MATCH
+};
+
+/**
  * enum nl80211_iface_limit_attrs - limit attributes
  * @NL80211_IFACE_LIMIT_UNSPEC: (reserved)
  * @NL80211_IFACE_LIMIT_MAX: maximum number of interfaces that
@@ -3502,11 +3856,6 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
  *	to work properly to suppport receiving regulatory hints from
  *	cellular base stations.
- * @NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL: If this is set, an active
- *	P2P Device (%NL80211_IFTYPE_P2P_DEVICE) requires its own channel
- *	in the interface combinations, even when it's only used for scan
- *	and remain-on-channel. This could be due to, for example, the
- *	remain-on-channel implementation requiring a channel context.
  * @NL80211_FEATURE_SAE: This driver supports simultaneous authentication of
  *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
  *	mode
@@ -3538,13 +3887,17 @@ enum nl80211_ap_sme_features {
  *	Peering Management entity which may be implemented by registering for
  *	beacons or NL80211_CMD_NEW_PEER_CANDIDATE events. The mesh beacon is
  *	still generated by the driver.
+ * @NL80211_FEATURE_ACTIVE_MONITOR: This driver supports an active monitor
+ *	interface. An active monitor interface behaves like a normal monitor
+ *	interface, but gets added to the driver. It ensures that incoming
+ *	unicast packets directed at the configured interface address get ACKed.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
 	NL80211_FEATURE_HT_IBSS				= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
-	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
+	/* bit 4 is reserved - don't use */
 	NL80211_FEATURE_SAE				= 1 << 5,
 	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
 	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
@@ -3557,6 +3910,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
+	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 };
 
 /**
@@ -3657,13 +4011,12 @@ enum nl80211_radar_event {
  *
  * Channel states used by the DFS code.
  *
- * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
+ * @NL80211_DFS_USABLE: The channel can be used, but channel availability
  *	check (CAC) must be performed before using it for AP or IBSS.
- * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
+ * @NL80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
  *	is therefore marked as not available.
- * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
+ * @NL80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
  */
-
 enum nl80211_dfs_state {
 	NL80211_DFS_USABLE,
 	NL80211_DFS_UNAVAILABLE,
@@ -3682,4 +4035,72 @@ enum nl80211_protocol_features {
 	NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP =	1 << 0,
 };
 
+/**
+ * enum nl80211_crit_proto_id - nl80211 critical protocol identifiers
+ *
+ * @NL80211_CRIT_PROTO_UNSPEC: protocol unspecified.
+ * @NL80211_CRIT_PROTO_DHCP: BOOTP or DHCPv6 protocol.
+ * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
+ * @NL80211_CRIT_PROTO_APIPA: APIPA protocol.
+ * @NUM_NL80211_CRIT_PROTO: must be kept last.
+ */
+enum nl80211_crit_proto_id {
+	NL80211_CRIT_PROTO_UNSPEC,
+	NL80211_CRIT_PROTO_DHCP,
+	NL80211_CRIT_PROTO_EAPOL,
+	NL80211_CRIT_PROTO_APIPA,
+	/* add other protocols before this one */
+	NUM_NL80211_CRIT_PROTO
+};
+
+/* maximum duration for critical protocol measures */
+#define NL80211_CRIT_PROTO_MAX_DURATION		5000 /* msec */
+
+/**
+ * enum nl80211_rxmgmt_flags - flags for received management frame.
+ *
+ * Used by cfg80211_rx_mgmt()
+ *
+ * @NL80211_RXMGMT_FLAG_ANSWERED: frame was answered by device/driver.
+ */
+enum nl80211_rxmgmt_flags {
+	NL80211_RXMGMT_FLAG_ANSWERED = 1 << 0,
+};
+
+/*
+ * If this flag is unset, the lower 24 bits are an OUI, if set
+ * a Linux nl80211 vendor ID is used (no such IDs are allocated
+ * yet, so that's not valid so far)
+ */
+#define NL80211_VENDOR_ID_IS_LINUX	0x80000000
+
+/**
+ * struct nl80211_vendor_cmd_info - vendor command data
+ * @vendor_id: If the %NL80211_VENDOR_ID_IS_LINUX flag is clear, then the
+ *	value is a 24-bit OUI; if it is set then a separately allocated ID
+ *	may be used, but no such IDs are allocated yet. New IDs should be
+ *	added to this file when needed.
+ * @subcmd: sub-command ID for the command
+ */
+struct nl80211_vendor_cmd_info {
+	__u32 vendor_id;
+	__u32 subcmd;
+};
+
+/**
+ * enum nl80211_tdls_peer_capability - TDLS peer flags.
+ *
+ * Used by tdls_mgmt() to determine which conditional elements need
+ * to be added to TDLS Setup frames.
+ *
+ * @NL80211_TDLS_PEER_HT: TDLS peer is HT capable.
+ * @NL80211_TDLS_PEER_VHT: TDLS peer is VHT capable.
+ * @NL80211_TDLS_PEER_WMM: TDLS peer is WMM capable.
+ */
+enum nl80211_tdls_peer_capability {
+	NL80211_TDLS_PEER_HT = 1<<0,
+	NL80211_TDLS_PEER_VHT = 1<<1,
+	NL80211_TDLS_PEER_WMM = 1<<2,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/reglib.h b/reglib.h
index d570c36..afd5ef6 100644
--- a/reglib.h
+++ b/reglib.h
@@ -37,9 +37,6 @@ struct ieee80211_regdomain {
 	struct ieee80211_reg_rule reg_rules[];
 };
 
-/* Remove this once upstream nl80211.h gets this */
-#define NL80211_RRF_NO_IR (1<<7)
-
 #define REGLIB_MHZ_TO_KHZ(freq) ((freq) * 1000)
 #define REGLIB_KHZ_TO_MHZ(freq) ((freq) / 1000)
 #define REGLIB_DBI_TO_MBI(gain) ((gain) * 100)
-- 
1.7.9.5

