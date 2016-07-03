Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60834 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbcGCTtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:49 +0300
Message-Id: <1467575332-32112-10-git-send-email-luca@coelho.fi> (sfid-20160703_214920_549529_003AA992)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 10/13] iwlwifi: pcie: allow more than one frame in RB for 9000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We now have 9000 devices that support multiple frames in
a single RB. Enable it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 27ff74d..4fad808 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -833,15 +833,13 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	/*
 	 * Enable Rx DMA
-	 * Single frame mode
 	 * Rx buffer size 4 or 8k or 12k
 	 * Min RB size 4 or 8
 	 * Drop frames that exceed RB size
 	 * 512 RBDs
 	 */
 	iwl_write_prph_no_grab(trans, RFH_RXF_DMA_CFG,
-			       RFH_DMA_EN_ENABLE_VAL |
-			       rb_size | RFH_RXF_DMA_SINGLE_FRAME_MASK |
+			       RFH_DMA_EN_ENABLE_VAL | rb_size |
 			       RFH_RXF_DMA_MIN_RB_4_8 |
 			       RFH_RXF_DMA_DROP_TOO_LARGE_MASK |
 			       RFH_RXF_DMA_RBDCB_SIZE_512);
-- 
2.8.1

