Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51752 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965429AbaCUNhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:37:22 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so1819779eek.31
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:37:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/4] mac80211: disconnect iface if CSA unexpectedly fails
Date: Fri, 21 Mar 2014 14:31:15 +0100
Message-Id: <1395408675-26013-5-git-send-email-michal.kazior@tieto.com> (sfid-20140321_143732_620829_E3A71B5D)
In-Reply-To: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
 <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
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
index 65768ef..64e152d 100644
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
@@ -3111,10 +3111,12 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
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
@@ -3123,6 +3125,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
+	int err;
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
@@ -3134,7 +3137,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
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
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-- 
1.8.5.3

