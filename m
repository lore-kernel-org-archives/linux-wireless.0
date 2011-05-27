Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab1E0QID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlagn: change log to better represent the state of aggregation process
Date: Fri, 27 May 2011 08:40:32 -0700
Message-Id: <1306510833-32049-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180815_182893_74D663C2)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple A-MPDU actions will received from mac80211 while setting up the
aggregation queue, change the message log to better represent the states.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 631d0a5..e459e62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1028,8 +1028,8 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;
 
-	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
-			__func__, sta->addr, tid);
+	IWL_DEBUG_HT(priv, "TX AGG request on ra = %pM tid = %d\n",
+		     sta->addr, tid);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1631c44..42a71e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2844,6 +2844,9 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 		iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
 				&sta_priv->lq_sta.lq, CMD_ASYNC, false);
+
+		IWL_INFO(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
+			 sta->addr, tid);
 		ret = 0;
 		break;
 	}
-- 
1.7.0.4

