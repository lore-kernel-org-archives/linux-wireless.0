Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41047 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753124AbeAaVdl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:33:41 -0500
Received: by mail-pg0-f65.google.com with SMTP id 141so520654pgd.8
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 13:33:41 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 2/6] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
Date: Wed, 31 Jan 2018 15:33:25 -0600
Message-Id: <20180131213329.25322-3-denkenz@gmail.com> (sfid-20180131_223346_947915_8BCE5011)
In-Reply-To: <20180131213329.25322-1-denkenz@gmail.com>
References: <20180131213329.25322-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 17 ++++++++++++++++-
 net/wireless/nl80211.c       | 12 ++++++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7d49cd0cf92d..fb369947aefb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -646,6 +646,8 @@ struct survey_info {
  *	allowed through even on unauthorized ports
  * @control_port_no_encrypt: TRUE to prevent encryption of control port
  *	protocol frames.
+ * @control_port_over_nl80211: TRUE if userspace expects to exchange control
+ *	port frames over NL80211 instead of the network interface.
  * @wep_keys: static WEP keys, if not NULL points to an array of
  *	CFG80211_MAX_WEP_KEYS WEP keys
  * @wep_tx_key: key index (0..3) of the default TX static WEP key
@@ -661,6 +663,7 @@ struct cfg80211_crypto_settings {
 	bool control_port;
 	__be16 control_port_ethertype;
 	bool control_port_no_encrypt;
+	bool control_port_over_nl80211;
 	struct key_params *wep_keys;
 	int wep_tx_key;
 	const u8 *psk;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ca3d5a613fc0..20b35ba6721f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
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
@@ -1475,6 +1476,15 @@ enum nl80211_commands {
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
@@ -2627,6 +2637,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NSS,
 
+	NL80211_ATTR_CONTROL_PORT_OVER_NL80211,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4996,6 +5008,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_LOW_SPAN_SCAN: Driver supports low span scan.
  * @NL80211_EXT_FEATURE_LOW_POWER_SCAN: Driver supports low power scan.
  * @NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN: Driver supports high accuracy scan.
+ * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports sending and
+ *     receiving control port frames over NL80211 instead of the netdevice.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5026,6 +5040,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
 	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
+	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc6ec5bab676..0c389044a4d3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -286,6 +286,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CONTROL_PORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CONTROL_PORT_ETHERTYPE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CONTROL_PORT_OVER_NL80211] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
@@ -8225,6 +8226,17 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 	} else
 		settings->control_port_ethertype = cpu_to_be16(ETH_P_PAE);
 
+	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
+		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
+			return -EINVAL;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211))
+			return -EOPNOTSUPP;
+
+		settings->control_port_over_nl80211 = true;
+	}
+
 	if (info->attrs[NL80211_ATTR_CIPHER_SUITES_PAIRWISE]) {
 		void *data;
 		int len, i;
-- 
2.13.5
