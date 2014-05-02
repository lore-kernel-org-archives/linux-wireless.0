Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39201 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751643AbaEBNlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 09:41:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: michal.kazior@tieto.com
Date: Fri,  2 May 2014 16:40:30 +0300
Message-Id: <1399038031-23206-3-git-send-email-luca@coelho.fi> (sfid-20140502_154123_085093_CB3C856E)
In-Reply-To: <1399038031-23206-1-git-send-email-luca@coelho.fi>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 3/4] mac80211: send channel switch failed notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Send a channel switch failed notification to userspace when an ongoing
channel swith fails.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c   | 30 +++++++++++++++++++++++-------
 net/mac80211/iface.c |  6 +++++-
 net/mac80211/mlme.c  |  9 ++++++++-
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 53a2cfe..f8958e0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1101,9 +1101,13 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
-	sdata->vif.csa_active = false;
-	kfree(sdata->u.ap.next_beacon);
-	sdata->u.ap.next_beacon = NULL;
+	if (sdata->vif.csa_active) {
+		cfg80211_ch_switch_failed_notify(sdata->dev,
+						 &sdata->csa_chandef);
+		sdata->vif.csa_active = false;
+		kfree(sdata->u.ap.next_beacon);
+		sdata->u.ap.next_beacon = NULL;
+	}
 
 	/* turn off carrier for this interface and dependent VLANs */
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
@@ -3030,8 +3034,11 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	mutex_unlock(&local->mtx);
-	if (WARN_ON(err < 0))
+	if (WARN_ON(err < 0)) {
+		cfg80211_ch_switch_failed_notify(sdata->dev,
+						 &sdata->csa_chandef);
 		return;
+	}
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
@@ -3045,21 +3052,30 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		kfree(sdata->u.ap.next_beacon);
 		sdata->u.ap.next_beacon = NULL;
 
-		if (err < 0)
+		if (err < 0) {
+			cfg80211_ch_switch_failed_notify(sdata->dev,
+							 &sdata->csa_chandef);
 			return;
+		}
 		changed |= err;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		err = ieee80211_ibss_finish_csa(sdata);
-		if (err < 0)
+		if (err < 0) {
+			cfg80211_ch_switch_failed_notify(sdata->dev,
+							 &sdata->csa_chandef);
 			return;
+		}
 		changed |= err;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
-		if (err < 0)
+		if (err < 0) {
+			cfg80211_ch_switch_failed_notify(sdata->dev,
+							 &sdata->csa_chandef);
 			return;
+		}
 		changed |= err;
 		break;
 #endif
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7fff3dc..578f6e6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -838,7 +838,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	cancel_work_sync(&sdata->recalc_smps);
 	sdata_lock(sdata);
-	sdata->vif.csa_active = false;
+	if (sdata->vif.csa_active) {
+		sdata->vif.csa_active = false;
+		cfg80211_ch_switch_failed_notify(sdata->dev,
+						 &sdata->csa_chandef);
+	}
 	sdata_unlock(sdata);
 	cancel_work_sync(&sdata->csa_finalize_work);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 139005d..beff8c8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -958,6 +958,8 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 			   "vif channel switch failed, disconnecting\n");
 		ieee80211_queue_work(&sdata->local->hw,
 				     &ifmgd->csa_connection_drop_work);
+		cfg80211_ch_switch_failed_notify(sdata->dev,
+						 &sdata->csa_chandef);
 		goto out;
 	}
 
@@ -2060,7 +2062,12 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
-	sdata->vif.csa_active = false;
+
+	if (sdata->vif.csa_active) {
+			cfg80211_ch_switch_failed_notify(sdata->dev,
+							 &sdata->csa_chandef);
+			sdata->vif.csa_active = false;
+	}
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-- 
1.9.2

