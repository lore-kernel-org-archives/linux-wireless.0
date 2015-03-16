Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbbCPVXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 17:23:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4] mac80211: notify the driver about association status
Date: Mon, 16 Mar 2015 23:23:36 +0200
Message-Id: <1426541017-10516-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150316_222353_411569_75F62D1F)
In-Reply-To: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can allow the driver to take action based on the
success / failure of the association.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h |  2 ++
 net/mac80211/mlme.c    | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6cddf77..dcddc4a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -331,9 +331,11 @@ struct ieee80211_rssi_event {
 /**
  * enum ieee80211_mlme_event_data - relevant when event type is %MLME_EVENT
  * @AUTH_EVENT: the MLME operation is authentication
+ * @ASSOC_EVENT: the MLME operation is association
  */
 enum ieee80211_mlme_event_data {
 	AUTH_EVENT,
+	ASSOC_EVENT,
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7865998..b6817c4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3041,6 +3041,10 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	u8 *pos;
 	bool reassoc;
 	struct cfg80211_bss *bss;
+	struct ieee80211_event event = {
+		.type = MLME_EVENT,
+		.u.mlme.data = ASSOC_EVENT,
+	};
 
 	sdata_assert_lock(sdata);
 
@@ -3092,6 +3096,9 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata, "%pM denied association (code=%d)\n",
 			   mgmt->sa, status_code);
 		ieee80211_destroy_assoc_data(sdata, false);
+		event.u.mlme.status = MLME_DENIED;
+		event.u.mlme.reason = status_code;
+		drv_event_callback(sdata->local, sdata, &event);
 	} else {
 		if (!ieee80211_assoc_success(sdata, bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
@@ -3099,6 +3106,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			cfg80211_assoc_timeout(sdata->dev, bss);
 			return;
 		}
+		event.u.mlme.status = MLME_SUCCESS;
+		drv_event_callback(sdata->local, sdata, &event);
 		sdata_info(sdata, "associated\n");
 
 		/*
@@ -3835,9 +3844,15 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 		if ((ifmgd->assoc_data->need_beacon && !ifmgd->have_beacon) ||
 		    ieee80211_do_assoc(sdata)) {
 			struct cfg80211_bss *bss = ifmgd->assoc_data->bss;
+			struct ieee80211_event event = {
+				.type = MLME_EVENT,
+				.u.mlme.data = ASSOC_EVENT,
+				.u.mlme.status = MLME_TIMEOUT,
+			};
 
 			ieee80211_destroy_assoc_data(sdata, false);
 			cfg80211_assoc_timeout(sdata->dev, bss);
+			drv_event_callback(sdata->local, sdata, &event);
 		}
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(sdata, ifmgd->assoc_data->timeout);
-- 
1.9.1

