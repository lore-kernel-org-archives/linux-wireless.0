Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:50657 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2IIIjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2012 04:39:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by uplift.swm.pp.se (Postfix) with ESMTP id CB8D19C
	for <linux-wireless@vger.kernel.org>; Sun,  9 Sep 2012 10:29:26 +0200 (CEST)
Date: Sun, 9 Sep 2012 10:29:26 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-wireless@vger.kernel.org
Subject: problem with 3.2 and iwlwifi
Message-ID: <alpine.DEB.2.00.1209091025480.13902@uplift.swm.pp.se> (sfid-20120909_103913_516900_99CA0543)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ubuntu 12.04:

$ uname -a
Linux swm-laptop 3.2.0-29-generic-pae #46-Ubuntu SMP Fri Jul 27 17:25:43 
UTC 2012 i686 i686 i386 GNU/Linux

Under load (4 megabyte/s) wifi stops working with the below messages in 
dmesg. I rmmod iwlwifi and modprobe it again and then things start 
working. This happens from time to time for me on this Thinkpad X200 with 
"03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300".

Any other info I can provide to help fault finding this?

[95932.501129] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
[95932.501141] iwlwifi 0000:03:00.0: Loaded firmware version: 8.83.5.1 build 33692
[95932.501231] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[95932.501238] iwlwifi 0000:03:00.0: Status: 0x000512E4, count: 5
[95932.501246] iwlwifi 0000:03:00.0: 0x00000016 | NMI_INTERRUPT_TRM
[95932.501253] iwlwifi 0000:03:00.0: 0x000006E4 | uPc
[95932.501258] iwlwifi 0000:03:00.0: 0x000005AA | branchlink1
[95932.501264] iwlwifi 0000:03:00.0: 0x00000776 | branchlink2
[95932.501270] iwlwifi 0000:03:00.0: 0x00000916 | interruptlink1
[95932.501277] iwlwifi 0000:03:00.0: 0x0000D616 | interruptlink2
[95932.501283] iwlwifi 0000:03:00.0: 0x00000040 | data1
[95932.501289] iwlwifi 0000:03:00.0: 0x07030000 | data2
[95932.501295] iwlwifi 0000:03:00.0: 0x000067C6 | line
[95932.501300] iwlwifi 0000:03:00.0: 0x81402089 | beacon time
[95932.501306] iwlwifi 0000:03:00.0: 0x286E7F77 | tsf low
[95932.501312] iwlwifi 0000:03:00.0: 0x000000D7 | tsf hi
[95932.501318] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[95932.501324] iwlwifi 0000:03:00.0: 0x544BDBFF | time gp2
[95932.501330] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[95932.501336] iwlwifi 0000:03:00.0: 0x00010853 | uCode version
[95932.501342] iwlwifi 0000:03:00.0: 0x00000024 | hw version
[95932.501348] iwlwifi 0000:03:00.0: 0x00480302 | board version
[95932.501354] iwlwifi 0000:03:00.0: 0xC010C059 | hcmd
[95932.501360] iwlwifi 0000:03:00.0: CSR values:
[95932.501365] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[95932.501376] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
[95932.501386] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X0000ff40
[95932.501395] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[95932.501405] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[95932.501414] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[95932.501424] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[95932.501433] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[95932.501442] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[95932.501451] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000024
[95932.501461] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[95932.501470] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000004
[95932.501479] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00060000
[95932.501489] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080044
[95932.501498] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X0000a28d
[95932.501507] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[95932.501516] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[95932.501525] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[95932.501535] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000058
[95932.501544] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X8802e974
[95932.501554] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[95932.501563] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[95932.501573] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[95932.501583] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[95932.501589] iwlwifi 0000:03:00.0: FH register values:
[95932.501609] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X036efb00
[95932.501628] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00369e60
[95932.501648] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000098
[95932.501667] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00819104
[95932.501687] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[95932.501706] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[95932.501726] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[95932.501746] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[95932.501766] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[95932.501829] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
[95932.501854] iwlwifi 0000:03:00.0: EVT_LOGT:1414256662:0x544bd815:1587
[95932.501870] iwlwifi 0000:03:00.0: EVT_LOGT:1414256766:0x544bd87e:1587
[95932.501887] iwlwifi 0000:03:00.0: EVT_LOGT:1414256798:0x544bd89e:1587
[95932.501903] iwlwifi 0000:03:00.0: EVT_LOGT:1414256906:0x544bd90a:1587
[95932.501919] iwlwifi 0000:03:00.0: EVT_LOGT:1414257014:0x544bd976:1587
[95932.501935] iwlwifi 0000:03:00.0: EVT_LOGT:1414257122:0x544bd9e2:1587
[95932.501952] iwlwifi 0000:03:00.0: EVT_LOGT:1414257230:0x544bda4d:1587
[95932.501968] iwlwifi 0000:03:00.0: EVT_LOGT:1414257338:0x544bdaba:1587
[95932.501984] iwlwifi 0000:03:00.0: EVT_LOGT:1414257450:0x544bdb29:1587
[95932.502000] iwlwifi 0000:03:00.0: EVT_LOGT:1414257458:0x544bdb31:1587
[95932.502016] iwlwifi 0000:03:00.0: EVT_LOGT:1414257466:0x544bdb3a:1587
[95932.502033] iwlwifi 0000:03:00.0: EVT_LOGT:1414257474:0x544bdb42:1587
[95932.502049] iwlwifi 0000:03:00.0: EVT_LOGT:1414257482:0x544bdb4a:1587
[95932.502065] iwlwifi 0000:03:00.0: EVT_LOGT:1414257490:0x544bdb52:1587
[95932.502082] iwlwifi 0000:03:00.0: EVT_LOGT:1414257498:0x544bdb5a:1587
[95932.502099] iwlwifi 0000:03:00.0: EVT_LOGT:1414257558:0x00000000:0263
[95932.502115] iwlwifi 0000:03:00.0: EVT_LOGT:1414257573:0x00000000:0302
[95932.502131] iwlwifi 0000:03:00.0: EVT_LOGT:1414257607:0x00000094:0303
[95932.502148] iwlwifi 0000:03:00.0: EVT_LOGT:1414257657:0x000000d7:0123
[95932.502164] iwlwifi 0000:03:00.0: EVT_LOGT:1414257668:0x00000000:0125
[95932.502542] ieee80211 phy0: Hardware restart was requested
[95932.502629] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[95932.505634] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0



-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
