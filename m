Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHOTkm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/9] mac80211: Introduce per vif frame registration API
Date: Sat, 15 Aug 2015 22:39:50 +0300
Message-Id: <1439667594-13632-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214050_690897_70F3A48D)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Currently the cfg80211's frame registration api receives wdev, however
mac80211 assumes per device filter configuration and ignores wdev.
Per device filtering is too wasteful, especially for multi-channel
devices.
Introduce new per vif frame registration API and use it for probe
request registrations in ieee80211_mgmt_frame_register()
Also call directly to ieee80211_configure_filter instead of using a work
since it is now allowed to sleep in ieee80211_mgmt_frame_register.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h    | 16 ++++++++++++++++
 net/mac80211/cfg.c        | 22 ++++++++++++++++++----
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 net/mac80211/trace.h      | 30 ++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3314e5..16786450 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5,6 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1358,6 +1359,8 @@ enum ieee80211_vif_flags {
  * @debugfs_dir: debugfs dentry, can be used by drivers to create own per
  *	interface debug files. Note that it will be NULL for the virtual
  *	monitor interface (if that is requested.)
+ * @probe_req_reg: probe requests should be reported to mac80211 for this
+ *	interface.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  * @txq: the multicast data TX queue (if driver uses the TXQ abstraction)
@@ -1382,6 +1385,8 @@ struct ieee80211_vif {
 	struct dentry *debugfs_dir;
 #endif
 
+	unsigned int probe_req_reg;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -2825,6 +2830,13 @@ enum ieee80211_reconfig_type {
  *	See the section "Frame filtering" for more information.
  *	This callback must be implemented and can sleep.
  *
+ * @config_iface_filter: Configure the interface's RX filter.
+ *	This callback is optional and is used to configure which frames
+ *	should be passed to mac80211. The filter_flags is the combination
+ *	of FIF_* flags. The changed_flags is a bit mask that indicates
+ *	which flags are changed.
+ *	This callback can sleep.
+ *
  * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
  * 	must be set or cleared for a given STA. Must be atomic.
  *
@@ -3264,6 +3276,10 @@ struct ieee80211_ops {
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 u64 multicast);
+	void (*config_iface_filter)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    unsigned int filter_flags,
+				    unsigned int changed_flags);
 	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		       bool set);
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1ca972e..9eab783 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3516,18 +3516,32 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 					  u16 frame_type, bool reg)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
 	switch (frame_type) {
 	case IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ:
-		if (reg)
+		if (reg) {
 			local->probe_req_reg++;
-		else
-			local->probe_req_reg--;
+			sdata->vif.probe_req_reg++;
+		} else {
+			if (local->probe_req_reg)
+				local->probe_req_reg--;
+
+			if (sdata->vif.probe_req_reg)
+				sdata->vif.probe_req_reg--;
+		}
 
 		if (!local->open_count)
 			break;
 
-		ieee80211_queue_work(&local->hw, &local->reconfig_filter);
+		if (sdata->vif.probe_req_reg == 1)
+			drv_config_iface_filter(local, sdata, FIF_PROBE_REQ,
+						FIF_PROBE_REQ);
+		else if (sdata->vif.probe_req_reg == 0)
+			drv_config_iface_filter(local, sdata, 0,
+						FIF_PROBE_REQ);
+
+		ieee80211_configure_filter(local);
 		break;
 	default:
 		break;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 02d9133..157b20b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -260,6 +260,22 @@ static inline void drv_configure_filter(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_config_iface_filter(struct ieee80211_local *local,
+					   struct ieee80211_sub_if_data *sdata,
+					   unsigned int filter_flags,
+					   unsigned int changed_flags)
+{
+	might_sleep();
+
+	trace_drv_config_iface_filter(local, sdata, filter_flags,
+				      changed_flags);
+	if (local->ops->config_iface_filter)
+		local->ops->config_iface_filter(&local->hw, &sdata->vif,
+						filter_flags,
+						changed_flags);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_set_tim(struct ieee80211_local *local,
 			      struct ieee80211_sta *sta, bool set)
 {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6f14591..b5960b9 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -497,6 +497,36 @@ TRACE_EVENT(drv_configure_filter,
 	)
 );
 
+TRACE_EVENT(drv_config_iface_filter,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 unsigned int filter_flags,
+		 unsigned int changed_flags),
+
+	TP_ARGS(local, sdata, filter_flags, changed_flags),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(unsigned int, filter_flags)
+		__field(unsigned int, changed_flags)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->filter_flags = filter_flags;
+		__entry->changed_flags = changed_flags;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT
+		" filter_flags: %#x changed_flags: %#x",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->filter_flags,
+		__entry->changed_flags
+	)
+);
+
 TRACE_EVENT(drv_set_tim,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sta *sta, bool set),
-- 
2.1.4

