Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab0DIUJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/12] iwlwifi: add more debug info in error event dump
Date: Fri,  9 Apr 2010 13:09:24 -0700
Message-Id: <1270843769-30017-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When sys assert happen, driver will dump the error table information
provided by uCode. There are more information available but is not being
display by the driver; adding program counter and last host command the
to log to help uCode debugging.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-commands.h |   27 ++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3526d5e..8a002c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1843,6 +1843,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 data2, line;
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
+	u32 pc, hcmd;
 
 	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
@@ -1865,6 +1866,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	}
 
 	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	pc = iwl_read_targ_mem(priv, base + 2 * sizeof(u32));
 	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
 	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
 	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
@@ -1873,6 +1875,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
 	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
 	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
+	hcmd = iwl_read_targ_mem(priv, base + 22 * sizeof(u32));
 
 	trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, data2, line,
 				      blink1, blink2, ilink1, ilink2);
@@ -1881,10 +1884,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		"data1      data2      line\n");
 	IWL_ERR(priv, "%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
 		desc_lookup(desc), desc, time, data1, data2, line);
-	IWL_ERR(priv, "blink1  blink2  ilink1  ilink2\n");
-	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
-		ilink1, ilink2);
-
+	IWL_ERR(priv, "pc      blink1  blink2  ilink1  ilink2  hcmd\n");
+	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X 0x%05X 0x%05X\n",
+		pc, blink1, blink2, ilink1, ilink2, hcmd);
 }
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6383d9f..74d6887 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -512,8 +512,9 @@ struct iwl_init_alive_resp {
  *
  *     Entries without timestamps contain only event_id and data.
  *
+ *
  * 2)  error_event_table_ptr indicates base of the error log.  This contains
- *     information about any uCode error that occurs.  For 4965, the format
+ *     information about any uCode error that occurs.  For agn, the format
  *     of the error log is:
  *
  *	__le32 valid;        (nonzero) valid, (0) log is empty
@@ -529,6 +530,30 @@ struct iwl_init_alive_resp {
  *	__le32 bcon_time;    beacon timer
  *	__le32 tsf_low;      network timestamp function timer
  *	__le32 tsf_hi;       network timestamp function timer
+ *	__le32 gp1;          GP1 timer register
+ *	__le32 gp2;          GP2 timer register
+ *	__le32 gp3;          GP3 timer register
+ *	__le32 ucode_ver;    uCode version
+ *	__le32 hw_ver;       HW Silicon version
+ *	__le32 brd_ver;      HW board version
+ *	__le32 log_pc;       log program counter
+ *	__le32 frame_ptr;    frame pointer
+ *	__le32 stack_ptr;    stack pointer
+ *	__le32 hcmd;         last host command
+ *	__le32 isr0;         isr status register LMPM_NIC_ISR0: rxtx_flag
+ *	__le32 isr1;         isr status register LMPM_NIC_ISR1: host_flag
+ *	__le32 isr2;         isr status register LMPM_NIC_ISR2: enc_flag
+ *	__le32 isr3;         isr status register LMPM_NIC_ISR3: time_flag
+ *	__le32 isr4;         isr status register LMPM_NIC_ISR4: wico interrupt
+ *	__le32 isr_pref;     isr status register LMPM_NIC_PREF_STAT
+ *	__le32 wait_event;   wait event() caller address
+ *	__le32 l2p_control;  L2pControlField
+ *	__le32 l2p_duration; L2pDurationField
+ *	__le32 l2p_mhvalid;  L2pMhValidBits
+ *	__le32 l2p_addr_match; L2pAddrMatchStat
+ *	__le32 lmpm_pmg_sel; indicate which clocks are turned on (LMPM_PMG_SEL)
+ *	__le32 u_timestamp;  indicate when the date and time of the compilation
+ *	__le32 reserved;
  *
  * The Linux driver can print both logs to the system log when a uCode error
  * occurs.
-- 
1.6.3.3

