Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50650 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752988AbdDKMjB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:36 +0300
Message-Id: <20170411123742.12214-20-luca@coelho.fi> (sfid-20170411_144106_163068_AF4E4DBB)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: pcie: use iwl_get_dma_hi_addr()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use iwl_get_dma_hi_addr() instead of open-coding it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 66bdd2df910a..9c8ab1a82b72 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -380,8 +380,7 @@ static inline void iwl_pcie_tfd_set_tb(struct iwl_trans *trans, void *tfd,
 		u16 hi_n_len = len << 4;
 
 		put_unaligned_le32(addr, &tb->lo);
-		if (sizeof(dma_addr_t) > sizeof(u32))
-			hi_n_len |= ((addr >> 16) >> 16) & 0xF;
+		hi_n_len |= iwl_get_dma_hi_addr(addr);
 
 		tb->hi_n_len = cpu_to_le16(hi_n_len);
 
-- 
2.11.0
