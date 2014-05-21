Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:52775 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaEUGlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 02:41:14 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-wireless@vger.kernel.org
Date: Wed, 21 May 2014 08:28:55 +0200
MIME-Version: 1.0
Message-ID: <m3k39fmyqg.fsf@t19.piap.pl> (sfid-20140521_084120_405680_24F6E838)
Content-Type: text/plain
Subject: iwlwifi Microcode SW error and subsequent WARNINGs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having problems with an Intel Corporation Wireless 7260 (rev 6b)
adapter running in ad hoc mode. Any ideas?

The hardware is Getac F110 tablet, Core i5 Haswell. I've tried to use
Linux v. 3.13, 3.14, 3.15-rc5+ with microcode v. 22.24.8.0 and
23.214.9.0.

What I'm trying to do is:

# iwconfig wlan0 mode ad-hoc essid xxx txpower 16 channel 11
# ip link set up dev wlan0
# sleep 1
# iwconfig wlan0 mode ad-hoc essid xxx txpower 16 channel 11 rate 6M
# sleep 10
# iwconfig wlan0 mode ad-hoc essid xxx txpower 16 channel 11 rate 6M

wlan0 works in ad hoc mode after "sleep 10" and subsequent iwconfig.

0b:00.0 0280: 8086:08b1 Network controller: Intel Corporation Wireless 7260 (rev 6b)
        Subsystem: 8086:c070 Intel Corporation Dual Band Wireless-AC 7260
        Flags: bus master, fast devsel, latency 0, IRQ 59
        Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [40] Express Endpoint, MSI 00

iwlwifi 0000:0b:00.0: irq 59 for MSI/MSI-X
iwlwifi 0000:0b:00.0: loaded firmware version 23.214.9.0 op_mode iwlmvm
iwlwifi 0000:0b:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:0b:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:0b:00.0: CSR values:
iwlwifi 0000:0b:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
iwlwifi 0000:0b:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
iwlwifi 0000:0b:00.0:          CSR_INT_COALESCING: 0X8000ff40
iwlwifi 0000:0b:00.0:                     CSR_INT: 0X10000000
iwlwifi 0000:0b:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:0b:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:0b:00.0:                 CSR_GPIO_IN: 0X00000000
iwlwifi 0000:0b:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:0b:00.0:                CSR_GP_CNTRL: 0X080403cd
iwlwifi 0000:0b:00.0:                  CSR_HW_REV: 0X00000144
iwlwifi 0000:0b:00.0:              CSR_EEPROM_REG: 0X00000000
iwlwifi 0000:0b:00.0:               CSR_EEPROM_GP: 0X80000000
iwlwifi 0000:0b:00.0:              CSR_OTP_GP_REG: 0X803a0000
iwlwifi 0000:0b:00.0:                 CSR_GIO_REG: 0X00080042
iwlwifi 0000:0b:00.0:            CSR_GP_UCODE_REG: 0X00000000
iwlwifi 0000:0b:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:0b:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:0b:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:0b:00.0:                 CSR_LED_REG: 0X00000060
iwlwifi 0000:0b:00.0:        CSR_DRAM_INT_TBL_REG: 0X88032ee7
iwlwifi 0000:0b:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:0b:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
iwlwifi 0000:0b:00.0:      CSR_MONITOR_STATUS_REG: 0X3d0801bd
iwlwifi 0000:0b:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:0b:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
iwlwifi 0000:0b:00.0: FH register values:
iwlwifi 0000:0b:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X032fbd00
iwlwifi 0000:0b:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0032fbc0
iwlwifi 0000:0b:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000018
iwlwifi 0000:0b:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
iwlwifi 0000:0b:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:0b:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
iwlwifi 0000:0b:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:0b:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:0b:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:0b:00.0: Start IWL Error Log Dump:
iwlwifi 0000:0b:00.0: Status: 0x00000000, count: 6
iwlwifi 0000:0b:00.0: Loaded firmware version: 23.214.9.0
iwlwifi 0000:0b:00.0: 0x00002B00 | ADVANCED_SYSASSERT
iwlwifi 0000:0b:00.0: 0x000002F0 | uPc
iwlwifi 0000:0b:00.0: 0x00000000 | branchlink1
iwlwifi 0000:0b:00.0: 0x00000BA4 | branchlink2
iwlwifi 0000:0b:00.0: 0x000166A4 | interruptlink1
iwlwifi 0000:0b:00.0: 0x00907B64 | interruptlink2
iwlwifi 0000:0b:00.0: 0x00000002 | data1
iwlwifi 0000:0b:00.0: 0xDEADBEEF | data2
iwlwifi 0000:0b:00.0: 0xDEADBEEF | data3
iwlwifi 0000:0b:00.0: 0x00309CDE | beacon time
iwlwifi 0000:0b:00.0: 0x000F6320 | tsf low
iwlwifi 0000:0b:00.0: 0x00000000 | tsf hi
iwlwifi 0000:0b:00.0: 0x00000000 | time gp1
iwlwifi 0000:0b:00.0: 0x000F6321 | time gp2
iwlwifi 0000:0b:00.0: 0x00000000 | time gp3
iwlwifi 0000:0b:00.0: 0x000417D6 | uCode version
iwlwifi 0000:0b:00.0: 0x00000144 | hw version
iwlwifi 0000:0b:00.0: 0x40489204 | board version
iwlwifi 0000:0b:00.0: 0x091C0019 | hcmd
iwlwifi 0000:0b:00.0: 0x00022080 | isr0
iwlwifi 0000:0b:00.0: 0x00000000 | isr1
iwlwifi 0000:0b:00.0: 0x00000002 | isr2
iwlwifi 0000:0b:00.0: 0x004000C0 | isr3
iwlwifi 0000:0b:00.0: 0x00000001 | isr4
iwlwifi 0000:0b:00.0: 0x01000112 | isr_pref
iwlwifi 0000:0b:00.0: 0x00000000 | wait_event
iwlwifi 0000:0b:00.0: 0x00003FC5 | l2p_control
iwlwifi 0000:0b:00.0: 0x00000000 | l2p_duration
iwlwifi 0000:0b:00.0: 0x00000000 | l2p_mhvalid
iwlwifi 0000:0b:00.0: 0x00000000 | l2p_addr_match
iwlwifi 0000:0b:00.0: 0x00000007 | lmpm_pmg_sel
iwlwifi 0000:0b:00.0: 0x18051651 | timestamp
iwlwifi 0000:0b:00.0: 0x00001828 | flow_handler
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:0b:00.0: FW error in SYNC CMD REMOVE_STA
CPU: 3 PID: 805 Comm: iwconfig Not tainted 3.15.0-rc5+ #37
Hardware name: GETAC            F110/F110, BIOS R1.04.070520 01/02/2014
 00000000 00000000 cad77ca8 c13e04c0 fffffffb cad77cf0 f8609557 f2d71064
 00000000 00000000 f860dbdd f883cce7 00000000 0000001c c028de88 00000000
 c034b240 c1062b40 cad77cdc cad77cdc cad77d1c 00000019 cad77d40 cad77d14
