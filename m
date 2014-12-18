Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34198 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaLRIL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 03:11:26 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so844701wid.15
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 00:11:25 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/5] iwlwifi: pcie: limit fw chunk sizes given to fh
Date: Thu, 18 Dec 2014 10:10:01 +0200
Message-Id: <1418890201-15177-5-git-send-email-egrumbach@gmail.com> (sfid-20141218_091132_171759_A4413DC9)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

New FW has chunks that are larger than the size limit of the
FH's DMA. To make sure we don't crash it - actively limit the
max size of each chunk.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h     | 1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 9564ae1..1f7f15e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -310,6 +310,7 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
 
 #define FH_MEM_TFDIB_REG1_ADDR_BITSHIFT	28
+#define FH_MEM_TB_MAX_LENGTH			(0x00020000)
 
 /* TFDB  Area - TFDs buffer table */
 #define FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK      (0xFFFFFFFF)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d151af3..523fe0c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -614,7 +614,7 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 {
 	u8 *v_addr;
 	dma_addr_t p_addr;
-	u32 offset, chunk_sz = section->len;
+	u32 offset, chunk_sz = min_t(u32, FH_MEM_TB_MAX_LENGTH, section->len);
 	int ret = 0;
 
 	IWL_DEBUG_FW(trans, "[%d] uCode section being loaded...\n",
-- 
1.9.1

