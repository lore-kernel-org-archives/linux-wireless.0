Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbbIRNTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:19:50 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] mac80211: Deinline drv_conf_tx()
Date: Fri, 18 Sep 2015 15:19:34 +0200
Message-Id: <1442582379-10342-2-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152148_707118_D04DDCE0)
In-Reply-To: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining the function size is 785 bytes and there are
7 callsites.

Total size reduction is about 3.5 kbytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/mac80211/driver-ops.c | 25 +++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 27 +++------------------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 267c3b1..b28e66ca 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -39,3 +39,28 @@ int drv_sta_state(struct ieee80211_local *local,
 	trace_drv_return_int(local, ret);
 	return ret;
 }
+
+int drv_conf_tx(struct ieee80211_local *local,
+		struct ieee80211_sub_if_data *sdata, u16 ac,
+		const struct ieee80211_tx_queue_params *params)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	if (WARN_ONCE(params->cw_min == 0 ||
+		      params->cw_min > params->cw_max,
+		      "%s: invalid CW_min/CW_max: %d/%d\n",
+		      sdata->name, params->cw_min, params->cw_max))
+		return -EINVAL;
+
+	trace_drv_conf_tx(local, sdata, ac, params);
+	if (local->ops->conf_tx)
+		ret = local->ops->conf_tx(&local->hw, &sdata->vif,
+					  ac, params);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 02d9133..bac456b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -630,30 +630,9 @@ static inline void drv_sta_statistics(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_conf_tx(struct ieee80211_local *local,
-			      struct ieee80211_sub_if_data *sdata, u16 ac,
-			      const struct ieee80211_tx_queue_params *params)
-{
-	int ret = -EOPNOTSUPP;
-
-	might_sleep();
-
-	if (!check_sdata_in_driver(sdata))
-		return -EIO;
-
-	if (WARN_ONCE(params->cw_min == 0 ||
-		      params->cw_min > params->cw_max,
-		      "%s: invalid CW_min/CW_max: %d/%d\n",
-		      sdata->name, params->cw_min, params->cw_max))
-		return -EINVAL;
-
-	trace_drv_conf_tx(local, sdata, ac, params);
-	if (local->ops->conf_tx)
-		ret = local->ops->conf_tx(&local->hw, &sdata->vif,
-					  ac, params);
-	trace_drv_return_int(local, ret);
-	return ret;
-}
+int drv_conf_tx(struct ieee80211_local *local,
+		struct ieee80211_sub_if_data *sdata, u16 ac,
+		const struct ieee80211_tx_queue_params *params);
 
 static inline u64 drv_get_tsf(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata)
-- 
1.8.1.4

