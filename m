Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44586 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbCHQE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 12:04:28 -0400
Received: by wghl18 with SMTP id l18so15778691wgh.11
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2015 09:04:26 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: initialize rate control earlier for tdls station
Date: Sun,  8 Mar 2015 18:04:22 +0200
Message-Id: <1425830662-24803-1-git-send-email-arik@wizery.com> (sfid-20150308_170505_282335_AF92359F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Puzyniak <marek.puzyniak@tieto.com>

Currently when TDLS station in driver goes from authorized
to associated state it can not use rate control parameters
because rate control is not initialized yet. Some drivers
require parameters already initialized by rate control when
entering associated state. It can be done by initializing
rate control after station transition to associated state
but before notifying driver about that.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/mac80211/cfg.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 94889de..0e43e6e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -977,6 +977,14 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
 	    set & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
 	    !test_sta_flag(sta, WLAN_STA_ASSOC)) {
+		/*
+		 * When peer becomes authorized, init rate control as
+		 * well. Some drivers require rate control initialized
+		 * before drv_sta_state() is called.
+		 */
+		if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+			rate_control_rate_init(sta);
+
 		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 		if (ret)
 			return ret;
@@ -1378,11 +1386,6 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	if (err)
 		goto out_err;
 
-	/* When peer becomes authorized, init rate control as well */
-	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
-	    test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-		rate_control_rate_init(sta);
-
 	mutex_unlock(&local->sta_mtx);
 
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
-- 
2.1.0

