Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33316 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbIBPsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 11:48:51 -0400
Received: by qgev79 with SMTP id v79so8115317qge.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 08:48:50 -0700 (PDT)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: iwlwifi lockup problems
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Message-ID: <55E71A60.9010608@gmail.com> (sfid-20150902_174856_918229_8F3EEC16)
Date: Wed, 2 Sep 2015 11:48:48 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070808090909020104080300"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070808090909020104080300
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


Hi,

Since a while I have been experiencing issues with iwlwifi locking up
requiring me to reconnect to my home AP. This happens both when
connecting on 2.4GHz and on 5GHz.

This is a Fedora kernel 4.1.6-200.fc22.x86_64, but checking
linux-2.6.git I see no updates to the driver since late July, so I
suspect it's uptodate on that front. I have been experiencing this issue
for about a month or so.

Attached dmesg output and the relevant portion of iw scan for the AP I
was connected to at the time.

Jes

--------------070808090909020104080300
Content-Type: text/x-log;
 name="iwl-2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iwl-2.log"

[92614.700666] PM: resume of devices complete after 1106.592 msecs
[92614.701187] PM: Finishing wakeup.
[92614.701188] Restarting tasks ... done.
[92614.715377] Bluetooth: hci0: read Intel version: 370810011003110e00
[92614.715382] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq
[92614.854508] systemd[1]: Unit suspend.target is bound to inactive unit systemd-suspend.service. Stopping, too.
[92614.921506] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[92615.247110] e1000e: eth0 NIC Link is Down
[92615.250299] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[92615.442981] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[92615.444497] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[92615.445037] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[92615.445484] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[92615.506918] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[92615.507377] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[92615.529039] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[92615.625863] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[92615.928377] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[92618.826468] wlan0: authenticate with 38:2c:4a:cb:b5:48
[92618.832853] wlan0: send auth to 38:2c:4a:cb:b5:48 (try 1/3)
[92618.834738] wlan0: authenticated
[92618.835866] wlan0: associate with 38:2c:4a:cb:b5:48 (try 1/3)
[92618.839677] wlan0: RX AssocResp from 38:2c:4a:cb:b5:48 (capab=0x1431 status=0 aid=1)
[92618.850530] wlan0: associated
[92618.850584] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[94379.661070] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[94379.661078] iwlwifi 0000:04:00.0: Current SW read_ptr 98 write_ptr 219
[94379.661117] iwl data: 00000000: 00 00 00 00 00 00 00 00 fc ff 03 00 00 00 00 00  ................
[94379.661129] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[94379.661141] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc0110071
[94379.661153] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[94379.661164] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x8030000a
[94379.661175] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[94379.661187] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[94379.661198] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[94379.661210] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x00709060
[94379.661259] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [11,11]
[94379.661307] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[94379.661356] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [181,181]
[94379.661404] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661452] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661501] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661549] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661597] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661646] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[94379.661694] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [97,97]
[94379.661742] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661791] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661839] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661887] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661935] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.661983] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[94379.662031] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [98,219]
[94379.662079] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.662128] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.662176] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[94379.662229] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[94379.662231] iwlwifi 0000:04:00.0: CSR values:
[94379.662232] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[94379.662238] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[94379.662249] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[94379.662252] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[94379.662256] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[94379.662259] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[94379.662262] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[94379.662265] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[94379.662268] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[94379.662271] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[94379.662275] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[94379.662278] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[94379.662281] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[94379.662284] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[94379.662287] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[94379.662290] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[94379.662294] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[94379.662297] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[94379.662300] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[94379.662303] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[94379.662306] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[94379.662309] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[94379.662313] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7ff57
[94379.662316] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[94379.662319] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[94379.662320] iwlwifi 0000:04:00.0: FH register values:
[94379.662342] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[94379.662353] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[94379.662364] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000060
[94379.662376] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[94379.662386] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[94379.662398] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[94379.662409] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[94379.662420] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[94379.662431] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[94379.662535] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[94379.662536] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[94379.662537] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[94379.662538] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[94379.662539] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[94379.662540] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[94379.662541] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[94379.662542] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[94379.662543] iwlwifi 0000:04:00.0: 0x00002B7C | interruptlink2
[94379.662543] iwlwifi 0000:04:00.0: 0x00000000 | data1
[94379.662544] iwlwifi 0000:04:00.0: 0x00000080 | data2
[94379.662545] iwlwifi 0000:04:00.0: 0x07030000 | data3
[94379.662546] iwlwifi 0000:04:00.0: 0x0841758F | beacon time
[94379.662547] iwlwifi 0000:04:00.0: 0xF226FA4D | tsf low
[94379.662548] iwlwifi 0000:04:00.0: 0x000002B8 | tsf hi
[94379.662549] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[94379.662550] iwlwifi 0000:04:00.0: 0x691618C4 | time gp2
[94379.662551] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[94379.662552] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[94379.662552] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[94379.662553] iwlwifi 0000:04:00.0: 0x00489200 | board version
[94379.662554] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[94379.662555] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[94379.662556] iwlwifi 0000:04:00.0: 0x00800000 | isr1
[94379.662557] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[94379.662558] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[94379.662559] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[94379.662559] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[94379.662560] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[94379.662561] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[94379.662562] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[94379.662563] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[94379.662564] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[94379.662565] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[94379.662566] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[94379.662567] iwlwifi 0000:04:00.0: 0x00346070 | flow_handler
[94379.662569] ieee80211 phy0: Hardware restart was requested
[94379.815232] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[94379.815647] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[94379.877155] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[94379.877606] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95102.665666] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[95102.665672] iwlwifi 0000:04:00.0: Current SW read_ptr 80 write_ptr 179
[95102.665996] iwl data: 00000000: 00 00 ff ff 00 00 00 00 00 00 00 00 00 00 00 00  ................
[95102.666008] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[95102.666019] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc011005f
[95102.666031] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[95102.666042] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300009
[95102.666053] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[95102.666065] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[95102.666076] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[95102.666087] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x00709012
[95102.666135] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [10,10]
[95102.666183] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[95102.666231] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [182,182]
[95102.666279] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666327] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666375] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666422] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666471] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666518] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[95102.666566] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [19,19]
[95102.666614] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666663] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666711] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666758] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666806] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666854] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[95102.666902] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [80,179]
[95102.666950] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.666997] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.667045] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95102.667151] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[95102.667154] iwlwifi 0000:04:00.0: CSR values:
[95102.667155] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[95102.667295] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[95102.667346] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[95102.667396] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[95102.667399] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[95102.667403] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[95102.667406] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[95102.667409] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[95102.667412] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[95102.667416] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[95102.667419] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[95102.667422] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[95102.667425] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[95102.667428] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[95102.667432] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[95102.667435] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[95102.667438] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[95102.667441] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[95102.667445] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[95102.667496] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[95102.667551] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[95102.667606] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[95102.667659] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f7d7
[95102.667713] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[95102.667764] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[95102.667765] iwlwifi 0000:04:00.0: FH register values:
[95102.667827] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[95102.667838] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[95102.667849] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000020
[95102.667860] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[95102.667871] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[95102.667882] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[95102.667893] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[95102.667904] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[95102.667915] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[95102.668017] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[95102.668018] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[95102.668019] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[95102.668020] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[95102.668021] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[95102.668022] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[95102.668023] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[95102.668024] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[95102.668025] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[95102.668026] iwlwifi 0000:04:00.0: 0x00000000 | data1
[95102.668027] iwlwifi 0000:04:00.0: 0x00000080 | data2
[95102.668028] iwlwifi 0000:04:00.0: 0x07030000 | data3
[95102.668029] iwlwifi 0000:04:00.0: 0x720129CE | beacon time
[95102.668030] iwlwifi 0000:04:00.0: 0x1D384607 | tsf low
[95102.668030] iwlwifi 0000:04:00.0: 0x000002B9 | tsf hi
[95102.668031] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[95102.668032] iwlwifi 0000:04:00.0: 0x2B0DFBE7 | time gp2
[95102.668033] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[95102.668034] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[95102.668035] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[95102.668036] iwlwifi 0000:04:00.0: 0x00489200 | board version
[95102.668037] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[95102.668038] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[95102.668038] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[95102.668039] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[95102.668040] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[95102.668041] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[95102.668042] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[95102.668043] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[95102.668044] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[95102.668045] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[95102.668045] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[95102.668046] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[95102.668047] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[95102.668048] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[95102.668049] iwlwifi 0000:04:00.0: 0x00342030 | flow_handler
[95102.668052] ieee80211 phy0: Hardware restart was requested
[95102.834402] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95102.834864] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95102.895515] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95102.895974] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95779.516272] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[95817.921613] iwlwifi 0000:04:00.0: Queue 2 stuck for 10000 ms.
[95817.921624] iwlwifi 0000:04:00.0: Current SW read_ptr 160 write_ptr 170
[95817.921796] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[95817.921860] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[95817.921924] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc0110048
[95817.921995] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[95817.922156] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300064
[95817.922221] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[95817.922285] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[95817.922350] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[95817.922415] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x007090df
[95817.922519] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [101,101]
[95817.922623] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[95817.922724] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [160,170]
[95817.922825] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.922928] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923029] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923131] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923227] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923323] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[95817.923420] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [224,224]
[95817.923517] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923613] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923710] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923806] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.923904] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.924001] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[95817.924098] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [57,25]
[95817.924194] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.924290] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.924387] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[95817.924537] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[95817.924539] iwlwifi 0000:04:00.0: CSR values:
[95817.924541] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[95817.924687] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[95817.924845] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[95817.924994] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[95817.925050] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[95817.925105] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[95817.925160] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[95817.925216] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[95817.925270] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[95817.925325] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[95817.925381] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[95817.925436] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[95817.925491] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[95817.925546] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[95817.925611] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[95817.925763] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[95817.925818] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[95817.925873] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[95817.925928] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[95817.925983] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[95817.926039] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[95817.926094] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[95817.926149] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f777
[95817.926204] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[95817.926259] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[95817.926261] iwlwifi 0000:04:00.0: FH register values:
[95817.926324] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[95817.926336] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[95817.926349] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000008
[95817.926361] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[95817.926374] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[95817.926434] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03230000
[95817.926494] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[95817.926555] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[95817.926570] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[95817.926727] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[95817.926729] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[95817.926732] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[95817.926734] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[95817.926736] iwlwifi 0000:04:00.0: 0x00000232 | uPc
[95817.926738] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[95817.926740] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[95817.926742] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[95817.926744] iwlwifi 0000:04:00.0: 0x00006486 | interruptlink2
[95817.926747] iwlwifi 0000:04:00.0: 0x00000000 | data1
[95817.926748] iwlwifi 0000:04:00.0: 0x00000080 | data2
[95817.926750] iwlwifi 0000:04:00.0: 0x07230000 | data3
[95817.926752] iwlwifi 0000:04:00.0: 0x5FC044B8 | beacon time
[95817.926754] iwlwifi 0000:04:00.0: 0x47D36B39 | tsf low
[95817.926756] iwlwifi 0000:04:00.0: 0x000002B9 | tsf hi
[95817.926757] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[95817.926759] iwlwifi 0000:04:00.0: 0x2A979899 | time gp2
[95817.926761] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[95817.926763] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[95817.926765] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[95817.926767] iwlwifi 0000:04:00.0: 0x00489200 | board version
[95817.926768] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[95817.926770] iwlwifi 0000:04:00.0: 0x26322002 | isr0
[95817.926772] iwlwifi 0000:04:00.0: 0x00004000 | isr1
[95817.926774] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[95817.926775] iwlwifi 0000:04:00.0: 0x00414080 | isr3
[95817.926776] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[95817.926777] iwlwifi 0000:04:00.0: 0x10000112 | isr_pref
[95817.926778] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[95817.926779] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[95817.926780] iwlwifi 0000:04:00.0: 0x00011432 | l2p_duration
[95817.926781] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[95817.926782] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[95817.926784] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[95817.926785] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[95817.926786] iwlwifi 0000:04:00.0: 0x00340818 | flow_handler
[95817.926789] ieee80211 phy0: Hardware restart was requested
[95818.131039] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95818.131492] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95818.192828] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95818.193279] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96543.999088] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[96543.999091] iwlwifi 0000:04:00.0: Current SW read_ptr 36 write_ptr 178
[96543.999260] iwl data: 00000000: 00 00 00 00 00 00 00 00 f0 ff 0f 00 00 00 00 00  ................
[96543.999271] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[96543.999282] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc0110033
[96543.999293] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[96543.999304] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x8030004d
[96543.999315] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[96543.999326] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[96543.999337] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[96543.999348] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x0070902c
[96543.999396] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [78,78]
[96543.999443] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[96543.999491] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [17,17]
[96543.999539] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999586] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999634] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999681] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999729] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999776] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[96543.999824] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [45,45]
[96543.999872] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999919] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96543.999967] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96544.000014] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96544.000067] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96544.000165] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[96544.000213] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [36,178]
[96544.000260] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96544.000308] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96544.000355] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96544.000466] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[96544.000469] iwlwifi 0000:04:00.0: CSR values:
[96544.000471] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[96544.000606] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[96544.000656] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[96544.000660] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[96544.000663] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[96544.000666] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[96544.000669] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[96544.000672] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[96544.000676] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[96544.000679] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[96544.000682] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[96544.000685] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[96544.000688] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[96544.000692] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[96544.000695] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[96544.000698] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[96544.000701] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[96544.000704] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[96544.000707] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[96544.000711] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[96544.000714] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[96544.000717] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[96544.000720] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f7d7
[96544.000723] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[96544.000727] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[96544.000728] iwlwifi 0000:04:00.0: FH register values:
[96544.000790] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[96544.000801] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[96544.000812] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f0
[96544.000823] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[96544.000834] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[96544.000845] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[96544.000856] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[96544.000867] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[96544.000878] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[96544.000981] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[96544.000982] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[96544.000983] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[96544.000985] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[96544.000986] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[96544.000987] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[96544.000988] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[96544.000988] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[96544.000989] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[96544.000990] iwlwifi 0000:04:00.0: 0x00000000 | data1
[96544.000991] iwlwifi 0000:04:00.0: 0x00000080 | data2
[96544.000992] iwlwifi 0000:04:00.0: 0x07030000 | data3
[96544.000993] iwlwifi 0000:04:00.0: 0x1E8006FC | beacon time
[96544.000994] iwlwifi 0000:04:00.0: 0x731388D8 | tsf low
[96544.000995] iwlwifi 0000:04:00.0: 0x000002B9 | tsf hi
[96544.000996] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[96544.000996] iwlwifi 0000:04:00.0: 0x2B3BF4CF | time gp2
[96544.000997] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[96544.000998] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[96544.000999] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[96544.001000] iwlwifi 0000:04:00.0: 0x00489200 | board version
[96544.001001] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[96544.001002] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[96544.001003] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[96544.001004] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[96544.001005] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[96544.001005] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[96544.001006] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[96544.001007] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[96544.001008] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[96544.001009] iwlwifi 0000:04:00.0: 0x00010130 | l2p_duration
[96544.001010] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[96544.001011] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[96544.001012] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[96544.001013] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[96544.001014] iwlwifi 0000:04:00.0: 0x0034F0F8 | flow_handler
[96544.001016] ieee80211 phy0: Hardware restart was requested
[96544.169903] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96544.170681] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96544.232649] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96544.233416] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96663.560414] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[96663.560428] iwlwifi 0000:04:00.0: Current SW read_ptr 195 write_ptr 247
[96663.560602] iwl data: 00000000: f8 ff 07 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[96663.560666] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x80003001
[96663.560730] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc01100d2
[96663.560794] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[96663.560854] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300008
[96663.560916] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[96663.560977] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[96663.561037] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[96663.561097] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x0070909b
[96663.561200] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [9,9]
[96663.561301] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[96663.561403] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [184,184]
[96663.561504] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [2,2]
[96663.561606] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.561707] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.561808] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.561910] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.562012] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[96663.562113] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [156,156]
[96663.562215] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.562317] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.562419] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.562520] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.562621] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.562723] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[96663.562824] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [195,247]
[96663.562926] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.563028] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.563129] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[96663.563309] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[96663.563312] iwlwifi 0000:04:00.0: CSR values:
[96663.563314] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[96663.563425] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[96663.563577] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[96663.563633] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[96663.563687] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[96663.563742] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[96663.563797] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[96663.563853] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[96663.563908] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[96663.563963] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[96663.564018] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[96663.564073] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[96663.564128] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[96663.564184] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[96663.564239] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[96663.564294] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[96663.564349] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[96663.564410] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[96663.564562] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[96663.564616] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[96663.564671] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[96663.564727] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[96663.564782] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7ff77
[96663.564837] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[96663.564892] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[96663.564894] iwlwifi 0000:04:00.0: FH register values:
[96663.564957] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[96663.565017] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[96663.565029] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000020
[96663.565042] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[96663.565054] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[96663.565067] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[96663.565080] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[96663.565092] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[96663.565105] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[96663.565263] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[96663.565265] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[96663.565267] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[96663.565270] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[96663.565272] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[96663.565274] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[96663.565276] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[96663.565278] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[96663.565280] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[96663.565282] iwlwifi 0000:04:00.0: 0x00000000 | data1
[96663.565284] iwlwifi 0000:04:00.0: 0x00000080 | data2
[96663.565286] iwlwifi 0000:04:00.0: 0x07030000 | data3
[96663.565288] iwlwifi 0000:04:00.0: 0x2D403978 | beacon time
[96663.565290] iwlwifi 0000:04:00.0: 0x7A32C732 | tsf low
[96663.565292] iwlwifi 0000:04:00.0: 0x000002B9 | tsf hi
[96663.565294] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[96663.565296] iwlwifi 0000:04:00.0: 0x071B9726 | time gp2
[96663.565298] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[96663.565300] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[96663.565302] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[96663.565304] iwlwifi 0000:04:00.0: 0x00489200 | board version
[96663.565306] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[96663.565308] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[96663.565310] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[96663.565312] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[96663.565314] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[96663.565316] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[96663.565318] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[96663.565320] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[96663.565322] iwlwifi 0000:04:00.0: 0x00000208 | l2p_control
[96663.565324] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[96663.565326] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[96663.565328] iwlwifi 0000:04:00.0: 0x000000A0 | l2p_addr_match
[96663.565330] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[96663.565332] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[96663.565334] iwlwifi 0000:04:00.0: 0x00342030 | flow_handler
[96663.565338] ieee80211 phy0: Hardware restart was requested
[96663.735654] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96663.736104] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96663.797642] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96663.798092] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[96693.680050] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[96876.031264] nf_conntrack: falling back to vmalloc.
[96876.031416] nf_conntrack: falling back to vmalloc.
[96876.052339] nf_conntrack: falling back to vmalloc.
[96876.052469] nf_conntrack: falling back to vmalloc.
[98941.396913] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[98945.084264] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[99303.322760] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[99303.322768] iwlwifi 0000:04:00.0: Current SW read_ptr 7 write_ptr 74
[99303.322937] iwl data: 00000000: 80 ff 7f 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[99303.322949] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x80003001
[99303.322960] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc0110016
[99303.322972] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[99303.322983] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300065
[99303.322995] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[99303.323006] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[99303.323017] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[99303.323029] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x00709056
[99303.323077] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [102,102]
[99303.323125] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[99303.323173] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [83,83]
[99303.323222] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [2,2]
[99303.323270] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323318] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323366] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323414] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323461] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[99303.323509] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [87,87]
[99303.323557] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323605] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323653] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323701] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323748] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323796] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[99303.323844] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [7,74]
[99303.323892] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323939] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.323987] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[99303.324075] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[99303.324077] iwlwifi 0000:04:00.0: CSR values:
[99303.324078] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[99303.324123] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[99303.324174] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[99303.324178] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[99303.324181] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[99303.324184] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[99303.324187] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[99303.324190] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[99303.324194] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[99303.324197] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[99303.324200] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[99303.324203] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[99303.324206] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[99303.324210] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[99303.324213] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[99303.324216] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[99303.324219] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[99303.324222] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[99303.324225] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[99303.324229] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[99303.324232] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[99303.324235] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[99303.324238] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f7d7
[99303.324241] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[99303.324244] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[99303.324245] iwlwifi 0000:04:00.0: FH register values:
[99303.324307] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[99303.324318] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[99303.324329] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000070
[99303.324340] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[99303.324351] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[99303.324362] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[99303.324373] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[99303.324384] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[99303.324395] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[99303.324498] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[99303.324499] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[99303.324500] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[99303.324502] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[99303.324503] iwlwifi 0000:04:00.0: 0x000002F0 | uPc
[99303.324504] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[99303.324504] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[99303.324505] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[99303.324506] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[99303.324507] iwlwifi 0000:04:00.0: 0x00000000 | data1
[99303.324508] iwlwifi 0000:04:00.0: 0x00000080 | data2
[99303.324509] iwlwifi 0000:04:00.0: 0x07030000 | data3
[99303.324510] iwlwifi 0000:04:00.0: 0xE100869C | beacon time
[99303.324511] iwlwifi 0000:04:00.0: 0x17712954 | tsf low
[99303.324512] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[99303.324513] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[99303.324513] iwlwifi 0000:04:00.0: 0x9D3AE1E8 | time gp2
[99303.324514] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[99303.324515] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[99303.324516] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[99303.324517] iwlwifi 0000:04:00.0: 0x00489200 | board version
[99303.324518] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[99303.324519] iwlwifi 0000:04:00.0: 0x00022002 | isr0
[99303.324520] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[99303.324521] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[99303.324521] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[99303.324522] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[99303.324523] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[99303.324524] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[99303.324525] iwlwifi 0000:04:00.0: 0x00000000 | l2p_control
[99303.324526] iwlwifi 0000:04:00.0: 0x00000020 | l2p_duration
[99303.324527] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[99303.324528] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[99303.324529] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[99303.324530] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[99303.324531] iwlwifi 0000:04:00.0: 0x00347080 | flow_handler
[99303.324533] ieee80211 phy0: Hardware restart was requested
[99303.494282] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[99303.494736] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[99303.556207] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[99303.556658] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100027.706024] nf_conntrack: falling back to vmalloc.
[100027.725333] nf_conntrack: falling back to vmalloc.
[100027.725551] nf_conntrack: falling back to vmalloc.
[100386.739382] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[100386.739389] iwlwifi 0000:04:00.0: Current SW read_ptr 26 write_ptr 109
[100386.739713] iwl data: 00000000: 00 00 00 fc 00 00 00 00 ff 03 00 00 00 00 00 00  ................
[100386.739725] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[100386.739737] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc0110029
[100386.739748] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[100386.739759] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300017
[100386.739771] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[100386.739782] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[100386.739793] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[100386.739805] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x007090eb
[100386.739853] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [24,24]
[100386.739901] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[100386.739949] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [49,49]
[100386.739997] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740045] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740093] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740141] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740189] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740237] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[100386.740285] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [236,236]
[100386.740333] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740381] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740429] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740477] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740525] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740573] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[100386.740621] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [26,109]
[100386.740669] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740717] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740765] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100386.740871] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[100386.740875] iwlwifi 0000:04:00.0: CSR values:
[100386.740877] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[100386.741015] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[100386.741066] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[100386.741116] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[100386.741167] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[100386.741217] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[100386.741220] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[100386.741223] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[100386.741227] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[100386.741230] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[100386.741233] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[100386.741236] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[100386.741240] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[100386.741243] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[100386.741246] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[100386.741249] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[100386.741252] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[100386.741256] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[100386.741259] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[100386.741262] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[100386.741265] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[100386.741268] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[100386.741271] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f777
[100386.741275] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[100386.741278] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[100386.741279] iwlwifi 0000:04:00.0: FH register values:
[100386.741341] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[100386.741352] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[100386.741368] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000008
[100386.741430] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[100386.741441] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[100386.741452] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[100386.741463] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[100386.741474] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[100386.741485] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[100386.741587] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[100386.741588] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[100386.741589] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[100386.741591] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[100386.741591] iwlwifi 0000:04:00.0: 0x000002F0 | uPc
[100386.741592] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[100386.741593] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[100386.741594] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[100386.741595] iwlwifi 0000:04:00.0: 0x0001F490 | interruptlink2
[100386.741596] iwlwifi 0000:04:00.0: 0x00000000 | data1
[100386.741597] iwlwifi 0000:04:00.0: 0x00000080 | data2
[100386.741598] iwlwifi 0000:04:00.0: 0x07030000 | data3
[100386.741599] iwlwifi 0000:04:00.0: 0xDA811A39 | beacon time
[100386.741600] iwlwifi 0000:04:00.0: 0x57FA759C | tsf low
[100386.741601] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[100386.741602] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[100386.741602] iwlwifi 0000:04:00.0: 0x4085B6F2 | time gp2
[100386.741603] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[100386.741604] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[100386.741605] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[100386.741606] iwlwifi 0000:04:00.0: 0x00489200 | board version
[100386.741607] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[100386.741608] iwlwifi 0000:04:00.0: 0x00022002 | isr0
[100386.741609] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[100386.741610] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[100386.741611] iwlwifi 0000:04:00.0: 0x404140C0 | isr3
[100386.741611] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[100386.741612] iwlwifi 0000:04:00.0: 0x00800110 | isr_pref
[100386.741613] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[100386.741614] iwlwifi 0000:04:00.0: 0x00000D3E | l2p_control
[100386.741615] iwlwifi 0000:04:00.0: 0x00000020 | l2p_duration
[100386.741616] iwlwifi 0000:04:00.0: 0x00000003 | l2p_mhvalid
[100386.741617] iwlwifi 0000:04:00.0: 0x00000090 | l2p_addr_match
[100386.741618] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[100386.741619] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[100386.741620] iwlwifi 0000:04:00.0: 0x00340818 | flow_handler
[100386.741622] ieee80211 phy0: Hardware restart was requested
[100386.916056] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100386.916521] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100386.977844] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100386.978298] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100507.389505] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[100507.389516] iwlwifi 0000:04:00.0: Current SW read_ptr 56 write_ptr 97
[100507.389685] iwl data: 00000000: ff 00 00 00 00 00 00 00 00 00 00 ff 00 00 00 00  ................
[100507.389745] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[100507.389756] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc0110047
[100507.389767] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[100507.389779] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x8030000a
[100507.389790] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[100507.389801] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[100507.389813] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[100507.389824] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x007090a4
[100507.389873] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [11,11]
[100507.389921] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[100507.389969] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [161,161]
[100507.390017] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390066] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390114] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390162] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390210] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390258] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[100507.390306] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [165,165]
[100507.390354] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390403] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390451] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390499] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390547] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390595] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[100507.390643] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [56,97]
[100507.390691] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390740] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390788] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100507.390898] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[100507.390901] iwlwifi 0000:04:00.0: CSR values:
[100507.390903] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[100507.391039] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[100507.391094] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[100507.391149] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[100507.391201] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[100507.391252] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[100507.391303] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[100507.391354] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[100507.391405] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[100507.391465] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[100507.391613] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[100507.391665] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[100507.391716] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[100507.391767] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[100507.391818] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[100507.391870] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[100507.391921] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[100507.391972] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[100507.392023] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[100507.392074] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[100507.392077] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[100507.392080] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[100507.392083] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7fff7
[100507.392086] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[100507.392089] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[100507.392090] iwlwifi 0000:04:00.0: FH register values:
[100507.392152] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[100507.392163] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[100507.392174] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000090
[100507.392185] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[100507.392196] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[100507.392207] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[100507.392218] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[100507.392229] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[100507.392240] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[100507.392342] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[100507.392343] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[100507.392344] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[100507.392345] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[100507.392346] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[100507.392347] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[100507.392348] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[100507.392349] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[100507.392350] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[100507.392351] iwlwifi 0000:04:00.0: 0x00000000 | data1
[100507.392352] iwlwifi 0000:04:00.0: 0x00000080 | data2
[100507.392353] iwlwifi 0000:04:00.0: 0x07030000 | data3
[100507.392354] iwlwifi 0000:04:00.0: 0xEB405790 | beacon time
[100507.392355] iwlwifi 0000:04:00.0: 0x5F2A482E | tsf low
[100507.392356] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[100507.392356] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[100507.392357] iwlwifi 0000:04:00.0: 0x072C1781 | time gp2
[100507.392358] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[100507.392359] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[100507.392360] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[100507.392361] iwlwifi 0000:04:00.0: 0x00489200 | board version
[100507.392362] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[100507.392363] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[100507.392364] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[100507.392365] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[100507.392365] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[100507.392366] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[100507.392367] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[100507.392368] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[100507.392369] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[100507.392370] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[100507.392371] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[100507.392372] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[100507.392373] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[100507.392373] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[100507.392374] iwlwifi 0000:04:00.0: 0x003490A0 | flow_handler
[100507.392377] ieee80211 phy0: Hardware restart was requested
[100507.565271] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100507.565845] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100507.626918] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100507.627368] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100744.847213] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[100744.847220] iwlwifi 0000:04:00.0: Current SW read_ptr 172 write_ptr 220
[100744.847389] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 f0 ff 0f 00 00 00 00  ................
[100744.847401] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[100744.847412] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc01100bb
[100744.847424] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[100744.847435] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x8030000b
[100744.847447] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[100744.847459] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[100744.847470] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[100744.847482] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x007090d6
[100744.847530] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [12,12]
[100744.847578] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[100744.847627] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [218,218]
[100744.847675] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.847723] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.847771] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.847819] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.847867] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.847915] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[100744.847963] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [215,215]
[100744.848011] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848059] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848108] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848156] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848204] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848252] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[100744.848300] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [172,220]
[100744.848348] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848397] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848445] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[100744.848532] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[100744.848535] iwlwifi 0000:04:00.0: CSR values:
[100744.848536] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[100744.848580] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[100744.848631] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[100744.848634] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[100744.848637] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[100744.848641] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[100744.848644] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[100744.848647] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[100744.848650] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[100744.848653] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[100744.848657] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[100744.848660] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[100744.848663] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[100744.848666] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[100744.848670] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[100744.848721] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[100744.848775] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[100744.848830] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[100744.848881] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[100744.848884] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[100744.848887] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[100744.848890] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[100744.848893] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f777
[100744.848896] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[100744.848900] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[100744.848901] iwlwifi 0000:04:00.0: FH register values:
[100744.848963] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[100744.848974] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[100744.848985] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000078
[100744.848996] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[100744.849007] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[100744.849018] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[100744.849029] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[100744.849040] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[100744.849051] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[100744.849155] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[100744.849156] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[100744.849157] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[100744.849158] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[100744.849159] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[100744.849160] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[100744.849161] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[100744.849162] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[100744.849163] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[100744.849164] iwlwifi 0000:04:00.0: 0x00000000 | data1
[100744.849164] iwlwifi 0000:04:00.0: 0x00000080 | data2
[100744.849165] iwlwifi 0000:04:00.0: 0x07030000 | data3
[100744.849166] iwlwifi 0000:04:00.0: 0x55012A0B | beacon time
[100744.849167] iwlwifi 0000:04:00.0: 0x6D4F55D6 | tsf low
[100744.849168] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[100744.849169] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[100744.849170] iwlwifi 0000:04:00.0: 0x0E2158E7 | time gp2
[100744.849171] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[100744.849172] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[100744.849173] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[100744.849174] iwlwifi 0000:04:00.0: 0x00489200 | board version
[100744.849174] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[100744.849175] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[100744.849176] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[100744.849177] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[100744.849178] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[100744.849179] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[100744.849180] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[100744.849181] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[100744.849182] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[100744.849182] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[100744.849183] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[100744.849184] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[100744.849185] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[100744.849186] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[100744.849187] iwlwifi 0000:04:00.0: 0x00347888 | flow_handler
[100744.849192] ieee80211 phy0: Hardware restart was requested
[100745.005263] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100745.005768] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100745.066682] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[100745.067132] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101108.046185] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[101108.046205] iwlwifi 0000:04:00.0: Current SW read_ptr 92 write_ptr 60
[101108.046380] iwl data: 00000000: 00 00 00 f0 00 00 00 00 ff 0f 00 00 00 00 00 00  ................
[101108.046445] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[101108.046511] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc011006b
[101108.046576] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[101108.046949] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300024
[101108.047008] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[101108.047019] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[101108.047031] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[101108.047043] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x00709025
[101108.047405] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [37,37]
[101108.047655] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[101108.047703] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [248,248]
[101108.047751] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.047799] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.047846] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.047894] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.047942] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.047989] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[101108.048037] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [38,38]
[101108.048084] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048132] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048181] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048231] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048636] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048683] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[101108.048731] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [92,60]
[101108.048778] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048826] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048874] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101108.048963] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[101108.048966] iwlwifi 0000:04:00.0: CSR values:
[101108.048967] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[101108.049021] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[101108.049204] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[101108.049357] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[101108.049411] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[101108.049470] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[101108.049524] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[101108.049579] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[101108.049634] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[101108.049696] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[101108.049861] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[101108.050017] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[101108.050071] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[101108.050126] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[101108.050180] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[101108.050235] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[101108.050290] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[101108.050340] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[101108.050392] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[101108.050453] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[101108.050600] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[101108.050651] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[101108.050702] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f7f7
[101108.050757] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[101108.050808] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[101108.050810] iwlwifi 0000:04:00.0: FH register values:
[101108.050882] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[101108.051503] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[101108.051565] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000060
[101108.051577] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[101108.051589] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[101108.051600] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[101108.051612] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[101108.051623] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[101108.051635] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[101108.051788] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[101108.051789] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[101108.051791] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[101108.051793] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[101108.051794] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[101108.051795] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[101108.051797] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[101108.051798] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[101108.051799] iwlwifi 0000:04:00.0: 0x00008680 | interruptlink2
[101108.051800] iwlwifi 0000:04:00.0: 0x00000000 | data1
[101108.051802] iwlwifi 0000:04:00.0: 0x00000080 | data2
[101108.051803] iwlwifi 0000:04:00.0: 0x07030000 | data3
[101108.051804] iwlwifi 0000:04:00.0: 0x19802054 | beacon time
[101108.051806] iwlwifi 0000:04:00.0: 0x82F1DF73 | tsf low
[101108.051807] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[101108.051809] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[101108.051810] iwlwifi 0000:04:00.0: 0x159F1A0F | time gp2
[101108.051811] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[101108.051813] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[101108.051814] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[101108.051816] iwlwifi 0000:04:00.0: 0x00489200 | board version
[101108.051817] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[101108.051818] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[101108.051820] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[101108.051821] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[101108.051823] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[101108.051824] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[101108.051826] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[101108.051827] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[101108.051829] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[101108.051830] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[101108.051831] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[101108.051833] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[101108.051834] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[101108.051835] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[101108.051837] iwlwifi 0000:04:00.0: 0x00346070 | flow_handler
[101108.051840] ieee80211 phy0: Hardware restart was requested
[101108.217600] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101108.218075] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101108.279125] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101108.279632] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101226.679063] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[101226.679076] iwlwifi 0000:04:00.0: Current SW read_ptr 168 write_ptr 37
[101226.679247] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 ff ff 00 00 00 00 00  ................
[101226.679310] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[101226.679370] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc01100b7
[101226.679430] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[101226.679442] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300028
[101226.679455] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[101226.679467] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[101226.679480] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[101226.679492] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x007090c6
[101226.679542] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [41,41]
[101226.679639] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[101226.679736] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [195,195]
[101226.679835] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.679936] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680033] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680129] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680225] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680321] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[101226.680418] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [199,199]
[101226.680514] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680611] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680708] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680804] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680900] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.680997] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[101226.681094] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [168,37]
[101226.681191] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.681288] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.681384] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101226.681525] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[101226.681528] iwlwifi 0000:04:00.0: CSR values:
[101226.681530] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[101226.681571] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[101226.681626] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[101226.681681] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[101226.681736] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[101226.681791] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[101226.681846] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[101226.681901] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[101226.681957] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[101226.682032] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[101226.682183] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[101226.682235] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[101226.682290] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[101226.682341] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[101226.682392] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[101226.682443] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[101226.682504] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[101226.682660] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[101226.682809] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[101226.682864] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[101226.682919] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[101226.682973] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[101226.683027] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7ff77
[101226.683078] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[101226.683129] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[101226.683130] iwlwifi 0000:04:00.0: FH register values:
[101226.683191] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[101226.683203] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[101226.683215] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000d8
[101226.683227] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[101226.683238] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[101226.683250] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[101226.683261] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[101226.683273] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[101226.683285] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[101226.683439] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[101226.683441] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[101226.683442] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[101226.683455] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[101226.683458] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[101226.683459] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[101226.683461] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[101226.683462] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[101226.683464] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[101226.683466] iwlwifi 0000:04:00.0: 0x00000000 | data1
[101226.683467] iwlwifi 0000:04:00.0: 0x00000080 | data2
[101226.683469] iwlwifi 0000:04:00.0: 0x07030000 | data3
[101226.683471] iwlwifi 0000:04:00.0: 0x378071AA | beacon time
[101226.683473] iwlwifi 0000:04:00.0: 0x8A02EE50 | tsf low
[101226.683474] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[101226.683476] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[101226.683478] iwlwifi 0000:04:00.0: 0x070D6F26 | time gp2
[101226.683480] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[101226.683481] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[101226.683483] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[101226.683485] iwlwifi 0000:04:00.0: 0x00489200 | board version
[101226.683486] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[101226.683488] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[101226.683489] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[101226.683491] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[101226.683493] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[101226.683494] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[101226.683496] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[101226.683497] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[101226.683499] iwlwifi 0000:04:00.0: 0x00004208 | l2p_control
[101226.683501] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[101226.683502] iwlwifi 0000:04:00.0: 0x0000013F | l2p_mhvalid
[101226.683504] iwlwifi 0000:04:00.0: 0x00000020 | l2p_addr_match
[101226.683506] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[101226.683507] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[101226.683509] iwlwifi 0000:04:00.0: 0x0034D8E0 | flow_handler
[101226.683512] ieee80211 phy0: Hardware restart was requested
[101226.875917] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101226.876540] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101226.938247] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101226.938864] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101586.996280] iwlwifi 0000:04:00.0: Queue 16 stuck for 10000 ms.
[101586.996293] iwlwifi 0000:04:00.0: Current SW read_ptr 215 write_ptr 81
[101586.996464] iwl data: 00000000: 00 00 80 ff 00 00 00 00 7f 00 00 00 00 00 00 00  ................
[101586.996527] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[101586.996587] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc01100e6
[101586.996647] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[101586.996659] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x8030001b
[101586.996672] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[101586.996684] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[101586.996697] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[101586.996709] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x007090cf
[101586.996760] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [28,28]
[101586.996857] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[101586.996954] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [34,34]
[101586.997051] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997149] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997245] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997342] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997439] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997536] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[101586.997633] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [208,208]
[101586.997730] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997827] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.997925] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.998022] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.998119] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.998216] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[101586.998313] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [215,81]
[101586.998410] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 3 ra_tid 0x0006 [80,80]
[101586.998507] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.998605] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[101586.998808] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[101586.998810] iwlwifi 0000:04:00.0: CSR values:
[101586.998812] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[101586.998959] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[101586.999014] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[101586.999066] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[101586.999117] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[101586.999168] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[101586.999225] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[101586.999378] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[101586.999432] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[101586.999487] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[101586.999538] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[101586.999589] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[101586.999640] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[101586.999691] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[101586.999742] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[101586.999793] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[101586.999844] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[101586.999896] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[101586.999947] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[101586.999998] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[101587.000053] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[101587.000104] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[101587.000155] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f757
[101587.000211] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[101587.000365] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[101587.000366] iwlwifi 0000:04:00.0: FH register values:
[101587.000427] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[101587.000439] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[101587.000451] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000070
[101587.000463] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[101587.000474] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[101587.000486] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03230000
[101587.000498] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[101587.000510] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[101587.000521] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[101587.000673] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[101587.000675] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[101587.000676] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[101587.000678] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[101587.000680] iwlwifi 0000:04:00.0: 0x00000230 | uPc
[101587.000681] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[101587.000683] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[101587.000684] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[101587.000686] iwlwifi 0000:04:00.0: 0x0000874C | interruptlink2
[101587.000687] iwlwifi 0000:04:00.0: 0x00000000 | data1
[101587.000689] iwlwifi 0000:04:00.0: 0x00000080 | data2
[101587.000690] iwlwifi 0000:04:00.0: 0x07230000 | data3
[101587.000692] iwlwifi 0000:04:00.0: 0x75812FDB | beacon time
[101587.000693] iwlwifi 0000:04:00.0: 0x9F797FF9 | tsf low
[101587.000695] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[101587.000696] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[101587.000698] iwlwifi 0000:04:00.0: 0x15728B9E | time gp2
[101587.000699] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[101587.000701] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[101587.000702] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[101587.000704] iwlwifi 0000:04:00.0: 0x00489200 | board version
[101587.000705] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[101587.000707] iwlwifi 0000:04:00.0: 0x24022002 | isr0
[101587.000708] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[101587.000709] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[101587.000711] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[101587.000712] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[101587.000714] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[101587.000715] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[101587.000717] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[101587.000718] iwlwifi 0000:04:00.0: 0x00010030 | l2p_duration
[101587.000720] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[101587.000721] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[101587.000723] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[101587.000724] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[101587.000726] iwlwifi 0000:04:00.0: 0x00347078 | flow_handler
[101587.000729] ieee80211 phy0: Hardware restart was requested
[101587.158695] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101587.159152] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101587.220487] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[101587.220937] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[102582.881934] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[102784.595514] iwlwifi 0000:04:00.0: Queue 2 stuck for 10000 ms.
[102784.595517] iwlwifi 0000:04:00.0: Current SW read_ptr 78 write_ptr 80
[102784.595686] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[102784.595697] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[102784.595708] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc01100ad
[102784.595719] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[102784.595730] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300017
[102784.595741] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[102784.595752] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[102784.595763] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[102784.595774] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x0070909c
[102784.595822] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [24,24]
[102784.595870] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[102784.595917] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [78,80]
[102784.595965] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596012] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596060] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596108] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596155] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596203] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[102784.596251] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [157,157]
[102784.596298] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596346] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596393] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596441] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596493] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596591] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[102784.596638] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [158,96]
[102784.596686] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596733] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596780] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[102784.596896] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[102784.596898] iwlwifi 0000:04:00.0: CSR values:
[102784.596898] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[102784.596915] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[102784.596966] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[102784.597017] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[102784.597067] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[102784.597070] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[102784.597073] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[102784.597076] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[102784.597080] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[102784.597083] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[102784.597086] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[102784.597089] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[102784.597092] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[102784.597096] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[102784.597099] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[102784.597102] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[102784.597105] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[102784.597108] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[102784.597111] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[102784.597114] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[102784.597117] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[102784.597121] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[102784.597124] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7f7d7
[102784.597127] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[102784.597130] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[102784.597131] iwlwifi 0000:04:00.0: FH register values:
[102784.597190] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[102784.597201] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[102784.597212] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f0
[102784.597223] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[102784.597234] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[102784.597245] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[102784.597256] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[102784.597267] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[102784.597278] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[102784.597381] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[102784.597382] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[102784.597383] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[102784.597384] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[102784.597385] iwlwifi 0000:04:00.0: 0x000002B0 | uPc
[102784.597386] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[102784.597387] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[102784.597388] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[102784.597389] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[102784.597390] iwlwifi 0000:04:00.0: 0x00000000 | data1
[102784.597391] iwlwifi 0000:04:00.0: 0x00000080 | data2
[102784.597392] iwlwifi 0000:04:00.0: 0x07030000 | data3
[102784.597392] iwlwifi 0000:04:00.0: 0x3841357B | beacon time
[102784.597393] iwlwifi 0000:04:00.0: 0xE6CFFA6B | tsf low
[102784.597394] iwlwifi 0000:04:00.0: 0x000002BA | tsf hi
[102784.597395] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[102784.597396] iwlwifi 0000:04:00.0: 0x475311B0 | time gp2
[102784.597397] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[102784.597398] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[102784.597399] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[102784.597399] iwlwifi 0000:04:00.0: 0x00489200 | board version
[102784.597400] iwlwifi 0000:04:00.0: 0x0000001C | hcmd
[102784.597401] iwlwifi 0000:04:00.0: 0x00022002 | isr0
[102784.597402] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[102784.597403] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[102784.597404] iwlwifi 0000:04:00.0: 0x004140C0 | isr3
[102784.597405] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[102784.597405] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[102784.597406] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[102784.597407] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
[102784.597408] iwlwifi 0000:04:00.0: 0x00010020 | l2p_duration
[102784.597409] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
[102784.597410] iwlwifi 0000:04:00.0: 0x00000080 | l2p_addr_match
[102784.597411] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[102784.597412] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[102784.597412] iwlwifi 0000:04:00.0: 0x0034F000 | flow_handler
[102784.597415] ieee80211 phy0: Hardware restart was requested
[102784.754178] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[102784.754673] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[102784.816395] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[102784.816854] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[103488.016486] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[105124.409376] nf_conntrack: falling back to vmalloc.
[105892.392015] iwlwifi 0000:04:00.0: Queue 2 stuck for 10000 ms.
[105892.392025] iwlwifi 0000:04:00.0: Current SW read_ptr 46 write_ptr 83
[105892.392191] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 c0 01 00 00 00 00 00  ................
[105892.392255] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x00000000
[105892.392267] iwlwifi 0000:04:00.0: FH TRBs(1) = 0x80102030
[105892.392280] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[105892.392292] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300079
[105892.392305] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[105892.392317] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[105892.392329] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[105892.392341] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x0070908a
[105892.392391] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [122,122]
[105892.392487] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
[105892.392536] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [46,83]
[105892.392632] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.392681] iwlwifi 0000:04:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.392730] iwlwifi 0000:04:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.392779] iwlwifi 0000:04:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.392828] iwlwifi 0000:04:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.392877] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
[105892.392926] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [139,139]
[105892.392975] iwlwifi 0000:04:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393078] iwlwifi 0000:04:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393174] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393223] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393272] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393321] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[105892.393370] iwlwifi 0000:04:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [192,25]
[105892.393419] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 3 ra_tid 0x0006 [159,159]
[105892.393467] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393516] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[105892.393604] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[105892.393606] iwlwifi 0000:04:00.0: CSR values:
[105892.393607] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[105892.393652] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[105892.393703] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[105892.393754] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[105892.393806] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[105892.393857] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[105892.393908] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[105892.393959] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[105892.394015] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[105892.394070] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000210
[105892.394125] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[105892.394176] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000000
[105892.394233] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[105892.394288] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[105892.394343] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[105892.394393] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[105892.394444] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[105892.394495] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[105892.394546] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[105892.394598] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b967c
[105892.394649] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[105892.394700] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[105892.394751] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xebb7ff77
[105892.394802] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[105892.394853] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[105892.394855] iwlwifi 0000:04:00.0: FH register values:
[105892.394916] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21f43700
[105892.394927] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02227670
[105892.394939] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000088
[105892.394950] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[105892.394962] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[105892.394976] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[105892.395038] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[105892.395049] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[105892.395060] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[105892.395164] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[105892.395166] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[105892.395167] iwlwifi 0000:04:00.0: Loaded firmware version: 25.17.12.0
[105892.395169] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[105892.395170] iwlwifi 0000:04:00.0: 0x00000281 | uPc
[105892.395172] iwlwifi 0000:04:00.0: 0x00000000 | branchlink1
[105892.395173] iwlwifi 0000:04:00.0: 0x00042870 | branchlink2
[105892.395174] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink1
[105892.395176] iwlwifi 0000:04:00.0: 0x00043154 | interruptlink2
[105892.395177] iwlwifi 0000:04:00.0: 0x00000000 | data1
[105892.395178] iwlwifi 0000:04:00.0: 0x00000080 | data2
[105892.395179] iwlwifi 0000:04:00.0: 0x07030000 | data3
[105892.395181] iwlwifi 0000:04:00.0: 0x43803DA9 | beacon time
[105892.395182] iwlwifi 0000:04:00.0: 0x9FEF925B | tsf low
[105892.395183] iwlwifi 0000:04:00.0: 0x000002BB | tsf hi
[105892.395184] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[105892.395186] iwlwifi 0000:04:00.0: 0xB91C4B8A | time gp2
[105892.395187] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[105892.395188] iwlwifi 0000:04:00.0: 0x00041911 | uCode version
[105892.395190] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[105892.395191] iwlwifi 0000:04:00.0: 0x00489200 | board version
[105892.395192] iwlwifi 0000:04:00.0: 0x10C0001C | hcmd
[105892.395193] iwlwifi 0000:04:00.0: 0x20022002 | isr0
[105892.395195] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[105892.395196] iwlwifi 0000:04:00.0: 0x0000000A | isr2
[105892.395197] iwlwifi 0000:04:00.0: 0x004174C0 | isr3
[105892.395198] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[105892.395200] iwlwifi 0000:04:00.0: 0x00000110 | isr_pref
[105892.395201] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[105892.395202] iwlwifi 0000:04:00.0: 0x00004288 | l2p_control
[105892.395203] iwlwifi 0000:04:00.0: 0x00018024 | l2p_duration
[105892.395205] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[105892.395206] iwlwifi 0000:04:00.0: 0x000000EF | l2p_addr_match
[105892.395207] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[105892.395209] iwlwifi 0000:04:00.0: 0x13041313 | timestamp
[105892.395210] iwlwifi 0000:04:00.0: 0x00348890 | flow_handler
[105892.395213] ieee80211 phy0: Hardware restart was requested
[105892.555367] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[105892.555822] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[105892.617480] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[105892.617931] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[105992.713490] wlan0: deauthenticating from 38:2c:4a:cb:b5:48 by local choice (Reason: 3=DEAUTH_LEAVING)
[105995.827976] wlan0: authenticate with 38:2c:4a:cb:b5:4c
[105995.835248] wlan0: send auth to 38:2c:4a:cb:b5:4c (try 1/3)
[105995.836263] wlan0: authenticated
[105995.836545] wlan0: associate with 38:2c:4a:cb:b5:4c (try 1/3)
[105995.837361] wlan0: RX AssocResp from 38:2c:4a:cb:b5:4c (capab=0x1011 status=0 aid=3)
[105995.838486] wlan0: associated

--------------070808090909020104080300
Content-Type: text/x-log;
 name="ap.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ap.log"

BSS 38:2c:4a:cb:b5:48(on wlan0)
	TSF: 3005710636997 usec (34d, 18:55:10)
	freq: 2462
	beacon interval: 100 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime RadioMeasure (0x1431)
	signal: -55.00 dBm
	last seen: 0 ms ago
	Information elements from Probe Response frame:
	SSID: The Viking Closet
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 11
	ERP: <no flags>
	ERP D4.0: <no flags>
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 0
		 * channel utilisation: 24/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x19ad
			RX LDPC
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT RX MCS rate indexes supported: 0-23
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 11
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 1
		 * HT protection: nonmember
		 * non-GF present: 0
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Overlapping BSS scan params:
		 * passive dwell: 20 TUs
		 * active dwell: 10 TUs
		 * channel width trigger scan interval: 300 s
		 * scan passive total per channel: 200 TUs
		 * scan active total per channel: 20 TUs
		 * BSS width channel transition delay factor: 5
		 * OBSS Scan Activity Threshold: 0.25 %
	Extended capabilities: HT Information Exchange Supported, Extended Channel Switching, BSS Transition, 6
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

--------------070808090909020104080300--
