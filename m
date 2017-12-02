Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48636 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752605AbdLBQ3Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:25 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:55 +0200
Message-Id: <20171202162858.4167-13-luca@coelho.fi> (sfid-20171202_172928_402173_1BC30F16)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 12/15] iwlwifi: mvm: enable RX offloading with TKIP and WEP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Set the flag that indicates that ICV was stripped on if
this option was enabled in the HW.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c  | 12 +++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 196b90b0451f..84ae1e274d38 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -117,6 +117,7 @@
 #define FH_RSCSR_FRAME_INVALID		0x55550000
 #define FH_RSCSR_FRAME_ALIGN		0x40
 #define FH_RSCSR_RPA_EN			BIT(25)
+#define FH_RSCSR_RADA_EN		BIT(26)
 #define FH_RSCSR_RXQ_POS		16
 #define FH_RSCSR_RXQ_MASK		0x3F0000
 
@@ -128,7 +129,8 @@ struct iwl_rx_packet {
 	 * 31:    flag flush RB request
 	 * 30:    flag ignore TC (terminal counter) request
 	 * 29:    flag fast IRQ request
-	 * 28-26: Reserved
+	 * 28-27: Reserved
+	 * 26:    RADA enabled
 	 * 25:    Offload enabled
 	 * 24:    RPF enabled
 	 * 23:    RSS enabled
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 00d048bd2d35..0e6a7dd30aa9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -232,8 +232,8 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 
 static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			     struct ieee80211_rx_status *stats,
-			     struct iwl_rx_mpdu_desc *desc, int queue,
-			     u8 *crypt_len)
+			     struct iwl_rx_mpdu_desc *desc, u32 pkt_flags,
+			     int queue, u8 *crypt_len)
 {
 	u16 status = le16_to_cpu(desc->status);
 
@@ -270,6 +270,10 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 		if ((status & IWL_RX_MPDU_STATUS_SEC_MASK) ==
 				IWL_RX_MPDU_STATUS_SEC_WEP)
 			*crypt_len = IEEE80211_WEP_IV_LEN;
+
+		if (pkt_flags & FH_RSCSR_RADA_EN)
+			stats->flag |= RX_FLAG_ICV_STRIPPED;
+
 		return 0;
 	case IWL_RX_MPDU_STATUS_SEC_EXT_ENC:
 		if (!(status & IWL_RX_MPDU_STATUS_MIC_OK))
@@ -848,7 +852,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
-	if (iwl_mvm_rx_crypto(mvm, hdr, rx_status, desc, queue, &crypt_len)) {
+	if (iwl_mvm_rx_crypto(mvm, hdr, rx_status, desc,
+			      le32_to_cpu(pkt->len_n_flags), queue,
+			      &crypt_len)) {
 		kfree_skb(skb);
 		return;
 	}
-- 
2.15.0
