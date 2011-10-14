Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab1JNPNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:13:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1REjRb-0001Ri-Ux
	for linux-wireless@vger.kernel.org; Fri, 14 Oct 2011 17:13:08 +0200
Message-Id: <20111014151152.613576600@sipsolutions.net> (sfid-20111014_171749_468277_F04DADB6)
Date: Fri, 14 Oct 2011 17:11:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 11/12] nl80211: advertise socket TX status capability
References: <20111014151119.246288840@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new wifi socket TX capability should be
supported by wifi drivers, let them advertise
whether they do or not.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   15 +++++++++++++++
 include/net/cfg80211.h  |    3 ++-
 net/wireless/nl80211.c  |    2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/include/linux/nl80211.h	2011-10-13 13:45:18.000000000 +0200
+++ b/include/linux/nl80211.h	2011-10-13 13:52:09.000000000 +0200
@@ -1136,6 +1136,9 @@ enum nl80211_commands {
  *	with support for the features listed in this attribute, see
  *	&enum nl80211_ap_sme_features.
  *
+ * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
+ *	&enum nl80211_feature_flags and is advertised in wiphy information.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1366,6 +1369,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_DEVICE_AP_MLME,
 
+	NL80211_ATTR_FEATURE_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2690,4 +2695,14 @@ enum nl80211_ap_sme_features {
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
--- a/include/net/cfg80211.h	2011-10-13 13:45:18.000000000 +0200
+++ b/include/net/cfg80211.h	2011-10-13 13:52:50.000000000 +0200
@@ -1870,6 +1870,7 @@ struct wiphy_wowlan_support {
  * @software_iftypes: bitmask of software interface types, these are not
  *	subject to any restrictions since they are purely managed in SW.
  * @flags: wiphy flags, see &enum wiphy_flags
+ * @features: features advertised to nl80211, see &enum nl80211_feature_flags.
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
@@ -1931,7 +1932,7 @@ struct wiphy {
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
-	u32 flags;
+	u32 flags, features;
 
 	u32 ap_sme_capa;
 
--- a/net/wireless/nl80211.c	2011-10-13 13:45:18.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-10-13 13:53:22.000000000 +0200
@@ -1013,6 +1013,8 @@ static int nl80211_send_wiphy(struct sk_
 		NLA_PUT_U32(msg, NL80211_ATTR_DEVICE_AP_MLME,
 			    dev->wiphy.ap_sme_capa);
 
+	NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, dev->wiphy.features);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:


