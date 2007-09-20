Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbXITQAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:00:38 -0400
Subject: [PATCH] nl80211: complete revamp
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 18:01:07 +0200
Message-Id: <1190304067.18521.81.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on an earlier patch by David Lamparter, this completely
revamps the nl80211 interface. All unused commands are removed
and new commands are added in groups of four commands (get, set,
new, del) and documented properly. Similarly, unused attributes
are removed. The cfg80211 API is pruned as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |  272 +++-----------
 include/net/cfg80211.h  |  112 -----
 net/wireless/nl80211.c  |  909 ++++++++----------------------------------------
 3 files changed, 227 insertions(+), 1066 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-09-20 17:31:05.561590332 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-09-20 17:36:39.711571777 +0200
@@ -8,201 +8,96 @@
 
 /**
  * enum nl80211_commands - supported nl80211 commands
+ *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
- * @NL80211_CMD_RENAME_WIPHY: rename a wiphy, needs
- *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME
- * @NL80211_CMD_WIPHY_NEWNAME: rename notification
- * @NL80211_CMD_GET_CMDLIST: TO BE DEFINED PROPERLY. currently the code makes
- *	it depend on the wiphy only but it really should depend on the
- *	interface type too....
- * @NL80211_CMD_NEW_CMDLIST: command list result
- * @NL80211_CMD_ADD_VIRTUAL_INTERFACE: create a virtual interface for the
- *	wiphy identified by an %NL80211_ATTR_WIPHY attribute with the given
- *	%NL80211_ATTR_IFTYPE and %NL80211_ATTR_IFNAME.
- * @NL80211_CMD_DEL_VIRTUAL_INTERFACE: destroy a virtual interface identified
- *	by %NL80211_ATTR_IFINDEX.
- * @NL80211_CMD_CHANGE_VIRTUAL_INTERFACE: change type of virtual interface to
- *	the type given by %NL80211_ATTR_IFTYPE, the interface is identified by
- *	%NL80211_ATTR_IFINDEX.
- * @NL80211_CMD_GET_WIPHYS: request a list of all wiphys present in the system
- * @NL80211_CMD_NEW_WIPHYS: returned list of all wiphys
- * @NL80211_CMD_GET_INTERFACES: request a list of all interfaces belonging to
- *	the wiphy identified by %NL80211_ATTR_WIPHY
- * @NL80211_CMD_NEW_INTERFACES: result for %NL80211_CMD_GET_INTERFACES
- * @NL80211_CMD_INITIATE_SCAN: initiate a scan with the passed parameters. THe
- *	parameters may contain %NL80211_ATTR_FLAG_SCAN_ACTIVE,
- *	%NL80211_ATTR_PHYMODE and a list of channels in an
- *	%NL80211_ATTR_CHANNEL_LIST attribute (an array of nested attributes)
- *	containing %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE, and possibly
- *	%NL80211_ATTR_FLAG_SCAN_ACTIVE. The outer %NL80211_ATTR_FLAG_SCAN_ACTIVE
- *	is ignored when a channel list is present.
- * @NL80211_CMD_SCAN_RESULT: scan result, contains an array in
- *	%NL80211_ATTR_BSS_LIST.
- * @NL80211_CMD_ASSOCIATE: associate with the given parameters
- *	(%NL80211_ATTR_SSID is mandatory, %NL80211_ATTR_TIMEOUT_TU,
- *	%NL80211_ATTR_BSSID, %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE,
- *	and %NL80211_ATTR_IE may be given)
- * @NL80211_CMD_ADD_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
- * 	%NL80211_ATTR_KEY_ID, %NL80211_ATTR_KEY_TYPE, %NL80211_ATTR_MAC and
- *	%NL80211_ATTR_KEY_CIPHER attributes.
- * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_ID,
- *	%NL80211_ATTR_KEY_TYPE and %NL80211_ATTR_MAC or all keys.
+ *
+ * @NL80211_CMD_GET_WIPHY: request information about a wiphy or dump request
+ *	to get a list of all present wiphys.
+ * @NL80211_CMD_SET_WIPHY: set wiphy name, needs %NL80211_ATTR_WIPHY and
+ *	%NL80211_ATTR_WIPHY_NAME.
+ * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
+ *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
+ *	%NL80211_ATTR_WIPHY_NAME.
+ * @NL80211_CMD_DEL_WIPHY: Wiphy deleted. Has attributes
+ *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME.
+ *
+ * @NL80211_CMD_GET_INTERFACE: Request an interface's configuration;
+ *	either a dump request on a %NL80211_ATTR_WIPHY or a specific get
+ *	on an %NL80211_ATTR_IFINDEX is supported.
+ * @NL80211_CMD_SET_INTERFACE: Set type of a virtual interface, requires
+ 	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_IFTYPE.
+ * @NL80211_CMD_NEW_INTERFACE: Newly created virtual interface or response
+ *	to %NL80211_CMD_GET_INTERFACE. Has %NL80211_ATTR_IFINDEX,
+ *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_IFTYPE attributes. Can also
+ *	be sent from userspace to request creation of a new virtual interface,
+ *	then requires attributes %NL80211_ATTR_WIPHY, %NL80211_ATTR_IFTYPE and
+ *	%NL80211_ATTR_IFNAME.
+ * @NL80211_CMD_DEL_INTERFACE: Virtual interface was deleted, has attributes
+ *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_WIPHY. Can also be sent from
+ *	userspace to request deletion of a virtual interface, then requires
+ *	attribute %NL80211_ATTR_IFINDEX.
+ *
+ * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
 enum nl80211_commands {
 /* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_CMD_UNSPEC,
-	/* %input: wiphy, wiphy_name */
-	NL80211_CMD_RENAME_WIPHY,
-	NL80211_CMD_WIPHY_NEWNAME,
-	/* %input: wiphy|ifindex */
-	NL80211_CMD_GET_CMDLIST,
-	NL80211_CMD_NEW_CMDLIST,
-	/* %input: wiphy, ifname, {iftype} */
-	NL80211_CMD_ADD_VIRTUAL_INTERFACE,
-	/* %input: wiphy, ifindex */
-	NL80211_CMD_DEL_VIRTUAL_INTERFACE,
-	/* %input: ifindex, iftype */
-	NL80211_CMD_CHANGE_VIRTUAL_INTERFACE,
-	/* %input: */
-	NL80211_CMD_GET_WIPHYS,
-	NL80211_CMD_NEW_WIPHYS,
-	/* %input: wiphy */
-	NL80211_CMD_GET_INTERFACES,
-	NL80211_CMD_NEW_INTERFACES,
-	NL80211_CMD_INITIATE_SCAN,
-	NL80211_CMD_SCAN_RESULT,
-	NL80211_CMD_GET_ASSOCIATION,
-	NL80211_CMD_ASSOCIATION_CHANGED,
-	NL80211_CMD_ASSOCIATE,
-	NL80211_CMD_DISASSOCIATE,
-	NL80211_CMD_DEAUTH,
-	NL80211_CMD_GET_AUTH_LIST,
-	NL80211_CMD_NEW_AUTH_LIST,
-	NL80211_CMD_AUTHENTICATION_CHANGED,
-	NL80211_CMD_AP_SET_BEACON,
-	NL80211_CMD_AP_ADD_STA,
-	NL80211_CMD_AP_UPDATE_STA,
-	NL80211_CMD_AP_GET_STA_INFO,
-	NL80211_CMD_AP_SET_RATESETS,
-	NL80211_CMD_ADD_KEY,
-	NL80211_CMD_DEL_KEY,
+
+	NL80211_CMD_GET_WIPHY,		/* can dump */
+	NL80211_CMD_SET_WIPHY,
+	NL80211_CMD_NEW_WIPHY,
+	NL80211_CMD_DEL_WIPHY,
+
+	NL80211_CMD_GET_INTERFACE,	/* can dump */
+	NL80211_CMD_SET_INTERFACE,
+	NL80211_CMD_NEW_INTERFACE,
+	NL80211_CMD_DEL_INTERFACE,
 
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
-	__NL80211_CMD_AFTER_LAST
+	__NL80211_CMD_AFTER_LAST,
+	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
 };
