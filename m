Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab0AVWXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/17] iwlwifi: Logic to control how frequent radio should be reset if needed
Date: Fri, 22 Jan 2010 14:22:45 -0800
Message-Id: <1264198978-5915-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add additional logic for internal scan routine to control how
frequent this function should be performed.

The intent of this function is to reset/re-tune the radio and bring the
RF/PHY back to normal state, it does not make sense calling it too
frequent,
if reset the radio can not bring it back to normal state, it indicate
there are other reason to cause the radio not operate correctly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 42cf181..86d38ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1076,6 +1076,7 @@ struct iwl_priv {
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
+	unsigned long last_internal_scan_jiffies;
 	void *scan;
 	int scan_bands;
 	struct cfg80211_scan_request *scan_request;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 07fabbb..08faafa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -201,7 +201,8 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf);
 #endif
 
-	priv->next_scan_jiffies = 0;
+	if (!priv->is_internal_short_scan)
+		priv->next_scan_jiffies = 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
@@ -247,7 +248,11 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 			goto reschedule;
 	}
 
-	priv->next_scan_jiffies = 0;
+	if (!priv->is_internal_short_scan)
+		priv->next_scan_jiffies = 0;
+	else
+		priv->last_internal_scan_jiffies = jiffies;
+
 	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
@@ -546,6 +551,8 @@ EXPORT_SYMBOL(iwl_mac_hw_scan);
  * internal short scan, this function should only been called while associated.
  * It will reset and tune the radio to prevent possible RF related problem
  */
+#define IWL_DELAY_NEXT_INTERNAL_SCAN (HZ*1)
+
 int iwl_internal_short_hw_scan(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -565,6 +572,13 @@ int iwl_internal_short_hw_scan(struct iwl_priv *priv)
 		ret = -EAGAIN;
 		goto out;
 	}
+	if (priv->last_internal_scan_jiffies &&
+	    time_after(priv->last_internal_scan_jiffies +
+		       IWL_DELAY_NEXT_INTERNAL_SCAN, jiffies)) {
+		IWL_DEBUG_SCAN(priv, "internal scan rejected\n");
+		goto out;
+	}
+
 	priv->scan_bands = 0;
 	if (priv->band == IEEE80211_BAND_5GHZ)
 		priv->scan_bands |= BIT(IEEE80211_BAND_5GHZ);
-- 
1.6.3.3

