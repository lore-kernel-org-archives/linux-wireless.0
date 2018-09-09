Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47994 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726722AbeIIO0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:48 +0300
Message-Id: <20180909093656.10194-9-luca@coelho.fi> (sfid-20180909_113714_061007_504B9BD1)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: mvm: use correct FIFO length
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Current FIFO size calculation is wrong for two reasons:
- We access lmac 0 by default
- We don't take 11ax into consideration.
Fix both.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 47 +++++++++++++------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 56871aff1698..781f30356720 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -82,6 +82,10 @@ const u8 iwl_mvm_ac_to_gen2_tx_fifo[] = {
 	IWL_GEN2_EDCA_TX_FIFO_VI,
 	IWL_GEN2_EDCA_TX_FIFO_BE,
 	IWL_GEN2_EDCA_TX_FIFO_BK,
+	IWL_GEN2_TRIG_TX_FIFO_VO,
+	IWL_GEN2_TRIG_TX_FIFO_VI,
+	IWL_GEN2_TRIG_TX_FIFO_BE,
+	IWL_GEN2_TRIG_TX_FIFO_BK,
 };
 
 struct iwl_mvm_mac_iface_iterator_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ffc0ad1eef15..a6877b3f8037 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -840,6 +840,36 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
 	return 0;
 }
 
+static unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
+					   struct ieee80211_sta *sta,
+					   unsigned int tid)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	enum nl80211_band band = mvmsta->vif->bss_conf.chandef.chan->band;
+	u8 ac = tid_to_mac80211_ac[tid];
+	unsigned int txf;
+	int lmac = IWL_LMAC_24G_INDEX;
+
+	if (iwl_mvm_is_cdb_supported(mvm) &&
+	    band == NL80211_BAND_5GHZ)
+		lmac = IWL_LMAC_5G_INDEX;
+
+	/* For HE redirect to trigger based fifos */
+	if (sta->he_cap.has_he && !WARN_ON(!iwl_mvm_has_new_tx_api(mvm)))
+		ac += 4;
+
+	txf = iwl_mvm_mac_ac_to_tx_fifo(mvm, ac);
+
+	/*
+	 * Don't send an AMSDU that will be longer than the TXF.
+	 * Add a security margin of 256 for the TX command + headers.
+	 * We also want to have the start of the next packet inside the
+	 * fifo to be able to send bursts.
+	 */
+	return min_t(unsigned int, mvmsta->max_amsdu_len,
+		     mvm->fwrt.smem_cfg.lmac[lmac].txfifo_size[txf] - 256);
+}
+
 static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
@@ -852,7 +882,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 snap_ip_tcp, pad;
 	unsigned int dbg_max_amsdu_len;
 	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
-	u8 tid, txf;
+	u8 tid;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
@@ -891,20 +921,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !(mvmsta->amsdu_enabled & BIT(tid)))
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 
-	max_amsdu_len = mvmsta->max_amsdu_len;
-
-	/* the Tx FIFO to which this A-MSDU will be routed */
-	txf = iwl_mvm_mac_ac_to_tx_fifo(mvm, tid_to_mac80211_ac[tid]);
-
-	/*
-	 * Don't send an AMSDU that will be longer than the TXF.
-	 * Add a security margin of 256 for the TX command + headers.
-	 * We also want to have the start of the next packet inside the
-	 * fifo to be able to send bursts.
-	 */
-	max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-			      mvm->fwrt.smem_cfg.lmac[0].txfifo_size[txf] -
-			      256);
+	max_amsdu_len = iwl_mvm_max_amsdu_size(mvm, sta, tid);
 
 	if (unlikely(dbg_max_amsdu_len))
 		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-- 
2.18.0
