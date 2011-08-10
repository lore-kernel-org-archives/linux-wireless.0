Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22859 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1HJUym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:54:42 -0400
Date: Wed, 10 Aug 2011 23:54:35 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] nl80211/cfg80211: Add crypto settings into NEW_BEACON
Message-ID: <20110810205435.GA3806@jouni.qca.qualcomm.com> (sfid-20110810_225446_063080_04516653)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes need from drivers to parse the beacon tail/head data
to figure out what crypto settings are to be used in AP mode in case
the Beacon and Probe Response frames are fully constructed in the
driver/firmware.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/nl80211.h |   25 ++++++++++-------
 include/net/cfg80211.h  |   66 +++++++++++++++++++++++++---------------------
 net/wireless/nl80211.c  |   21 +++++++++++++++
 3 files changed, 72 insertions(+), 40 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 227ee9a..580fcdc 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -163,7 +163,10 @@
  *	%NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL attributes.
  *	Following attributes are provided for drivers that generate full Beacon
  *	and Probe Response frames internally: %NL80211_ATTR_SSID,
- *	%NL80211_ATTR_HIDDEN_SSID.
+ *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
+ *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
+ *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
+ *	%NL80211_ATTR_AUTH_TYPE.
  * @NL80211_CMD_NEW_BEACON: add a new beacon to an access point interface,
  *	parameters are like for %NL80211_CMD_SET_BEACON.
  * @NL80211_CMD_DEL_BEACON: remove the beacon, stop sending it
