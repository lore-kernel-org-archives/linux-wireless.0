Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:60597 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752422AbeCaHF7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 03:05:59 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/12] iwlwifi: Remove local iwl_bcast_addr and use ether_broadcast_addr
Date: Sat, 31 Mar 2018 00:05:24 -0700
Message-Id: <af831d8873ffcc36014244f76d21cd6aaf5aca9c.1522479608.git.joe@perches.com> (sfid-20180331_090654_068360_566E1015)
In-Reply-To: <cover.1522479607.git.joe@perches.com>
References: <cover.1522479607.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new global to save a little bit of object code.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h  | 1 -
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c  | 4 +---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index cceb4cd8e501..157cc21c5dfb 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -271,7 +271,6 @@ struct iwl_sensitivity_ranges {
  *
  ****************************************************************************/
 void iwl_update_chain_flags(struct iwl_priv *priv);
-extern const u8 iwl_bcast_addr[ETH_ALEN];
 
 #define IWL_OPERATION_MODE_AUTO     0
 #define IWL_OPERATION_MODE_HT_ONLY  1
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 17e6a32384d3..e40d9b9fc4a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -871,7 +871,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		/* use bcast addr, will not be transmitted but must be valid */
 		cmd_len = iwl_fill_probe_req(
 					(struct ieee80211_mgmt *)scan->data,
-					iwl_bcast_addr, NULL, 0,
+					ether_broadcast_addr, NULL, 0,
 					NULL, 0,
 					scan_cmd_size - sizeof(*scan));
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index de6ec9b7ace4..177a366f7ad3 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -32,8 +32,6 @@
 #include "dev.h"
 #include "agn.h"
 
-const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-
 static int iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
 	lockdep_assert_held(&priv->sta_lock);
@@ -1287,7 +1285,7 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 	u8 sta_id;
 
 	spin_lock_bh(&priv->sta_lock);
-	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
+	sta_id = iwl_prep_station(priv, ctx, ether_broadcast_addr, false, NULL);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare broadcast station\n");
 		spin_unlock_bh(&priv->sta_lock);
-- 
2.15.0
