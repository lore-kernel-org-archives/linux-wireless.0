Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:12654 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754691AbZIANMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:41 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 5/9] iwmc3200wifi: add disconnect work
Date: Tue,  1 Sep 2009 15:14:02 +0200
Message-Id: <cf887cbfdcddc6c3874e08978b8926f82862d345.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
 <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
 <b08ebbaa73e4796a6be51889860bc1bd67867a90.1251809163.git.sameo@linux.intel.com>
 <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
 <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

When the driver receives "connection terminated" event from device,
it could be caused by 2 reasons: the firmware is roaming or the
connection is lost (AP disappears). For the former, an association
complete event is supposed to come within 3 seconds. For the latter,
the driver won't receive any event except the connection terminated.
So we kick a delayed work (5*HZ) when we receive the connection
terminated event. It will be canceled if it turns out to be a roaming
event later. Otherwise we notify SME and userspace the disconnection.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    1 +
 drivers/net/wireless/iwmc3200wifi/main.c |   21 +++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/rx.c   |   32 +++++++++++++++++++++++++----
 3 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index f054cc8..da49df6 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -273,6 +273,7 @@ struct iwm_priv {
 
 	struct iw_statistics wstats;
 	struct delayed_work stats_request;
+	struct delayed_work disconnect;
 
 	struct iwm_debugfs dbg;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index cf25744..c41fa8c 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -108,6 +108,26 @@ static void iwm_statistics_request(struct work_struct *work)
 	iwm_send_umac_stats_req(iwm, 0);
 }
 
+static void iwm_disconnect_work(struct work_struct *work)
+{
+	struct iwm_priv *iwm =
+		container_of(work, struct iwm_priv, disconnect.work);
+
+	if (iwm->umac_profile_active)
+		iwm_invalidate_mlme_profile(iwm);
+
+	clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
+	iwm->umac_profile_active = 0;
+	memset(iwm->bssid, 0, ETH_ALEN);
+	iwm->channel = 0;
+
+	iwm_link_off(iwm);
+
+	wake_up_interruptible(&iwm->mlme_queue);
+
+	cfg80211_disconnected(iwm_to_ndev(iwm), 0, NULL, 0, GFP_KERNEL);
+}
+
 int __iwm_up(struct iwm_priv *iwm);
 int __iwm_down(struct iwm_priv *iwm);
 
@@ -198,6 +218,7 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	spin_lock_init(&iwm->cmd_lock);
 	iwm->scan_id = 1;
 	INIT_DELAYED_WORK(&iwm->stats_request, iwm_statistics_request);
+	INIT_DELAYED_WORK(&iwm->disconnect, iwm_disconnect_work);
 	INIT_WORK(&iwm->reset_worker, iwm_reset_worker);
 	INIT_LIST_HEAD(&iwm->bss_list);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 9e6f2cd..4d9793e 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -514,6 +514,7 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 		/* Internal roaming state, avoid notifying SME. */
 		if (!test_and_clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status)
 		    && iwm->conf.mode == UMAC_MODE_BSS) {
+			cancel_delayed_work(&iwm->disconnect);
 			cfg80211_roamed(iwm_to_ndev(iwm),
 					complete->bssid,
 					iwm->req_ie, iwm->req_ie_len,
@@ -540,8 +541,10 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 
 		/* Internal roaming state, avoid notifying SME. */
 		if (!test_and_clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status)
-		    && iwm->conf.mode == UMAC_MODE_BSS)
+		    && iwm->conf.mode == UMAC_MODE_BSS) {
+			cancel_delayed_work(&iwm->disconnect);
 			break;
+		}
 
 		iwm_link_off(iwm);
 
@@ -569,11 +572,18 @@ static int iwm_mlme_profile_invalidate(struct iwm_priv *iwm, u8 *buf,
 				       struct iwm_wifi_cmd *cmd)
 {
 	struct iwm_umac_notif_profile_invalidate *invalid;
+	u32 reason;
 
 	invalid = (struct iwm_umac_notif_profile_invalidate *)buf;
+	reason = le32_to_cpu(invalid->reason);
+
+	IWM_DBG_MLME(iwm, INFO, "Profile Invalidated. Reason: %d\n", reason);
 
-	IWM_DBG_MLME(iwm, INFO, "Profile Invalidated. Reason: %d\n",
-		     le32_to_cpu(invalid->reason));
+	if (reason != UMAC_PROFILE_INVALID_REQUEST &&
+	    test_bit(IWM_STATUS_SME_CONNECTING, &iwm->status))
+		cfg80211_connect_result(iwm_to_ndev(iwm), NULL, NULL, 0, NULL,
+					0, WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
 
 	clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status);
 	clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
@@ -589,6 +599,19 @@ static int iwm_mlme_profile_invalidate(struct iwm_priv *iwm, u8 *buf,
 	return 0;
 }
 
+#define IWM_DISCONNECT_INTERVAL	(5 * HZ)
+
+static int iwm_mlme_connection_terminated(struct iwm_priv *iwm, u8 *buf,
+					  unsigned long buf_size,
+					  struct iwm_wifi_cmd *cmd)
+{
+	IWM_DBG_MLME(iwm, DBG, "Connection terminated\n");
+
+	schedule_delayed_work(&iwm->disconnect, IWM_DISCONNECT_INTERVAL);
+
+	return 0;
+}
+
 static int iwm_mlme_scan_complete(struct iwm_priv *iwm, u8 *buf,
 				  unsigned long buf_size,
 				  struct iwm_wifi_cmd *cmd)
@@ -848,8 +871,7 @@ static int iwm_ntf_mlme(struct iwm_priv *iwm, u8 *buf,
 	case WIFI_IF_NTFY_PROFILE_INVALIDATE_COMPLETE:
 		return iwm_mlme_profile_invalidate(iwm, buf, buf_size, cmd);
 	case WIFI_IF_NTFY_CONNECTION_TERMINATED:
-		IWM_DBG_MLME(iwm, DBG, "Connection terminated\n");
-		break;
+		return iwm_mlme_connection_terminated(iwm, buf, buf_size, cmd);
 	case WIFI_IF_NTFY_SCAN_COMPLETE:
 		return iwm_mlme_scan_complete(iwm, buf, buf_size, cmd);
 	case WIFI_IF_NTFY_STA_TABLE_CHANGE:
-- 
1.6.3.3

