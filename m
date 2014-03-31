Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45465 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaCaKDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 06:03:34 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so5553062wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 03:03:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 4/4] mac80211: disconnect iface if CSA unexpectedly fails
Date: Mon, 31 Mar 2014 11:57:21 +0200
Message-Id: <1396259841-6359-5-git-send-email-michal.kazior@tieto.com> (sfid-20140331_120340_265597_3CDCB6BD)
In-Reply-To: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to leave a cripled
interface running.

As a side effect this will unblock tx queues with
CSA reason immediately after failure instead of
until after userspace requests interface to stop.

This also gives userspace an opportunity to
indirectly see CSA failure.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * rebase to use gfp_t argument

 net/mac80211/cfg.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2fd8e08..821143c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3088,7 +3088,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
@@ -3100,7 +3100,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	if (WARN_ON(err < 0))
-		return;
+		return err;
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
@@ -3111,7 +3111,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	err = ieee80211_set_after_csa_beacon(sdata, &changed);
 	if (err)
-		return;
+		return err;
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
@@ -3120,6 +3120,8 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	return 0;
 }
 
 void ieee80211_csa_finalize_work(struct work_struct *work)
@@ -3128,6 +3130,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
+	int err;
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
@@ -3139,7 +3142,12 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	ieee80211_csa_finalize(sdata);
+	err = ieee80211_csa_finalize(sdata);
+	if (err) {
+		sdata_info(sdata, "failed to finalize CSA, disconnecting\n");
+		cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev, GFP_KERNEL);
+		goto unlock;
+	}
 
 unlock:
 	mutex_unlock(&local->mtx);
-- 
1.8.5.3

