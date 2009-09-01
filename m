Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbZIANM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:59 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 8/9] iwmc3200wifi: Handle UMAC stalls and UMAC assert properly
Date: Tue,  1 Sep 2009 15:14:05 +0200
Message-Id: <c49af0d7f3b96643dbb7a2da52ede622f66220b5.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <e8d5aebbcfa2f5d4430bbee3850bd11e34808088.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
 <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
 <b08ebbaa73e4796a6be51889860bc1bd67867a90.1251809163.git.sameo@linux.intel.com>
 <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
 <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
 <cf887cbfdcddc6c3874e08978b8926f82862d345.1251809163.git.sameo@linux.intel.com>
 <0b1215c4ea3f375a932030fe94fd97e47df4b4eb.1251809163.git.sameo@linux.intel.com>
 <e8d5aebbcfa2f5d4430bbee3850bd11e34808088.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When UMAC stalls or asserts, we want to reset the device. But when we're
associated, the current reset worker will end up calling
cfg80211_connect_result() with the cfg80211 sme layer knowing that we're
reassociating. That ends up with some ugly warnings.
With this patch we're telling the upper layer that we've roamed if
reassociation succeeds, and that we're disconnected if it fails.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    2 ++
 drivers/net/wireless/iwmc3200wifi/main.c |   18 +++++++++++++++---
 drivers/net/wireless/iwmc3200wifi/rx.c   |   29 +++++++++++++++++++++++------
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 74964ee..f5c2d6f 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -178,6 +178,7 @@ struct iwm_key {
 #define IWM_STATUS_SCAN_ABORTING	2
 #define IWM_STATUS_SME_CONNECTING	3
 #define IWM_STATUS_ASSOCIATED		4
+#define IWM_STATUS_RESETTING		5
 
 struct iwm_tx_queue {
 	int id;
@@ -317,6 +318,7 @@ int iwm_mode_to_nl80211_iftype(int mode);
 int iwm_priv_init(struct iwm_priv *iwm);
 void iwm_priv_deinit(struct iwm_priv *iwm);
 void iwm_reset(struct iwm_priv *iwm);
+void iwm_resetting(struct iwm_priv *iwm);
 void iwm_tx_credit_init_pools(struct iwm_priv *iwm,
 			      struct iwm_umac_notif_alive *alive);
 int iwm_tx_credit_alloc(struct iwm_priv *iwm, int id, int nb);
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index fc7fce4..6a5b76a 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -187,7 +187,8 @@ static void iwm_reset_worker(struct work_struct *work)
 		memcpy(iwm->umac_profile, profile, sizeof(*profile));
 		iwm_send_mlme_profile(iwm);
 		kfree(profile);
-	}
+	} else
+		clear_bit(IWM_STATUS_RESETTING, &iwm->status);
 
  out:
 	mutex_unlock(&iwm->mutex);
@@ -200,7 +201,7 @@ static void iwm_watchdog(unsigned long data)
 	IWM_WARN(iwm, "Watchdog expired: UMAC stalls!\n");
 
 	if (modparam_reset)
-		schedule_work(&iwm->reset_worker);
+		iwm_resetting(iwm);
 }
 
 int iwm_priv_init(struct iwm_priv *iwm)
@@ -284,7 +285,11 @@ void iwm_reset(struct iwm_priv *iwm)
 	if (test_bit(IWM_STATUS_READY, &iwm->status))
 		iwm_target_reset(iwm);
 
-	iwm->status = 0;
+	if (test_bit(IWM_STATUS_RESETTING, &iwm->status)) {
+		iwm->status = 0;
+		set_bit(IWM_STATUS_RESETTING, &iwm->status);
+	} else
+		iwm->status = 0;
 	iwm->scan_id = 1;
 
 	list_for_each_entry_safe(notif, next, &iwm->pending_notif, pending) {
@@ -300,6 +305,13 @@ void iwm_reset(struct iwm_priv *iwm)
 	iwm_link_off(iwm);
 }
 
+void iwm_resetting(struct iwm_priv *iwm)
+{
+	set_bit(IWM_STATUS_RESETTING, &iwm->status);
+
+	schedule_work(&iwm->reset_worker);
+}
+
 /*
  * Notification code:
  *
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 2daa586..14950b1 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -118,6 +118,8 @@ static int iwm_ntf_error(struct iwm_priv *iwm, u8 *buf,
 	IWM_ERR(iwm, "\tLMAC status: 0x%x\n", le32_to_cpu(fw_err->lmac_status));
 	IWM_ERR(iwm, "\tSDIO status: 0x%x\n", le32_to_cpu(fw_err->sdio_status));
 
+	iwm_resetting(iwm);
+
 	return 0;
 }
 
@@ -528,11 +530,19 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 		if (iwm->conf.mode == UMAC_MODE_IBSS)
 			goto ibss;
 
-		cfg80211_connect_result(iwm_to_ndev(iwm),
+		if (!test_bit(IWM_STATUS_RESETTING, &iwm->status))
+			cfg80211_connect_result(iwm_to_ndev(iwm),
+						complete->bssid,
+						iwm->req_ie, iwm->req_ie_len,
+						iwm->resp_ie, iwm->resp_ie_len,
+						WLAN_STATUS_SUCCESS,
+						GFP_KERNEL);
+		else
+			cfg80211_roamed(iwm_to_ndev(iwm),
 					complete->bssid,
 					iwm->req_ie, iwm->req_ie_len,
 					iwm->resp_ie, iwm->resp_ie_len,
-					WLAN_STATUS_SUCCESS, GFP_KERNEL);
+					GFP_KERNEL);
 		break;
 	case UMAC_ASSOC_COMPLETE_FAILURE:
 		clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
@@ -551,19 +561,26 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 		if (iwm->conf.mode == UMAC_MODE_IBSS)
 			goto ibss;
 
-		cfg80211_connect_result(iwm_to_ndev(iwm), complete->bssid,
-					NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
+		if (!test_bit(IWM_STATUS_RESETTING, &iwm->status))
+			cfg80211_connect_result(iwm_to_ndev(iwm),
+						complete->bssid,
+						NULL, 0, NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_KERNEL);
+		else
+			cfg80211_disconnected(iwm_to_ndev(iwm), 0, NULL, 0,
+					      GFP_KERNEL);
 		break;
 	default:
 		break;
 	}
 
+	clear_bit(IWM_STATUS_RESETTING, &iwm->status);
 	return 0;
 
  ibss:
 	cfg80211_ibss_joined(iwm_to_ndev(iwm), iwm->bssid, GFP_KERNEL);
+	clear_bit(IWM_STATUS_RESETTING, &iwm->status);
 	return 0;
 }
 
-- 
1.6.3.3

