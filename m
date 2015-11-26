Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37707 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbbKZP0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 10:26:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>
Subject: [PATCH 1/3] cfg80211: use NL80211_ATTR_STA_AID in nl82011_set_station
Date: Thu, 26 Nov 2015 16:26:12 +0100
Message-Id: <1448551574-3207-1-git-send-email-johannes@sipsolutions.net> (sfid-20151126_162636_662722_3EF09236)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Fix nl80211_set_station() to use the value of NL80211_ATTR_STA_AID
attribute instead of NL80211_ATTR_PEER_AID attribute.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c71e274c810a..5536b69df2ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4256,8 +4256,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	 * station. Include these parameters here and will check them in
 	 * cfg80211_check_station_change().
 	 */
-	if (info->attrs[NL80211_ATTR_PEER_AID])
-		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
+	if (info->attrs[NL80211_ATTR_STA_AID])
+		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
 
 	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
 		params.listen_interval =
-- 
2.6.2

