Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34888 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFYLML (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:40 +0300
Message-Id: <20170625111158.1792-9-luca@coelho.fi> (sfid-20170625_131220_147324_9111ACD2)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 08/26] iwlwifi: document transmit buffer bits better
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Properly document the transmit buffer bits using an enum and
kernel-doc documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 77be149276b6..66e5db41e559 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -655,6 +655,17 @@ static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
 {
 	return (sizeof(addr) > sizeof(u32) ? upper_32_bits(addr) : 0) & 0xF;
 }
+
+/**
+ * enum iwl_tfd_tb_hi_n_len - TB hi_n_len bits
+ * @TB_HI_N_LEN_ADDR_HI_MSK: high 4 bits (to make it 36) of DMA address
+ * @TB_HI_N_LEN_LEN_MSK: length of the TB
+ */
+enum iwl_tfd_tb_hi_n_len {
+	TB_HI_N_LEN_ADDR_HI_MSK	= 0xf,
+	TB_HI_N_LEN_LEN_MSK	= 0xfff0,
+};
+
 /**
  * struct iwl_tfd_tb transmit buffer descriptor within transmit frame descriptor
  *
@@ -662,8 +673,7 @@ static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
  *
  * @lo: low [31:0] portion of the dma address of TX buffer
  * 	every even is unaligned on 16 bit boundary
- * @hi_n_len 0-3 [35:32] portion of dma
- *	     4-15 length of the tx buffer
+ * @hi_n_len: &enum iwl_tfd_tb_hi_n_len
  */
 struct iwl_tfd_tb {
 	__le32 lo;
-- 
2.11.0
