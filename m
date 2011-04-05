Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1DERBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/25] iwlagn: move IO functions out of line
Date: Tue,  5 Apr 2011 09:42:12 -0700
Message-Id: <1302021732-21250-26-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This generates a massive reduction in module size:
with debug:
   text	   data	    bss	    dec	    hex	filename
 670300	  13136	    420	 683856	  a6f50	iwlagn.ko (before)
 388347	  13136	    408	 401891	  621e3	iwlagn.ko (after)

without debug:
   text	   data	    bss	    dec	    hex	filename
 528575	  13072	    420	 542067	  84573	iwlagn.ko (before)
 294192	  13072	    408	 307672	  4b1d8	iwlagn.ko (after)

This also removes all the IO debug functionality since
it can easily be replaced by tracing, and makes the
code unnecessarily complex.

I haven't done any CPU utilisation measurements, but
given that the hotpaths don't use much IO it is not
likely to have a negative impact; in fact, the size
reduction will reduce cache pressure which possibly
improves performance.

Finally, an unused function or two were removed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   18 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h      |    2 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |   36 +-
 drivers/net/wireless/iwlwifi/iwl-io.c         |  274 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h         |  489 +-----------------------
 8 files changed, 326 insertions(+), 503 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-io.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 9d6ee83..3652931 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
-iwlagn-objs		+= iwl-agn-lib.o iwl-agn-calib.o
+iwlagn-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
 iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
 
 iwlagn-objs 		+= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index c6dd9b7..3bcaa10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -103,7 +103,7 @@ int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
-			IWL_DEBUG_IO(priv,
+			IWL_DEBUG_EEPROM(priv,
 				"Acquired semaphore after %d tries.\n",
 				count+1);
 			return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 5187a2c..01a6d2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -561,7 +561,7 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv,
 		 * if IWL_DL_IO is set */
 		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			i + IWLAGN_RTC_INST_LOWER_BOUND);
-		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
 	}
@@ -587,9 +587,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 	     offs < len && errors < 20;
 	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IWL_DL_IO is set */
-		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERR(priv, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 761e60c..3d53a30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -556,7 +556,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	}
 
 	/* Set starting address; reads will auto-increment */
