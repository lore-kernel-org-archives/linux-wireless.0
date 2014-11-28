Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47837 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751172AbaK1VGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 16:06:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 23:05:54 +0200
Message-Id: <1417208756-14839-2-git-send-email-luca@coelho.fi> (sfid-20141128_220616_474128_86651083)
In-Reply-To: <1417208756-14839-1-git-send-email-luca@coelho.fi>
References: <1417208756-14839-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw v3 1/3] update nl80211.h
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 nl80211.h | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 115 insertions(+), 4 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index f7daae5..d775245 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -643,7 +643,18 @@
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ and the
- *	attributes determining channel width.
+ *	attributes determining channel width.  This indication may also be
+ *	sent when a remotely-initiated switch (e.g., when a STA receives a CSA
+ *	from the remote AP) is completed;
+ *
+ * @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY: Notify that a channel switch
+ *	has been started on an interface, regardless of the initiator
+ *	(ie. whether it was requested from a remote device or
+ *	initiated on our own).  It indicates that
+ *	%NL80211_ATTR_IFINDEX will be on %NL80211_ATTR_WIPHY_FREQ
+ *	after %NL80211_ATTR_CH_SWITCH_COUNT TBTT's.  The userspace may
+ *	decide to react to this indication by requesting other
+ *	interfaces to change channel as well.
  *
  * @NL80211_CMD_START_P2P_DEVICE: Start the given P2P Device, identified by
  *	its %NL80211_ATTR_WDEV identifier. It must have been created with
@@ -746,6 +757,23 @@
  *	destination %NL80211_ATTR_MAC on the interface identified by
  *	%NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_JOIN_OCB: Join the OCB network. The center frequency and
+ *	bandwidth of a channel must be given.
+ * @NL80211_CMD_LEAVE_OCB: Leave the OCB network -- no special arguments, the
+ *	network is determined by the network interface.
+ *
+ * @NL80211_CMD_TDLS_CHANNEL_SWITCH: Start channel-switching with a TDLS peer,
+ *	identified by the %NL80211_ATTR_MAC parameter. A target channel is
+ *	provided via %NL80211_ATTR_WIPHY_FREQ and other attributes determining
+ *	channel width/type. The target operating class is given via
+ *	%NL80211_ATTR_OPER_CLASS.
+ *	The driver is responsible for continually initiating channel-switching
+ *	operations and returning to the base channel for communication with the
+ *	AP.
+ * @NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH: Stop channel-switching with a TDLS
+ *	peer given by %NL80211_ATTR_MAC. Both peers must be on the base channel
+ *	when this command completes.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -922,6 +950,14 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_MPP,
 
+	NL80211_CMD_JOIN_OCB,
+	NL80211_CMD_LEAVE_OCB,
+
+	NL80211_CMD_CH_SWITCH_STARTED_NOTIFY,
+
+	NL80211_CMD_TDLS_CHANNEL_SWITCH,
+	NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1616,9 +1652,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_PEER_CAPABILITY: flags for TDLS peer capabilities, u32.
  *	As specified in the &enum nl80211_tdls_peer_capability.
  *
- * @NL80211_ATTR_IFACE_SOCKET_OWNER: flag attribute, if set during interface
+ * @NL80211_ATTR_SOCKET_OWNER: Flag attribute, if set during interface
  *	creation then the new interface will be owned by the netlink socket
- *	that created it and will be destroyed when the socket is closed
+ *	that created it and will be destroyed when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
@@ -1648,6 +1684,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *	&enum nl80211_smps_mode.
  *
+ * @NL80211_ATTR_OPER_CLASS: operating class
+ *
+ * @NL80211_ATTR_MAC_MASK: MAC address mask
+ *
+ * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1983,7 +2024,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_PEER_CAPABILITY,
 
-	NL80211_ATTR_IFACE_SOCKET_OWNER,
+	NL80211_ATTR_SOCKET_OWNER,
 
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
@@ -2000,15 +2041,21 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMPS_MODE,
 
+	NL80211_ATTR_OPER_CLASS,
+
+	NL80211_ATTR_MAC_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
+	NUM_NL80211_ATTR = __NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
 /* source-level API compatibility */
 #define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
 #define	NL80211_ATTR_MESH_PARAMS NL80211_ATTR_MESH_CONFIG
+#define NL80211_ATTR_IFACE_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
 
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
@@ -2074,6 +2121,8 @@ enum nl80211_attrs {
  *	and therefore can't be created in the normal ways, use the
  *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
  *	commands to create and destroy one
+ * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
+ *	This mode corresponds to the MIB variable dot11OCBActivated=true
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2093,6 +2142,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
+	NL80211_IFTYPE_OCB,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
@@ -2641,6 +2691,11 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
  *	base on contiguous rules and wider channels will be allowed to cross
  *	multiple contiguous/overlapping frequency ranges.
+ * @NL80211_RRF_GO_CONCURRENT: See &NL80211_FREQUENCY_ATTR_GO_CONCURRENT
+ * @NL80211_RRF_NO_HT40MINUS: channels can't be used in HT40- operation
+ * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
+ * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
+ * @NL80211_RRF_NO_160MHZ: 160MHz operation not allowed
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2653,11 +2708,18 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_IR		= 1<<7,
 	__NL80211_RRF_NO_IBSS		= 1<<8,
 	NL80211_RRF_AUTO_BW		= 1<<11,
+	NL80211_RRF_GO_CONCURRENT	= 1<<12,
+	NL80211_RRF_NO_HT40MINUS	= 1<<13,
+	NL80211_RRF_NO_HT40PLUS		= 1<<14,
+	NL80211_RRF_NO_80MHZ		= 1<<15,
+	NL80211_RRF_NO_160MHZ		= 1<<16,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
 #define NL80211_RRF_NO_IBSS		NL80211_RRF_NO_IR
 #define NL80211_RRF_NO_IR		NL80211_RRF_NO_IR
+#define NL80211_RRF_NO_HT40		(NL80211_RRF_NO_HT40MINUS |\
+					 NL80211_RRF_NO_HT40PLUS)
 
 /* For backport compatibility with older userspace */
 #define NL80211_RRF_NO_IR_ALL		(NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
