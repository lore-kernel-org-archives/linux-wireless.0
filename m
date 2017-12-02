Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52088 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752317AbdLBUXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 15:23:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: j@w1.fi, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net 2/2] nl80211: use NLA_U8_BUGGY for two attributes
Date: Sat,  2 Dec 2017 21:23:32 +0100
Message-Id: <20171202202332.10205-2-johannes@sipsolutions.net> (sfid-20171202_212359_352827_2F1DAFA7)
In-Reply-To: <20171202202332.10205-1-johannes@sipsolutions.net>
References: <20171202202332.10205-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We discovered that these are set incorrectly by the
corresponding userspace code, so keep compatible with
their bugs even if they'd always set the value to 0.

Reported-by: Jouni Malinen <j@w1.fi>
Fixes: 28033ae4e0f5 ("net: netlink: Update attr validation to require exact length for some types")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b1ac23ca20c8..751b4efbf09a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -384,7 +384,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_TSID] = { .type = NLA_U8 },
 	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
-	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8_BUGGY },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
@@ -5830,7 +5830,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_MAX_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_TTL] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_ELEMENT_TTL] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8_BUGGY },
 	[NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_PATH_REFRESH_TIME] = { .type = NLA_U32 },
-- 
2.14.2
