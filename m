Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60728 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751149AbdFBL0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:34 +0300
Message-Id: <20170602112553.2466-7-luca@coelho.fi> (sfid-20170602_132637_595694_0F8FC0F8)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: use proper sta_addr in firmware API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point to declare an address as a __le32/__le16
and then only take a pointer to it anyway, change that to
just a sta_addr[ETH_ALEN].

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 6 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 81b98915b1a4..c03fbb81efd1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -594,8 +594,7 @@ struct iwl_mvm_tx_resp {
 /**
  * struct iwl_mvm_ba_notif - notifies about reception of BA
  * ( BA_NOTIF = 0xc5 )
- * @sta_addr_lo32: lower 32 bits of the MAC address
- * @sta_addr_hi16: upper 16 bits of the MAC address
+ * @sta_addr: MAC address
  * @sta_id: Index of recipient (BA-sending) station in fw's station table
  * @tid: tid of the session
  * @seq_ctl:
@@ -609,8 +608,7 @@ struct iwl_mvm_tx_resp {
  *	for Tx-ing then this value will be set to 0 by FW.
  */
 struct iwl_mvm_ba_notif {
-	__le32 sta_addr_lo32;
-	__le16 sta_addr_hi16;
+	u8 sta_addr[ETH_ALEN];
 	__le16 reserved;
 
 	u8 sta_id;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index aa76c8baecce..64ca8b92f8d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1850,7 +1850,7 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 
 	IWL_DEBUG_TX_REPLY(mvm,
 			   "BA_NOTIFICATION Received from %pM, sta_id = %d\n",
-			   (u8 *)&ba_notif->sta_addr_lo32, ba_notif->sta_id);
+			   ba_notif->sta_addr, ba_notif->sta_id);
 
 	IWL_DEBUG_TX_REPLY(mvm,
 			   "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = %d, scd_ssn = %d sent:%d, acked:%d\n",
-- 
2.11.0
