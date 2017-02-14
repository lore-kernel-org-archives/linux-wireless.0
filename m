Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43602 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753834AbdBNNWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:22:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 4/7] mac80211: remove local pointer from rate_ctrl_ref
Date: Tue, 14 Feb 2017 14:22:05 +0100
Message-Id: <20170214132208.8715-5-johannes@sipsolutions.net> (sfid-20170214_142251_248003_74A745BA)
In-Reply-To: <20170214132208.8715-1-johannes@sipsolutions.net>
References: <20170214132208.8715-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This pointer really isn't needed, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c | 10 +++++-----
 net/mac80211/rate.h |  1 -
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 206698bc93f4..094c15645228 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -208,7 +208,6 @@ static struct rate_control_ref *rate_control_alloc(const char *name,
 	ref = kmalloc(sizeof(struct rate_control_ref), GFP_KERNEL);
 	if (!ref)
 		return NULL;
-	ref->local = local;
 	ref->ops = ieee80211_rate_control_ops_get(name);
 	if (!ref->ops)
 		goto free;
@@ -229,13 +228,14 @@ static struct rate_control_ref *rate_control_alloc(const char *name,
 	return NULL;
 }
 
-static void rate_control_free(struct rate_control_ref *ctrl_ref)
+static void rate_control_free(struct ieee80211_local *local,
+			      struct rate_control_ref *ctrl_ref)
 {
 	ctrl_ref->ops->free(ctrl_ref->priv);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	debugfs_remove_recursive(ctrl_ref->local->debugfs.rcdir);
-	ctrl_ref->local->debugfs.rcdir = NULL;
+	debugfs_remove_recursive(local->debugfs.rcdir);
+	local->debugfs.rcdir = NULL;
 #endif
 
 	kfree(ctrl_ref);
@@ -936,6 +936,6 @@ void rate_control_deinitialize(struct ieee80211_local *local)
 		return;
 
 	local->rate_ctrl = NULL;
-	rate_control_free(ref);
+	rate_control_free(local, ref);
 }
 
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 8d3260785b94..d51a1cce4d4a 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -20,7 +20,6 @@
 #include "driver-ops.h"
 
 struct rate_control_ref {
-	struct ieee80211_local *local;
 	const struct rate_control_ops *ops;
 	void *priv;
 };
-- 
2.9.3
