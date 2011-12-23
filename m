Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1LWHOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 03/10] iwlegacy: move some i/o helpers out of inline
Date: Fri, 23 Dec 2011 08:13:43 +0100
Message-Id: <1324624430-3688-3-git-send-email-sgruszka@redhat.com> (sfid-20111223_081417_431660_CD46BC63)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This save us about 20k of text size, and should have no impact on
performance as hot paths do not use much I/O.

Before:
   text	   data	    bss	    dec	    hex	filename
 108512	   1784	    168	 110464	  1af80	drivers/net/wireless/iwlegacy/iwl3945.ko
 165730	   2164	    156	 168050	  29072	drivers/net/wireless/iwlegacy/iwl4965.ko
  91942	    328	     48	  92318	  1689e	drivers/net/wireless/iwlegacy/iwlegacy.ko

After:
   text	   data	    bss	    dec	    hex	filename
  95556	   1784	    168	  97508	  17ce4	drivers/net/wireless/iwlegacy/iwl3945.ko
 154853	   2164	    156	 157173	  265f5	drivers/net/wireless/iwlegacy/iwl4965.ko
  91634	    328	     48	  92010	  1676a	drivers/net/wireless/iwlegacy/iwlegacy.ko

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |  161 +++++++++++++++++++++++++
 drivers/net/wireless/iwlegacy/common.h |  206 ++-----------------------------
 2 files changed, 175 insertions(+), 192 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 881ba04..36454d0 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -42,6 +42,167 @@
 
 #include "common.h"
 
