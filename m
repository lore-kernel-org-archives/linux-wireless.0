Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZGTDq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:46:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/5] iwmc3200wifi: use cfg80211_connect_result to send req/resp IE
Date: Mon, 20 Jul 2009 11:47:45 +0800
Message-Id: <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_connect_result() let us specify associate request and
response IEs as parameters after we are connected. We use this
capability instead of doing it ourselves with WEXT.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    5 ++++
 drivers/net/wireless/iwmc3200wifi/main.c |    7 +++++
 drivers/net/wireless/iwmc3200wifi/rx.c   |   36 +++++++++++++++++++----------
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 79d9d89..2175a48 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -281,6 +281,11 @@ struct iwm_priv {
 	struct work_struct reset_worker;
 	struct mutex mutex;
 
+	u8 *req_ie;
+	int req_ie_len;
+	u8 *resp_ie;
+	int resp_ie_len;
+
 	char private[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 484f110..cf25744 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -497,6 +497,13 @@ void iwm_link_off(struct iwm_priv *iwm)
 	memset(wstats, 0, sizeof(struct iw_statistics));
 	wstats->qual.updated = IW_QUAL_ALL_INVALID;
 
+	kfree(iwm->req_ie);
+	iwm->req_ie = NULL;
+	iwm->req_ie_len = 0;
+	kfree(iwm->resp_ie);
+	iwm->resp_ie = NULL;
+	iwm->resp_ie_len = 0;
+
 	del_timer_sync(&iwm->watchdog);
 }
 
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 82b572a..6743391 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -519,7 +519,8 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 
 		cfg80211_connect_result(iwm_to_ndev(iwm),
 					complete->bssid,
-					NULL, 0, NULL, 0,
+					iwm->req_ie, iwm->req_ie_len,
+					iwm->resp_ie, iwm->resp_ie_len,
 					WLAN_STATUS_SUCCESS, GFP_KERNEL);
 		break;
 	case UMAC_ASSOC_COMPLETE_FAILURE:
@@ -771,37 +772,46 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
 {
 	struct iwm_umac_notif_mgt_frame *mgt_frame =
-	(struct iwm_umac_notif_mgt_frame *)buf;
+			(struct iwm_umac_notif_mgt_frame *)buf;
 	struct ieee80211_mgmt *mgt = (struct ieee80211_mgmt *)mgt_frame->frame;
 	u8 *ie;
-	unsigned int event;
-	union iwreq_data wrqu;
 
 	IWM_HEXDUMP(iwm, DBG, MLME, "MGT: ", mgt_frame->frame,
 		    le16_to_cpu(mgt_frame->len));
 
 	if (ieee80211_is_assoc_req(mgt->frame_control)) {
 		ie = mgt->u.assoc_req.variable;;
-		event = IWEVASSOCREQIE;
+		iwm->req_ie_len =
+				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		kfree(iwm->req_ie);
+		iwm->req_ie = kmemdup(mgt->u.assoc_req.variable,
+				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_req(mgt->frame_control)) {
 		ie = mgt->u.reassoc_req.variable;;
-		event = IWEVASSOCREQIE;
+		iwm->req_ie_len =
+				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		kfree(iwm->req_ie);
+		iwm->req_ie = kmemdup(mgt->u.reassoc_req.variable,
+				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_assoc_resp(mgt->frame_control)) {
 		ie = mgt->u.assoc_resp.variable;;
-		event = IWEVASSOCRESPIE;
+		iwm->resp_ie_len =
+				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		kfree(iwm->resp_ie);
+		iwm->resp_ie = kmemdup(mgt->u.assoc_resp.variable,
+				       iwm->resp_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_resp(mgt->frame_control)) {
 		ie = mgt->u.reassoc_resp.variable;;
-		event = IWEVASSOCRESPIE;
+		iwm->resp_ie_len =
+				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		kfree(iwm->resp_ie);
+		iwm->resp_ie = kmemdup(mgt->u.reassoc_resp.variable,
+				       iwm->resp_ie_len, GFP_KERNEL);
 	} else {
 		IWM_ERR(iwm, "Unsupported management frame");
 		return 0;
 	}
 
-	wrqu.data.length = le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
-
-	IWM_HEXDUMP(iwm, DBG, MLME, "EVT: ", ie, wrqu.data.length);
-	wireless_send_event(iwm_to_ndev(iwm), event, &wrqu, ie);
-
 	return 0;
 }
 
-- 
1.6.0.4