Call Trace:
 [<c13e04c0>] dump_stack+0x41/0x52
 [<f8609557>] iwl_trans_pcie_send_hcmd+0x497/0x4b0 [iwlwifi]
 [<c1062b40>] ? __wake_up_sync+0x20/0x20
 [<f882d3db>] iwl_mvm_send_cmd+0x2b/0xb0 [iwlmvm]
 [<f8837e10>] ? iwl_mvm_bt_coex_reduced_txp+0xf0/0xf0 [iwlmvm]
 [<c13ca7bb>] ? __iterate_active_interfaces+0x8b/0xe0
 [<f882d49a>] iwl_mvm_send_cmd_pdu+0x3a/0x50 [iwlmvm]
 [<f88309ff>] iwl_mvm_rm_sta_common+0x3f/0xa0 [iwlmvm]
 [<f8831701>] iwl_mvm_send_rm_bcast_sta+0x11/0x40 [iwlmvm]
 [<f882971d>] iwl_mvm_stop_ap_ibss+0x6d/0xa0 [iwlmvm]
 [<c13b64c4>] ieee80211_ibss_disconnect+0x184/0x1e0
 [<c1099bd8>] ? lru_cache_add+0x8/0x10
 [<c10b319e>] ? page_add_new_anon_rmap+0x8e/0x100
 [<c13b73cd>] ieee80211_ibss_leave+0xd/0x80
 [<c13be3fe>] ieee80211_leave_ibss+0xe/0x10
 [<c13a28a5>] __cfg80211_leave_ibss+0x25/0x50
 [<c13a2d87>] cfg80211_ibss_wext_siwessid+0xd7/0x130
 [<c13a747b>] cfg80211_wext_siwessid+0x4b/0x60
 [<c13a8cc1>] ioctl_standard_call+0x131/0x380
 [<c130ddd1>] ? dev_get_by_name_rcu+0x51/0x70
 [<c13a910b>] wext_handle_ioctl+0x13b/0x190
 [<c13a7430>] ? cfg80211_wext_giwessid+0x70/0x70
 [<c1324aee>] dev_ioctl+0x25e/0x4d0
 [<c10a8845>] ? tlb_flush_mmu_free+0x25/0x40
 [<c12fee4e>] sock_ioctl+0x12e/0x250
 [<c12fed20>] ? ___sys_recvmsg.part.38+0x190/0x190
 [<c10cfe42>] do_vfs_ioctl+0x302/0x4e0
 [<c10b01fe>] ? do_munmap+0x21e/0x2c0
 [<c10d0058>] SyS_ioctl+0x38/0x70
 [<c13e564a>] sysenter_do_call+0x12/0x26
