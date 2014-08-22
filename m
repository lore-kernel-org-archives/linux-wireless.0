Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43089 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaHVWBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 18:01:06 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so10971929wgh.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 15:01:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ilw@linux.intel.com, emmanuel.grumbach@intel.com,
	johannes.berg@intel.com
Subject: Iwlwifi 3160 AC (firmware?) clashes with CONFIG_IWLWIFI_BCAST_FILTERING
Date: Sat, 23 Aug 2014 00:01:02 +0200
Message-ID: <6715079.xd2j4mnUMo@debian64> (sfid-20140823_000110_973351_36DBD4BB)
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I got new hardware. Among the new stuff, there was one
Intel® Dual Band Wireless-AC 3160. When I tried to connect
to one (in fact any) of my networks, I was getting the
following errors:

[ 1021.092378] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x82000000.
[...]
[ 1021.093935] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[ 1021.093939] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[ 1021.093942] iwlwifi 0000:01:00.0: Loaded firmware version: 25.223.9.0
[ 1021.093947] iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND <---                
[ 1021.093951] iwlwifi 0000:01:00.0: 0x00A00220 | uPc
[...]
[ 1021.094192] Call Trace:
[ 1021.094205]  [<ffffffff813ce9bd>] ? dump_stack+0x41/0x51
[ 1021.094217]  [<ffffffffa0b9cd8b>] ? iwl_trans_pcie_send_hcmd+0x367/0x438 [iwlwifi]
[ 1021.094226]  [<ffffffffa0b9b52c>] ? iwl_pcie_enqueue_hcmd+0x5e3/0x5fe [iwlwifi]
[ 1021.094235]  [<ffffffff8105fd4c>] ? finish_wait+0x5d/0x5d
[ 1021.094250]  [<ffffffffa0d50106>] ? iwl_mvm_send_cmd+0xd/0x22 [iwlmvm]
[ 1021.094262]  [<ffffffffa0d50160>] ? iwl_mvm_send_cmd_pdu+0x45/0x52 [iwlmvm]
[ 1021.094273]  [<ffffffffa0d4c5fb>] ? iwl_mvm_configure_bcast_filter.isra.14.part.15+0x36/0x3f [iwlmvm]

(Full log attached below)

What cough my eye was the "BAD_COMMAND" in the error log. I disabled
"CONFIG_IWLWIFI_BCAST_FILTERING" option and the 3160 is now working.

As far as I can tell, there is already a firmware feature flag:
"IWL_UCODE_TLV_FLAGS_BCAST_FILTERING" which can be used to
distinguish whenever the feature is supported or not. But it
seems to be "stuck on" for the 3160.

Regards
Christian

