Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55930 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3KUP4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 10:56:31 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/4] mac80211: don't leak next beacon when csa is aborted
Date: Thu, 21 Nov 2013 16:56:23 +0100
Message-Id: <1385049383-5617-5-git-send-email-sw@simonwunderlich.de> (sfid-20131121_165635_417627_12E49E55)
In-Reply-To: <1385049383-5617-1-git-send-email-sw@simonwunderlich.de>
References: <1385049383-5617-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/cfg.c   |    5 +++++
 net/mac80211/iface.c |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9f19cde..8bf0cc0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1079,7 +1079,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
+	if (sdata->vif.csa_active) {
+		kfree(sdata->u.ap.next_beacon);
+		sdata->u.ap.next_beacon = NULL;
+	}
 	sdata->vif.csa_active = false;
+
 	cancel_work_sync(&sdata->u.ap.request_smps_work);
 
 	/* turn off carrier for this interface and dependent VLANs */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d226751..dce4398 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -820,8 +820,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	cancel_work_sync(&sdata->recalc_smps);
-	sdata->vif.csa_active = false;
 	cancel_work_sync(&sdata->csa_finalize_work);
+	/* free left-over next beacon if a CSA was aborted */
+	if (sdata->vif.csa_active && sdata->vif.type == NL80211_IFTYPE_AP) {
+		kfree(sdata->u.ap.next_beacon);
+		sdata->u.ap.next_beacon = NULL;
+	}
+	sdata->vif.csa_active = false;
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
-- 
1.7.10.4

