Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from j1.co.za ([52.0.118.132]:51738 "EHLO j1.co.za"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbcDKOPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 10:15:06 -0400
Received: from [10.0.0.111] (169-0-102-122.ip.afrihost.co.za [169.0.102.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by j1.co.za (Postfix) with ESMTPSA id EC591401F3
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 14:09:42 +0000 (UTC)
To: linux-wireless@vger.kernel.org
From: Johann Haarhoff <johann@j1.co.za>
Subject: hardware restart on Intel 7260
Message-ID: <570BB012.8060709@j1.co.za> (sfid-20160411_161512_764544_1957CBEF)
Date: Mon, 11 Apr 2016 16:09:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

(Please CC as I am not subscribed to the list)

I'm seeing the following trace on a Lenovo Yoga 2 Pro with an Intel 7260 (rev 6b).

Kernel is 4.5 on using the latest -16 firmware from wireless.wiki.kernel.org. I tried the -17 firmware from git.kernel.org with a
very similar result.

module was loaded with:

options iwlwifi power_save=0 bt_coex_active=0 swcrypto=1

The trace is accompanied by a couple seconds where no data transfer can happen (youtube stutters etc.), but other than that it seems
to resume fine. This happens every 2-15 minutes if I am moving data.

Disabling 11n fixes the problem, but that is not really an viable option.

Please let me know if there is anything I can add to help with the debugging.

> Apr 11 15:52:30  kernel: [13827.165868] iwlwifi 0000:01:00.0: Queue 2 stuck for 10000 ms.
> Apr 11 15:52:30  kernel: [13827.165878] iwlwifi 0000:01:00.0: Current SW read_ptr 135 write_ptr 171
> Apr 11 15:52:30  kernel: [13827.165917] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Apr 11 15:52:30  kernel: [13827.165928] iwlwifi 0000:01:00.0: FH TRBs(0) = 0x00000000
> Apr 11 15:52:30  kernel: [13827.165940] iwlwifi 0000:01:00.0: FH TRBs(1) = 0xc0110003
> Apr 11 15:52:30  kernel: [13827.165951] iwlwifi 0000:01:00.0: FH TRBs(2) = 0x00000000
> Apr 11 15:52:30  kernel: [13827.165962] iwlwifi 0000:01:00.0: FH TRBs(3) = 0x8030000f
> Apr 11 15:52:30  kernel: [13827.165973] iwlwifi 0000:01:00.0: FH TRBs(4) = 0x00000000
> Apr 11 15:52:30  kernel: [13827.165985] iwlwifi 0000:01:00.0: FH TRBs(5) = 0x00000000
> Apr 11 15:52:30  kernel: [13827.165996] iwlwifi 0000:01:00.0: FH TRBs(6) = 0x00000000
> Apr 11 15:52:30  kernel: [13827.166007] iwlwifi 0000:01:00.0: FH TRBs(7) = 0x007090ed
> Apr 11 15:52:30  kernel: [13827.166056] iwlwifi 0000:01:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [16,16]
> Apr 11 15:52:30  kernel: [13827.166104] iwlwifi 0000:01:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166151] iwlwifi 0000:01:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [135,171]
> Apr 11 15:52:30  kernel: [13827.166199] iwlwifi 0000:01:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166247] iwlwifi 0000:01:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166295] iwlwifi 0000:01:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166343] iwlwifi 0000:01:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166391] iwlwifi 0000:01:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166439] iwlwifi 0000:01:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166487] iwlwifi 0000:01:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [238,238]
> Apr 11 15:52:30  kernel: [13827.166535] iwlwifi 0000:01:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166583] iwlwifi 0000:01:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166631] iwlwifi 0000:01:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166679] iwlwifi 0000:01:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166727] iwlwifi 0000:01:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.166930] iwlwifi 0000:01:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167155] iwlwifi 0000:01:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x000f [244,176]
> Apr 11 15:52:30  kernel: [13827.167204] iwlwifi 0000:01:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167254] iwlwifi 0000:01:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167328] iwlwifi 0000:01:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167381] iwlwifi 0000:01:00.0: Q 20 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167444] iwlwifi 0000:01:00.0: Q 21 is inactive and mapped to fifo 0 ra_tid 0xfff0 [0,0]
> Apr 11 15:52:30  kernel: [13827.167551] iwlwifi 0000:01:00.0: Q 22 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167612] iwlwifi 0000:01:00.0: Q 23 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167720] iwlwifi 0000:01:00.0: Q 24 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167781] iwlwifi 0000:01:00.0: Q 25 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167865] iwlwifi 0000:01:00.0: Q 26 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.167941] iwlwifi 0000:01:00.0: Q 27 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.168026] iwlwifi 0000:01:00.0: Q 28 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.168096] iwlwifi 0000:01:00.0: Q 29 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.168147] iwlwifi 0000:01:00.0: Q 30 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> Apr 11 15:52:30  kernel: [13827.168594] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
> Apr 11 15:52:30  kernel: [13827.168595] iwlwifi 0000:01:00.0: CSR values:
> Apr 11 15:52:30  kernel: [13827.168596] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> Apr 11 15:52:30  kernel: [13827.168737] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
> Apr 11 15:52:30  kernel: [13827.168792] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X80000040
> Apr 11 15:52:30  kernel: [13827.168846] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
> Apr 11 15:52:30  kernel: [13827.168899] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
> Apr 11 15:52:30  kernel: [13827.168951] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169006] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169057] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169113] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
> Apr 11 15:52:30  kernel: [13827.169168] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
> Apr 11 15:52:30  kernel: [13827.169224] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169278] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
> Apr 11 15:52:30  kernel: [13827.169330] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
> Apr 11 15:52:30  kernel: [13827.169386] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X001f0042
> Apr 11 15:52:30  kernel: [13827.169441] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169496] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169551] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169606] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> Apr 11 15:52:30  kernel: [13827.169661] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
> Apr 11 15:52:30  kernel: [13827.169715] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X8809776b
> Apr 11 15:52:30  kernel: [13827.169769] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> Apr 11 15:52:30  kernel: [13827.169821] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> Apr 11 15:52:30  kernel: [13827.169887] iwlwifi 0000:01:00.0:      CSR_MONITOR_STATUS_REG: 0X3d0801bd
> Apr 11 15:52:30  kernel: [13827.170050] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> Apr 11 15:52:30  kernel: [13827.170205] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> Apr 11 15:52:30  kernel: [13827.170210] iwlwifi 0000:01:00.0: FH register values:
> Apr 11 15:52:30  kernel: [13827.170378] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X25230b00
> Apr 11 15:52:30  kernel: [13827.170550] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X025230c0
> Apr 11 15:52:30  kernel: [13827.170616] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000060
> Apr 11 15:52:30  kernel: [13827.170783] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
> Apr 11 15:52:30  kernel: [13827.170852] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> Apr 11 15:52:30  kernel: [13827.170921] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
> Apr 11 15:52:30  kernel: [13827.170992] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> Apr 11 15:52:30  kernel: [13827.171158] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> Apr 11 15:52:30  kernel: [13827.171227] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> Apr 11 15:52:30  kernel: [13827.171494] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
> Apr 11 15:52:30  kernel: [13827.171502] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
> Apr 11 15:52:30  kernel: [13827.171508] iwlwifi 0000:01:00.0: Loaded firmware version: 16.242414.0
> Apr 11 15:52:30  kernel: [13827.171515] iwlwifi 0000:01:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
> Apr 11 15:52:30  kernel: [13827.171520] iwlwifi 0000:01:00.0: 0x00A006F5 | uPc
> Apr 11 15:52:30  kernel: [13827.171526] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> Apr 11 15:52:30  kernel: [13827.171531] iwlwifi 0000:01:00.0: 0x00000B2C | branchlink2
> Apr 11 15:52:30  kernel: [13827.171536] iwlwifi 0000:01:00.0: 0x00016A90 | interruptlink1
> Apr 11 15:52:30  kernel: [13827.171542] iwlwifi 0000:01:00.0: 0x00016A90 | interruptlink2
> Apr 11 15:52:30  kernel: [13827.171547] iwlwifi 0000:01:00.0: 0x00000000 | data1
> Apr 11 15:52:30  kernel: [13827.171553] iwlwifi 0000:01:00.0: 0x00000080 | data2
> Apr 11 15:52:30  kernel: [13827.171558] iwlwifi 0000:01:00.0: 0x07030000 | data3
> Apr 11 15:52:30  kernel: [13827.171564] iwlwifi 0000:01:00.0: 0x18C01D9E | beacon time
> Apr 11 15:52:30  kernel: [13827.171569] iwlwifi 0000:01:00.0: 0x30F23214 | tsf low
> Apr 11 15:52:30  kernel: [13827.171575] iwlwifi 0000:01:00.0: 0x000000A5 | tsf hi
> Apr 11 15:52:30  kernel: [13827.171580] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
> Apr 11 15:52:30  kernel: [13827.171585] iwlwifi 0000:01:00.0: 0x0D3D99AB | time gp2
> Apr 11 15:52:30  kernel: [13827.171590] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
> Apr 11 15:52:30  kernel: [13827.171596] iwlwifi 0000:01:00.0: 0x00000010 | uCode version major
> Apr 11 15:52:30  kernel: [13827.171601] iwlwifi 0000:01:00.0: 0x0003B2EE | uCode version minor
> Apr 11 15:52:30  kernel: [13827.171607] iwlwifi 0000:01:00.0: 0x00000144 | hw version
> Apr 11 15:52:30  kernel: [13827.171612] iwlwifi 0000:01:00.0: 0x40489204 | board version
> Apr 11 15:52:30  kernel: [13827.171616] iwlwifi 0000:01:00.0: 0x10F4001C | hcmd
> Apr 11 15:52:30  kernel: [13827.171621] iwlwifi 0000:01:00.0: 0x80122002 | isr0
> Apr 11 15:52:30  kernel: [13827.171626] iwlwifi 0000:01:00.0: 0x00000000 | isr1
> Apr 11 15:52:30  kernel: [13827.171631] iwlwifi 0000:01:00.0: 0x0000000A | isr2
> Apr 11 15:52:30  kernel: [13827.171637] iwlwifi 0000:01:00.0: 0x0041F4C4 | isr3
> Apr 11 15:52:30  kernel: [13827.171642] iwlwifi 0000:01:00.0: 0x00000000 | isr4
> Apr 11 15:52:30  kernel: [13827.171647] iwlwifi 0000:01:00.0: 0x00000110 | isr_pref
> Apr 11 15:52:30  kernel: [13827.171653] iwlwifi 0000:01:00.0: 0x00000000 | wait_event
> Apr 11 15:52:30  kernel: [13827.171659] iwlwifi 0000:01:00.0: 0x0000CFE2 | l2p_control
> Apr 11 15:52:30  kernel: [13827.171664] iwlwifi 0000:01:00.0: 0x00002820 | l2p_duration
> Apr 11 15:52:30  kernel: [13827.171670] iwlwifi 0000:01:00.0: 0x00000003 | l2p_mhvalid
> Apr 11 15:52:30  kernel: [13827.171676] iwlwifi 0000:01:00.0: 0x000000FE | l2p_addr_match
> Apr 11 15:52:30  kernel: [13827.171681] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
> Apr 11 15:52:30  kernel: [13827.171687] iwlwifi 0000:01:00.0: 0x22121936 | timestamp
> Apr 11 15:52:30  kernel: [13827.171693] iwlwifi 0000:01:00.0: 0x00346068 | flow_handler
> Apr 11 15:52:30  kernel: [13827.171702] ieee80211 phy0: Hardware restart was requested


Thanks,

Johann
