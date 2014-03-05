Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44037 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbaCEOcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 09:32:32 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so1080520eak.29
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 06:32:31 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] mac80211: disconnect iface if CSA unexpectedly fails
Date: Wed,  5 Mar 2014 15:27:03 +0100
Message-Id: <1394029623-21894-5-git-send-email-michal.kazior@tieto.com> (sfid-20140305_153243_275543_76C442A4)
In-Reply-To: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to leave a cripled
interface running.

As a side effect this will unblock tx queues with
CSA reason immediately after failure instead of
until after userspace requests interface to stop.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4654823..e174cc3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3091,7 +3091,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
@@ -3103,7 +3103,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	if (WARN_ON(err < 0))
-		return;
+		return err;
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
@@ -3114,10 +3114,12 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	err = ieee80211_set_after_csa_beacon(sdata, &changed);
 	if (err)
-		return;
+		return err;
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+
+	return 0;
 }
 
 void ieee80211_csa_finalize_work(struct work_struct *work)
@@ -3126,6 +3128,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
+	int err;
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
@@ -3137,7 +3140,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	ieee80211_csa_finalize(sdata);
+	err = ieee80211_csa_finalize(sdata);
+	if (err) {
+		sdata_info(sdata, "failed to finalize CSA, disconnecting\n");
+		cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev);
+		goto unlock;
+	}
+
 	ieee80211_recalc_csa_block_tx(local);
 
 unlock:
-- 
1.8.5.3

