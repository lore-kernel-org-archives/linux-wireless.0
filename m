Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab0HWOxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/26] iwlwifi: reset BT when going down
Date: Mon, 23 Aug 2010 07:56:59 -0700
Message-Id: <1282575437-23270-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we turn off the device, reset BT
data so that we don't have outdated
information when we come up again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3ced9ea..d4d08aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2768,6 +2768,10 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_dealloc_bcast_station(priv);
 	iwl_clear_driver_stations(priv);
 
+	/* reset BT coex data */
+	priv->bt_traffic_load = 0;
+	priv->bt_sco_active = false;
+
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
@@ -3073,8 +3077,9 @@ static void iwl_bg_restart(struct work_struct *data)
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
 		priv->is_open = 0;
+		__iwl_down(priv);
 		mutex_unlock(&priv->mutex);
-		iwl_down(priv);
+		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
 		iwl_down(priv);
-- 
1.7.0.4

