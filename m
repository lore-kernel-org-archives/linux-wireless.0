Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:40855 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932231AbdL1R6i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 12:58:38 -0500
Received: by mail-io0-f194.google.com with SMTP id v30so7264931iov.7
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 09:58:38 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC 1/4] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
Date: Thu, 28 Dec 2017 11:58:29 -0600
Message-Id: <20171228175832.3253-2-denkenz@gmail.com> (sfid-20171228_185853_802417_80C54F85)
In-Reply-To: <20171228175832.3253-1-denkenz@gmail.com>
References: <20171228175832.3253-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 14 +++++++++++++-
 net/mac80211/cfg.c           |  2 ++
 net/mac80211/ieee80211_i.h   |  1 +
 net/mac80211/mlme.c          |  2 ++
 net/wireless/nl80211.c       | 10 ++++++++++
 6 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3a4a1a903a4d..0aa1c866a73b 100644
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
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b77ee342b5f8..b6f37ae5e3be 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -925,6 +925,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	sdata->control_port_protocol = params->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
+	sdata->control_port_over_nl80211 = false;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(sdata->local,
 							&params->crypto,
 							sdata->vif.type);
@@ -934,6 +935,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			params->crypto.control_port_ethertype;
 		vlan->control_port_no_encrypt =
 			params->crypto.control_port_no_encrypt;
+		vlan->control_port_over_nl80211 = false;
 		vlan->encrypt_headroom =
 			ieee80211_cs_headroom(sdata->local,
 					      &params->crypto,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 26900025de2f..6f91aea6a4cb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -899,6 +899,7 @@ struct ieee80211_sub_if_data {
 	u16 sequence_number;
 	__be16 control_port_protocol;
 	bool control_port_no_encrypt;
+	bool control_port_over_nl80211;
 	int encrypt_headroom;
 
 	atomic_t num_tx_queued;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b9a908..fc71a906939b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4830,6 +4830,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->control_port_protocol = req->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
+	sdata->control_port_over_nl80211 =
+					req->crypto.control_port_over_nl80211;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
 							sdata->vif.type);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3f8970c3a47..f5b4008f40da 100644
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
@@ -8209,6 +8210,15 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 	} else
 		settings->control_port_ethertype = cpu_to_be16(ETH_P_PAE);
 
+	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
+		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
+			return -EINVAL;
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
