Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbeAQHei (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:34:38 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 3/4] mac80211: enable setting cqm config for AP mode
Date: Wed, 17 Jan 2018 13:01:15 +0530
Message-Id: <1516174276-16789-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_083447_841846_C2D71B8B)
In-Reply-To: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

Enable connection monitoring for AP mode which makes it possible to
track signal strength of connected stations.

Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e1..f290ca4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2689,6 +2689,26 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
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
+	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	     sdata->vif.type == NL80211_IFTYPE_P2P_GO) &&
+	     !sdata->vif.bss_conf.enable_beacon)
+		return;
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+}
+
 static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 s32 rssi_thold, u32 rssi_hyst)
@@ -2711,11 +2731,7 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
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
 
@@ -2736,11 +2752,7 @@ static int ieee80211_set_cqm_rssi_range_config(struct wiphy *wiphy,
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
1.9.1