-#define NL80211_CMD_MAX (__NL80211_CMD_AFTER_LAST - 1)
 
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
+ *
  * @NL80211_ATTR_UNSPEC: unspecified attribute to catch errors
- * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
- * @NL80211_ATTR_IFNAME: network interface name
+ *
  * @NL80211_ATTR_WIPHY: index of wiphy to operate on, cf.
  *	/sys/class/ieee80211/<phyname>/index
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
- * @NL80211_ATTR_CMDS: list of u8's identifying commands a device supports
+ *
+ * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
+ * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
- * @NL80211_ATTR_INTERFACE_LIST: interface array, nested netlink attribute
- * @NL80211_ATTR_WIPHY_LIST: wiphy array, nested netlink attribute
- * @NL80211_ATTR_BSSID: BSSID (must be 6 bytes)
- * @NL80211_ATTR_SSID: SSID (1-32 bytes)
- * @NL80211_ATTR_CHANNEL: channel number
- * @NL80211_ATTR_PHYMODE: PHY mode, see &enum nl80211_phymode
- * @NL80211_ATTR_CHANNEL_LIST: netlink nested attribute array containing scan
- *	parameters for channels
- * @NL80211_ATTR_BSS_LIST: nested attribute containing an array
- * @NL80211_ATTR_BSSTYPE: BSS type, see &enum nl80211_bsstype
- * @NL80211_ATTR_BEACON_PERIOD: beacon period
- * @NL80211_ATTR_DTIM_PERIOD: DTIM period
- * @NL80211_ATTR_TIMESTAMP: 64-bit timestamp of received beacon/probe response
- * @NL80211_ATTR_IE: information element(s), maximum length %NL80211_MAX_IE_LEN
- * @NL80211_ATTR_AUTH_ALGORITHM: authentication algorithm
- * @NL80211_ATTR_TIMEOUT_TU: timeout in TU (TO BE USED)
- * @NL80211_ATTR_REASON_CODE: 802.11 reason code
- * @NL80211_ATTR_ASSOCIATION_ID: association ID (u16, 1-2007)
- * @NL80211_ATTR_DEAUTHENTICATED: TO BE USED
- * @NL80211_ATTR_RX_SENSITIVITY: receiver sensitivity in dBm
- * @NL80211_ATTR_TRANSMIT_POWER: transmit power in mW
- * @NL80211_ATTR_FRAG_THRESHOLD: fragmentation threshold (bytes)
- * @NL80211_ATTR_FLAG_SCAN_ACTIVE: netlink flag indiciating active scan
- * @NL80211_ATTR_KEY_DATA: temporal key data
- * @NL80211_ATTR_KEY_ID: key ID (u8, 0-3)
- * @NL80211_ATTR_KEY_TYPE: key type (see &enum nl80211_keytype)
- * @NL80211_ATTR_MAC: MAC address
- * @NL80211_ATTR_KEY_CIPHER: key cipher suite (u32)
+ *
+ * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_attrs {
 /* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_ATTR_UNSPEC,
-	/* %type: u32 */
-	NL80211_ATTR_IFINDEX,
-	/* %type: nulstring */
-	NL80211_ATTR_IFNAME,
-	/* %type: u32 */
+
 	NL80211_ATTR_WIPHY,
-	/* %type: nulstring */
 	NL80211_ATTR_WIPHY_NAME,
-	NL80211_ATTR_CMDS,
-	/* %type: u32 */
-	NL80211_ATTR_IFTYPE,
-	NL80211_ATTR_INTERFACE_LIST,
-	NL80211_ATTR_WIPHY_LIST,
-	NL80211_ATTR_BSSID,
-	NL80211_ATTR_SSID,
-	NL80211_ATTR_CHANNEL,
-	NL80211_ATTR_PHYMODE,
-	NL80211_ATTR_CHANNEL_LIST,
-	NL80211_ATTR_BSS_LIST,
-	NL80211_ATTR_BSSTYPE,
-	NL80211_ATTR_BEACON_PERIOD,
-	NL80211_ATTR_DTIM_PERIOD,
-	NL80211_ATTR_TIMESTAMP,
-	NL80211_ATTR_IE,
-	NL80211_ATTR_AUTH_ALGORITHM,
-	NL80211_ATTR_TIMEOUT_TU,
-	NL80211_ATTR_REASON_CODE,
-	NL80211_ATTR_ASSOCIATION_ID,
-	NL80211_ATTR_DEAUTHENTICATED,
-	NL80211_ATTR_RX_SENSITIVITY,
-	NL80211_ATTR_TRANSMIT_POWER,
-	NL80211_ATTR_FRAG_THRESHOLD,
-	NL80211_ATTR_FLAG_SCAN_ACTIVE,
-
-	NL80211_ATTR_KEY_DATA,
-	NL80211_ATTR_KEY_ID,
-	NL80211_ATTR_KEY_TYPE,
-	NL80211_ATTR_MAC,
-	NL80211_ATTR_KEY_CIPHER,
 
-	NL80211_ATTR_BEACON_HEAD,
-	NL80211_ATTR_BEACON_TAIL,
+	NL80211_ATTR_IFINDEX,
+	NL80211_ATTR_IFNAME,
+	NL80211_ATTR_IFTYPE,
 
 	/* add attributes here, update the policy in nl80211.c */
 
-	/* used to define NL80211_ATTR_MAX below */
 	__NL80211_ATTR_AFTER_LAST,
+	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
-#define NL80211_ATTR_MAX (__NL80211_ATTR_AFTER_LAST - 1)
-
-/*
- * maximum length of IE(s) passed in an NL80211_ATTR_IE.
- * this is an arbitrary limit, 774 means three full-length
- * IEs would fit... increase if necessary */
-#define NL80211_MAX_IE_LEN 774
-
-/*
- * maximum number of items in an ATTR_CHANNEL_LIST,
- * just to avoid too large allocations
- */
-#define NL80211_MAX_CHANNEL_LIST_ITEM 200
 
 /**
  * enum nl80211_iftype - (virtual) interface types
+ *
  * @NL80211_IFTYPE_UNSPECIFIED: unspecified type, driver decides
  * @NL80211_IFTYPE_ADHOC: independent BSS member
  * @NL80211_IFTYPE_STATION: managed BSS member
@@ -210,9 +105,10 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
+ * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
- * These values are used with the NL80211_ATTR_IFTYPE
+ * These values are used with the %NL80211_ATTR_IFTYPE
  * to set the type of an interface.
  *
  */
@@ -226,60 +122,8 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MONITOR,
 
 	/* keep last */
-	__NL80211_IFTYPE_AFTER_LAST
-};
-#define NL80211_IFTYPE_MAX (__NL80211_IFTYPE_AFTER_LAST - 1)
-
-/**
- * enum nl80211_phymode - PHY modes
- * @NL80211_PHYMODE_A: 5 GHz PHY
- * @NL80211_PHYMODE_B: 2.4 GHz PHY (B mode)
- * @NL80211_PHYMODE_G: 2.4 GHz PHY (G, compatible with B)
- * @__NL80211_PHYMODE_AFTER_LAST: internal use
- *
- * These values are used for %NL80211_ATTR_PHYMODE.
- */
-enum nl80211_phymode {
-	NL80211_PHYMODE_A,
-	NL80211_PHYMODE_B,
-	NL80211_PHYMODE_G,
-
-	/* keep last */
-	__NL80211_PHYMODE_AFTER_LAST
-};
-#define NL80211_PHYMODE_MAX (__NL80211_PHYMODE_AFTER_LAST - 1)
-
-/**
- * enum nl80211_bsstype - BSS types
- * @NL80211_BSSTYPE_INFRASTRUCTURE: infrastructure BSS
- * @NL80211_BSSTYPE_INDEPENDENT: independent BSS (ad-hoc network)
- * @__NL80211_BSSTYPE_AFTER_LAST: internal use
- *
- * These values are used for %NL80211_ATTR_BSSTYPE.
- */
-enum nl80211_bsstype {
-	NL80211_BSSTYPE_INFRASTRUCTURE,
-	NL80211_BSSTYPE_INDEPENDENT,
-
-	/* keep last */
-	__NL80211_BSSTYPE_AFTER_LAST
-};
-#define NL80211_BSSTYPE_MAX (__NL80211_BSSTYPE_AFTER_LAST - 1)
-
-/**
- * enum nl80211_keytype - key types
- * @NL80211_KEYTYPE_GROUP: group key
- * @NL80211_KEYTYPE_PAIRWISE: pairwise key
- * @NL80211_KEYTYPE_PEER: peer key
- */
-enum nl80211_keytype {
-	NL80211_KEYTYPE_GROUP,
-	NL80211_KEYTYPE_PAIRWISE,
-	NL80211_KEYTYPE_PEER,
-
-	/* keep last */
-	__NL80211_KEYTYPE_AFTER_LAST
+	__NL80211_IFTYPE_AFTER_LAST,
+	NL80211_IFTYPE_MAX = __NL80211_IFTYPE_AFTER_LAST - 1
 };
