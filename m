Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbbIWMSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 08:18:42 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mac80211: Deinline drv_switch_vif_chanctx()
Date: Wed, 23 Sep 2015 14:18:34 +0200
Message-Id: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com> (sfid-20150923_141933_950247_3C71FF03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining the function size is 821 bytes and there are
2 callsites, reducing code size by about 800 bytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---

Rediffed against mac80211-next

 net/mac80211/driver-ops.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 51 ++-------------------------------------------
 2 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index b284e6e..54581ce 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -138,3 +138,56 @@ int drv_conf_tx(struct ieee80211_local *local,
 	trace_drv_return_int(local, ret);
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
index 0baeefd..1cf1b4a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1002,58 +1002,11 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
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

