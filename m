Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2FMJQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 05:16:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Sejh5-0001E7-9t
	for linux-wireless@vger.kernel.org; Wed, 13 Jun 2012 11:16:51 +0200
Message-ID: <1339579011.4519.22.camel@jlt3.sipsolutions.net> (sfid-20120613_111656_715922_B90C2025)
Subject: [PATCH] cfg80211/nl80211: fix kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 11:16:51 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add missing entries to nl80211.h and fix
the kernel-doc notation in cfg80211.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   33 ++++++++++++++++++++++++++++-----
 include/net/cfg80211.h  |    8 ++++----
 2 files changed, 32 insertions(+), 9 deletions(-)

--- a/include/linux/nl80211.h	2012-06-13 11:13:59.000000000 +0200
+++ b/include/linux/nl80211.h	2012-06-13 11:14:13.000000000 +0200
@@ -275,6 +275,12 @@
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
@@ -454,6 +460,10 @@
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
@@ -769,6 +779,13 @@ enum nl80211_commands {
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
@@ -1004,6 +1021,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_PS_STATE: powersave state, using &enum nl80211_ps_state values.
+ *
  * @NL80211_ATTR_CQM: connection quality monitor configuration in a
  *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
  *
@@ -1061,7 +1080,7 @@ enum nl80211_commands {
  *	flag isn't set, the frame will be rejected. This is also used as an
  *	nl80211 capability flag.
  *
- * @NL80211_ATTR_BSS_HTOPMODE: HT operation mode (u16)
+ * @NL80211_ATTR_BSS_HT_OPMODE: HT operation mode (u16)
  *
  * @NL80211_ATTR_KEY_DEFAULT_TYPES: A nested attribute containing flags
  *	attributes, specifying what a key should be set as default as.
@@ -1085,10 +1104,10 @@ enum nl80211_commands {
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
@@ -1115,7 +1134,7 @@ enum nl80211_commands {
  *	are managed in software: interfaces of these types aren't subject to
  *	any restrictions in their number or combinations.
  *
- * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
+ * @NL80211_ATTR_REKEY_DATA: nested attribute containing the information
  *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
  *
  * @NL80211_ATTR_SCAN_SUPP_RATES: rates per to be advertised as supported in scan,
@@ -1182,7 +1201,6 @@ enum nl80211_commands {
  * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
  *	&enum nl80211_feature_flags and is advertised in wiphy information.
  * @NL80211_ATTR_PROBE_RESP_OFFLOAD: Indicates that the HW responds to probe
- *
  *	requests while operating in AP-mode.
  *	This attribute holds a bitmap of the supported protocols for
  *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
@@ -2499,6 +2517,11 @@ enum nl80211_band {
 	NL80211_BAND_5GHZ,
 };
 
+/**
+ * enum nl80211_ps_state - powersave state
+ * @NL80211_PS_DISABLED: powersave is disabled
+ * @NL80211_PS_ENABLED: powersave is enabled
+ */
 enum nl80211_ps_state {
 	NL80211_PS_DISABLED,
 	NL80211_PS_ENABLED,
--- a/include/net/cfg80211.h	2012-06-13 11:13:52.000000000 +0200
+++ b/include/net/cfg80211.h	2012-06-13 11:14:13.000000000 +0200
@@ -622,10 +622,10 @@ struct sta_bss_parameters {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
- * @signal: the signal strength, type depends on the wiphy's signal_type
-	NOTE: For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
- * @signal_avg: avg signal strength, type depends on the wiphy's signal_type
-	NOTE: For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
+ * @signal: The signal strength, type depends on the wiphy's signal_type.
+ *	For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
+ * @signal_avg: Average signal strength, type depends on the wiphy's signal_type.
+ *	For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
  * @txrate: current unicast bitrate from this station
  * @rxrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station