iwlwifi 0000:0b:00.0: Failed to remove station. Id=2
iwlwifi 0000:0b:00.0: Failed sending remove station
------------[ cut here ]------------
WARNING: CPU: 3 PID: 805 at /home/khalasa/src/linux-stable/drivers/net/wireless/iwlwifi/mvm/binding.c:201 iwl_mvm_binding_remove_vif+0x87/0x90 [iwlmvm]()
Modules linked in: hid_multitouch i2c_i801 e1000e ptp iwlmvm pps_core i915 iwlwifi cfbfillrect cfbimgblt intel_gtt i2c_algo_bit cfbcopyarea drm_kms_helper drm battery ac button
CPU: 3 PID: 805 Comm: iwconfig Not tainted 3.15.0-rc5+ #37
Hardware name: GETAC            F110/F110, BIOS R1.04.070520 01/02/2014
 00000000 00000000 cad77d30 c13e04c0 00000000 cad77d60 c1034e64 c149c288
 00000003 00000325 f883c124 000000c9 f8830307 f8830307 c0265b8c c0265b8c
 c0146d60 cad77d70 c1034efd 00000009 00000000 cad77d90 f8830307 cad77d90
Call Trace:
 [<c13e04c0>] dump_stack+0x41/0x52
 [<c1034e64>] warn_slowpath_common+0x74/0x90
 [<f8830307>] ? iwl_mvm_binding_remove_vif+0x87/0x90 [iwlmvm]
 [<f8830307>] ? iwl_mvm_binding_remove_vif+0x87/0x90 [iwlmvm]
 [<c1034efd>] warn_slowpath_null+0x1d/0x20
 [<f8830307>] iwl_mvm_binding_remove_vif+0x87/0x90 [iwlmvm]
 [<f883171a>] ? iwl_mvm_send_rm_bcast_sta+0x2a/0x40 [iwlmvm]
 [<f8829726>] iwl_mvm_stop_ap_ibss+0x76/0xa0 [iwlmvm]
 [<c13b64c4>] ieee80211_ibss_disconnect+0x184/0x1e0
 [<c1099bd8>] ? lru_cache_add+0x8/0x10
 [<c10b319e>] ? page_add_new_anon_rmap+0x8e/0x100
 [<c13b73cd>] ieee80211_ibss_leave+0xd/0x80
 [<c13be3fe>] ieee80211_leave_ibss+0xe/0x10
 [<c13a28a5>] __cfg80211_leave_ibss+0x25/0x50
 [<c13a2d87>] cfg80211_ibss_wext_siwessid+0xd7/0x130
 [<c13a747b>] cfg80211_wext_siwessid+0x4b/0x60
 [<c13a8cc1>] ioctl_standard_call+0x131/0x380
 [<c130ddd1>] ? dev_get_by_name_rcu+0x51/0x70
 [<c13a910b>] wext_handle_ioctl+0x13b/0x190
 [<c13a7430>] ? cfg80211_wext_giwessid+0x70/0x70
 [<c1324aee>] dev_ioctl+0x25e/0x4d0
 [<c10a8845>] ? tlb_flush_mmu_free+0x25/0x40
 [<c12fee4e>] sock_ioctl+0x12e/0x250
 [<c12fed20>] ? ___sys_recvmsg.part.38+0x190/0x190
 [<c10cfe42>] do_vfs_ioctl+0x302/0x4e0
 [<c10b01fe>] ? do_munmap+0x21e/0x2c0
 [<c10d0058>] SyS_ioctl+0x38/0x70
 [<c13e564a>] sysenter_do_call+0x12/0x26
