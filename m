Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63456 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1IZGgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 02:36:49 -0400
Received: by eya28 with SMTP id 28so3293981eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2011 23:36:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: treat the WME sta flag as a bit
Date: Mon, 26 Sep 2011 09:36:42 +0300
Message-Id: <1317019002-32560-1-git-send-email-arik@wizery.com> (sfid-20110926_083652_818005_1757E7D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct flag usage - use it as a bit index instead of a bit value.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/wireless/nl80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c26a1da..4bb1f48 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2613,7 +2613,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	/* parse WME attributes if sta is WME capable */
 	if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
-	    (params.sta_flags_set & NL80211_STA_FLAG_WME) &&
+	    (params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)) &&
 	    info->attrs[NL80211_ATTR_STA_WME]) {
 		struct nlattr *tb[NL80211_STA_WME_MAX + 1];
 		struct nlattr *nla;
-- 
1.7.4.1

