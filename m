Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40832 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750916AbeDVI17 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:27:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:37 +0300
Message-Id: <20180422082745.9743-5-luca@coelho.fi> (sfid-20180422_102807_182973_B5C8B722)
In-Reply-To: <20180422082745.9743-1-luca@coelho.fi>
References: <20180422082745.9743-1-luca@coelho.fi>
Subject: [PATCH 04/12] iwlwifi: pcie: allow sending pre-built A-MSDUs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

In case of A-MSDUs, the trans layer is taking care of building
the subframes (out of the given skb), according to the given gso_size.

However, in some testing flows, we want to build the whole A-MSDU
frame in a different place (e.g. userspace), and ask the driver
to send it as-is.

In case of gso_size==0, simply treat the frame as normal-frame,
although the A-MSDU flag is set.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 1cbb8f470afd..473fe7ccb07c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2397,7 +2397,13 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
-	if (amsdu) {
+	/*
+	 * If gso_size wasn't set, don't give the frame "amsdu treatment"
+	 * (adding subframes, etc.).
+	 * This can happen in some testing flows when the amsdu was already
+	 * pre-built, and we just need to send the resulting skb.
+	 */
+	if (amsdu && skb_shinfo(skb)->gso_size) {
 		if (unlikely(iwl_fill_data_tbs_amsdu(trans, skb, txq, hdr_len,
 						     out_meta, dev_cmd,
 						     tb1_len)))
-- 
2.17.0
