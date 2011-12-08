Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1LHWXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 17:23:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: gregkh@suse.de
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.0] iwlwifi: do not re-configure HT40 after associated
Date: Thu,  8 Dec 2011 13:25:16 -0800
Message-Id: <1323379516-26015-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111208_232354_253828_A1761E76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ht40 setting should not change after association unless channel switch

This fix a problem we are seeing which cause uCode assert because driver
sending invalid information and make uCode confuse

Here is the firmware assert message:
kernel: iwlagn 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
kernel: iwlagn 0000:03:00.0: Loaded firmware version: 17.168.5.3 build 42301
kernel: iwlagn 0000:03:00.0: Start IWL Error Log Dump:
kernel: iwlagn 0000:03:00.0: Status: 0x000512E4, count: 6
kernel: iwlagn 0000:03:00.0: 0x00002078 | ADVANCED_SYSASSERT
kernel: iwlagn 0000:03:00.0: 0x00009514 | uPc
kernel: iwlagn 0000:03:00.0: 0x00009496 | branchlink1
kernel: iwlagn 0000:03:00.0: 0x00009496 | branchlink2
kernel: iwlagn 0000:03:00.0: 0x0000D1F2 | interruptlink1
kernel: iwlagn 0000:03:00.0: 0x00000000 | interruptlink2
kernel: iwlagn 0000:03:00.0: 0x01008035 | data1
kernel: iwlagn 0000:03:00.0: 0x0000C90F | data2
kernel: iwlagn 0000:03:00.0: 0x000005A7 | line
kernel: iwlagn 0000:03:00.0: 0x5080B520 | beacon time
kernel: iwlagn 0000:03:00.0: 0xCC515AE0 | tsf low
kernel: iwlagn 0000:03:00.0: 0x00000003 | tsf hi
kernel: iwlagn 0000:03:00.0: 0x00000000 | time gp1
kernel: iwlagn 0000:03:00.0: 0x29703BF0 | time gp2
kernel: iwlagn 0000:03:00.0: 0x00000000 | time gp3
kernel: iwlagn 0000:03:00.0: 0x000111A8 | uCode version
kernel: iwlagn 0000:03:00.0: 0x000000B0 | hw version
kernel: iwlagn 0000:03:00.0: 0x00480303 | board version
kernel: iwlagn 0000:03:00.0: 0x09E8004E | hcmd
kernel: iwlagn 0000:03:00.0: CSR values:
kernel: iwlagn 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
kernel: iwlagn 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480303
kernel: iwlagn 0000:03:00.0:          CSR_INT_COALESCING: 0X0000ff40
kernel: iwlagn 0000:03:00.0:                     CSR_INT: 0X00000000
kernel: iwlagn 0000:03:00.0:                CSR_INT_MASK: 0X00000000
kernel: iwlagn 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
kernel: iwlagn 0000:03:00.0:                 CSR_GPIO_IN: 0X00000030
kernel: iwlagn 0000:03:00.0:                   CSR_RESET: 0X00000000
kernel: iwlagn 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
kernel: iwlagn 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
kernel: iwlagn 0000:03:00.0:              CSR_EEPROM_REG: 0X07d60ffd
kernel: iwlagn 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
kernel: iwlagn 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
kernel: iwlagn 0000:03:00.0:                 CSR_GIO_REG: 0X00080044
kernel: iwlagn 0000:03:00.0:            CSR_GP_UCODE_REG: 0X000093bb
kernel: iwlagn 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
kernel: iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
kernel: iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
kernel: iwlagn 0000:03:00.0:                 CSR_LED_REG: 0X00000078
kernel: iwlagn 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88214dd2
kernel: iwlagn 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
kernel: iwlagn 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
kernel: iwlagn 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
kernel: iwlagn 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
kernel: iwlagn 0000:03:00.0: FH register values:
kernel: iwlagn 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21316d00
kernel: iwlagn 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X021479c0
kernel: iwlagn 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000060
kernel: iwlagn 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
kernel: iwlagn 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
kernel: iwlagn 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
kernel: iwlagn 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
kernel: iwlagn 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
kernel: iwlagn 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
kernel: iwlagn 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
kernel: ------------[ cut here ]------------
WARNING: at net/mac80211/util.c:1208 ieee80211_reconfig+0x1f1/0x407()
kernel: Hardware name: 4290W4H
kernel: Pid: 1896, comm: kworker/0:0 Not tainted 3.1.0 #2
kernel: Call Trace:
kernel:  [<ffffffff81036558>] ? warn_slowpath_common+0x73/0x87
kernel:  [<ffffffff813b8966>] ? ieee80211_reconfig+0x1f1/0x407
kernel:  [<ffffffff8139e8dc>] ? ieee80211_recalc_smps_work+0x32/0x32
kernel:  [<ffffffff8139e95a>] ? ieee80211_restart_work+0x7e/0x87
kernel:  [<ffffffff810472fa>] ? process_one_work+0x1c8/0x2e3
kernel:  [<ffffffff810480c9>] ? worker_thread+0x17a/0x23a
kernel:  [<ffffffff81047f4f>] ? manage_workers.clone.18+0x15b/0x15b
kernel:  [<ffffffff81047f4f>] ? manage_workers.clone.18+0x15b/0x15b
kernel:  [<ffffffff8104ba97>] ? kthread+0x7a/0x82
kernel:  [<ffffffff813d21b4>] ? kernel_thread_helper+0x4/0x10
kernel:  [<ffffffff8104ba1d>] ? kthread_flush_work_fn+0x11/0x11
kernel:  [<ffffffff813d21b0>] ? gs_change+0xb/0xb