BTW: I also tried the older "23.214.9.0" firmware too.
=> Same result [Doesn't work with BCAST_FILTERING enabled].

---
[  989.779548] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AC 3160, REV=0x164
[  989.779753] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[  989.780191] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[  989.882439] ieee80211 phy2: Selected rate control algorithm 'iwl-mvm-rs'
[ 1021.092378] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x82000000.
[ 1021.092382] iwlwifi 0000:01:00.0: CSR values:
[ 1021.092386] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[ 1021.092403] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89204
[ 1021.092446] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
[ 1021.092489] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[ 1021.092532] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[ 1021.092576] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[ 1021.092619] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[ 1021.092663] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[ 1021.092707] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403cd
[ 1021.092750] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000164
[ 1021.092794] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[ 1021.092837] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[ 1021.092881] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[ 1021.092925] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080042
[ 1021.092968] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[ 1021.093012] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[ 1021.093056] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[ 1021.093099] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[ 1021.093143] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[ 1021.093186] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88283dea
[ 1021.093230] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[ 1021.093274] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[ 1021.093317] iwlwifi 0000:01:00.0:      CSR_MONITOR_STATUS_REG: 0Xdbb7f7d7
[ 1021.093361] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[ 1021.093405] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[ 1021.093409] iwlwifi 0000:01:00.0: FH register values:
[ 1021.093450] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X289f9700
[ 1021.093493] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0283e4a0
[ 1021.093537] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000048
[ 1021.093580] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[ 1021.093624] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 1021.093667] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[ 1021.093711] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 1021.093754] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 1021.093798] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[ 1021.093935] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[ 1021.093939] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[ 1021.093942] iwlwifi 0000:01:00.0: Loaded firmware version: 25.223.9.0
[ 1021.093947] iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND                 
[ 1021.093951] iwlwifi 0000:01:00.0: 0x00A00220 | uPc
[ 1021.093954] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[ 1021.093958] iwlwifi 0000:01:00.0: 0x00000B84 | branchlink2
[ 1021.093961] iwlwifi 0000:01:00.0: 0x00014B88 | interruptlink1
[ 1021.093964] iwlwifi 0000:01:00.0: 0x00260117 | interruptlink2
[ 1021.093968] iwlwifi 0000:01:00.0: 0x00010000 | data1
[ 1021.093971] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[ 1021.093974] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[ 1021.093977] iwlwifi 0000:01:00.0: 0x000084E9 | beacon time
[ 1021.093981] iwlwifi 0000:01:00.0: 0xCF5E6121 | tsf low
[ 1021.093984] iwlwifi 0000:01:00.0: 0x000001C3 | tsf hi
[ 1021.093987] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[ 1021.093990] iwlwifi 0000:01:00.0: 0x003B49A6 | time gp2
[ 1021.093993] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[ 1021.093997] iwlwifi 0000:01:00.0: 0x000419DF | uCode version
[ 1021.094000] iwlwifi 0000:01:00.0: 0x00000164 | hw version
[ 1021.094003] iwlwifi 0000:01:00.0: 0x00C89204 | board version
[ 1021.094006] iwlwifi 0000:01:00.0: 0x00010000 | hcmd
[ 1021.094010] iwlwifi 0000:01:00.0: 0x24022080 | isr0
[ 1021.094013] iwlwifi 0000:01:00.0: 0x11800000 | isr1
[ 1021.094016] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[ 1021.094019] iwlwifi 0000:01:00.0: 0x00417CC0 | isr3
[ 1021.094022] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[ 1021.094025] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[ 1021.094028] iwlwifi 0000:01:00.0: 0x00000000 | wait_event
[ 1021.094032] iwlwifi 0000:01:00.0: 0x00000010 | l2p_control
[ 1021.094035] iwlwifi 0000:01:00.0: 0x00018030 | l2p_duration
[ 1021.094038] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[ 1021.094041] iwlwifi 0000:01:00.0: 0x000000CF | l2p_addr_match
[ 1021.094044] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[ 1021.094048] iwlwifi 0000:01:00.0: 0x27070928 | timestamp
[ 1021.094051] iwlwifi 0000:01:00.0: 0x00004858 | flow_handler
[ 1021.094056] ieee80211 phy2: Hardware restart was requested
[ 1021.094080] iwlwifi 0000:01:00.0: FW Error notification: type 0x00000000 cmd_id 0x00
[ 1021.094084] iwlwifi 0000:01:00.0: FW Error notification: seq 0x0001 service 0x00000000
[ 1021.094087] iwlwifi 0000:01:00.0: FW Error notification: timestamp 0x     1C3CF5E611B
[ 1021.094114] iwlwifi 0000:01:00.0: FW error in SYNC CMD BCAST_FILTER_CMD
[ 1021.094122] CPU: 2 PID: 13275 Comm: kworker/u8:2 Tainted: P           O   3.17.0-rc1-wl-bd+ #66
[ 1021.094124] Hardware name: Acer Aspire V5-122P/Aspire V5-122P, BIOS V2.12 01/20/2014
[ 1021.094177] Workqueue: phy2 ieee80211_iface_work [mac80211]
[ 1021.094183]  0000000000000000 ffffffff813ce9bd ffff880283e14000 ffffffffa0b9cd8b
[ 1021.094187]  ffff880283e14020 ffffffffa0b9b52c 0000000000000000 ffff880283f4d750
[ 1021.094190]  ffffffff8105fd4c ffff88028f9776b8 ffff88028f9776b8 ffff88028f977710
[ 1021.094192] Call Trace:
[ 1021.094205]  [<ffffffff813ce9bd>] ? dump_stack+0x41/0x51
[ 1021.094217]  [<ffffffffa0b9cd8b>] ? iwl_trans_pcie_send_hcmd+0x367/0x438 [iwlwifi]
[ 1021.094226]  [<ffffffffa0b9b52c>] ? iwl_pcie_enqueue_hcmd+0x5e3/0x5fe [iwlwifi]
[ 1021.094235]  [<ffffffff8105fd4c>] ? finish_wait+0x5d/0x5d
[ 1021.094250]  [<ffffffffa0d50106>] ? iwl_mvm_send_cmd+0xd/0x22 [iwlmvm]
[ 1021.094262]  [<ffffffffa0d50160>] ? iwl_mvm_send_cmd_pdu+0x45/0x52 [iwlmvm]
[ 1021.094273]  [<ffffffffa0d4c5fb>] ? iwl_mvm_configure_bcast_filter.isra.14.part.15+0x36/0x3f [iwlmvm]
[ 1021.094283]  [<ffffffffa0d4c5fb>] ? iwl_mvm_configure_bcast_filter.isra.14.part.15+0x36/0x3f [iwlmvm]
[ 1021.094295]  [<ffffffffa0d4c864>] ? iwl_mvm_bss_info_changed+0x24e/0x4b4 [iwlmvm]
[ 1021.094318]  [<ffffffffa0b5afb5>] ? ieee80211_assoc_success+0x663/0x8ee [mac80211]
[ 1021.094327]  [<ffffffff81056d8d>] ? local_clock+0x5/0x1b
[ 1021.094334]  [<ffffffff81069c9c>] ? log_store+0x156/0x1a0
[ 1021.094341]  [<ffffffff81060f95>] ? down_trylock+0x1f/0x27
[ 1021.094346]  [<ffffffff81069a6a>] ? console_trylock+0xd/0x4f
[ 1021.094351]  [<ffffffff8106acac>] ? vprintk_emit+0x300/0x35f
[ 1021.094382]  [<ffffffffa0b49534>] ? ieee80211_rx_mgmt_assoc_resp+0x176/0x1e4 [mac80211]
[ 1021.094415]  [<ffffffffa0b49a07>] ? ieee80211_sta_rx_queued_mgmt+0x40b/0x4a0 [mac80211]
[ 1021.094427]  [<ffffffff8105b1c7>] ? load_balance+0x138/0x6e9
[ 1021.094437]  [<ffffffff81053dbd>] ? get_nohz_timer_target+0x19/0x78
[ 1021.094446]  [<ffffffff81056cd2>] ? sched_clock_cpu+0xc/0x97
[ 1021.094455]  [<ffffffff810583e3>] ? update_next_balance.constprop.69+0x10/0x39
[ 1021.094463]  [<ffffffff8105ba16>] ? pick_next_task_fair+0x29e/0x327
[ 1021.094491]  [<ffffffffa0b2f85a>] ? ieee80211_iface_work+0x2e4/0x37f [mac80211]
[ 1021.094501]  [<ffffffff8104ac47>] ? process_one_work+0x140/0x20a
[ 1021.094509]  [<ffffffff8104b132>] ? worker_thread+0x1e7/0x291
[ 1021.094517]  [<ffffffff8104af4b>] ? rescuer_thread+0x217/0x217
[ 1021.094527]  [<ffffffff8104e4b4>] ? kthread+0xa7/0xaf
[ 1021.094535]  [<ffffffff81050000>] ? __async_schedule+0x48/0x161
[ 1021.094544]  [<ffffffff8104e40d>] ? __kthread_parkme+0x5b/0x5b
[ 1021.094553]  [<ffffffff813d23ac>] ? ret_from_fork+0x7c/0xb0
[ 1021.094562]  [<ffffffff8104e40d>] ? __kthread_parkme+0x5b/0x5b

