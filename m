Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61091 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaEHHQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 03:16:57 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1365405eei.14
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 00:16:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5] mac80211: disconnect iface if CSA unexpectedly fails
Date: Thu,  8 May 2014 09:10:02 +0200
Message-Id: <1399533002-3681-1-git-send-email-michal.kazior@tieto.com> (sfid-20140508_091701_818912_0652BF82)
In-Reply-To: <1397049062-24177-5-git-send-email-michal.kazior@tieto.com>
References: <1397049062-24177-5-git-send-email-michal.kazior@tieto.com>
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
This was originally a 4/4 of csa fixes patchset.

Changelog:

v3:
 * rebase to use gfp_t argument

v4:
 * remove WARN_ON from ieee80211_vif_change_channel() error checking [Luca]
 * fix typo: s/cripled/crippled/ [Johannes]

v5:
 * fix csa failure for immediate csa.
   ieee80211_csa_finalize() wasn't error checked
   in __ieee80211_channel_switch.
   __ieee80211_csa_finalize() now does what
   ieee80211_csa_finalize() originally did, while
   the latter now performs the error check to avoid
   code duplication [Johannes]

 net/mac80211/cfg.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0c87c8c..e028a2b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3090,7 +3090,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
@@ -3101,8 +3101,8 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		return;
+	if (err < 0)
+		return err;
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
@@ -3113,7 +3113,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	err = ieee80211_set_after_csa_beacon(sdata, &changed);
 	if (err)
-		return;
+		return err;
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
@@ -3122,6 +3122,21 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	return 0;
+}
+
+static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+{
+	int err;
+
+	err = __ieee80211_csa_finalize(sdata);
+	if (err) {
+		sdata_info(sdata, "failed to finalize CSA, disconnecting\n");
+		cfg80211_stop_iface(sdata->local->hw.wiphy, &sdata->wdev,
+				    GFP_KERNEL);
+		return;
+	}
 }
 
 void ieee80211_csa_finalize_work(struct work_struct *work)
-- 
1.8.5.3

