Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZJPFVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:21:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/16] iwmc3200wifi: Try shared auth when open WEP fails
Date: Fri, 16 Oct 2009 13:18:57 +0800
Message-Id: <1255670340-22565-14-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-13-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-12-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

When we fail to associate with an open WEP AP, we fall back to shared auth.
This allows us to support joining a shared auth WEP AP with iwconfig.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    2 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    1 +
 drivers/net/wireless/iwmc3200wifi/main.c     |   28 ++++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/rx.c       |   28 +++++++++++++++++++++----
 4 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 2911ace..7e12438 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -794,7 +794,7 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 		return ret;
 
 	ret = wait_event_interruptible_timeout(iwm->mlme_queue,
-				(iwm->umac_profile_active == 0), 2 * HZ);
+				(iwm->umac_profile_active == 0), 5 * HZ);
 
 	return ret ? 0 : -EBUSY;
 }
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index fe0ab80..c4a01f2 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -285,6 +285,7 @@ struct iwm_priv {
 	u8 *eeprom;
 	struct timer_list watchdog;
 	struct work_struct reset_worker;
+	struct work_struct auth_retry_worker;
 	struct mutex mutex;
 
 	u8 *req_ie;
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index dfc8fd4..97c6f5a 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -208,6 +208,33 @@ static void iwm_reset_worker(struct work_struct *work)
 	mutex_unlock(&iwm->mutex);
 }
 
+static void iwm_auth_retry_worker(struct work_struct *work)
+{
+	struct iwm_priv *iwm;
+	int i, ret;
+
+	iwm = container_of(work, struct iwm_priv, auth_retry_worker);
+	if (iwm->umac_profile_active) {
+		ret = iwm_invalidate_mlme_profile(iwm);
+		if (ret < 0)
+			return;
+	}
+
+	iwm->umac_profile->sec.auth_type = UMAC_AUTH_TYPE_LEGACY_PSK;
+
+	ret = iwm_send_mlme_profile(iwm);
+	if (ret < 0)
+		return;
+
+	for (i = 0; i < IWM_NUM_KEYS; i++)
+		if (iwm->keys[i].key_len)
+			iwm_set_key(iwm, 0, &iwm->keys[i]);
+
+	iwm_set_tx_key(iwm, iwm->default_key);
+}
+
+
+
 static void iwm_watchdog(unsigned long data)
 {
 	struct iwm_priv *iwm = (struct iwm_priv *)data;
@@ -241,6 +268,7 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	INIT_DELAYED_WORK(&iwm->disconnect, iwm_disconnect_work);
 	INIT_DELAYED_WORK(&iwm->ct_kill_delay, iwm_ct_kill_work);
 	INIT_WORK(&iwm->reset_worker, iwm_reset_worker);
+	INIT_WORK(&iwm->auth_retry_worker, iwm_auth_retry_worker);
 	INIT_LIST_HEAD(&iwm->bss_list);
 
 	skb_queue_head_init(&iwm->rx_list);
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 0fa3f5c..c0fa853 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -502,6 +502,18 @@ static int iwm_mlme_assoc_start(struct iwm_priv *iwm, u8 *buf,
 	return 0;
 }
 
+static u8 iwm_is_open_wep_profile(struct iwm_priv *iwm)
+{
+	if ((iwm->umac_profile->sec.ucast_cipher == UMAC_CIPHER_TYPE_WEP_40 ||
+	     iwm->umac_profile->sec.ucast_cipher == UMAC_CIPHER_TYPE_WEP_104) &&
+	    (iwm->umac_profile->sec.ucast_cipher ==
+	     iwm->umac_profile->sec.mcast_cipher) &&
+	    (iwm->umac_profile->sec.auth_type == UMAC_AUTH_TYPE_OPEN))
+	       return 1;
+
+       return 0;
+}
+
 static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 				   unsigned long buf_size,
 				   struct iwm_wifi_cmd *cmd)
@@ -567,11 +579,17 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 			goto ibss;
 
 		if (!test_bit(IWM_STATUS_RESETTING, &iwm->status))
-			cfg80211_connect_result(iwm_to_ndev(iwm),
-						complete->bssid,
-						NULL, 0, NULL, 0,
-						WLAN_STATUS_UNSPECIFIED_FAILURE,
-						GFP_KERNEL);
+			if (!iwm_is_open_wep_profile(iwm)) {
+				cfg80211_connect_result(iwm_to_ndev(iwm),
+					       complete->bssid,
+					       NULL, 0, NULL, 0,
+					       WLAN_STATUS_UNSPECIFIED_FAILURE,
+					       GFP_KERNEL);
+			} else {
+				/* Let's try shared WEP auth */
+				IWM_ERR(iwm, "Trying WEP shared auth\n");
+				schedule_work(&iwm->auth_retry_worker);
+			}
 		else
 			cfg80211_disconnected(iwm_to_ndev(iwm), 0, NULL, 0,
 					      GFP_KERNEL);
-- 
1.6.0.4

