Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0KLHnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 02:43:37 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/3] iwlwifi: kill elapsed_jiffies
Date: Fri, 12 Nov 2010 08:47:07 +0100
Message-Id: <1289548027-3383-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
References: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subtract of jiffies is fine even if one variable overwrap.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-scan.c    |    3 +--
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 1aaef70..9233683 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -44,15 +44,6 @@ static inline struct ieee80211_conf *ieee80211_get_hw_conf(
 	return &hw->conf;
 }
 
-static inline unsigned long elapsed_jiffies(unsigned long start,
-					    unsigned long end)
-{
-	if (end >= start)
-		return end - start;
-
-	return end + (MAX_JIFFY_OFFSET - start) + 1;
-}
-
 /**
  * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
  * @index -- current index
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e1aa0e1..12d9363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -252,8 +252,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 
 	IWL_DEBUG_SCAN(priv, "Scan on %sGHz took %dms\n",
 		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
-		       jiffies_to_msecs(elapsed_jiffies
-					(priv->scan_start, jiffies)));
+		       jiffies_to_msecs(jiffies - priv->scan_start));
 
 	queue_work(priv->workqueue, &priv->scan_completed);
 
-- 
1.7.1

