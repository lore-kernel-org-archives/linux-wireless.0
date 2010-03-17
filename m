Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f201.google.com ([209.85.211.201]:54547 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0CQNNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 09:13:47 -0400
Received: by ywh39 with SMTP id 39so409886ywh.21
        for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 06:13:46 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 08:13:46 -0500
Message-ID: <f39b508c1003170613g5a8754a2kc9e15075c16f499b@mail.gmail.com>
Subject: 
From: Vasil Lalov <vasil.lalov@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am seeing some weird behavior with the iwlagn driver from linuxwireless.com:

My Intel 5300 wireless card will randomly disassociate itself from the
access point. It happens with or without security enabled. It only
happens when using the 802.11n mode. I've noticed that the further
away I am from the AP, the LOWER the chances of this to happen. If I
put my laptop within 2-3 feet from the access point, the wireless card
will disassociate itself on average once every 30 seconds.

Here is some data:

uname -a
Linux red 2.6.31-20-generic #57-Ubuntu SMP Mon Feb 8 09:02:26 UTC 2010
x86_64 GNU/Linux

filename:
/lib/modules/2.6.31-20-generic/updates/drivers/net/wireless/iwlwifi/iwlagn.ko
alias:          iwl4965
license:        GPL
author:         Copyright(c) 2003-2010 Intel Corporation <ilw@linux.intel.com>
version:        in-tree:
description:    Intel(R) Wireless WiFi Link AGN driver for Linux
firmware:       iwlwifi-4965-2.ucode
firmware:       iwlwifi-5150-2.ucode
firmware:       iwlwifi-5000-2.ucode
firmware:       iwlwifi-6050-4.ucode
firmware:       iwlwifi-6000-4.ucode
firmware:       iwlwifi-1000-3.ucode
srcversion:     10AEF71B7C48925A15AC101
alias:          pci:v00008086d00000084sv*sd00001316bc*sc*i*
alias:          pci:v00008086d00000084sv*sd00001216bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001326bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001226bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001306bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001206bc*sc*i*
alias:          pci:v00008086d00000084sv*sd00001315bc*sc*i*
alias:          pci:v00008086d00000084sv*sd00001215bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001325bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001225bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001305bc*sc*i*
alias:          pci:v00008086d00000083sv*sd00001205bc*sc*i*
alias:          pci:v00008086d00000089sv*sd00001316bc*sc*i*
alias:          pci:v00008086d00000089sv*sd00001311bc*sc*i*
alias:          pci:v00008086d00000087sv*sd00001326bc*sc*i*
alias:          pci:v00008086d00000087sv*sd00001321bc*sc*i*
alias:          pci:v00008086d00000087sv*sd00001306bc*sc*i*
alias:          pci:v00008086d00000087sv*sd00001301bc*sc*i*
alias:          pci:v00008086d00004239sv*sd00001316bc*sc*i*
alias:          pci:v00008086d00004239sv*sd00001311bc*sc*i*
alias:          pci:v00008086d00004238sv*sd00001111bc*sc*i*
alias:          pci:v00008086d0000422Csv*sd00001326bc*sc*i*
alias:          pci:v00008086d0000422Csv*sd00001321bc*sc*i*
alias:          pci:v00008086d0000422Csv*sd00001307bc*sc*i*
alias:          pci:v00008086d0000422Csv*sd00001306bc*sc*i*
alias:          pci:v00008086d0000422Csv*sd00001301bc*sc*i*
alias:          pci:v00008086d0000422Bsv*sd00001121bc*sc*i*
alias:          pci:v00008086d0000422Bsv*sd00001101bc*sc*i*
alias:          pci:v00008086d0000423Dsv*sd00001316bc*sc*i*
alias:          pci:v00008086d0000423Dsv*sd00001216bc*sc*i*
alias:          pci:v00008086d0000423Dsv*sd00001311bc*sc*i*
alias:          pci:v00008086d0000423Dsv*sd00001211bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd00001321bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd00001221bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd00001306bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd00001206bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd00001301bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd00001201bc*sc*i*
alias:          pci:v00008086d0000423Bsv*sd00001011bc*sc*i*
alias:          pci:v00008086d0000423Asv*sd00001021bc*sc*i*
alias:          pci:v00008086d0000423Asv*sd00001001bc*sc*i*
alias:          pci:v00008086d00004236sv*sd00001114bc*sc*i*
alias:          pci:v00008086d00004236sv*sd00001014bc*sc*i*
alias:          pci:v00008086d00004236sv*sd00001111bc*sc*i*
alias:          pci:v00008086d00004236sv*sd00001011bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001104bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001004bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001101bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001001bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001124bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001024bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001121bc*sc*i*
alias:          pci:v00008086d00004235sv*sd00001021bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001316bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001216bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001315bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001215bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001314bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001214bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001311bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001211bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001326bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001226bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001325bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001225bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001324bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001224bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001321bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001221bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001306bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001206bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001305bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001205bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001304bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001204bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001301bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001201bc*sc*i*
alias:          pci:v00008086d00004230sv*sd*bc*sc*i*
alias:          pci:v00008086d00004229sv*sd*bc*sc*i*
depends:        iwlcore,mac80211,compat_firmware_class,cfg80211
vermagic:       2.6.31-20-generic SMP mod_unload modversions
parm:           swcrypto50:using software crypto engine (default 0 [hardware])
 (bool)
parm:           queues_num50:number of hw queues in 50xx series (int)
parm:           11n_disable50:disable 50XX 11n functionality (int)
parm:           amsdu_size_8K50:enable 8K amsdu size in 50XX series (int)
parm:           fw_restart50:restart firmware in case of error (int)
parm:           antenna:select antenna (1=Main, 2=Aux, default 0 [both]) (int)
parm:           swcrypto:using crypto in software (default 0 [hardware]) (int)
parm:           disable_hw_scan:disable hardware scanning (default 0) (int)
parm:           queues_num:number of hw queues. (int)
parm:           11n_disable:disable 11n functionality (int)
parm:           amsdu_size_8K:enable 8K amsdu size (int)
parm:           fw_restart4965:restart firmware in case of error (int)


The error messages in dmesg:

iwlagn 0000:0c:00.0: Microcode SW error detected.  Restarting 0x2000000.
[40595.037808] iwlagn 0000:0c:00.0: Start IWL Error Log Dump:
[40595.037814] iwlagn 0000:0c:00.0: Status: 0x000212E4, count: 5
[40595.037945] iwlagn 0000:0c:00.0: Desc
Time       data1      data2      line
[40595.037954] iwlagn 0000:0c:00.0: NMI_INTERRUPT_WDG            (#04)
3570070946 0x00000002 0x07030000 3664
[40595.037960] iwlagn 0000:0c:00.0: blink1  blink2  ilink1  ilink2
[40595.037966] iwlagn 0000:0c:00.0: 0x005AA 0x006E8 0x008B2 0x02294
[40595.037972] iwlagn 0000:0c:00.0: CSR values:
[40595.037976] iwlagn 0000:0c:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[40595.037986] iwlagn 0000:0c:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480301
[40595.037994] iwlagn 0000:0c:00.0:          CSR_INT_COALESCING: 0X00000040
[40595.038003] iwlagn 0000:0c:00.0:                     CSR_INT: 0X04000000
[40595.038012] iwlagn 0000:0c:00.0:                CSR_INT_MASK: 0X00000000
[40595.038020] iwlagn 0000:0c:00.0:           CSR_FH_INT_STATUS: 0X00000000
[40595.038029] iwlagn 0000:0c:00.0:                 CSR_GPIO_IN: 0X00000000
[40595.038037] iwlagn 0000:0c:00.0:                   CSR_RESET: 0X00000000
[40595.038046] iwlagn 0000:0c:00.0:                CSR_GP_CNTRL: 0X080403c5
[40595.038054] iwlagn 0000:0c:00.0:                  CSR_HW_REV: 0X00000024
[40595.038062] iwlagn 0000:0c:00.0:              CSR_EEPROM_REG: 0X00000000
[40595.038071] iwlagn 0000:0c:00.0:               CSR_EEPROM_GP: 0X90000004
[40595.038079] iwlagn 0000:0c:00.0:              CSR_OTP_GP_REG: 0X00060000
[40595.038088] iwlagn 0000:0c:00.0:                 CSR_GIO_REG: 0X00080046
[40595.038096] iwlagn 0000:0c:00.0:            CSR_GP_UCODE_REG: 0X00004547
[40595.038104] iwlagn 0000:0c:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[40595.038112] iwlagn 0000:0c:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[40595.038121] iwlagn 0000:0c:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[40595.038129] iwlagn 0000:0c:00.0:                 CSR_LED_REG: 0X00000058
[40595.038138] iwlagn 0000:0c:00.0:        CSR_DRAM_INT_TBL_REG: 0X88110576
[40595.038146] iwlagn 0000:0c:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[40595.038154] iwlagn 0000:0c:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[40595.038163] iwlagn 0000:0c:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[40595.038171] iwlagn 0000:0c:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[40595.038176] iwlagn 0000:0c:00.0: FH register values:
[40595.038194] iwlagn 0000:0c:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1100a800
[40595.038212] iwlagn 0000:0c:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01105640
[40595.038231] iwlagn 0000:0c:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000078
[40595.038249] iwlagn 0000:0c:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[40595.038267] iwlagn 0000:0c:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[40595.038286] iwlagn 0000:0c:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[40595.038304] iwlagn 0000:0c:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[40595.038322] iwlagn 0000:0c:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[40595.038340] iwlagn 0000:0c:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[40595.038402] iwlagn 0000:0c:00.0: Start IWL Event Log Dump: display
last 20 entries
[40595.038426] iwlagn 0000:0c:00.0: EVT_LOGT:2749976970:0x0000010f:0106
[40595.038441] iwlagn 0000:0c:00.0: EVT_LOGT:2749976972:0x00000000:0301
[40595.038456] iwlagn 0000:0c:00.0: EVT_LOGT:2749977046:0x00000261:0353
[40595.038471] iwlagn 0000:0c:00.0: EVT_LOGT:2749977367:0x0000010f:0106
[40595.038485] iwlagn 0000:0c:00.0: EVT_LOGT:2749977369:0x00000000:0302
[40595.038500] iwlagn 0000:0c:00.0: EVT_LOGT:2749977395:0x00000436:0323
[40595.038515] iwlagn 0000:0c:00.0: EVT_LOGT:2749977417:0x00000000:1350
[40595.038530] iwlagn 0000:0c:00.0: EVT_LOGT:2749977418:0x00000000:1351
[40595.038545] iwlagn 0000:0c:00.0: EVT_LOGT:2749977418:0x00000001:1352
[40595.038559] iwlagn 0000:0c:00.0: EVT_LOGT:2749977419:0x00000002:1353
[40595.038575] iwlagn 0000:0c:00.0: EVT_LOGT:2749977474:0x000000d4:0322
[40595.038590] iwlagn 0000:0c:00.0: EVT_LOGT:2749977641:0x0000010f:0106
[40595.038604] iwlagn 0000:0c:00.0: EVT_LOGT:2749977642:0x00000000:0302
[40595.038619] iwlagn 0000:0c:00.0: EVT_LOGT:2749977668:0x00000436:0323
[40595.038634] iwlagn 0000:0c:00.0: EVT_LOGT:2749977690:0x00000000:1350
[40595.038649] iwlagn 0000:0c:00.0: EVT_LOGT:2749977690:0x00000000:1351
[40595.038664] iwlagn 0000:0c:00.0: EVT_LOGT:2749977691:0x00000001:1352
[40595.038678] iwlagn 0000:0c:00.0: EVT_LOGT:2749977691:0x00000002:1353
[40595.038693] iwlagn 0000:0c:00.0: EVT_LOGT:2750177633:0x000000d7:0123
[40595.038708] iwlagn 0000:0c:00.0: EVT_LOGT:2750177641:0x00000000:0125
[40595.101312] iwlagn 0000:0c:00.0: Stopping AGG while state not ON or starting
[40595.101318] iwlagn 0000:0c:00.0: queue number out of range: 0, must
be 10 to 19
[40595.101340] iwlagn 0000:0c:00.0: Stopping AGG while state not ON or starting
[40595.101343] iwlagn 0000:0c:00.0: queue number out of range: 0, must
be 10 to 19
[40595.146001] iwlagn 0000:0c:00.0: iwl_tx_agg_start on ra =
00:26:5a:f5:73:3a tid = 0
[40600.324551] iwlagn 0000:0c:00.0: iwl_tx_agg_start on ra =
00:26:5a:f5:73:3a tid = 0
[40600.540126] No probe response from AP 00:26:5a:f5:73:3a after
500ms, disconnecting.
[40600.572606] mac80211-phy0: failed to remove key (0,
00:26:5a:f5:73:3a) from hardware (-22)
[40600.640467] cfg80211: All devices are disconnected, going to
restore regulatory settings
[40600.640481] cfg80211: Restoring regulatory settings
[40600.640489] cfg80211: Calling CRDA to update world regulatory domain
[40600.653155] cfg80211: World regulatory domain updated:
[40600.653163]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[40600.653170]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[40600.653177]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[40600.653183]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[40600.653190]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[40600.653196]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[40620.132020] wlan0: authenticate with 00:26:5a:f5:73:3a (try 1)
[40620.137290] wlan0: authenticated
[40620.137341] wlan0: associate with 00:26:5a:f5:73:3a (try 1)
[40620.142828] wlan0: RX AssocResp from 00:26:5a:f5:73:3a (capab=0x431
status=0 aid=1)
[40620.142832] wlan0: associated
[40622.631049] iwlagn 0000:0c:00.0: iwl_tx_agg_start on ra =
00:26:5a:f5:73:3a tid = 0


Any suggestions?
