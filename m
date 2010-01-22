Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0AVWXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Henry Zhangh <hongx.c.zhang@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/17] iwlwifi: Fix A band scanning when associated
Date: Fri, 22 Jan 2010 14:22:44 -0800
Message-Id: <1264198978-5915-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Zhangh <hongx.c.zhang@intel.com>

This patch allows A band to be scanned when driver is associated to AP.
Scan mechanism is that mac80211/cfg80211 requests driver to scan G band
first and then immediately to scan A band. Original code require
driver to wait for 2 seconds after any scan before another scan will be
performed. This caused driver to service G band scan request from
mac80211/cfg80211 but deny the A band scan request.

Signed-off-by: Henry Zhangh <hongx.c.zhang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c |   17 ++---------------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 502d7a6..42cf181 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1072,7 +1072,6 @@ struct iwl_priv {
 	struct iwl_calib_result calib_results[IWL_CALIB_MAX];
 
 	/* Scan related variables */
-	unsigned long last_scan_jiffies;
 	unsigned long next_scan_jiffies;
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index fd6bafb..07fabbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -192,18 +192,15 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 	IWL_DEBUG_SCAN(priv, "Scan ch.res: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d "
-		       "elapsed=%lu usec (%dms since last)\n",
+		       "elapsed=%lu usec\n",
 		       notif->channel,
 		       notif->band ? "bg" : "a",
 		       le32_to_cpu(notif->tsf_high),
 		       le32_to_cpu(notif->tsf_low),
 		       le32_to_cpu(notif->statistics[0]),
-		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf,
-		       jiffies_to_msecs(elapsed_jiffies
-					(priv->last_scan_jiffies, jiffies)));
+		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf);
 #endif
 
-	priv->last_scan_jiffies = jiffies;
 	priv->next_scan_jiffies = 0;
 }
 
@@ -250,7 +247,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 			goto reschedule;
 	}
 
-	priv->last_scan_jiffies = jiffies;
 	priv->next_scan_jiffies = 0;
 	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
 
@@ -528,15 +524,6 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	/* if we just finished scan ask for delay */
-	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
-	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
-		IWL_DEBUG_SCAN(priv, "scan rejected: within previous scan period\n");
-		queue_work(priv->workqueue, &priv->scan_completed);
-		ret = 0;
-		goto out_unlock;
-	}
-
 	priv->scan_bands = 0;
 	for (i = 0; i < req->n_channels; i++)
 		priv->scan_bands |= BIT(req->channels[i]->band);
-- 
1.6.3.3

