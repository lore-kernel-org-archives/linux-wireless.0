Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47211 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KRLCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:02:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv3 1/2] iw: import latest nl80211.h with new commands
Date: Fri, 18 Nov 2011 12:01:49 +0100
Message-Id: <1321614110-32392-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111118_120217_364330_38A1A33F)
In-Reply-To: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 nl80211.h |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 8049bf7..b99e50d 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -509,6 +509,38 @@
  * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
  * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
  *
+ * @NL80211_CMD_UNEXPECTED_FRAME: Used by an application controlling an AP
+ *	(or GO) interface (i.e. hostapd) to ask for unexpected frames to
+ *	implement sending deauth to stations that send unexpected class 3
+ *	frames. Also used as the event sent by the kernel when such a frame
+ *	is received.
+ *	For the event, the %NL80211_ATTR_MAC attribute carries the TA and
+ *	other attributes like the interface index are present.
+ *	If used as the command it must have an interface index and you can
+ *	only unsubscribe from the event by closing the socket. Subscription
+ *	is also for %NL80211_CMD_UNEXPECTED_4ADDR_FRAME events.
+ *
+ * @NL80211_CMD_UNEXPECTED_4ADDR_FRAME: Sent as an event indicating that the
+ *	associated station identified by %NL80211_ATTR_MAC sent a 4addr frame
+ *	and wasn't already in a 4-addr VLAN. The event will be sent similarly
+ *	to the %NL80211_CMD_UNEXPECTED_FRAME event, to the same listener.
+ *
+ * @NL80211_CMD_PROBE_CLIENT: Probe an associated station on an AP interface
+ *	by sending a null data frame to it and reporting when the frame is
+ *	acknowleged. This is used to allow timing out inactive clients. Uses
+ *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_MAC. The command returns a
+ *	direct reply with an %NL80211_ATTR_COOKIE that is later used to match
+ *	up the event with the request. The event includes the same data and
+ *	has %NL80211_ATTR_ACK set if the frame was ACKed.
+ *
+ * @NL80211_CMD_REGISTER_BEACONS: Register this socket to receive beacons from
+ *	other BSSes when any interfaces are in AP mode. This helps implement
+ *	OLBC handling in hostapd. Beacons are reported in %NL80211_CMD_FRAME
+ *	messages. Note that per PHY only one application may register.
+ *
+ * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
+ *      No Acknowledgement Policy should be applied.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -638,6 +670,16 @@ enum nl80211_commands {
 	NL80211_CMD_TDLS_OPER,
 	NL80211_CMD_TDLS_MGMT,
 
+	NL80211_CMD_UNEXPECTED_FRAME,
+
+	NL80211_CMD_PROBE_CLIENT,
+
+	NL80211_CMD_REGISTER_BEACONS,
+
+	NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
+
+	NL80211_CMD_SET_NOACK_MAP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -658,6 +700,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
+#define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
+
 /* source-level API compatibility */
 #define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
 #define NL80211_CMD_SET_MESH_PARAMS NL80211_CMD_SET_MESH_CONFIG
@@ -1109,6 +1153,31 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DEVICE_AP_SME: This u32 attribute may be listed for devices
+ *	that have AP support to indicate that they have the AP SME integrated
+ *	with support for the features listed in this attribute, see
+ *	&enum nl80211_ap_sme_features.
+ *
+ * @NL80211_ATTR_DONT_WAIT_FOR_ACK: Used with %NL80211_CMD_FRAME, this tells
+ *	the driver to not wait for an acknowledgement. Note that due to this,
+ *	it will also not give a status callback nor return a cookie. This is
+ *	mostly useful for probe responses to save airtime.
+ *
+ * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
+ *	&enum nl80211_feature_flags and is advertised in wiphy information.
+ * @NL80211_ATTR_PROBE_RESP_OFFLOAD: Indicates that the HW responds to probe
+ *
+ *	requests while operating in AP-mode.
+ *	This attribute holds a bitmap of the supported protocols for
+ *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
+ *
+ * @NL80211_ATTR_PROBE_RESP: Probe Response template data. Contains the entire
+ *	probe-response frame. The DA field in the 802.11 header is zero-ed out,
+ *	to be filled by the FW.
+ *
+ * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
+ *      up to 16 TIDs.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1406,18 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DEVICE_AP_SME,
+
+	NL80211_ATTR_DONT_WAIT_FOR_ACK,
+
+	NL80211_ATTR_FEATURE_FLAGS,
+
+	NL80211_ATTR_PROBE_RESP_OFFLOAD,
+
+	NL80211_ATTR_PROBE_RESP,
+
+	NL80211_ATTR_NOACK_MAP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1371,6 +1452,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_AKM_SUITES NL80211_ATTR_AKM_SUITES
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
+#define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -2650,4 +2732,43 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_DISABLE_LINK,
 };
 
+/*
+ * enum nl80211_ap_sme_features - device-integrated AP features
+ * Reserved for future use, no bits are defined in
+ * NL80211_ATTR_DEVICE_AP_SME yet.
+enum nl80211_ap_sme_features {
+};
+ */
+
+/**
+ * enum nl80211_feature_flags - device/driver features
+ * @NL80211_FEATURE_SK_TX_STATUS: This driver supports reflecting back
+ *	TX status to the socket error queue when requested with the
+ *	socket option.
+ */
+enum nl80211_feature_flags {
+	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
+};
+
+/**
+ * enum nl80211_probe_resp_offload_support_attr - optional supported
+ *	protocols for probe-response offloading by the driver/FW.
+ *	To be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD attribute.
+ *	Each enum value represents a bit in the bitmap of supported
+ *	protocols. Typically a subset of probe-requests belonging to a
+ *	supported protocol will be excluded from offload and uploaded
+ *	to the host.
+ *
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS: Support for WPS ver. 1
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2: Support for WPS ver. 2
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P: Support for P2P
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U: Support for 802.11u
+ */
+enum nl80211_probe_resp_offload_support_attr {
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS =	1<<0,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 =	1<<1,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P =	1<<2,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
1.7.7.3

