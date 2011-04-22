Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab1DVRzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlagn: simplify error table reading
Date: Fri, 22 Apr 2011 10:33:09 -0700
Message-Id: <1303493598-10979-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current code to read the error table header
just hardcodes all the offsets, which is a bit
hard to understand. We can read in the entire
header (as much as we need) into a structure,
and then take the data from there, which makes
it easier to understand. To read a bigger blob
we also don't need to grab NIC access for each
word read, making the code more efficient.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   27 +++++----
 drivers/net/wireless/iwlwifi/iwl-commands.h |   90 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-io.c       |   18 +++++-
 drivers/net/wireless/iwlwifi/iwl-io.h       |   10 +++
 4 files changed, 91 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cdeb09e..f8559cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1878,6 +1878,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
 	u32 pc, hcmd;
+	struct iwl_error_event_table table;
 
 	base = priv->device_pointers.error_event_table;
 	if (priv->ucode_type == UCODE_INIT) {
@@ -1895,7 +1896,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	count = iwl_read_targ_mem(priv, base);
+	iwl_read_targ_mem_words(priv, base, &table, sizeof(table));
+
+	count = table.valid;
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
@@ -1903,18 +1906,18 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 			priv->status, count);
 	}
 
-	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	desc = table.error_id;
 	priv->isr_stats.err_code = desc;
-	pc = iwl_read_targ_mem(priv, base + 2 * sizeof(u32));
-	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
-	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
-	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
-	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
-	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
-	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
-	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
-	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
-	hcmd = iwl_read_targ_mem(priv, base + 22 * sizeof(u32));
+	pc = table.pc;
+	blink1 = table.blink1;
+	blink2 = table.blink2;
+	ilink1 = table.ilink1;
+	ilink2 = table.ilink2;
+	data1 = table.data1;
+	data2 = table.data2;
+	line = table.line;
+	time = table.tsf_low;
+	hcmd = table.hcmd;
 
 	trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, data2, line,
 				      blink1, blink2, ilink1, ilink2);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0edba8a..7aea7b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -422,49 +422,61 @@ struct iwl_tx_ant_config_cmd {
  *
  * 2)  error_event_table_ptr indicates base of the error log.  This contains
  *     information about any uCode error that occurs.  For agn, the format
- *     of the error log is:
- *
- *	__le32 valid;        (nonzero) valid, (0) log is empty
- *	__le32 error_id;     type of error
- *	__le32 pc;           program counter
- *	__le32 blink1;       branch link
- *	__le32 blink2;       branch link
- *	__le32 ilink1;       interrupt link
- *	__le32 ilink2;       interrupt link
- *	__le32 data1;        error-specific data
- *	__le32 data2;        error-specific data
- *	__le32 line;         source code line of error
- *	__le32 bcon_time;    beacon timer
- *	__le32 tsf_low;      network timestamp function timer
- *	__le32 tsf_hi;       network timestamp function timer
- *	__le32 gp1;          GP1 timer register
- *	__le32 gp2;          GP2 timer register
- *	__le32 gp3;          GP3 timer register
- *	__le32 ucode_ver;    uCode version
- *	__le32 hw_ver;       HW Silicon version
- *	__le32 brd_ver;      HW board version
- *	__le32 log_pc;       log program counter
- *	__le32 frame_ptr;    frame pointer
- *	__le32 stack_ptr;    stack pointer
- *	__le32 hcmd;         last host command
- *	__le32 isr0;         isr status register LMPM_NIC_ISR0: rxtx_flag
- *	__le32 isr1;         isr status register LMPM_NIC_ISR1: host_flag
- *	__le32 isr2;         isr status register LMPM_NIC_ISR2: enc_flag
- *	__le32 isr3;         isr status register LMPM_NIC_ISR3: time_flag
- *	__le32 isr4;         isr status register LMPM_NIC_ISR4: wico interrupt
- *	__le32 isr_pref;     isr status register LMPM_NIC_PREF_STAT
- *	__le32 wait_event;   wait event() caller address
- *	__le32 l2p_control;  L2pControlField
- *	__le32 l2p_duration; L2pDurationField
- *	__le32 l2p_mhvalid;  L2pMhValidBits
- *	__le32 l2p_addr_match; L2pAddrMatchStat
- *	__le32 lmpm_pmg_sel; indicate which clocks are turned on (LMPM_PMG_SEL)
- *	__le32 u_timestamp;  indicate when the date and time of the compilation
- *	__le32 reserved;
+ *     of the error log is defined by struct iwl_error_event_table.
  *
  * The Linux driver can print both logs to the system log when a uCode error
  * occurs.
  */