-#define NL80211_KEYTYPE_MAX (__NL80211_KEYTYPE_AFTER_LAST - 1)
 
 #endif /* __LINUX_NL80211_H */
--- wireless-dev.orig/net/wireless/nl80211.c	2007-09-20 17:31:05.621571452 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-09-20 17:36:39.721571723 +0200
@@ -1,7 +1,7 @@
 /*
  * This is the new netlink-based wireless configuration interface.
  *
- * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
  */
 
 #include <linux/if.h>
@@ -13,6 +13,7 @@
 #include <linux/ieee80211.h>
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
+#include <linux/netlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "core.h"
@@ -27,22 +28,6 @@ static struct genl_family nl80211_fam = 
 	.maxattr = NL80211_ATTR_MAX,
 };
 
-/* internal helper: validate an information element attribute */
-static int check_information_element(struct nlattr *nla)
-{
-	int len = nla_len(nla);
-	u8 *data = nla_data(nla);
-	int elementlen;
-
-	while (len >= 2) {
-		/* 1 byte ID, 1 byte len, `len' bytes data */
-		elementlen = *(data+1) + 2;
-		data += elementlen;
-		len -= elementlen;
-	}
-	return len ? -EINVAL : 0;
-}
-
 /* internal helper: get drv and dev */
 static int get_drv_dev_by_info_ifindex(struct genl_info *info,
 				       struct cfg80211_registered_device **drv,
@@ -69,287 +54,194 @@ static int get_drv_dev_by_info_ifindex(s
 
 /* policy for the attributes */
 static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
-	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
-	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = BUS_ID_SIZE-1 },
+
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
-	[NL80211_ATTR_SSID] = { .type = NLA_BINARY,
-				.len = IEEE80211_MAX_SSID_LEN },
-	[NL80211_ATTR_CHANNEL] = { .type = NLA_U32 },
-	[NL80211_ATTR_PHYMODE] = { .type = NLA_U32 },
-	[NL80211_ATTR_CHANNEL_LIST] = { .type = NLA_NESTED },
-	[NL80211_ATTR_BSS_LIST] = { .type = NLA_NESTED },
-	[NL80211_ATTR_BSSTYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_BEACON_PERIOD] = { .type = NLA_U32 },
-	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
-	[NL80211_ATTR_TIMESTAMP] = { .type = NLA_U64 },
-	[NL80211_ATTR_IE] = { .type = NLA_BINARY, .len = NL80211_MAX_IE_LEN },
-	[NL80211_ATTR_AUTH_ALGORITHM] = { .type = NLA_U32 },
-	[NL80211_ATTR_TIMEOUT_TU] = { .type = NLA_U32 },
-	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U32 },
-	[NL80211_ATTR_ASSOCIATION_ID] = { .type = NLA_U16 },
-	[NL80211_ATTR_DEAUTHENTICATED] = { .type = NLA_FLAG },
-	[NL80211_ATTR_RX_SENSITIVITY] = { .type = NLA_U32 },
-	[NL80211_ATTR_TRANSMIT_POWER] = { .type = NLA_U32 },
-	[NL80211_ATTR_FRAG_THRESHOLD] = { .type = NLA_U32 },
-	[NL80211_ATTR_FLAG_SCAN_ACTIVE] = { .type = NLA_FLAG },
-	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_BINARY },
-	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY },
-	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
-				    .len = WLAN_MAX_KEY_LEN },
-	[NL80211_ATTR_KEY_ID] = { .type = NLA_U32 },
-	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
-	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
+	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
+	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 };
 
