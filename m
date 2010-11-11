Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56853 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469Ab0KKOHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:07:32 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/2] cfg80211: add support for setting the ad-hoc multicast rate
Date: Thu, 11 Nov 2010 15:07:22 +0100
Message-Id: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    4 ++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index fb877b5..9ee61fa 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -804,6 +804,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_IBSS_RSN: The device supports IBSS RSN, which mostly
  *	means support for per-station GTKs.
  *
+ * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -973,6 +975,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORT_IBSS_RSN,
 
+	NL80211_ATTR_MCAST_RATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e5702f5..15cc593 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -923,6 +923,7 @@ struct cfg80211_disassoc_request {
  * @privacy: this is a protected network, keys will be configured
  *	after joining
  * @basic_rates: bitmap of basic rates to use when creating the IBSS
+ * @mcast_rate: multicast tx rate (in 100 kbps)
  */
 struct cfg80211_ibss_params {
 	u8 *ssid;
@@ -934,6 +935,7 @@ struct cfg80211_ibss_params {
 	u32 basic_rates;
 	bool channel_fixed;
 	bool privacy;
+	int mcast_rate;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4e78e3f..b3da2e0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -167,6 +167,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_TX_POWER_SETTING] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] = { .type = NLA_U32 },
 	[NL80211_ATTR_FRAME_TYPE] = { .type = NLA_U16 },
+	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3652,6 +3653,9 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 				return -EINVAL;
 		}
 	}
+	if (info->attrs[NL80211_ATTR_MCAST_RATE])
+		ibss.mcast_rate =
+			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
 
 	if (ibss.privacy && info->attrs[NL80211_ATTR_KEYS]) {
 		connkeys = nl80211_parse_connkeys(rdev,
-- 
1.7.2.2

