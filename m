Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0DPVwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/21] iwlwifi: remove scan_pass_start
Date: Fri, 16 Apr 2010 14:52:22 -0700
Message-Id: <1271454758-14351-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we no longer do a multi-pass scan,
keeping track of how long each pass took
is pointless since there will only be one.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c |    8 ++------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f2d4ca5..a7ffb4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1050,7 +1050,6 @@ struct iwl_priv {
 
 	/* Scan related variables */
 	unsigned long scan_start;
-	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
 	void *scan;
 	enum ieee80211_band scan_band;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e45b49a..cb3601d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -218,10 +218,10 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 
-	IWL_DEBUG_INFO(priv, "Scan pass on %sGHz took %dms\n",
+	IWL_DEBUG_INFO(priv, "Scan on %sGHz took %dms\n",
 		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
-					(priv->scan_pass_start, jiffies)));
+					(priv->scan_start, jiffies)));
 
 	/*
 	 * If a request to abort was given, or the scan did not succeed
@@ -235,9 +235,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 
 	clear_bit(STATUS_SCANNING, &priv->status);
 
-	IWL_DEBUG_INFO(priv, "Scan took %dms\n",
-		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
-
 	queue_work(priv->workqueue, &priv->scan_completed);
 }
 
@@ -449,7 +446,6 @@ static int iwl_scan_initiate(struct iwl_priv *priv)
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->is_internal_short_scan = false;
 	priv->scan_start = jiffies;
-	priv->scan_pass_start = priv->scan_start;
 
 	queue_work(priv->workqueue, &priv->request_scan);
 
-- 
1.6.3.3

