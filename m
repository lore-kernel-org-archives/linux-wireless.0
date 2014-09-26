Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:52590 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756003AbaIZTfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 15:35:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Fri, 26 Sep 2014 22:34:59 +0300
Message-Id: <1411760105-18614-2-git-send-email-luca@coelho.fi> (sfid-20140926_213549_412908_C6A0A843)
In-Reply-To: <1411760105-18614-1-git-send-email-luca@coelho.fi>
References: <1411760105-18614-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 1/7] nl80211: sanity check the channel switch counter value
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The nl80211 channel switch count attribute
(NL80211_ATTR_CH_SWITCH_COUNT) is specified as u32, but the
specification uses u8 for the counter.  To make sure strange things
don't happen without informing the user, sanity check the value and
return -EINVAL if it doesn't fit in u8.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4cce3e1..9e29053 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5927,6 +5927,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	int err;
 	bool need_new_beacon = false;
 	int len, i;
+	u32 cs_count;
 
 	if (!rdev->ops->channel_switch ||
 	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
@@ -5963,7 +5964,14 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (need_new_beacon && !info->attrs[NL80211_ATTR_CSA_IES])
 		return -EINVAL;
 
-	params.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+	/* Even though the attribute is u32, the specification says
+	 * u8, so let's make sure we don't overflow.
+	 */
+	cs_count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+	if (cs_count > 255)
+		return -EINVAL;
+
+	params.count = cs_count;
 
 	if (!need_new_beacon)
 		goto skip_beacons;
-- 
2.1.0

