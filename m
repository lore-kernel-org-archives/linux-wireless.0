Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1KFNPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 08:15:14 -0500
Message-Id: <20111106131424.932238639@sipsolutions.net> (sfid-20111106_142607_361678_CA917B5C)
Date: Sun, 06 Nov 2011 14:13:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] nl80211: advertise socket TX status capability
References: <20111106131332.746774119@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new wifi socket TX capability should be
supported by wifi drivers, let them advertise
whether they do or not.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   18 ++++++++++++++++++
 include/net/cfg80211.h  |    3 ++-
 net/wireless/nl80211.c  |    2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/include/linux/nl80211.h	2011-11-04 11:22:29.000000000 +0100
+++ b/include/linux/nl80211.h	2011-11-04 11:43:48.000000000 +0100
@@ -695,6 +695,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
+#define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
+
 /* source-level API compatibility */
 #define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
 #define NL80211_CMD_SET_MESH_PARAMS NL80211_CMD_SET_MESH_CONFIG
@@ -1156,6 +1158,9 @@ enum nl80211_commands {
  *	it will also not give a status callback nor return a cookie. This is
  *	mostly useful for probe responses to save airtime.
  *
+ * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
+ *	&enum nl80211_feature_flags and is advertised in wiphy information.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1388,6 +1393,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_DONT_WAIT_FOR_ACK,
 
+	NL80211_ATTR_FEATURE_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1422,6 +1429,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_AKM_SUITES NL80211_ATTR_AKM_SUITES
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
+#define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -2714,4 +2722,14 @@ enum nl80211_ap_sme_features {
 	NL80211_AP_SME_WSC	= 1 << 0,
 };
 
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
 #endif /* __LINUX_NL80211_H */
--- a/include/net/cfg80211.h	2011-11-04 11:22:29.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-04 11:43:05.000000000 +0100
@@ -1877,6 +1877,7 @@ struct wiphy_wowlan_support {
  * @software_iftypes: bitmask of software interface types, these are not
  *	subject to any restrictions since they are purely managed in SW.
  * @flags: wiphy flags, see &enum wiphy_flags
+ * @features: features advertised to nl80211, see &enum nl80211_feature_flags.
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
@@ -1938,7 +1939,7 @@ struct wiphy {
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
-	u32 flags;
+	u32 flags, features;
 
 	u32 ap_sme_capa;
 
--- a/net/wireless/nl80211.c	2011-11-04 11:22:29.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-04 11:43:05.000000000 +0100
@@ -1017,6 +1017,8 @@ static int nl80211_send_wiphy(struct sk_
 		NLA_PUT_U32(msg, NL80211_ATTR_DEVICE_AP_SME,
 			    dev->wiphy.ap_sme_capa);
 
+	NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, dev->wiphy.features);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:


