Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:43986 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030199Ab2ERMDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:21 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 3/6] mac80211: add drv_* wrappers for channel contexts
Date: Fri, 18 May 2012 14:03:06 +0200
Message-ID: <1337342589-10617-4-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140328_765931_BC032309)
In-Reply-To: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/driver-ops.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..5bc1efc 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -845,4 +845,49 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+
+static inline void
+drv_add_channel_context(struct ieee80211_local *local,
+		        struct ieee80211_channel_context *ctx)
+{
+	if (local->ops->add_channel_context)
+		local->ops->add_channel_context(&local->hw, ctx);
+}
+
+static inline void
+drv_remove_channel_context(struct ieee80211_local *local,
+			   struct ieee80211_channel_context *ctx)
+{
+	if (local->ops->remove_channel_context)
+		local->ops->remove_channel_context(&local->hw, ctx);
+}
+
+static inline void
+drv_change_channel_type(struct ieee80211_local *local,
+			struct ieee80211_channel_context *ctx)
+{
+	if (local->ops->change_channel_type)
+		local->ops->change_channel_type(&local->hw, ctx);
+}
+
+static inline void
+drv_assign_vif_channel_context(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_channel_context *ctx)
+{
+	if (local->ops->assign_vif_channel_context)
+		local->ops->assign_vif_channel_context(&local->hw,
+						       &sdata->vif, ctx);
+}
+
+static inline void
+drv_unassign_vif_channel_context(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_channel_context *ctx)
+{
+	if (local->ops->unassign_vif_channel_context)
+		local->ops->unassign_vif_channel_context(&local->hw,
+							 &sdata->vif, ctx);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
-- 
1.7.0.4

