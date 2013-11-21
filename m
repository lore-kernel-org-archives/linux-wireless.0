Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55845 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3KUOfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 09:35:23 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [RFC 2/3] cfg80211/mac80211/ath6kl: acquire wdev lock outside ch_switch_notify
Date: Thu, 21 Nov 2013 15:34:21 +0100
Message-Id: <1385044462-23046-3-git-send-email-sw@simonwunderlich.de> (sfid-20131121_153529_562002_771209C0)
In-Reply-To: <1385044462-23046-1-git-send-email-sw@simonwunderlich.de>
References: <1385044462-23046-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel switch notification should be sent under the
wdev/sdata-lock, preferably in the same moment as the channel change
happens, to avoid races by other callers (e.g. start/stop_ap).
This also adds the previously missing sdata_lock protection in
csa_finalize_work.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 include/net/cfg80211.h                     |    3 ++-
 net/mac80211/cfg.c                         |   21 +++++++++++++++------
 net/wireless/nl80211.c                     |    9 +++------
 4 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 36dc61d..43a05c9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1109,7 +1109,9 @@ void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 				(mode == WMI_11G_HT20) ?
 					NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT);
 
+	mutex_lock(vif->wdev->mtx);
 	cfg80211_ch_switch_notify(vif->ndev, &chandef);
+	mutex_unlock(vif->wdev->mtx);
 }
 
 static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 633146b..874b5ae 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4286,7 +4286,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
  * @dev: the device which switched channels
  * @chandef: the new channel definition
  *
- * Acquires wdev_lock, so must only be called from sleepable driver context!
+ * Caller must acquire wdev_lock, therefore must only be called from sleepable
+ * driver context!
  */
 void cfg80211_ch_switch_notify(struct net_device *dev,
 			       struct cfg80211_chan_def *chandef);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 433d5cd..a715c9b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3010,13 +3010,18 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	struct ieee80211_local *local = sdata->local;
 	int err, changed = 0;
 
+	sdata_lock(sdata);
+	/* AP might have been stopped while waiting for the lock. */
+	if (!sdata->vif.csa_active)
+		goto unlock;
+
 	if (!ieee80211_sdata_running(sdata))
-		return;
+		goto unlock;
 
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	if (WARN_ON(err < 0))
-		return;
+		goto unlock;
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
@@ -3025,11 +3030,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
 		if (err < 0)
-			return;
+			goto unlock;
+
 		changed |= err;
 		kfree(sdata->u.ap.next_beacon);
 		sdata->u.ap.next_beacon = NULL;
@@ -3043,20 +3050,22 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
 		if (err < 0)
-			return;
+			goto unlock;
 		break;
 #endif
 	default:
 		WARN_ON(1);
-		return;
+		goto unlock;
 	}
-	sdata->vif.csa_active = false;
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+
+unlock:
+	sdata_unlock(sdata);
 }
 
 static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e39fadc..1355abf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10804,21 +10804,18 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	trace_cfg80211_ch_switch_notify(dev, chandef);
 
-	wdev_lock(wdev);
-
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
 		    wdev->iftype != NL80211_IFTYPE_ADHOC &&
 		    wdev->iftype != NL80211_IFTYPE_MESH_POINT))
-		goto out;
+		return;
 
 	wdev->channel = chandef->chan;
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
-out:
-	wdev_unlock(wdev);
-	return;
 }
 EXPORT_SYMBOL(cfg80211_ch_switch_notify);
 
-- 
1.7.10.4

