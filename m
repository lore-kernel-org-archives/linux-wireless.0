Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXCWOIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 10:08:14 -0400
Subject: [PATCH] cfg80211/nl80211 updates
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 15:06:52 +0100
Message-Id: <1174658812.3366.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a whole bunch of new nl80211 commands and removes the
configure call since I have decided that simply passing all required
parameters along with the associate call is much better since it doesn't
require a transaction layer in the kernel.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/ieee80211.h  |   12 
 include/linux/nl80211.h    |  420 +++++++++++++++++----------------
 include/net/cfg80211.h     |  146 +++++------
 include/net/wireless.h     |    1 
 net/mac80211/ieee80211_i.h |    2 
 net/wireless/nl80211.c     |  571 +++++++++++++++++----------------------------
 net/wireless/wext-compat.c |   30 --
 7 files changed, 520 insertions(+), 662 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-03-23 11:19:34.033431747 +0100
+++ wireless-dev/include/linux/nl80211.h	2007-03-23 11:19:35.293431747 +0100
@@ -6,266 +6,237 @@
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
  */
 
-/* currently supported commands
- * don't change the order or add anything inbetween, this is ABI! */
-enum {
-	/* There's no technical reason to not use command 0 but malformed
-	 * zeroed messages may have it and this catches that */
+/**
+ * enum nl80211_commands - supported nl80211 commands
+ * @NL80211_CMD_UNSPEC: unspecified command to catch errors
+ * @NL80211_CMD_RENAME_WIPHY: rename a wiphy, needs
+ *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME
+ * @NL80211_CMD_WIPHY_NEWNAME: rename notification
+ * @NL80211_CMD_GET_CMDLIST: TO BE DEFINED PROPERLY. currently the code makes
+ *	it depend on the wiphy only but it really should depend on the
+ *	interface type too....
+ * @NL80211_CMD_NEW_CMDLIST: command list result
+ * @NL80211_CMD_ADD_VIRTUAL_INTERFACE: create a virtual interface for the
+ *	wiphy identified by an %NL80211_ATTR_WIPHY attribute with the given
+ *	%NL80211_ATTR_IFTYPE and %NL80211_ATTR_IFNAME.
+ * @NL80211_CMD_DEL_VIRTUAL_INTERFACE: destroy a virtual interface identified
+ *	by %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_CHANGE_VIRTUAL_INTERFACE: change type of virtual interface to
+ *	the type given by %NL80211_ATTR_IFTYPE, the interface is identified by
+ *	%NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_GET_WIPHYS: request a list of all wiphys present in the system
+ * @NL80211_CMD_NEW_WIPHYS: returned list of all wiphys
+ * @NL80211_CMD_GET_INTERFACES: request a list of all interfaces belonging to
+ *	the wiphy identified by %NL80211_ATTR_WIPHY
+ * @NL80211_CMD_NEW_INTERFACES: result for %NL80211_CMD_GET_INTERFACES
+ * @NL80211_CMD_INITIATE_SCAN: initiate a scan with the passed parameters. THe
+ *	parameters may contain %NL80211_ATTR_FLAG_SCAN_ACTIVE,
+ *	%NL80211_ATTR_PHYMODE and a list of channels in an
+ *	%NL80211_ATTR_CHANNEL_LIST attribute (an array of nested attributes)
+ *	containing %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE, and possibly
+ *	%NL80211_ATTR_FLAG_SCAN_ACTIVE. The outer %NL80211_ATTR_FLAG_SCAN_ACTIVE
+ *	is ignored when a channel list is present.
+ * @NL80211_CMD_SCAN_RESULT: scan result, contains an array in
+ *	%NL80211_ATTR_BSS_LIST.
+ * @NL80211_CMD_ASSOCIATE: associate with the given parameters
+ *	(%NL80211_ATTR_SSID is mandatory, %NL80211_ATTR_TIMEOUT_TU,
+ *	%NL80211_ATTR_BSSID, %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE,
+ *	and %NL80211_ATTR_IE may be given)
+ * @NL80211_CMD_ADD_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
+ * 	%NL80211_ATTR_KEY_ID, %NL80211_ATTR_KEY_TYPE, %NL80211_ATTR_MAC and
+ *	%NL80211_ATTR_KEY_CIPHER attributes.
+ * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_ID,
+ *	%NL80211_ATTR_KEY_TYPE and %NL80211_ATTR_MAC or all keys.
+ * @__NL80211_CMD_AFTER_LAST: internal use
+ */
+enum nl80211_commands {
+/* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_CMD_UNSPEC,
-
-	/* Get supported commands by ifindex,
-	 * uses NL80211_ATTR_CMDS (output) and NL80211_ATTR_IFINDEX (input) */
+	/* %input: wiphy, wiphy_name */
+	NL80211_CMD_RENAME_WIPHY,
+	NL80211_CMD_WIPHY_NEWNAME,
+	/* %input: wiphy|ifindex */
 	NL80211_CMD_GET_CMDLIST,
-
-	/* Supported commands returned */
 	NL80211_CMD_NEW_CMDLIST,
-
-	/* Inject a frame using NL80211_ATTR_FLAGS and NL80211_ATTR_FRAME.
-	 * If kernel sends this, it's a status notification for the injected
-	 * frame. */
-	NL80211_CMD_INJECT,
-
-	/* add a virtual interface to a group that is identified by any
-	 * other ifindex in the group of a wiphy index, needs the
-	 * NL80211_IF_NAME attribute */
+	/* %input: wiphy, ifname, {iftype} */
 	NL80211_CMD_ADD_VIRTUAL_INTERFACE,
-
-	/* remove a given (with NL80211_ATTR_IFINDEX) virtual device */
+	/* %input: wiphy, ifindex */
 	NL80211_CMD_DEL_VIRTUAL_INTERFACE,
-
-	/* get list of all wiphys */
+	/* %input: ifindex, iftype */
+	NL80211_CMD_CHANGE_VIRTUAL_INTERFACE,
+	/* %input: */
 	NL80211_CMD_GET_WIPHYS,
-
-	/* get list of all wiphys */
 	NL80211_CMD_NEW_WIPHYS,
-
-	/* get list of all interfaces belonging to a wiphy */
+	/* %input: wiphy */
 	NL80211_CMD_GET_INTERFACES,
-
-	/* get list of all interfaces belonging to a wiphy */
 	NL80211_CMD_NEW_INTERFACES,
-
-	/* configure device */
-	NL80211_CMD_CONFIGURE,
-
-	/* request configuration */
-	NL80211_CMD_GET_CONFIG,
-
-	/* configuration sent from kernel */
-	NL80211_CMD_NEW_CONFIG,
-
-	/* initiate scan.
-	 * Takes a CHANNEL_LIST attribute containing nested
-	 * attributes which in turn contain CHANNEL and FLAGS
-	 * attributes.
-	 * The top level can also contain a FLAGS attribute
-	 * which is then the default for each channel.
-	 * If no channel list is given (or it is empty)
-	 * all channels shall be scanned. */
 	NL80211_CMD_INITIATE_SCAN,
-
-	/* scan result (kernel -> userspace) */
 	NL80211_CMD_SCAN_RESULT,
-
-	/* change roaming control */
-	NL80211_CMD_SET_ROAMING_CONTROL,
-
-	/* get roaming control setting */
-	NL80211_CMD_GET_ROAMING_CONTROL,
-
-	/* answer to that */
-	NL80211_CMD_ROAMING_CONTROL,
-
-	/* set access point BSSID for userspace roaming */
-	NL80211_CMD_SET_FIXED_BSSID,
-
-	/* get currently set userspace roaming BSSID */
-	NL80211_CMD_GET_FIXED_BSSID,
-
-	/* currently set roaming BSSID */
-	NL80211_CMD_FIXED_BSSID,
-
-	/* get current association information, if not associated then
-	 * the BSSID attribute is not present in response */
 	NL80211_CMD_GET_ASSOCIATION,
-
-	/* association notification and response to GET_BSSID */
 	NL80211_CMD_ASSOCIATION_CHANGED,
-
-	/* disassociate from current AP */
-	NL80211_CMD_DISASSOCIATE,
-
-	/* deauth from current AP */
-	NL80211_CMD_DEAUTH,
-
-	/* associate with current settings */
 	NL80211_CMD_ASSOCIATE,
-
-	/* re-associate with current settings
-	 * (SSID and BSSID if roaming control in userspace) */
 	NL80211_CMD_REASSOCIATE,
-
-	/* request the full list of BSSs the device is
-	 * authenticated with */
+	NL80211_CMD_DISASSOCIATE,
+	NL80211_CMD_DEAUTH,
 	NL80211_CMD_GET_AUTH_LIST,
-
-	/* sent as a response to GET_AUTH_LIST containing
-	 * an ATTR_BSSID_LIST */
-	NL80211_CMD_AUTH_LIST,
-
-	/* sent when authenticating/deauthenticating.
-	 * contains an ATTR_BSSID and possibly an
-	 * ATTR_DEAUTHENTICATED */
+	NL80211_CMD_NEW_AUTH_LIST,
 	NL80211_CMD_AUTHENTICATION_CHANGED,
-
-	/* rename a wiphy, takes a wiphy index and name */
-	NL80211_CMD_RENAME_WIPHY,
-
-	/* notification about rename */
-	NL80211_CMD_WIPHY_NEWNAME,
+	NL80211_CMD_AP_SET_BEACON,
+	NL80211_CMD_AP_ADD_STA,
+	NL80211_CMD_AP_UPDATE_STA,
+	NL80211_CMD_AP_GET_STA_INFO,
+	NL80211_CMD_AP_SET_RATESETS,
+	NL80211_CMD_ADD_KEY,
+	NL80211_CMD_DEL_KEY,
 
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
-	__NL80211_CMD_AFTER_LAST,
+	__NL80211_CMD_AFTER_LAST
 };
 #define NL80211_CMD_MAX (__NL80211_CMD_AFTER_LAST - 1)
 
 
-/* currently supported attributes.
- * don't change the order or add anything inbetween, this is ABI! */
-enum {
+/**
+ * enum nl80211_attrs - nl80211 netlink attributes
+ * @NL80211_ATTR_UNSPEC: unspecified attribute to catch errors
+ * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
+ * @NL80211_ATTR_IFNAME: network interface name
+ * @NL80211_ATTR_WIPHY: index of wiphy to operate on, cf.
+ *	/sys/class/ieee80211/<phyname>/index
+ * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
+ * @NL80211_ATTR_CMDS: list of u8's identifying commands a device supports
+ * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
+ * @NL80211_ATTR_INTERFACE_LIST: interface array, nested netlink attribute
+ * @NL80211_ATTR_WIPHY_LIST: wiphy array, nested netlink attribute
+ * @NL80211_ATTR_BSSID: BSSID (must be 6 bytes)
+ * @NL80211_ATTR_SSID: SSID (1-32 bytes)
+ * @NL80211_ATTR_CHANNEL: channel number
+ * @NL80211_ATTR_PHYMODE: PHY mode, see &enum nl80211_phymode
+ * @NL80211_ATTR_CHANNEL_LIST: netlink nested attribute array containing scan
+ *	parameters for channels
+ * @NL80211_ATTR_BSS_LIST: nested attribute containing an array
+ * @NL80211_ATTR_BSSTYPE: BSS type, see &enum nl80211_bsstype
+ * @NL80211_ATTR_BEACON_PERIOD: beacon period
+ * @NL80211_ATTR_DTIM_PERIOD: DTIM period
+ * @NL80211_ATTR_TIMESTAMP: 64-bit timestamp of received beacon/probe response
+ * @NL80211_ATTR_IE: information element(s), maximum length %NL80211_MAX_IE_LEN
+ * @NL80211_ATTR_AUTH_ALGORITHM: authentication algorithm
+ * @NL80211_ATTR_TIMEOUT_TU: timeout in TU (TO BE USED)
+ * @NL80211_ATTR_REASON_CODE: 802.11 reason code
+ * @NL80211_ATTR_ASSOCIATION_ID: association ID (u16, 1-2007)
+ * @NL80211_ATTR_DEAUTHENTICATED: TO BE USED
+ * @NL80211_ATTR_RX_SENSITIVITY: receiver sensitivity in dBm
+ * @NL80211_ATTR_TRANSMIT_POWER: transmit power in mW
+ * @NL80211_ATTR_FRAG_THRESHOLD: fragmentation threshold (bytes)
+ * @NL80211_ATTR_FLAG_SCAN_ACTIVE: netlink flag indiciating active scan
+ * @NL80211_ATTR_KEY_DATA: temporal key data
+ * @NL80211_ATTR_KEY_ID: key ID (u8, 0-3)
+ * @NL80211_ATTR_KEY_TYPE: key type (see &enum nl80211_keytype)
+ * @NL80211_ATTR_MAC: MAC address
+ * @NL80211_ATTR_KEY_CIPHER: key cipher suite (u32)
+ * @__NL80211_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_attrs {
+/* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_ATTR_UNSPEC,
-
-	/* network device (ifindex) to operate on */
+	/* %type: u32 */
 	NL80211_ATTR_IFINDEX,
-
-	/* wiphy index to operate on */
+	/* %type: nulstring */
+	NL80211_ATTR_IFNAME,
+	/* %type: u32 */
 	NL80211_ATTR_WIPHY,
-
-	/* list of u8 cmds that a given device implements */
+	/* %type: nulstring */
+	NL80211_ATTR_WIPHY_NAME,
 	NL80211_ATTR_CMDS,
-
-	/* flags for injection and other commands, see below */
-	NL80211_ATTR_FLAGS,
-
-	/* which hardware queue to use */
-	NL80211_ATTR_QUEUE,
-
-	/* frame to inject or received frame for mgmt frame subscribers */
-	NL80211_ATTR_FRAME,
-
-	/* interface name */
-	NL80211_ATTR_IFNAME,
-
-	/* type of (virtual) interface */
+	/* %type: u32 */
 	NL80211_ATTR_IFTYPE,
-
-	/* interface list */
 	NL80211_ATTR_INTERFACE_LIST,
-
-	/* wiphy list */
 	NL80211_ATTR_WIPHY_LIST,
-
-	/* channel, 1-14 are B/G */
+	NL80211_ATTR_BSSID,
+	NL80211_ATTR_SSID,
 	NL80211_ATTR_CHANNEL,
-
-	/* channel list for scan determination */
+	NL80211_ATTR_PHYMODE,
 	NL80211_ATTR_CHANNEL_LIST,
-
-	/* receiver sensitivity in dBm */
-	NL80211_ATTR_RX_SENSITIVITY,
-
-	/* BSSID to associate to, only used when roaming control
-	 * is in userspace */
-	NL80211_ATTR_BSSID,
-
-	/* list of multiple BSSIDs, this is a nested attribute
-	 * containing an index->(attrs) mapping */
-	NL80211_ATTR_BSSID_LIST,
-
-	/* this is a flag for when an authentication is lost */
+	NL80211_ATTR_BSS_LIST,
+	NL80211_ATTR_BSSTYPE,
+	NL80211_ATTR_BEACON_PERIOD,
+	NL80211_ATTR_DTIM_PERIOD,
+	NL80211_ATTR_TIMESTAMP,
+	NL80211_ATTR_IE,
+	NL80211_ATTR_AUTH_ALGORITHM,
+	NL80211_ATTR_TIMEOUT_TU,
+	NL80211_ATTR_REASON_CODE,
+	NL80211_ATTR_ASSOCIATION_ID,
 	NL80211_ATTR_DEAUTHENTICATED,
-
-	/* SSID of ESS to associate to */
-	NL80211_ATTR_SSID,
-
-	/* transmit power in mW */
+	NL80211_ATTR_RX_SENSITIVITY,
 	NL80211_ATTR_TRANSMIT_POWER,
-
-	/* fragmentation threshold in bytes */
 	NL80211_ATTR_FRAG_THRESHOLD,
+	NL80211_ATTR_FLAG_SCAN_ACTIVE,
 
-	/* one or more information elements */
-	NL80211_ATTR_INFORMATION_ELEMENT,
-
-	NL80211_ATTR_ROAMING_CONTROL,
+	NL80211_ATTR_KEY_DATA,
+	NL80211_ATTR_KEY_ID,
+	NL80211_ATTR_KEY_TYPE,
+	NL80211_ATTR_MAC,
+	NL80211_ATTR_KEY_CIPHER,
 
-	NL80211_ATTR_SCAN_TYPE,
-
-	NL80211_ATTR_WIPHY_NAME,
+	NL80211_ATTR_BEACON_HEAD,
+	NL80211_ATTR_BEACON_TAIL,
 
-	/* add attributes here */
+	/* add attributes here, update the policy in nl80211.c */
 
 	/* used to define NL80211_ATTR_MAX below */
 	__NL80211_ATTR_AFTER_LAST,
 };
 #define NL80211_ATTR_MAX (__NL80211_ATTR_AFTER_LAST - 1)
 
-/* multicast groups */
-enum {
+/**
+ * enum nl80211_multicast_groups - multicast groups for nl80211
+ * @NL80211_GROUP_CONFIG: members of this group are notified of
+ *	configuration changes
+ */
+enum nl80211_multicast_groups {
 	/* be notified of configuration changes like wiphy renames */
 	NL80211_GROUP_CONFIG,
 
 	/* add groups here */
-};
 
-/**
- * NL80211_FLAG_TXSTATUS - send transmit status indication
- */
-#define NL80211_FLAG_TXSTATUS		(1<<0)
-/**
- * NL80211_FLAG_ENCRYPT - encrypt this packet
- * Warning: This looks inside the packet header!
- */
-#define NL80211_FLAG_ENCRYPT		(1<<1)
-
-/**
- * NL80211_FLAG_SCAN_TYPE_ACTIVE - set this with a scan
- * request to have it scan actively, can also be used
- * within the nested CHANNEL_LIST...
- */
-#define NL80211_FLAG_SCAN_TYPE_ACTIVE	(1<<2)
-
-/**
- * maximum length of a frame that can be injected
- */
-#define NL80211_MAX_FRAME_LEN 2500
-
-/* this is an arbitrary limit, 516 means two full-length
- * IEs would fit... */
-/**
- * maximum length of IE(s) passed in an NL80211_ATTR_INFORMATION_ELEMENT.
- */
-#define NL80211_MAX_IE_LEN 516
+	/* keep last */
+	__NL80211_GROUP_AFTER_LAST
+};
+#define NL80211_GROUP_MAX (__NL80211_GROUP_AFTER_LAST - 1)
 
-/* may need to be bumped? */
-/**
- * maximum number of items in an ATTR_CHANNEL_LIST
+/*
+ * maximum length of IE(s) passed in an NL80211_ATTR_IE.
+ * this is an arbitrary limit, 774 means three full-length
+ * IEs would fit... increase if necessary */
+#define NL80211_MAX_IE_LEN 774
+
+/*
+ * maximum number of items in an ATTR_CHANNEL_LIST,
+ * just to avoid too large allocations
  */
-#define NL80211_MAX_CHANNEL_LIST_ITEM 20
+#define NL80211_MAX_CHANNEL_LIST_ITEM 200
 
 /**
- * &enum nl80211_iftype - (virtual) interface types
+ * enum nl80211_iftype - (virtual) interface types
+ * @NL80211_IFTYPE_UNSPECIFIED: unspecified type, driver decides
+ * @NL80211_IFTYPE_ADHOC: independent BSS member
+ * @NL80211_IFTYPE_STATION: managed BSS member
+ * @NL80211_IFTYPE_AP: access point
+ * @NL80211_IFTYPE_WDS: wireless distribution interface
+ * @NL80211_IFTYPE_SECONDARY: ???
+ * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
+ * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
- * This structure is used with the NL80211_ATTR_IFTYPE
+ * These values are used with the NL80211_ATTR_IFTYPE
  * to set the type of an interface.
  * Note that these are intentionally compatible with
  * the IW_MODE_* constants except for the removal of
  * IW_MODE_AUTO.
  *
  */
-enum {
+enum nl80211_iftype {
 	NL80211_IFTYPE_UNSPECIFIED,
 	NL80211_IFTYPE_ADHOC,
 	NL80211_IFTYPE_STATION,
@@ -279,13 +250,56 @@ enum {
 };
 #define NL80211_IFTYPE_MAX (__NL80211_IFTYPE_AFTER_LAST - 1)
 
-enum {
-	NL80211_ROAMING_CONTROL_KERNEL,
-	NL80211_ROAMING_CONTROL_USERSPACE,
+/**
+ * enum nl80211_phymode - PHY modes
+ * @NL80211_PHYMODE_A: 5 GHz PHY
+ * @NL80211_PHYMODE_B: 2.4 GHz PHY (B mode)
+ * @NL80211_PHYMODE_G: 2.4 GHz PHY (G, compatible with B)
+ * @__NL80211_PHYMODE_AFTER_LAST: internal use
+ *
+ * These values are used for %NL80211_ATTR_PHYMODE.
+ */
+enum nl80211_phymode {
+	NL80211_PHYMODE_A,
+	NL80211_PHYMODE_B,
+	NL80211_PHYMODE_G,
+
+	/* keep last */
+	__NL80211_PHYMODE_AFTER_LAST
+};
+#define NL80211_PHYMODE_MAX (__NL80211_PHYMODE_AFTER_LAST - 1)
+
+/**
+ * enum nl80211_bsstype - BSS types
+ * @NL80211_BSSTYPE_INFRASTRUCTURE: infrastructure BSS
+ * @NL80211_BSSTYPE_INDEPENDENT: independent BSS (ad-hoc network)
+ * @__NL80211_BSSTYPE_AFTER_LAST: internal use
+ *
+ * These values are used for %NL80211_ATTR_BSSTYPE.
+ */
+enum nl80211_bsstype {
+	NL80211_BSSTYPE_INFRASTRUCTURE,
+	NL80211_BSSTYPE_INDEPENDENT,
+
+	/* keep last */
+	__NL80211_BSSTYPE_AFTER_LAST
+};
+#define NL80211_BSSTYPE_MAX (__NL80211_BSSTYPE_AFTER_LAST - 1)
+
+/**
+ * enum nl80211_keytype - key types
+ * @NL80211_KEYTYPE_GROUP: group key
+ * @NL80211_KEYTYPE_PAIRWISE: pairwise key
+ * @NL80211_KEYTYPE_PEER: peer key
+ */
+enum nl80211_keytype {
+	NL80211_KEYTYPE_GROUP,
+	NL80211_KEYTYPE_PAIRWISE,
+	NL80211_KEYTYPE_PEER,
 
 	/* keep last */
-	__NL80211_ROAMING_CONTROL_AFTER_LAST
+	__NL80211_KEYTYPE_AFTER_LAST
 };
-#define NL80211_ROAMING_CONTROL_MAX (__NL80211_ROAMING_CONTROL_AFTER_LAST-1)
+#define NL80211_KEYTYPE_MAX (__NL80211_KEYTYPE_AFTER_LAST - 1)
 
 #endif /* __LINUX_NL80211_H */
--- wireless-dev.orig/include/net/cfg80211.h	2007-03-23 11:18:10.823431747 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-03-23 11:19:35.303431747 +0100
@@ -11,49 +11,69 @@
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
  */
 
-#define SSID_MAX_LEN	32
-
 /**
- * struct cfg80211_config - description of a configuration (request)
+ * struct scan_channel - describes a single channel to scan
+ * @phymode: PHY mode for this channel
+ * @channel: channel number (1-14, ...)
+ * @active: scan actively or passively on this channel
  */
-struct cfg80211_config {
-	/* see below */
-	u32 valid;
-
-	s8 ssid_len;
-	u8 ssid[SSID_MAX_LEN];
-
-	s32 rx_sensitivity;
-	u32 transmit_power;
-	u32 fragmentation_threshold;
-	u32 channel;
-};
-
-#define CFG80211_CFG_VALID_SSID			(1<<0)
-#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<1)
-#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<2)
-#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<3)
-#define CFG80211_CFG_VALID_CHANNEL		(1<<4)
-
 struct scan_channel {
+	int phymode;
 	u32 channel;
 	int active;
 };
 
+/**
+ * struct scan_params - describes scan parameters
+ * @n_channels: number of items in @channels array or -1 to indicate all
+ * 	channels should be scanned (in that case @channels will be %NULL)
+ * @active: when n_channels is -1 this determines active/passive scanning.
+ * @phymode: when n_channels is -1 this determines PHY mode to scan. It is
+ *	not possible to scan different PHY modes in one request w/o giving
+ *	a channel list.
+ * @channels: array containing @n_channels &struct scan_channel items
+ */
 struct scan_params {
-	/* number of items in 'channels' array
-	 * or -1 to indicate scanning all channels
-	 * (in that case 'channels' is NULL) */
 	int n_channels;
-
-	/* use only when n_channels is -1 to determine
-	 * whether scanning should be active or not */
 	int active;
-
-	/* the channel list if any */
+	int phymode;
 	struct scan_channel *channels;
 };
 
+/**
+ * struct association_params - describes association parameters
+ * @valid: this member contains flags which items are valid
+ * @bssid: the BSSID of the BSS to associate [%ASSOC_PARAMS_BSSID]
+ * @timeout: timeout (in TU) [%ASSOC_PARAMS_TIMEOUT]
+ * @ie: information element(s) to include in the association frames [%ASSOC_PARAMS_IE]
+ * @ie_len: length of the information element(s)
+ * @ssid: the SSID, always valid.
+ * @ssid_len: length of the SSID
+ */
+struct association_params {
+	u8 *bssid;
+	u32 timeout;
+	u8 *ie;
+	int ie_len;
+	u8 *ssid;
+	int ssid_len;
+
+	unsigned int valid;
+};
+#define ASSOC_PARAMS_TIMEOUT	(1<<0)
+
+/**
+ * struct key_params - key information
+ */
+struct key_params {
+	u8 *key;
+	int key_len;
+	int key_id;
+	u32 key_type;
+	u8 *macaddress;
+	u32 cipher;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -66,45 +86,21 @@ struct wiphy;
  * All callbacks except where otherwise noted should return 0
  * on success or a negative error code.
  *
- * @inject_packet: inject the given frame with the NL80211_FLAG_*
- *		   flags onto the given queue.
- *
  * @add_virtual_intf: create a new virtual interface with the given name
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.
  *
- * @configure: configure the given interface as requested in the config struct.
- *	       must not ignore any configuration item, if something is
- *	       is requested that cannot be fulfilled return an error.
- *             This call does not actually initiate any association or such.
- *
- * @get_config: fill the given config structure with the current configuration
+ * @change_virtual_intf: change type of virtual interface
  *
- * @get_config_valid: return a bitmask of CFG80211_CFG_VALID_* indicating
- *		      which parameters can be set.
+ * @associate: associate with given parameters
  *
- * @associate: associate with previously given settings (SSID, BSSID
- *             if userspace roaming is enabled)
- *
- * @reassociate: reassociate with current settings (SSID, BSSID if
- *		 userspace roaming is enabled)
+ * @reassociate: reassociate with settings
  *
  * @disassociate: disassociate from current AP
  *
  * @deauth: deauth from current AP
  *
- * @initiate_scan: ...
- *
- * @set_roaming: set who gets to control roaming, the roaming_control
- *		 parameter is passed NL80211_ROAMING_CONTROL_* values.
- *
- * @get_roaming: return where roaming control currently is done or
- *		 a negative error.
- *
- * @set_fixed_bssid: set BSSID to use with userspace roaming, forces
- *		     reassociation if changing.
- * @get_fixed_bssid: get BSSID that is used with userspace roaming,
- *		     the bssid parameter has space for 6 bytes
+ * @initiate_scan: scan with the given information (see &struct scan_params above)
  *
  * @get_association: get BSSID of the BSS that the device is currently
  *		     associated to and return 1, or return 0 if not
@@ -113,26 +109,18 @@ struct wiphy;
  *		   authenticated with, must call next_bssid for each,
  *		   next_bssid returns non-zero on error, the given data
  *		   is to be passed to that callback
+ * @add_key: add a key using &struct key_params
+ * @del_key: delete a key using info from &struct key_params
  */
 struct cfg80211_ops {
-	int	(*inject_packet)(struct wiphy *wiphy, void *frame, int framelen,
-				 u32 flags, int queue);
-
-
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
 				    unsigned int type);
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
+	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
+				       unsigned int type);
 
-
-	int	(*configure)(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_config *cfg);
-	void	(*get_config)(struct wiphy *wiphy, struct net_device *dev,
-			      struct cfg80211_config *cfg);
-	u32	(*get_config_valid)(struct wiphy *wiphy,
-				    struct net_device *dev);
-
-
-	int	(*associate)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*associate)(struct wiphy *wiphy, struct net_device *dev,
+			     struct association_params *params);
 	int	(*reassociate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*disassociate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev);
@@ -142,21 +130,17 @@ struct cfg80211_ops {
 				 struct scan_params *params);
 
 
-	int	(*set_roaming)(struct wiphy *wiphy, struct net_device *dev,
-			       int roaming_control);
-	int	(*get_roaming)(struct wiphy *wiphy, struct net_device *dev);
-	int	(*set_fixed_bssid)(struct wiphy *wiphy, struct net_device *dev,
-				   u8 *bssid);
-	int	(*get_fixed_bssid)(struct wiphy *wiphy, struct net_device *dev,
-				   u8 *bssid);
-
-
 	int	(*get_association)(struct wiphy *wiphy, struct net_device *dev,
 				   u8 *bssid);
 
 	int	(*get_auth_list)(struct wiphy *wiphy, struct net_device *dev,
 				 void *data,
 				 int (*next_bssid)(void *data, u8 *bssid));
+
+	int	(*add_key)(struct wiphy *wiphy, struct net_device *dev,
+			   struct key_params *params);
+	int	(*del_key)(struct wiphy *wiphy, struct net_device *dev,
+			   struct key_params *params);
 };
 
 
--- wireless-dev.orig/include/net/wireless.h	2007-03-23 11:18:11.013431747 +0100
+++ wireless-dev/include/net/wireless.h	2007-03-23 11:19:35.303431747 +0100
@@ -55,7 +55,6 @@ struct wireless_dev {
 	struct wiphy *wiphy;
 
 	/* private to the generic wireless code */
-	struct cfg80211_config pending_config;
 	struct list_head list;
 	struct net_device *netdev;
 };
--- wireless-dev.orig/net/wireless/nl80211.c	2007-03-23 11:19:34.043431747 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-03-23 12:07:15.278914719 +0100
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/if_ether.h>
+#include <linux/ieee80211.h>
 #include <linux/nl80211.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
@@ -68,25 +69,39 @@ static int get_drv_dev_by_info_ifindex(s
 /* policy for the attributes */
 static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
-	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
-	[NL80211_ATTR_FLAGS] = { .type = NLA_U32 },
-	[NL80211_ATTR_QUEUE] = { .type = NLA_U32 },
-	[NL80211_ATTR_FRAME] = { .type = NLA_STRING,
-				 .len = NL80211_MAX_FRAME_LEN },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
+	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
+				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_SSID] = { .type = NLA_STRING,
+				.len = IEEE80211_MAX_SSID_LEN },
 	[NL80211_ATTR_CHANNEL] = { .type = NLA_U32 },
+	[NL80211_ATTR_PHYMODE] = { .type = NLA_U32 },
+	[NL80211_ATTR_CHANNEL_LIST] = { .type = NLA_NESTED },
+	[NL80211_ATTR_BSS_LIST] = { .type = NLA_NESTED },
+	[NL80211_ATTR_BSSTYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_BEACON_PERIOD] = { .type = NLA_U32 },
+	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
+	[NL80211_ATTR_TIMESTAMP] = { .type = NLA_U64 },
+	[NL80211_ATTR_IE] = { .type = NLA_STRING, .len = NL80211_MAX_IE_LEN },
+	[NL80211_ATTR_AUTH_ALGORITHM] = { .type = NLA_U32 },
+	[NL80211_ATTR_TIMEOUT_TU] = { .type = NLA_U32 },
+	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U32 },
+	[NL80211_ATTR_ASSOCIATION_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_DEAUTHENTICATED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_RX_SENSITIVITY] = { .type = NLA_U32 },
-	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
-	[NL80211_ATTR_SSID] = { .type = NLA_STRING, .len = 32 },
 	[NL80211_ATTR_TRANSMIT_POWER] = { .type = NLA_U32 },
 	[NL80211_ATTR_FRAG_THRESHOLD] = { .type = NLA_U32 },
-	[NL80211_ATTR_INFORMATION_ELEMENT] = { .type = NLA_STRING,
-					       .len = NL80211_MAX_IE_LEN },
-	[NL80211_ATTR_ROAMING_CONTROL] = { .type = NLA_U32 },
-	[NL80211_ATTR_SCAN_TYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
-				      .len = BUS_ID_SIZE-1 },
+	[NL80211_ATTR_FLAG_SCAN_ACTIVE] = { .type = NLA_FLAG },
+	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_STRING },
+	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_STRING },
+	[NL80211_ATTR_KEY_DATA] = { .type = NLA_STRING, .len = WLAN_MAX_KEY_LEN },
+	[NL80211_ATTR_KEY_ID] = { .type = NLA_U32 },
+	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
+	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 };
 
 /* netlink command implementations */
