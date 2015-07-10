Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:46651 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbbGKIGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 04:06:31 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1ZDiCL-0002E0-BC
	for linux-wireless@vger.kernel.org; Sat, 11 Jul 2015 01:59:18 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.84)
	(envelope-from <sesse@samfundet.no>)
	id 1ZDiCL-0009b2-5I
	for linux-wireless@vger.kernel.org; Sat, 11 Jul 2015 01:59:17 +0200
Date: Sat, 11 Jul 2015 01:59:17 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: [BUG] 7260AC microcode hang
Message-ID: <20150710235917.GA31592@sesse.net> (sfid-20150711_100635_458836_9A662CE2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a Lenovo X240 with an 7260AC (I upgraded it myself, but it is Lenovo
branded). This weekend I'm at an event where I run the Wi-Fi myself with
Cisco gear, mostly 2602i. I've had several instances only today where the
microcode hangs:

Jul 10 19:25:57 klump kernel: [420622.407962] wlan0: Limiting TX power to 4 dBm as advertised by 64:e9:50:7d:1f:80
Jul 10 19:27:44 klump kernel: [420729.220577] wlan0: Limiting TX power to 4 dBm as advertised by 64:e9:50:7d:1f:80
Jul 10 19:30:07 klump kernel: [420872.370557] wlan0: Limiting TX power to 4 dBm as advertised by 64:e9:50:7d:1f:80
Jul 10 19:30:27 klump kernel: [420892.207803] wlan0: Limiting TX power to 4 dBm as advertised by 64:e9:50:7d:1f:80
Jul 10 19:36:06 klump kernel: [421230.918430] wlan0: Limiting TX power to 4 dBm as advertised by 64:e9:50:7d:1f:80
Jul 10 19:36:26 klump kernel: [421250.652146] wlan0: Limiting TX power to 4 dBm as advertised by 64:e9:50:7d:1f:80
Jul 10 19:36:50 klump kernel: [421275.191430] iwlwifi 0000:03:00.0: Queue 16 stuck for 10000 ms.
Jul 10 19:36:50 klump kernel: [421275.191435] iwlwifi 0000:03:00.0: Current SW read_ptr 219 write_ptr 4
Jul 10 19:36:50 klump kernel: [421275.191476] iwl data: 00000000: 00 00 00 f8 00 00 00 00 ff 07 00 00 00 00 00 00  ................
Jul 10 19:36:50 klump kernel: [421275.191488] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
Jul 10 19:36:50 klump kernel: [421275.191499] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc01100ea
Jul 10 19:36:50 klump kernel: [421275.191511] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
Jul 10 19:36:50 klump kernel: [421275.191523] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x8030005d
Jul 10 19:36:50 klump kernel: [421275.191534] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
Jul 10 19:36:50 klump kernel: [421275.191545] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
Jul 10 19:36:50 klump kernel: [421275.191557] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
Jul 10 19:36:50 klump kernel: [421275.191568] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090ff
Jul 10 19:36:50 klump kernel: [421275.191617] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [94,94]
Jul 10 19:36:50 klump kernel: [421275.191666] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.191714] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [89,89]
Jul 10 19:36:50 klump kernel: [421275.191763] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.191811] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.191860] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.191909] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.191959] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192008] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192056] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192104] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192153] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192201] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192249] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192298] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192346] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192395] iwlwifi 0000:03:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [219,4]
Jul 10 19:36:50 klump kernel: [421275.192443] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 3 ra_tid 0x0006 [3,3]
Jul 10 19:36:50 klump kernel: [421275.192491] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192540] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Jul 10 19:36:50 klump kernel: [421275.192589] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
Jul 10 19:36:50 klump kernel: [421275.192591] iwlwifi 0000:03:00.0: CSR values:
Jul 10 19:36:50 klump kernel: [421275.192593] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul 10 19:36:50 klump kernel: [421275.192599] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
Jul 10 19:36:50 klump kernel: [421275.192612] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X80000040
Jul 10 19:36:50 klump kernel: [421275.192624] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192637] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192649] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192662] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192674] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192686] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 10 19:36:50 klump kernel: [421275.192700] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000144
Jul 10 19:36:50 klump kernel: [421275.192712] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192724] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X80000000
Jul 10 19:36:50 klump kernel: [421275.192737] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X803a0000
Jul 10 19:36:50 klump kernel: [421275.192749] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
Jul 10 19:36:50 klump kernel: [421275.192761] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192774] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192786] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192799] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192812] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
Jul 10 19:36:50 klump kernel: [421275.192824] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88233bac
Jul 10 19:36:50 klump kernel: [421275.192837] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 10 19:36:50 klump kernel: [421275.192849] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
Jul 10 19:36:50 klump kernel: [421275.192861] iwlwifi 0000:03:00.0:      CSR_MONITOR_STATUS_REG: 0X3d0801bd
Jul 10 19:36:50 klump kernel: [421275.192874] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 10 19:36:50 klump kernel: [421275.192886] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
Jul 10 19:36:50 klump kernel: [421275.192888] iwlwifi 0000:03:00.0: FH register values:
Jul 10 19:36:50 klump kernel: [421275.192909] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b9ee500
Jul 10 19:36:50 klump kernel: [421275.192921] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b9f170
Jul 10 19:36:50 klump kernel: [421275.192933] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000a0
Jul 10 19:36:50 klump kernel: [421275.192944] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
Jul 10 19:36:50 klump kernel: [421275.192956] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 10 19:36:50 klump kernel: [421275.192968] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
Jul 10 19:36:50 klump kernel: [421275.192979] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.192991] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 10 19:36:50 klump kernel: [421275.193003] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
Jul 10 19:36:50 klump kernel: [421275.193107] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
Jul 10 19:36:50 klump kernel: [421275.193109] iwlwifi 0000:03:00.0: Status: 0x00000000, count: 6
Jul 10 19:36:50 klump kernel: [421275.193110] iwlwifi 0000:03:00.0: Loaded firmware version: 23.15.10.0
Jul 10 19:36:50 klump kernel: [421275.193112] iwlwifi 0000:03:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
Jul 10 19:36:50 klump kernel: [421275.193114] iwlwifi 0000:03:00.0: 0x00000230 | uPc
Jul 10 19:36:50 klump kernel: [421275.193115] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
Jul 10 19:36:50 klump kernel: [421275.193117] iwlwifi 0000:03:00.0: 0x00000B3C | branchlink2
Jul 10 19:36:50 klump kernel: [421275.193118] iwlwifi 0000:03:00.0: 0x00016164 | interruptlink1
Jul 10 19:36:50 klump kernel: [421275.193120] iwlwifi 0000:03:00.0: 0x00008116 | interruptlink2
Jul 10 19:36:50 klump kernel: [421275.193121] iwlwifi 0000:03:00.0: 0x00000000 | data1
Jul 10 19:36:50 klump kernel: [421275.193123] iwlwifi 0000:03:00.0: 0x00000080 | data2
Jul 10 19:36:50 klump kernel: [421275.193124] iwlwifi 0000:03:00.0: 0x07030000 | data3
Jul 10 19:36:50 klump kernel: [421275.193126] iwlwifi 0000:03:00.0: 0xE8418690 | beacon time
Jul 10 19:36:50 klump kernel: [421275.193127] iwlwifi 0000:03:00.0: 0xB30319D2 | tsf low
Jul 10 19:36:50 klump kernel: [421275.193129] iwlwifi 0000:03:00.0: 0x0000000E | tsf hi
Jul 10 19:36:50 klump kernel: [421275.193130] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
Jul 10 19:36:50 klump kernel: [421275.193131] iwlwifi 0000:03:00.0: 0xB6806E08 | time gp2
Jul 10 19:36:50 klump kernel: [421275.193133] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
Jul 10 19:36:50 klump kernel: [421275.193134] iwlwifi 0000:03:00.0: 0x0004170F | uCode version
Jul 10 19:36:50 klump kernel: [421275.193136] iwlwifi 0000:03:00.0: 0x00000144 | hw version
Jul 10 19:36:50 klump kernel: [421275.193137] iwlwifi 0000:03:00.0: 0x40489204 | board version
Jul 10 19:36:50 klump kernel: [421275.193139] iwlwifi 0000:03:00.0: 0x0000001C | hcmd
Jul 10 19:36:50 klump kernel: [421275.193140] iwlwifi 0000:03:00.0: 0x24022002 | isr0
Jul 10 19:36:50 klump kernel: [421275.193141] iwlwifi 0000:03:00.0: 0x01800000 | isr1
Jul 10 19:36:50 klump kernel: [421275.193143] iwlwifi 0000:03:00.0: 0x00000002 | isr2
Jul 10 19:36:50 klump kernel: [421275.193144] iwlwifi 0000:03:00.0: 0x004140C0 | isr3
Jul 10 19:36:50 klump kernel: [421275.193146] iwlwifi 0000:03:00.0: 0x00000000 | isr4
Jul 10 19:36:50 klump kernel: [421275.193147] iwlwifi 0000:03:00.0: 0x00000110 | isr_pref
Jul 10 19:36:50 klump kernel: [421275.193148] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
Jul 10 19:36:50 klump kernel: [421275.193150] iwlwifi 0000:03:00.0: 0x00000080 | l2p_control
Jul 10 19:36:50 klump kernel: [421275.193151] iwlwifi 0000:03:00.0: 0x00010030 | l2p_duration
Jul 10 19:36:50 klump kernel: [421275.193153] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
Jul 10 19:36:50 klump kernel: [421275.193154] iwlwifi 0000:03:00.0: 0x000000CE | l2p_addr_match
Jul 10 19:36:50 klump kernel: [421275.193155] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
Jul 10 19:36:50 klump kernel: [421275.193157] iwlwifi 0000:03:00.0: 0x03031311 | timestamp
Jul 10 19:36:50 klump kernel: [421275.193158] iwlwifi 0000:03:00.0: 0x0034A0B0 | flow_handler
Jul 10 19:36:50 klump kernel: [421275.193162] ieee80211 phy0: Hardware restart was requested
Jul 10 19:36:50 klump kernel: [421275.314984] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
Jul 10 19:36:50 klump kernel: [421275.315679] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
Jul 10 19:36:50 klump kernel: [421275.528028] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
Jul 10 19:36:50 klump kernel: [421275.528540] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
Jul 10 19:36:51 klump kernel: [421276.024718] wlan0: deauthenticated from 64:e9:50:7d:1f:80 (Reason: 7=CLASS3_FRAME_FROM_NONASSOC_STA)
Jul 10 19:36:51 klump kernel: [421276.060019] cfg80211: Calling CRDA to update world regulatory domain
Jul 10 19:36:51 klump kernel: [421276.060441] wlan0: authenticate with 64:e9:50:7d:1f:80
Jul 10 19:36:51 klump kernel: [421276.067305] wlan0: send auth to 64:e9:50:7d:1f:80 (try 1/3)

At this point, my Wi-Fi is usually so hosed that I just have to reboot;
SSH lags etc., and then after a while all networking just hangs.

Now, a different question is why Linux insists on using 2.4 GHz even though
it's super-congested and the APs have turned down the power significantly
(you can see it's asked to send at 4 dBm in the log there). But that's a
different and much broader story :-) (I don't have band-select on.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