Cc: <stable@vger.kernel.org> 3.0
Reported-by: Udo Steinberg <udo@hypervisor.org>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
This patch is for kernel 3.0 only since the orig. patch does not apply
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   36 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   18 ++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 09f679d..b849ad7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -411,6 +411,24 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	return 0;
 }
 
+void iwlagn_config_ht40(struct ieee80211_conf *conf,
+	struct iwl_rxon_context *ctx)
+{
+	if (conf_is_ht40_minus(conf)) {
+		ctx->ht.extension_chan_offset =
+			IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		ctx->ht.is_40mhz = true;
+	} else if (conf_is_ht40_plus(conf)) {
+		ctx->ht.extension_chan_offset =
+			IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		ctx->ht.is_40mhz = true;
+	} else {
+		ctx->ht.extension_chan_offset =
+			IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		ctx->ht.is_40mhz = false;
+	}
+}
+
 int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -470,19 +488,11 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 				ctx->ht.enabled = conf_is_ht(conf);
 
 			if (ctx->ht.enabled) {
-				if (conf_is_ht40_minus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ctx->ht.is_40mhz = true;
-				} else if (conf_is_ht40_plus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ctx->ht.is_40mhz = true;
-				} else {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ctx->ht.is_40mhz = false;
-				}
+				/* if HT40 is used, it should not change
+				 * after associated except channel switch */
+				if (iwl_is_associated_ctx(ctx) &&
+				     !ctx->ht.is_40mhz)
+					iwlagn_config_ht40(conf, ctx);
 			} else
 				ctx->ht.is_40mhz = false;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8e1942e..d690708 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2867,21 +2867,9 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 
 			/* Configure HT40 channels */
 			ctx->ht.enabled = conf_is_ht(conf);
-			if (ctx->ht.enabled) {
-				if (conf_is_ht40_minus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ctx->ht.is_40mhz = true;
-				} else if (conf_is_ht40_plus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ctx->ht.is_40mhz = true;
-				} else {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ctx->ht.is_40mhz = false;
-				}
-			} else
+			if (ctx->ht.enabled)
+				iwlagn_config_ht40(conf, ctx);
+			else
 				ctx->ht.is_40mhz = false;
 
 			if ((le16_to_cpu(ctx->staging.channel) != ch))
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d171684..5a0acab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -152,6 +152,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *bss_conf,
 			     u32 changes);
+void iwlagn_config_ht40(struct ieee80211_conf *conf,
+			struct iwl_rxon_context *ctx);
 
 /* uCode */
 void iwlagn_rx_calib_result(struct iwl_priv *priv,
-- 
1.7.0.4

