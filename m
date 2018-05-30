Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46908 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752842AbeE3HUO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:19:57 +0300
Message-Id: <20180530072005.633-3-luca@coelho.fi> (sfid-20180530_092023_695094_A605E6E8)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 02/10] iwlwifi: mvm: drop UNKNOWN security type frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In some cases we may get from FW errored frames with
UNKNOWN security type.

This may happen in unsecured aggregation flow, where
the first packet had a CRC error in the WEP bit, which
was followed by a failure to decrypt and was dropped.

The next frames in the aggregation "inherit" the bad metadata
of the first packet.

Make sure to drop such frames since RADA and other offloads
will not operate correctly which may have unexpected results.

In case of AP it also causes to TX AMSDU frames to the peers,
resulting with assert 0x104B.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 20 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index e7565f37ece9..7e570c4a9df0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -295,6 +295,7 @@ enum iwl_rx_mpdu_status {
 	IWL_RX_MPDU_STATUS_MIC_OK		= BIT(6),
 	IWL_RX_MPDU_RES_STATUS_TTAK_OK		= BIT(7),
 	IWL_RX_MPDU_STATUS_SEC_MASK		= 0x7 << 8,
+	IWL_RX_MPDU_STATUS_SEC_UNKNOWN		= IWL_RX_MPDU_STATUS_SEC_MASK,
 	IWL_RX_MPDU_STATUS_SEC_NONE		= 0x0 << 8,
 	IWL_RX_MPDU_STATUS_SEC_WEP		= 0x1 << 8,
 	IWL_RX_MPDU_STATUS_SEC_CCM		= 0x2 << 8,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index bb63e75a9b7f..2b1f0dc73c25 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -227,12 +227,24 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 }
 
 static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
-			     struct ieee80211_rx_status *stats,
-			     struct iwl_rx_mpdu_desc *desc, u32 pkt_flags,
-			     int queue, u8 *crypt_len)
+			     struct ieee80211_rx_status *stats, u16 phy_info,
+			     struct iwl_rx_mpdu_desc *desc,
+			     u32 pkt_flags, int queue, u8 *crypt_len)
 {
 	u16 status = le16_to_cpu(desc->status);
 
+	/*
+	 * Drop UNKNOWN frames in aggregation, unless in monitor mode
+	 * (where we don't have the keys).
+	 * We limit this to aggregation because in TKIP this is a valid
+	 * scenario, since we may not have the (correct) TTAK (phase 1
+	 * key) in the firmware.
+	 */
+	if (phy_info & IWL_RX_MPDU_PHY_AMPDU &&
+	    (status & IWL_RX_MPDU_STATUS_SEC_MASK) ==
+	    IWL_RX_MPDU_STATUS_SEC_UNKNOWN && !mvm->monitor_on)
+		return -1;
+
 	if (!ieee80211_has_protected(hdr->frame_control) ||
 	    (status & IWL_RX_MPDU_STATUS_SEC_MASK) ==
 	    IWL_RX_MPDU_STATUS_SEC_NONE)
@@ -870,7 +882,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
-	if (iwl_mvm_rx_crypto(mvm, hdr, rx_status, desc,
+	if (iwl_mvm_rx_crypto(mvm, hdr, rx_status, phy_info, desc,
 			      le32_to_cpu(pkt->len_n_flags), queue,
 			      &crypt_len)) {
 		kfree_skb(skb);
-- 
2.17.0
