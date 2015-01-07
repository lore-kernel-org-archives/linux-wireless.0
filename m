Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61678 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbbAGPuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 10:50:21 -0500
Received: by mail-wg0-f41.google.com with SMTP id l18so1447158wgh.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 07:50:20 -0800 (PST)
Received: from muse.ger.corp.intel.com (93-172-181-114.bb.netvision.net.il. [93.172.181.114])
        by mx.google.com with ESMTPSA id o1sm2567110wjf.41.2015.01.07.07.50.18
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Jan 2015 07:50:19 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] mac80211: consider only relevant vifs for radar_required calculation
Date: Wed,  7 Jan 2015 17:50:10 +0200
Message-Id: <1420645811-17877-2-git-send-email-eliad@wizery.com> (sfid-20150107_165026_282798_F372C15C)
In-Reply-To: <1420645811-17877-1-git-send-email-eliad@wizery.com>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ctx->conf.radar_enabled should reflect whether radar
detection is enabled for the channel context.

When calculating it, make it consider only the vifs
that have this context assigned (instead of all the
vifs).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2: 
* add a new function (instead of replacing existing one)
* init ctx->conf.radar_enabled to false

 net/mac80211/chan.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f5d08d5..28da444 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -406,6 +406,34 @@ bool ieee80211_is_radar_required(struct ieee80211_local *local)
 	return false;
 }
 
+static bool
+ieee80211_chanctx_radar_required(struct ieee80211_local *local,
+				 struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_chanctx_conf *conf = &ctx->conf;
+	struct ieee80211_sub_if_data *sdata;
+	bool required = false;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+	lockdep_assert_held(&local->mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
+			continue;
+		if (!sdata->radar_required)
+			continue;
+
+		required = true;
+		break;
+	}
+	rcu_read_unlock();
+
+	return required;
+}
+
 static struct ieee80211_chanctx *
 ieee80211_alloc_chanctx(struct ieee80211_local *local,
 			const struct cfg80211_chan_def *chandef,
@@ -425,7 +453,7 @@ ieee80211_alloc_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
-	ctx->conf.radar_enabled = ieee80211_is_radar_required(local);
+	ctx->conf.radar_enabled = false;
 	ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	return ctx;
@@ -570,7 +598,7 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	/* for ieee80211_is_radar_required */
 	lockdep_assert_held(&local->mtx);
 
-	radar_enabled = ieee80211_is_radar_required(local);
+	radar_enabled = ieee80211_chanctx_radar_required(local, chanctx);
 
 	if (radar_enabled == chanctx->conf.radar_enabled)
 		return;
-- 
1.8.5.2.229.g4448466.dirty

