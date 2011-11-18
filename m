Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab1KRIVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LAA0015639
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/77] iwlegacy: rename il_{read,write}32 to _il_{rd,wr}
Date: Fri, 18 Nov 2011 09:21:32 +0100
Message-Id: <1321604559-10707-10-git-send-email-sgruszka@redhat.com> (sfid-20111118_092149_115212_E3E6A980)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce rule that underscore at the beginning mean unlocked I/O method.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-led.c |    6 +-
 drivers/net/wireless/iwlegacy/iwl-core.c     |   10 ++--
 drivers/net/wireless/iwlegacy/iwl-csr.h      |    6 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-eeprom.c   |    6 +-
 drivers/net/wireless/iwlegacy/iwl-helpers.h  |   10 ++--
 drivers/net/wireless/iwlegacy/iwl-io.h       |   23 +++++------
 drivers/net/wireless/iwlegacy/iwl-rx.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c       |    4 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |   42 ++++++++++----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   56 +++++++++++++-------------
 12 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index cf47fdb..6e2e71a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -1058,7 +1058,7 @@ static inline int il3945_hw_reg_temp_out_of_range(int temperature)
 
 int il3945_hw_get_temperature(struct il_priv *il)
 {
-	return il_read32(il, CSR_UCODE_DRV_GP2);
+	return _il_rd(il, CSR_UCODE_DRV_GP2);
 }
 
 /**
@@ -2211,7 +2211,7 @@ int il3945_hw_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq)
 		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
 
 	/* fake read to flush all prev. writes */
-	il_read32(il, FH39_TSSR_CBB_BASE);
+	_il_rd(il, FH39_TSSR_CBB_BASE);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-led.c b/drivers/net/wireless/iwlegacy/iwl-4965-led.c
index 1436a1b..4854157 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-led.c
@@ -55,9 +55,9 @@ il4965_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
 	};
 	u32 reg;
 
