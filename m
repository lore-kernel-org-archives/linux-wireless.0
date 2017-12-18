Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50992 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759296AbdLRMi0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:26 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:09 +0200
Message-Id: <20171218123815.3968-6-luca@coelho.fi> (sfid-20171218_133831_774041_BBC9BA06)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 05/11] iwlwifi: mvm: support RX flags API change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Latest firmware calculates both phases of the TKIP
field, so the TTAK ok flag is not needed and deprecated.

Support this API change.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 0824c007b6f8..12f97a2fc7ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -248,6 +248,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_NEW_RX_STATS: should new RX STATISTICS API be used
  * @IWL_UCODE_TLV_API_QUOTA_LOW_LATENCY: Quota command includes a field
  *	indicating low latency direction.
+ * @IWL_UCODE_TLV_API_DEPRECATE_TTAK: RX status flag TTAK ok (bit 7) is
+ *	deprecated.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -266,6 +268,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_NEW_BEACON_TEMPLATE	= (__force iwl_ucode_tlv_api_t)34,
 	IWL_UCODE_TLV_API_NEW_RX_STATS		= (__force iwl_ucode_tlv_api_t)35,
 	IWL_UCODE_TLV_API_QUOTA_LOW_LATENCY	= (__force iwl_ucode_tlv_api_t)38,
+	IWL_UCODE_TLV_API_DEPRECATE_TTAK	= (__force iwl_ucode_tlv_api_t)41,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 63a57f0a16ef..d26833c5ce1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -222,7 +222,9 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 
 	case RX_MPDU_RES_STATUS_SEC_TKIP_ENC:
 		/* Don't drop the frame and decrypt it in SW */
-		if (!(rx_pkt_status & RX_MPDU_RES_STATUS_TTAK_OK))
+		if (!fw_has_api(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_API_DEPRECATE_TTAK) &&
+		    !(rx_pkt_status & RX_MPDU_RES_STATUS_TTAK_OK))
 			return 0;
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
 		/* fall through if TTAK OK */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 00d048bd2d35..858465838355 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -257,7 +257,9 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 		return 0;
 	case IWL_RX_MPDU_STATUS_SEC_TKIP:
 		/* Don't drop the frame and decrypt it in SW */
-		if (!(status & IWL_RX_MPDU_RES_STATUS_TTAK_OK))
+		if (!fw_has_api(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_API_DEPRECATE_TTAK) &&
+		    !(status & IWL_RX_MPDU_RES_STATUS_TTAK_OK))
 			return 0;
 
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
-- 
2.15.1
