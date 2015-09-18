Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbIRNUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:20:08 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] mac80211: Deinline drv_get/set/reset_tsf()
Date: Fri, 18 Sep 2015 15:19:37 +0200
Message-Id: <1442582379-10342-5-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152116_154456_BA620E13)
In-Reply-To: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining these functions have sizes and callsite counts
as follows:

drv_get_tsf: 634 bytes, 6 calls
drv_set_tsf: 626 bytes, 2 calls
drv_reset_tsf: 617 bytes, 2 calls

Total size reduction is about 4.2 kbytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/mac80211/driver-ops.c | 46 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 50 +++++++----------------------------------------
 2 files changed, 53 insertions(+), 43 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 476d684..1c91a22 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -85,6 +85,52 @@ int drv_conf_tx(struct ieee80211_local *local,
 	return ret;
 }
 
+u64 drv_get_tsf(struct ieee80211_local *local,
+		struct ieee80211_sub_if_data *sdata)
+{
+	u64 ret = -1ULL;
+
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return ret;
+
+	trace_drv_get_tsf(local, sdata);
+	if (local->ops->get_tsf)
+		ret = local->ops->get_tsf(&local->hw, &sdata->vif);
+	trace_drv_return_u64(local, ret);
+	return ret;
+}
+
+void drv_set_tsf(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u64 tsf)
+{
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_set_tsf(local, sdata, tsf);
+	if (local->ops->set_tsf)
+		local->ops->set_tsf(&local->hw, &sdata->vif, tsf);
+	trace_drv_return_void(local);
+}
+
+void drv_reset_tsf(struct ieee80211_local *local,
+		   struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_reset_tsf(local, sdata);
+	if (local->ops->reset_tsf)
+		local->ops->reset_tsf(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
+
 int drv_ampdu_action(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
 		     enum ieee80211_ampdu_mlme_action action,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 92e7cf1..62999a7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -618,51 +618,15 @@ int drv_conf_tx(struct ieee80211_local *local,
 		struct ieee80211_sub_if_data *sdata, u16 ac,
 		const struct ieee80211_tx_queue_params *params);
 
-static inline u64 drv_get_tsf(struct ieee80211_local *local,
-			      struct ieee80211_sub_if_data *sdata)
-{
-	u64 ret = -1ULL;
-
-	might_sleep();
-
-	if (!check_sdata_in_driver(sdata))
-		return ret;
-
-	trace_drv_get_tsf(local, sdata);
-	if (local->ops->get_tsf)
-		ret = local->ops->get_tsf(&local->hw, &sdata->vif);
-	trace_drv_return_u64(local, ret);
-	return ret;
-}
+u64 drv_get_tsf(struct ieee80211_local *local,
+		struct ieee80211_sub_if_data *sdata);
 
-static inline void drv_set_tsf(struct ieee80211_local *local,
-			       struct ieee80211_sub_if_data *sdata,
-			       u64 tsf)
-{
-	might_sleep();
+void drv_set_tsf(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u64 tsf);
 
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	trace_drv_set_tsf(local, sdata, tsf);
-	if (local->ops->set_tsf)
-		local->ops->set_tsf(&local->hw, &sdata->vif, tsf);
-	trace_drv_return_void(local);
-}
-
-static inline void drv_reset_tsf(struct ieee80211_local *local,
-				 struct ieee80211_sub_if_data *sdata)
-{
-	might_sleep();
-
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	trace_drv_reset_tsf(local, sdata);
-	if (local->ops->reset_tsf)
-		local->ops->reset_tsf(&local->hw, &sdata->vif);
-	trace_drv_return_void(local);
-}
+void drv_reset_tsf(struct ieee80211_local *local,
+		   struct ieee80211_sub_if_data *sdata);
 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 {
-- 
1.8.1.4