@@ -127,22 +142,17 @@ static int nl80211_get_cmdlist(struct sk
 	NLA_PUT_FLAG(msg, NL80211_CMD_GET_INTERFACES);
 	NLA_PUT_FLAG(msg, NL80211_CMD_RENAME_WIPHY);
 
-	CHECK_CMD(inject_packet, INJECT);
 	CHECK_CMD(add_virtual_intf, ADD_VIRTUAL_INTERFACE);
 	CHECK_CMD(del_virtual_intf, DEL_VIRTUAL_INTERFACE);
-	CHECK_CMD(configure, CONFIGURE);
-	CHECK_CMD(get_config, GET_CONFIG);
 	CHECK_CMD(associate, ASSOCIATE);
 	CHECK_CMD(reassociate, REASSOCIATE);
 	CHECK_CMD(disassociate, DISASSOCIATE);
 	CHECK_CMD(deauth, DEAUTH);
 	CHECK_CMD(initiate_scan, INITIATE_SCAN);
-	CHECK_CMD(set_roaming, SET_ROAMING_CONTROL);
-	CHECK_CMD(get_roaming, GET_ROAMING_CONTROL);
-	CHECK_CMD(set_fixed_bssid, SET_FIXED_BSSID);
-	CHECK_CMD(get_fixed_bssid, GET_FIXED_BSSID);
 	CHECK_CMD(get_association, GET_ASSOCIATION);
 	CHECK_CMD(get_auth_list, GET_AUTH_LIST);
+	CHECK_CMD(add_key, ADD_KEY);
+	CHECK_CMD(del_key, DEL_KEY);
 
 	nla_nest_end(msg, start);
 
@@ -278,38 +288,6 @@ static int nl80211_get_intfs(struct sk_b
 	return err;
 }
 
-static int nl80211_do_inject(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	u32 flags = 0;
-	int err, queue = -1;
-
-	if (!info->attrs[NL80211_ATTR_FRAME])
-		return -EINVAL;
-	if (info->attrs[NL80211_ATTR_FLAGS])
-		flags = nla_get_u32(info->attrs[NL80211_ATTR_FLAGS]);
-	if (info->attrs[NL80211_ATTR_QUEUE])
-		queue = (int) nla_get_u32(info->attrs[NL80211_ATTR_QUEUE]);
-
-	drv = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(drv))
-		return PTR_ERR(drv);
-
-	if (!drv->ops->inject_packet) {
-		err = -ENOSYS;
-		goto unlock;
-	}
-
-	err = drv->ops->inject_packet(&drv->wiphy,
-		nla_data(info->attrs[NL80211_ATTR_FRAME]),
-		nla_len(info->attrs[NL80211_ATTR_FRAME]),
-		flags,
-		queue);
- unlock:
-	cfg80211_put_dev(drv);
-	return err;
-}
-
 static int nl80211_add_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
