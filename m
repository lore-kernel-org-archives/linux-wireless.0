Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752159AbdHIHHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:07:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  9 Aug 2017 10:07:06 +0300
Message-Id: <20170809070706.14862-3-luca@coelho.fi> (sfid-20170809_090720_656719_8649FC01)
In-Reply-To: <20170809070706.14862-1-luca@coelho.fi>
References: <20170809070706.14862-1-luca@coelho.fi>
Subject: [PATCH 2/2] iwlwifi: mvm: send delba upon rx ba session timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

When an RX block-ack session times out, the firmware, which offloads
RX reordering but not the BA session negotiation, stops the session
but doesn't send a DELBA.  This causes the the session to remain
active in the remote device, so no more BA sessions will be
established, causing a severe throughput degradation due to the lack
of aggregation.

Use the new ieee80211_rx_ba_timer_expired API when the ba session timer
expires, since this will tear down the ba session and also send a delba.

The previous API used is intended for drivers that offload the
addba/delba negotiation, but not the rx reordering, while our driver
does the opposite.

This patch depends on "mac80211: add api to start ba session timer
expired flow".

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index dcaef7c043ac..027ee5e72172 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -291,8 +291,8 @@ static void iwl_mvm_rx_agg_session_expired(unsigned long data)
 		goto unlock;
 
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
-	ieee80211_stop_rx_ba_session_offl(mvm_sta->vif,
-					  sta->addr, ba_data->tid);
+	ieee80211_rx_ba_timer_expired(mvm_sta->vif,
+				      sta->addr, ba_data->tid);
 unlock:
 	rcu_read_unlock();
 }
-- 
2.13.2
