Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60876 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751177AbdFBL12 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:27:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:49 +0300
Message-Id: <20170602112553.2466-22-luca@coelho.fi> (sfid-20170602_132759_522694_578AA9E4)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: mvm: remove unused TX_CMD_NEXT_FRAME_*
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 25 +---------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 052b7f0db889..30008237323a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -177,29 +177,6 @@ enum iwl_tx_cmd_sec_ctrl {
 	TX_CMD_SEC_KEY_FROM_TABLE	= 0x10,
 };
 
-/* TODO: how does these values are OK with only 16 bit variable??? */
-/*
- * TX command next frame info
- *
- * bits 0:2 - security control (TX_CMD_SEC_*)
- * bit 3 - immediate ACK required
- * bit 4 - rate is taken from STA table
- * bit 5 - frame belongs to BA stream
- * bit 6 - immediate BA response expected
- * bit 7 - unused
- * bits 8:15 - Station ID
- * bits 16:31 - rate
- */
-#define TX_CMD_NEXT_FRAME_ACK_MSK		(0x8)
-#define TX_CMD_NEXT_FRAME_STA_RATE_MSK		(0x10)
-#define TX_CMD_NEXT_FRAME_BA_MSK		(0x20)
-#define TX_CMD_NEXT_FRAME_IMM_BA_RSP_MSK	(0x40)
-#define TX_CMD_NEXT_FRAME_FLAGS_MSK		(0xf8)
-#define TX_CMD_NEXT_FRAME_STA_ID_MSK		(0xff00)
-#define TX_CMD_NEXT_FRAME_STA_ID_POS		(8)
-#define TX_CMD_NEXT_FRAME_RATE_MSK		(0xffff0000)
-#define TX_CMD_NEXT_FRAME_RATE_POS		(16)
-
 /*
  * TX command Frame life time in us - to be written in pm_frame_timeout
  */
@@ -265,7 +242,7 @@ enum iwl_tx_offload_assist_flags_pos {
  * @initial_rate_index: index into the the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @key: security key
- * @next_frame_flags: TX_CMD_SEC_* and TX_CMD_NEXT_FRAME_*
+ * @reserved3: reserved
  * @life_time: frame life time (usecs??)
  * @dram_lsb_ptr: Physical address of scratch area in the command (try_cnt +
  *	btkill_cnd + reserved), first 32 bits. "0" disables usage.
-- 
2.11.0
