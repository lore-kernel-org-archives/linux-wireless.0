Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42412 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752585AbdHESrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 14:47:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 21:47:41 +0300
Message-Id: <20170805184743.23650-2-luca@coelho.fi> (sfid-20170805_205039_440725_9536D435)
In-Reply-To: <20170805184743.23650-1-luca@coelho.fi>
References: <20170805184743.23650-1-luca@coelho.fi>
Subject: [PATCH 1/3] iwlwifi: mvm: Fix a memory leak in an error handling path in 'iwl_mvm_sar_get_wgds_table()'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

We should free 'wgds.pointer' here as done a few lines above in another
error handling path.
It was allocated within 'acpi_evaluate_object()'.

Fixes: c52030a01ccc ("iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 79e7a7a285dc..82863e9273eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1275,8 +1275,10 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
 
 			entry = &wifi_pkg->package.elements[idx++];
 			if ((entry->type != ACPI_TYPE_INTEGER) ||
-			    (entry->integer.value > U8_MAX))
-				return -EINVAL;
+			    (entry->integer.value > U8_MAX)) {
+				ret = -EINVAL;
+				goto out_free;
+			}
 
 			mvm->geo_profiles[i].values[j] = entry->integer.value;
 		}
-- 
2.13.2
