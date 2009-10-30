Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZJ3VgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/15] iwlagn: Clarify FH_TX interrupt
Date: Fri, 30 Oct 2009 14:36:08 -0700
Message-Id: <1256938578-9638-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add/clarify comments and debug messages for interrupt used only for uCode load

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a6dce23..f36a7d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1034,11 +1034,12 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
+	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
+		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
 		priv->isr_stats.tx++;
 		handled |= CSR_INT_BIT_FH_TX;
-		/* FH finished to write, send event */
+		/* Wake up uCode load routine, now that load is complete */
 		priv->ucode_write_complete = 1;
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
@@ -1235,12 +1236,13 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		iwl_leds_background(priv);
 	}
 
+	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
 		iwl_write32(priv, CSR_FH_INT_STATUS, CSR49_FH_INT_TX_MASK);
-		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
+		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
 		priv->isr_stats.tx++;
 		handled |= CSR_INT_BIT_FH_TX;
-		/* FH finished to write, send event */
+		/* Wake up uCode load routine, now that load is complete */
 		priv->ucode_write_complete = 1;
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
-- 
1.5.6.3