-	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(priv, HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/*
@@ -564,13 +564,13 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	 * place event id # at far right for easier visual parsing.
 	 */
 	for (i = 0; i < num_events; i++) {
-		ev = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			trace_iwlwifi_dev_ucode_cont_event(priv,
 							0, time, ev);
 		} else {
-			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 			trace_iwlwifi_dev_ucode_cont_event(priv,
 						time, data, ev);
 		}
@@ -1961,14 +1961,14 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	iwl_grab_nic_access(priv);
 
 	/* Set starting address; reads will auto-increment */
-	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(priv, HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			if (bufsz) {
@@ -1982,7 +1982,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 					time, ev);
 			}
 		} else {
-			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 			if (bufsz) {
 				pos += scnprintf(*buf + pos, bufsz - pos,
 						"EVT_LOGT:%010u:0x%08x:%04u\n",
@@ -3687,7 +3687,7 @@ static u32 iwl_hw_detect(struct iwl_priv *priv)
 
 	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
-	return _iwl_read32(priv, CSR_HW_REV);
+	return iwl_read32(priv, CSR_HW_REV);
 }
 
 static int iwl_set_hw_params(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 8489431..2824ccb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -146,7 +146,6 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_RX		(1 << 24)
 #define IWL_DL_ISR		(1 << 25)
 #define IWL_DL_HT		(1 << 26)
-#define IWL_DL_IO		(1 << 27)
 /* 0xF0000000 - 0x10000000 */
 #define IWL_DL_11H		(1 << 28)
 #define IWL_DL_STATS		(1 << 29)
@@ -174,7 +173,6 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 		IWL_DEBUG_LIMIT(p, IWL_DL_DROP, f, ## a)
 #define IWL_DEBUG_AP(p, f, a...)	IWL_DEBUG(p, IWL_DL_AP, f, ## a)
 #define IWL_DEBUG_TXPOWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_TXPOWER, f, ## a)
-#define IWL_DEBUG_IO(p, f, a...)	IWL_DEBUG(p, IWL_DL_IO, f, ## a)
 #define IWL_DEBUG_RATE(p, f, a...)	IWL_DEBUG(p, IWL_DL_RATE, f, ## a)
 #define IWL_DEBUG_RATE_LIMIT(p, f, a...)	\
 		IWL_DEBUG_LIMIT(p, IWL_DL_RATE, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 4f8c13e..859b94a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -226,15 +226,15 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 	int ret;
 
 	/* Enable 40MHz radio clock */
-	_iwl_write32(priv, CSR_GP_CNTRL,
-		     _iwl_read32(priv, CSR_GP_CNTRL) |
-		     CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_write32(priv, CSR_GP_CNTRL,
+		    iwl_read32(priv, CSR_GP_CNTRL) |
+		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock to be ready */
 	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-				  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-				  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-				  25000);
+				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+				 25000);
 	if (ret < 0)
 		IWL_ERR(priv, "Time out access OTP\n");
 	else {
@@ -261,17 +261,17 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_dat
 	u32 r;
 	u32 otpgp;
 
-	_iwl_write32(priv, CSR_EEPROM_REG,
-		     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+	iwl_write32(priv, CSR_EEPROM_REG,
+		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 	ret = iwl_poll_bit(priv, CSR_EEPROM_REG,
-				  CSR_EEPROM_REG_READ_VALID_MSK,
-				  CSR_EEPROM_REG_READ_VALID_MSK,
-				  IWL_EEPROM_ACCESS_TIMEOUT);
+				 CSR_EEPROM_REG_READ_VALID_MSK,
+				 CSR_EEPROM_REG_READ_VALID_MSK,
+				 IWL_EEPROM_ACCESS_TIMEOUT);
 	if (ret < 0) {
 		IWL_ERR(priv, "Time out reading OTP[%d]\n", addr);
 		return ret;
 	}
-	r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
+	r = iwl_read32(priv, CSR_EEPROM_REG);
 	/* check for ECC errors: */
 	otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
@@ -442,9 +442,9 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 			ret = -ENOENT;
 			goto done;
 		}
-		_iwl_write32(priv, CSR_EEPROM_GP,
-			     iwl_read32(priv, CSR_EEPROM_GP) &
-			     ~CSR_EEPROM_GP_IF_OWNER_MSK);
+		iwl_write32(priv, CSR_EEPROM_GP,
+			    iwl_read32(priv, CSR_EEPROM_GP) &
+			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
 		iwl_set_bit(priv, CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
@@ -471,8 +471,8 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			_iwl_write32(priv, CSR_EEPROM_REG,
-				     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+			iwl_write32(priv, CSR_EEPROM_REG,
+				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
 			ret = iwl_poll_bit(priv, CSR_EEPROM_REG,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
@@ -482,7 +482,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 				IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
 				goto done;
 			}
-			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
+			r = iwl_read32(priv, CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
new file mode 100644
index 0000000..5133741
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -0,0 +1,274 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include "iwl-io.h"
+
+#define IWL_POLL_INTERVAL 10	/* microseconds */
+
+static inline void __iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	iwl_write32(priv, reg, iwl_read32(priv, reg) | mask);
+}
+
+static inline void __iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	iwl_write32(priv, reg, iwl_read32(priv, reg) & ~mask);
+}
+
+void iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	__iwl_set_bit(priv, reg, mask);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+void iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	__iwl_clear_bit(priv, reg, mask);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+		 u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read32(priv, addr) & mask) == (bits & mask))
+			return t;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+int iwl_grab_nic_access(struct iwl_priv *priv)
+{
+	int ret;
+	u32 val;
+
+	lockdep_assert_held(&priv->reg_lock);
+
+	/* this bit wakes up the NIC */
+	__iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
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
+	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
+	 * and do not save/restore SRAM when power cycling.
+	 */
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
+	if (ret < 0) {
+		val = iwl_read32(priv, CSR_GP_CNTRL);
+		IWL_ERR(priv,
+			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
+		iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+void iwl_release_nic_access(struct iwl_priv *priv)
+{
+	lockdep_assert_held(&priv->reg_lock);
+	__iwl_clear_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+
+u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg)
+{
+	u32 value;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iwl_grab_nic_access(priv);
+	value = iwl_read32(priv, reg);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+
+	return value;
+}
+
+void iwl_write_direct32(struct iwl_priv *priv, u32 reg, u32 value)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	if (!iwl_grab_nic_access(priv)) {
+		iwl_write32(priv, reg, value);
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+int iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr, u32 mask,
+			int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read_direct32(priv, addr) & mask) == mask)
+			return t;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+static inline u32 __iwl_read_prph(struct iwl_priv *priv, u32 reg)
+{
+	iwl_write32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	rmb();
+	return iwl_read32(priv, HBUS_TARG_PRPH_RDAT);
+}
+
+static inline void __iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val)
+{
+	iwl_write32(priv, HBUS_TARG_PRPH_WADDR,
+		    ((addr & 0x0000FFFF) | (3 << 24)));
+	wmb();
+	iwl_write32(priv, HBUS_TARG_PRPH_WDAT, val);
+}
+
+u32 iwl_read_prph(struct iwl_priv *priv, u32 reg)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iwl_grab_nic_access(priv);
+	val = __iwl_read_prph(priv, reg);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	return val;
+}
+
+void iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	if (!iwl_grab_nic_access(priv)) {
+		__iwl_write_prph(priv, addr, val);
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+void iwl_set_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iwl_grab_nic_access(priv);
+	__iwl_write_prph(priv, reg, __iwl_read_prph(priv, reg) | mask);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
+			    u32 bits, u32 mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iwl_grab_nic_access(priv);
+	__iwl_write_prph(priv, reg,
+			 (__iwl_read_prph(priv, reg) & mask) | bits);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+void iwl_clear_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iwl_grab_nic_access(priv);
+	val = __iwl_read_prph(priv, reg);
+	__iwl_write_prph(priv, reg, (val & ~mask));
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
+{
+	unsigned long flags;
+	u32 value;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iwl_grab_nic_access(priv);
+
+	iwl_write32(priv, HBUS_TARG_MEM_RADDR, addr);
+	rmb();
+	value = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	return value;
+}
+
+void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	if (!iwl_grab_nic_access(priv)) {
+		iwl_write32(priv, HBUS_TARG_MEM_WADDR, addr);
+		wmb();
+		iwl_write32(priv, HBUS_TARG_MEM_WDAT, val);
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 3ddb2fb..ab632ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -35,494 +35,47 @@
 #include "iwl-debug.h"
 #include "iwl-devtrace.h"
 
-/*
- * IO, register, and NIC memory access functions
- *
- * NOTE on naming convention and macro usage for these
- *
- * A single _ prefix before a an access function means that no state
- * check or debug information is printed when that function is called.
- *
- * A double __ prefix before an access function means that state is checked
- * and the current line number and caller function name are printed in addition
- * to any other debug output.
- *
- * The non-prefixed name is the #define that maps the caller into a
- * #define that provides the caller's name and __LINE__ to the double
- * prefix version.
- *
- * If you wish to call the function without any debug or state checking,
- * you should use the single _ prefix version (as is used by dependent IO
- * routines, for example _iwl_read_direct32 calls the non-check version of
- * _iwl_read32.)
- *
- * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguration of the hardware I/O.  In combination with
- * git-bisect and the IO debug level you can quickly determine the specific
- * commit which breaks the IO sequence to the hardware.
- *
- */
-
-static inline void _iwl_write8(struct iwl_priv *priv, u32 ofs, u8 val)
+static inline void iwl_write8(struct iwl_priv *priv, u32 ofs, u8 val)
 {
 	trace_iwlwifi_dev_iowrite8(priv, ofs, val);
 	iowrite8(val, priv->hw_base + ofs);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write8(const char *f, u32 l, struct iwl_priv *priv,
-				 u32 ofs, u8 val)
-{
-	IWL_DEBUG_IO(priv, "write8(0x%08X, 0x%02X) - %s %d\n", ofs, val, f, l);
-	_iwl_write8(priv, ofs, val);
-}
-#define iwl_write8(priv, ofs, val) \
-	__iwl_write8(__FILE__, __LINE__, priv, ofs, val)
-#else
-#define iwl_write8(priv, ofs, val) _iwl_write8(priv, ofs, val)
-#endif
-
-
-static inline void _iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
+static inline void iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite32(priv, ofs, val);
 	iowrite32(val, priv->hw_base + ofs);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
-				 u32 ofs, u32 val)
-{
-	IWL_DEBUG_IO(priv, "write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
-	_iwl_write32(priv, ofs, val);
-}
-#define iwl_write32(priv, ofs, val) \
-	__iwl_write32(__FILE__, __LINE__, priv, ofs, val)
-#else
-#define iwl_write32(priv, ofs, val) _iwl_write32(priv, ofs, val)
-#endif
-
-static inline u32 _iwl_read32(struct iwl_priv *priv, u32 ofs)
+static inline u32 iwl_read32(struct iwl_priv *priv, u32 ofs)
 {
 	u32 val = ioread32(priv->hw_base + ofs);
 	trace_iwlwifi_dev_ioread32(priv, ofs, val);
 	return val;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
-{
-	IWL_DEBUG_IO(priv, "read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl_read32(priv, ofs);
-}
-#define iwl_read32(priv, ofs) __iwl_read32(__FILE__, __LINE__, priv, ofs)
-#else
-#define iwl_read32(p, o) _iwl_read32(p, o)
-#endif
-
-#define IWL_POLL_INTERVAL 10	/* microseconds */
-static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
-				u32 bits, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
-			return t;
-		udelay(IWL_POLL_INTERVAL);
-		t += IWL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_poll_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 addr,
-				 u32 bits, u32 mask, int timeout)
-{
-	int ret = _iwl_poll_bit(priv, addr, bits, mask, timeout);
-	IWL_DEBUG_IO(priv, "poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
-		     addr, bits, mask,
-		     unlikely(ret  == -ETIMEDOUT) ? "timeout" : "", f, l);
-	return ret;
-}
-#define iwl_poll_bit(priv, addr, bits, mask, timeout) \
-	__iwl_poll_bit(__FILE__, __LINE__, priv, addr, bits, mask, timeout)
-#else
-#define iwl_poll_bit(p, a, b, m, t) _iwl_poll_bit(p, a, b, m, t)
-#endif
-
-static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl_read32(priv, reg) | mask;
-	IWL_DEBUG_IO(priv, "set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl_write32(priv, reg, val);
-}
-static inline void iwl_set_bit(struct iwl_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	__iwl_set_bit(__FILE__, __LINE__, p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-#else
-static inline void iwl_set_bit(struct iwl_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	_iwl_set_bit(p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-#endif
-
-static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_clear_bit(const char *f, u32 l,
-				   struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl_read32(priv, reg) & ~mask;
-	IWL_DEBUG_IO(priv, "clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl_write32(priv, reg, val);
-}
-static inline void iwl_clear_bit(struct iwl_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	__iwl_clear_bit(__FILE__, __LINE__, p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-#else
-static inline void iwl_clear_bit(struct iwl_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	_iwl_clear_bit(p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-#endif
-
-static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
-{
-	int ret;
-	u32 val;
-
-	/* this bit wakes up the NIC */
-	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
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
-	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
-	 * and do not save/restore SRAM when power cycling.
-	 */
-	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
-	if (ret < 0) {
-		val = _iwl_read32(priv, CSR_GP_CNTRL);
-		IWL_ERR(priv, "MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
-		_iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_grab_nic_access(const char *f, u32 l,
-					       struct iwl_priv *priv)
-{
-	IWL_DEBUG_IO(priv, "grabbing nic access - %s %d\n", f, l);
-	return _iwl_grab_nic_access(priv);
-}
-#define iwl_grab_nic_access(priv) \
-	__iwl_grab_nic_access(__FILE__, __LINE__, priv)
-#else
-#define iwl_grab_nic_access(priv) \
-	_iwl_grab_nic_access(priv)
-#endif
-
-static inline void _iwl_release_nic_access(struct iwl_priv *priv)
-{
-	_iwl_clear_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_release_nic_access(const char *f, u32 l,
-					    struct iwl_priv *priv)
-{
-
-	IWL_DEBUG_IO(priv, "releasing nic access - %s %d\n", f, l);
-	_iwl_release_nic_access(priv);
-}
-#define iwl_release_nic_access(priv) \
-	__iwl_release_nic_access(__FILE__, __LINE__, priv)
-#else
-#define iwl_release_nic_access(priv) \
-	_iwl_release_nic_access(priv)
-#endif
-
-static inline u32 _iwl_read_direct32(struct iwl_priv *priv, u32 reg)
-{
-	return _iwl_read32(priv, reg);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_direct32(const char *f, u32 l,
-					struct iwl_priv *priv, u32 reg)
-{
-	u32 value = _iwl_read_direct32(priv, reg);
-	IWL_DEBUG_IO(priv, "read_direct32(0x%4X) = 0x%08x - %s %d\n", reg, value,
-		     f, l);
-	return value;
-}
-static inline u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg)
-{
-	u32 value;
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-	value = __iwl_read_direct32(__FILE__, __LINE__, priv, reg);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-	return value;
-}
-
-#else
-static inline u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg)
-{
-	u32 value;
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-	value = _iwl_read_direct32(priv, reg);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-	return value;
-
-}
-#endif
-
-static inline void _iwl_write_direct32(struct iwl_priv *priv,
-					 u32 reg, u32 value)
-{
-	_iwl_write32(priv, reg, value);
-}
-static inline void iwl_write_direct32(struct iwl_priv *priv, u32 reg, u32 value)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	if (!iwl_grab_nic_access(priv)) {
-		_iwl_write_direct32(priv, reg, value);
-		iwl_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
-
-static inline void iwl_write_reg_buf(struct iwl_priv *priv,
-					       u32 reg, u32 len, u32 *values)
-{
-	u32 count = sizeof(u32);
-
-	if ((priv != NULL) && (values != NULL)) {
-		for (; 0 < len; len -= count, reg += count, values++)
-			iwl_write_direct32(priv, reg, *values);
-	}
-}
-
-static inline int _iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr,
-				       u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((iwl_read_direct32(priv, addr) & mask) == mask)
-			return t;
-		udelay(IWL_POLL_INTERVAL);
-		t += IWL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_poll_direct_bit(const char *f, u32 l,
-					    struct iwl_priv *priv,
-					    u32 addr, u32 mask, int timeout)
-{
-	int ret  = _iwl_poll_direct_bit(priv, addr, mask, timeout);
-
-	if (unlikely(ret == -ETIMEDOUT))
-		IWL_DEBUG_IO(priv, "poll_direct_bit(0x%08X, 0x%08X) - "
-			     "timedout - %s %d\n", addr, mask, f, l);
-	else
-		IWL_DEBUG_IO(priv, "poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
-			     "- %s %d\n", addr, mask, ret, f, l);
-	return ret;
-}
-#define iwl_poll_direct_bit(priv, addr, mask, timeout) \
-	__iwl_poll_direct_bit(__FILE__, __LINE__, priv, addr, mask, timeout)
-#else
-#define iwl_poll_direct_bit _iwl_poll_direct_bit
-#endif
-
-static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
-{
-	_iwl_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	rmb();
-	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
-}
-static inline u32 iwl_read_prph(struct iwl_priv *priv, u32 reg)
-{
-	unsigned long reg_flags;
-	u32 val;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-	val = _iwl_read_prph(priv, reg);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-	return val;
-}
-
-static inline void _iwl_write_prph(struct iwl_priv *priv,
-					     u32 addr, u32 val)
-{
-	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
-			      ((addr & 0x0000FFFF) | (3 << 24)));
-	wmb();
-	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
-}
-
-static inline void iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val)
-{
-	unsigned long reg_flags;
+void iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask);
+void iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask);
 
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	if (!iwl_grab_nic_access(priv)) {
-		_iwl_write_prph(priv, addr, val);
-		iwl_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
+int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+		 u32 bits, u32 mask, int timeout);
+int iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr, u32 mask,
+			int timeout);
 
-#define _iwl_set_bits_prph(priv, reg, mask) \
-	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
+int iwl_grab_nic_access(struct iwl_priv *priv);
+void iwl_release_nic_access(struct iwl_priv *priv);
 
-static inline void iwl_set_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	unsigned long reg_flags;
+u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg);
+void iwl_write_direct32(struct iwl_priv *priv, u32 reg, u32 value);
 
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-	_iwl_set_bits_prph(priv, reg, mask);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
 
-#define _iwl_set_bits_mask_prph(priv, reg, bits, mask) \
-	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
+u32 iwl_read_prph(struct iwl_priv *priv, u32 reg);
+void iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val);
+void iwl_set_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask);
+void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
+			    u32 bits, u32 mask);
+void iwl_clear_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask);
 
-static inline void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
-				u32 bits, u32 mask)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
-
-static inline void iwl_clear_bits_prph(struct iwl_priv
-						 *priv, u32 reg, u32 mask)
-{
-	unsigned long reg_flags;
-	u32 val;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-	val = _iwl_read_prph(priv, reg);
-	_iwl_write_prph(priv, reg, (val & ~mask));
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
-
-static inline u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
-{
-	unsigned long reg_flags;
-	u32 value;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
-
-	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
-	value = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-	return value;
-}
-
-static inline void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	if (!iwl_grab_nic_access(priv)) {
-		_iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-		_iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
-		iwl_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
-
-static inline void iwl_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
-					  u32 len, u32 *values)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	if (!iwl_grab_nic_access(priv)) {
-		_iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-		for (; 0 < len; len -= sizeof(u32), values++)
-			_iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
-
-		iwl_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
-}
+u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr);
+void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val);
 #endif
-- 
1.7.0.4

