Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbbIRNT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:19:56 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] mac80211: Deinline drv_sta_rc_update()
Date: Fri, 18 Sep 2015 15:19:35 +0200
Message-Id: <1442582379-10342-3-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152137_723269_D1479F4D)
In-Reply-To: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining the function size is 706 bytes and there are
2 callsites, reducing code size by about 700 bytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/mac80211/driver-ops.c | 20 ++++++++++++++++++++
 net/mac80211/driver-ops.h | 22 +++-------------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index b28e66ca..b85f6ff 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -40,6 +40,26 @@ int drv_sta_state(struct ieee80211_local *local,
 	return ret;
 }
 
+void drv_sta_rc_update(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_sta *sta, u32 changed)
+{
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	WARN_ON(changed & IEEE80211_RC_SUPP_RATES_CHANGED &&
+		(sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		 sdata->vif.type != NL80211_IFTYPE_MESH_POINT));
+
+	trace_drv_sta_rc_update(local, sdata, sta, changed);
+	if (local->ops->sta_rc_update)
+		local->ops->sta_rc_update(&local->hw, &sdata->vif,
+					  sta, changed);
+
+	trace_drv_return_void(local);
+}
+
 int drv_conf_tx(struct ieee80211_local *local,
 		struct ieee80211_sub_if_data *sdata, u16 ac,
 		const struct ieee80211_tx_queue_params *params)
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index bac456b..fdde11e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -580,25 +580,9 @@ int drv_sta_state(struct ieee80211_local *local,
 		  enum ieee80211_sta_state old_state,
 		  enum ieee80211_sta_state new_state);
 
-static inline void drv_sta_rc_update(struct ieee80211_local *local,
-				     struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_sta *sta, u32 changed)
-{
-	sdata = get_bss_sdata(sdata);
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	WARN_ON(changed & IEEE80211_RC_SUPP_RATES_CHANGED &&
-		(sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-		 sdata->vif.type != NL80211_IFTYPE_MESH_POINT));
-
-	trace_drv_sta_rc_update(local, sdata, sta, changed);
-	if (local->ops->sta_rc_update)
-		local->ops->sta_rc_update(&local->hw, &sdata->vif,
-					  sta, changed);
-
-	trace_drv_return_void(local);
-}
+void drv_sta_rc_update(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_sta *sta, u32 changed);
 
 static inline void drv_sta_rate_tbl_update(struct ieee80211_local *local,
 					   struct ieee80211_sub_if_data *sdata,
-- 
1.8.1.4

