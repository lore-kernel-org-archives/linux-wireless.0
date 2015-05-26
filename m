Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbEZTTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/39] iwlwifi: nvm: fix otp parsing in 8000 hw family
Date: Tue, 26 May 2015 22:17:45 +0300
Message-Id: <1432667872-18092-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211908_343250_8AA77C00)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

The radio cfg DWORD was taken from the wrong place in the
8000 HW family, after a line in the code was wrongly changed
by mistake. This broke several 8260 devices.

CC: <stable@vger.kernel.org> [4.1]
Fixes: 5dd9c68a854a ("iwlwifi: drop support for early versions of 8000")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 75e96db..8e604a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -471,7 +471,7 @@ static int iwl_get_radio_cfg(const struct iwl_cfg *cfg, const __le16 *nvm_sw,
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + RADIO_CFG);
 
-	return le32_to_cpup((__le32 *)(nvm_sw + RADIO_CFG_FAMILY_8000));
+	return le32_to_cpup((__le32 *)(phy_sku + RADIO_CFG_FAMILY_8000));
 
 }
 
-- 
2.1.4

