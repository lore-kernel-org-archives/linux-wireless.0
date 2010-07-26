Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57991 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0GZTJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 15:09:19 -0400
Received: by pwi5 with SMTP id 5so201892pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 12:09:19 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 26 Jul 2010 15:08:59 -0400
Message-ID: <AANLkTimo4RV6UMgti0ng1rQYE2eUVh2WLv_WHQZkz30j@mail.gmail.com>
Subject: iwlagn: two regressions 2.6.34->2.6.35-rc6
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regression 1:  I got a SYSASSERT.  rmmod/modprobe fixed it.  No fancy
debug because I can't reproduce it.

[  167.648419] phy0: device no longer idle - scanning
[  167.656408] phy0: device now idle
[  167.715946] phy0: device no longer idle - scanning
[  167.716066] iwlagn 0000:03:00.0: Microcode SW error detected.
Restarting 0x82000000.
[  167.716069] iwlagn 0000:03:00.0: Loaded firmware version: 8.24.2.12
[  167.716105] iwlagn 0000:03:00.0: Start IWL Error Log Dump:
[  167.716108] iwlagn 0000:03:00.0: Status: 0x0002B2E4, count: 5
[  167.716302] iwlagn 0000:03:00.0: Desc
Time       data1      data2      line
[  167.716307] iwlagn 0000:03:00.0: SYSASSERT                    (#05)
1042449688 0x00200200 0x00000000 1051
[  167.716312] iwlagn 0000:03:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
[  167.716316] iwlagn 0000:03:00.0: 0x02CC8 0x02C98 0x02C98 0x008B2
0x00000 0x441C0080
[  167.716319] iwlagn 0000:03:00.0: CSR values:
[  167.716322] iwlagn 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  167.716350] iwlagn 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480301
[  167.716376] iwlagn 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  167.716401] iwlagn 0000:03:00.0:                     CSR_INT: 0X00000000
[  167.716409] iwlagn 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  167.716418] iwlagn 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  167.716426] iwlagn 0000:03:00.0:                 CSR_GPIO_IN: 0X00000008
[  167.716435] iwlagn 0000:03:00.0:                   CSR_RESET: 0X00000000
[  167.716444] iwlagn 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  167.716452] iwlagn 0000:03:00.0:                  CSR_HW_REV: 0X00000024
[  167.716461] iwlagn 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[  167.716470] iwlagn 0000:03:00.0:               CSR_EEPROM_GP: 0X90000804
[  167.716478] iwlagn 0000:03:00.0:              CSR_OTP_GP_REG: 0X00060000
[  167.716487] iwlagn 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
[  167.716495] iwlagn 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00002183
[  167.716504] iwlagn 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  167.716529] iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  167.716537] iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  167.716563] iwlagn 0000:03:00.0:                 CSR_LED_REG: 0X00000058
[  167.716588] iwlagn 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88135b6a
[  167.716614] iwlagn 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  167.716639] iwlagn 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[  167.716664] iwlagn 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  167.716673] iwlagn 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  167.716675] iwlagn 0000:03:00.0: FH register values:
[  167.716710] iwlagn 0000:03:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X133cf500
[  167.716730] iwlagn 0000:03:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01339760
[  167.716750] iwlagn 0000:03:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000098
[  167.716770] iwlagn 0000:03:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  167.716789] iwlagn 0000:03:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  167.716808] iwlagn 0000:03:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  167.716827] iwlagn 0000:03:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  167.716846] iwlagn 0000:03:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  167.716865] iwlagn 0000:03:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  167.716922] iwlagn 0000:03:00.0: Start IWL Event Log Dump: display
last 20 entries
[  167.716944] iwlagn 0000:03:00.0: EVT_LOGT:0151076484:0x00000037:0353
[  167.716975] iwlagn 0000:03:00.0: EVT_LOGT:0151076880:0x0000010f:0106
[  167.717006] iwlagn 0000:03:00.0: EVT_LOGT:0151076881:0x00000000:0302
[  167.717037] iwlagn 0000:03:00.0: EVT_LOGT:0151076905:0x00000038:0353
[  167.717051] iwlagn 0000:03:00.0: EVT_LOGT:0151077567:0x441c0080:0401
[  167.717066] iwlagn 0000:03:00.0: EVT_LOGT:0151077568:0x441c0080:0700
[  167.717080] iwlagn 0000:03:00.0: EVT_LOGT:0151077569:0x00000000:0706
[  167.717094] iwlagn 0000:03:00.0: EVT_LOGT:0151077585:0x00000001:0452
[  167.717109] iwlagn 0000:03:00.0: EVT_LOGT:0151077587:0x00000001:0452
[  167.717139] iwlagn 0000:03:00.0: EVT_LOGT:0151077588:0x00000233:0601
[  167.717153] iwlagn 0000:03:00.0: EVT_LOGT:0151077589:0x00000061:0600
[  167.717168] iwlagn 0000:03:00.0: EVT_LOGT:0151077591:0x0000007a:0602
[  167.717182] iwlagn 0000:03:00.0: EVT_LOGT:0151077597:0x00000100:0706
[  167.717213] iwlagn 0000:03:00.0: EVT_LOGT:0151077601:0x00000000:0708
[  167.717227] iwlagn 0000:03:00.0: EVT_LOGT:0151077603:0x01000200:0706
[  167.717258] iwlagn 0000:03:00.0: EVT_LOGT:0151077613:0x01000200:0725
[  167.717263] iwlagn 0000:03:00.0: EVT_LOGT:0151077613:0x00000000:0709
[  167.717263] iwlagn 0000:03:00.0: EVT_LOGT:0151077614:0x00000000:0707
[  167.717263] iwlagn 0000:03:00.0: EVT_LOGT:0151077614:0x02000201:0706
[  167.717263] iwlagn 0000:03:00.0: EVT_LOGT:0151077622:0x00000000:0125


Regression 2:

On 2.6.34 my wireless appears to be rock solid (yay -- it's been awhile).

On 2.6.35-rc6, I have an AP here that doesn't work well.  It's an
EnGenius ESR-7750 with latest firmware.  I can connect to its 2.4GHz
radio (usually but it seems to connect more slowly than 2.6.34), but I
can't always see the 5GHz radio, let alone connect.  It's connected
exactly once out of many tries on 2.6.35-rc6, but it works fine on
2.6.34.

In the attached log, you'll see the one successful connection to
00:02:6f:6e:d7:6c as well as a failure.  The failure is just:

[  668.569218] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 1)
[  668.769269] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 2)
[  668.969150] wlan0: authenticate with 00:02:6f:6e:d7:6c (try 3)
[  669.169262] wlan0: authentication with 00:02:6f:6e:d7:6c timed out

--Andy
