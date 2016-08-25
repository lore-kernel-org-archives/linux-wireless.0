Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:20548 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbcHYTWB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 15:22:01 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] nl80211: initialize state.filter_wiphy in nl80211_dump_interface()
Date: Thu, 25 Aug 2016 20:20:54 +0100
Message-Id: <1472152854-3183-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160825_212214_311381_0C1A69A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In nl80211_dump_interface() the filter_wiphy variable was set to -1.
However, that does not help as message may not contain wiphy or wdev
attribute. Instead initialize state.filter_wiphy as is done in
nl80211_dump_wiphy().

Fixes: 2d75da13fbb9 ("nl80211: Allow GET_INTERFACE dumps to be filtered")
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 95d55d2..681c689 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2525,7 +2525,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 	int if_idx = 0;
 	int wp_start = cb->args[0];
 	int if_start = cb->args[1];
-	int filter_wiphy = -1;
+	int filter_wiphy;
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 
@@ -2534,6 +2534,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 		struct nl80211_dump_wiphy_state state = {};
 		int ret;
 
+		state.filter_wiphy = -1;
 		ret = nl80211_dump_wiphy_parse(skb, cb, &state);
 		if (ret)
 			return ret;
-- 
1.9.1
