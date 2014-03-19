Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582AbaCSKLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 06:11:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 v2] mac80211: fix suspend vs. authentication race
Date: Wed, 19 Mar 2014 11:11:18 +0100
Message-Id: <1395223878-12962-1-git-send-email-johannes@sipsolutions.net> (sfid-20140319_111124_629227_94838DBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since Stanislaw's patch removing the quiescing code, mac80211 had
a race regarding suspend vs. authentication: as cfg80211 doesn't
track authentication attempts, it can't abort them. Therefore the
attempts may be kept running while suspending, which can lead to
all kinds of issues, in at least some cases causing an error in
iwlmvm firmware.

Fix this by aborting the authentication attempt when suspending.

Cc: stable@vger.kernel.org
Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 26 ++++++++++++++++++++++++++
 net/mac80211/pm.c          | 14 +++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5e44e3179e02..6bd498470138 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1385,6 +1385,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 				  __le16 fc, bool acked);
+void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 245dce969b31..9f7a586e1d16 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3504,6 +3504,32 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 }
 
 #ifdef CONFIG_PM
+void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+	sdata_lock(sdata);
+
+	if (ifmgd->auth_data) {
+		/*
+		 * If we are trying to authenticate while suspending, cfg80211
+		 * won't know and won't actually abort those attempts, thus we
+		 * need to do that ourselves.
+		 */
+		ieee80211_send_deauth_disassoc(sdata,
+					       ifmgd->auth_data->bss->bssid,
+					       IEEE80211_STYPE_DEAUTH,
+					       WLAN_REASON_DEAUTH_LEAVING,
+					       false, frame_buf);
+		ieee80211_destroy_auth_data(sdata, false);
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+				      IEEE80211_DEAUTH_FRAME_LEN);
+	}
+
+	sdata_unlock(sdata);
+}
+
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index af64fb8e8add..d478b880a0af 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -100,10 +100,18 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces that were created in the driver */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata) ||
-		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		    sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		if (!ieee80211_sdata_running(sdata))
 			continue;
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			continue;
+		case NL80211_IFTYPE_STATION:
+			ieee80211_mgd_quiesce(sdata);
+			break;
+		default:
+			break;
+		}
 
 		drv_remove_interface(local, sdata);
 	}
-- 
1.8.5.3

