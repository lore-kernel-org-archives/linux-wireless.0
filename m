Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2GDIp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 04:45:26 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/4] sync nl80211 with kernel v3.5
Date: Wed, 4 Jul 2012 11:45:08 +0300
Message-ID: <1341391511-11359-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120704_104532_078336_777BCAE9)
In-Reply-To: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 nl80211.h |  180 +++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 127 insertions(+), 53 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index a6959f7..0f03969 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -170,6 +170,8 @@
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
  *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
+ *	The channel to use can be set on the interface or be given using the
+ *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_WIPHY_CHANNEL_TYPE attrs.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
  * @NL80211_CMD_STOP_AP: Stop AP operation on the given interface
  * @NL80211_CMD_DEL_BEACON: old alias for %NL80211_CMD_STOP_AP
@@ -275,6 +277,12 @@
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
  *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
  *
+ * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry, using %NL80211_ATTR_MAC
+ *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ * @NL80211_CMD_DEL_PMKSA: Delete a PMKSA cache entry, using %NL80211_ATTR_MAC
+ *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ * @NL80211_CMD_FLUSH_PMKSA: Flush all PMKSA cache entries.
+ *
  * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
  * 	has been changed and provides details of the request information
  * 	that caused the change such as who initiated the regulatory request
@@ -454,6 +462,10 @@
  *	the frame.
  * @NL80211_CMD_ACTION_TX_STATUS: Alias for @NL80211_CMD_FRAME_TX_STATUS for
  *	backward compatibility.
+ *
+ * @NL80211_CMD_SET_POWER_SAVE: Set powersave, using %NL80211_ATTR_PS_STATE
+ * @NL80211_CMD_GET_POWER_SAVE: Get powersave status in %NL80211_ATTR_PS_STATE
+ *
  * @NL80211_CMD_SET_CQM: Connection quality monitor configuration. This command
  *	is used to configure connection quality monitoring notification trigger
  *	levels.
@@ -769,6 +781,13 @@ enum nl80211_commands {
  *	section 7.3.2.25.1, e.g. 0x000FAC04)
  * @NL80211_ATTR_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
  *	CCMP keys, each six bytes in little endian
+ * @NL80211_ATTR_KEY_DEFAULT: Flag attribute indicating the key is default key
+ * @NL80211_ATTR_KEY_DEFAULT_MGMT: Flag attribute indicating the key is the
+ *	default management key
+ * @NL80211_ATTR_CIPHER_SUITES_PAIRWISE: For crypto settings for connect or
+ *	other commands, indicates which pairwise cipher suites are used
+ * @NL80211_ATTR_CIPHER_SUITE_GROUP: For crypto settings for connect or
+ *	other commands, indicates which group cipher suite is used
  *
  * @NL80211_ATTR_BEACON_INTERVAL: beacon interval in TU
  * @NL80211_ATTR_DTIM_PERIOD: DTIM period for beaconing
@@ -1004,6 +1023,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_PS_STATE: powersave state, using &enum nl80211_ps_state values.
+ *
  * @NL80211_ATTR_CQM: connection quality monitor configuration in a
  *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
  *
