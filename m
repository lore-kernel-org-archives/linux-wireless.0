Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbbIWMSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 08:18:47 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mac80211: Deinline drv_get/set/reset_tsf()
Date: Wed, 23 Sep 2015 14:18:36 +0200
Message-Id: <1443010716-32651-3-git-send-email-dvlasenk@redhat.com> (sfid-20150923_141916_752131_747B0D68)
In-Reply-To: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com>
References: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com>
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
CC: Johannes Berg <johannes.berg@intel.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---

Rediffed against mac80211-next

 net/mac80211/driver-ops.c | 46 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 52 +++++++----------------------------------------
 2 files changed, 53 insertions(+), 45 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 4f7c81d..5d51a5d 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -139,6 +139,52 @@ int drv_conf_tx(struct ieee80211_local *local,
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
 int
 drv_switch_vif_chanctx(struct ieee80211_local *local,
 		       struct ieee80211_vif_chanctx_switch *vifs,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 7f08d82..5ef28af 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -590,51 +590,13 @@ int drv_conf_tx(struct ieee80211_local *local,
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
-
-static inline void drv_set_tsf(struct ieee80211_local *local,
-			       struct ieee80211_sub_if_data *sdata,
-			       u64 tsf)
-{
-	might_sleep();
-
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
+u64 drv_get_tsf(struct ieee80211_local *local,
+		struct ieee80211_sub_if_data *sdata);
+void drv_set_tsf(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u64 tsf);
+void drv_reset_tsf(struct ieee80211_local *local,
+		   struct ieee80211_sub_if_data *sdata);
 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 {
-- 
1.8.1.4

