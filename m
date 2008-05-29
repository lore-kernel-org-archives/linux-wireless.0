Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYE2IhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/43] iwlwifi: remove notif_missed_beacons variable
Date: Thu, 29 May 2008 16:34:53 +0800
Message-Id: <1212050128-17132-9-git-send-email-yi.zhu@intel.com> (sfid-20080529_103725_666016_7D5D9E43)
In-Reply-To: <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes notif_missed_beacons from priv since it was never
used. Missed beacons notification will have only meaning if roaming
will be implemented in mac80211.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 --
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 4 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 835c5b4..a9b3eda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -835,8 +835,6 @@ struct iwl3945_priv {
 
 	u8 mac80211_registered;
 
-	u32 notif_missed_beacons;
-
 	/* Rx'd packet timing information */
 	u32 last_beacon_time;
 	u64 last_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1ee8121..342c6a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1125,8 +1125,6 @@ struct iwl_priv {
 
 	u8 mac80211_registered;
 
-	u32 notif_missed_beacons;
-
 	/* Rx'd packet timing information */
 	u32 last_beacon_time;
 	u64 last_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e0f52e2..244bfe5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5847,9 +5847,6 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	/* Configure the adapter for unassociated operation */
 	iwl3945_commit_rxon(priv);
 
-	/* At this point, the NIC is initialized and operational */
-	priv->notif_missed_beacons = 0;
-
 	iwl3945_reg_txpower_periodic(priv);
 
 	iwl3945_led_register(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d7f9321..6785200 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3314,8 +3314,6 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	iwl4965_commit_rxon(priv);
 
 	/* At this point, the NIC is initialized and operational */
-	priv->notif_missed_beacons = 0;
-
 	iwl4965_rf_kill_ct_config(priv);
 
 	iwl_leds_register(priv);
-- 
1.5.3.6

