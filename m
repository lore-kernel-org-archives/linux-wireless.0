Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.128.226]:50366 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab0BHC6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 21:58:49 -0500
Date: Sun, 7 Feb 2010 21:47:50 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	akpm@linux-foundation.org
Subject: [PATCH 1/2] mac80211: make rate_control_alloc static
Message-ID: <20100207214750.7786e20b@mycelium.queued.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


rate_control_alloc is not used by anything outside of
ieee80211_init_rate_ctrl_alg.  Both are in rate.c; there's no reason to make
rate_control_alloc visible outside of it.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 net/mac80211/rate.c |    2 +-
 net/mac80211/rate.h |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index b9007f8..2565626 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -145,7 +145,7 @@ static const struct file_operations rcname_ops = {
 };
 #endif
 
-struct rate_control_ref *rate_control_alloc(const char *name,
+static struct rate_control_ref *rate_control_alloc(const char *name,
 					    struct ieee80211_local *local)
 {
 	struct dentry *debugfsdir = NULL;
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index cb9bd1f..eea945f 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -26,10 +26,6 @@ struct rate_control_ref {
 	struct kref kref;
 };
 
-/* Get a reference to the rate control algorithm. If `name' is NULL, get the
- * first available algorithm. */
-struct rate_control_ref *rate_control_alloc(const char *name,
-					    struct ieee80211_local *local);
 void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc);
@@ -115,7 +111,8 @@ static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 #endif
 }
 
-/* functions for rate control related to a device */
+/* Get a reference to the rate control algorithm. If `name' is NULL, get the
+ * first available algorithm. */
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 void rate_control_deinitialize(struct ieee80211_local *local);
-- 
1.5.6.5

