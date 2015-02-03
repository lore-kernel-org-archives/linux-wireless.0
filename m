Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43755 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbbBCKka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:40:30 -0500
Received: by mail-wg0-f46.google.com with SMTP id l2so43797616wgh.5
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:40:29 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [RFC 3/4] mac80211: initialize rate control earlier for tdls station
Date: Tue,  3 Feb 2015 11:41:53 +0100
Message-Id: <1422960114-25137-4-git-send-email-marek.puzyniak@tieto.com> (sfid-20150203_114040_038804_6C408287)
In-Reply-To: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
References: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently when TDLS station in driver goes from assoc
to authorized state it can not use rate control parameters
because rate control is not initialized yet. Some drivers
require parameters already initialized by rate control when
entering authorized state. It can be done by initializing
rate control after station transition to authorized state
but before notifying driver about that.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 net/mac80211/cfg.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a777114..3849054 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -952,12 +952,21 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
-		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
+		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
+			/*
+			 * When peer becomes authorized, init rate control as
+			 * well. Some drivers require rate control initialized
+			 * before drv_sta_state() is called.
+			 */
+			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+				rate_control_rate_init(sta);
+
 			ret = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
-		else if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		} else if (test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-		else
+		} else {
 			ret = 0;
+		}
 		if (ret)
 			return ret;
 	}
@@ -1346,11 +1355,6 @@ static int ieee80211_change_station(struct wiphy *wiphy,
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
2.1.4

