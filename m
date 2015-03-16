Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbbCPVXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 17:23:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] mac80211: notify the driver about authentication status
Date: Mon, 16 Mar 2015 23:23:35 +0200
Message-Id: <1426541017-10516-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150316_222352_845463_60032503)
In-Reply-To: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can allow the driver to take action based on the
success / failure of the authentication.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/mlme.c    | 15 +++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7a966f3e..6cddf77 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -303,9 +303,11 @@ enum ieee80211_bss_change {
 /**
  * enum ieee80211_event_type - event to be notified to the low level driver
  * @RSSI_EVENT: AP's rssi crossed the a threshold set by the driver.
+ * @MLME_EVENT: event related to MLME
  */
 enum ieee80211_event_type {
 	RSSI_EVENT,
+	MLME_EVENT,
 };
 
 /**
@@ -327,14 +329,48 @@ struct ieee80211_rssi_event {
 };
 
 /**
+ * enum ieee80211_mlme_event_data - relevant when event type is %MLME_EVENT
+ * @AUTH_EVENT: the MLME operation is authentication
+ */
+enum ieee80211_mlme_event_data {
+	AUTH_EVENT,
+};
+
+/**
+ * enum ieee80211_mlme_event_status - relevant when event type is %MLME_EVENT
+ * @MLME_SUCCESS: the MLME operation completed successfully.
+ * @MLME_DENIED: the MLME operation was denied by the peer.
+ * @MLME_TIMEOUT: the MLME operation timed out.
+ */
+enum ieee80211_mlme_event_status {
+	MLME_SUCCESS,
+	MLME_DENIED,
+	MLME_TIMEOUT,
+};
+
+/**
+ * enum ieee80211_mlme_event - data attached to an %MLME_EVENT
+ * @data: See &enum ieee80211_mlme_event_data
+ * @status: See &enum ieee80211_mlme_event_status
+ * @reason: the reason code if applicable
+ */
+struct ieee80211_mlme_event {
+	enum ieee80211_mlme_event_data data;
+	enum ieee80211_mlme_event_status status;
+	u16 reason;
+};
+
+/**
  * struct ieee80211_event - event to be sent to the driver
  * @type The event itself. See &enum ieee80211_event_type.
  * @rssi: relevant if &type is %RSSI_EVENT
+ * @mlme: relevant if &type is %AUTH_EVENT
  */
 struct ieee80211_event {
 	enum ieee80211_event_type type;
 	union {
 		struct ieee80211_rssi_event rssi;
+		struct ieee80211_mlme_event mlme;
 	} u;
 };
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a8c8fe4..7865998 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2495,6 +2495,10 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	u8 bssid[ETH_ALEN];
 	u16 auth_alg, auth_transaction, status_code;
 	struct sta_info *sta;
+	struct ieee80211_event event = {
+		.type = MLME_EVENT,
+		.u.mlme.data = AUTH_EVENT,
+	};
 
 	sdata_assert_lock(sdata);
 
@@ -2527,6 +2531,9 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 			   mgmt->sa, status_code);
 		ieee80211_destroy_auth_data(sdata, false);
 		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
+		event.u.mlme.status = MLME_DENIED;
+		event.u.mlme.reason = status_code;
+		drv_event_callback(sdata->local, sdata, &event);
 		return;
 	}
 
@@ -2549,6 +2556,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	event.u.mlme.status = MLME_SUCCESS;
+	drv_event_callback(sdata->local, sdata, &event);
 	sdata_info(sdata, "authenticated\n");
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
@@ -3805,12 +3814,18 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			ieee80211_destroy_auth_data(sdata, false);
 		} else if (ieee80211_probe_auth(sdata)) {
 			u8 bssid[ETH_ALEN];
+			struct ieee80211_event event = {
+				.type = MLME_EVENT,
+				.u.mlme.data = AUTH_EVENT,
+				.u.mlme.status = MLME_TIMEOUT,
+			};
 
 			memcpy(bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN);
 
 			ieee80211_destroy_auth_data(sdata, false);
 
 			cfg80211_auth_timeout(sdata->dev, bssid);
+			drv_event_callback(sdata->local, sdata, &event);
 		}
 	} else if (ifmgd->auth_data && ifmgd->auth_data->timeout_started)
 		run_again(sdata, ifmgd->auth_data->timeout);
-- 
1.9.1