@@ -3555,6 +3617,25 @@ struct nl80211_pattern_support {
  * @NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS: For wakeup reporting only,
  *	the TCP connection ran out of tokens to use for data to send to the
  *	service
+ * @NL80211_WOWLAN_TRIG_NET_DETECT: wake up when a configured network
+ *	is detected.  This is a nested attribute that contains the
+ *	same attributes used with @NL80211_CMD_START_SCHED_SCAN.  It
+ *	specifies how the scan is performed (e.g. the interval and the
+ *	channels to scan) as well as the scan results that will
+ *	trigger a wake (i.e. the matchsets).
+ * @NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS: nested attribute
+ *	containing an array with information about what triggered the
+ *	wake up.  If no elements are present in the array, it means
+ *	that the information is not available.  If more than one
+ *	element is present, it means that more than one match
+ *	occurred.
+ *	Each element in the array is a nested attribute that contains
+ *	one optional %NL80211_ATTR_SSID attribute and one optional
+ *	%NL80211_ATTR_SCAN_FREQUENCIES attribute.  At least one of
+ *	these attributes must be present.  If
+ *	%NL80211_ATTR_SCAN_FREQUENCIES contains more than one
+ *	frequency, it means that the match occurred in more than one
+ *	channel.
  * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
  * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
  *
@@ -3580,6 +3661,8 @@ enum nl80211_wowlan_triggers {
 	NL80211_WOWLAN_TRIG_WAKEUP_TCP_MATCH,
 	NL80211_WOWLAN_TRIG_WAKEUP_TCP_CONNLOST,
 	NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS,
+	NL80211_WOWLAN_TRIG_NET_DETECT,
+	NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS,
 
 	/* keep last */
 	NUM_NL80211_WOWLAN_TRIG,
@@ -4059,6 +4142,20 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
  *	the vif's MAC address upon creation.
  *	See 'macaddr' field in the vif_params (cfg80211.h).
+ * @NL80211_FEATURE_TDLS_CHANNEL_SWITCH: Driver supports channel switching when
+ *	operating as a TDLS peer.
+ * @NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports using a
+ *	random MAC address during scan (if the device is unassociated); the
+ *	%NL80211_SCAN_FLAG_RANDOM_ADDR flag may be set for scans and the MAC
+ *	address mask/value will be used.
+ * @NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR: This device/driver supports
+ *	using a random MAC address for every scan iteration during scheduled
+ *	scan (while not associated), the %NL80211_SCAN_FLAG_RANDOM_ADDR may
+ *	be set for scheduled scan and the MAC address mask/value will be used.
+ * @NL80211_FEATURE_ND_RANDOM_MAC_ADDR: This device/driver supports using a
+ *	random MAC address for every scan iteration during "net detect", i.e.
+ *	scan in unassociated WoWLAN, the %NL80211_SCAN_FLAG_RANDOM_ADDR may
+ *	be set for scheduled scan and the MAC address mask/value will be used.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4089,6 +4186,10 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
 	NL80211_FEATURE_SUPPORTS_WMM_ADMISSION		= 1 << 26,
 	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 27,
+	NL80211_FEATURE_TDLS_CHANNEL_SWITCH		= 1 << 28,
+	NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR		= 1 << 29,
+	NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR	= 1 << 30,
+	NL80211_FEATURE_ND_RANDOM_MAC_ADDR		= 1 << 31,
 };
 
 /**
@@ -4137,11 +4238,21 @@ enum nl80211_connect_failed_reason {
  *	dangerous because will destroy stations performance as a lot of frames
  *	will be lost while scanning off-channel, therefore it must be used only
  *	when really needed
+ * @NL80211_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (or
+ *	for scheduled scan: a different one for every scan iteration). When the
+ *	flag is set, depending on device capabilities the @NL80211_ATTR_MAC and
+ *	@NL80211_ATTR_MAC_MASK attributes may also be given in which case only
+ *	the masked bits will be preserved from the MAC address and the remainder
+ *	randomised. If the attributes are not given full randomisation (46 bits,
+ *	locally administered 1, multicast 0) is assumed.
+ *	This flag must not be requested when the feature isn't supported, check
+ *	the nl80211 feature flags for the device.
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 	NL80211_SCAN_FLAG_AP				= 1<<2,
+	NL80211_SCAN_FLAG_RANDOM_ADDR			= 1<<3,
 };
 
 /**
-- 
2.1.3

