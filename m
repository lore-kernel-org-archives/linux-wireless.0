Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1LIBZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/15] iwlwifi: Display more uCode debug info
Date: Thu,  8 Dec 2011 16:26:10 -0800
Message-Id: <1323390382-1678-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022513_838273_FE12C8F3)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When uCode encounter problem, it pass a lot of debug data to help debugging
the issue. We only show partial data before, why not display all of those.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   24 ++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   15 +++++++++++++
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index f4eccf5..d98d09c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -466,23 +466,27 @@ struct iwl_error_event_table {
 	u32 frame_ptr;		/* frame pointer */
 	u32 stack_ptr;		/* stack pointer */
 	u32 hcmd;		/* last host command header */
-#if 0
-	/* no need to read the remainder, we don't use the values */
-	u32 isr0;		/* isr status register LMPM_NIC_ISR0: rxtx_flag */
-	u32 isr1;		/* isr status register LMPM_NIC_ISR1: host_flag */
-	u32 isr2;		/* isr status register LMPM_NIC_ISR2: enc_flag */
-	u32 isr3;		/* isr status register LMPM_NIC_ISR3: time_flag */
-	u32 isr4;		/* isr status register LMPM_NIC_ISR4: wico interrupt */
+	u32 isr0;		/* isr status register LMPM_NIC_ISR0:
+				 * rxtx_flag */
+	u32 isr1;		/* isr status register LMPM_NIC_ISR1:
+				 * host_flag */
+	u32 isr2;		/* isr status register LMPM_NIC_ISR2:
+				 * enc_flag */
+	u32 isr3;		/* isr status register LMPM_NIC_ISR3:
+				 * time_flag */
+	u32 isr4;		/* isr status register LMPM_NIC_ISR4:
+				 * wico interrupt */
 	u32 isr_pref;		/* isr status register LMPM_NIC_PREF_STAT */
 	u32 wait_event;		/* wait event() caller address */
 	u32 l2p_control;	/* L2pControlField */
 	u32 l2p_duration;	/* L2pDurationField */
 	u32 l2p_mhvalid;	/* L2pMhValidBits */
 	u32 l2p_addr_match;	/* L2pAddrMatchStat */
-	u32 lmpm_pmg_sel;	/* indicate which clocks are turned on (LMPM_PMG_SEL) */
-	u32 u_timestamp;	/* indicate when the date and time of the compilation */
+	u32 lmpm_pmg_sel;	/* indicate which clocks are turned on
+				 * (LMPM_PMG_SEL) */
+	u32 u_timestamp;	/* indicate when the date and time of the
+				 * compilation */
 	u32 flow_handler;	/* FH read/write pointers, RX credit */
-#endif
 } __packed;
 
 struct iwl_alive_resp {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index becd921..a0d43d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -648,6 +648,21 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 	IWL_ERR(trans, "0x%08X | hw version\n", table.hw_ver);
 	IWL_ERR(trans, "0x%08X | board version\n", table.brd_ver);
 	IWL_ERR(trans, "0x%08X | hcmd\n", table.hcmd);
+
+	IWL_ERR(trans, "0x%08X | isr0\n", table.isr0);
+	IWL_ERR(trans, "0x%08X | isr1\n", table.isr1);
+	IWL_ERR(trans, "0x%08X | isr2\n", table.isr2);
+	IWL_ERR(trans, "0x%08X | isr3\n", table.isr3);
+	IWL_ERR(trans, "0x%08X | isr4\n", table.isr4);
+	IWL_ERR(trans, "0x%08X | isr_pref\n", table.isr_pref);
+	IWL_ERR(trans, "0x%08X | wait_event\n", table.wait_event);
+	IWL_ERR(trans, "0x%08X | l2p_control\n", table.l2p_control);
+	IWL_ERR(trans, "0x%08X | l2p_duration\n", table.l2p_duration);
+	IWL_ERR(trans, "0x%08X | l2p_mhvalid\n", table.l2p_mhvalid);
+	IWL_ERR(trans, "0x%08X | l2p_addr_match\n", table.l2p_addr_match);
+	IWL_ERR(trans, "0x%08X | lmpm_pmg_sel\n", table.lmpm_pmg_sel);
+	IWL_ERR(trans, "0x%08X | timestamp\n", table.u_timestamp);
+	IWL_ERR(trans, "0x%08X | flow_handler\n", table.flow_handler);
 }
 
 /**
-- 
1.7.0.4

