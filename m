Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab1BFRz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 12:55:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlwifi: remove unnecessary locking
Date: Sun,  6 Feb 2011 09:42:52 -0800
Message-Id: <1297014173-28964-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1297014173-28964-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1297014173-28964-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code, and the places that set the variable
is_internal_short_scan and the vif pointers are
all protected by the mutex, there's no point in
locking the spinlock here as well (any more).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 ---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index d4ba335..3aa4864 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1395,15 +1395,12 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		u32 extra;
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
-		unsigned long flags;
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
-		spin_lock_irqsave(&priv->lock, flags);
 		if (priv->is_internal_short_scan)
 			interval = 0;
 		else
 			interval = vif->bss_conf.beacon_int;
-		spin_unlock_irqrestore(&priv->lock, flags);
 
 		scan->suspend_time = 0;
 		scan->max_out_time = cpu_to_le32(200 * 1024);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 76fae81..adcef73 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2860,16 +2860,13 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		u32 extra;
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
-		unsigned long flags;
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 
-		spin_lock_irqsave(&priv->lock, flags);
 		if (priv->is_internal_short_scan)
 			interval = 0;
 		else
 			interval = vif->bss_conf.beacon_int;
-		spin_unlock_irqrestore(&priv->lock, flags);
 
 		scan->suspend_time = 0;
 		scan->max_out_time = cpu_to_le32(200 * 1024);
-- 
1.7.0.4

