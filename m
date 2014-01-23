Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:58016 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752063AbaAWJzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:55:55 -0500
Date: Thu, 23 Jan 2014 11:16:59 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: linux-wireless@vger.kernel.org
Cc: ilw@linux.intel.com, Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: iwlwifi crash with 3.13
Message-ID: <20140123091659.GE9077@localhost> (sfid-20140123_105605_166785_1F7D8D24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi guys,

Connecting to 5GHz router with my iwlwifi (on Yoga 2 Pro, 3.13 kernel) seems to work fine, but 'dmesg' doesn't look pretty.  This is what 
'lspci' say about the actual controller: Intel Corporation Wireless 7260 (rev 6b).

IIRC this was going on with 3.11.y and 3.12.y as well.  Please let me know if i can help with anything else.


cheers,
Petko


--- part_of_dmesg ---

iwlwifi 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
iwlwifi 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
wlan0: associate with 00:25:9c:24:d5:4c (try 1/3)
wlan0: RX AssocResp from 00:25:9c:24:d5:4c (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:25:9c:24:d5:4c by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
wlan0: authenticate with 00:25:9c:24:d5:4d
wlan0: send auth to 00:25:9c:24:d5:4d (try 1/3)
wlan0: authenticated
wlan0: associate with 00:25:9c:24:d5:4d (try 1/3)
wlan0: RX AssocResp from 00:25:9c:24:d5:4d (capab=0x11 status=0 aid=1)
iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:01:00.0: CSR values:
iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255254
iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
iwlwifi 0000:01:00.0: FH register values:
iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X25538700
iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X025576d0
iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000038
iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:01:00.0: FW error in SYNC CMD PHY_CONTEXT_CMD
CPU: 3 PID: 6 Comm: kworker/u8:0 Not tainted 3.13.0 #2
Hardware name: LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
Workqueue: phy0 ieee80211_iface_work
 ffff880254037218 ffffffff814e7ea2 ffff880254034000 ffffffffa000c755
 ffff8802560ef7b0 00000008560ef868 0000000000000000 ffff8802560ca0d0
 ffffffff81074510 ffff8802560ef758 ffff8802560ef758 ffff8802560ef7b0
Call Trace:
 [<ffffffff814e7ea2>] ? dump_stack+0x41/0x51
 [<ffffffffa000c755>] ? iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]
 [<ffffffff81074510>] ? prepare_to_wait_event+0xf0/0xf0
 [<ffffffffa00345d8>] ? iwl_mvm_send_cmd+0x18/0x60 [iwlmvm]
 [<ffffffffa003465c>] ? iwl_mvm_send_cmd_pdu+0x3c/0x50 [iwlmvm]
 [<ffffffffa0032d11>] ? iwl_mvm_phy_ctxt_apply.constprop.5+0x111/0x230 [iwlmvm]
 [<ffffffffa002fc5b>] ? iwl_mvm_change_chanctx+0x6b/0xb0 [iwlmvm]
 [<ffffffff814d3916>] ? ieee80211_recalc_smps+0x36/0x70
 [<ffffffff814e9d97>] ? ieee80211_assoc_success+0x694/0x9b6
 [<ffffffff8107745f>] ? msg_print_text+0xdf/0x1d0
 [<ffffffff810752cd>] ? up+0xd/0x40
 [<ffffffff81078247>] ? console_unlock+0x267/0x3d0
 [<ffffffff814d9941>] ? ieee80211_rx_mgmt_assoc_resp+0x111/0x210
 [<ffffffff814d9eb4>] ? ieee80211_sta_rx_queued_mgmt+0x154/0x540
 [<ffffffff81070e25>] ? load_balance+0x155/0x850
 [<ffffffff814bda1b>] ? ieee80211_iface_work+0x24b/0x350
 [<ffffffff810591fc>] ? process_one_work+0x13c/0x3c0
 [<ffffffff81059d66>] ? worker_thread+0x116/0x3a0
iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
iwlwifi 0000:01:00.0: 0x000014FE | ADVANCED_SYSASSERT          
iwlwifi 0000:01:00.0: 0x00A00220 | uPc
iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
 [<ffffffff81059c50>] ? manage_workers.isra.30+0x280/0x280
iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
 [<ffffffff8105f061>] ? kthread+0xc1/0xe0
 [<ffffffff8105efa0>] ? kthread_create_on_node+0x180/0x180
 [<ffffffff814ee53c>] ? ret_from_fork+0x7c/0xb0
iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
 [<ffffffff8105efa0>] ? kthread_create_on_node+0x180/0x180
iwlwifi 0000:01:00.0: PHY ctxt cmd error. ret=-5
iwlwifi 0000:01:00.0: 0x001B20FB | interruptlink2
iwlwifi 0000:01:00.0: 0x00000000 | data1
iwlwifi 0000:01:00.0: 0x00000005 | data2
iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
iwlwifi 0000:01:00.0: 0x00002A4A | beacon time
iwlwifi 0000:01:00.0: 0x01C7F4F1 | tsf low
iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
iwlwifi 0000:01:00.0: 0x00000000 | time gp1
iwlwifi 0000:01:00.0: 0x0037F4BA | time gp2
iwlwifi 0000:01:00.0: 0x00000000 | time gp3
iwlwifi 0000:01:00.0: 0x00321600 | uCode version
iwlwifi 0000:01:00.0: 0x00000144 | hw version
iwlwifi 0000:01:00.0: 0x00489204 | board version
iwlwifi 0000:01:00.0: 0x09280008 | hcmd
iwlwifi 0000:01:00.0: 0x24022080 | isr0
iwlwifi 0000:01:00.0: 0x01000000 | isr1
iwlwifi 0000:01:00.0: 0x00000002 | isr2
iwlwifi 0000:01:00.0: 0x0041FCC0 | isr3
iwlwifi 0000:01:00.0: 0x00000001 | isr4
iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
iwlwifi 0000:01:00.0: 0x00027C32 | wait_event
iwlwifi 0000:01:00.0: 0x00000010 | l2p_control
iwlwifi 0000:01:00.0: 0x00018030 | l2p_duration
iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
iwlwifi 0000:01:00.0: 0x000000CF | l2p_addr_match
iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
iwlwifi 0000:01:00.0: 0x17061625 | timestamp
iwlwifi 0000:01:00.0: 0x00003840 | flow_handler
ieee80211 phy0: Hardware restart was requested
wlan0: associated
iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:01:00.0: CSR values:
iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255254
iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
iwlwifi 0000:01:00.0: FH register values:
iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X25538700
iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X025576d0
iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000060
iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:01:00.0: FW error in SYNC CMD PHY_CONTEXT_CMD
CPU: 2 PID: 9384 Comm: kworker/u8:1 Not tainted 3.13.0 #2
Hardware name: LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
Workqueue: phy0 ieee80211_recalc_smps_work
 ffff880254037218 ffffffff814e7ea2 ffff880254034000 ffffffffa000c755
 ffff880254151d50 0000001e00000001 ffff880200000000 ffff880256394ec0
 ffffffff81074510 ffff880254151cf8 ffff880254151cf8 ffff880254151d50
Call Trace:
 [<ffffffff814e7ea2>] ? dump_stack+0x41/0x51
 [<ffffffffa000c755>] ? iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]
 [<ffffffff81074510>] ? prepare_to_wait_event+0xf0/0xf0
 [<ffffffffa00345d8>] ? iwl_mvm_send_cmd+0x18/0x60 [iwlmvm]
 [<ffffffffa003465c>] ? iwl_mvm_send_cmd_pdu+0x3c/0x50 [iwlmvm]
 [<ffffffff814ecb5a>] ? __mutex_lock_slowpath+0x13a/0x1b0
 [<ffffffffa0032d11>] ? iwl_mvm_phy_ctxt_apply.constprop.5+0x111/0x230 [iwlmvm]
 [<ffffffffa002fc5b>] ? iwl_mvm_change_chanctx+0x6b/0xb0 [iwlmvm]
 [<ffffffff814d3916>] ? ieee80211_recalc_smps+0x36/0x70
 [<ffffffff810591fc>] ? process_one_work+0x13c/0x3c0
 [<ffffffff81059d66>] ? worker_thread+0x116/0x3a0
 [<ffffffff81059c50>] ? manage_workers.isra.30+0x280/0x280
 [<ffffffff8105f061>] ? kthread+0xc1/0xe0
 [<ffffffff8105efa0>] ? kthread_create_on_node+0x180/0x180
 [<ffffffff814ee53c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8105efa0>] ? kthread_create_on_node+0x180/0x180
