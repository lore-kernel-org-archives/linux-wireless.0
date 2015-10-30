Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35555 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbbJ3Rq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 13:46:27 -0400
Received: by pasz6 with SMTP id z6so80392148pas.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2015 10:46:27 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: Handle sleep requirements for channel context ops.
Date: Fri, 30 Oct 2015 23:16:15 +0530
Message-Id: <1446227175-28942-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20151030_184630_987819_57741181)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

Channel context OPs can sleep, so add might_sleep() and
also document sleep requirements for those OPs.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/driver-ops.c |  2 ++
 net/mac80211/driver-ops.h | 10 ++++++++++
 3 files changed, 18 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4b9dd07..3876739 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3170,18 +3170,24 @@ enum ieee80211_reconfig_type {
  *	The callback is optional and can sleep.
  *
  * @add_chanctx: Notifies device driver about new channel context creation.
+ *	This callback may sleep.
  * @remove_chanctx: Notifies device driver about channel context destruction.
+ *	This callback may sleep.
  * @change_chanctx: Notifies device driver about channel context changes that
  *	may happen when combining different virtual interfaces on the same
  *	channel context with different settings
+ *	This callback may sleep.
  * @assign_vif_chanctx: Notifies device driver about channel context being bound
  *	to vif. Possible use is for hw queue remapping.
+ *	This callback may sleep.
  * @unassign_vif_chanctx: Notifies device driver about channel context being
  *	unbound from vif.
+ *	This callback may sleep.
  * @switch_vif_chanctx: switch a number of vifs from one chanctx to
  *	another, as specified in the list of
  *	@ieee80211_vif_chanctx_switch passed to the driver, according
  *	to the mode defined in &ieee80211_chanctx_switch_mode.
+ *	This callback may sleep.
  *
  * @start_ap: Start operation on the AP interface, this is called after all the
  *	information in bss_conf is set and beacon can be retrieved. A channel
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index a1d5431..578403a 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -192,6 +192,8 @@ int drv_switch_vif_chanctx(struct ieee80211_local *local,
 	int ret = 0;
 	int i;
 
+	might_sleep();
+
 	if (!local->ops->switch_vif_chanctx)
 		return -EOPNOTSUPP;
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3098709..5869bc6 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -871,6 +871,8 @@ static inline int drv_add_chanctx(struct ieee80211_local *local,
 {
 	int ret = -EOPNOTSUPP;
 
+	might_sleep();
+
 	trace_drv_add_chanctx(local, ctx);
 	if (local->ops->add_chanctx)
 		ret = local->ops->add_chanctx(&local->hw, &ctx->conf);
@@ -884,6 +886,8 @@ static inline int drv_add_chanctx(struct ieee80211_local *local,
 static inline void drv_remove_chanctx(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx)
 {
+	might_sleep();
+
 	if (WARN_ON(!ctx->driver_present))
 		return;
 
@@ -898,6 +902,8 @@ static inline void drv_change_chanctx(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx,
 				      u32 changed)
 {
+	might_sleep();
+
 	trace_drv_change_chanctx(local, ctx, changed);
 	if (local->ops->change_chanctx) {
 		WARN_ON_ONCE(!ctx->driver_present);
@@ -912,6 +918,8 @@ static inline int drv_assign_vif_chanctx(struct ieee80211_local *local,
 {
 	int ret = 0;
 
+	might_sleep();
+
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
@@ -931,6 +939,8 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 					    struct ieee80211_sub_if_data *sdata,
 					    struct ieee80211_chanctx *ctx)
 {
+	might_sleep();
+
 	if (!check_sdata_in_driver(sdata))
 		return;
 
-- 
1.9.1