+
+/*
+ * Note: This structure is read from the device with IO accesses,
+ * and the reading already does the endian conversion. As it is
+ * read with u32-sized accesses, any members with a different size
+ * need to be ordered correctly though!
+ */
+struct iwl_error_event_table {
+	u32 valid;		/* (nonzero) valid, (0) log is empty */
+	u32 error_id;		/* type of error */
+	u32 pc;			/* program counter */
+	u32 blink1;		/* branch link */
+	u32 blink2;		/* branch link */
+	u32 ilink1;		/* interrupt link */
+	u32 ilink2;		/* interrupt link */
+	u32 data1;		/* error-specific data */
+	u32 data2;		/* error-specific data */
+	u32 line;		/* source code line of error */
+	u32 bcon_time;		/* beacon timer */
+	u32 tsf_low;		/* network timestamp function timer */
+	u32 tsf_hi;		/* network timestamp function timer */
+	u32 gp1;		/* GP1 timer register */
+	u32 gp2;		/* GP2 timer register */
+	u32 gp3;		/* GP3 timer register */
+	u32 ucode_ver;		/* uCode version */
+	u32 hw_ver;		/* HW Silicon version */
+	u32 brd_ver;		/* HW board version */
+	u32 log_pc;		/* log program counter */
+	u32 frame_ptr;		/* frame pointer */
+	u32 stack_ptr;		/* stack pointer */
+	u32 hcmd;		/* last host command header */
+#if 0
+	/* no need to read the remainder, we don't use the values */
+	u32 isr0;		/* isr status register LMPM_NIC_ISR0: rxtx_flag */
+	u32 isr1;		/* isr status register LMPM_NIC_ISR1: host_flag */
+	u32 isr2;		/* isr status register LMPM_NIC_ISR2: enc_flag */
+	u32 isr3;		/* isr status register LMPM_NIC_ISR3: time_flag */
+	u32 isr4;		/* isr status register LMPM_NIC_ISR4: wico interrupt */
+	u32 isr_pref;		/* isr status register LMPM_NIC_PREF_STAT */
+	u32 wait_event;		/* wait event() caller address */
+	u32 l2p_control;	/* L2pControlField */
+	u32 l2p_duration;	/* L2pDurationField */
+	u32 l2p_mhvalid;	/* L2pMhValidBits */
+	u32 l2p_addr_match;	/* L2pAddrMatchStat */
+	u32 lmpm_pmg_sel;	/* indicate which clocks are turned on (LMPM_PMG_SEL) */
+	u32 u_timestamp;	/* indicate when the date and time of the compilation */
+	u32 flow_handler;	/* FH read/write pointers, RX credit */
+#endif
+} __packed;
+
 struct iwl_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 5133741..993b3df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -242,20 +242,32 @@ void iwl_clear_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
 	spin_unlock_irqrestore(&priv->reg_lock, flags);
 }
 
-u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
+void _iwl_read_targ_mem_words(struct iwl_priv *priv, u32 addr,
+			      void *buf, int words)
 {
 	unsigned long flags;
-	u32 value;
+	int offs;
+	u32 *vals = buf;
 
 	spin_lock_irqsave(&priv->reg_lock, flags);
 	iwl_grab_nic_access(priv);
 
 	iwl_write32(priv, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
-	value = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+
+	for (offs = 0; offs < words; offs++)
+		vals[offs] = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
 
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
+{
+	u32 value;
+
+	_iwl_read_targ_mem_words(priv, addr, &value, 1);
+
 	return value;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index ab632ba..262e026 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -76,6 +76,16 @@ void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
 			    u32 bits, u32 mask);
 void iwl_clear_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask);
 
+void _iwl_read_targ_mem_words(struct iwl_priv *priv, u32 addr,
+			      void *buf, int words);
+
+#define iwl_read_targ_mem_words(priv, addr, buf, bufsize)	\
+	do {							\
+		BUILD_BUG_ON((bufsize) % sizeof(u32));		\
+		_iwl_read_targ_mem_words(priv, addr, buf,	\
+					 (bufsize) / sizeof(u32));\
+	} while (0)
+
 u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr);
 void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val);
 #endif
-- 
1.7.0.4

