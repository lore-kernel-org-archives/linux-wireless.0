Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbbIWMSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 08:18:45 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mac80211: Deinline drv_ampdu_action()
Date: Wed, 23 Sep 2015 14:18:35 +0200
Message-Id: <1443010716-32651-2-git-send-email-dvlasenk@redhat.com> (sfid-20150923_141924_630545_0790077D)
In-Reply-To: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com>
References: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining the function size is 755 bytes and there are
6 callsites.

Total size reduction is about 3.3 kbytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---

Rediffed against mac80211-next

 net/mac80211/driver-ops.c | 26 ++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 30 +++++-------------------------
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 54581ce..4f7c81d 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -191,3 +191,29 @@ drv_switch_vif_chanctx(struct ieee80211_local *local,
 
 	return ret;
 }
+
+int drv_ampdu_action(struct ieee80211_local *local,
+		     struct ieee80211_sub_if_data *sdata,
+		     enum ieee80211_ampdu_mlme_action action,
+		     struct ieee80211_sta *sta, u16 tid,
+		     u16 *ssn, u8 buf_size, bool amsdu)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_ampdu_action(local, sdata, action, sta, tid,
+			       ssn, buf_size, amsdu);
+
+	if (local->ops->ampdu_action)
+		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
+					       sta, tid, ssn, buf_size, amsdu);
+
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1cf1b4a..7f08d82 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -649,31 +649,11 @@ static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_ampdu_action(struct ieee80211_local *local,
-				   struct ieee80211_sub_if_data *sdata,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid,
-				   u16 *ssn, u8 buf_size, bool amsdu)
-{
-	int ret = -EOPNOTSUPP;
-
-	might_sleep();
-
-	sdata = get_bss_sdata(sdata);
-	if (!check_sdata_in_driver(sdata))
-		return -EIO;
-
-	trace_drv_ampdu_action(local, sdata, action, sta, tid,
-			       ssn, buf_size, amsdu);
-
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn, buf_size, amsdu);
-
-	trace_drv_return_int(local, ret);
-
-	return ret;
-}
+int drv_ampdu_action(struct ieee80211_local *local,
+		     struct ieee80211_sub_if_data *sdata,
+		     enum ieee80211_ampdu_mlme_action action,
+		     struct ieee80211_sta *sta, u16 tid,
+		     u16 *ssn, u8 buf_size, bool amsdu);
 
 static inline int drv_get_survey(struct ieee80211_local *local, int idx,
 				struct survey_info *survey)
-- 
1.8.1.4

