Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50975 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaDINRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:17:22 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so1872850eek.38
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:17:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 4/4] mac80211: disconnect iface if CSA unexpectedly fails
Date: Wed,  9 Apr 2014 15:11:02 +0200
Message-Id: <1397049062-24177-5-git-send-email-michal.kazior@tieto.com> (sfid-20140409_151738_247802_12D25412)
In-Reply-To: <1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
 <1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to leave a crippled
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

v4:
 * remove WARN_ON from ieee80211_vif_change_channel() error checking [Luca]
 * fix typo: s/cripled/crippled/ [Johannes]

 net/mac80211/cfg.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2fd8e08..5bd4a81 100644
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
@@ -3099,8 +3099,8 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		return;
+	if (err < 0)
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

