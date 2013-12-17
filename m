Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52114 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3LQUor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:47 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so3061651eek.5
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:46 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/36] iwlwifi: mvm: don't send SMPS action frame with single RX antenna
Date: Tue, 17 Dec 2013 22:44:04 +0200
Message-Id: <1387313079-28123-1-git-send-email-egrumbach@gmail.com> (sfid-20131217_214450_912448_D70A7E7D)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Products that have only 1 antenna in Rx don't support MIMO
in RX. As a consequence, they will be in STATIC always.
Don't tell mac80211 to update SMPS in that case. mac80211
would send an action frame to the AP which is clearly
bogus.
As a matter of fact, we have seen that some APs send a
deauth when that happens.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 56cf819..f4aff56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -518,6 +518,11 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
+
+	/* SMPS is irrelevant for NICs that don't have at least 2 RX antenna */
+	if (num_of_ant(iwl_fw_valid_rx_ant(mvm->fw)) == 1)
+		return;
+
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	mvmvif->smps_requests[req_type] = smps_request;
 	for (i = 0; i < NUM_IWL_MVM_SMPS_REQ; i++) {
-- 
1.7.9.5

