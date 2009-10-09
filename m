Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbZJIUVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:21:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/17 v2.6.32] iwl3945: update iwl3945_apm_init()
Date: Fri,  9 Oct 2009 13:20:18 -0700
Message-Id: <1255119634-3060-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Update iwl3945_apm_init() to set up device registers in sequence most recently
recommended by factory.

Add resets for APMG interrupts and radio chip, formerly done only in
iwl3945_apm_reset(); moving them here assures that apm_init() will do
a complete job of preparing hardware not only after platform boot,
but also after apm_stop() has executed (due to rfkill, ifconfig down,
driver unload, etc.).  This is in preparation to completely remove apm_reset().

Add some comments.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   42 ++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4115672..89f8239 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -982,23 +982,45 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 	return rc;
 }
 
+/*
+ * Start up NIC's basic functionality after it has been reset
+ * (e.g. after platform boot, or shutdown via iwl3945_apm_stop())
+ * NOTE:  This does not load uCode nor start the embedded processor
+ */
 static int iwl3945_apm_init(struct iwl_priv *priv)
 {
 	int ret;
 
 	iwl_power_initialize(priv);
 
+	/* Configure chip clock phase-lock-loop */
+	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
+
+	/*
+	 * Disable L0S exit timer (platform NMI Work/Around)
+	 * (does this do anything on 3945, or just 4965 and beyond?)
+	 */
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
-	/* disable L0s without affecting L1 :don't wait for ICH L0s bug W/A) */
+	/* Disable L0s without affecting L1; don't wait for ICH (L0s bug W/A) */
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
-	/* set "initialization complete" bit to move adapter
-	* D0U* --> D0A* state */
+	/* Set FH wait threshold to maximum (HW error during stress W/A) */
+	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+
+	/*
+	 * Set "initialization complete" bit to move adapter from
+	 * D0U* --> D0A* (powered-up active) state.
+	 */
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
+	/*
+	 * Wait for clock stabilization; once stabilized, access to
+	 * device-internal resources is supported, e.g. iwl_write_prph()
+	 * and accesses to uCode SRAM.
+	 */
 	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
@@ -1007,13 +1029,21 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 		goto out;
 	}
 
-	/* enable DMA */
+	/* Enable DMA and BSM clocks, wait for them to stabilize */
 	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
 						APMG_CLK_VAL_BSM_CLK_RQT);
-
 	udelay(20);
 
-	/* disable L1-Active */
+	/* Clear APMG (NIC's internal power management) interrupts */
+	iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
+	iwl_write_prph(priv, APMG_RTC_INT_STT_REG, 0xFFFFFFFF);
+
+	/* Reset radio chip */
+	iwl_set_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
+	udelay(5);
+	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
+
+	/* Disable L1-Active */
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-- 
1.5.6.3

