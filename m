Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:32872 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752575AbeC3Upx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 16:45:53 -0400
Received: by mail-lf0-f47.google.com with SMTP id x70-v6so7006102lfa.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2018 13:45:52 -0700 (PDT)
From: Dmitry Lebed <lebed.dmitry@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH 1/2] update nl80211.h
Date: Fri, 30 Mar 2018 23:45:08 +0300
Message-Id: <20180330204509.4395-1-lebed.dmitry@gmail.com> (sfid-20180330_224559_459216_60FF8ED9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dmitry Lebed <lebed.dmitry@gmail.com>
---
 nl80211.h | 136 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 2 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index c587a61..15daf5e 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -542,7 +542,8 @@
  *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_USE_MFP,
  *	%NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
- *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT, %NL80211_ATTR_MAC_HINT, and
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT,
+ *	%NL80211_ATTR_CONTROL_PORT_OVER_NL80211, %NL80211_ATTR_MAC_HINT, and
  *	%NL80211_ATTR_WIPHY_FREQ_HINT.
  *	If included, %NL80211_ATTR_MAC and %NL80211_ATTR_WIPHY_FREQ are
  *	restrictions on BSS selection, i.e., they effectively prevent roaming
@@ -990,8 +991,45 @@
  *	&NL80211_CMD_CONNECT or &NL80211_CMD_ROAM. If the 4 way handshake failed
  *	&NL80211_CMD_DISCONNECT should be indicated instead.
  *
+ * @NL80211_CMD_CONTROL_PORT_FRAME: Control Port (e.g. PAE) frame TX request
+ *	and RX notification.  This command is used both as a request to transmit
+ *	a control port frame and as a notification that a control port frame
+ *	has been received. %NL80211_ATTR_FRAME is used to specify the
+ *	frame contents.  The frame is the raw EAPoL data, without ethernet or
+ *	802.11 headers.
+ *	When used as an event indication %NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT and %NL80211_ATTR_MAC are added
+ *	indicating the protocol type of the received frame; whether the frame
+ *	was received unencrypted and the MAC address of the peer respectively.
+ *
  * @NL80211_CMD_RELOAD_REGDB: Request that the regdb firmware file is reloaded.
  *
+ * @NL80211_CMD_EXTERNAL_AUTH: This interface is exclusively defined for host
+ *	drivers that do not define separate commands for authentication and
+ *	association, but rely on user space for the authentication to happen.
+ *	This interface acts both as the event request (driver to user space)
+ *	to trigger the authentication and command response (userspace to
+ *	driver) to indicate the authentication status.
+ *
+ *	User space uses the %NL80211_CMD_CONNECT command to the host driver to
+ *	trigger a connection. The host driver selects a BSS and further uses
+ *	this interface to offload only the authentication part to the user
+ *	space. Authentication frames are passed between the driver and user
+ *	space through the %NL80211_CMD_FRAME interface. Host driver proceeds
+ *	further with the association after getting successful authentication
+ *	status. User space indicates the authentication status through
+ *	%NL80211_ATTR_STATUS_CODE attribute in %NL80211_CMD_EXTERNAL_AUTH
+ *	command interface.
+ *
+ *	Host driver reports this status on an authentication failure to the
+ *	user space through the connect result as the user space would have
+ *	initiated the connection through the connect request.
+ *
+ * @NL80211_CMD_STA_OPMODE_CHANGED: An event that notify station's
+ *	ht opmode or vht opmode changes using any of &NL80211_ATTR_SMPS_MODE,
+ *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
+ *	address(specified in &NL80211_ATTR_MAC).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1198,6 +1236,12 @@ enum nl80211_commands {
 
 	NL80211_CMD_RELOAD_REGDB,
 
+	NL80211_CMD_EXTERNAL_AUTH,
+
+	NL80211_CMD_STA_OPMODE_CHANGED,
+
+	NL80211_CMD_CONTROL_PORT_FRAME,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1445,6 +1489,15 @@ enum nl80211_commands {
  * @NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT: When included along with
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE, indicates that the custom
  *	ethertype frames used for key negotiation must not be encrypted.
+ * @NL80211_ATTR_CONTROL_PORT_OVER_NL80211: A flag indicating whether control
+ *	port frames (e.g. of type given in %NL80211_ATTR_CONTROL_PORT_ETHERTYPE)
+ *	will be sent directly to the network interface or sent via the NL80211
+ *	socket.  If this attribute is missing, then legacy behavior of sending
+ *	control port frames directly to the network interface is used.  If the
+ *	flag is included, then control port frames are sent over NL80211 instead
+ *	using %CMD_CONTROL_PORT_FRAME.  If control port routing over NL80211 is
+ *	to be used then userspace must also use the %NL80211_ATTR_SOCKET_OWNER
+ *	flag.
  *
  * @NL80211_ATTR_TESTDATA: Testmode data blob, passed through to the driver.
  *	We recommend using nested, driver-specific attributes within this.
@@ -1932,6 +1985,12 @@ enum nl80211_commands {
  *	multicast group.
  *	If set during %NL80211_CMD_ASSOCIATE or %NL80211_CMD_CONNECT the
  *	station will deauthenticate when the socket is closed.
+ *	If set during %NL80211_CMD_JOIN_IBSS the IBSS will be automatically
+ *	torn down when the socket is closed.
+ *	If set during %NL80211_CMD_JOIN_MESH the mesh setup will be
+ *	automatically torn down when the socket is closed.
+ *	If set during %NL80211_CMD_START_AP the AP will be automatically
+ *	disabled when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
@@ -2153,6 +2212,19 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
  * @NL80211_ATTR_PORT_AUTHORIZED: (reserved)
  *
+ * @NL80211_ATTR_EXTERNAL_AUTH_ACTION: Identify the requested external
+ *     authentication operation (u32 attribute with an
+ *     &enum nl80211_external_auth_action value). This is used with the
+ *     &NL80211_CMD_EXTERNAL_AUTH request event.
+ * @NL80211_ATTR_EXTERNAL_AUTH_SUPPORT: Flag attribute indicating that the user
+ *     space supports external authentication. This attribute shall be used
+ *     only with %NL80211_CMD_CONNECT request. The driver may offload
+ *     authentication processing to user space if this capability is indicated
+ *     in NL80211_CMD_CONNECT requests from the user space.
+ *
+ * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
+ *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2579,6 +2651,14 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKR0_NAME,
 	NL80211_ATTR_PORT_AUTHORIZED,
 
+	NL80211_ATTR_EXTERNAL_AUTH_ACTION,
+	NL80211_ATTR_EXTERNAL_AUTH_SUPPORT,
+
+	NL80211_ATTR_NSS,
+	NL80211_ATTR_ACK_SIGNAL,
+
+	NL80211_ATTR_CONTROL_PORT_OVER_NL80211,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2899,6 +2979,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_RX_DURATION: aggregate PPDU duration for all frames
  *	received from the station (u64, usec)
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
+ * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2937,6 +3018,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TID_STATS,
 	NL80211_STA_INFO_RX_DURATION,
 	NL80211_STA_INFO_PAD,
+	NL80211_STA_INFO_ACK_SIGNAL,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -4945,6 +5027,17 @@ enum nl80211_feature_flags {
  *	probe request tx deferral and suppression
  * @NL80211_EXT_FEATURE_MFP_OPTIONAL: Driver supports the %NL80211_MFP_OPTIONAL
  *	value in %NL80211_ATTR_USE_MFP.
+ * @NL80211_EXT_FEATURE_LOW_SPAN_SCAN: Driver supports low span scan.
+ * @NL80211_EXT_FEATURE_LOW_POWER_SCAN: Driver supports low power scan.
+ * @NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN: Driver supports high accuracy scan.
+ * @NL80211_EXT_FEATURE_DFS_OFFLOAD: HW/driver will offload DFS actions.
+ *	Device or driver will do all DFS-related actions by itself,
+ *	informing user-space about CAC progress, radar detection event,
+ *	channel change triggered by radar detection event.
+ *	No need to start CAC from user-space, no need to react to
+ *	"radar detected" event.
+ * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports sending and
+ *	receiving control port frames over nl80211 instead of the netdevice.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4972,6 +5065,11 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
 	NL80211_EXT_FEATURE_MFP_OPTIONAL,
+	NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
+	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
+	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
+	NL80211_EXT_FEATURE_DFS_OFFLOAD,
+	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5032,6 +5130,10 @@ enum nl80211_timeout_reason {
  * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
  * requests.
  *
+ * NL80211_SCAN_FLAG_LOW_SPAN, NL80211_SCAN_FLAG_LOW_POWER, and
+ * NL80211_SCAN_FLAG_HIGH_ACCURACY flags are exclusive of each other, i.e., only
+ * one of them can be used in the request.
+ *
  * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
  * @NL80211_SCAN_FLAG_AP: force a scan even if the interface is configured
@@ -5059,7 +5161,20 @@ enum nl80211_timeout_reason {
  *	and suppression (if it has received a broadcast Probe Response frame,
  *	Beacon frame or FILS Discovery frame from an AP that the STA considers
  *	a suitable candidate for (re-)association - suitable in terms of
- *	SSID and/or RSSI
+ *	SSID and/or RSSI.
+ * @NL80211_SCAN_FLAG_LOW_SPAN: Span corresponds to the total time taken to
+ *	accomplish the scan. Thus, this flag intends the driver to perform the
+ *	scan request with lesser span/duration. It is specific to the driver
+ *	implementations on how this is accomplished. Scan accuracy may get
+ *	impacted with this flag.
+ * @NL80211_SCAN_FLAG_LOW_POWER: This flag intends the scan attempts to consume
+ *	optimal possible power. Drivers can resort to their specific means to
+ *	optimize the power. Scan accuracy may get impacted with this flag.
+ * @NL80211_SCAN_FLAG_HIGH_ACCURACY: Accuracy here intends to the extent of scan
+ *	results obtained. Thus HIGH_ACCURACY scan flag aims to get maximum
+ *	possible scan results. This flag hints the driver to use the best
+ *	possible scan configuration to improve the accuracy in scanning.
+ *	Latency and power use may get impacted with this flag.
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY				= 1<<0,
@@ -5070,6 +5185,9 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_ACCEPT_BCAST_PROBE_RESP		= 1<<5,
 	NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE		= 1<<6,
 	NL80211_SCAN_FLAG_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION	= 1<<7,
+	NL80211_SCAN_FLAG_LOW_SPAN				= 1<<8,
+	NL80211_SCAN_FLAG_LOW_POWER				= 1<<9,
+	NL80211_SCAN_FLAG_HIGH_ACCURACY				= 1<<10,
 };
 
 /**
@@ -5127,6 +5245,8 @@ enum nl80211_smps_mode {
  *	non-operating channel is expired and no longer valid. New CAC must
  *	be done on this channel before starting the operation. This is not
  *	applicable for ETSI dfs domain where pre-CAC is valid for ever.
+ * @NL80211_RADAR_CAC_STARTED: Channel Availability Check has been started,
+ *	should be generated by HW if NL80211_EXT_FEATURE_DFS_OFFLOAD is enabled.
  */
 enum nl80211_radar_event {
 	NL80211_RADAR_DETECTED,
@@ -5134,6 +5254,7 @@ enum nl80211_radar_event {
 	NL80211_RADAR_CAC_ABORTED,
 	NL80211_RADAR_NOP_FINISHED,
 	NL80211_RADAR_PRE_CAC_EXPIRED,
+	NL80211_RADAR_CAC_STARTED,
 };
 
 /**
@@ -5469,4 +5590,15 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };
 
+/**
+ * nl80211_external_auth_action - Action to perform with external
+ *     authentication request. Used by NL80211_ATTR_EXTERNAL_AUTH_ACTION.
+ * @NL80211_EXTERNAL_AUTH_START: Start the authentication.
+ * @NL80211_EXTERNAL_AUTH_ABORT: Abort the ongoing authentication.
+ */
+enum nl80211_external_auth_action {
+	NL80211_EXTERNAL_AUTH_START,
+	NL80211_EXTERNAL_AUTH_ABORT,
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
2.16.3
