Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaI3NXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 09:23:04 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/2] iw: update nl80211.h
Date: Tue, 30 Sep 2014 15:20:34 +0200
Message-Id: <1412083235-8560-1-git-send-email-sgruszka@redhat.com> (sfid-20140930_152308_915015_2592E09D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync nl80211.h with wireless-testing tree and add
NL80211_ATTR_PS_TIMEOUT attribute needed for further ps changes.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 nl80211.h | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 2 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index be9519b..600d47b 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -722,6 +722,22 @@
  *	QoS mapping is relevant for IP packets, it is only valid during an
  *	association. This is cleared on disassociation and AP restart.
  *
+ * @NL80211_CMD_ADD_TX_TS: Ask the kernel to add a traffic stream for the given
+ *	%NL80211_ATTR_TSID and %NL80211_ATTR_MAC with %NL80211_ATTR_USER_PRIO
+ *	and %NL80211_ATTR_ADMITTED_TIME parameters.
+ *	Note that the action frame handshake with the AP shall be handled by
+ *	userspace via the normal management RX/TX framework, this only sets
+ *	up the TX TS in the driver/device.
+ *	If the admitted time attribute is not added then the request just checks
+ *	if a subsequent setup could be successful, the intent is to use this to
+ *	avoid setting up a session with the AP when local restrictions would
+ *	make that impossible. However, the subsequent "real" setup may still
+ *	fail even if the check was successful.
+ * @NL80211_CMD_DEL_TX_TS: Remove an existing TS with the %NL80211_ATTR_TSID
+ *	and %NL80211_ATTR_MAC parameters. It isn't necessary to call this
+ *	before removing a station entry entirely, or before disassociating
+ *	or similar, cleanup will happen in the driver/device in this case.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -893,6 +909,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_QOS_MAP,
 
+	NL80211_CMD_ADD_TX_TS,
+	NL80211_CMD_DEL_TX_TS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1591,6 +1610,34 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
+ *	the TDLS link initiator.
+ *
+ * @NL80211_ATTR_USE_RRM: flag for indicating whether the current connection
+ *	shall support Radio Resource Measurements (11k). This attribute can be
+ *	used with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests.
+ *	User space applications are expected to use this flag only if the
+ *	underlying device supports these minimal RRM features:
+ *		%NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES,
+ *		%NL80211_FEATURE_QUIET,
+ *	If this flag is used, driver must add the Power Capabilities IE to the
+ *	association request. In addition, it must also set the RRM capability
+ *	flag in the association request's Capability Info field.
+ *
+ * @NL80211_ATTR_WIPHY_DYN_ACK: flag attribute used to enable ACK timeout
+ *	estimation algorithm (dynack). In order to activate dynack
+ *	%NL80211_FEATURE_ACKTO_ESTIMATION feature flag must be set by lower
+ *	drivers to indicate dynack capability. Dynack is automatically disabled
+ *	setting valid value for coverage class.
+ *
+ * @NL80211_ATTR_TSID: a TSID value (u8 attribute)
+ * @NL80211_ATTR_USER_PRIO: user priority value (u8 attribute)
+ * @NL80211_ATTR_ADMITTED_TIME: admitted time in units of 32 microseconds
+ *	(per second) (u16 attribute)
+ *
+ * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
+ *	&enum nl80211_smps_mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1931,6 +1978,20 @@ enum nl80211_attrs {
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
 
+	NL80211_ATTR_TDLS_INITIATOR,
+
+	NL80211_ATTR_USE_RRM,
+
+	NL80211_ATTR_WIPHY_DYN_ACK,
+
+	NL80211_ATTR_TSID,
+	NL80211_ATTR_USER_PRIO,
+	NL80211_ATTR_ADMITTED_TIME,
+
+	NL80211_ATTR_SMPS_MODE,
+
+	NL80211_ATTR_PS_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3050,14 +3111,20 @@ enum nl80211_bss_scan_width {
  * @NL80211_BSS_BSSID: BSSID of the BSS (6 octets)
  * @NL80211_BSS_FREQUENCY: frequency in MHz (u32)
  * @NL80211_BSS_TSF: TSF of the received probe response/beacon (u64)
+ *	(if @NL80211_BSS_PRESP_DATA is present then this is known to be
+ *	from a probe response, otherwise it may be from the same beacon
+ *	that the NL80211_BSS_BEACON_TSF will be from)
  * @NL80211_BSS_BEACON_INTERVAL: beacon interval of the (I)BSS (u16)
  * @NL80211_BSS_CAPABILITY: capability field (CPU order, u16)
  * @NL80211_BSS_INFORMATION_ELEMENTS: binary attribute containing the
  *	raw information elements from the probe response/beacon (bin);
- *	if the %NL80211_BSS_BEACON_IES attribute is present, the IEs here are
- *	from a Probe Response frame; otherwise they are from a Beacon frame.
+ *	if the %NL80211_BSS_BEACON_IES attribute is present and the data is
+ *	different then the IEs here are from a Probe Response frame; otherwise
+ *	they are from a Beacon frame.
  *	However, if the driver does not indicate the source of the IEs, these
  *	IEs may be from either frame subtype.
+ *	If present, the @NL80211_BSS_PRESP_DATA attribute indicates that the
+ *	data here is known to be from a probe response, without any heuristics.
  * @NL80211_BSS_SIGNAL_MBM: signal strength of probe response/beacon
  *	in mBm (100 * dBm) (s32)
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
@@ -3069,6 +3136,10 @@ enum nl80211_bss_scan_width {
  *	yet been received
  * @NL80211_BSS_CHAN_WIDTH: channel width of the control channel
  *	(u32, enum nl80211_bss_scan_width)
+ * @NL80211_BSS_BEACON_TSF: TSF of the last received beacon (u64)
+ *	(not present if no beacon frame has been received yet)
+ * @NL80211_BSS_PRESP_DATA: the data in @NL80211_BSS_INFORMATION_ELEMENTS and
+ *	@NL80211_BSS_TSF is known to be from a probe response (flag attribute)
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3086,6 +3157,8 @@ enum nl80211_bss {
 	NL80211_BSS_SEEN_MS_AGO,
 	NL80211_BSS_BEACON_IES,
 	NL80211_BSS_CHAN_WIDTH,
+	NL80211_BSS_BEACON_TSF,
+	NL80211_BSS_PRESP_DATA,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
@@ -3951,6 +4024,26 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
  *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
  *	lifetime of a BSS.
+ * @NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES: This device adds a DS Parameter
+ *	Set IE to probe requests.
+ * @NL80211_FEATURE_WFA_TPC_IE_IN_PROBES: This device adds a WFA TPC Report IE
+ *	to probe requests.
+ * @NL80211_FEATURE_QUIET: This device, in client mode, supports Quiet Period
+ *	requests sent to it by an AP.
+ * @NL80211_FEATURE_TX_POWER_INSERTION: This device is capable of inserting the
+ *	current tx power value into the TPC Report IE in the spectrum
+ *	management TPC Report action frame, and in the Radio Measurement Link
+ *	Measurement Report action frame.
+ * @NL80211_FEATURE_ACKTO_ESTIMATION: This driver supports dynamic ACK timeout
+ *	estimation (dynack). %NL80211_ATTR_WIPHY_DYN_ACK flag attribute is used
+ *	to enable dynack.
+ * @NL80211_FEATURE_STATIC_SMPS: Device supports static spatial
+ *	multiplexing powersave, ie. can turn off all but one chain
+ *	even on HT connections that should be using more chains.
+ * @NL80211_FEATURE_DYNAMIC_SMPS: Device supports dynamic spatial
+ *	multiplexing powersave, ie. can turn off all but one chain
+ *	and then wake the rest up as required after, for example,
+ *	rts/cts handshake.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3972,6 +4065,13 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
+	NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES	= 1 << 19,
+	NL80211_FEATURE_WFA_TPC_IE_IN_PROBES		= 1 << 20,
+	NL80211_FEATURE_QUIET				= 1 << 21,
+	NL80211_FEATURE_TX_POWER_INSERTION		= 1 << 22,
+	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
+	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
+	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
 };
 
 /**
@@ -4046,6 +4146,25 @@ enum nl80211_acl_policy {
 };
 
 /**
+ * enum nl80211_smps_mode - SMPS mode
+ *
+ * Requested SMPS mode (for AP mode)
+ *
+ * @NL80211_SMPS_OFF: SMPS off (use all antennas).
+ * @NL80211_SMPS_STATIC: static SMPS (use a single antenna)
+ * @NL80211_SMPS_DYNAMIC: dynamic smps (start with a single antenna and
+ *	turn on other antennas after CTS/RTS).
+ */
+enum nl80211_smps_mode {
+	NL80211_SMPS_OFF,
+	NL80211_SMPS_STATIC,
+	NL80211_SMPS_DYNAMIC,
+
+	__NL80211_SMPS_AFTER_LAST,
+	NL80211_SMPS_MAX = __NL80211_SMPS_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_radar_event - type of radar event for DFS operation
  *
  * Type of event to be used with NL80211_ATTR_RADAR_EVENT to inform userspace
-- 
1.8.3.1

