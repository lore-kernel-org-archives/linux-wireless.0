Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbIRNUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:20:02 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] mac80211: Deinline drv_ampdu_action()
Date: Fri, 18 Sep 2015 15:19:36 +0200
Message-Id: <1442582379-10342-4-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152130_711810_8CA4B863)
In-Reply-To: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining the function size is 755 bytes and there are
6 callsites.

Total size reduction is about 3.3 kbytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/mac80211/driver-ops.c | 25 +++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 29 +++++------------------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index b85f6ff..476d684 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -84,3 +84,28 @@ int drv_conf_tx(struct ieee80211_local *local,
 	trace_drv_return_int(local, ret);
 	return ret;
 }
+
+int drv_ampdu_action(struct ieee80211_local *local,
+		     struct ieee80211_sub_if_data *sdata,
+		     enum ieee80211_ampdu_mlme_action action,
+		     struct ieee80211_sta *sta, u16 tid,
+		     u16 *ssn, u8 buf_size)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
+
+	if (local->ops->ampdu_action)
+		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
+					       sta, tid, ssn, buf_size);
+
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index fdde11e..92e7cf1 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -677,30 +677,11 @@ static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_ampdu_action(struct ieee80211_local *local,
-				   struct ieee80211_sub_if_data *sdata,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid,
-				   u16 *ssn, u8 buf_size)
-{
-	int ret = -EOPNOTSUPP;
-
-	might_sleep();
-
-	sdata = get_bss_sdata(sdata);
-	if (!check_sdata_in_driver(sdata))
-		return -EIO;
-
-	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
-
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn, buf_size);
-
-	trace_drv_return_int(local, ret);
-
-	return ret;
-}
+int drv_ampdu_action(struct ieee80211_local *local,
+		     struct ieee80211_sub_if_data *sdata,
+		     enum ieee80211_ampdu_mlme_action action,
+		     struct ieee80211_sta *sta, u16 tid,
+		     u16 *ssn, u8 buf_size);
 
 static inline int drv_get_survey(struct ieee80211_local *local, int idx,
 				struct survey_info *survey)
-- 
1.8.1.4

