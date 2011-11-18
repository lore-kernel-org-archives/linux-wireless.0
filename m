Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1KRIVU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:20 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LKOt022572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:20 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 15/77] iwlegacy: rename il_{read,write}_prph
Date: Fri, 18 Nov 2011 09:21:37 +0100
Message-Id: <1321604559-10707-15-git-send-email-sgruszka@redhat.com> (sfid-20111118_092127_968383_ED870D76)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |   48 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c     |   34 +++++++++---------
 drivers/net/wireless/iwlegacy/iwl-core.c     |    6 ++--
 drivers/net/wireless/iwlegacy/iwl-io.h       |   23 ++++++------
 drivers/net/wireless/iwlegacy/iwl3945-base.c |   12 +++---
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   18 +++++-----
 7 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index fc8ddb6..cdea5b0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -797,18 +797,18 @@ static int il3945_tx_reset(struct il_priv *il)
 {
 
 	/* bypass mode */
-	il_write_prph(il, ALM_SCD_MODE_REG, 0x2);
+	il_wr_prph(il, ALM_SCD_MODE_REG, 0x2);
 
 	/* RA 0 is active */
-	il_write_prph(il, ALM_SCD_ARASTAT_REG, 0x01);
+	il_wr_prph(il, ALM_SCD_ARASTAT_REG, 0x01);
 
 	/* all 6 fifo are active */
-	il_write_prph(il, ALM_SCD_TXFACT_REG, 0x3f);
+	il_wr_prph(il, ALM_SCD_TXFACT_REG, 0x3f);
 
-	il_write_prph(il, ALM_SCD_SBYP_MODE_1_REG, 0x010000);
-	il_write_prph(il, ALM_SCD_SBYP_MODE_2_REG, 0x030002);
-	il_write_prph(il, ALM_SCD_TXF4MF_REG, 0x000004);
-	il_write_prph(il, ALM_SCD_TXF5MF_REG, 0x000005);
+	il_wr_prph(il, ALM_SCD_SBYP_MODE_1_REG, 0x010000);
+	il_wr_prph(il, ALM_SCD_SBYP_MODE_2_REG, 0x030002);
+	il_wr_prph(il, ALM_SCD_TXF4MF_REG, 0x000004);
+	il_wr_prph(il, ALM_SCD_TXF5MF_REG, 0x000005);
 
 	il_wr(il, FH39_TSSR_CBB_BASE,
 			     il->_3945.shared_phys);
@@ -878,8 +878,8 @@ static int il3945_apm_init(struct il_priv *il)
 	int ret = il_apm_init(il);
 
 	/* Clear APMG (NIC's internal power management) interrupts */
-	il_write_prph(il, APMG_RTC_INT_MSK_REG, 0x0);
-	il_write_prph(il, APMG_RTC_INT_STT_REG, 0xFFFFFFFF);
+	il_wr_prph(il, APMG_RTC_INT_MSK_REG, 0x0);
+	il_wr_prph(il, APMG_RTC_INT_STT_REG, 0xFFFFFFFF);
 
 	/* Reset radio chip */
 	il_set_bits_prph(il, APMG_PS_CTRL_REG,
@@ -1025,8 +1025,8 @@ void il3945_hw_txq_ctx_stop(struct il_priv *il)
 	int txq_id;
 
 	/* stop SCD */
-	il_write_prph(il, ALM_SCD_MODE_REG, 0);
-	il_write_prph(il, ALM_SCD_TXFACT_REG, 0);
+	il_wr_prph(il, ALM_SCD_MODE_REG, 0);
+	il_wr_prph(il, ALM_SCD_TXFACT_REG, 0);
 
 	/* reset TFD queues */
 	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
@@ -2475,11 +2475,11 @@ static int il3945_verify_bsm(struct il_priv *il)
 	D_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = il_read_prph(il, BSM_WR_DWCOUNT_REG);
+	val = il_rd_prph(il, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image++) {
-		val = il_read_prph(il, reg);
+		val = il_rd_prph(il, reg);
 		if (val != le32_to_cpu(*image)) {
 			IL_ERR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -2583,16 +2583,16 @@ static int il3945_load_bsm(struct il_priv *il)
 	inst_len = il->ucode_init.len;
 	data_len = il->ucode_init_data.len;
 
-	il_write_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
-	il_write_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
-	il_write_prph(il, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	il_write_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	il_wr_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
+	il_wr_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
+	il_wr_prph(il, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	il_wr_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_il_write_prph(il, reg_offset,
+		_il_wr_prph(il, reg_offset,
 					  le32_to_cpu(*image));
 
 	rc = il3945_verify_bsm(il);
@@ -2600,19 +2600,19 @@ static int il3945_load_bsm(struct il_priv *il)
 		return rc;
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	il_write_prph(il, BSM_WR_MEM_SRC_REG, 0x0);
-	il_write_prph(il, BSM_WR_MEM_DST_REG,
+	il_wr_prph(il, BSM_WR_MEM_SRC_REG, 0x0);
+	il_wr_prph(il, BSM_WR_MEM_DST_REG,
 				 IWL39_RTC_INST_LOWER_BOUND);
-	il_write_prph(il, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	il_wr_prph(il, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	il_write_prph(il, BSM_WR_CTRL_REG,
+	il_wr_prph(il, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = il_read_prph(il, BSM_WR_CTRL_REG);
+		done = il_rd_prph(il, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -2626,7 +2626,7 @@ static int il3945_load_bsm(struct il_priv *il)
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	il_write_prph(il, BSM_WR_CTRL_REG,
+	il_wr_prph(il, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 25c9b71..f86a3b9 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -754,7 +754,7 @@ static void il4965_tx_queue_stop_scheduler(struct il_priv *il,
 {
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	il_write_prph(il,
+	il_wr_prph(il,
 		IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 7b422f2..a745032 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -72,11 +72,11 @@ static int il4965_verify_bsm(struct il_priv *il)
 	D_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = il_read_prph(il, BSM_WR_DWCOUNT_REG);
+	val = il_rd_prph(il, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image++) {
-		val = il_read_prph(il, reg);
+		val = il_rd_prph(il, reg);
 		if (val != le32_to_cpu(*image)) {
 			IL_ERR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -156,34 +156,34 @@ static int il4965_load_bsm(struct il_priv *il)
 	inst_len = il->ucode_init.len;
 	data_len = il->ucode_init_data.len;
 
-	il_write_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
-	il_write_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
-	il_write_prph(il, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	il_write_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	il_wr_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
+	il_wr_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
+	il_wr_prph(il, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	il_wr_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_il_write_prph(il, reg_offset, le32_to_cpu(*image));
+		_il_wr_prph(il, reg_offset, le32_to_cpu(*image));
 
 	ret = il4965_verify_bsm(il);
 	if (ret)
 		return ret;
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	il_write_prph(il, BSM_WR_MEM_SRC_REG, 0x0);
-	il_write_prph(il,
+	il_wr_prph(il, BSM_WR_MEM_SRC_REG, 0x0);
+	il_wr_prph(il,
 			BSM_WR_MEM_DST_REG, IWL49_RTC_INST_LOWER_BOUND);
-	il_write_prph(il, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	il_wr_prph(il, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	il_write_prph(il, BSM_WR_CTRL_REG, BSM_WR_CTRL_REG_BIT_START);
+	il_wr_prph(il, BSM_WR_CTRL_REG, BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = il_read_prph(il, BSM_WR_CTRL_REG);
+		done = il_rd_prph(il, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -197,7 +197,7 @@ static int il4965_load_bsm(struct il_priv *il)
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	il_write_prph(il,
+	il_wr_prph(il,
 			BSM_WR_CTRL_REG, BSM_WR_CTRL_REG_BIT_START_EN);
 
 
@@ -224,14 +224,14 @@ static int il4965_set_ucode_ptrs(struct il_priv *il)
 	pdata = il->ucode_data_backup.p_addr >> 4;
 
 	/* Tell bootstrap uCode where to find image to load */
-	il_write_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
-	il_write_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
-	il_write_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG,
+	il_wr_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
+	il_wr_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
+	il_wr_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 il->ucode_data.len);
 
 	/* Inst byte count must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	il_write_prph(il, BSM_DRAM_INST_BYTECOUNT_REG,
+	il_wr_prph(il, BSM_DRAM_INST_BYTECOUNT_REG,
 				 il->ucode_code.len | BSM_DRAM_INST_LOAD);
 	D_INFO("Runtime uCode pointers are set.\n");
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index d2534fb..ed44159 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1069,7 +1069,7 @@ int il_apm_init(struct il_priv *il)
 
 	/*
 	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is supported, e.g. il_write_prph()
+	 * device-internal resources is supported, e.g. il_wr_prph()
 	 * and accesses to uCode SRAM.
 	 */
 	ret = _il_poll_bit(il, CSR_GP_CNTRL,
@@ -1089,10 +1089,10 @@ int il_apm_init(struct il_priv *il)
 	 * set by default in "CLK_CTRL_REG" after reset.
 	 */
 	if (il->cfg->base_params->use_bsm)
-		il_write_prph(il, APMG_CLK_EN_REG,
+		il_wr_prph(il, APMG_CLK_EN_REG,
 			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
 	else
-		il_write_prph(il, APMG_CLK_EN_REG,
+		il_wr_prph(il, APMG_CLK_EN_REG,
 			APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(20);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index f435942..8cb924d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -197,26 +197,27 @@ static inline int il_poll_bit(struct il_priv *il, u32 addr,
 	return -ETIMEDOUT;
 }
 
-static inline u32 _il_read_prph(struct il_priv *il, u32 reg)
+static inline u32 _il_rd_prph(struct il_priv *il, u32 reg)
 {
 	_il_wr(il, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	rmb();
 	return _il_rd(il, HBUS_TARG_PRPH_RDAT);
 }
-static inline u32 il_read_prph(struct il_priv *il, u32 reg)
+
+static inline u32 il_rd_prph(struct il_priv *il, u32 reg)
 {
 	unsigned long reg_flags;
 	u32 val;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	_il_grab_nic_access(il);
-	val = _il_read_prph(il, reg);
+	val = _il_rd_prph(il, reg);
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 	return val;
 }
 
-static inline void _il_write_prph(struct il_priv *il,
+static inline void _il_wr_prph(struct il_priv *il,
 					     u32 addr, u32 val)
 {
 	_il_wr(il, HBUS_TARG_PRPH_WADDR,
@@ -226,20 +227,20 @@ static inline void _il_write_prph(struct il_priv *il,
 }
 
 static inline void
-il_write_prph(struct il_priv *il, u32 addr, u32 val)
+il_wr_prph(struct il_priv *il, u32 addr, u32 val)
 {
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	if (!_il_grab_nic_access(il)) {
-		_il_write_prph(il, addr, val);
+		_il_wr_prph(il, addr, val);
 		_il_release_nic_access(il);
 	}
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
 #define _il_set_bits_prph(il, reg, mask) \
-_il_write_prph(il, reg, (_il_read_prph(il, reg) | mask))
+_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask))
 
 static inline void
 il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
@@ -254,8 +255,8 @@ il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 }
 
 #define _il_set_bits_mask_prph(il, reg, bits, mask) \
-_il_write_prph(il, reg,				\
-		 ((_il_read_prph(il, reg) & mask) | bits))
+_il_wr_prph(il, reg,				\
+		 ((_il_rd_prph(il, reg) & mask) | bits))
 
 static inline void il_set_bits_mask_prph(struct il_priv *il, u32 reg,
 				u32 bits, u32 mask)
@@ -277,8 +278,8 @@ static inline void il_clear_bits_prph(struct il_priv
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	_il_grab_nic_access(il);
-	val = _il_read_prph(il, reg);
-	_il_write_prph(il, reg, (val & ~mask));
+	val = _il_rd_prph(il, reg);
+	_il_wr_prph(il, reg, (val & ~mask));
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index a0b5a74..5037216 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2122,14 +2122,14 @@ static int il3945_set_ucode_ptrs(struct il_priv *il)
 	pdata = il->ucode_data_backup.p_addr;
 
 	/* Tell bootstrap uCode where to find image to load */
-	il_write_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
-	il_write_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
-	il_write_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG,
+	il_wr_prph(il, BSM_DRAM_INST_PTR_REG, pinst);
+	il_wr_prph(il, BSM_DRAM_DATA_PTR_REG, pdata);
+	il_wr_prph(il, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 il->ucode_data.len);
 
 	/* Inst byte count must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	il_write_prph(il, BSM_DRAM_INST_BYTECOUNT_REG,
+	il_wr_prph(il, BSM_DRAM_INST_BYTECOUNT_REG,
 				 il->ucode_code.len | BSM_DRAM_INST_LOAD);
 
 	D_INFO("Runtime uCode pointers are set.\n");
@@ -2210,7 +2210,7 @@ static void il3945_alive_start(struct il_priv *il)
 		goto restart;
 	}
 
-	rfkill = il_read_prph(il, APMG_RFKILL_REG);
+	rfkill = il_rd_prph(il, APMG_RFKILL_REG);
 	D_INFO("RFKILL status: 0x%x\n", rfkill);
 
 	if (rfkill & 0x1) {
@@ -2342,7 +2342,7 @@ static void __il3945_down(struct il_priv *il)
 	il3945_hw_rxq_stop(il);
 
 	/* Power-down device's busmaster DMA clocks */
-	il_write_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	il_wr_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(5);
 
 	/* Stop the device, and put it in low power state */
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index b0668ea..0f7d44c 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1622,7 +1622,7 @@ static int il4965_alive_notify(struct il_priv *il)
 	spin_lock_irqsave(&il->lock, flags);
 
 	/* Clear 4965's internal Tx Scheduler data base */
-	il->scd_base_addr = il_read_prph(il,
+	il->scd_base_addr = il_rd_prph(il,
 					IWL49_SCD_SRAM_BASE_ADDR);
 	a = il->scd_base_addr + IWL49_SCD_CONTEXT_DATA_OFFSET;
 	for (; a < il->scd_base_addr + IWL49_SCD_TX_STTS_BITMAP_OFFSET; a += 4)
@@ -1634,7 +1634,7 @@ static int il4965_alive_notify(struct il_priv *il)
 		il_write_targ_mem(il, a, 0);
 
 	/* Tel 4965 where to find Tx byte count tables */
-	il_write_prph(il, IWL49_SCD_DRAM_BASE_ADDR,
+	il_wr_prph(il, IWL49_SCD_DRAM_BASE_ADDR,
 			il->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
@@ -1650,13 +1650,13 @@ static int il4965_alive_notify(struct il_priv *il)
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	/* Disable chain mode for all queues */
-	il_write_prph(il, IWL49_SCD_QUEUECHAIN_SEL, 0);
+	il_wr_prph(il, IWL49_SCD_QUEUECHAIN_SEL, 0);
 
 	/* Initialize each Tx queue (including the command queue) */
 	for (i = 0; i < il->hw_params.max_txq_num; i++) {
 
 		/* TFD circular buffer read/write indexes */
-		il_write_prph(il, IWL49_SCD_QUEUE_RDPTR(i), 0);
+		il_wr_prph(il, IWL49_SCD_QUEUE_RDPTR(i), 0);
 		il_wr(il, HBUS_TARG_WRPTR, 0 | (i << 8));
 
 		/* Max Tx Window size for Scheduler-ACK mode */
@@ -1675,7 +1675,7 @@ static int il4965_alive_notify(struct il_priv *il)
 				IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
-	il_write_prph(il, IWL49_SCD_INTERRUPT_MASK,
+	il_wr_prph(il, IWL49_SCD_INTERRUPT_MASK,
 				 (1 << il->hw_params.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
@@ -1868,7 +1868,7 @@ static void __il4965_down(struct il_priv *il)
 	il4965_rxq_stop(il);
 
 	/* Power-down device's busmaster DMA clocks */
-	il_write_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	il_wr_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(5);
 
 	/* Make sure (redundant) we've released our request to stay awake */
@@ -2733,7 +2733,7 @@ void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 index)
 {
 	il_wr(il, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
-	il_write_prph(il, IWL49_SCD_QUEUE_RDPTR(txq_id), index);
+	il_wr_prph(il, IWL49_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void il4965_tx_queue_set_status(struct il_priv *il,
@@ -2746,7 +2746,7 @@ void il4965_tx_queue_set_status(struct il_priv *il,
 	int active = test_bit(txq_id, &il->txq_ctx_active_msk) ? 1 : 0;
 
 	/* Set up and activate */
-	il_write_prph(il, IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
+	il_wr_prph(il, IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
 			 (active << IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 			 (tx_fifo_id << IWL49_SCD_QUEUE_STTS_REG_POS_TXF) |
 			 (scd_retry << IWL49_SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -3195,7 +3195,7 @@ static void __devexit il4965_pci_remove(struct pci_dev *pdev)
  */
 void il4965_txq_set_sched(struct il_priv *il, u32 mask)
 {
-	il_write_prph(il, IWL49_SCD_TXFACT, mask);
+	il_wr_prph(il, IWL49_SCD_TXFACT, mask);
 }
 
 /*****************************************************************************
-- 
1.7.1

