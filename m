Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43203 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbcHOSHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 14:07:48 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, Peng Xu <pxu@qca.qualcomm.com>,
	"Jouni Malinen" <jouni@qca.qualcomm.com>
Subject: [PATCH] cfg80211: Add HT and VHT information in start_ap
Date: Mon, 15 Aug 2016 21:07:04 +0300
Message-ID: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20160815_200753_360228_E38127E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peng Xu <pxu@qca.qualcomm.com>

Add HT and VHT information in struct cfg80211_ap_settings when
starting ap so that driver does not need to parse IE to obtain
the information.

Signed-off-by: Peng Xu <pxu@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 15 +++++++++++++++
 include/uapi/linux/nl80211.h | 16 ++++++++++++++++
 net/wireless/nl80211.c       | 28 ++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..6292d35 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -676,6 +676,12 @@ struct cfg80211_acl_data {
 	struct mac_address mac_addrs[];
 };
 
+enum ht_vht_support {
+	HT_VHT_DISABLED,
+	HT_VHT_ENABLED,
+	HT_VHT_NOT_INDICATED
+};
+
 /**
  * struct cfg80211_ap_settings - AP configuration
  *
@@ -700,6 +706,10 @@ struct cfg80211_acl_data {
  *	MAC address based access control
  * @pbss: If set, start as a PCP instead of AP. Relevant for DMG
  *	networks.
+ * @ht_enabled: if HT capability is enabled/disabled/not indicated
+ * @vht_enabled: if VHT capability is enabled/disabled/not indicated
+ * @require_ht: require stations to support HT PHY
+ * @require_vht: require stations to support VHT PHY
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -719,6 +729,11 @@ struct cfg80211_ap_settings {
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
 	bool pbss;
+	enum ht_vht_support ht_enabled;
+	enum ht_vht_support vht_enabled;
+	enum ht_vht_support require_ht;
+	enum ht_vht_support require_vht;
+
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..3ce88ff 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1867,6 +1867,17 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer (u16). This is
  *	used to pull the stored data for mesh peer in power save state.
  *
+ * @NL80211_ATTR_HT_ENABLED: u8 value to indicate if HT capability is enabled.
+ *	0=disabled, 1=enabled, not being included as being no value available
+ * @NL80211_ATTR_VHT_ENABLED: u8 value to indicate if VHT capability is enabled.
+ *	0=disabled, 1=enabled, not being included as being no value available
+ * @NL80211_ATTR_REQUIRE_HT: u8 value to require stations to support HT phy.
+ *	0=not required, 1=required, not being included as being no value
+ *	available
+ * @NL80211_ATTR_REQUIRE_VHT: u8 value to require stations to support VHT phy.
+ *	0=not required, 1=required, not being included as being no value
+ *	available
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2261,6 +2272,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MESH_PEER_AID,
 
+	NL80211_ATTR_HT_ENABLED,
+	NL80211_ATTR_VHT_ENABLED,
+	NL80211_ATTR_REQUIRE_HT,
+	NL80211_ATTR_REQUIRE_VHT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4997857..5f66abf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -409,6 +409,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		.len = VHT_MUMIMO_GROUPS_DATA_LEN
 	},
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
+	[NL80211_ATTR_HT_ENABLED] { .type = NLA_U8 },
+	[NL80211_ATTR_VHT_ENABLED] { .type = NLA_U8 },
+	[NL80211_ATTR_REQUIRE_HT] { .type = NLA_U8 },
+	[NL80211_ATTR_REQUIRE_VHT] { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -3557,6 +3561,30 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	if (info->attrs[NL80211_ATTR_HT_ENABLED])
+		params.ht_enabled = nla_get_u8(
+			info->attrs[NL80211_ATTR_HT_ENABLED]);
+	else
+		params.ht_enabled = HT_VHT_NOT_INDICATED;
+
+	if (info->attrs[NL80211_ATTR_VHT_ENABLED])
+		params.vht_enabled = nla_get_u8(
+			info->attrs[NL80211_ATTR_VHT_ENABLED]);
+	else
+		params.vht_enabled = HT_VHT_NOT_INDICATED;
+
+	if (info->attrs[NL80211_ATTR_REQUIRE_HT])
+		params.require_ht = nla_get_u8(
+			info->attrs[NL80211_ATTR_REQUIRE_HT]);
+	else
+		params.require_ht = HT_VHT_NOT_INDICATED;
+
+	if (info->attrs[NL80211_ATTR_REQUIRE_VHT])
+		params.require_vht = nla_get_u8(
+			info->attrs[NL80211_ATTR_REQUIRE_VHT]);
+	else
+		params.require_vht = HT_VHT_NOT_INDICATED;
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
1.9.1

