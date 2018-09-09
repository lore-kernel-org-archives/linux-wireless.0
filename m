Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47928 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726689AbeIIO0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:41 +0300
Message-Id: <20180909093656.10194-2-luca@coelho.fi> (sfid-20180909_113708_244604_D9DFDA1B)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 01/16] iwlwifi: pcie: gen2: build A-MSDU only for GSO
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the incoming frame should be an A-MSDU, it may already be one,
for example in the case of NAN multicast being encapsulated in an
A-MSDU. Thus, use the GSO algorithm to build A-MSDU only if the
skb actually contains GSO data.

Fixes: 6ffe5de35b05 ("iwlwifi: pcie: add AMSDU to gen2")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 943891a9d3e7..ba9d37bed4c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -539,7 +539,12 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
-	if (amsdu)
+	/*
+	 * Only build A-MSDUs here if doing so by GSO, otherwise it may be
+	 * an A-MSDU for other reasons, e.g. NAN or an A-MSDU having been
+	 * built in the higher layers already.
+	 */
+	if (amsdu && skb_shinfo(skb)->gso_size)
 		return iwl_pcie_gen2_build_tx_amsdu(trans, txq, dev_cmd, skb,
 						    out_meta, hdr_len, len);
 
-- 
2.18.0
