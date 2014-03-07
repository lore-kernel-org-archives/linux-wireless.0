Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37675 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCGLZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 06:25:24 -0500
Received: by mail-ee0-f54.google.com with SMTP id d49so1689529eek.13
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 03:25:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] mac80211: include ieee80211_local in chanctx
Date: Fri,  7 Mar 2014 12:19:55 +0100
Message-Id: <1394191196-6425-2-git-send-email-michal.kazior@tieto.com> (sfid-20140307_122528_896003_B4A403C4)
In-Reply-To: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel contexts are implicitly bound to hw
already so make it possible to dereference it
through the channel context itself.

This will make it possible to reduce number of
arguments for chanctx-related functions.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        | 1 +
 net/mac80211/ieee80211_i.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..5b946e8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -228,6 +228,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.def = *chandef;
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
+	ctx->local = local;
 	ctx->mode = mode;
 	ctx->conf.radar_enabled = ieee80211_is_radar_required(local);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..c21b0c3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -691,6 +691,7 @@ struct ieee80211_chanctx {
 	struct list_head list;
 	struct rcu_head rcu_head;
 
+	struct ieee80211_local *local;
 	enum ieee80211_chanctx_mode mode;
 	int refcount;
 	bool driver_present;
-- 
1.8.5.3

