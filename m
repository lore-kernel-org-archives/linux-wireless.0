Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50756 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751797AbdDKMki (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:40:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:27 +0300
Message-Id: <20170411123742.12214-11-luca@coelho.fi> (sfid-20170411_145544_692214_665B21BF)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: use upper_32_bits/lower_32_bits where appropriate
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

That's a bit nicer than open-coding it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 33ef5372d195..361fc25e8618 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -647,7 +647,7 @@ struct iwl_rb_status {
 
 static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
 {
-	return (sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0) & 0xF;
+	return (sizeof(addr) > sizeof(u32) ? upper_32_bits(addr) : 0) & 0xF;
 }
 /**
  * struct iwl_tfd_tb transmit buffer descriptor within transmit frame descriptor
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index a9f69fdd170b..0f893ae6e715 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -54,8 +54,8 @@ IWL_EXPORT_SYMBOL(iwl_write32);
 void iwl_write64(struct iwl_trans *trans, u64 ofs, u64 val)
 {
 	trace_iwlwifi_dev_iowrite64(trans->dev, ofs, val);
-	iwl_trans_write32(trans, ofs, val & 0xffffffff);
-	iwl_trans_write32(trans, ofs + 4, val >> 32);
+	iwl_trans_write32(trans, ofs, lower_32_bits(val));
+	iwl_trans_write32(trans, ofs + 4, upper_32_bits(val));
 }
 IWL_EXPORT_SYMBOL(iwl_write64);
 
-- 
2.11.0
