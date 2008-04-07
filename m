Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbYDGNGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 09:06:10 -0400
Subject: [PATCH] nl80211: fix STA AID bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Bas Hulsken <bhulsken@zonnet.nl>,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 14:35:46 +0200
Message-Id: <1207571746.12481.2.camel@johannes.berg> (sfid-20080407_140623_671923_7348040E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the STA AID setting and actually makes hostapd/mac80211
work properly in presence of power-saving stations.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Makes me want to hurt myself.

 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/wireless/nl80211.c	2008-04-07 14:14:20.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-04-07 14:14:39.000000000 +0200
@@ -1161,7 +1161,7 @@ static int nl80211_new_station(struct sk
 		nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
-	params.listen_interval = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
 
 	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
 				&params.station_flags))


