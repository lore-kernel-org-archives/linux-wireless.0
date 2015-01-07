Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48805 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbAGPuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 10:50:19 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so8329789wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 07:50:18 -0800 (PST)
Received: from muse.ger.corp.intel.com (93-172-181-114.bb.netvision.net.il. [93.172.181.114])
        by mx.google.com with ESMTPSA id o1sm2567110wjf.41.2015.01.07.07.50.15
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Jan 2015 07:50:16 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/3] mac80211: remove local->radar_detect_enabled
Date: Wed,  7 Jan 2015 17:50:09 +0200
Message-Id: <1420645811-17877-1-git-send-email-eliad@wizery.com> (sfid-20150107_165025_378337_907EFAC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

local->radar_detect_enabled should tell whether
radar_detect is enabled on any interface belonging
to local.

However, it's not getting updated correctly
in many cases (actually, when testing with hwsim
it's never been set, even when the dfs master
is beaconing).

Instead of handling all the corner cases
(e.g. channel switch), simply check whether
radar detection is enabled only when needed,
instead of caching the result.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c         | 2 +-
 net/mac80211/chan.c        | 5 ++---
 net/mac80211/ieee80211_i.h | 3 +--
 net/mac80211/scan.c        | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1696658..3c53fa3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2557,7 +2557,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 	/* if there's one pending or we're scanning, queue this one */
 	if (!list_empty(&local->roc_list) ||
-	    local->scanning || local->radar_detect_enabled)
+	    local->scanning || ieee80211_is_radar_required(local))
 		goto out_check_combine;
 
 	/* if not HW assist, just queue & schedule work */
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5d6dae9..f5d08d5 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -388,7 +388,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-static bool ieee80211_is_radar_required(struct ieee80211_local *local)
+bool ieee80211_is_radar_required(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -567,7 +567,7 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	bool radar_enabled;
 
 	lockdep_assert_held(&local->chanctx_mtx);
-	/* for setting local->radar_detect_enabled */
+	/* for ieee80211_is_radar_required */
 	lockdep_assert_held(&local->mtx);
 
 	radar_enabled = ieee80211_is_radar_required(local);
@@ -576,7 +576,6 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 		return;
 
 	chanctx->conf.radar_enabled = radar_enabled;
-	local->radar_detect_enabled = chanctx->conf.radar_enabled;
 
 	if (!local->use_chanctx) {
 		local->hw.conf.radar_enabled = chanctx->conf.radar_enabled;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f45cab..9cdd94a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1168,8 +1168,6 @@ struct ieee80211_local {
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
-	/* DFS/radar detection is enabled */
-	bool radar_detect_enabled;
 	struct work_struct radar_detected_work;
 
 	/* number of RX chains the hardware has */
@@ -1982,6 +1980,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
 void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx);
+bool ieee80211_is_radar_required(struct ieee80211_local *local);
 
 void ieee80211_dfs_cac_timer(unsigned long data);
 void ieee80211_dfs_cac_timer_work(struct work_struct *work);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ae84267..cdd8258 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -432,7 +432,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local,
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
-	if (local->radar_detect_enabled)
+	if (ieee80211_is_radar_required(local))
 		return false;
 
 	if (!list_empty(&local->roc_list))
-- 
1.8.5.2.229.g4448466.dirty