-/* netlink command implementations */
+/* message building helper */
+static inline void *nl80211hdr_put(struct sk_buff *skb, u32 pid, u32 seq,
+				   int flags, u8 cmd)
+{
+	/* since there is no private header just add the generic one */
+	return genlmsg_put(skb, pid, seq, &nl80211_fam, flags, cmd);
+}
 
-#define CHECK_CMD(ptr, cmd)				\
-	if (drv->ops->ptr)				\
-		NLA_PUT_FLAG(msg, NL80211_CMD_##cmd);
+/* netlink command implementations */
 
-static int nl80211_get_cmdlist(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
+			      struct cfg80211_registered_device *dev)
 {
-	struct cfg80211_registered_device *drv;
-	struct sk_buff *msg;
 	void *hdr;
-	int err;
-	struct nlattr *start;
 
-	drv = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(drv))
-		return PTR_ERR(drv);
-
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_NEW_CMDLIST);
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto put_drv;
-	}
+	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->idx);
+	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
+	return genlmsg_end(msg, hdr);
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
-
-	start = nla_nest_start(msg, NL80211_ATTR_CMDS);
-	if (!start)
-		goto nla_put_failure;
-
-	/* unconditionally allow some common commands we handle centrally
-	 * or where we require the implementation */
-	NLA_PUT_FLAG(msg, NL80211_CMD_GET_CMDLIST);
-	NLA_PUT_FLAG(msg, NL80211_CMD_GET_WIPHYS);
-	NLA_PUT_FLAG(msg, NL80211_CMD_GET_INTERFACES);
-	NLA_PUT_FLAG(msg, NL80211_CMD_RENAME_WIPHY);
-
-	CHECK_CMD(add_virtual_intf, ADD_VIRTUAL_INTERFACE);
-	CHECK_CMD(del_virtual_intf, DEL_VIRTUAL_INTERFACE);
-	CHECK_CMD(associate, ASSOCIATE);
-	CHECK_CMD(disassociate, DISASSOCIATE);
-	CHECK_CMD(deauth, DEAUTH);
-	CHECK_CMD(initiate_scan, INITIATE_SCAN);
-	CHECK_CMD(get_association, GET_ASSOCIATION);
-	CHECK_CMD(get_auth_list, GET_AUTH_LIST);
-	CHECK_CMD(add_key, ADD_KEY);
-	CHECK_CMD(del_key, DEL_KEY);
+ nla_put_failure:
+	return genlmsg_cancel(msg, hdr);
+}
 
-	nla_nest_end(msg, start);
+static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	int idx = 0;
+	int start = cb->args[0];
+	struct cfg80211_registered_device *dev;
 
-	genlmsg_end(msg, hdr);
+	mutex_lock(&cfg80211_drv_mutex);
+	list_for_each_entry(dev, &cfg80211_drv_list, list) {
+		if (++idx < start)
+			continue;
+		if (nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).pid,
+				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				       dev) < 0)
+			break;
+	}
+	mutex_unlock(&cfg80211_drv_mutex);
 
-	err = genlmsg_unicast(msg, info->snd_pid);
-	goto put_drv;
+	cb->args[0] = idx;
 
- nla_put_failure:
-	err = -ENOBUFS;
-	nlmsg_free(msg);
- put_drv:
-	cfg80211_put_dev(drv);
-	return err;
+	return skb->len;
 }
-#undef CHECK_CMD
 
-static int nl80211_get_wiphys(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
-	void *hdr;
-	struct nlattr *start, *indexstart;
-	struct cfg80211_registered_device *drv;
-	int idx = 1;
+	struct cfg80211_registered_device *dev;
 
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_NEW_WIPHYS);
-	if (IS_ERR(hdr))
-		return PTR_ERR(hdr);
-
-	start = nla_nest_start(msg, NL80211_ATTR_WIPHY_LIST);
-	if (!start)
-		goto nla_outer_nest_failure;
+	dev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
 
-	mutex_lock(&cfg80211_drv_mutex);
-	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		indexstart = nla_nest_start(msg, idx++);
-		if (!indexstart)
-			goto nla_put_failure;
-		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
-		nla_nest_end(msg, indexstart);
-	}
-	mutex_unlock(&cfg80211_drv_mutex);
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		goto out_err;
 
-	nla_nest_end(msg, start);
+	if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev) < 0)
+		goto out_free;
 
-	genlmsg_end(msg, hdr);
+	cfg80211_put_dev(dev);
 
 	return genlmsg_unicast(msg, info->snd_pid);
 
