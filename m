Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51814 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751295AbdLWJWJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 04:22:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 23 Dec 2017 11:21:57 +0200
Message-Id: <20171223092200.30270-3-luca@coelho.fi> (sfid-20171223_102219_359001_7252F4C5)
In-Reply-To: <20171223092200.30270-1-luca@coelho.fi>
References: <20171223092200.30270-1-luca@coelho.fi>
Subject: [PATCH 2/5] iwlwifi: mvm: take RCU lock before dereferencing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

RCU isn't properly locked.

Fixes: 46d372af9935 ("iwlwifi: mvm: rs: new rate scale API - add FW notifications")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 55d1274c6092..fb5745660509 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -234,13 +234,15 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 	struct iwl_mvm_sta *mvmsta;
 	struct iwl_lq_sta_rs_fw *lq_sta;
 
+	rcu_read_lock();
+
 	notif = (void *)pkt->data;
 	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, notif->sta_id);
 
 	if (!mvmsta) {
 		IWL_ERR(mvm, "Invalid sta id (%d) in FW TLC notification\n",
 			notif->sta_id);
-		return;
+		goto out;
 	}
 
 	lq_sta = &mvmsta->lq_sta.rs_fw;
@@ -251,6 +253,8 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 		IWL_DEBUG_RATE(mvm, "new rate_n_flags: 0x%X\n",
 			       lq_sta->last_rate_n_flags);
 	}
+out:
+	rcu_read_unlock();
 }
 
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-- 
2.15.1