@@ -1061,7 +1082,7 @@ enum nl80211_commands {
  *	flag isn't set, the frame will be rejected. This is also used as an
  *	nl80211 capability flag.
  *
- * @NL80211_ATTR_BSS_HTOPMODE: HT operation mode (u16)
+ * @NL80211_ATTR_BSS_HT_OPMODE: HT operation mode (u16)
  *
  * @NL80211_ATTR_KEY_DEFAULT_TYPES: A nested attribute containing flags
  *	attributes, specifying what a key should be set as default as.
@@ -1085,10 +1106,10 @@ enum nl80211_commands {
  *	indicate which WoW triggers should be enabled. This is also
  *	used by %NL80211_CMD_GET_WOWLAN to get the currently enabled WoWLAN
  *	triggers.
-
+ *
  * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
  *	cycles, in msecs.
-
+ *
  * @NL80211_ATTR_SCHED_SCAN_MATCH: Nested attribute with one or more
  *	sets of attributes to match during scheduled scans.  Only BSSs
  *	that match any of the sets will be reported.  These are
@@ -1115,7 +1136,7 @@ enum nl80211_commands {
  *	are managed in software: interfaces of these types aren't subject to
  *	any restrictions in their number or combinations.
  *
- * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
+ * @NL80211_ATTR_REKEY_DATA: nested attribute containing the information
  *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
  *
  * @NL80211_ATTR_SCAN_SUPP_RATES: rates per to be advertised as supported in scan,
@@ -1182,7 +1203,6 @@ enum nl80211_commands {
  * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
  *	&enum nl80211_feature_flags and is advertised in wiphy information.
  * @NL80211_ATTR_PROBE_RESP_OFFLOAD: Indicates that the HW responds to probe
- *
  *	requests while operating in AP-mode.
  *	This attribute holds a bitmap of the supported protocols for
  *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
@@ -1520,6 +1540,11 @@ enum nl80211_attrs {
 #define NL80211_MAX_NR_CIPHER_SUITES		5
 #define NL80211_MAX_NR_AKM_SUITES		2
 
+#define NL80211_MIN_REMAIN_ON_CHANNEL_TIME	10
+
+/* default RSSI threshold for scan results if none specified. */
+#define NL80211_SCAN_RSSI_THOLD_OFF		-300
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -1613,12 +1638,19 @@ struct nl80211_sta_flag_update {
  *
  * These attribute types are used with %NL80211_STA_INFO_TXRATE
  * when getting information about the bitrate of a station.
+ * There are 2 types for bitrate, legacy one that represents
+ * 16-bit value, and new one that represents 32-bit value.
+ * If rate value fits into 16 bit, both attributes reported with
+ * the same value. If rate is too high to fit into 16 bit (>6.5535Gbps),
+ * only new value included.
+ * User space tools encouraged to use new bitrate.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
  * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ * @NL80211_RATE_INFO_BITRATE_HT: total bitrate (u32, 100kbit/s)
  * @NL80211_RATE_INFO_MAX: highest rate_info number currently defined
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
@@ -1628,6 +1660,7 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
+	NL80211_RATE_INFO_BITRATE_HT,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
@@ -1788,6 +1821,9 @@ enum nl80211_mpath_info {
  * @NL80211_BAND_ATTR_HT_CAPA: HT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_HT_AMPDU_FACTOR: A-MPDU factor, as in 11n
  * @NL80211_BAND_ATTR_HT_AMPDU_DENSITY: A-MPDU density, as in 11n
+ * @NL80211_BAND_ATTR_VHT_MCS_SET: 32-byte attribute containing the MCS set as
+ *	defined in 802.11ac
+ * @NL80211_BAND_ATTR_VHT_CAPA: VHT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
  * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
@@ -1801,6 +1837,9 @@ enum nl80211_band_attr {
 	NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
 	NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
 
+	NL80211_BAND_ATTR_VHT_MCS_SET,
+	NL80211_BAND_ATTR_VHT_CAPA,
+
 	/* keep last */
 	__NL80211_BAND_ATTR_AFTER_LAST,
 	NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
@@ -1952,6 +1991,8 @@ enum nl80211_reg_rule_attr {
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
  * only report BSS with matching SSID.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_RSSI: RSSI threshold (in dBm) for reporting a
+ *	BSS in scan results. Filtering is turned off if not specified.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -1959,7 +2000,8 @@ enum nl80211_reg_rule_attr {
 enum nl80211_sched_scan_match_attr {
 	__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID,
 
-	NL80211_ATTR_SCHED_SCAN_MATCH_SSID,
+	NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
+	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
@@ -1967,6 +2009,9 @@ enum nl80211_sched_scan_match_attr {
 		__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST - 1
 };
 
+/* only for backward compatibility */
+#define NL80211_ATTR_SCHED_SCAN_MATCH_SSID NL80211_SCHED_SCAN_MATCH_ATTR_SSID
+
 /**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
@@ -2086,78 +2131,91 @@ enum nl80211_mntr_flags {
  * @__NL80211_MESHCONF_INVALID: internal use
  *
  * @NL80211_MESHCONF_RETRY_TIMEOUT: specifies the initial retry timeout in
- * millisecond units, used by the Peer Link Open message
+ *	millisecond units, used by the Peer Link Open message
  *
  * @NL80211_MESHCONF_CONFIRM_TIMEOUT: specifies the initial confirm timeout, in
- * millisecond units, used by the peer link management to close a peer link
+ *	millisecond units, used by the peer link management to close a peer link
  *
  * @NL80211_MESHCONF_HOLDING_TIMEOUT: specifies the holding timeout, in
- * millisecond units
+ *	millisecond units
  *
  * @NL80211_MESHCONF_MAX_PEER_LINKS: maximum number of peer links allowed
- * on this mesh interface
+ *	on this mesh interface
  *
  * @NL80211_MESHCONF_MAX_RETRIES: specifies the maximum number of peer link
- * open retries that can be sent to establish a new peer link instance in a
- * mesh
+ *	open retries that can be sent to establish a new peer link instance in a
+ *	mesh
  *
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
- * point.
+ *	point.
  *
  * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
- * open peer links when we detect compatible mesh peers.
+ *	open peer links when we detect compatible mesh peers.
  *
  * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
- * containing a PREQ that an MP can send to a particular destination (path
- * target)
+ *	containing a PREQ that an MP can send to a particular destination (path
+ *	target)
  *
  * @NL80211_MESHCONF_PATH_REFRESH_TIME: how frequently to refresh mesh paths
- * (in milliseconds)
+ *	(in milliseconds)
  *
  * @NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT: minimum length of time to wait
- * until giving up on a path discovery (in milliseconds)
+ *	until giving up on a path discovery (in milliseconds)
  *
  * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT: The time (in TUs) for which mesh
- * points receiving a PREQ shall consider the forwarding information from the
- * root to be valid. (TU = time unit)
+ *	points receiving a PREQ shall consider the forwarding information from
+ *	the root to be valid. (TU = time unit)
  *
  * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
- * TUs) during which an MP can send only one action frame containing a PREQ
- * reference element
+ *	TUs) during which an MP can send only one action frame containing a PREQ
+ *	reference element
  *
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
- * that it takes for an HWMP information element to propagate across the mesh
+ *	that it takes for an HWMP information element to propagate across the
+ *	mesh
  *
  * @NL80211_MESHCONF_HWMP_ROOTMODE: whether root mode is enabled or not
  *
  * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
- * source mesh point for path selection elements.
+ *	source mesh point for path selection elements.
  *
  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
- * root announcements are transmitted.
+ *	root announcements are transmitted.
  *
  * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
- * access to a broader network beyond the MBSS.  This is done via Root
- * Announcement frames.
+ *	access to a broader network beyond the MBSS.  This is done via Root
+ *	Announcement frames.
  *
  * @NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL: The minimum interval of time (in
- * TUs) during which a mesh STA can send only one Action frame containing a
- * PERR element.
+ *	TUs) during which a mesh STA can send only one Action frame containing a
+ *	PERR element.
  *
  * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
- * or forwarding entity (default is TRUE - forwarding entity)
+ *	or forwarding entity (default is TRUE - forwarding entity)
  *
  * @NL80211_MESHCONF_RSSI_THRESHOLD: RSSI threshold in dBm. This specifies the
- * threshold for average signal strength of candidate station to establish
- * a peer link.
- *
- * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
+ *	threshold for average signal strength of candidate station to establish
+ *	a peer link.
  *
  * @NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR: maximum number of neighbors
- * to synchronize to for 11s default synchronization method (see 11C.12.2.2)
+ *	to synchronize to for 11s default synchronization method
+ *	(see 11C.12.2.2)
  *
  * @NL80211_MESHCONF_HT_OPMODE: set mesh HT protection mode.
  *
+ * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
+ *
+ * @NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT: The time (in TUs) for
+ *	which mesh STAs receiving a proactive PREQ shall consider the forwarding
+ *	information to the root mesh STA to be valid.
+ *
+ * @NL80211_MESHCONF_HWMP_ROOT_INTERVAL: The interval of time (in TUs) between
+ *	proactive PREQs are transmitted.
+ *
+ * @NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL: The minimum interval of time
+ *	(in TUs) during which a mesh STA can send only one Action frame
+ *	containing a PREQ element for root path confirmation.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2184,6 +2242,9 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_RSSI_THRESHOLD,
 	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
 	NL80211_MESHCONF_HT_OPMODE,
+	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
@@ -2199,34 +2260,36 @@ enum nl80211_meshconf_params {
  * @__NL80211_MESH_SETUP_INVALID: Internal use
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL: Enable this option to use a
- * vendor specific path selection algorithm or disable it to use the default
- * HWMP.
+ *	vendor specific path selection algorithm or disable it to use the
+ *	default HWMP.
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC: Enable this option to use a
- * vendor specific path metric or disable it to use the default Airtime
- * metric.
+ *	vendor specific path metric or disable it to use the default Airtime
+ *	metric.
  *
  * @NL80211_MESH_SETUP_IE: Information elements for this mesh, for instance, a
- * robust security network ie, or a vendor specific information element that
- * vendors will use to identify the path selection methods and metrics in use.
+ *	robust security network ie, or a vendor specific information element
+ *	that vendors will use to identify the path selection methods and
+ *	metrics in use.
  *
  * @NL80211_MESH_SETUP_USERSPACE_AUTH: Enable this option if an authentication
- * daemon will be authenticating mesh candidates.
+ *	daemon will be authenticating mesh candidates.
  *
  * @NL80211_MESH_SETUP_USERSPACE_AMPE: Enable this option if an authentication
- * daemon will be securing peer link frames.  AMPE is a secured version of Mesh
- * Peering Management (MPM) and is implemented with the assistance of a
- * userspace daemon.  When this flag is set, the kernel will send peer
- * management frames to a userspace daemon that will implement AMPE
- * functionality (security capabilities selection, key confirmation, and key
- * management).  When the flag is unset (default), the kernel can autonomously
- * complete (unsecured) mesh peering without the need of a userspace daemon.
- *
- * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
+ *	daemon will be securing peer link frames.  AMPE is a secured version of
+ *	Mesh Peering Management (MPM) and is implemented with the assistance of
+ *	a userspace daemon.  When this flag is set, the kernel will send peer
+ *	management frames to a userspace daemon that will implement AMPE
+ *	functionality (security capabilities selection, key confirmation, and
+ *	key management).  When the flag is unset (default), the kernel can
+ *	autonomously complete (unsecured) mesh peering without the need of a
+ *	userspace daemon.
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC: Enable this option to use a
- * vendor specific synchronization method or disable it to use the default
- * neighbor offset synchronization
+ *	vendor specific synchronization method or disable it to use the default
+ *	neighbor offset synchronization
+ *
+ * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
@@ -2490,12 +2553,19 @@ enum nl80211_tx_rate_attributes {
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
  * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
+ * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
  */
 enum nl80211_band {
 	NL80211_BAND_2GHZ,
 	NL80211_BAND_5GHZ,
+	NL80211_BAND_60GHZ,
 };
 
+/**
+ * enum nl80211_ps_state - powersave state
+ * @NL80211_PS_DISABLED: powersave is disabled
+ * @NL80211_PS_ENABLED: powersave is enabled
+ */
 enum nl80211_ps_state {
 	NL80211_PS_DISABLED,
 	NL80211_PS_ENABLED,
@@ -2534,10 +2604,14 @@ enum nl80211_attr_cqm {
  *      configured threshold
  * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher than the
  *      configured threshold
+ * @NL80211_CQM_RSSI_BEACON_LOSS_EVENT: The device experienced beacon loss.
+ *	(Note that deauth/disassoc will still follow if the AP is not
+ *	available. This event might get used as roaming event, etc.)
  */
 enum nl80211_cqm_rssi_threshold_event {
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+	NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
 };
 
 
-- 
1.7.9.5

