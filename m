Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0GITXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 15:23:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/4] iwlagn: fix the bit mask of a FH register in stop Tx DMA flow
Date: Fri,  9 Jul 2010 12:24:40 -0700
Message-Id: <1278703480-13363-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we stop the Tx DMA channels, we poll bits 16:31 in
FH_TSSR_RX_STATUS_REG. From 4965 and up, only the bits 16:26 are legal.
Bits 27:31 are not used and are always unset.
Polling them will lead to fail on timeout but since the timeout is quite
small, the stall was not felt.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    7 +++++--
 drivers/net/wireless/iwlwifi/iwl-fh.h     |    7 +------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2573234..55a1b31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -950,9 +950,12 @@ void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
 		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
+		if (iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    1000);
+				    1000))
+			IWL_ERR(priv, "Failing on timeout while stopping"
+			    " DMA channel %d [0x%08x]", ch,
+			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 113c366..dd896f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -398,12 +398,7 @@
  */
 #define FH_TSSR_TX_ERROR_REG		(FH_TSSR_LOWER_BOUND + 0x018)
 
-#define FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) ((1 << (_chnl)) << 24)
-#define FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl) ((1 << (_chnl)) << 16)
-
-#define FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_chnl) \
-	(FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) | \
-	FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl))
+#define FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_chnl) ((1 << (_chnl)) << 16)
 
 /* Tx service channels */
 #define FH_SRVC_CHNL		(9)
-- 
1.7.0.4

