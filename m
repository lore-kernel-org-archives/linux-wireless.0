Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab0DPVwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/21] iwlwifi: remove next_scan_jiffies
Date: Fri, 16 Apr 2010 14:52:21 -0700
Message-Id: <1271454758-14351-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This logic is just confusing, if anything it
belongs into mac80211. Also, even if we do
scan during the EAPOL handshake, that will
not cause any problems, just a short delay.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   20 --------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 -----
 4 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 73f5fc6..9d300b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1867,7 +1867,6 @@ static inline void iwl_set_no_assoc(struct iwl_priv *priv)
 	iwlcore_commit_rxon(priv);
 }
 
-#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf,
@@ -1988,14 +1987,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 			iwl_led_associate(priv);
 
-			/*
-			 * We have just associated, don't start scan too early
-			 * leave time for EAPOL exchange to complete.
-			 *
-			 * XXX: do this in mac80211
-			 */
-			priv->next_scan_jiffies = jiffies +
-					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
 			if (!iwl_is_rfkill(priv))
 				priv->cfg->ops->lib->post_associate(priv);
 		} else
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ee4cb02..f2d4ca5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1049,7 +1049,6 @@ struct iwl_priv {
 	struct iwl_calib_result calib_results[IWL_CALIB_MAX];
 
 	/* Scan related variables */
-	unsigned long next_scan_jiffies;
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 7982b19..e45b49a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -199,9 +199,6 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->statistics[0]),
 		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf);
 #endif
-
-	if (!priv->is_internal_short_scan)
-		priv->next_scan_jiffies = 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
@@ -234,9 +231,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	if (test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status))
 		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
 
-	if (!priv->is_internal_short_scan)
-		priv->next_scan_jiffies = 0;
-
 	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
@@ -462,8 +456,6 @@ static int iwl_scan_initiate(struct iwl_priv *priv)
 	return 0;
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
-
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		     struct cfg80211_scan_request *req)
 {
@@ -497,18 +489,6 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	/* We don't schedule scan within next_scan_jiffies period.
-	 * Avoid scanning during possible EAPOL exchange, return
-	 * success immediately.
-	 */
-	if (priv->next_scan_jiffies &&
-	    time_after(priv->next_scan_jiffies, jiffies)) {
-		IWL_DEBUG_SCAN(priv, "scan rejected: within next scan period\n");
-		queue_work(priv->workqueue, &priv->scan_completed);
-		ret = 0;
-		goto out_unlock;
-	}
-
 	/* mac80211 will only ask for one band at a time */
 	priv->scan_band = req->channels[0]->band;
 	priv->scan_request = req;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e266695..af32359 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3048,8 +3048,6 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
-
 void iwl3945_post_associate(struct iwl_priv *priv)
 {
 	int rc = 0;
@@ -3134,9 +3132,6 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 			   __func__, priv->iw_mode);
 		break;
 	}
-
-	/* we have just associated, don't start scan too early */
-	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
 
 /*****************************************************************************
-- 
1.6.3.3

