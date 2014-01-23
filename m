Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaAWMpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:45:53 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Petko Manolov <petkan@nucleusys.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi crash with 3.13
Date: Thu, 23 Jan 2014 12:45:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com> (sfid-20140123_134557_239794_BDF2C0A9)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >
> > > Can you share the very first iwlwifi lines of your dmesg? I'd like
> > > to check the
> > fw version. Also - can you please update to latest firmware
> > > from http://wireless.kernel.org/en/users/Drivers/iwlwifi. You can
> > > take
> > iwlwifi-7260-ucode-22.1.7.0.tgz or iwlwifi-7260-ucode-22.15.8.0.tgz.
> >
> > I used the latter firmware version with pretty much the same result.
> > Attached you'll find complete (iwlwifi-related) dmesg.  BTW, after
> > these dumps the controller successfully connected to 2.4GHz network.
> >
> 
> Ok - thanks.
> Can I see the output of
> 
> cat /sys/kernel/debug/iwlwifi/*/iwlmvm/nvm_sw | hexdump | head -5
> 

If it easier - you can also reload the module and add debug=0x1:

modprobe iwlwifi debug=0x1.

Note that you first need to unload iwlmvm, then, unload iwlwifi. After that you can reload iwlwifi.
I prefer the debufgs line above though, I'll get a bit more information.

> thanks.
> 
> > --- dmesg ---
> >
> > Intel(R) Wireless WiFi driver for Linux, in-tree:
> > Copyright(c) 2003-2013 Intel Corporation iwlwifi 0000:01:00.0: irq 62
> > for MSI/MSI-X iwlwifi 0000:01:00.0: loaded firmware version 22.15.8.0
> > op_mode iwlmvm iwlwifi 0000:01:00.0: Detected Intel(R) Wireless N
> > 7260, REV=0x144 iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> > iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> > ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> > --- snip ---
> > iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0:
> > L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0: Microcode SW error
> > detected.  Restarting 0x2000000.
> > iwlwifi 0000:01:00.0: CSR values:
> > iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is
> > CSR_INT_PERIODIC_REG)
> > iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
> > iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
> > iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
> > iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
> > iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
> > iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
> > iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
> > iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
> > iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
> > iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
> > iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255090
> > iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> > iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> > iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> > iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> > iwlwifi 0000:01:00.0: FH register values:
> > iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2553ce00
> > iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02553d40
> > iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000028
> > iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
> 0X80801114
> > iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> > iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> > iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
> > 0X00000000
> > iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> > iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> > iwlwifi 0000:01:00.0: FW error in SYNC CMD SCAN_REQUEST_CMD
> > CPU: 2 PID: 6 Comm: kworker/u8:0 Not tainted 3.13.0 #3 Hardware name:
> > LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
> > Workqueue: phy0 ieee80211_scan_work
> >  ffff88025533f218 ffffffff814e7e35 ffff88025533c000 ffffffffa0008755
> >  ffff8802560efd10 0000001f00000000 0000000000000000 ffff8802560ca0d0
> >  ffffffff810744f0 ffff8802560efc78 ffff8802560efc78 ffff8802560efd10
> > Call Trace:
> >  [<ffffffff814e7e35>] ? dump_stack+0x41/0x51  [<ffffffffa0008755>] ?
> > iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]  [<ffffffff810744f0>] ?
> > prepare_to_wait_event+0xf0/0xf0  [<ffffffffa0034633>] ?
> > iwl_mvm_send_cmd_status+0x33/0x120 [iwlmvm]  [<ffffffffa00396f5>] ?
> > iwl_mvm_scan_request+0x355/0x430 [iwlmvm]  [<ffffffffa003074e>] ?
> > iwl_mvm_mac_hw_scan+0x6e/0x80 [iwlmvm]  [<ffffffff814b503f>] ?
> > __ieee80211_scan_completed+0x12f/0x1e0
> >  [<ffffffff814b5afa>] ? ieee80211_scan_work+0xda/0x490
> > [<ffffffff810591ec>] ? process_one_work+0x13c/0x3c0
> > [<ffffffff81059d56>] ? worker_thread+0x116/0x3a0  [<ffffffff81059c40>]
> > ? manage_workers.isra.30+0x280/0x280
> >  [<ffffffff8105f041>] ? kthread+0xc1/0xe0  [<ffffffff8105ef80>] ?
> > kthread_create_on_node+0x180/0x180
> >  [<ffffffff814ee4bc>] ? ret_from_fork+0x7c/0xb0  [<ffffffff8105ef80>]
> > ? kthread_create_on_node+0x180/0x180
> > iwlwifi 0000:01:00.0: Scan failed! status 0x1 ret -5 iwlwifi
> > 0000:01:00.0: Start IWL Error Log Dump:
> > iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6 iwlwifi
> > 0000:01:00.0: 0x000014F4 | ADVANCED_SYSASSERT iwlwifi 0000:01:00.0:
> > 0x000002A0 | uPc iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> > iwlwifi 0000:01:00.0: 0x00000C2A | branchlink2 iwlwifi 0000:01:00.0:
> > 0x00015ADC | interruptlink1 iwlwifi 0000:01:00.0: 0x001B20FB |
> > interruptlink2 iwlwifi 0000:01:00.0: 0x00000175 | data1 iwlwifi
> > 0000:01:00.0: 0x00000024 | data2 iwlwifi 0000:01:00.0: 0x000000E0 |
> > data3 iwlwifi 0000:01:00.0: 0x003523E9 | beacon time iwlwifi
> > 0000:01:00.0: 0x000B9A37 | tsf low iwlwifi 0000:01:00.0: 0x00000000 |
> > tsf hi iwlwifi 0000:01:00.0: 0x00000000 | time gp1 iwlwifi
> > 0000:01:00.0: 0x000B9A37 | time gp2 iwlwifi 0000:01:00.0: 0x00000000 |
> > time gp3 iwlwifi 0000:01:00.0: 0x0004160F | uCode version iwlwifi
> > 0000:01:00.0: 0x00000144 | hw version iwlwifi 0000:01:00.0: 0x00489204
> > | board version iwlwifi 0000:01:00.0: 0x091F0080 | hcmd iwlwifi
> > 0000:01:00.0: 0x00022080 | isr0 iwlwifi 0000:01:00.0: 0x00000000 |
> > isr1 iwlwifi 0000:01:00.0: 0x00000002 | isr2 iwlwifi 0000:01:00.0:
> > 0x0041FCC0 | isr3 iwlwifi 0000:01:00.0: 0x00000001 | isr4 iwlwifi
> > 0000:01:00.0: 0x01000112 | isr_pref iwlwifi 0000:01:00.0: 0x00000000 |
> > wait_event iwlwifi 0000:01:00.0: 0x00000080 | l2p_control iwlwifi
> > 0000:01:00.0: 0x00018000 | l2p_duration iwlwifi 0000:01:00.0:
> > 0x0000003F | l2p_mhvalid iwlwifi 0000:01:00.0: 0x00000000 |
> > l2p_addr_match iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel iwlwifi
> > 0000:01:00.0: 0x22121614 | timestamp iwlwifi 0000:01:00.0: 0x00002838
> > | flow_handler
> > ieee80211 phy0: Hardware restart was requested iwlwifi 0000:01:00.0:
> > L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0: L1 Disabled; Enabling
> > L0S iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting
> > 0x2000000.
> > iwlwifi 0000:01:00.0: CSR values:
> > iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is
> > CSR_INT_PERIODIC_REG)
> > iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
> > iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
> > iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
> > iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
> > iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
> > iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
> > iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
> > iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
> > iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
> > iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
> > iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255090
> > iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> > iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> > iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> > iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> > iwlwifi 0000:01:00.0: FH register values:
> > iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2553ce00
> > iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02553d40
> > iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000028
> > iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
> 0X80801114
> > iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> > iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> > iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
> > 0X00000000
> > iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> > iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> > iwlwifi 0000:01:00.0: FW error in SYNC CMD SCAN_REQUEST_CMD
> > CPU: 2 PID: 6 Comm: kworker/u8:0 Not tainted 3.13.0 #3 Hardware name:
> > LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
> > Workqueue: phy0 ieee80211_scan_work
> >  ffff88025533f218 ffffffff814e7e35 ffff88025533c000 ffffffffa0008755
> >  ffff8802560efd10 0000001f00000000 0000000000000000 ffff8802560ca0d0
> >  ffffffff810744f0 ffff8802560efc78 ffff8802560efc78 ffff8802560efd10
> > Call Trace:
> >  [<ffffffff814e7e35>] ? dump_stack+0x41/0x51  [<ffffffffa0008755>] ?
> > iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]  [<ffffffff810744f0>] ?
> > prepare_to_wait_event+0xf0/0xf0  [<ffffffffa0034633>] ?
> > iwl_mvm_send_cmd_status+0x33/0x120 [iwlmvm]  [<ffffffffa00396f5>] ?
> > iwl_mvm_scan_request+0x355/0x430 [iwlmvm]  [<ffffffffa003074e>] ?
> > iwl_mvm_mac_hw_scan+0x6e/0x80 [iwlmvm]  [<ffffffff814b503f>] ?
> > __ieee80211_scan_completed+0x12f/0x1e0
> >  [<ffffffff814b5afa>] ? ieee80211_scan_work+0xda/0x490
> > [<ffffffff810591ec>] ? process_one_work+0x13c/0x3c0
> > [<ffffffff81059d56>] ? worker_thread+0x116/0x3a0  [<ffffffff81059c40>]
> > ? manage_workers.isra.30+0x280/0x280
> >  [<ffffffff8105f041>] ? kthread+0xc1/0xe0  [<ffffffff8105ef80>] ?
> > kthread_create_on_node+0x180/0x180
> >  [<ffffffff814ee4bc>] ? ret_from_fork+0x7c/0xb0  [<ffffffff8105ef80>]
> > ? kthread_create_on_node+0x180/0x180
> > iwlwifi 0000:01:00.0: Scan failed! status 0x1 ret -5 iwlwifi
> > 0000:01:00.0: Start IWL Error Log Dump:
> > iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6 iwlwifi
> > 0000:01:00.0: 0x000014F4 | ADVANCED_SYSASSERT iwlwifi 0000:01:00.0:
> > 0x000002B0 | uPc iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> > iwlwifi 0000:01:00.0: 0x00000C2A | branchlink2 iwlwifi 0000:01:00.0:
> > 0x00015ADC | interruptlink1 iwlwifi 0000:01:00.0: 0x001B20FB |
> > interruptlink2 iwlwifi 0000:01:00.0: 0x00000175 | data1 iwlwifi
> > 0000:01:00.0: 0x00000024 | data2 iwlwifi 0000:01:00.0: 0x000000E0 |
> > data3 iwlwifi 0000:01:00.0: 0x00352263 | beacon time iwlwifi
> > 0000:01:00.0: 0x005732DD | tsf low iwlwifi 0000:01:00.0: 0x00000000 |
> > tsf hi iwlwifi 0000:01:00.0: 0x00000000 | time gp1 iwlwifi
> > 0000:01:00.0: 0x005732DE | time gp2 iwlwifi 0000:01:00.0: 0x00000000 |
> > time gp3 iwlwifi 0000:01:00.0: 0x0004160F | uCode version iwlwifi
> > 0000:01:00.0: 0x00000144 | hw version iwlwifi 0000:01:00.0: 0x00489204
> > | board version iwlwifi 0000:01:00.0: 0x091F0080 | hcmd iwlwifi
> > 0000:01:00.0: 0x00022080 | isr0 iwlwifi 0000:01:00.0: 0x00000000 |
> > isr1 iwlwifi 0000:01:00.0: 0x00000002 | isr2 iwlwifi 0000:01:00.0:
> > 0x0041FCC0 | isr3 iwlwifi 0000:01:00.0: 0x00000001 | isr4 iwlwifi
> > 0000:01:00.0: 0x01000112 | isr_pref iwlwifi 0000:01:00.0: 0x00000000 |
> > wait_event iwlwifi 0000:01:00.0: 0x00000080 | l2p_control iwlwifi
> > 0000:01:00.0: 0x00010000 | l2p_duration iwlwifi 0000:01:00.0:
> > 0x0000003F | l2p_mhvalid iwlwifi 0000:01:00.0: 0x00000000 |
> > l2p_addr_match iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel iwlwifi
> > 0000:01:00.0: 0x22121614 | timestamp iwlwifi 0000:01:00.0: 0x00002838
> > | flow_handler
> > ieee80211 phy0: Hardware restart was requested iwlwifi 0000:01:00.0:
> > L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0: L1 Disabled; Enabling
> > L0S iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting
> > 0x2000000.
> > iwlwifi 0000:01:00.0: CSR values:
> > iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is
> > CSR_INT_PERIODIC_REG)
> > iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
> > iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
> > iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
> > iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
> > iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
> > iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
> > iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
> > iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
> > iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
> > iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
> > iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255090
> > iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> > iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> > iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> > iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> > iwlwifi 0000:01:00.0: FH register values:
> > iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2553ce00
> > iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02553d40
> > iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000028
> > iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
> 0X80801114
> > iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> > iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> > iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
> > 0X00000000
> > iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> > iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> > iwlwifi 0000:01:00.0: FW error in SYNC CMD SCAN_REQUEST_CMD
> > CPU: 2 PID: 25 Comm: kworker/u8:1 Not tainted 3.13.0 #3 Hardware name:
> > LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
> > Workqueue: phy0 ieee80211_scan_work
> >  ffff88025533f218 ffffffff814e7e35 ffff88025533c000 ffffffffa0008755
> >  ffff8802561e5d10 0000001f00000000 0000000000000000 ffff8802561413b0
> >  ffffffff810744f0 ffff8802561e5c78 ffff8802561e5c78 ffff8802561e5d10
> > Call Trace:
> >  [<ffffffff814e7e35>] ? dump_stack+0x41/0x51  [<ffffffffa0008755>] ?
> > iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]  [<ffffffff810744f0>] ?
> > prepare_to_wait_event+0xf0/0xf0  [<ffffffffa0034633>] ?
> > iwl_mvm_send_cmd_status+0x33/0x120 [iwlmvm]  [<ffffffffa00396f5>] ?
> > iwl_mvm_scan_request+0x355/0x430 [iwlmvm]  [<ffffffffa003074e>] ?
> > iwl_mvm_mac_hw_scan+0x6e/0x80 [iwlmvm]  [<ffffffff814b503f>] ?
> > __ieee80211_scan_completed+0x12f/0x1e0
> >  [<ffffffff814b5afa>] ? ieee80211_scan_work+0xda/0x490
> > [<ffffffff810591ec>] ? process_one_work+0x13c/0x3c0
> > [<ffffffff81059d56>] ? worker_thread+0x116/0x3a0  [<ffffffff81059c40>]
> > ? manage_workers.isra.30+0x280/0x280
> >  [<ffffffff8105f041>] ? kthread+0xc1/0xe0  [<ffffffff8105ef80>] ?
> > kthread_create_on_node+0x180/0x180
> >  [<ffffffff814ee4bc>] ? ret_from_fork+0x7c/0xb0  [<ffffffff8105ef80>]
> > ? kthread_create_on_node+0x180/0x180
> > iwlwifi 0000:01:00.0: Scan failed! status 0x1 ret -5 iwlwifi
> > 0000:01:00.0: Start IWL Error Log Dump:
> > iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6 iwlwifi
> > 0000:01:00.0: 0x000014F4 | ADVANCED_SYSASSERT iwlwifi 0000:01:00.0:
> > 0x000002B0 | uPc iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> > iwlwifi 0000:01:00.0: 0x00000C2A | branchlink2 iwlwifi 0000:01:00.0:
> > 0x00015ADC | interruptlink1 iwlwifi 0000:01:00.0: 0x001B20FB |
> > interruptlink2 iwlwifi 0000:01:00.0: 0x00000175 | data1 iwlwifi
> > 0000:01:00.0: 0x00000024 | data2 iwlwifi 0000:01:00.0: 0x000000E0 |
> > data3 iwlwifi 0000:01:00.0: 0x0035223E | beacon time iwlwifi
> > 0000:01:00.0: 0x0057260D | tsf low iwlwifi 0000:01:00.0: 0x00000000 |
> > tsf hi iwlwifi 0000:01:00.0: 0x00000000 | time gp1 iwlwifi
> > 0000:01:00.0: 0x0057260D | time gp2 iwlwifi 0000:01:00.0: 0x00000000 |
> > time gp3 iwlwifi 0000:01:00.0: 0x0004160F | uCode version iwlwifi
> > 0000:01:00.0: 0x00000144 | hw version iwlwifi 0000:01:00.0: 0x00489204
> > | board version iwlwifi 0000:01:00.0: 0x091F0080 | hcmd iwlwifi
> > 0000:01:00.0: 0x00022080 | isr0 iwlwifi 0000:01:00.0: 0x00000000 |
> > isr1 iwlwifi 0000:01:00.0: 0x00000002 | isr2 iwlwifi 0000:01:00.0:
> > 0x0041FCC0 | isr3 iwlwifi 0000:01:00.0: 0x00000001 | isr4 iwlwifi
> > 0000:01:00.0: 0x01000112 | isr_pref iwlwifi 0000:01:00.0: 0x00000000 |
> > wait_event iwlwifi 0000:01:00.0: 0x00000080 | l2p_control iwlwifi
> > 0000:01:00.0: 0x00010000 | l2p_duration iwlwifi 0000:01:00.0:
> > 0x0000003F | l2p_mhvalid iwlwifi 0000:01:00.0: 0x00000000 |
> > l2p_addr_match iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel iwlwifi
> > 0000:01:00.0: 0x22121614 | timestamp iwlwifi 0000:01:00.0: 0x00002838
> > | flow_handler
> > ieee80211 phy0: Hardware restart was requested iwlwifi 0000:01:00.0:
> > L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0: L1 Disabled; Enabling
> > L0S iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting
> > 0x2000000.
> > iwlwifi 0000:01:00.0: CSR values:
> > iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is
> > CSR_INT_PERIODIC_REG)
> > iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
> > iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
> > iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
> > iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
> > iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
> > iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
> > iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
> > iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
> > iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
> > iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
> > iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255090
> > iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> > iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> > iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> > iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> > iwlwifi 0000:01:00.0: FH register values:
> > iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2553ce00
> > iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02553d40
> > iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000030
> > iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
> 0X80801114
> > iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> > iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> > iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
> > 0X00000000
> > iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> > iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> > iwlwifi 0000:01:00.0: FW error in SYNC CMD SCAN_REQUEST_CMD
> > CPU: 2 PID: 25 Comm: kworker/u8:1 Not tainted 3.13.0 #3 Hardware name:
> > LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
> > Workqueue: phy0 ieee80211_scan_work
> >  ffff88025533f218 ffffffff814e7e35 ffff88025533c000 ffffffffa0008755
> >  ffff8802561e5d10 0000001f00000000 0000000000000000 ffff8802561413b0
> >  ffffffff810744f0 ffff8802561e5c78 ffff8802561e5c78 ffff8802561e5d10
> > Call Trace:
> >  [<ffffffff814e7e35>] ? dump_stack+0x41/0x51  [<ffffffffa0008755>] ?
> > iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]  [<ffffffff810744f0>] ?
> > prepare_to_wait_event+0xf0/0xf0  [<ffffffffa0034633>] ?
> > iwl_mvm_send_cmd_status+0x33/0x120 [iwlmvm]  [<ffffffffa00396f5>] ?
> > iwl_mvm_scan_request+0x355/0x430 [iwlmvm]  [<ffffffffa003074e>] ?
> > iwl_mvm_mac_hw_scan+0x6e/0x80 [iwlmvm]  [<ffffffff814b503f>] ?
> > __ieee80211_scan_completed+0x12f/0x1e0
> >  [<ffffffff814b5afa>] ? ieee80211_scan_work+0xda/0x490
> > [<ffffffff810591ec>] ? process_one_work+0x13c/0x3c0
> > [<ffffffff81059d56>] ? worker_thread+0x116/0x3a0  [<ffffffff81059c40>]
> > ? manage_workers.isra.30+0x280/0x280
> >  [<ffffffff8105f041>] ? kthread+0xc1/0xe0  [<ffffffff8105ef80>] ?
> > kthread_create_on_node+0x180/0x180
> >  [<ffffffff814ee4bc>] ? ret_from_fork+0x7c/0xb0  [<ffffffff8105ef80>]
> > ? kthread_create_on_node+0x180/0x180
> > iwlwifi 0000:01:00.0: Scan failed! status 0x1 ret -5 iwlwifi
> > 0000:01:00.0: Start IWL Error Log Dump:
> > iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6 iwlwifi
> > 0000:01:00.0: 0x000014F4 | ADVANCED_SYSASSERT iwlwifi 0000:01:00.0:
> > 0x000002B0 | uPc iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> > iwlwifi 0000:01:00.0: 0x00000C2A | branchlink2 iwlwifi 0000:01:00.0:
> > 0x00015ADC | interruptlink1 iwlwifi 0000:01:00.0: 0x001B20FB |
> > interruptlink2 iwlwifi 0000:01:00.0: 0x00000175 | data1 iwlwifi
> > 0000:01:00.0: 0x00000024 | data2 iwlwifi 0000:01:00.0: 0x000000E0 |
> > data3 iwlwifi 0000:01:00.0: 0x0035227F | beacon time iwlwifi
> > 0000:01:00.0: 0x005733C4 | tsf low iwlwifi 0000:01:00.0: 0x00000000 |
> > tsf hi iwlwifi 0000:01:00.0: 0x00000000 | time gp1 iwlwifi
> > 0000:01:00.0: 0x005733C4 | time gp2 iwlwifi 0000:01:00.0: 0x00000000 |
> > time gp3 iwlwifi 0000:01:00.0: 0x0004160F | uCode version iwlwifi
> > 0000:01:00.0: 0x00000144 | hw version iwlwifi 0000:01:00.0: 0x00489204
> > | board version iwlwifi 0000:01:00.0: 0x091F0080 | hcmd iwlwifi
> > 0000:01:00.0: 0x00022080 | isr0 iwlwifi 0000:01:00.0: 0x01000000 |
> > isr1 iwlwifi 0000:01:00.0: 0x00000002 | isr2 iwlwifi 0000:01:00.0:
> > 0x0041FCC0 | isr3 iwlwifi 0000:01:00.0: 0x00000001 | isr4 iwlwifi
> > 0000:01:00.0: 0x01000112 | isr_pref iwlwifi 0000:01:00.0: 0x00000000 |
> > wait_event iwlwifi 0000:01:00.0: 0x00000080 | l2p_control iwlwifi
> > 0000:01:00.0: 0x00010000 | l2p_duration iwlwifi 0000:01:00.0:
> > 0x0000003F | l2p_mhvalid iwlwifi 0000:01:00.0: 0x00000000 |
> > l2p_addr_match iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel iwlwifi
> > 0000:01:00.0: 0x22121614 | timestamp iwlwifi 0000:01:00.0: 0x00003038
> > | flow_handler
> > ieee80211 phy0: Hardware restart was requested iwlwifi 0000:01:00.0:
> > L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0: L1 Disabled; Enabling
> > L0S iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting
> > 0x2000000.
> > iwlwifi 0000:01:00.0: CSR values:
> > iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is
> > CSR_INT_PERIODIC_REG)
> > iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
> > iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
> > iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
> > iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
> > iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
> > iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
> > iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
> > iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
> > iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
> > iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
> > iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> > iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> > iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
> > iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X88255090
> > iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> > iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> > iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> > iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> > iwlwifi 0000:01:00.0: FH register values:
> > iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2553ce00
> > iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02553d40
> > iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000028
> > iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
> 0X80801114
> > iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> > iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> > iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
> > 0X00000000
> > iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> > iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> > iwlwifi 0000:01:00.0: FW error in SYNC CMD SCAN_REQUEST_CMD
> > CPU: 2 PID: 6 Comm: kworker/u8:0 Not tainted 3.13.0 #3 Hardware name:
> > LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
> > Workqueue: phy0 ieee80211_scan_work
> >  ffff88025533f218 ffffffff814e7e35 ffff88025533c000 ffffffffa0008755
> >  ffff8802560efd10 0000001f00000000 0000000000000000 ffff8802560ca0d0
> >  ffffffff810744f0 ffff8802560efc78 ffff8802560efc78 ffff8802560efd10
> > Call Trace:
> >  [<ffffffff814e7e35>] ? dump_stack+0x41/0x51  [<ffffffffa0008755>] ?
> > iwl_trans_pcie_send_hcmd+0x525/0x560 [iwlwifi]  [<ffffffff810744f0>] ?
> > prepare_to_wait_event+0xf0/0xf0  [<ffffffffa0034633>] ?
> > iwl_mvm_send_cmd_status+0x33/0x120 [iwlmvm]  [<ffffffffa00396f5>] ?
> > iwl_mvm_scan_request+0x355/0x430 [iwlmvm]  [<ffffffffa003074e>] ?
> > iwl_mvm_mac_hw_scan+0x6e/0x80 [iwlmvm]  [<ffffffff814b503f>] ?
> > __ieee80211_scan_completed+0x12f/0x1e0
> >  [<ffffffff814b5afa>] ? ieee80211_scan_work+0xda/0x490
> > [<ffffffff810591ec>] ? process_one_work+0x13c/0x3c0
> > [<ffffffff81059d56>] ? worker_thread+0x116/0x3a0  [<ffffffff81059c40>]
> > ? manage_workers.isra.30+0x280/0x280
> >  [<ffffffff8105f041>] ? kthread+0xc1/0xe0  [<ffffffff8105ef80>] ?
> > kthread_create_on_node+0x180/0x180
> >  [<ffffffff814ee4bc>] ? ret_from_fork+0x7c/0xb0  [<ffffffff8105ef80>]
> > ? kthread_create_on_node+0x180/0x180
> > iwlwifi 0000:01:00.0: Scan failed! status 0x1 ret -5 iwlwifi
> > 0000:01:00.0: Start IWL Error Log Dump:
> > iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6 iwlwifi
> > 0000:01:00.0: 0x000014F4 | ADVANCED_SYSASSERT iwlwifi 0000:01:00.0:
> > 0x000002B0 | uPc iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> > iwlwifi 0000:01:00.0: 0x00000C2A | branchlink2 iwlwifi 0000:01:00.0:
> > 0x00015ADC | interruptlink1 iwlwifi 0000:01:00.0: 0x001B20FB |
> > interruptlink2 iwlwifi 0000:01:00.0: 0x00000175 | data1 iwlwifi
> > 0000:01:00.0: 0x00000024 | data2 iwlwifi 0000:01:00.0: 0x000000E0 |
> > data3 iwlwifi 0000:01:00.0: 0x003522B5 | beacon time iwlwifi
> > 0000:01:00.0: 0x00572B49 | tsf low iwlwifi 0000:01:00.0: 0x00000000 |
> > tsf hi iwlwifi 0000:01:00.0: 0x00000000 | time gp1 iwlwifi
> > 0000:01:00.0: 0x00572B49 | time gp2 iwlwifi 0000:01:00.0: 0x00000000 |
> > time gp3 iwlwifi 0000:01:00.0: 0x0004160F | uCode version iwlwifi
> > 0000:01:00.0: 0x00000144 | hw version iwlwifi 0000:01:00.0: 0x00489204
> > | board version iwlwifi 0000:01:00.0: 0x091F0080 | hcmd iwlwifi
> > 0000:01:00.0: 0x00022080 | isr0 iwlwifi 0000:01:00.0: 0x00000000 |
> > isr1 iwlwifi 0000:01:00.0: 0x00000002 | isr2 iwlwifi 0000:01:00.0:
> > 0x0041FCC0 | isr3 iwlwifi 0000:01:00.0: 0x00000001 | isr4 iwlwifi
> > 0000:01:00.0: 0x01000112 | isr_pref iwlwifi 0000:01:00.0: 0x00000000 |
> > wait_event iwlwifi 0000:01:00.0: 0x00000080 | l2p_control iwlwifi
> > 0000:01:00.0: 0x00010000 | l2p_duration iwlwifi 0000:01:00.0:
> > 0x0000003F | l2p_mhvalid iwlwifi 0000:01:00.0: 0x00000000 |
> > l2p_addr_match iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel iwlwifi
> > 0000:01:00.0: 0x22121614 | timestamp iwlwifi 0000:01:00.0: 0x00002838
> > | flow_handler
> > ieee80211 phy0: Hardware restart was requested iwlwifi 0000:01:00.0:
> > L1 Disabled; Enabling L0S iwlwifi 0000:01:00.0: L1 Disabled; Enabling
> > L0S

