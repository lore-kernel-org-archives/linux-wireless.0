Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbeBYHuG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 02:50:06 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv4 2/3] mac80211: enable setting cqm rssi config for AP mode
Date: Sun, 25 Feb 2018 13:19:57 +0530
Message-Id: <1519544998-2621-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180225_085011_885309_75C5EC6D)
In-Reply-To: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
References: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

Enable connection monitoring for AP mode which makes it possible to
track signal strength of connected stations.

Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 net/mac80211/cfg.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6f9d5be..74092cb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2690,6 +2690,25 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static void ieee80211_update_rssi_config(struct ieee80211_sub_if_data *sdata)
+{
+	if (!(sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI))
+		return;
+
+	/* tell the driver upon association, unless already associated */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return;
+
+	/* if AP, always tell the driver by checking beacon status */
+	if (!sdata->vif.bss_conf.enable_beacon ||
+	    !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+				NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG))
+		return;
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+}
+
 static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 s32 rssi_thold, u32 rssi_hyst)
@@ -2712,11 +2731,7 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	bss_conf->cqm_rssi_high = 0;
 	sdata->u.mgd.last_cqm_event_signal = 0;
 
-	/* tell the driver upon association, unless already associated */
-	if (sdata->u.mgd.associated &&
-	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
-
+	ieee80211_update_rssi_config(sdata);
 	return 0;
 }
 
@@ -2737,11 +2752,7 @@ static int ieee80211_set_cqm_rssi_range_config(struct wiphy *wiphy,
 	bss_conf->cqm_rssi_hyst = 0;
 	sdata->u.mgd.last_cqm_event_signal = 0;
 
-	/* tell the driver upon association, unless already associated */
-	if (sdata->u.mgd.associated &&
-	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
-
+	ieee80211_update_rssi_config(sdata);
 	return 0;
 }
 
-- 
1.7.9.5
