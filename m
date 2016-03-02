Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbcCBH5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/43] iwlwifi: mvm: don't send an A-MSDU that is larger than the TXF
Date: Wed,  2 Mar 2016 09:56:19 +0200
Message-Id: <1456905404-14435-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085741_703775_F0C50F4A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The A-MSDU must be smaller than the Transmit FIFO in the
device. Since the size of the TXF can change depending
on the device / firmware compilation mode, take the size
of the FIFO dynamically from the what the firmware tells us.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index a73ae01..dd616c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -449,7 +449,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
 	u16 amsdu_add, snap_ip_tcp, pad, i = 0;
 	unsigned int dbg_max_amsdu_len;
-	u8 *qc, tid;
+	u8 *qc, tid, txf;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
@@ -480,6 +480,19 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	max_amsdu_len = sta->max_amsdu_len;
 	dbg_max_amsdu_len = ACCESS_ONCE(mvm->max_amsdu_len);
+
+	/* the Tx FIFO to which this A-MSDU will be routed */
+	txf = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
+
+	/*
+	 * Don't send an AMSDU that will be longer than the TXF.
+	 * Add a security margin of 256 for the TX command + headers.
+	 * We also want to have the start of the next packet inside the
+	 * fifo to be able to send bursts.
+	 */
+	max_amsdu_len = min_t(unsigned int, max_amsdu_len,
+			      mvm->shared_mem_cfg.txfifo_size[txf] - 256);
+
 	if (dbg_max_amsdu_len)
 		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
 				      dbg_max_amsdu_len);
-- 
2.5.0

