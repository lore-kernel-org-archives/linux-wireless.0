Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42474 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751401AbdHETnj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:43:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:15 +0300
Message-Id: <20170805194331.17426-4-luca@coelho.fi> (sfid-20170805_214355_354135_CF7B2BE0)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 03/19] iwlwifi: mvm: add const to thermal_cooling_device_ops structure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bhumika Goyal <bhumirks@gmail.com>

Declare thermal_cooling_device_ops structure as const as it is only passed
as an argument to the function thermal_cooling_device_register and this
argument is of type const. So, declare the structure as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index a638bd69a1f9..3f143402cf7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -813,7 +813,7 @@ static int iwl_mvm_tcool_set_cur_state(struct thermal_cooling_device *cdev,
 	return ret;
 }
 
-static struct thermal_cooling_device_ops tcooling_ops = {
+static const struct thermal_cooling_device_ops tcooling_ops = {
 	.get_max_state = iwl_mvm_tcool_get_max_state,
 	.get_cur_state = iwl_mvm_tcool_get_cur_state,
 	.set_cur_state = iwl_mvm_tcool_set_cur_state,
-- 
2.13.2
