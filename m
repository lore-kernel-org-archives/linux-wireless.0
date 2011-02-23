Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:35021 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1BWHAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 02:00:03 -0500
From: jgq516@gmail.com
To: linux-wireless@vger.kernel.org
Cc: jgq516@gmail.com
Subject: Help about Intel Centrino Advanced-N 6205 wifi card
Date: Wed, 23 Feb 2011 15:06:45 +0800
Message-Id: <1298444805-27178-1-git-send-email-jgq516@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have one Intel Centrino Advanced-N 6205 wifi card which need firmware iwlwifi-6000g2a-4.ucode to support it, but in intel website http://intellinuxwireless.org/?n=Downloads, only iwlwifi-6000g2a-5.ucode firmware exists, where can I download the official version
4 firmware? Thanks in advance!

I also got iwlwifi-6000g2a-4.ucode from one website but maybe it has some problems, this firmware works well with kernel 2.6.37-rc1,
but it seems can't compatible with 2.6.36, there are some "Microcode SW error detected" when enable the card, pls see the following
logs, why this error exist with 2.6.36 kernel but disappeared in 2.6.37-rc1 kernel? and unfortunately, I want to work with 2.6.36 kernel:(.

root> dmesg|grep iwl
[    4.194286] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[    4.201576] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    4.207335] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.214313] iwlagn 0000:02:00.0: setting latency timer to 64
[    4.214398] iwlagn 0000:02:00.0: Detected 6000 Series 2x2 AGN Gen2a, REV=0xB0
[    4.239961] iwlagn 0000:02:00.0: device EEPROM VER=0x715, CALIB=0x6
[    4.246224] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    4.254142] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[   15.719763] iwlagn 0000:02:00.0: loaded firmware version 9.201.4.1 build 24255
[   15.753679] phy0: Selected rate control algorithm 'iwl-agn-rs'

root> ifconfig wlan0 up
[   68.599441] iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
[   68.607169] iwlagn 0000:02:00.0: Loaded firmware version: 9.201.4.1 build 24255
[   68.614470] iwlagn 0000:02:00.0: Start IWL Error Log Dump:
[   68.619939] iwlagn 0000:02:00.0: Status: 0x00020224, count: 5
[   68.625853] iwlagn 0000:02:00.0: Desc                                  Time       data1      data2      line
[   68.635650] iwlagn 0000:02:00.0: UCODE_VERSION_MISMATCH       (0x0010) 0000011764 0x0000000B 0x00000005 999
[   68.645363] iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
[   68.652478] iwlagn 0000:02:00.0: 0x031C4 0x1AA7C 0x1AA7C 0x009B2 0x00000 0x400005A
[   68.660025] iwlagn 0000:02:00.0: CSR values:
[   68.664282] iwlagn 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   68.672436] iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480303
[   68.679121] iwlagn 0000:02:00.0:          CSR_INT_COALESCING: 0X0000ff40
[   68.685806] iwlagn 0000:02:00.0:                     CSR_INT: 0X10000000
[   68.692492] iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
[   68.692497] iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
[   68.692502] iwlagn 0000:02:00.0:                 CSR_GPIO_IN: 0X00000030
[   68.692508] iwlagn 0000:02:00.0:                   CSR_RESET: 0X00000000
[   68.692513] iwlagn 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
[   68.692518] iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X000000b0
[   68.692524] iwlagn 0000:02:00.0:              CSR_EEPROM_REG: 0Xbf660ffd
[   68.692530] iwlagn 0000:02:00.0:               CSR_EEPROM_GP: 0X90000001
[   68.692536] iwlagn 0000:02:00.0:              CSR_OTP_GP_REG: 0X00030001
[   68.692541] iwlagn 0000:02:00.0:                 CSR_GIO_REG: 0X00080046
[   68.692547] iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000002
[   68.692553] iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000004
[   68.692559] iwlagn 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   68.692565] iwlagn 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   68.692571] iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000018
[   68.692577] iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   68.692583] iwlagn 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   68.692589] iwlagn 0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   68.692595] iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   68.692601] iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   68.692603] iwlagn 0000:02:00.0: FH register values:
[   68.692626] iwlagn 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0361ee00
[   68.692650] iwlagn 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0034f080
[   68.692674] iwlagn 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000000
[   68.692697] iwlagn 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   68.692721] iwlagn 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   68.692745] iwlagn 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   68.692769] iwlagn 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   68.692793] iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   68.692817] iwlagn 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   68.692913] iwlagn 0000:02:00.0: Log capacity 1024 is bogus, limit to 512 entries
[   68.692915] iwlagn 0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
[   68.692947] iwlagn 0000:02:00.0: EVT_LOGT:0000004085:0x000000ff:1100
[   68.692965] iwlagn 0000:02:00.0: EVT_LOGT:0000004086:0x000000ff:1100
[   68.692984] iwlagn 0000:02:00.0: EVT_LOGT:0000004087:0x000000ff:1100
[   68.693003] iwlagn 0000:02:00.0: EVT_LOGT:0000004087:0x000000ff:1100
[   68.693021] iwlagn 0000:02:00.0: EVT_LOGT:0000004088:0x000000ff:1100
[   68.693040] iwlagn 0000:02:00.0: EVT_LOGT:0000004089:0x000000ff:1100
[   68.693059] iwlagn 0000:02:00.0: EVT_LOGT:0000004089:0x000000ff:1100
[   68.693078] iwlagn 0000:02:00.0: EVT_LOGT:0000004090:0x000000ff:1100
[   68.693096] iwlagn 0000:02:00.0: EVT_LOGT:0000004092:0x000000ff:1100
[   68.693115] iwlagn 0000:02:00.0: EVT_LOGT:0000004092:0x000000ff:1100
[   68.693134] iwlagn 0000:02:00.0: EVT_LOGT:0000004093:0x000000ff:1100
[   68.693153] iwlagn 0000:02:00.0: EVT_LOGT:0000004093:0x000000ff:1100
[   68.693171] iwlagn 0000:02:00.0: EVT_LOGT:0000004094:0x000000ff:1100
[   68.693190] iwlagn 0000:02:00.0: EVT_LOGT:0000004095:0x000000ff:1100
[   68.693209] iwlagn 0000:02:00.0: EVT_LOGT:0000004095:0x000000ff:1100
[   68.693228] iwlagn 0000:02:00.0: EVT_LOGT:0000011598:0x0400005a:0401
[   68.693246] iwlagn 0000:02:00.0: EVT_LOGT:0000011599:0x0400005a:1513
[   68.693265] iwlagn 0000:02:00.0: EVT_LOGT:0000011599:0x00000000:1513
[   68.693284] iwlagn 0000:02:00.0: EVT_LOGT:0000011600:0x00000001:1523
[   68.693303] iwlagn 0000:02:00.0: EVT_LOGT:0000011773:0x00000000:0125
[   68.693329] iwlagn 0000:02:00.0: Command REPLY_PHY_CALIBRATION_CMD failed: FW Error
[   68.693331] iwlagn 0000:02:00.0: Error -5 iteration 0
[   69.192493] iwlagn 0000:02:00.0: Error sending CALIBRATION_CFG_CMD: time out after 500ms.
[   72.585834] iwlagn 0000:02:00.0: START_ALIVE timeout after 4000ms.
SIOCSIFFLAGS: Connection timed out

Best Regards,
Xiao
