Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:43889 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaAFH6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 02:58:22 -0500
Date: Mon, 6 Jan 2014 09:51:02 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 1/3] cfg80211: Allow BSS hint to be provided for connect
Message-ID: <20140106075102.GA31031@w1.fi> (sfid-20140106_085826_857964_97D0D9C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This clarifies the expected driver behavior on the older
NL80211_ATTR_MAC and NL80211_ATTR_WIPHY_FREQ attributes and adds a new
set of similar attributes with _HINT postfix to enable use of a
recommendation of the initial BSS to choose. This can be helpful for
some drivers that can avoid an additional full scan on connection
request if the information is provided to them (user space tools like
wpa_supplicant already has that information available based on earlier
scans).

In addition, this can be used to get more expected behavior for cases
where a specific BSS should be picked first based on operations like
Interworking network selection or WPS. These cases were already easily
addressed with drivers that leave BSS selection to user space, but there
was no convenient way to do this with drivers that take care of BSS
selection internally without using the NL80211_ATTR_MAC which is not
really desired since it is needed for other purposes to force the
association to remain with the same BSS.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/net/cfg80211.h       |    8 ++++++++
 include/uapi/linux/nl80211.h |   20 ++++++++++++++++++--
 net/wireless/nl80211.c       |   12 ++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 56c5977..8b5777a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1701,8 +1701,14 @@ struct cfg80211_ibss_params {
  *
  * @channel: The channel to use or %NULL if not specified (auto-select based
  *	on scan results)
+ * @channel_hint: The channel of the recommended BSS for initial connection or
+ *	%NULL if not specified
  * @bssid: The AP BSSID or %NULL if not specified (auto-select based on scan
  *	results)
+ * @bssid_hint: The recommended AP BSSID for initial connection to the BSS or
+ *	%NULL if not specified. Unlike the @bssid parameter, the driver is
+ *	allowed to ignore this @bssid_hint if it has knowledge of a better BSS
+ *	to use.
  * @ssid: SSID
  * @ssid_len: Length of ssid in octets
  * @auth_type: Authentication type (algorithm)
@@ -1725,7 +1731,9 @@ struct cfg80211_ibss_params {
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
+	struct ieee80211_channel *channel_hint;
 	u8 *bssid;
+	u8 *bssid_hint;
 	u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_auth_type auth_type;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..e57de33 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -418,8 +418,18 @@
  *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
  *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_USE_MFP,
  *	%NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
- *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
- *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT, %NL80211_ATTR_MAC_HINT, and
+ *	%NL80211_ATTR_WIPHY_FREQ_HINT.
+ *	If included, %NL80211_ATTR_MAC and %NL80211_ATTR_WIPHY_FREQ are
+ *	restrictions on BSS selection, i.e., they effectively prevent roaming
+ *	within the ESS. %NL80211_ATTR_MAC_HINT and %NL80211_ATTR_WIPHY_FREQ_HINT
+ *	can be included to provide a recommendation of the initial BSS while
+ *	allowing the driver to roam to other BSSes within the ESS and also to
+ *	ignore this recommendation if the indicated BSS is not ideal. Only one
+ *	set of BSSID,frequency parameters is used (i.e., either the enforcing
+ *	%NL80211_ATTR_MAC,%NL80211_ATTR_WIPHY_FREQ or the less strict
+ *	%NL80211_ATTR_MAC_HINT and %NL80211_ATTR_WIPHY_FREQ_HINT).
  *	Background scan period can optionally be
  *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
  *	if not specified default background scan configuration
@@ -1555,6 +1565,9 @@ enum nl80211_commands {
  *	data is in the format defined for the payload of the QoS Map Set element
  *	in IEEE Std 802.11-2012, 8.4.2.97.
  *
+ * @NL80211_ATTR_MAC_HINT: MAC address recommendation as initial BSS
+ * @NL80211_ATTR_WIPHY_FREQ_HINT: frequency of the recommended initial BSS
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1883,6 +1896,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_QOS_MAP,
 
+	NL80211_ATTR_MAC_HINT,
+	NL80211_ATTR_WIPHY_FREQ_HINT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 81bd2ae..a3a6fb7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -384,6 +384,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
+	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
+	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -7021,6 +7023,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_MAC])
 		connect.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	else if (info->attrs[NL80211_ATTR_MAC_HINT])
+		connect.bssid_hint =
+			nla_data(info->attrs[NL80211_ATTR_MAC_HINT]);
 	connect.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
 	connect.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
@@ -7045,6 +7050,13 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		if (!connect.channel ||
 		    connect.channel->flags & IEEE80211_CHAN_DISABLED)
 			return -EINVAL;
+	} else if (info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]) {
+		connect.channel_hint =
+			ieee80211_get_channel(wiphy,
+					      nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]));
+		if (!connect.channel_hint ||
+		    connect.channel_hint->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
 	}
 
 	if (connect.privacy && info->attrs[NL80211_ATTR_KEYS]) {
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
