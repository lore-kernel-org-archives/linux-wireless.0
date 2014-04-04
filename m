Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:56626 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaDDLIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 07:08:52 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so3248305wes.12
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 04:08:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix radar_enabled propagation
Date: Fri,  4 Apr 2014 13:02:43 +0200
Message-Id: <1396609363-24539-1-git-send-email-michal.kazior@tieto.com> (sfid-20140404_130902_830631_B4E33380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If chandef had non-HT width it was possible for
radar_enabled update to not be propagated properly
through drv_config(). This happened because
ieee80211_hw_conf_chan() would never see different
local->hw.conf.chandef and local->_oper_chandef.

This wasn't a problem with HT chandefs because
_oper_chandef width is reset to non-HT in
ieee80211_free_chanctx() making
ieee80211_hw_conf_chan() to kick in.

This problem led (at least) ath10k to not start
CAC if prior CAC was cancelled and both CACs were
requested for identical non-HT chandefs.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 122033d..b472daa 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -269,7 +269,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = *chandef;
-		ieee80211_hw_config(local, 0);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 	} else {
 		err = drv_add_chanctx(local, ctx);
 		if (err) {
@@ -306,7 +306,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 			check_single_channel = true;
 		local->hw.conf.radar_enabled = false;
 
-		ieee80211_hw_config(local, 0);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 	} else {
 		drv_remove_chanctx(local, ctx);
 	}
-- 
1.8.5.3