---[ end trace c683f56639800424 ]---
------------[ cut here ]------------
WARNING: CPU: 3 PID: 805 at /home/khalasa/src/linux-stable/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:1208 iwl_mvm_mac_ctxt_remove+0x13a/0x150 [iwlmvm]()
Removing inactive MAC 7c:7a:91:0d:39:96/1
Modules linked in: hid_multitouch i2c_i801 e1000e ptp iwlmvm pps_core i915 iwlwifi cfbfillrect cfbimgblt intel_gtt i2c_algo_bit cfbcopyarea drm_kms_helper drm battery ac button
CPU: 3 PID: 805 Comm: iwconfig Tainted: G        W     3.15.0-rc5+ #37
Hardware name: GETAC            F110/F110, BIOS R1.04.070520 01/02/2014
 00000000 00000000 cad77c88 c13e04c0 cad77cc8 cad77cb8 c1034e64 f883d2d8
 cad77ce4 00000325 f883be08 000004b8 f882d32a f882d32a c0265c60 c0265b8c
 c0146d60 cad77cd0 c1034eae 00000009 cad77cc8 f883d2d8 cad77ce4 cad77d90
Call Trace:
 [<c13e04c0>] dump_stack+0x41/0x52
 [<c1034e64>] warn_slowpath_common+0x74/0x90
 [<f882d32a>] ? iwl_mvm_mac_ctxt_remove+0x13a/0x150 [iwlmvm]
 [<f882d32a>] ? iwl_mvm_mac_ctxt_remove+0x13a/0x150 [iwlmvm]
 [<c1034eae>] warn_slowpath_fmt+0x2e/0x30
 [<f882d32a>] iwl_mvm_mac_ctxt_remove+0x13a/0x150 [iwlmvm]
 [<c13df01e>] ? printk+0x38/0x3a
 [<c1034dea>] ? print_oops_end_marker+0x2a/0x30
 [<c13ca7bb>] ? __iterate_active_interfaces+0x8b/0xe0
 [<f8836bc0>] ? iwl_mvm_tx_protection+0x60/0x60 [iwlmvm]
 [<c13ca822>] ? ieee80211_iterate_active_interfaces_atomic+0x12/0x20
 [<f8837316>] ? iwl_mvm_power_update_mac+0x76/0x100 [iwlmvm]
 [<f8829738>] iwl_mvm_stop_ap_ibss+0x88/0xa0 [iwlmvm]
 [<c13b64c4>] ieee80211_ibss_disconnect+0x184/0x1e0
 [<c1099bd8>] ? lru_cache_add+0x8/0x10
 [<c10b319e>] ? page_add_new_anon_rmap+0x8e/0x100
 [<c13b73cd>] ieee80211_ibss_leave+0xd/0x80
 [<c13be3fe>] ieee80211_leave_ibss+0xe/0x10
 [<c13a28a5>] __cfg80211_leave_ibss+0x25/0x50
 [<c13a2d87>] cfg80211_ibss_wext_siwessid+0xd7/0x130
 [<c13a747b>] cfg80211_wext_siwessid+0x4b/0x60
 [<c13a8cc1>] ioctl_standard_call+0x131/0x380
 [<c130ddd1>] ? dev_get_by_name_rcu+0x51/0x70
 [<c13a910b>] wext_handle_ioctl+0x13b/0x190
 [<c13a7430>] ? cfg80211_wext_giwessid+0x70/0x70
 [<c1324aee>] dev_ioctl+0x25e/0x4d0
 [<c10a8845>] ? tlb_flush_mmu_free+0x25/0x40
 [<c12fee4e>] sock_ioctl+0x12e/0x250
 [<c12fed20>] ? ___sys_recvmsg.part.38+0x190/0x190
 [<c10cfe42>] do_vfs_ioctl+0x302/0x4e0
 [<c10b01fe>] ? do_munmap+0x21e/0x2c0
 [<c10d0058>] SyS_ioctl+0x38/0x70
 [<c13e564a>] sysenter_do_call+0x12/0x26
---[ end trace c683f56639800425 ]---
iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
wlan0: Creating new IBSS network, BSSID xxx
wlan0: Selected IBSS BSSID xxx based on configured SSID

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
