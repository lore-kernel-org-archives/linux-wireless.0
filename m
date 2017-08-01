Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41506 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751368AbdHAJkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:33 +0300
Message-Id: <20170801094039.22349-3-luca@coelho.fi> (sfid-20170801_114059_329348_1045C357)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 2/8] iwlwifi: add TLV for MLME offload firmware capability
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware now adds a new DWORD for the MLME offload's
capability even on firmware versions that don't support
it.
Add the TLV bit to avoid getting the print:
capa flags index 3 larger than supported by driver.

This fixes the bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=196195

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 0fa8c473f1e2..c73a6438ce8f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -328,6 +328,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_TX_POWER_ACK: reduced TX power API has larger
  *	command size (command version 4) that supports toggling ACK TX
  *	power reduction.
+ * @IWL_UCODE_TLV_CAPA_MLME_OFFLOAD: supports MLME offload
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -373,6 +374,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG	= (__force iwl_ucode_tlv_capa_t)80,
 	IWL_UCODE_TLV_CAPA_LQM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)81,
 	IWL_UCODE_TLV_CAPA_TX_POWER_ACK			= (__force iwl_ucode_tlv_capa_t)84,
+	IWL_UCODE_TLV_CAPA_MLME_OFFLOAD			= (__force iwl_ucode_tlv_capa_t)96,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
-- 
2.13.2
