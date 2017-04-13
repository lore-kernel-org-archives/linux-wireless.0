Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51308 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754623AbdDMPZe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:44 +0300
Message-Id: <20170413152507.9648-4-luca@coelho.fi> (sfid-20170413_172548_698114_C35D5E18)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 03/26] iwlwifi: cleanup unused function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

iwl_has_secure_boot() isn't getting called anywhere. Clean it up.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 717e089ff036..06034a71a190 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -90,16 +90,6 @@ enum iwl_device_family {
 	IWL_DEVICE_FAMILY_8000,
 };
 
-static inline bool iwl_has_secure_boot(u32 hw_rev,
-				       enum iwl_device_family family)
-{
-	/* return 1 only for family 8000 B0 */
-	if ((family == IWL_DEVICE_FAMILY_8000) && (hw_rev & 0xC))
-		return true;
-
-	return false;
-}
-
 /*
  * LED mode
  *    IWL_LED_DEFAULT:  use device default
-- 
2.11.0
