Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56864 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbbJELk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:40:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>, <stable@vger.kernel.org>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 14:40:42 +0300
Message-Id: <1444045246-9946-4-git-send-email-luca@coelho.fi> (sfid-20151005_134114_695082_6CF3BDBD)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 4/8] iwlwifi: mvm: clear csa countdown when AP is stopped
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

The csa_countdown flag was not cleared when the AP is stopped.
As a result, if the AP was stopped after csa_countdown had started,
all the folowing channel switch commands would fail.
Fix that by clearing the csa_countdown flag when the AP is stopped.

Cc: <stable@vger.kernel.org> [3.17+]
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index aa8c2b7..7c2944a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2388,6 +2388,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
 		RCU_INIT_POINTER(mvm->csa_vif, NULL);
+		mvmvif->csa_countdown = false;
 	}
 
 	if (rcu_access_pointer(mvm->csa_tx_blocked_vif) == vif) {
-- 
2.5.3

