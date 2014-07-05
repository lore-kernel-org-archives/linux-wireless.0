Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50580 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaGEBhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 21:37:24 -0400
Received: by mail-ob0-f174.google.com with SMTP id va2so2392519obc.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2014 18:37:23 -0700 (PDT)
Message-ID: <53B756D8.1080909@lwfinger.net> (sfid-20140705_033757_321791_11F25CF8)
Date: Fri, 04 Jul 2014 20:37:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Microcode SW errors for Intel 7260
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wireless device in my new Toshiba Tecra A50 reports the following when using 
'lspci -nnv':

04:00.0 Network controller [0280]: Intel Corporation Wireless 7260 [8086:08b1] 
(rev 73)
         Subsystem: Intel Corporation Dual Band Wireless-AC 7260 [8086:4070]
         Flags: bus master, fast devsel, latency 0, IRQ 48
         Memory at e2400000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: <access denied>
         Kernel driver in use: iwlwifi
         Kernel modules: iwlwifi

My kernel is from the wireless-testing tree, and 'git describe' shows

master-2014-06-26-51-g956e5e6

The device seems to work OK, and is connected to channel 36 (5 GHz) with WPA2 
encryption; however, it floods my logs with sequences as follows:

[367733.570361] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 
0x2000000.
[367733.570372] iwlwifi 0000:04:00.0: CSR values:
[367733.570378] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is 
CSR_INT_PERIODIC_REG)
[367733.570396] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
[367733.570413] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X80000040
[367733.570430] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[367733.570448] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[367733.570464] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[367733.570480] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[367733.570496] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[367733.570512] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[367733.570529] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000144
[367733.570581] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
[367733.570605] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X80000000
[367733.570633] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X803a0000
[367733.570659] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[367733.570678] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[367733.570698] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[367733.570718] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[367733.570738] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[367733.570758] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[367733.570779] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88220a0d
[367733.570804] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[367733.570825] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[367733.570845] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
[367733.570864] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[367733.570884] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[367733.570892] iwlwifi 0000:04:00.0: FH register values:
[367733.570924] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 
0X0c05ff00
[367733.570953] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 
0X00c06000
[367733.570984] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 
0X00000028
[367733.571010] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 
0X80801114
[367733.571036] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 
0X000000fc
[367733.571063] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 
0X07030000
[367733.571089] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 
0X00000000
[367733.571116] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 
0X07ff0001
[367733.571142] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 
0X00000000
[367733.571281] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[367733.571286] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[367733.571290] iwlwifi 0000:04:00.0: Loaded firmware version: 23.214.9.0
[367733.571294] iwlwifi 0000:04:00.0: 0x0000277B | ADVANCED_SYSASSERT
[367733.571298] iwlwifi 0000:04:00.0: 0x000002B0 | uPc
[367733.571301] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[367733.571305] iwlwifi 0000:04:00.0: 0x00000BA4 | branchlink2
[367733.571308] iwlwifi 0000:04:00.0: 0x000166A4 | interruptlink1
[367733.571312] iwlwifi 0000:04:00.0: 0x00DB0DD3 | interruptlink2
[367733.571316] iwlwifi 0000:04:00.0: 0x00000024 | data1
[367733.571319] iwlwifi 0000:04:00.0: 0x00000018 | data2
[367733.571323] iwlwifi 0000:04:00.0: 0xDEADBEEF | data3
[367733.571326] iwlwifi 0000:04:00.0: 0x003BE407 | beacon time
[367733.571330] iwlwifi 0000:04:00.0: 0x00041C14 | tsf low
[367733.571333] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[367733.571337] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[367733.571340] iwlwifi 0000:04:00.0: 0x00041C14 | time gp2
[367733.571345] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[367733.571349] iwlwifi 0000:04:00.0: 0x000417D6 | uCode version
[367733.571353] iwlwifi 0000:04:00.0: 0x00000144 | hw version
[367733.571357] iwlwifi 0000:04:00.0: 0x40489204 | board version
[367733.571362] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[367733.571366] iwlwifi 0000:04:00.0: 0x00022000 | isr0
[367733.571370] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[367733.571374] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[367733.571378] iwlwifi 0000:04:00.0: 0x0040D0C0 | isr3
[367733.571382] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[367733.571386] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[367733.571390] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[367733.571394] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[367733.571398] iwlwifi 0000:04:00.0: 0x00010000 | l2p_duration
[367733.571402] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[367733.571406] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[367733.571410] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[367733.571415] iwlwifi 0000:04:00.0: 0x18051651 | timestamp
[367733.571419] iwlwifi 0000:04:00.0: 0x00002830 | flow_handler
[367733.571428] ieee80211 phy0: Hardware restart was requested
[367733.572094] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[367733.572457] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S

Please inform me of any further info that is needed.

Thanks,

Larry