iwlwifi 0000:01:00.0: PHY ctxt cmd error. ret=-5
iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
iwlwifi 0000:01:00.0: 0x000014FE | ADVANCED_SYSASSERT          
iwlwifi 0000:01:00.0: 0x00000220 | uPc
iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
iwlwifi 0000:01:00.0: 0x001B20FB | interruptlink2
iwlwifi 0000:01:00.0: 0x00000000 | data1
iwlwifi 0000:01:00.0: 0x00000005 | data2
iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
iwlwifi 0000:01:00.0: 0x5041464A | beacon time
iwlwifi 0000:01:00.0: 0x4E8A8A49 | tsf low
iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
iwlwifi 0000:01:00.0: 0x00000000 | time gp1
iwlwifi 0000:01:00.0: 0x4CF50993 | time gp2
iwlwifi 0000:01:00.0: 0x00000000 | time gp3
iwlwifi 0000:01:00.0: 0x00321600 | uCode version
iwlwifi 0000:01:00.0: 0x00000144 | hw version
iwlwifi 0000:01:00.0: 0x00489204 | board version
iwlwifi 0000:01:00.0: 0x097E0008 | hcmd
iwlwifi 0000:01:00.0: 0x24022080 | isr0
iwlwifi 0000:01:00.0: 0x00000000 | isr1
iwlwifi 0000:01:00.0: 0x00000002 | isr2
iwlwifi 0000:01:00.0: 0x00405CC0 | isr3
iwlwifi 0000:01:00.0: 0x00000001 | isr4
iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
iwlwifi 0000:01:00.0: 0x00014D9A | wait_event
iwlwifi 0000:01:00.0: 0x000000D4 | l2p_control
iwlwifi 0000:01:00.0: 0x00018030 | l2p_duration
iwlwifi 0000:01:00.0: 0x00000007 | l2p_mhvalid
iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
iwlwifi 0000:01:00.0: 0x17061625 | timestamp
iwlwifi 0000:01:00.0: 0x00006068 | flow_handler
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S

