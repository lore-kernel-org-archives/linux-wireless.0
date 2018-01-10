Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46155 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933445AbeAJRJt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 12:09:49 -0500
Received: by mail-pg0-f67.google.com with SMTP id r2so11290893pgq.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 09:09:48 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v2 1/5] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
Date: Wed, 10 Jan 2018 11:09:34 -0600
Message-Id: <20180110170938.2341-2-denkenz@gmail.com> (sfid-20180110_180956_952258_12ECA7BD)
In-Reply-To: <20180110170938.2341-1-denkenz@gmail.com>
References: <20180110170938.2341-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h | 14 +++++++++++++-
 net/wireless/nl80211.c       | 20 ++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3a4a1a903a4d..f46bdc4298f1 100644
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
@@ -3236,6 +3239,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_CONTROL_PORT_PROTOCOL: This device supports setting the
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
+ * @WIPHY_FLAG_CONTROL_PORT_OVER_NL80211: This device supports sending and
+ *	receiving control port frames over NL80211 instead of the netdevice.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
@@ -3288,6 +3293,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
+	WIPHY_FLAG_CONTROL_PORT_OVER_NL80211	= BIT(25),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c587a61c32bf..8855b7eaf92c 100644
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
@@ -1445,6 +1446,15 @@ enum nl80211_commands {
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
@@ -2579,6 +2589,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKR0_NAME,
 	NL80211_ATTR_PORT_AUTHORIZED,
 
+	NL80211_ATTR_CONTROL_PORT_OVER_NL80211,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3f8970c3a47..840ee6d73269 100644
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
@@ -1547,6 +1548,13 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		    nla_put_flag(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE))
 			goto nla_put_failure;
 
+		if (rdev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_OVER_NL80211) {
+			int type = NL80211_ATTR_CONTROL_PORT_OVER_NL80211;
+
+			if (nla_put_flag(msg, type))
+				goto nla_put_failure;
+		}
+
 		if (nla_put_u32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 				rdev->wiphy.available_antennas_tx) ||
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
@@ -8209,6 +8217,18 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 	} else
 		settings->control_port_ethertype = cpu_to_be16(ETH_P_PAE);
 
+	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
+		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
+			return -EINVAL;
+
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_OVER_NL80211))
+			return -EOPNOTSUPP;
+
+		settings->control_port_over_nl80211 = true;
+	} else {
+		settings->control_port_over_nl80211 = false;
+	}
+
 	if (info->attrs[NL80211_ATTR_CIPHER_SUITES_PAIRWISE]) {
 		void *data;
 		int len, i;
-- 
2.13.5