@@ -845,18 +848,20 @@ enum nl80211_commands {
  * @NL80211_ATTR_STATUS_CODE: StatusCode for the %NL80211_CMD_CONNECT
  *	event (u16)
  * @NL80211_ATTR_PRIVACY: Flag attribute, used with connect(), indicating
- *	that protected APs should be used.
+ *	that protected APs should be used. This is also used with NEW_BEACON to
+ *	indicate that the BSS is to use protection.
  *
- * @NL80211_ATTR_CIPHERS_PAIRWISE: Used with CONNECT and ASSOCIATE to
- *	indicate which unicast key ciphers will be used with the connection
+ * @NL80211_ATTR_CIPHERS_PAIRWISE: Used with CONNECT, ASSOCIATE, and NEW_BEACON
+ *	to indicate which unicast key ciphers will be used with the connection
  *	(an array of u32).
- * @NL80211_ATTR_CIPHER_GROUP: Used with CONNECT and ASSOCIATE to indicate
- *	which group key cipher will be used with the connection (a u32).
- * @NL80211_ATTR_WPA_VERSIONS: Used with CONNECT and ASSOCIATE to indicate
- *	which WPA version(s) the AP we want to associate with is using
+ * @NL80211_ATTR_CIPHER_GROUP: Used with CONNECT, ASSOCIATE, and NEW_BEACON to
+ *	indicate which group key cipher will be used with the connection (a
+ *	u32).
+ * @NL80211_ATTR_WPA_VERSIONS: Used with CONNECT, ASSOCIATE, and NEW_BEACON to
+ *	indicate which WPA version(s) the AP we want to associate with is using
  *	(a u32 with flags from &enum nl80211_wpa_versions).
- * @NL80211_ATTR_AKM_SUITES: Used with CONNECT and ASSOCIATE to indicate
- *	which key management algorithm(s) to use (an array of u32).
+ * @NL80211_ATTR_AKM_SUITES: Used with CONNECT, ASSOCIATE, and NEW_BEACON to
+ *	indicate which key management algorithm(s) to use (an array of u32).
  *
  * @NL80211_ATTR_REQ_IE: (Re)association request information elements as
  *	sent out by the card, for ROAM and successful CONNECT events.
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 27c5eec..e530e9b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -334,6 +334,36 @@ struct survey_info {
 };
 
 /**
+ * struct cfg80211_crypto_settings - Crypto settings
+ * @wpa_versions: indicates which, if any, WPA versions are enabled
+ *	(from enum nl80211_wpa_versions)
+ * @cipher_group: group key cipher suite (or 0 if unset)
+ * @n_ciphers_pairwise: number of AP supported unicast ciphers
+ * @ciphers_pairwise: unicast key cipher suites
+ * @n_akm_suites: number of AKM suites
+ * @akm_suites: AKM suites
+ * @control_port: Whether user space controls IEEE 802.1X port, i.e.,
+ *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
+ *	required to assume that the port is unauthorized until authorized by
+ *	user space. Otherwise, port is marked authorized by default.
+ * @control_port_ethertype: the control port protocol that should be
+ *	allowed through even on unauthorized ports
+ * @control_port_no_encrypt: TRUE to prevent encryption of control port
+ *	protocol frames.
+ */
+struct cfg80211_crypto_settings {
+	u32 wpa_versions;
+	u32 cipher_group;
+	int n_ciphers_pairwise;
+	u32 ciphers_pairwise[NL80211_MAX_NR_CIPHER_SUITES];
+	int n_akm_suites;
+	u32 akm_suites[NL80211_MAX_NR_AKM_SUITES];
+	bool control_port;
+	__be16 control_port_ethertype;
+	bool control_port_no_encrypt;
+};
+
+/**
  * struct beacon_parameters - beacon parameters
  *
  * Used to configure the beacon for an interface.
@@ -350,6 +380,9 @@ struct survey_info {
  *	user space)
  * @ssid_len: length of @ssid
  * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
+ * @crypto: crypto settings
+ * @privacy: the BSS uses privacy
+ * @auth_type: Authentication type (algorithm)
  */
 struct beacon_parameters {
 	u8 *head, *tail;
@@ -358,6 +391,9 @@ struct beacon_parameters {
 	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_hidden_ssid hidden_ssid;
+	struct cfg80211_crypto_settings crypto;
+	bool privacy;
+	enum nl80211_auth_type auth_type;
 };
 
 /**
@@ -906,36 +942,6 @@ const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie);
 
 
 /**
- * struct cfg80211_crypto_settings - Crypto settings
- * @wpa_versions: indicates which, if any, WPA versions are enabled
- *	(from enum nl80211_wpa_versions)
- * @cipher_group: group key cipher suite (or 0 if unset)
- * @n_ciphers_pairwise: number of AP supported unicast ciphers
- * @ciphers_pairwise: unicast key cipher suites
- * @n_akm_suites: number of AKM suites
- * @akm_suites: AKM suites
- * @control_port: Whether user space controls IEEE 802.1X port, i.e.,
- *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
- *	required to assume that the port is unauthorized until authorized by
- *	user space. Otherwise, port is marked authorized by default.
- * @control_port_ethertype: the control port protocol that should be
- *	allowed through even on unauthorized ports
- * @control_port_no_encrypt: TRUE to prevent encryption of control port
- *	protocol frames.
- */
-struct cfg80211_crypto_settings {
-	u32 wpa_versions;
-	u32 cipher_group;
-	int n_ciphers_pairwise;
-	u32 ciphers_pairwise[NL80211_MAX_NR_CIPHER_SUITES];
-	int n_akm_suites;
-	u32 akm_suites[NL80211_MAX_NR_AKM_SUITES];
-	bool control_port;
-	__be16 control_port_ethertype;
-	bool control_port_no_encrypt;
-};
-
-/**
  * struct cfg80211_auth_request - Authentication request data
  *
  * This structure provides information needed to complete IEEE 802.11
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c2d7a9a..8388861 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -23,6 +23,12 @@
 #include "nl80211.h"
 #include "reg.h"
 
+static bool nl80211_valid_auth_type(enum nl80211_auth_type auth_type);
+static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
+				   struct genl_info *info,
+				   struct cfg80211_crypto_settings *settings,
+				   int cipher_limit);
+
 static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info);
 static void nl80211_post_doit(struct genl_ops *ops, struct sk_buff *skb,
@@ -2039,6 +2045,21 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
 				return -EINVAL;
 		}
 
+		params.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
+
+		if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
+			params.auth_type = nla_get_u32(
+				info->attrs[NL80211_ATTR_AUTH_TYPE]);
+			if (!nl80211_valid_auth_type(params.auth_type))
+				return -EINVAL;
+		} else
+			params.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+
+		err = nl80211_crypto_settings(rdev, info, &params.crypto,
+					      NL80211_MAX_NR_CIPHER_SUITES);
+		if (err)
+			return err;
+
 		call = rdev->ops->add_beacon;
 		break;
 	case NL80211_CMD_SET_BEACON:
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
