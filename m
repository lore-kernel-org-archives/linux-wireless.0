Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59839 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2LLV4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:56:06 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 3/6] mac80211: Check for NULL in get-ethtool-stats logic.
Date: Wed, 12 Dec 2012 13:54:52 -0800
Message-Id: <1355349295-30960-3-git-send-email-greearb@candelatech.com> (sfid-20121212_225626_327122_3F8FF5FB)
In-Reply-To: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

In an earlier version of this code, testing found that sometimes
either sta wasn't found or sta->sdata was NULL.  This caused
crashes of course.  So, add checks with WARN_ON_ONCE to
catch these.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/cfg.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5c61677..1e6dcc3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -599,7 +599,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
 
-		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
+		if (sta == NULL || WARN_ON_ONCE(sta->sdata == NULL)
+		    || WARN_ON(sta->sdata->dev != dev))
 			goto do_survey;
 
 		i = 0;
@@ -625,7 +626,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 	} else {
 		list_for_each_entry(sta, &local->sta_list, list) {
 			/* Make sure this station belongs to the proper dev */
-			if (sta->sdata->dev != dev)
+			if (WARN_ON_ONCE(sta->sdata == NULL) ||
+			    sta->sdata->dev != dev)
 				continue;
 
 			i = 0;
-- 
1.7.3.4

