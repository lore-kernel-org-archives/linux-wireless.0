Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZEXRYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 13:24:14 -0400
Subject: [PATCH] cfg80211: validate AID of stations being added
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 May 2009 16:42:30 +0200
Message-Id: <1243176150.29222.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have some validation code in mac80211 but said code will
force an invalid AID to 0 which isn't a valid AID either;
instead require a valid AID (1-2007) to be passed in from
userspace in cfg80211 already. Also move the code before
the race comment since it can only be executed during STA
addition and thus is not racy.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c     |   13 +++++++------
 net/wireless/nl80211.c |    4 ++++
 2 files changed, 11 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-05-24 16:40:30.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-05-24 16:40:42.000000000 +0200
@@ -664,18 +664,19 @@ static void sta_apply_parameters(struct 
 	spin_unlock_bh(&sta->lock);
 
 	/*
+	 * cfg80211 validates this (1-2007) and allows setting the AID
+	 * only when creating a new station entry
+	 */
+	if (params->aid)
+		sta->sta.aid = params->aid;
+
+	/*
 	 * FIXME: updating the following information is racy when this
 	 *	  function is called from ieee80211_change_station().
 	 *	  However, all this information should be static so
 	 *	  maybe we should just reject attemps to change it.
 	 */
 
-	if (params->aid) {
-		sta->sta.aid = params->aid;
-		if (sta->sta.aid > IEEE80211_MAX_AID)
-			sta->sta.aid = 0; /* XXX: should this be an error? */
-	}
-
 	if (params->listen_interval >= 0)
 		sta->listen_interval = params->listen_interval;
 
--- wireless-testing.orig/net/wireless/nl80211.c	2009-05-24 16:40:33.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-05-24 16:40:42.000000000 +0200
@@ -1738,7 +1738,11 @@ static int nl80211_new_station(struct sk
 		nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
+
 	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+	if (!params.aid || params.aid > IEEE80211_MAX_AID)
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);


