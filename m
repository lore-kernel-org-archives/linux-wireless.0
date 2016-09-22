Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45442 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S938926AbcIVUwW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:04 +0300
Message-Id: <20160922205210.1778-5-luca@coelho.fi> (sfid-20160922_225301_100122_61503182)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 04/10] iwlwifi: pcie: avoid variable shadowing in TFD helpers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The various TFD/TB helpers have two code paths depending on the
type of TFD supported, with variable shadowing due to the new if
branches. Move the fall-through code into else branches to avoid
variable shadowing. While doing so, rename some of the variables
and do some other cleanups (like removing void * casts of void *
pointers.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 19 ++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 47 ++++++++++++----------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 2d81630..cac6d99 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -497,23 +497,20 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
 
-static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_trans *trans, void *tfd,
+static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_trans *trans, void *_tfd,
 					  u8 idx)
 {
-	struct iwl_tfd *tfd_fh;
-	struct iwl_tfd_tb *tb;
-
 	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
-		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
+		struct iwl_tfh_tfd *tfd = _tfd;
+		struct iwl_tfh_tb *tb = &tfd->tbs[idx];
 
 		return le16_to_cpu(tb->tb_len);
-	}
-
-	tfd_fh = (void *)tfd;
-	tb = &tfd_fh->tbs[idx];
+	} else {
+		struct iwl_tfd *tfd = _tfd;
+		struct iwl_tfd_tb *tb = &tfd->tbs[idx];
 
-	return le16_to_cpu(tb->hi_n_len) >> 4;
+		return le16_to_cpu(tb->hi_n_len) >> 4;
+	}
 }
 
 /*****************************************************
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index e00e7d8..e9a278b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -337,28 +337,32 @@ static inline void *iwl_pcie_get_tfd(struct iwl_trans_pcie *trans_pcie,
 }
 
 static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_trans *trans,
-						  void *tfd, u8 idx)
+						  void *_tfd, u8 idx)
 {
-	struct iwl_tfd *tfd_fh;
-	struct iwl_tfd_tb *tb;
-	dma_addr_t addr;
 
 	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
-		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
+		struct iwl_tfh_tfd *tfd = _tfd;
+		struct iwl_tfh_tb *tb = &tfd->tbs[idx];
 
 		return (dma_addr_t)(le64_to_cpu(tb->addr));
-	}
+	} else {
+		struct iwl_tfd *tfd = _tfd;
+		struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+		dma_addr_t addr = get_unaligned_le32(&tb->lo);
+		dma_addr_t hi_len;
 
-	tfd_fh = (void *)tfd;
-	tb = &tfd_fh->tbs[idx];
-	addr = get_unaligned_le32(&tb->lo);
+		if (sizeof(dma_addr_t) <= sizeof(u32))
+			return addr;
 
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		addr |=
-		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
+		hi_len = le16_to_cpu(tb->hi_n_len) & 0xF;
 
-	return addr;
+		/*
+		 * shift by 16 twice to avoid warnings on 32-bit
+		 * (where this code never runs anyway due to the
+		 * if statement above)
+		 */
+		return addr | ((hi_len << 16) << 16);
+	}
 }
 
 static inline void iwl_pcie_tfd_set_tb(struct iwl_trans *trans, void *tfd,
@@ -388,18 +392,17 @@ static inline void iwl_pcie_tfd_set_tb(struct iwl_trans *trans, void *tfd,
 	}
 }
 
-static inline u8 iwl_pcie_tfd_get_num_tbs(struct iwl_trans *trans, void *tfd)
+static inline u8 iwl_pcie_tfd_get_num_tbs(struct iwl_trans *trans, void *_tfd)
 {
-	struct iwl_tfd *tfd_fh;
-
 	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+		struct iwl_tfh_tfd *tfd = _tfd;
 
-		return le16_to_cpu(tfd_fh->num_tbs) & 0x1f;
-	}
+		return le16_to_cpu(tfd->num_tbs) & 0x1f;
+	} else {
+		struct iwl_tfd *tfd = _tfd;
 
-	tfd_fh = (void *)tfd;
-	return tfd_fh->num_tbs & 0x1f;
+		return tfd->num_tbs & 0x1f;
+	}
 }
 
 static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
-- 
2.9.3