- nla_put_failure:
-	mutex_unlock(&cfg80211_drv_mutex);
- nla_outer_nest_failure:
+ out_free:
 	nlmsg_free(msg);
+ out_err:
+	cfg80211_put_dev(dev);
 	return -ENOBUFS;
 }
 
-static int addifidx(struct net_device *dev, struct sk_buff *skb, int *idx)
+static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
-	int err = -ENOBUFS;
-	struct nlattr *start;
-
-	dev_hold(dev);
+	struct cfg80211_registered_device *rdev;
+	int result;
 
-	start = nla_nest_start(skb, *idx++);
-	if (!start)
-		goto nla_put_failure;
+	if (!info->attrs[NL80211_ATTR_WIPHY_NAME])
+		return -EINVAL;
 
-	NLA_PUT_U32(skb, NL80211_ATTR_IFINDEX, dev->ifindex);
-	NLA_PUT_STRING(skb, NL80211_ATTR_IFNAME, dev->name);
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
 
-	nla_nest_end(skb, start);
-	err = 0;
+	result = cfg80211_dev_rename(rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
 
- nla_put_failure:
-	dev_put(dev);
-	return err;
+	cfg80211_put_dev(rdev);
+	return result;
 }
 
-static int nl80211_get_intfs(struct sk_buff *skb, struct genl_info *info)
+
+static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
+			      struct net_device *dev)
 {
-	struct cfg80211_registered_device *drv;
-	struct sk_buff *msg;
 	void *hdr;
-	int err, array_idx;
-	struct nlattr *start;
-	struct wireless_dev *wdev;
-
-	drv = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(drv))
-		return PTR_ERR(drv);
 
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_NEW_INTERFACES);
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto put_drv;
-	}
-
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
-
-	start = nla_nest_start(msg, NL80211_ATTR_INTERFACE_LIST);
-	if (!start) {
-		err = -ENOBUFS;
-		goto msg_free;
-	}
+	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_INTERFACE);
+	if (!hdr)
+		return -1;
 
-	array_idx = 1;
-	err = 0;
-	mutex_lock(&drv->devlist_mtx);
-	list_for_each_entry(wdev, &drv->netdev_list, list) {
-		err = addifidx(wdev->netdev, msg, &array_idx);
-		if (err)
-			break;
-	}
-	mutex_unlock(&drv->devlist_mtx);
-	if (err)
-		goto msg_free;
-
-	nla_nest_end(msg, start);
-
-	genlmsg_end(msg, hdr);
-
-	err = genlmsg_unicast(msg, info->snd_pid);
-	goto put_drv;
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, dev->name);
+	/* TODO: interface type */
+	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
-	err = -ENOBUFS;
- msg_free:
-	nlmsg_free(msg);
- put_drv:
-	cfg80211_put_dev(drv);
-	return err;
+	return genlmsg_cancel(msg, hdr);
 }
 
-static int nl80211_add_virt_intf(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct cfg80211_registered_device *drv;
-	int err;
-	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
-
-	if (!info->attrs[NL80211_ATTR_IFNAME])
-		return -EINVAL;
+	int wp_idx = 0;
+	int if_idx = 0;
+	int wp_start = cb->args[0];
+	int if_start = cb->args[1];
+	struct cfg80211_registered_device *dev;
+	struct wireless_dev *wdev;
 
-	if (info->attrs[NL80211_ATTR_IFTYPE]) {
-		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
-		if (type > NL80211_IFTYPE_MAX)
-			return -EINVAL;
+	mutex_lock(&cfg80211_drv_mutex);
+	list_for_each_entry(dev, &cfg80211_drv_list, list) {
+		if (++wp_idx < wp_start)
+			continue;
+		if_idx = 0;
+
+		mutex_lock(&dev->devlist_mtx);
+		list_for_each_entry(wdev, &dev->netdev_list, list) {
+			if (++if_idx < if_start)
+				continue;
+			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).pid,
+					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					       wdev->netdev) < 0)
+				break;
+		}
+		mutex_unlock(&dev->devlist_mtx);
 	}
+	mutex_unlock(&cfg80211_drv_mutex);
 
-	drv = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(drv))
-		return PTR_ERR(drv);
-
-	if (!drv->ops->add_virtual_intf) {
-		err = -EOPNOTSUPP;
-		goto unlock;
-	}
+	cb->args[0] = wp_idx;
+	cb->args[1] = if_idx;
 
-	rtnl_lock();
-	err = drv->ops->add_virtual_intf(&drv->wiphy,
-		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
-	rtnl_unlock();
-
- unlock:
-	cfg80211_put_dev(drv);
-	return err;
+	return skb->len;
 }
 
-static int nl80211_del_virt_intf(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
-	int ifindex, err;
-	struct net_device *dev;
+	struct sk_buff *msg;
+	struct cfg80211_registered_device *dev;
+	struct net_device *netdev;
+	int err;
 
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	err = get_drv_dev_by_info_ifindex(info, &dev, &netdev);
 	if (err)
 		return err;
-	ifindex = dev->ifindex;
-	dev_put(dev);
 
-	if (!drv->ops->del_virtual_intf) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		goto out_err;
 
-	rtnl_lock();
-	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
-	rtnl_unlock();
+	if (nl80211_send_iface(msg, info->snd_pid, info->snd_seq, 0, netdev) < 0)
+		goto out_free;
 
- out:
-	cfg80211_put_dev(drv);
-	return err;
+	dev_put(netdev);
+	cfg80211_put_dev(dev);
+
+	return genlmsg_unicast(msg, info->snd_pid);
+
+ out_free:
+	nlmsg_free(msg);
+ out_err:
+	dev_put(netdev);
+	cfg80211_put_dev(dev);
+	return -ENOBUFS;
 }
 
