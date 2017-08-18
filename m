Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44610 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751646AbdHRPwd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:13 +0300
Message-Id: <20170818154922.2904-16-luca@coelho.fi> (sfid-20170818_175236_005606_B0FC06D0)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 15/24] iwlwifi: mvm: Fix channel switch in case of count <= 1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The code did not consider the case that the channel switch counter
is <= 1, which would result with an inaccurate calculation of the
time event apply time.

As the specification states that in case of counter == 0 the switch
occurs at any time after the reception the frame, and for counter == 1
the switch would happens before the next TBTT, schedule the time
event immediately.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 01143c491e53..cfabe302c9c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3875,11 +3875,16 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		/* Schedule the time event to a bit before beacon 1,
 		 * to make sure we're in the new channel when the
-		 * GO/AP arrives.
+		 * GO/AP arrives. In case count <= 1 immediately schedule the
+		 * TE (this might result with some packet loss or connection
+		 * loss).
 		 */
-		apply_time = chsw->device_timestamp +
-			((vif->bss_conf.beacon_int * (chsw->count - 1) -
-			  IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT) * 1024);
+		if (chsw->count <= 1)
+			apply_time = 0;
+		else
+			apply_time = chsw->device_timestamp +
+				((vif->bss_conf.beacon_int * (chsw->count - 1) -
+				  IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT) * 1024);
 
 		if (chsw->block_tx)
 			iwl_mvm_csa_client_absent(mvm, vif);
-- 
2.14.1
