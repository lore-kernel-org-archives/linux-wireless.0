Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47619 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0KCVvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:51:07 -0400
Received: by mail-fx0-f46.google.com with SMTP id 16so938793fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 14:51:06 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/4] mac80211: notify drivers about frag threshold changes
Date: Wed,  3 Nov 2010 23:50:51 +0200
Message-Id: <1288821053-19013-3-git-send-email-arik@wizery.com>
In-Reply-To: <1288821053-19013-1-git-send-email-arik@wizery.com>
References: <1288821053-19013-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lower driver is notified when the fragmentation threshold changes
and upon a reconfig of the interface.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c          |    7 +++++++
 net/mac80211/driver-ops.h   |   14 ++++++++++++++
 net/mac80211/driver-trace.h |   21 +++++++++++++++++++++
 net/mac80211/util.c         |    3 +++
 4 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..3df12f7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1299,6 +1299,13 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	int err;
 
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		err = drv_set_frag_threshold(local, wiphy->frag_threshold);
+
+		if (err)
+			return err;
+	}
+
 	if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
 		err = drv_set_coverage_class(local, wiphy->coverage_class);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1698382..79019f9 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -233,6 +233,20 @@ static inline void drv_get_tkip_seq(struct ieee80211_local *local,
 	trace_drv_get_tkip_seq(local, hw_key_idx, iv32, iv16);
 }
 
+static inline int drv_set_frag_threshold(struct ieee80211_local *local,
+					u32 value)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	trace_drv_set_frag_threshold(local, value);
+	if (local->ops->set_frag_threshold)
+		ret = local->ops->set_frag_threshold(&local->hw, value);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 					u32 value)
 {
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6831fb1..431d655 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -531,6 +531,27 @@ TRACE_EVENT(drv_get_tkip_seq,
 	)
 );
 
+TRACE_EVENT(drv_set_frag_threshold,
+	TP_PROTO(struct ieee80211_local *local, u32 value),
+
+	TP_ARGS(local, value),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, value)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->value = value;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " value:%d",
+		LOCAL_PR_ARG, __entry->value
+	)
+);
+
 TRACE_EVENT(drv_set_rts_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value),
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0b6fc92..e486286 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1152,6 +1152,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->sta_mtx);
 
+	/* setup fragmentation threshold */
+	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
+
 	/* setup RTS threshold */
 	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
 
-- 
1.7.1