-static int nl80211_change_virt_intf(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err, ifindex;
@@ -383,567 +275,107 @@ static int nl80211_change_virt_intf(stru
 	return err;
 }
 
-static int nl80211_get_association(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err;
-	struct net_device *dev;
-	struct sk_buff *msg;
-	void *hdr;
-	u8 bssid[ETH_ALEN];
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	if (!drv->ops->get_association) {
-		err = -EOPNOTSUPP;
-		goto out_put_drv;
-	}
-
-	rtnl_lock();
-	err = drv->ops->get_association(&drv->wiphy, dev, bssid);
-	rtnl_unlock();
-	if (err < 0)
-		goto out_put_drv;
-
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_ASSOCIATION_CHANGED);
-
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto out_put_drv;
-	}
-
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
-	if (err == 1)
-		NLA_PUT(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
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
-static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err;
-	struct net_device *dev;
-	struct association_params assoc_params;
-
-	memset(&assoc_params, 0, sizeof(assoc_params));
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	if (!drv->ops->associate) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 
-	if (!info->attrs[NL80211_ATTR_SSID])
+	if (!info->attrs[NL80211_ATTR_IFNAME])
 		return -EINVAL;
 
-	assoc_params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
-	assoc_params.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
-
-	if (info->attrs[NL80211_ATTR_BSSID])
-		assoc_params.bssid = nla_data(info->attrs[NL80211_ATTR_BSSID]);
-
-	if (info->attrs[NL80211_ATTR_IE]) {
-		err = check_information_element(info->attrs[NL80211_ATTR_IE]);
-		if (err)
-			goto out;
-		assoc_params.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
-		assoc_params.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
-	}
-
-	if (info->attrs[NL80211_ATTR_TIMEOUT_TU]) {
-		assoc_params.timeout =
-			nla_get_u32(info->attrs[NL80211_ATTR_TIMEOUT_TU]);
-		assoc_params.valid |= ASSOC_PARAMS_TIMEOUT;
-	}
-
-	rtnl_lock();
-	err = drv->ops->associate(&drv->wiphy, dev, &assoc_params);
-	rtnl_unlock();
-
- out:
-	cfg80211_put_dev(drv);
-	dev_put(dev);
-	return err;
-}
-
-static int nl80211_disassoc_deauth(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err;
-	struct net_device *dev;
-	int (*act)(struct wiphy *wiphy, struct net_device *dev);
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	switch (info->genlhdr->cmd) {
-	case NL80211_CMD_DISASSOCIATE:
-		act = drv->ops->disassociate;
-		break;
-	case NL80211_CMD_DEAUTH:
-		act = drv->ops->deauth;
-		break;
-	default:
-		act = NULL;
-	}
-
-	if (!act) {
-		err = -EOPNOTSUPP;
-		goto out;
+	if (info->attrs[NL80211_ATTR_IFTYPE]) {
+		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
+		if (type > NL80211_IFTYPE_MAX)
+			return -EINVAL;
 	}
 
-	rtnl_lock();
-	err = act(&drv->wiphy, dev);
-	rtnl_unlock();
- out:
-	cfg80211_put_dev(drv);
-	dev_put(dev);
-	return err;
-}
-
-struct add_cb_data {
-	int idx;
-	struct sk_buff *skb;
-};
-
-static int add_bssid(void *data, u8 *bssid)
-{
-	struct add_cb_data *cb = data;
-	int err = -ENOBUFS;
-	struct nlattr *start;
-
-	start = nla_nest_start(cb->skb, cb->idx++);
-	if (!start)
-		goto nla_put_failure;
-
-	NLA_PUT(cb->skb, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
-
-	nla_nest_end(cb->skb, start);
-	err = 0;
-
- nla_put_failure:
-	return err;
-}
-
-static int nl80211_get_auth_list(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	struct net_device *dev;
-	struct sk_buff *msg;
-	void *hdr;
-	int err;
-	struct nlattr *start;
-	struct add_cb_data cb;
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
+	drv = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(drv))
+		return PTR_ERR(drv);
 
-	if (!drv->ops->get_auth_list) {
+	if (!drv->ops->add_virtual_intf) {
 		err = -EOPNOTSUPP;
-		goto put_drv;
-	}
-
-	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_NEW_AUTH_LIST);
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto put_drv;
-	}
-
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
-
-	start = nla_nest_start(msg, NL80211_ATTR_BSS_LIST);
-	if (!start) {
-		err = -ENOBUFS;
-		goto msg_free;
+		goto unlock;
 	}
 
-	cb.skb = msg;
-	cb.idx = 1;
 	rtnl_lock();
-	err = drv->ops->get_auth_list(&drv->wiphy, dev, &cb, add_bssid);
+	err = drv->ops->add_virtual_intf(&drv->wiphy,
+		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
 	rtnl_unlock();
-	if (err)
-		goto msg_free;
-
-	nla_nest_end(msg, start);
 
-	genlmsg_end(msg, hdr);
-
-	err = genlmsg_unicast(msg, info->snd_pid);
-	goto put_drv;
-
- nla_put_failure:
-	err = -ENOBUFS;
- msg_free:
-	nlmsg_free(msg);
- put_drv:
+ unlock:
 	cfg80211_put_dev(drv);
-	dev_put(dev);
 	return err;
 }
 
-static int nl80211_initiate_scan(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
-	int err;
+	int ifindex, err;
 	struct net_device *dev;
-	struct scan_params params;
-	struct scan_channel *channels = NULL;
-	int count = -1;
-
-	if (info->attrs[NL80211_ATTR_PHYMODE])
-		params.phymode = nla_get_u32(info->attrs[NL80211_ATTR_PHYMODE]);
-
-	if (params.phymode > NL80211_PHYMODE_MAX)
-		return -EINVAL;
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
-
-	if (!drv->ops->initiate_scan) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	params.active = nla_get_flag(info->attrs[NL80211_ATTR_FLAG_SCAN_ACTIVE]);
-
-	if (info->attrs[NL80211_ATTR_CHANNEL_LIST]) {
-		struct nlattr *attr = info->attrs[NL80211_ATTR_CHANNEL_LIST];
-		struct nlattr *nla;
-		int rem;
-		struct nlattr **tb;
-
-		/* let's count first */
-		count = 0;
-		nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem)
-			count++;
-
-		if (count == 0) {
-			/* assume we should actually scan all channels,
-			 * scanning no channels make no sense */
-			count = -1;
-			goto done_channels;
-		}
-
-		if (count > NL80211_MAX_CHANNEL_LIST_ITEM) {
-			err = -EINVAL;
-			goto out;
-		}
-
-		channels = kmalloc(count * sizeof(struct scan_channel),
-				   GFP_KERNEL);
-		tb = kmalloc((NL80211_ATTR_MAX+1) * sizeof(struct nlattr),
-			     GFP_KERNEL);
-
-		count = 0;
-		nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
-			err = nla_parse(tb, NL80211_ATTR_MAX, nla_data(nla),
-					nla_len(nla), nl80211_policy);
-
-			if (err || !tb[NL80211_ATTR_CHANNEL]) {
-				err = -EINVAL;
-				kfree(tb);
-				kfree(channels);
-				goto out;
-			}
-
-			channels[count].phymode = params.phymode;
-
-			if (tb[NL80211_ATTR_PHYMODE])
-				channels[count].phymode =
-					nla_get_u32(tb[NL80211_ATTR_PHYMODE]);
-
-			if (channels[count].phymode > NL80211_PHYMODE_MAX) {
-				err = -EINVAL;
-				kfree(tb);
-				kfree(channels);
-				goto out;
-			}
-
-			channels[count].channel =
-				nla_get_u32(tb[NL80211_ATTR_CHANNEL]);
-
-			channels[count].active =
-				nla_get_flag(tb[NL80211_ATTR_FLAG_SCAN_ACTIVE]);
-			count++;
-		}
-		kfree(tb);
-	}
-
- done_channels:
-	params.channels = channels;
-	params.n_channels = count;
-
-	rtnl_lock();
-	err = drv->ops->initiate_scan(&drv->wiphy, dev, &params);
-	rtnl_unlock();
-
-	kfree(channels);
- out:
-	cfg80211_put_dev(drv);
+	ifindex = dev->ifindex;
 	dev_put(dev);
