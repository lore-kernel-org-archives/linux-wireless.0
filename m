Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbZKTUFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/19] iwlagn: Use iwl_write8() for CSR_INT_COALESCING register
Date: Fri, 20 Nov 2009 12:04:53 -0800
Message-Id: <1258747510-21233-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

CSR_INT_COALESCING previously had only one, but now has two single-byte fields.
With only one single-byte field (lowest order byte) it was okay to write via
iwl_write32(), but now with two, an iwl_write32() to the lower order field
clobbers the other field (odd-address CSR_INT_PERIODIC_REG, offset 0x5), and an
iwl_write32() to CSR_INT_PERIODIC_REG could clobber the lowest byte of the
next-higher register (CSR_INT, offset 0x8).

Fortunately, no bad side effects have been produced by the iwl_write32()
usage, due to order of execution (low order byte was always written before
higher order byte), and the fact that writing "0" to the low byte of the
next higher register has no effect (only action is when writing "1"s).

Nonetheless, this cleans up the accesses so no bad side effects might occur
in the future, if execution order changes, or more bit fields get added to
CSR_INT_COALESCING.

Add some comments regarding periodic interrupt usage.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   19 ++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    3 ++-
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 84b56f5..4da0d3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1267,15 +1267,24 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		 * 3- update RX shared data to indicate last write index.
 		 * 4- send interrupt.
 		 * This could lead to RX race, driver could receive RX interrupt
-		 * but the shared data changes does not reflect this.
-		 * this could lead to RX race, RX periodic will solve this race
+		 * but the shared data changes does not reflect this;
+		 * periodic interrupt will detect any dangling Rx activity.
 		 */
-		iwl_write32(priv, CSR_INT_PERIODIC_REG,
+
+		/* Disable periodic interrupt; we use it as just a one-shot. */
+		iwl_write8(priv, CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
 		iwl_rx_handle(priv);
-		/* Only set RX periodic if real RX is received. */
+
+		/*
+		 * Enable periodic interrupt in 8 msec only if we received
+		 * real RX interrupt (instead of just periodic int), to catch
+		 * any dangling Rx interrupt.  If it was just the periodic
+		 * interrupt, there was no dangling Rx activity, and no need
+		 * to extend the periodic interrupt; one-shot is enough.
+		 */
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write32(priv, CSR_INT_PERIODIC_REG,
+			iwl_write8(priv, CSR_INT_PERIODIC_REG,
 				    CSR_INT_PERIODIC_ENA);
 
 		priv->isr_stats.rx++;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3d49a65..3a4b855 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -256,7 +256,10 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->cfg->ops->lib->apm_ops.init(priv);
-	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
+
+	/* Set interrupt coalescing timer to 512 usecs */
+	iwl_write8(priv, CSR_INT_COALESCING, 512 / 32);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 68ed822..a7bfae0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -173,8 +173,8 @@
 #define CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE (0x02000000) /* ME_OWN */
 #define CSR_HW_IF_CONFIG_REG_PREPARE		  (0x08000000) /* WAKE_ME */
 
-#define CSR_INT_PERIODIC_DIS			(0x00)
-#define CSR_INT_PERIODIC_ENA			(0xFF)
+#define CSR_INT_PERIODIC_DIS			(0x00) /* disable periodic int*/
+#define CSR_INT_PERIODIC_ENA			(0xFF) /* 255*32 usec ~ 8 msec*/
 
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index cc980d5..6090bc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -477,7 +477,8 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
-	iwl_write32(priv, CSR_INT_COALESCING, 0x40);
+	/* Set interrupt coalescing timer to 64 x 32 = 2048 usecs */
+	iwl_write8(priv, CSR_INT_COALESCING, 0x40);
 
 	return 0;
 }
-- 
1.5.6.3

