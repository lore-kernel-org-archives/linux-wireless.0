Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46735 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbbFQIlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/14] mac80211: rename 'sta_inf' variable to more common 'sta'
Date: Wed, 17 Jun 2015 10:41:03 +0200
Message-Id: <1434530475-3553-3-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104127_325741_51FD0AE3)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We typically use 'sta' for the station info struct, and if needed
'pubsta' for the public (driver-visible) portion thereof. Do this
in the ieee80211_sta_ps_transition() function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5dae166cb7f5..9fb8ce982c2d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1240,22 +1240,22 @@ static void sta_ps_end(struct sta_info *sta)
 	ieee80211_sta_ps_deliver_wakeup(sta);
 }
 
-int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
+int ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 {
-	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	bool in_ps;
 
-	WARN_ON(!ieee80211_hw_check(&sta_inf->local->hw, AP_LINK_PS));
+	WARN_ON(!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS));
 
 	/* Don't let the same PS state be set twice */
-	in_ps = test_sta_flag(sta_inf, WLAN_STA_PS_STA);
+	in_ps = test_sta_flag(sta, WLAN_STA_PS_STA);
 	if ((start && in_ps) || (!start && !in_ps))
 		return -EINVAL;
 
 	if (start)
-		sta_ps_start(sta_inf);
+		sta_ps_start(sta);
 	else
-		sta_ps_end(sta_inf);
+		sta_ps_end(sta);
 
 	return 0;
 }
-- 
2.1.4