-	return err;
-}
-
-static int nl80211_rename_wiphy(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *rdev;
-	int result;
-
-	if (!info->attrs[NL80211_ATTR_WIPHY_NAME])
-		return -EINVAL;
-
-	rdev = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(rdev))
-		return PTR_ERR(rdev);
-
-	result = cfg80211_dev_rename(rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
-
-	cfg80211_put_dev(rdev);
-	return result;
-}
-
-static int nl80211_key_cmd(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_device *drv;
-	int err, del;
-	struct net_device *dev;
-	struct key_params params;
-	int (*act)(struct wiphy *wiphy, struct net_device *dev,
-		   struct key_params *params);
 
-	memset(&params, 0, sizeof(params));
-
-	if (!info->attrs[NL80211_ATTR_KEY_TYPE])
-		return -EINVAL;
-
-	if (!info->attrs[NL80211_ATTR_KEY_CIPHER])
-		return -EINVAL;
-
-	params.key_type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
-	if (params.key_type > NL80211_KEYTYPE_MAX)
-		return -EINVAL;
-
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
-
-	switch (info->genlhdr->cmd) {
-	case NL80211_CMD_ADD_KEY:
-		act = drv->ops->add_key;
-		del = 0;
-		break;
-	case NL80211_CMD_DEL_KEY:
-		act = drv->ops->del_key;
-		del = 1;
-		break;
-	default:
-		act = NULL;
-	}
-
-	if (!act) {
+	if (!drv->ops->del_virtual_intf) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
-		params.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
-		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
-	}
-
-	if (info->attrs[NL80211_ATTR_KEY_ID]) {
-		params.key_id = nla_get_u32(info->attrs[NL80211_ATTR_KEY_ID]);
-	} else {
-		params.key_id = -1;
-	}
-
-	params.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
-
-	if (info->attrs[NL80211_ATTR_MAC]) {
-		params.macaddress = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	} else {
-		params.macaddress = NULL;
-	}
-
 	rtnl_lock();
-	err = act(&drv->wiphy, dev, &params);
+	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
 	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
-	dev_put(dev);
 	return err;
 }
 
 static struct genl_ops nl80211_ops[] = {
 	{
-		.cmd = NL80211_CMD_RENAME_WIPHY,
-		.doit = nl80211_rename_wiphy,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_GET_CMDLIST,
-		.doit = nl80211_get_cmdlist,
+		.cmd = NL80211_CMD_GET_WIPHY,
+		.doit = nl80211_get_wiphy,
+		.dumpit = nl80211_dump_wiphy,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_ADD_VIRTUAL_INTERFACE,
-		.doit = nl80211_add_virt_intf,
+		.cmd = NL80211_CMD_SET_WIPHY,
+		.doit = nl80211_set_wiphy,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_DEL_VIRTUAL_INTERFACE,
-		.doit = nl80211_del_virt_intf,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_CHANGE_VIRTUAL_INTERFACE,
-		.doit = nl80211_change_virt_intf,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_GET_WIPHYS,
-		.doit = nl80211_get_wiphys,
-		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
-	},
-	{
-		.cmd = NL80211_CMD_GET_INTERFACES,
-		.doit = nl80211_get_intfs,
+		.cmd = NL80211_CMD_GET_INTERFACE,
+		.doit = nl80211_get_interface,
+		.dumpit = nl80211_dump_interface,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_INITIATE_SCAN,
-		.doit = nl80211_initiate_scan,
+		.cmd = NL80211_CMD_SET_INTERFACE,
+		.doit = nl80211_set_interface,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_ASSOCIATION,
-		.doit = nl80211_get_association,
-		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
-	},
-	{
-		.cmd = NL80211_CMD_ASSOCIATE,
-		.doit = nl80211_associate,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_DISASSOCIATE,
-		.doit = nl80211_disassoc_deauth,
+		.cmd = NL80211_CMD_NEW_INTERFACE,
+		.doit = nl80211_new_interface,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_DEAUTH,
-		.doit = nl80211_disassoc_deauth,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_GET_AUTH_LIST,
-		.doit = nl80211_get_auth_list,
-		.policy = nl80211_policy,
-		/* can be retrieved by unprivileged users */
-	},
-/*
-	{
-		.cmd = NL80211_CMD_AP_SET_BEACON,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_AP_ADD_STA,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_AP_UPDATE_STA,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_AP_GET_STA_INFO,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_AP_SET_RATESETS,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-*/
-	{
-		.cmd = NL80211_CMD_ADD_KEY,
-		.doit = nl80211_key_cmd,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = NL80211_CMD_DEL_KEY,
-		.doit = nl80211_key_cmd,
+		.cmd = NL80211_CMD_DEL_INTERFACE,
+		.doit = nl80211_del_interface,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 };
 
-
-/* exported functions */
-
-void *nl80211hdr_put(struct sk_buff *skb, u32 pid, u32 seq, int flags, u8 cmd)
-{
-	/* since there is no private header just add the generic one */
-	return genlmsg_put(skb, pid, seq, &nl80211_fam, flags, cmd);
-}
-EXPORT_SYMBOL_GPL(nl80211hdr_put);
-
-void *nl80211msg_new(struct sk_buff **skb, u32 pid, u32 seq, int flags, u8 cmd)
-{
-	void *hdr;
-
-	*skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!*skb)
-		return ERR_PTR(-ENOBUFS);
-
-	hdr = nl80211hdr_put(*skb, pid, seq, flags, cmd);
-	if (!hdr) {
-		nlmsg_free(*skb);
-		return ERR_PTR(-ENOBUFS);
-	}
-
-	return hdr;
-}
-EXPORT_SYMBOL_GPL(nl80211msg_new);
-
 /* multicast groups */
 static struct genl_multicast_group nl80211_config_mcgrp = {
 	.name = "config",
@@ -954,22 +386,17 @@ static struct genl_multicast_group nl802
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
 {
 	struct sk_buff *msg;
-	void *hdr;
 
-	hdr = nl80211msg_new(&msg, 0, 0, 0, NL80211_CMD_WIPHY_NEWNAME);
-	if (IS_ERR(hdr))
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
 		return;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->idx);
-	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&rdev->wiphy));
+	if (nl80211_send_wiphy(msg, 0, 0, 0, rdev) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
 
-	genlmsg_end(msg, hdr);
 	genlmsg_multicast(msg, 0, nl80211_config_mcgrp.id, GFP_KERNEL);
-
-	return;
-
- nla_put_failure:
-	nlmsg_free(msg);
 }
 
 /* initialisation/exit functions */
