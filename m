Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3BZVMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:12:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: prohibit zero keepalive interval
Date: Tue, 26 Feb 2013 22:12:46 +0100
Message-Id: <1361913166-17570-1-git-send-email-johannes@sipsolutions.net> (sfid-20130226_221256_413864_51CD2849)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's not useful to specify a 0 keepalive interval, this
would send too much data. Prohibit this to also avoid
device issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2af3950..67bda6c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7603,7 +7603,8 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	if (nla_get_u32(tb[NL80211_WOWLAN_TCP_DATA_INTERVAL]) >
-			rdev->wiphy.wowlan.tcp->data_interval_max)
+			rdev->wiphy.wowlan.tcp->data_interval_max ||
+	    nla_get_u32(tb[NL80211_WOWLAN_TCP_DATA_INTERVAL]) == 0)
 		return -EINVAL;
 
 	wake_size = nla_len(tb[NL80211_WOWLAN_TCP_WAKE_PAYLOAD]);
-- 
1.8.0

