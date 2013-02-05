Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45316 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3BEPmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 10:42:00 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] iw: sync nl80211.h with kernel
Date: Tue, 5 Feb 2013 17:41:43 +0200
Message-ID: <1360078904-13056-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130205_164207_823832_3FE3972A)
In-Reply-To: <1360078904-13056-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1360078904-13056-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 nl80211.h |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 122 insertions(+), 5 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index e3e19f8..5c7d54c 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -170,7 +170,8 @@
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
+ *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT,
+ *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS.
  *	The channel to use can be set on the interface or be given using the
  *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
@@ -374,8 +375,8 @@
  *	requests to connect to a specified network but without separating
  *	auth and assoc steps. For this, you need to specify the SSID in a
  *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
- *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_MAC,
- *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
+ *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_USE_MFP,
+ *	%NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
  *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
  *	Background scan period can optionally be
@@ -586,6 +587,16 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_SET_MAC_ACL: sets ACL for MAC address based access control.
+ *	This is to be used with the drivers advertising the support of MAC
+ *	address based access control. List of MAC addresses is passed in
+ *	%NL80211_ATTR_MAC_ADDRS and ACL policy is passed in
+ *	%NL80211_ATTR_ACL_POLICY. Driver will enable ACL with this list, if it
+ *	is not already done. The new list will replace any existing list. Driver
+ *	will clear its ACL when the list of MAC addresses passed is empty. This
+ *	command is used in AP/P2P GO mode. Driver has to make sure to clear its
+ *	ACL list during %NL80211_CMD_STOP_AP.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -736,6 +747,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_SET_MAC_ACL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -958,7 +971,7 @@ enum nl80211_commands {
  * @NL80211_ATTR_USE_MFP: Whether management frame protection (IEEE 802.11w) is
  *	used for the association (&enum nl80211_mfp, represented as a u32);
  *	this attribute can be used
- *	with %NL80211_CMD_ASSOCIATE request
+ *	with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests
  *
  * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
  *	&struct nl80211_sta_flag_update.
@@ -1310,6 +1323,19 @@ enum nl80211_commands {
  *	if not given in START_AP 0 is assumed, if not given in SET_BSS
  *	no change is made.
  *
+ * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
+ *	defined in &enum nl80211_mesh_power_mode.
+ *
+ * @NL80211_ATTR_ACL_POLICY: ACL policy, see &enum nl80211_acl_policy,
+ *	carried in a u32 attribute
+ *
+ * @NL80211_ATTR_MAC_ADDRS: Array of nested MAC addresses, used for
+ *	MAC ACL.
+ *
+ * @NL80211_ATTR_MAC_ACL_MAX: u32 attribute to advertise the maximum
+ *	number of MAC addresses that a device can support for MAC
+ *	ACL.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1580,6 +1606,14 @@ enum nl80211_attrs {
 	NL80211_ATTR_P2P_CTWINDOW,
 	NL80211_ATTR_P2P_OPPPS,
 
+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
+
+	NL80211_ATTR_ACL_POLICY,
+
+	NL80211_ATTR_MAC_ADDRS,
+
+	NL80211_ATTR_MAC_ACL_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1697,6 +1731,9 @@ enum nl80211_iftype {
  *	flag can't be changed, it is only valid while adding a station, and
  *	attempts to change it will silently be ignored (rather than rejected
  *	as errors.)
+ * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with drivers
+ *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
+ *	previously added station into associated state
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1708,6 +1745,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
 	NL80211_STA_FLAG_TDLS_PEER,
+	NL80211_STA_FLAG_ASSOCIATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -1813,6 +1851,8 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
  * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
+ * @NL80211_STA_INFO_RX_BYTES64: total received bytes (u64, from this station)
+ * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (u64, to this station)
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_rate_info
@@ -1834,6 +1874,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
  * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
  * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
+ * @NL80211_STA_INFO_LOCAL_PM: local mesh STA link-specific power mode
+ * @NL80211_STA_INFO_PEER_PM: peer mesh STA link-specific power mode
+ * @NL80211_STA_INFO_NONPEER_PM: neighbor mesh STA power save mode towards
+ *	non-peer STA
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1858,6 +1902,11 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_STA_FLAGS,
 	NL80211_STA_INFO_BEACON_LOSS,
 	NL80211_STA_INFO_T_OFFSET,
+	NL80211_STA_INFO_LOCAL_PM,
+	NL80211_STA_INFO_PEER_PM,
+	NL80211_STA_INFO_NONPEER_PM,
+	NL80211_STA_INFO_RX_BYTES64,
+	NL80211_STA_INFO_TX_BYTES64,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2249,6 +2298,34 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enum nl80211_mesh_power_mode - mesh power save modes
+ *
+ * @NL80211_MESH_POWER_UNKNOWN: The mesh power mode of the mesh STA is
+ *	not known or has not been set yet.
+ * @NL80211_MESH_POWER_ACTIVE: Active mesh power mode. The mesh STA is
+ *	in Awake state all the time.
+ * @NL80211_MESH_POWER_LIGHT_SLEEP: Light sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but will wake up for
+ *	neighbor's beacons.
+ * @NL80211_MESH_POWER_DEEP_SLEEP: Deep sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but may not wake up
+ *	for neighbor's beacons.
+ *
+ * @__NL80211_MESH_POWER_AFTER_LAST - internal use
+ * @NL80211_MESH_POWER_MAX - highest possible power save level
+ */
+
+enum nl80211_mesh_power_mode {
+	NL80211_MESH_POWER_UNKNOWN,
+	NL80211_MESH_POWER_ACTIVE,
+	NL80211_MESH_POWER_LIGHT_SLEEP,
+	NL80211_MESH_POWER_DEEP_SLEEP,
+
+	__NL80211_MESH_POWER_AFTER_LAST,
+	NL80211_MESH_POWER_MAX = __NL80211_MESH_POWER_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
@@ -2342,6 +2419,11 @@ enum nl80211_mntr_flags {
  *	(in TUs) during which a mesh STA can send only one Action frame
  *	containing a PREQ element for root path confirmation.
  *
+ * @NL80211_MESHCONF_POWER_MODE: Default mesh power mode for new peer links.
+ *	type &enum nl80211_mesh_power_mode (u32)
+ *
+ * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2371,6 +2453,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
 	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	NL80211_MESHCONF_POWER_MODE,
+	NL80211_MESHCONF_AWAKE_WINDOW,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
@@ -2933,6 +3017,8 @@ enum nl80211_iface_limit_attrs {
  *	the infrastructure network's beacon interval.
  * @NL80211_IFACE_COMB_NUM_CHANNELS: u32 attribute specifying how many
  *	different channels may be used within this group.
+ * @NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS: u32 attribute containing the bitmap
+ *	of supported channel widths for radar detection.
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -2965,6 +3051,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_MAXNUM,
 	NL80211_IFACE_COMB_STA_AP_BI_MATCH,
 	NL80211_IFACE_COMB_NUM_CHANNELS,
+	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
@@ -3140,6 +3227,17 @@ enum nl80211_ap_sme_features {
  *	setting
  * @NL80211_FEATURE_P2P_GO_OPPPS: P2P GO implementation supports opportunistic
  *	powersave
+ * @NL80211_FEATURE_FULL_AP_CLIENT_STATE: The driver supports full state
+ *	transitions for AP clients. Without this flag (and if the driver
+ *	doesn't have the AP SME in the device) the driver supports adding
+ *	stations only when they're associated and adds them in associated
+ *	state (to later be transitioned into authorized), with this flag
+ *	they should be added before even sending the authentication reply
+ *	and then transitioned into authenticated, associated and authorized
+ *	states using station flags.
+ *	Note that even for drivers that support this, the default is to add
+ *	stations in authenticated/associated state, so to add unauthenticated
+ *	stations the authenticated/associated bits have to be set in the mask.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3155,6 +3253,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_NEED_OBSS_SCAN			= 1 << 10,
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
+	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
 };
 
 /**
@@ -3182,7 +3281,7 @@ enum nl80211_probe_resp_offload_support_attr {
  * enum nl80211_connect_failed_reason - connection request failed reasons
  * @NL80211_CONN_FAIL_MAX_CLIENTS: Maximum number of clients that can be
  *	handled by the AP is reached.
- * @NL80211_CONN_FAIL_BLOCKED_CLIENT: Client's MAC is in the AP's blocklist.
+ * @NL80211_CONN_FAIL_BLOCKED_CLIENT: Connection request is rejected due to ACL.
  */
 enum nl80211_connect_failed_reason {
 	NL80211_CONN_FAIL_MAX_CLIENTS,
@@ -3210,4 +3309,22 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 };
 
+/**
+ * enum nl80211_acl_policy - access control policy
+ *
+ * Access control policy is applied on a MAC list set by
+ * %NL80211_CMD_START_AP and %NL80211_CMD_SET_MAC_ACL, to
+ * be used with %NL80211_ATTR_ACL_POLICY.
+ *
+ * @NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED: Deny stations which are
+ *	listed in ACL, i.e. allow all the stations which are not listed
+ *	in ACL to authenticate.
+ * @NL80211_ACL_POLICY_DENY_UNLESS_LISTED: Allow the stations which are listed
+ *	in ACL, i.e. deny all the stations which are not listed in ACL.
+ */
+enum nl80211_acl_policy {
+	NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED,
+	NL80211_ACL_POLICY_DENY_UNLESS_LISTED,
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
1.7.10.4

