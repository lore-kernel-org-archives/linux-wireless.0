Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47986 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726743AbeIIO0O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:47 +0300
Message-Id: <20180909093656.10194-8-luca@coelho.fi> (sfid-20180909_113713_341905_977804C7)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 07/16] iwlwifi: pcie: set RB size according to user settings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

RB size can be configured by user to be greater than 4K.
That's needed for monitor to capture big AMSDUs.
The firmware now enables different RB sizes configuration
via context info.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-context-info.h | 25 +++++++++++++++--
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   | 28 +++++++++++++++----
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h b/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
index 4b6fdf3b15fb..5ed07e37e3ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
@@ -64,20 +64,41 @@
  *	the init done for driver command that configures several system modes
  * @IWL_CTXT_INFO_EARLY_DEBUG: enable early debug
  * @IWL_CTXT_INFO_ENABLE_CDMP: enable core dump
- * @IWL_CTXT_INFO_RB_SIZE_4K: Use 4K RB size (the default is 2K)
  * @IWL_CTXT_INFO_RB_CB_SIZE_POS: position of the RBD Cyclic Buffer Size
  *	exponent, the actual size is 2**value, valid sizes are 8-2048.
  *	The value is four bits long. Maximum valid exponent is 12
  * @IWL_CTXT_INFO_TFD_FORMAT_LONG: use long TFD Format (the
  *	default is short format - not supported by the driver)
+ * @IWL_CTXT_INFO_RB_SIZE_POS: RB size position
+ *	(values are IWL_CTXT_INFO_RB_SIZE_*K)
+ * @IWL_CTXT_INFO_RB_SIZE_1K: Value for 1K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_2K: Value for 2K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_4K: Value for 4K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_8K: Value for 8K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_12K: Value for 12K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_16K: Value for 16K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_20K: Value for 20K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_24K: Value for 24K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_28K: Value for 28K RB size
+ * @IWL_CTXT_INFO_RB_SIZE_32K: Value for 32K RB size
  */
 enum iwl_context_info_flags {
 	IWL_CTXT_INFO_AUTO_FUNC_INIT	= BIT(0),
 	IWL_CTXT_INFO_EARLY_DEBUG	= BIT(1),
 	IWL_CTXT_INFO_ENABLE_CDMP	= BIT(2),
-	IWL_CTXT_INFO_RB_SIZE_4K	= BIT(3),
 	IWL_CTXT_INFO_RB_CB_SIZE_POS	= 4,
 	IWL_CTXT_INFO_TFD_FORMAT_LONG	= BIT(8),
+	IWL_CTXT_INFO_RB_SIZE_POS	= 9,
+	IWL_CTXT_INFO_RB_SIZE_1K	= 0x1,
+	IWL_CTXT_INFO_RB_SIZE_2K	= 0x2,
+	IWL_CTXT_INFO_RB_SIZE_4K	= 0x4,
+	IWL_CTXT_INFO_RB_SIZE_8K	= 0x8,
+	IWL_CTXT_INFO_RB_SIZE_12K	= 0x9,
+	IWL_CTXT_INFO_RB_SIZE_16K	= 0xa,
+	IWL_CTXT_INFO_RB_SIZE_20K	= 0xb,
+	IWL_CTXT_INFO_RB_SIZE_24K	= 0xc,
+	IWL_CTXT_INFO_RB_SIZE_28K	= 0xd,
+	IWL_CTXT_INFO_RB_SIZE_32K	= 0xe,
 };
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index b2cd7ef5fc3a..6f45a0303ddd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -162,7 +162,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_context_info *ctxt_info;
 	struct iwl_context_info_rbd_cfg *rx_cfg;
-	u32 control_flags = 0;
+	u32 control_flags = 0, rb_size;
 	int ret;
 
 	ctxt_info = dma_alloc_coherent(trans->dev, sizeof(*ctxt_info),
@@ -177,11 +177,29 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 	/* size is in DWs */
 	ctxt_info->version.size = cpu_to_le16(sizeof(*ctxt_info) / 4);
 
+	switch (trans_pcie->rx_buf_size) {
+	case IWL_AMSDU_2K:
+		rb_size = IWL_CTXT_INFO_RB_SIZE_2K;
+		break;
+	case IWL_AMSDU_4K:
+		rb_size = IWL_CTXT_INFO_RB_SIZE_4K;
+		break;
+	case IWL_AMSDU_8K:
+		rb_size = IWL_CTXT_INFO_RB_SIZE_8K;
+		break;
+	case IWL_AMSDU_12K:
+		rb_size = IWL_CTXT_INFO_RB_SIZE_12K;
+		break;
+	default:
+		WARN_ON(1);
+		rb_size = IWL_CTXT_INFO_RB_SIZE_4K;
+	}
+
 	BUILD_BUG_ON(RX_QUEUE_CB_SIZE(MQ_RX_TABLE_SIZE) > 0xF);
-	control_flags = IWL_CTXT_INFO_RB_SIZE_4K |
-			IWL_CTXT_INFO_TFD_FORMAT_LONG |
-			RX_QUEUE_CB_SIZE(MQ_RX_TABLE_SIZE) <<
-			IWL_CTXT_INFO_RB_CB_SIZE_POS;
+	control_flags = IWL_CTXT_INFO_TFD_FORMAT_LONG |
+			(RX_QUEUE_CB_SIZE(MQ_RX_TABLE_SIZE) <<
+			 IWL_CTXT_INFO_RB_CB_SIZE_POS) |
+			(rb_size << IWL_CTXT_INFO_RB_SIZE_POS);
 	ctxt_info->control.control_flags = cpu_to_le32(control_flags);
 
 	/* initialize RX default queue */
-- 
2.18.0
