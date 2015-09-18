Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbIRNUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:20:14 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] mac80211: Deinline drv_add/remove/change_interface()
Date: Fri, 18 Sep 2015 15:19:38 +0200
Message-Id: <1442582379-10342-6-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152100_982368_51BAA9B4)
In-Reply-To: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining these functions have sizes and callsite counts
as follows:

drv_add_interface: 638 bytes, 5 calls
drv_remove_interface: 611 bytes, 6 calls
drv_change_interface: 658 bytes, 1 call

Total size reduction is about 9 kbytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/mac80211/driver-ops.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 58 ++++++-----------------------------------------
 2 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 1c91a22..3e144b9 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -8,6 +8,60 @@
 #include "trace.h"
 #include "driver-ops.h"
 
+int drv_add_interface(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata)
+{
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+		     !ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
+		     !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
+		return -EINVAL;
+
+	trace_drv_add_interface(local, sdata);
+	ret = local->ops->add_interface(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+
+	if (ret == 0)
+		sdata->flags |= IEEE80211_SDATA_IN_DRIVER;
+
+	return ret;
+}
+
+int drv_change_interface(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata,
+			 enum nl80211_iftype type, bool p2p)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_change_interface(local, sdata, type, p2p);
+	ret = local->ops->change_interface(&local->hw, &sdata->vif, type, p2p);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+void drv_remove_interface(struct ieee80211_local *local,
+			  struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_remove_interface(local, sdata);
+	local->ops->remove_interface(&local->hw, &sdata->vif);
+	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
+	trace_drv_return_void(local);
+}
+
 __must_check
 int drv_sta_state(struct ieee80211_local *local,
 		  struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 62999a7..518c574 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -137,59 +137,15 @@ static inline void drv_set_wakeup(struct ieee80211_local *local,
 }
 #endif
 
-static inline int drv_add_interface(struct ieee80211_local *local,
-				    struct ieee80211_sub_if_data *sdata)
-{
-	int ret;
-
-	might_sleep();
-
-	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-		     !ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
-		     !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
-		return -EINVAL;
-
-	trace_drv_add_interface(local, sdata);
-	ret = local->ops->add_interface(&local->hw, &sdata->vif);
-	trace_drv_return_int(local, ret);
-
-	if (ret == 0)
-		sdata->flags |= IEEE80211_SDATA_IN_DRIVER;
-
-	return ret;
-}
-
-static inline int drv_change_interface(struct ieee80211_local *local,
-				       struct ieee80211_sub_if_data *sdata,
-				       enum nl80211_iftype type, bool p2p)
-{
-	int ret;
-
-	might_sleep();
-
-	if (!check_sdata_in_driver(sdata))
-		return -EIO;
-
-	trace_drv_change_interface(local, sdata, type, p2p);
-	ret = local->ops->change_interface(&local->hw, &sdata->vif, type, p2p);
-	trace_drv_return_int(local, ret);
-	return ret;
-}
+int drv_add_interface(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata);
 
-static inline void drv_remove_interface(struct ieee80211_local *local,
-					struct ieee80211_sub_if_data *sdata)
-{
-	might_sleep();
-
-	if (!check_sdata_in_driver(sdata))
-		return;
+int drv_change_interface(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata,
+			 enum nl80211_iftype type, bool p2p);
 
-	trace_drv_remove_interface(local, sdata);
-	local->ops->remove_interface(&local->hw, &sdata->vif);
-	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
-	trace_drv_return_void(local);
-}
+void drv_remove_interface(struct ieee80211_local *local,
+			  struct ieee80211_sub_if_data *sdata);
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
 {
-- 
1.8.1.4

