Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4702 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752244AbdHIXlv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 19:41:51 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: enable setting cqm config for AP mode
Date: Wed,  9 Aug 2017 16:41:37 -0700
Message-Id: <1502322097-29746-2-git-send-email-pradeepc@codeaurora.org> (sfid-20170810_014154_656133_41EFF69E)
In-Reply-To: <1502322097-29746-1-git-send-email-pradeepc@codeaurora.org>
References: <1502322097-29746-1-git-send-email-pradeepc@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable connection monitoring for AP mode which makes it possible to track
signal strength of connected stations.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 net/mac80211/cfg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a354f1939e49..1548fd34961c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2682,9 +2682,11 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	bss_conf->cqm_rssi_high = 0;
 	sdata->u.mgd.last_cqm_event_signal = 0;
 
-	/* tell the driver upon association, unless already associated */
-	if (sdata->u.mgd.associated &&
-	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
+	/* if STA, tell the driver upon association, unless already associated.
+	 * if AP, always tell the driver.
+	 */
+	if ((sdata->u.mgd.associated || vif->type == NL80211_IFTYPE_AP) &&
+	    (sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI))
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
 
 	return 0;
@@ -2708,7 +2710,7 @@ static int ieee80211_set_cqm_rssi_range_config(struct wiphy *wiphy,
 	sdata->u.mgd.last_cqm_event_signal = 0;
 
 	/* tell the driver upon association, unless already associated */
-	if (sdata->u.mgd.associated &&
+	if ((sdata->u.mgd.associated  || vif->type == NL80211_IFTYPE_AP) &&
 	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
 
-- 
1.9.1
