Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40736 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbcEJU3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:12 +0300
Message-Id: <1462910797-20303-16-git-send-email-luca@coelho.fi> (sfid-20160510_222933_475433_640E54A3)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 16/41] iwlwifi: mvm: allow a debug knob for Tx A-MSDU even if rate control forbids it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There is a debugfs knob to configure the maximal length
of the A-MSDU. If this value is not 0 (which is the
default), allow Tx A-MSDU even if the rate control
disallows it.
While at it, add "unlikely" to the if that limits the
length of the A-MSDU based on the debugfs hook.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index a8e5a67..3b64568 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -609,9 +609,11 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 		return -EINVAL;
 
+	dbg_max_amsdu_len = ACCESS_ONCE(mvm->max_amsdu_len);
+
 	if (!sta->max_amsdu_len ||
 	    !ieee80211_is_data_qos(hdr->frame_control) ||
-	    !mvmsta->tlc_amsdu) {
+	    (!mvmsta->tlc_amsdu && !dbg_max_amsdu_len)) {
 		num_subframes = 1;
 		pad = 0;
 		goto segment;
@@ -642,7 +644,6 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	max_amsdu_len = sta->max_amsdu_len;
-	dbg_max_amsdu_len = ACCESS_ONCE(mvm->max_amsdu_len);
 
 	/* the Tx FIFO to which this A-MSDU will be routed */
 	txf = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
@@ -656,7 +657,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	max_amsdu_len = min_t(unsigned int, max_amsdu_len,
 			      mvm->shared_mem_cfg.txfifo_size[txf] - 256);
 
-	if (dbg_max_amsdu_len)
+	if (unlikely(dbg_max_amsdu_len))
 		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
 				      dbg_max_amsdu_len);
 
-- 
2.8.1

