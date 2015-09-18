Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbIRNUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:20:19 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] mac80211: Deinline drv_switch_vif_chanctx()
Date: Fri, 18 Sep 2015 15:19:39 +0200
Message-Id: <1442582379-10342-7-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152048_408666_D0F277E8)
In-Reply-To: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining the function size is 821 bytes and there are
2 callsites, reducing code size by about 800 bytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/mac80211/driver-ops.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 51 ++-------------------------------------------
 2 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 3e144b9..e4d68d7 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -209,3 +209,56 @@ int drv_ampdu_action(struct ieee80211_local *local,
 
 	return ret;
 }
+
+int
+drv_switch_vif_chanctx(struct ieee80211_local *local,
+		       struct ieee80211_vif_chanctx_switch *vifs,
+		       int n_vifs,
+		       enum ieee80211_chanctx_switch_mode mode)
+{
+	int ret = 0;
+	int i;
+
+	if (!local->ops->switch_vif_chanctx)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < n_vifs; i++) {
+		struct ieee80211_chanctx *new_ctx =
+			container_of(vifs[i].new_ctx,
+				     struct ieee80211_chanctx,
+				     conf);
+		struct ieee80211_chanctx *old_ctx =
+			container_of(vifs[i].old_ctx,
+				     struct ieee80211_chanctx,
+				     conf);
+
+		WARN_ON_ONCE(!old_ctx->driver_present);
+		WARN_ON_ONCE((mode == CHANCTX_SWMODE_SWAP_CONTEXTS &&
+			      new_ctx->driver_present) ||
+			     (mode == CHANCTX_SWMODE_REASSIGN_VIF &&
+			      !new_ctx->driver_present));
+	}
+
+	trace_drv_switch_vif_chanctx(local, vifs, n_vifs, mode);
+	ret = local->ops->switch_vif_chanctx(&local->hw,
+					     vifs, n_vifs, mode);
+	trace_drv_return_int(local, ret);
+
+	if (!ret && mode == CHANCTX_SWMODE_SWAP_CONTEXTS) {
+		for (i = 0; i < n_vifs; i++) {
+			struct ieee80211_chanctx *new_ctx =
+				container_of(vifs[i].new_ctx,
+					     struct ieee80211_chanctx,
+					     conf);
+			struct ieee80211_chanctx *old_ctx =
+				container_of(vifs[i].old_ctx,
+					     struct ieee80211_chanctx,
+					     conf);
+
+			new_ctx->driver_present = true;
+			old_ctx->driver_present = false;
+		}
+	}
+
+	return ret;
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 518c574..79f8234 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -930,58 +930,11 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int
+int
 drv_switch_vif_chanctx(struct ieee80211_local *local,
 		       struct ieee80211_vif_chanctx_switch *vifs,
 		       int n_vifs,
-		       enum ieee80211_chanctx_switch_mode mode)
-{
-	int ret = 0;
-	int i;
-
-	if (!local->ops->switch_vif_chanctx)
-		return -EOPNOTSUPP;
-
-	for (i = 0; i < n_vifs; i++) {
-		struct ieee80211_chanctx *new_ctx =
-			container_of(vifs[i].new_ctx,
-				     struct ieee80211_chanctx,
-				     conf);
-		struct ieee80211_chanctx *old_ctx =
-			container_of(vifs[i].old_ctx,
-				     struct ieee80211_chanctx,
-				     conf);
-
-		WARN_ON_ONCE(!old_ctx->driver_present);
-		WARN_ON_ONCE((mode == CHANCTX_SWMODE_SWAP_CONTEXTS &&
-			      new_ctx->driver_present) ||
-			     (mode == CHANCTX_SWMODE_REASSIGN_VIF &&
-			      !new_ctx->driver_present));
-	}
-
-	trace_drv_switch_vif_chanctx(local, vifs, n_vifs, mode);
-	ret = local->ops->switch_vif_chanctx(&local->hw,
-					     vifs, n_vifs, mode);
-	trace_drv_return_int(local, ret);
-
-	if (!ret && mode == CHANCTX_SWMODE_SWAP_CONTEXTS) {
-		for (i = 0; i < n_vifs; i++) {
-			struct ieee80211_chanctx *new_ctx =
-				container_of(vifs[i].new_ctx,
-					     struct ieee80211_chanctx,
-					     conf);
-			struct ieee80211_chanctx *old_ctx =
-				container_of(vifs[i].old_ctx,
-					     struct ieee80211_chanctx,
-					     conf);
-
-			new_ctx->driver_present = true;
-			old_ctx->driver_present = false;
-		}
-	}
-
-	return ret;
-}
+		       enum ieee80211_chanctx_switch_mode mode);
 
 static inline int drv_start_ap(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
-- 
1.8.1.4

