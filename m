Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33604 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbcGFKqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: striebit <shaul.triebitz@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:24 +0300
Message-Id: <1467801651-1816-29-git-send-email-luca@coelho.fi> (sfid-20160706_125023_120417_6805AB75)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 29/56] iwlmvm: mvm: set correct state in smart-fifo configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: striebit <shaul.triebitz@intel.com>

Currently the state sent in SF configuration is always
FULL_ON.
This commit sets the correct state (e.g. INIT_OFF
when station is not associated).

Fixes: commit f4a3ee493e69 ("iwlwifi: mvm: Always enable the smart FIFO")
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
index 443a428..101fb04 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
@@ -215,7 +215,7 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 			     enum iwl_sf_state new_state)
 {
 	struct iwl_sf_cfg_cmd sf_cmd = {
-		.state = cpu_to_le32(SF_FULL_ON),
+		.state = cpu_to_le32(new_state),
 	};
 	struct ieee80211_sta *sta;
 	int ret = 0;
-- 
2.8.1