@@ -330,7 +308,7 @@ static int nl80211_add_virt_intf(struct 
 		return PTR_ERR(drv);
 
 	if (!drv->ops->add_virtual_intf) {
-		err = -ENOSYS;
+		err = -EOPNOTSUPP;
 		goto unlock;
 	}
 
@@ -366,175 +344,62 @@ static int nl80211_del_virt_intf(struct 
 	return err;
 }
 
-static int nl80211_configure(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err;
-	struct net_device *dev;
-	struct cfg80211_config config;
-	struct nlattr *attr;
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	if (!drv->ops->configure) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	memset(&config, 0, sizeof(config));
-
-	attr = info->attrs[NL80211_ATTR_SSID];
-	if (attr) {
-		config.ssid_len = nla_len(attr);
-		memcpy(config.ssid, nla_data(attr), config.ssid_len);
-	}
-
-	attr = info->attrs[NL80211_ATTR_RX_SENSITIVITY];
-	if (attr) {
-		config.valid |= CFG80211_CFG_VALID_RX_SENSITIVITY;
-		config.rx_sensitivity = (s32) nla_get_u32(attr);
-	}
-
-	attr = info->attrs[NL80211_ATTR_TRANSMIT_POWER];
-	if (attr) {
-		config.valid |= CFG80211_CFG_VALID_TRANSMIT_POWER;
-		config.transmit_power = nla_get_u32(attr);
-	}
-
-	attr = info->attrs[NL80211_ATTR_FRAG_THRESHOLD];
-	if (attr) {
-		config.valid |= CFG80211_CFG_VALID_FRAG_THRESHOLD;
-		config.fragmentation_threshold = nla_get_u32(attr);
-	}
-
-	attr = info->attrs[NL80211_ATTR_CHANNEL];
-	if (attr) {
-		config.valid |= CFG80211_CFG_VALID_CHANNEL;
-		config.channel = nla_get_u32(attr);
-	}
-
-	err = drv->ops->configure(&drv->wiphy, dev, &config);
- out:
-	cfg80211_put_dev(drv);
-	dev_put(dev);
-	return err;
-}
-
-static int nl80211_get_config(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_change_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
-	int err;
+	int err, ifindex;
+	unsigned int type;
 	struct net_device *dev;
-	struct cfg80211_config config;
-	struct sk_buff *msg;
-	void *hdr;
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	if (!drv->ops->get_config) {
-		err = -EOPNOTSUPP;
-		goto out_put_drv;
-	}
-
-	memset(&config, 0, sizeof(config));
-
-	drv->ops->get_config(&drv->wiphy, dev, &config);
-
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_NEW_CONFIG);
-
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto out_put_drv;
-	}
-
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
-
-	if (config.ssid)
-		NLA_PUT_STRING(msg, NL80211_ATTR_SSID, config.ssid);
-
-	if (config.valid & CFG80211_CFG_VALID_RX_SENSITIVITY)
-		NLA_PUT_U32(msg, NL80211_ATTR_RX_SENSITIVITY, (u32)config.rx_sensitivity);
-
-	if (config.valid & CFG80211_CFG_VALID_TRANSMIT_POWER)
-		NLA_PUT_U32(msg, NL80211_ATTR_TRANSMIT_POWER, config.transmit_power);
-
-	if (config.valid & CFG80211_CFG_VALID_FRAG_THRESHOLD)
-		NLA_PUT_U32(msg, NL80211_ATTR_FRAG_THRESHOLD, config.fragmentation_threshold);
 
