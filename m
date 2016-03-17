Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936107AbcCQNlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:41:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/5] mac80211: add an option to not disconnect on beacon loss
Date: Thu, 17 Mar 2016 15:41:36 +0200
Message-Id: <1458222099-30301-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_144148_294567_44AB7307)
In-Reply-To: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add the option to set mac80211 to not disconnect on beacon loss.
If this option is set, mac80211 will send a beacon loss event
to userspace but will not disconnect.
The beacon loss event is sent only once as long as no response
is received from the AP. If after receiving response from the AP the
beacon loss threshold is hit again, another beacon loss event will
be sent.
The default behavior remains as it was: probe the AP and disconnect
if the AP does not respond.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/main.c        |  2 ++
 net/mac80211/mlme.c        | 14 +++++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c6830fb..0008f28 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -356,6 +356,8 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_160MHZ	= BIT(13),
 	IEEE80211_STA_DISABLE_WMM	= BIT(14),
 	IEEE80211_STA_ENABLE_RRM	= BIT(15),
+	IEEE80211_STA_BEACON_LOSS_DO_NOT_DISCONNECT	= BIT(16),
+	IEEE80211_STA_BEACON_LOSS_REPORTED	= BIT(17),
 };
 
 struct ieee80211_mgd_auth_data {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 33c80de..6083256 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -554,6 +554,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
 				   NL80211_FEATURE_AP_SCAN;
 
+	wiphy_ext_feature_set(wiphy,
+			      NL80211_EXT_FEATURE_BEACON_LOSS_DO_NOT_DISCONNECT);
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 281b8d6..8968a96 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -126,6 +126,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 		return;
 
 	ifmgd->probe_send_count = 0;
+	sdata->u.mgd.flags &= ~IEEE80211_STA_BEACON_LOSS_REPORTED;
 
 	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
 		return;
@@ -1926,6 +1927,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	/* just to be sure */
 	ieee80211_stop_poll(sdata);
+	sdata->u.mgd.flags &= ~IEEE80211_STA_BEACON_LOSS_REPORTED;
 
 	ieee80211_led_assoc(local, 1);
 
@@ -1984,6 +1986,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee80211_stop_poll(sdata);
+	ifmgd->flags &= ~IEEE80211_STA_BEACON_LOSS_REPORTED;
 
 	ifmgd->associated = NULL;
 	netif_carrier_off(sdata->dev);
@@ -2422,8 +2425,12 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 		sdata_info(sdata, "Connection to AP %pM lost\n",
 			   ifmgd->bssid);
 		__ieee80211_disconnect(sdata);
-	} else {
+	} else if (!(ifmgd->flags & IEEE80211_STA_BEACON_LOSS_DO_NOT_DISCONNECT)) {
 		ieee80211_mgd_probe_ap(sdata, true);
+	} else if (!(ifmgd->flags & IEEE80211_STA_BEACON_LOSS_REPORTED)) {
+		ieee80211_cqm_beacon_loss_notify(&sdata->vif,
+						 GFP_KERNEL);
+		ifmgd->flags |= IEEE80211_STA_BEACON_LOSS_REPORTED;
 	}
 }
 
@@ -4742,6 +4749,11 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
 							sdata->vif.type);
 
+	if (req->flags & ASSOC_REQ_BEACON_LOSS_DO_NOT_DISCONNECT)
+		ifmgd->flags |= IEEE80211_STA_BEACON_LOSS_DO_NOT_DISCONNECT;
+	else
+		ifmgd->flags &= ~IEEE80211_STA_BEACON_LOSS_DO_NOT_DISCONNECT;
+
 	/* kick off associate process */
 
 	ifmgd->assoc_data = assoc_data;
-- 
2.5.0

