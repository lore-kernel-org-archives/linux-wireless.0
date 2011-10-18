Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1JRLjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 07:39:21 -0400
Subject: [PATCH] mac80211: fix confusing parentheses
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 13:39:14 +0200
Message-ID: <1318937954.3958.23.camel@jlt3.sipsolutions.net> (sfid-20111018_133924_632382_45D4E330)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's an extra pair of parentheses here that
is simply confusing because it implies a nesting
that doesn't actually exist. Just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/cfg.c	2011-10-18 13:36:05.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-10-18 13:38:05.000000000 +0200
@@ -1413,7 +1413,7 @@ static int ieee80211_set_channel(struct
 	    (old_oper_type != local->_oper_channel_type))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	if ((sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR) &&
+	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR &&
 	    old_vif_oper_type != sdata->vif.bss_conf.channel_type)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
 