-	if (config.valid & CFG80211_CFG_VALID_CHANNEL)
-		NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL, config.channel);
-
-	genlmsg_end(msg, hdr);
-	err = genlmsg_unicast(msg, info->snd_pid);
-	goto out_put_drv;
-
- nla_put_failure:
-	err = -ENOBUFS;
-	nlmsg_free(msg);
- out_put_drv:
-	cfg80211_put_dev(drv);
-	dev_put(dev);
-	return err;
-}
-
-static int nl80211_set_roaming(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err;
-	struct net_device *dev;
-	int roaming_control;
-
-	if (!info->attrs[NL80211_ATTR_ROAMING_CONTROL])
-		return -EINVAL;
-	roaming_control = nla_get_u32(info->attrs[NL80211_ATTR_ROAMING_CONTROL]);
-
-	if (roaming_control > NL80211_ROAMING_CONTROL_MAX)
+	if (info->attrs[NL80211_ATTR_IFTYPE]) {
+		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
+		if (type > NL80211_IFTYPE_MAX)
+			return -EINVAL;
+	} else
 		return -EINVAL;
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
+	ifindex = dev->ifindex;
+	dev_put(dev);
 
-	if (!drv->ops->set_roaming) {
+	if (!drv->ops->change_virtual_intf) {
 		err = -EOPNOTSUPP;
-		goto out;
+		goto unlock;
 	}
 
-	err = drv->ops->set_roaming(&drv->wiphy, dev, roaming_control);
- out:
+	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex, type);
+
+ unlock:
 	cfg80211_put_dev(drv);
-	dev_put(dev);
 	return err;
 }
 