--- wireless-dev.orig/include/net/cfg80211.h	2007-09-20 17:31:05.591569987 +0200
+++ wireless-dev/include/net/cfg80211.h	2007-09-20 17:36:39.731570258 +0200
@@ -9,73 +9,9 @@
 /*
  * 802.11 configuration in-kernel interface
  *
- * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
  */
 
-/**
- * struct scan_channel - describes a single channel to scan
- * @phymode: PHY mode for this channel
- * @channel: channel number (1-14, ...)
- * @active: scan actively or passively on this channel
- */
-struct scan_channel {
-	enum nl80211_phymode phymode;
-	u32 channel;
-	int active;
-};
-
-/**
- * struct scan_params - describes scan parameters
- * @n_channels: number of items in @channels array or -1 to indicate all
- * 	channels should be scanned (in that case @channels will be %NULL)
- * @active: when n_channels is -1 this determines active/passive scanning.
- * @phymode: when n_channels is -1 this determines PHY mode to scan. It is
- *	not possible to scan different PHY modes in one request w/o giving
- *	a channel list.
- * @channels: array containing @n_channels &struct scan_channel items
- */
-struct scan_params {
-	int n_channels;
-	int active;
-	enum nl80211_phymode phymode;
-	struct scan_channel *channels;
-};
-
-/**
- * struct association_params - describes association parameters
- * @valid: this member contains flags which items are valid
- * @bssid: the BSSID of the BSS to associate [%ASSOC_PARAMS_BSSID]
- * @timeout: timeout (in TU) [%ASSOC_PARAMS_TIMEOUT]
- * @ie: information element(s) to include in the association frames [%ASSOC_PARAMS_IE]
- * @ie_len: length of the information element(s)
- * @ssid: the SSID, always valid.
- * @ssid_len: length of the SSID
- */
-struct association_params {
-	u8 *bssid;
-	u32 timeout;
-	u8 *ie;
-	int ie_len;
-	u8 *ssid;
-	int ssid_len;
-
-	unsigned int valid;
-};
-#define ASSOC_PARAMS_TIMEOUT	(1<<0)
-
-/**
- * struct key_params - key information
- */
-struct key_params {
-	u8 *key;
-	int key_len;
-	int key_id;
-	u32 key_type;
-	u8 *macaddress;
-	u32 cipher;
-};
-
-
 /* Radiotap header iteration
  *   implemented in net/wireless/radiotap.c
  *   docs in Documentation/networking/radiotap-headers.txt
@@ -135,23 +71,6 @@ struct wiphy;
  *
  * @change_virtual_intf: change type of virtual interface
  *
- * @associate: associate with given parameters
- *
- * @disassociate: disassociate from current AP
- *
- * @deauth: deauth from current AP
- *
- * @initiate_scan: scan with the given information (see &struct scan_params above)
- *
- * @get_association: get BSSID of the BSS that the device is currently
- *		     associated to and return 1, or return 0 if not
- *		     associated (or a negative error code)
- * @get_auth_list: get list of BSSIDs of all BSSs the device has
- *		   authenticated with, must call next_bssid for each,
- *		   next_bssid returns non-zero on error, the given data
- *		   is to be passed to that callback
- * @add_key: add a key using &struct key_params
- * @del_key: delete a key using info from &struct key_params
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -159,35 +78,6 @@ struct cfg80211_ops {
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
 				       enum nl80211_iftype type);
-
-	int	(*associate)(struct wiphy *wiphy, struct net_device *dev,
-			     struct association_params *params);
-	int	(*disassociate)(struct wiphy *wiphy, struct net_device *dev);
-	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev);
-
-
-	int	(*initiate_scan)(struct wiphy *wiphy, struct net_device *dev,
-				 struct scan_params *params);
-
-
-	int	(*get_association)(struct wiphy *wiphy, struct net_device *dev,
-				   u8 *bssid);
-
-	int	(*get_auth_list)(struct wiphy *wiphy, struct net_device *dev,
-				 void *data,
-				 int (*next_bssid)(void *data, u8 *bssid));
-
-	int	(*add_key)(struct wiphy *wiphy, struct net_device *dev,
-			   struct key_params *params);
-	int	(*del_key)(struct wiphy *wiphy, struct net_device *dev,
-			   struct key_params *params);
 };
 
-
-/* helper functions specific to nl80211 */
-extern void *nl80211hdr_put(struct sk_buff *skb, u32 pid,
-			    u32 seq, int flags, u8 cmd);
-extern void *nl80211msg_new(struct sk_buff **skb, u32 pid,
-			    u32 seq, int flags, u8 cmd);
-
 #endif /* __NET_CFG80211_H */


