Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:26342 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0H0L1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:27:16 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCHv2 3/4] cfg80211: allow changing port control protocol
Date: Fri, 27 Aug 2010 14:26:53 +0300
Message-Id: <1282908414-26783-4-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1282908414-26783-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1282908414-26783-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some vendor specified mechanisms for 802.1X-style
functionality use a different protocol than EAP
(even if EAP is vendor-extensible). Allow setting
the ethertype for the protocol when a driver has
support for this. The default if unspecified is
EAP, of course.

Note: This is suitable only for station mode, not
      for AP implementation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/linux/nl80211.h |   16 +++++++++++++++-
 include/net/cfg80211.h  |   24 +++++++++++++++++-------
 net/wireless/nl80211.c  |   25 ++++++++++++++++++++++---
 net/wireless/wext-sme.c |    2 ++
 4 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ec1690d..31603e8 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -295,7 +295,9 @@
  *	auth and assoc steps. For this, you need to specify the SSID in a
  *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
  *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_MAC,
- *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_CONTROL_PORT.
+ *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
+ *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
  *	It is also sent as an event, with the BSSID and response IEs when the
  *	connection is established or failed to be established. This can be
  *	determined by the STATUS_CODE attribute.
@@ -686,6 +688,15 @@ enum nl80211_commands {
  *	request, the driver will assume that the port is unauthorized until
  *	authorized by user space. Otherwise, port is marked authorized by
  *	default in station mode.
+ * @NL80211_ATTR_CONTROL_PORT_ETHERTYPE: A 16-bit value indicating the
+ *	ethertype that will be used for key negotiation. It can be
+ *	specified with the associate and connect commands. If it is not
+ *	specified, the value defaults to 0x888E (PAE, 802.1X). This
+ *	attribute is also used as a flag in the wiphy information to
+ *	indicate that protocols other than PAE are supported.
+ * @NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT: When included along with
+ *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE, indicates that the custom
+ *	ethertype frames used for key negotiation must not be encrypted.
  *
  * @NL80211_ATTR_TESTDATA: Testmode data blob, passed through to the driver.
  *	We recommend using nested, driver-specific attributes within this.
@@ -951,6 +962,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_RX_FRAME_TYPES,
 	NL80211_ATTR_FRAME_TYPE,
 
+	NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
+	NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f274053..4c8c727 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -763,6 +763,10 @@ const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie);
  *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
  *	required to assume that the port is unauthorized until authorized by
  *	user space. Otherwise, port is marked authorized by default.
+ * @control_port_ethertype: the control port protocol that should be
+ *	allowed through even on unauthorized ports
+ * @control_port_no_encrypt: TRUE to prevent encryption of control port
+ *	protocol frames.
  */
 struct cfg80211_crypto_settings {
 	u32 wpa_versions;
@@ -772,6 +776,8 @@ struct cfg80211_crypto_settings {
 	int n_akm_suites;
 	u32 akm_suites[NL80211_MAX_NR_AKM_SUITES];
 	bool control_port;
+	__be16 control_port_ethertype;
+	bool control_port_no_encrypt;
 };
 
 /**
@@ -1293,15 +1299,19 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_4ADDR_AP: supports 4addr mode even on AP (with a single station
  *	on a VLAN interface)
  * @WIPHY_FLAG_4ADDR_STATION: supports 4addr mode even as a station
+ * @WIPHY_FLAG_CONTROL_PORT_PROTOCOL: This device supports setting the
+ *	control port protocol ethertype. The device also honours the
+ *	control_port_no_encrypt flag.
  */
 enum wiphy_flags {
-	WIPHY_FLAG_CUSTOM_REGULATORY	= BIT(0),
-	WIPHY_FLAG_STRICT_REGULATORY	= BIT(1),
-	WIPHY_FLAG_DISABLE_BEACON_HINTS	= BIT(2),
-	WIPHY_FLAG_NETNS_OK		= BIT(3),
-	WIPHY_FLAG_PS_ON_BY_DEFAULT	= BIT(4),
-	WIPHY_FLAG_4ADDR_AP		= BIT(5),
-	WIPHY_FLAG_4ADDR_STATION	= BIT(6),
+	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
+	WIPHY_FLAG_STRICT_REGULATORY		= BIT(1),
+	WIPHY_FLAG_DISABLE_BEACON_HINTS		= BIT(2),
+	WIPHY_FLAG_NETNS_OK			= BIT(3),
+	WIPHY_FLAG_PS_ON_BY_DEFAULT		= BIT(4),
+	WIPHY_FLAG_4ADDR_AP			= BIT(5),
+	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
+	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 };
 
 struct mac_address {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 49f5ca3..85a23de 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -136,6 +136,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = sizeof(struct nl80211_sta_flag_update),
 	},
 	[NL80211_ATTR_CONTROL_PORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CONTROL_PORT_ETHERTYPE] = { .type = NLA_U16 },
+	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
@@ -474,6 +476,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_PMKIDS,
 		   dev->wiphy.max_num_pmkids);
 
+	if (dev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE);
+
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
 	if (!nl_modes)
 		goto nla_put_failure;
@@ -3691,7 +3696,8 @@ unlock_rtnl:
 	return err;
 }
 
-static int nl80211_crypto_settings(struct genl_info *info,
+static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
+				   struct genl_info *info,
 				   struct cfg80211_crypto_settings *settings,
 				   int cipher_limit)
 {
@@ -3699,6 +3705,19 @@ static int nl80211_crypto_settings(struct genl_info *info,
 
 	settings->control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
 
+	if (info->attrs[NL80211_ATTR_CONTROL_PORT_ETHERTYPE]) {
+		u16 proto;
+		proto = nla_get_u16(
+			info->attrs[NL80211_ATTR_CONTROL_PORT_ETHERTYPE]);
+		settings->control_port_ethertype = cpu_to_be16(proto);
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL) &&
+		    proto != ETH_P_PAE)
+			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT])
+			settings->control_port_no_encrypt = true;
+	} else
+		settings->control_port_ethertype = cpu_to_be16(ETH_P_PAE);
+
 	if (info->attrs[NL80211_ATTR_CIPHER_SUITES_PAIRWISE]) {
 		void *data;
 		int len, i;
@@ -3826,7 +3845,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_PREV_BSSID])
 		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
 
-	err = nl80211_crypto_settings(info, &crypto, 1);
+	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 					  ssid, ssid_len, ie, ie_len, use_mfp,
@@ -4303,7 +4322,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
 
-	err = nl80211_crypto_settings(info, &connect.crypto,
+	err = nl80211_crypto_settings(rdev, info, &connect.crypto,
 				      NL80211_MAX_NR_CIPHER_SUITES);
 	if (err)
 		return err;
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 9818198..6fffe62 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -197,6 +197,8 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 	wdev->wext.connect.ssid_len = len;
 
 	wdev->wext.connect.crypto.control_port = false;
+	wdev->wext.connect.crypto.control_port_ethertype =
+					cpu_to_be16(ETH_P_PAE);
 
 	err = cfg80211_mgd_wext_connect(rdev, wdev);
  out:
-- 
1.6.3.3

