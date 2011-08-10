Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41729 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1HJU4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:56:03 -0400
Date: Wed, 10 Aug 2011 23:55:56 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] nl80211/cfg80211: Add extra IE configuration to AP mode
 setup
Message-ID: <20110810205556.GA3821@jouni.qca.qualcomm.com> (sfid-20110810_225608_162051_7F66DC03)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NL80211_CMD_NEW_BEACON command is, in practice, requesting AP mode
operations to be started. Add new attributes to provide extra IEs
(e.g., WPS IE, P2P IE) for drivers that build Beacon, Probe Response,
and (Re)Association Response frames internally (likely in firmware).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/nl80211.h |   16 +++++++++++++++-
 include/net/cfg80211.h  |   14 ++++++++++++++
 net/wireless/nl80211.c  |   28 +++++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 580fcdc..89dec16 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -166,7 +166,8 @@
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE.
+ *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_IE, %NL80211_ATTR_IE_PROBE_RESP,
+ *	%NL80211_ATTR_IE_ASSOC_RESP.
  * @NL80211_CMD_NEW_BEACON: add a new beacon to an access point interface,
  *	parameters are like for %NL80211_CMD_SET_BEACON.
  * @NL80211_CMD_DEL_BEACON: remove the beacon, stop sending it
@@ -1031,6 +1032,16 @@ enum nl80211_commands {
  *	and Probe Response (when response to wildcard Probe Request); see
  *	&enum nl80211_hidden_ssid, represented as a u32
  *
+ * @NL80211_ATTR_IE_PROBE_RESP: Information element(s) for Probe Response frame.
+ *	This is used with %NL80211_CMD_NEW_BEACON and %NL80211_CMD_SET_BEACON to
+ *	provide extra IEs (e.g., WPS/P2P IE) into Probe Response frames when the
+ *	driver (or firmware) replies to Probe Request frames.
+ * @NL80211_ATTR_IE_ASSOC_RESP: Information element(s) for (Re)Association
+ *	Response frames. This is used with %NL80211_CMD_NEW_BEACON and
+ *	%NL80211_CMD_SET_BEACON to provide extra IEs (e.g., WPS/P2P IE) into
+ *	(Re)Association Response frames when the driver (or firmware) replies to
+ *	(Re)Association Request frames.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1238,6 +1249,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HIDDEN_SSID,
 
+	NL80211_ATTR_IE_PROBE_RESP,
+	NL80211_ATTR_IE_ASSOC_RESP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e530e9b..5d7bb1a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -383,6 +383,14 @@ struct cfg80211_crypto_settings {
  * @crypto: crypto settings
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
+ * @beacon_ies: extra information element(s) to add into Beacon frames or %NULL
+ * @beacon_ies_len: length of beacon_ies in octets
+ * @proberesp_ies: extra information element(s) to add into Probe Response
+ *	frames or %NULL
+ * @proberesp_ies_len: length of proberesp_ies in octets
+ * @assocresp_ies: extra information element(s) to add into (Re)Association
+ *	Response frames or %NULL
+ * @assocresp_ies_len: length of assocresp_ies in octets
  */
 struct beacon_parameters {
 	u8 *head, *tail;
@@ -394,6 +402,12 @@ struct beacon_parameters {
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
 	enum nl80211_auth_type auth_type;
+	const u8 *beacon_ies;
+	size_t beacon_ies_len;
+	const u8 *proberesp_ies;
+	size_t proberesp_ies_len;
+	const u8 *assocresp_ies;
+	size_t assocresp_ies_len;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8388861..ed06491 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -185,6 +185,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_REKEY_DATA] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SUPP_RATES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_HIDDEN_SSID] = { .type = NLA_U32 },
+	[NL80211_ATTR_IE_PROBE_RESP] = { .type = NLA_BINARY,
+					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
+					 .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the key attributes */
@@ -1991,7 +1995,10 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
 	struct beacon_parameters params;
 	int haveinfo = 0, err;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_BEACON_TAIL]))
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_BEACON_TAIL]) ||
+	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]) ||
+	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_PROBE_RESP]) ||
+	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]))
 		return -EINVAL;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -2090,6 +2097,25 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (!haveinfo)
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_IE]) {
+		params.beacon_ies = nla_data(info->attrs[NL80211_ATTR_IE]);
+		params.beacon_ies_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	if (info->attrs[NL80211_ATTR_IE_PROBE_RESP]) {
+		params.proberesp_ies =
+			nla_data(info->attrs[NL80211_ATTR_IE_PROBE_RESP]);
+		params.proberesp_ies_len =
+			nla_len(info->attrs[NL80211_ATTR_IE_PROBE_RESP]);
+	}
+
+	if (info->attrs[NL80211_ATTR_IE_ASSOC_RESP]) {
+		params.assocresp_ies =
+			nla_data(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
+		params.assocresp_ies_len =
+			nla_len(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
+	}
+
 	err = call(&rdev->wiphy, dev, &params);
 	if (!err && params.interval)
 		wdev->beacon_interval = params.interval;
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