-	reg = il_read32(il, CSR_LED_REG);
+	reg = _il_rd(il, CSR_LED_REG);
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		il_write32(il, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+		_il_wr(il, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
 	return il_send_cmd(il, &cmd);
 }
@@ -65,7 +65,7 @@ il4965_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
 /* Set led register off */
 void il4965_led_enable(struct il_priv *il)
 {
-	il_write32(il, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	_il_wr(il, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 }
 
 const struct il_led_ops il4965_led_ops = {
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 42be833..c5ffd91 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2001,7 +2001,7 @@ int il_pci_resume(struct device *device)
 
 	il_enable_interrupts(il);
 
-	if (!(il_read32(il, CSR_GP_CNTRL) &
+	if (!(_il_rd(il, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 		hw_rfkill = true;
 
@@ -2580,12 +2580,12 @@ irqreturn_t il_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = il_read32(il, CSR_INT_MASK);  /* just for debug */
-	il_write32(il, CSR_INT_MASK, 0x00000000);
+	inta_mask = _il_rd(il, CSR_INT_MASK);  /* just for debug */
+	_il_wr(il, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = il_read32(il, CSR_INT);
-	inta_fh = il_read32(il, CSR_FH_INT_STATUS);
+	inta = _il_rd(il, CSR_INT);
+	inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
diff --git a/drivers/net/wireless/iwlegacy/iwl-csr.h b/drivers/net/wireless/iwlegacy/iwl-csr.h
index 24b71ae..faffb8e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-csr.h
+++ b/drivers/net/wireless/iwlegacy/iwl-csr.h
@@ -70,7 +70,7 @@
  * low power states due to driver-invoked device resets
  * (e.g. CSR_RESET_REG_FLAG_SW_RESET) or uCode-driven power-saving modes.
  *
- * Use il_write32() and il_read32() family to access these registers;
+ * Use _il_wr() and _il_rd() family to access these registers;
  * these provide simple PCI bus access, without waking up the MAC.
  * Do not use il_write_direct32() family for these registers;
  * no need to "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ.
@@ -91,7 +91,7 @@
 #define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
 #define CSR_GP_CNTRL            (CSR_BASE+0x024)
 
-/* 2nd byte of CSR_INT_COALESCING, not accessible via il_write32()! */
+/* 2nd byte of CSR_INT_COALESCING, not accessible via _il_wr()! */
 #define CSR_INT_PERIODIC_REG	(CSR_BASE+0x005)
 
 /*
@@ -374,7 +374,7 @@
  * to make sure the MAC (uCode processor, etc.) is powered up for accessing
  * internal resources.
  *
- * Do not use il_write32()/il_read32() family to access these registers;
+ * Do not use _il_wr()/_il_rd() family to access these registers;
  * these provide only simple PCI bus access, without waking up the MAC.
  */
 #define HBUS_BASE	(0x400)
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 45b71a8..cd15e67 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -1018,7 +1018,7 @@ static ssize_t il_dbgfs_power_save_status_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	u32 pwrsave_status;
 
-	pwrsave_status = il_read32(il, CSR_GP_CNTRL) &
+	pwrsave_status = _il_rd(il, CSR_GP_CNTRL) &
 			CSR_GP_REG_POWER_SAVE_STATUS_MSK;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 5f0fd2a..26cf506 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -144,7 +144,7 @@ static const u8 il_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 
 static int il_eeprom_verify_signature(struct il_priv *il)
 {
-	u32 gp = il_read32(il, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+	u32 gp = _il_rd(il, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
 	D_EEPROM("EEPROM signature=0x%08x\n", gp);
@@ -187,7 +187,7 @@ EXPORT_SYMBOL(il_eeprom_query16);
 int il_eeprom_init(struct il_priv *il)
 {
 	__le16 *e;
-	u32 gp = il_read32(il, CSR_EEPROM_GP);
+	u32 gp = _il_rd(il, CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
@@ -223,7 +223,7 @@ int il_eeprom_init(struct il_priv *il)
 	for (addr = 0; addr < sz; addr += sizeof(u16)) {
 		u32 r;
 
-		_il_write32(il, CSR_EEPROM_REG,
+		_il_wr(il, CSR_EEPROM_REG,
 			     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
 		ret = il_poll_bit(il, CSR_EEPROM_REG,
diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index a0a84b2..a9d8702 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -149,26 +149,26 @@ static inline void il_disable_interrupts(struct il_priv *il)
 	clear_bit(STATUS_INT_ENABLED, &il->status);
 
 	/* disable interrupts from uCode/NIC to host */
-	il_write32(il, CSR_INT_MASK, 0x00000000);
+	_il_wr(il, CSR_INT_MASK, 0x00000000);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
-	il_write32(il, CSR_INT, 0xffffffff);
-	il_write32(il, CSR_FH_INT_STATUS, 0xffffffff);
+	_il_wr(il, CSR_INT, 0xffffffff);
+	_il_wr(il, CSR_FH_INT_STATUS, 0xffffffff);
 	D_ISR("Disabled interrupts\n");
 }
 
 static inline void il_enable_rfkill_int(struct il_priv *il)
 {
 	D_ISR("Enabling rfkill interrupt\n");
-	il_write32(il, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	_il_wr(il, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
 static inline void il_enable_interrupts(struct il_priv *il)
 {
 	D_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &il->status);
-	il_write32(il, CSR_INT_MASK, il->inta_mask);
+	_il_wr(il, CSR_INT_MASK, il->inta_mask);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index 1afd5c0..cdbcfde 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -40,18 +40,15 @@ static inline void _il_write8(struct il_priv *il, u32 ofs, u8 val)
 }
 #define il_write8(il, ofs, val) _il_write8(il, ofs, val)
 
-static inline void _il_write32(struct il_priv *il, u32 ofs, u32 val)
+static inline void _il_wr(struct il_priv *il, u32 ofs, u32 val)
 {
 	iowrite32(val, il->hw_base + ofs);
 }
-#define il_write32(il, ofs, val) _il_write32(il, ofs, val)
 
-static inline u32 _il_read32(struct il_priv *il, u32 ofs)
+static inline u32 _il_rd(struct il_priv *il, u32 ofs)
 {
-	u32 val = ioread32(il->hw_base + ofs);
-	return val;
+	return ioread32(il->hw_base + ofs);
 }
-#define il_read32(p, o) _il_read32(p, o)
 
 #define IL_POLL_INTERVAL 10	/* microseconds */
 static inline int
@@ -61,7 +58,7 @@ _il_poll_bit(struct il_priv *il, u32 addr,
 	int t = 0;
 
 	do {
-		if ((_il_read32(il, addr) & mask) == (bits & mask))
+		if ((_il_rd(il, addr) & mask) == (bits & mask))
 			return t;
 		udelay(IL_POLL_INTERVAL);
 		t += IL_POLL_INTERVAL;
@@ -73,7 +70,7 @@ _il_poll_bit(struct il_priv *il, u32 addr,
 
 static inline void _il_set_bit(struct il_priv *il, u32 reg, u32 mask)
 {
-	_il_write32(il, reg, _il_read32(il, reg) | mask);
+	_il_wr(il, reg, _il_rd(il, reg) | mask);
 }
 
 static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
@@ -88,7 +85,7 @@ static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
 static inline void
 _il_clear_bit(struct il_priv *il, u32 reg, u32 mask)
 {
-	_il_write32(il, reg, _il_read32(il, reg) & ~mask);
+	_il_wr(il, reg, _il_rd(il, reg) & ~mask);
 }
 
 static inline void il_clear_bit(struct il_priv *p, u32 r, u32 m)
@@ -131,10 +128,10 @@ static inline int _il_grab_nic_access(struct il_priv *il)
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
-		val = _il_read32(il, CSR_GP_CNTRL);
+		val = _il_rd(il, CSR_GP_CNTRL);
 		IL_ERR(
 			"MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
-		_il_write32(il, CSR_RESET,
+		_il_wr(il, CSR_RESET,
 				CSR_RESET_REG_FLAG_FORCE_NMI);
 		return -EIO;
 	}
@@ -152,7 +149,7 @@ static inline void _il_release_nic_access(struct il_priv *il)
 
 static inline u32 _il_read_direct32(struct il_priv *il, u32 reg)
 {
-	return _il_read32(il, reg);
+	return _il_rd(il, reg);
 }
 
 static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
@@ -172,7 +169,7 @@ static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 static inline void _il_write_direct32(struct il_priv *il,
 					 u32 reg, u32 value)
 {
-	_il_write32(il, reg, value);
+	_il_wr(il, reg, value);
 }
 static inline void
 il_write_direct32(struct il_priv *il, u32 reg, u32 value)
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 183acdc..e481ca8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -138,7 +138,7 @@ il_rx_queue_update_write_ptr(struct il_priv *il,
 
 	/* If power-saving is in use, make sure device is awake */
 	if (test_bit(STATUS_POWER_PMI, &il->status)) {
-		reg = il_read32(il, CSR_UCODE_DRV_GP1);
+		reg = _il_rd(il, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			D_INFO(
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index cfc015a..6b5e652 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -55,7 +55,7 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 		/* wake up nic if it's powered down ...
 		 * uCode will wake up, and interrupt us again, so next
 		 * time we'll skip this part. */
-		reg = il_read32(il, CSR_UCODE_DRV_GP1);
+		reg = _il_rd(il, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			D_INFO(
@@ -75,7 +75,7 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 		 * trying to tx (during RFKILL, we're not trying to tx).
 		 */
 	} else
-		il_write32(il, HBUS_TARG_WRPTR,
+		_il_wr(il, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 	txq->need_update = 0;
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 66aa850..def3140 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -824,7 +824,7 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
-	il_write32(il, CSR_UCODE_DRV_GP1_SET,
+	_il_wr(il, CSR_UCODE_DRV_GP1_SET,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	if (flags & HW_CARD_DISABLED)
@@ -1419,19 +1419,19 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 *  and will clear only when CSR_FH_INT_STATUS gets cleared. */
-	inta = il_read32(il, CSR_INT);
-	il_write32(il, CSR_INT, inta);
+	inta = _il_rd(il, CSR_INT);
+	_il_wr(il, CSR_INT, inta);
 
 	/* Ack/clear/reset pending flow-handler (DMA) interrupts.
 	 * Any new interrupts that happen after this, either while we're
 	 * in this tasklet, or later, will show up in next ISR/tasklet. */
-	inta_fh = il_read32(il, CSR_FH_INT_STATUS);
-	il_write32(il, CSR_FH_INT_STATUS, inta_fh);
+	inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
+	_il_wr(il, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_ISR) {
 		/* just for debug */
-		inta_mask = il_read32(il, CSR_INT_MASK);
+		inta_mask = _il_rd(il, CSR_INT_MASK);
 		D_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -1519,7 +1519,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 		D_ISR("Tx interrupt\n");
 		il->isr_stats.tx++;
 
-		il_write32(il, CSR_FH_INT_STATUS, (1 << 6));
+		_il_wr(il, CSR_FH_INT_STATUS, (1 << 6));
 		il_write_direct32(il, FH39_TCSR_CREDIT
 					(FH39_SRVC_CHNL), 0x0);
 		handled |= CSR_INT_BIT_FH_TX;
@@ -1543,9 +1543,9 @@ static void il3945_irq_tasklet(struct il_priv *il)
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
-		inta = il_read32(il, CSR_INT);
-		inta_mask = il_read32(il, CSR_INT_MASK);
-		inta_fh = il_read32(il, CSR_FH_INT_STATUS);
+		inta = _il_rd(il, CSR_INT);
+		inta_mask = _il_rd(il, CSR_INT_MASK);
+		inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
 		D_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
@@ -1817,7 +1817,7 @@ static int il3945_verify_ucode(struct il_priv *il)
 static void il3945_nic_start(struct il_priv *il)
 {
 	/* Remove all resets to allow NIC to operate */
-	il_write32(il, CSR_RESET, 0);
+	_il_wr(il, CSR_RESET, 0);
 }
 
 #define IWL3945_UCODE_GET(item)						\
@@ -2304,7 +2304,7 @@ static void __il3945_down(struct il_priv *il)
 		clear_bit(STATUS_EXIT_PENDING, &il->status);
 
 	/* stop and reset the on-board processor */
-	il_write32(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&il->lock, flags);
@@ -2412,7 +2412,7 @@ static int __il3945_up(struct il_priv *il)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (il_read32(il, CSR_GP_CNTRL) &
+	if (_il_rd(il, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &il->status);
 	else {
@@ -2421,7 +2421,7 @@ static int __il3945_up(struct il_priv *il)
 		return -ENODEV;
 	}
 
-	il_write32(il, CSR_INT, 0xFFFFFFFF);
+	_il_wr(il, CSR_INT, 0xFFFFFFFF);
 
 	rc = il3945_hw_nic_init(il);
 	if (rc) {
@@ -2430,17 +2430,17 @@ static int __il3945_up(struct il_priv *il)
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR,
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	il_write32(il, CSR_INT, 0xFFFFFFFF);
+	_il_wr(il, CSR_INT, 0xFFFFFFFF);
 	il_enable_interrupts(il);
 
 	/* really make sure rfkill handshake bits are cleared */
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
@@ -2529,7 +2529,7 @@ static void il3945_rfkill_poll(struct work_struct *data)
 	struct il_priv *il =
 	    container_of(data, struct il_priv, _3945.rfkill_poll.work);
 	bool old_rfkill = test_bit(STATUS_RF_KILL_HW, &il->status);
-	bool new_rfkill = !(il_read32(il, CSR_GP_CNTRL)
+	bool new_rfkill = !(_il_rd(il, CSR_GP_CNTRL)
 			& CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 
 	if (new_rfkill != old_rfkill) {
@@ -3748,7 +3748,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	 * strange state ... like being left stranded by a primary kernel
 	 * and this is now the kdump kernel trying to start up
 	 */
-	il_write32(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/***********************
 	 * 4. Read EEPROM
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index df7e0a4..a774373 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -517,9 +517,9 @@ static void il4965_perform_ct_kill_task(struct il_priv *il)
 	if (il->mac80211_registered)
 		ieee80211_stop_queues(il->hw);
 
-	il_write32(il, CSR_UCODE_DRV_GP1_SET,
+	_il_wr(il, CSR_UCODE_DRV_GP1_SET,
 			CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-	il_read32(il, CSR_UCODE_DRV_GP1);
+	_il_rd(il, CSR_UCODE_DRV_GP1);
 
 	spin_lock_irqsave(&il->reg_lock, flags);
 	if (!il_grab_nic_access(il))
@@ -545,14 +545,14 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
 		     CT_CARD_DISABLED)) {
 
-		il_write32(il, CSR_UCODE_DRV_GP1_SET,
+		_il_wr(il, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 		il_write_direct32(il, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
-			il_write32(il, CSR_UCODE_DRV_GP1_CLR,
+			_il_wr(il, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 			il_write_direct32(il, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
@@ -787,19 +787,19 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 *  and will clear only when CSR_FH_INT_STATUS gets cleared. */
-	inta = il_read32(il, CSR_INT);
-	il_write32(il, CSR_INT, inta);
+	inta = _il_rd(il, CSR_INT);
+	_il_wr(il, CSR_INT, inta);
 
 	/* Ack/clear/reset pending flow-handler (DMA) interrupts.
 	 * Any new interrupts that happen after this, either while we're
 	 * in this tasklet, or later, will show up in next ISR/tasklet. */
-	inta_fh = il_read32(il, CSR_FH_INT_STATUS);
-	il_write32(il, CSR_FH_INT_STATUS, inta_fh);
+	inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
+	_il_wr(il, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_ISR) {
 		/* just for debug */
-		inta_mask = il_read32(il, CSR_INT_MASK);
+		inta_mask = _il_rd(il, CSR_INT_MASK);
 		D_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -853,7 +853,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!(il_read32(il, CSR_GP_CNTRL) &
+		if (!(_il_rd(il, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
@@ -948,9 +948,9 @@ static void il4965_irq_tasklet(struct il_priv *il)
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
-		inta = il_read32(il, CSR_INT);
-		inta_mask = il_read32(il, CSR_INT_MASK);
-		inta_fh = il_read32(il, CSR_FH_INT_STATUS);
+		inta = _il_rd(il, CSR_INT);
+		inta_mask = _il_rd(il, CSR_INT_MASK);
+		inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
 		D_ISR(
 			"End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
@@ -1092,7 +1092,7 @@ static void il4965_dealloc_ucode_pci(struct il_priv *il)
 static void il4965_nic_start(struct il_priv *il)
 {
 	/* Remove all resets to allow NIC to operate */
-	il_write32(il, CSR_RESET, 0);
+	_il_wr(il, CSR_RESET, 0);
 }
 
 static void il4965_ucode_callback(const struct firmware *ucode_raw,
@@ -1584,7 +1584,7 @@ static void il4965_rf_kill_ct_config(struct il_priv *il)
 	int ret = 0;
 
 	spin_lock_irqsave(&il->lock, flags);
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR,
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -1830,7 +1830,7 @@ static void __il4965_down(struct il_priv *il)
 		clear_bit(STATUS_EXIT_PENDING, &il->status);
 
 	/* stop and reset the on-board processor */
-	il_write32(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&il->lock, flags);
@@ -1980,7 +1980,7 @@ static int __il4965_up(struct il_priv *il)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (il_read32(il,
+	if (_il_rd(il,
 		CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &il->status);
 	else
@@ -1994,7 +1994,7 @@ static int __il4965_up(struct il_priv *il)
 		return 0;
 	}
 
-	il_write32(il, CSR_INT, 0xFFFFFFFF);
+	_il_wr(il, CSR_INT, 0xFFFFFFFF);
 
 	/* must be initialised before il_hw_nic_init */
 	il->cmd_queue = IL_DEFAULT_CMD_QUEUE_NUM;
@@ -2006,17 +2006,17 @@ static int __il4965_up(struct il_priv *il)
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR,
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	il_write32(il, CSR_INT, 0xFFFFFFFF);
+	_il_wr(il, CSR_INT, 0xFFFFFFFF);
 	il_enable_interrupts(il);
 
 	/* really make sure rfkill handshake bits are cleared */
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	il_write32(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	_il_wr(il, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
@@ -2296,7 +2296,7 @@ void il4965_mac_stop(struct ieee80211_hw *hw)
 
 	/* User space software may expect getting rfkill changes
 	 * even if interface is down */
-	il_write32(il, CSR_INT, 0xFFFFFFFF);
+	_il_wr(il, CSR_INT, 0xFFFFFFFF);
 	il_enable_rfkill_int(il);
 
 	D_MAC80211("leave\n");
@@ -2821,8 +2821,8 @@ static void il4965_uninit_drv(struct il_priv *il)
 
 static void il4965_hw_detect(struct il_priv *il)
 {
-	il->hw_rev = _il_read32(il, CSR_HW_REV);
-	il->hw_wa_rev = _il_read32(il, CSR_HW_REV_WA_REG);
+	il->hw_rev = _il_rd(il, CSR_HW_REV);
+	il->hw_wa_rev = _il_rd(il, CSR_HW_REV_WA_REG);
 	il->rev_id = il->pci_dev->revision;
 	D_INFO("HW Revision ID = 0x%X\n", il->rev_id);
 }
@@ -2978,7 +2978,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * strange state ... like being left stranded by a primary kernel
 	 * and this is now the kdump kernel trying to start up
 	 */
-	il_write32(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	il4965_hw_detect(il);
 	IL_INFO("Detected %s, REV=0x%X\n",
@@ -3066,7 +3066,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il_enable_rfkill_int(il);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (il_read32(il, CSR_GP_CNTRL) &
+	if (_il_rd(il, CSR_GP_CNTRL) &
 		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &il->status);
 	else
-- 
1.7.1