-static int nl80211_get_roaming(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_get_association(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct sk_buff *msg;
 	void *hdr;
+	u8 bssid[ETH_ALEN];
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
 
-	if (!drv->ops->get_roaming) {
+	if (!drv->ops->get_association) {
 		err = -EOPNOTSUPP;
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_roaming(&drv->wiphy, dev);
+	err = drv->ops->get_association(&drv->wiphy, dev, bssid);
 	if (err < 0)
 		goto out_put_drv;
 
 	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_ROAMING_CONTROL);
+			     NL80211_CMD_ASSOCIATION_CHANGED);
 
 	if (IS_ERR(hdr)) {
 		err = PTR_ERR(hdr);
@@ -542,7 +407,8 @@ static int nl80211_get_roaming(struct sk
 	}
 
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
-	NLA_PUT_U32(msg, NL80211_ATTR_ROAMING_CONTROL, err);
+	if (err == 1)
+		NLA_PUT(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
 
 	genlmsg_end(msg, hdr);
 	err = genlmsg_unicast(msg, info->snd_pid);
@@ -557,127 +423,56 @@ static int nl80211_get_roaming(struct sk
 	return err;
 }
 
-static int nl80211_set_fixed_bssid(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
-	u8 *bssid;
+	struct association_params assoc_params;
 
-	if (!info->attrs[NL80211_ATTR_BSSID])
-		return -EINVAL;
-	bssid = nla_data(info->attrs[NL80211_ATTR_BSSID]);
+	memset(&assoc_params, 0, sizeof(assoc_params));
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
 
-	if (!drv->ops->set_fixed_bssid) {
+	if (!drv->ops->associate) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = drv->ops->set_fixed_bssid(&drv->wiphy, dev, bssid);
- out:
-	cfg80211_put_dev(drv);
-	dev_put(dev);
-	return err;
-}
-
-static int nl80211_get_fixed_bssid(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err;
-	struct net_device *dev;
-	struct sk_buff *msg;
-	void *hdr;
-	u8 bssid[ETH_ALEN];
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	if (!drv->ops->get_fixed_bssid) {
-		err = -EOPNOTSUPP;
-		goto out_put_drv;
-	}
-
-	err = drv->ops->get_fixed_bssid(&drv->wiphy, dev, bssid);
-	if (err < 0)
-		goto out_put_drv;
-
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_FIXED_BSSID);
-
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto out_put_drv;
-	}
-
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
-	NLA_PUT(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
-
-	genlmsg_end(msg, hdr);
-	err = genlmsg_unicast(msg, info->snd_pid);
-	goto out_put_drv;
-
- nla_put_failure:
-	err = -ENOBUFS;
-	nlmsg_free(msg);
- out_put_drv:
-	cfg80211_put_dev(drv);
-	dev_put(dev);
-	return err;
-}
+	if (!info->attrs[NL80211_ATTR_SSID])
+		return -EINVAL;
 
-static int nl80211_get_association(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err;
-	struct net_device *dev;
-	struct sk_buff *msg;
-	void *hdr;
-	u8 bssid[ETH_ALEN];
+	assoc_params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+	assoc_params.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
+	if (info->attrs[NL80211_ATTR_BSSID])
+		assoc_params.bssid = nla_data(info->attrs[NL80211_ATTR_BSSID]);
 
-	if (!drv->ops->get_association) {
-		err = -EOPNOTSUPP;
-		goto out_put_drv;
+	if (info->attrs[NL80211_ATTR_IE]) {
+		err = check_information_element(info->attrs[NL80211_ATTR_IE]);
+		if (err)
+			goto out;
+		assoc_params.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		assoc_params.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = drv->ops->get_association(&drv->wiphy, dev, bssid);
-	if (err < 0)
-		goto out_put_drv;
-
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_ASSOCIATION_CHANGED);
-
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto out_put_drv;
+	if (info->attrs[NL80211_ATTR_TIMEOUT_TU]) {
+		assoc_params.timeout =
+			nla_get_u32(info->attrs[NL80211_ATTR_TIMEOUT_TU]);
+		assoc_params.valid |= ASSOC_PARAMS_TIMEOUT;
 	}
 
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
-	if (err == 1)
-		NLA_PUT(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
-
-	genlmsg_end(msg, hdr);
-	err = genlmsg_unicast(msg, info->snd_pid);
-	goto out_put_drv;
+	err = drv->ops->associate(&drv->wiphy, dev, &assoc_params);
 
- nla_put_failure:
-	err = -ENOBUFS;
-	nlmsg_free(msg);
- out_put_drv:
+ out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
-static int nl80211_assoc_deauth(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_disassoc_deauth(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err;
@@ -689,15 +484,9 @@ static int nl80211_assoc_deauth(struct s
 		return err;
 
 	switch (info->genlhdr->cmd) {
-	case NL80211_CMD_ASSOCIATE:
-		act = drv->ops->associate;
-		break;
 	case NL80211_CMD_DISASSOCIATE:
 		act = drv->ops->disassociate;
 		break;
-	case NL80211_CMD_REASSOCIATE:
-		act = drv->ops->reassociate;
-		break;
 	case NL80211_CMD_DEAUTH:
 		act = drv->ops->deauth;
 		break;
@@ -761,7 +550,7 @@ static int nl80211_get_auth_list(struct 
 	}
 
 	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_AUTH_LIST);
+			     NL80211_CMD_NEW_AUTH_LIST);
 	if (IS_ERR(hdr)) {
 		err = PTR_ERR(hdr);
 		goto put_drv;
@@ -769,7 +558,7 @@ static int nl80211_get_auth_list(struct 
 
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 
-	start = nla_nest_start(msg, NL80211_ATTR_BSSID_LIST);
+	start = nla_nest_start(msg, NL80211_ATTR_BSS_LIST);
 	if (!start) {
 		err = -ENOBUFS;
 		goto msg_free;
@@ -807,6 +596,12 @@ static int nl80211_initiate_scan(struct 
 	struct scan_channel *channels = NULL;
 	int count = -1;
 
+	if (info->attrs[NL80211_ATTR_PHYMODE])
+		params.phymode = nla_get_u32(info->attrs[NL80211_ATTR_PHYMODE]);
+
+	if (params.phymode > NL80211_PHYMODE_MAX)
+		return -EINVAL;
+
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
@@ -816,11 +611,7 @@ static int nl80211_initiate_scan(struct 
 		goto out;
 	}
 
-	params.active = 0;
-
-	if (info->attrs[NL80211_ATTR_FLAGS])
-		params.active = !!(nla_get_u32(info->attrs[NL80211_ATTR_FLAGS])
-					& NL80211_FLAG_SCAN_TYPE_ACTIVE);
+	params.active = nla_get_flag(info->attrs[NL80211_ATTR_FLAG_SCAN_ACTIVE]);
 
 	if (info->attrs[NL80211_ATTR_CHANNEL_LIST]) {
 		struct nlattr *attr = info->attrs[NL80211_ATTR_CHANNEL_LIST];
@@ -840,6 +631,11 @@ static int nl80211_initiate_scan(struct 
 			goto done_channels;
 		}
 
+		if (count > NL80211_MAX_CHANNEL_LIST_ITEM) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		channels = kmalloc(count * sizeof(struct scan_channel),
 				   GFP_KERNEL);
 		tb = kmalloc((NL80211_ATTR_MAX+1) * sizeof(struct nlattr),
@@ -849,21 +645,32 @@ static int nl80211_initiate_scan(struct 
 		nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
 			err = nla_parse(tb, NL80211_ATTR_MAX, nla_data(nla),
 					nla_len(nla), nl80211_policy);
+
 			if (err || !tb[NL80211_ATTR_CHANNEL]) {
 				err = -EINVAL;
 				kfree(tb);
 				kfree(channels);
 				goto out;
 			}
+
+			channels[count].phymode = params.phymode;
+
+			if (tb[NL80211_ATTR_PHYMODE])
+				channels[count].phymode =
+					nla_get_u32(tb[NL80211_ATTR_PHYMODE]);
+
+			if (channels[count].phymode > NL80211_PHYMODE_MAX) {
+				err = -EINVAL;
+				kfree(tb);
+				kfree(channels);
+				goto out;
+			}
+
 			channels[count].channel =
 				nla_get_u32(tb[NL80211_ATTR_CHANNEL]);
 
-			channels[count].active = params.active;
-
-			if (tb[NL80211_ATTR_FLAGS])
-				channels[count].active =
-					!!(nla_get_u32(tb[NL80211_ATTR_FLAGS])
-					     & NL80211_FLAG_SCAN_TYPE_ACTIVE);
+			channels[count].active =
+				nla_get_flag(tb[NL80211_ATTR_FLAG_SCAN_ACTIVE]);
 			count++;
 		}
 		kfree(tb);
@@ -900,124 +707,198 @@ static int nl80211_rename_wiphy(struct s
 	return result;
 }
 
+static int nl80211_key_cmd(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err, del;
+	struct net_device *dev;
+	struct key_params params;
+	int (*act)(struct wiphy *wiphy, struct net_device *dev,
+		   struct key_params *params);
+
+	memset(&params, 0, sizeof(params));
+
+	if (!info->attrs[NL80211_ATTR_KEY_TYPE])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_KEY_CIPHER])
+		return -EINVAL;
+
+	params.key_type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
+	if (params.key_type > NL80211_KEYTYPE_MAX)
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	switch (info->genlhdr->cmd) {
+	case NL80211_CMD_ADD_KEY:
+		act = drv->ops->add_key;
+		del = 0;
+		break;
+	case NL80211_CMD_DEL_KEY:
+		act = drv->ops->del_key;
+		del = 1;
+		break;
+	default:
+		act = NULL;
+	}
+
+	if (!act) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
+		params.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
+		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
+	}
+
+	if (info->attrs[NL80211_ATTR_KEY_ID]) {
+		params.key_id = nla_get_u32(info->attrs[NL80211_ATTR_KEY_ID]);
+	} else {
+		params.key_id = -1;
+	}
+
+	params.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
+
+	if (info->attrs[NL80211_ATTR_MAC]) {
+		params.macaddress = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	} else {
+		params.macaddress = NULL;
+	}
+
+	err = act(&drv->wiphy, dev, &params);
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
+		.cmd = NL80211_CMD_RENAME_WIPHY,
+		.doit = nl80211_rename_wiphy,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
 		.cmd = NL80211_CMD_GET_CMDLIST,
 		.doit = nl80211_get_cmdlist,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_GET_WIPHYS,
-		.doit = nl80211_get_wiphys,
+		.cmd = NL80211_CMD_ADD_VIRTUAL_INTERFACE,
+		.doit = nl80211_add_virt_intf,
 		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_INTERFACES,
-		.doit = nl80211_get_intfs,
+		.cmd = NL80211_CMD_DEL_VIRTUAL_INTERFACE,
+		.doit = nl80211_del_virt_intf,
 		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_INJECT,
-		.doit = nl80211_do_inject,
+		.cmd = NL80211_CMD_CHANGE_VIRTUAL_INTERFACE,
+		.doit = nl80211_change_virt_intf,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_ADD_VIRTUAL_INTERFACE,
-		.doit = nl80211_add_virt_intf,
+		.cmd = NL80211_CMD_GET_WIPHYS,
+		.doit = nl80211_get_wiphys,
 		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
+		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_DEL_VIRTUAL_INTERFACE,
-		.doit = nl80211_del_virt_intf,
+		.cmd = NL80211_CMD_GET_INTERFACES,
+		.doit = nl80211_get_intfs,
 		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
+		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_CONFIGURE,
-		.doit = nl80211_configure,
+		.cmd = NL80211_CMD_INITIATE_SCAN,
+		.doit = nl80211_initiate_scan,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_CONFIG,
-		.doit = nl80211_get_config,
+		.cmd = NL80211_CMD_GET_ASSOCIATION,
+		.doit = nl80211_get_association,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_SET_ROAMING_CONTROL,
-		.doit = nl80211_set_roaming,
+		.cmd = NL80211_CMD_ASSOCIATE,
+		.doit = nl80211_associate,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+/*
 	{
-		.cmd = NL80211_CMD_GET_ROAMING_CONTROL,
-		.doit = nl80211_get_roaming,
+		.cmd = NL80211_CMD_REASSOCIATE,
 		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
+		.flags = GENL_ADMIN_PERM,
 	},
+*/
 	{
-		.cmd = NL80211_CMD_SET_FIXED_BSSID,
-		.doit = nl80211_set_fixed_bssid,
+		.cmd = NL80211_CMD_DISASSOCIATE,
+		.doit = nl80211_disassoc_deauth,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_FIXED_BSSID,
-		.doit = nl80211_get_fixed_bssid,
+		.cmd = NL80211_CMD_DEAUTH,
+		.doit = nl80211_disassoc_deauth,
 		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
+		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_ASSOCIATION,
-		.doit = nl80211_get_association,
+		.cmd = NL80211_CMD_GET_AUTH_LIST,
+		.doit = nl80211_get_auth_list,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
+/*
 	{
-		.cmd = NL80211_CMD_ASSOCIATE,
-		.doit = nl80211_assoc_deauth,
+		.cmd = NL80211_CMD_AP_SET_BEACON,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_DISASSOCIATE,
-		.doit = nl80211_assoc_deauth,
+		.cmd = NL80211_CMD_AP_ADD_STA,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_DEAUTH,
-		.doit = nl80211_assoc_deauth,
+		.cmd = NL80211_CMD_AP_UPDATE_STA,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_REASSOCIATE,
-		.doit = nl80211_assoc_deauth,
+		.cmd = NL80211_CMD_AP_GET_STA_INFO,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_AUTH_LIST,
-		.doit = nl80211_get_auth_list,
+		.cmd = NL80211_CMD_AP_SET_RATESETS,
 		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
+		.flags = GENL_ADMIN_PERM,
 	},
+*/
 	{
-		.cmd = NL80211_CMD_INITIATE_SCAN,
-		.doit = nl80211_initiate_scan,
+		.cmd = NL80211_CMD_ADD_KEY,
+		.doit = nl80211_key_cmd,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_RENAME_WIPHY,
-		.doit = nl80211_rename_wiphy,
+		.cmd = NL80211_CMD_DEL_KEY,
+		.doit = nl80211_key_cmd,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
--- wireless-dev.orig/net/wireless/wext-compat.c	2007-03-23 11:18:11.183431747 +0100
+++ wireless-dev/net/wireless/wext-compat.c	2007-03-23 11:19:35.323431747 +0100
@@ -15,15 +15,6 @@
  * if explicitly asked for. This is probably not what most people
  * would expect, but perfectly fine in the WE API.
  *
- * NB: Note that each of the wrappers should check if the cfg80211
- * user provides the command, and for configure() it must also check
- * if that parameter can be set or not via get_config_valid()
- *
- * NB2: It's really bad that we can't report an error from the timer-
- * based commit... Hopefully get_config_valid() can catch everything?
- *
- * see set_essid for an example
- *
  * another question I just thought about.. does wext expect to see
  * the new config even if it wasn't committed... if so, we need to
  * look at the pending config in various _get_ calls...
@@ -57,11 +48,6 @@ static void cfg80211_wx_start_commit_tim
 	 * as well as taking the rtnl lock (due to wext)! */
 }
 
-static struct cfg80211_config *get_pending_cfg(struct net_device *dev)
-{
-	return &dev->ieee80211_ptr->pending_config;
-}
-
 static int cfg80211_wx_set_commit(struct cfg80211_registered_device *drv,
 				  struct net_device *net_dev,
 				  struct iw_request_info *info,
@@ -279,23 +265,7 @@ static int cfg80211_wx_set_essid(struct 
 				 char *extra)
 {
 	int err = -EOPNOTSUPP;
-	struct cfg80211_config *cfg;
 
-	if (!drv->ops->configure || !drv->ops->get_config_valid)
-		goto out;
-	if (!(drv->ops->get_config_valid(&drv->wiphy, net_dev)
-			& CFG80211_CFG_VALID_SSID))
-		goto out;
-
-	cfg = get_pending_cfg(net_dev);
-
-	memcpy(cfg->ssid, extra, data->essid.length);
-	cfg->ssid_len = data->essid.length;
-	cfg->valid |= CFG80211_CFG_VALID_SSID;
-
-	cfg80211_wx_start_commit_timer(net_dev->ifindex);
-	err = 0;
- out:
 	return err;
 }
 
--- wireless-dev.orig/include/linux/ieee80211.h	2007-03-23 11:18:10.803431747 +0100
+++ wireless-dev/include/linux/ieee80211.h	2007-03-23 11:19:35.323431747 +0100
@@ -93,6 +93,7 @@
    represents the 2304 bytes of real data, plus a possible 8 bytes of
    WEP IV and ICV. (this interpretation suggested by Ramiro Barreiro) */
 
+#define IEEE80211_MAX_SSID_LEN		32
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -207,6 +208,7 @@ struct ieee80211_cts {
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
+#define WLAN_AUTH_FAST_BSS_TRANSITION 2
 #define WLAN_AUTH_LEAP 128
 
 #define WLAN_AUTH_CHALLENGE_LEN 128
@@ -327,4 +329,14 @@ enum ieee80211_eid {
 	WLAN_EID_QOS_PARAMETER = 222
 };
 
+/* cipher suite selectors */
+#define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
+#define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
+#define WLAN_CIPHER_SUITE_TKIP		0x000FAC02
+/* reserved: 				0x000FAC03 */
+#define WLAN_CIPHER_SUITE_CCMP		0x000FAC04
+#define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
+
+#define WLAN_MAX_KEY_LEN		32
+
 #endif /* IEEE80211_H */
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-23 11:19:34.983431747 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-23 11:19:35.323431747 +0100
@@ -31,8 +31,6 @@
 #define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
 #endif /* ETH_P_PAE */
 
-#define IEEE80211_MAX_SSID_LEN 32
-
 #define WLAN_FC_DATA_PRESENT(fc) (((fc) & 0x4c) == 0x08)
 
 struct ieee80211_local;


