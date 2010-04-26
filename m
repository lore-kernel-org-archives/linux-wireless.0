Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39932 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab0DZXYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 19:24:01 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/2] cfg80211: add ap isolation support
Date: Tue, 27 Apr 2010 01:23:35 +0200
Message-Id: <1272324216-73349-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used to configure APs to not bridge traffic between connected stations.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    4 ++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2ea3ede..f8750f9 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -709,6 +709,9 @@ enum nl80211_commands {
  *	NL80211_CMD_AUTHENTICATE, NL80211_CMD_DEAUTHENTICATE,
  *	NL80211_CMD_DISASSOCIATE.
  *
+ * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
+ *	connected to this BSS.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -864,6 +867,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_LOCAL_STATE_CHANGE,
 
+	NL80211_ATTR_AP_ISOLATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5a4efe5..f6b29bf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -511,6 +511,7 @@ struct mpath_info {
  * @basic_rates: basic rates in IEEE 802.11 format
  *	(or NULL for no change)
  * @basic_rates_len: number of basic rates
+ * @ap_isolate: do not forward packets between connected stations
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -518,6 +519,7 @@ struct bss_parameters {
 	int use_short_slot_time;
 	u8 *basic_rates;
 	u8 basic_rates_len;
+	int ap_isolate;
 };
 
 struct mesh_config {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 356a84a..01da83d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -152,6 +152,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
+	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
 };
 
 /* policy for the attributes */
@@ -2442,6 +2443,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	params.use_cts_prot = -1;
 	params.use_short_preamble = -1;
 	params.use_short_slot_time = -1;
+	params.ap_isolate = -1;
 
 	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
 		params.use_cts_prot =
@@ -2458,6 +2460,8 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 		params.basic_rates_len =
 			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
 	}
+	if (info->attrs[NL80211_ATTR_AP_ISOLATE])
+		params.ap_isolate = !!nla_get_u8(info->attrs[NL80211_ATTR_AP_ISOLATE]);
 
 	rtnl_lock();
 
-- 
1.6.4.2