+int
+_il_poll_bit(struct il_priv *il, u32 addr, u32 bits, u32 mask, int timeout)
+{
+	const int interval = 10; /* microseconds */
+	int t = 0;
+
+	do {
+		if ((_il_rd(il, addr) & mask) == (bits & mask))
+			return t;
+		udelay(interval);
+		t += interval;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL(_il_poll_bit);
+
+void
+il_set_bit(struct il_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	_il_set_bit(p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
+EXPORT_SYMBOL(il_set_bit);
+
+void
+il_clear_bit(struct il_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	_il_clear_bit(p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
+EXPORT_SYMBOL(il_clear_bit);
+
+int
+_il_grab_nic_access(struct il_priv *il)
+{
+	int ret;
+	u32 val;
+
+	/* this bit wakes up the NIC */
+	_il_set_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/*
+	 * These bits say the device is running, and should keep running for
+	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
+	 * but they do not indicate that embedded SRAM is restored yet;
+	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
+	 * to/from host DRAM when sleeping/waking for power-saving.
+	 * Each direction takes approximately 1/4 millisecond; with this
+	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
+	 * series of register accesses are expected (e.g. reading Event Log),
+	 * to keep device from sleeping.
+	 *
+	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
+	 * SRAM is okay/restored.  We don't check that here because this call
+	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
+	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
+	 *
+	 */
+	ret =
+	    _il_poll_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			 (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			  CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
+	if (ret < 0) {
+		val = _il_rd(il, CSR_GP_CNTRL);
+		IL_ERR("MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
+		_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
+		return -EIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(_il_grab_nic_access);
+
+int
+il_poll_bit(struct il_priv *il, u32 addr, u32 mask, int timeout)
+{
+	const int interval = 10; /* microseconds */
+	int t = 0;
+
+	do {
+		if ((il_rd(il, addr) & mask) == mask)
+			return t;
+		udelay(interval);
+		t += interval;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL(il_poll_bit);
+
+u32
+il_rd_prph(struct il_priv *il, u32 reg)
+{
+	unsigned long reg_flags;
+	u32 val;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+	val = _il_rd_prph(il, reg);
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+	return val;
+}
+EXPORT_SYMBOL(il_rd_prph);
+
+void
+il_wr_prph(struct il_priv *il, u32 addr, u32 val)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	if (!_il_grab_nic_access(il)) {
+		_il_wr_prph(il, addr, val);
+		_il_release_nic_access(il);
+	}
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+EXPORT_SYMBOL(il_wr_prph);
+
+u32
+il_read_targ_mem(struct il_priv *il, u32 addr)
+{
+	unsigned long reg_flags;
+	u32 value;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+
+	_il_wr(il, HBUS_TARG_MEM_RADDR, addr);
+	rmb();
+	value = _il_rd(il, HBUS_TARG_MEM_RDAT);
+
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+	return value;
+}
+EXPORT_SYMBOL(il_read_targ_mem);
+
+void
+il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	if (!_il_grab_nic_access(il)) {
+		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
+		wmb();
+		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
+		_il_release_nic_access(il);
+	}
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+EXPORT_SYMBOL(il_write_targ_mem);
+
 const char *
 il_get_cmd_string(u8 cmd)
 {
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 1bc0b02..abfa388 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/wait.h>
+#include <linux/io.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 
@@ -2163,7 +2164,15 @@ void il_tx_cmd_protection(struct il_priv *il, struct ieee80211_tx_info *info,
 
 irqreturn_t il_isr(int irq, void *data);
 
-#include <linux/io.h>
+extern void il_set_bit(struct il_priv *p, u32 r, u32 m);
+extern void il_clear_bit(struct il_priv *p, u32 r, u32 m);
+extern int _il_grab_nic_access(struct il_priv *il);
+extern int _il_poll_bit(struct il_priv *il, u32 addr, u32 bits, u32 mask, int timeout);
+extern int il_poll_bit(struct il_priv *il, u32 addr, u32 mask, int timeout);
+extern u32 il_rd_prph(struct il_priv *il, u32 reg);
+extern void il_wr_prph(struct il_priv *il, u32 addr, u32 val);
+extern u32 il_read_targ_mem(struct il_priv *il, u32 addr);
+extern void il_write_targ_mem(struct il_priv *il, u32 addr, u32 val);
 
 static inline void
 _il_write8(struct il_priv *il, u32 ofs, u8 val)
@@ -2184,38 +2193,6 @@ _il_rd(struct il_priv *il, u32 ofs)
 	return ioread32(il->hw_base + ofs);
 }
 
-#define IL_POLL_INTERVAL 10	/* microseconds */
-static inline int
-_il_poll_bit(struct il_priv *il, u32 addr, u32 bits, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((_il_rd(il, addr) & mask) == (bits & mask))
-			return t;
-		udelay(IL_POLL_INTERVAL);
-		t += IL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
-static inline void
-_il_set_bit(struct il_priv *il, u32 reg, u32 mask)
-{
-	_il_wr(il, reg, _il_rd(il, reg) | mask);
-}
-
-static inline void
-il_set_bit(struct il_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	_il_set_bit(p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-
 static inline void
 _il_clear_bit(struct il_priv *il, u32 reg, u32 mask)
 {
@@ -2223,53 +2200,9 @@ _il_clear_bit(struct il_priv *il, u32 reg, u32 mask)
 }
 
 static inline void
-il_clear_bit(struct il_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	_il_clear_bit(p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-
-static inline int
-_il_grab_nic_access(struct il_priv *il)
+_il_set_bit(struct il_priv *il, u32 reg, u32 mask)
 {
-	int ret;
-	u32 val;
-
-	/* this bit wakes up the NIC */
-	_il_set_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	/*
-	 * These bits say the device is running, and should keep running for
-	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
-	 * but they do not indicate that embedded SRAM is restored yet;
-	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
-	 * to/from host DRAM when sleeping/waking for power-saving.
-	 * Each direction takes approximately 1/4 millisecond; with this
-	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
-	 * series of register accesses are expected (e.g. reading Event Log),
-	 * to keep device from sleeping.
-	 *
-	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
-	 * SRAM is okay/restored.  We don't check that here because this call
-	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
-	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
-	 *
-	 */
-	ret =
-	    _il_poll_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			 (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			  CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
-	if (ret < 0) {
-		val = _il_rd(il, CSR_GP_CNTRL);
-		IL_ERR("MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
-		_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
-		return -EIO;
-	}
-
-	return 0;
+	_il_wr(il, reg, _il_rd(il, reg) | mask);
 }
 
 static inline void
@@ -2290,7 +2223,6 @@ il_rd(struct il_priv *il, u32 reg)
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 	return value;
-
 }
 
 static inline void
@@ -2306,32 +2238,6 @@ il_wr(struct il_priv *il, u32 reg, u32 value)
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
-static inline void
-il_write_reg_buf(struct il_priv *il, u32 reg, u32 len, u32 * values)
-{
-	u32 count = sizeof(u32);
-
-	if (il != NULL && values != NULL) {
-		for (; 0 < len; len -= count, reg += count, values++)
-			il_wr(il, reg, *values);
-	}
-}
-
-static inline int
-il_poll_bit(struct il_priv *il, u32 addr, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((il_rd(il, addr) & mask) == mask)
-			return t;
-		udelay(IL_POLL_INTERVAL);
-		t += IL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
 static inline u32
 _il_rd_prph(struct il_priv *il, u32 reg)
 {
@@ -2340,20 +2246,6 @@ _il_rd_prph(struct il_priv *il, u32 reg)
 	return _il_rd(il, HBUS_TARG_PRPH_RDAT);
 }
 
-static inline u32
-il_rd_prph(struct il_priv *il, u32 reg)
-{
-	unsigned long reg_flags;
-	u32 val;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	val = _il_rd_prph(il, reg);
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-	return val;
-}
-
 static inline void
 _il_wr_prph(struct il_priv *il, u32 addr, u32 val)
 {
@@ -2363,37 +2255,17 @@ _il_wr_prph(struct il_priv *il, u32 addr, u32 val)
 }
 
 static inline void
-il_wr_prph(struct il_priv *il, u32 addr, u32 val)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr_prph(il, addr, val);
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-#define _il_set_bits_prph(il, reg, mask) \
-_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask))
-
-static inline void
 il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 {
 	unsigned long reg_flags;
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	_il_grab_nic_access(il);
-	_il_set_bits_prph(il, reg, mask);
+	_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask));
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
-#define _il_set_bits_mask_prph(il, reg, bits, mask) \
-_il_wr_prph(il, reg,				\
-		 ((_il_rd_prph(il, reg) & mask) | bits))
-
 static inline void
 il_set_bits_mask_prph(struct il_priv *il, u32 reg, u32 bits, u32 mask)
 {
@@ -2401,7 +2273,7 @@ il_set_bits_mask_prph(struct il_priv *il, u32 reg, u32 bits, u32 mask)
 
 	spin_lock_irqsave(&il->reg_lock, reg_flags);
 	_il_grab_nic_access(il);
-	_il_set_bits_mask_prph(il, reg, bits, mask);
+	_il_wr_prph(il, reg, ((_il_rd_prph(il, reg) & mask) | bits));
 	_il_release_nic_access(il);
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
@@ -2420,56 +2292,6 @@ il_clear_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
 }
 
-static inline u32
-il_read_targ_mem(struct il_priv *il, u32 addr)
-{
-	unsigned long reg_flags;
-	u32 value;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-
-	_il_wr(il, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
-	value = _il_rd(il, HBUS_TARG_MEM_RDAT);
-
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-	return value;
-}
-
-static inline void
-il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-static inline void
-il_write_targ_mem_buf(struct il_priv *il, u32 addr, u32 len, u32 * values)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-		for (; 0 < len; len -= sizeof(u32), values++)
-			_il_wr(il, HBUS_TARG_MEM_WDAT, *values);
-
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
 #define HW_KEY_DYNAMIC 0
 #define HW_KEY_DEFAULT 1
 
-- 
1.7.4.4

