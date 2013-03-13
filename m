Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41191 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246Ab3CMWf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 18:35:57 -0400
Received: by mail-ea0-f173.google.com with SMTP id h14so674846eak.18
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 15:35:55 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: linux-wireless@vger.kernel.org
Reply-To: isedev@gmail.com
Subject: BCM4312 / b43 DMA transmission sequence errors
Date: Wed, 13 Mar 2013 23:35:52 +0100
Message-ID: <2021951.aYaXb566kj@wks001.ise.net> (sfid-20130313_233601_669970_6395ED49)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The wireless connection keeps failing shortly after being established. Up to now, I've tracked it down to a DMA transmission sequence error in ring 3. Beyond that, I cannot say...

Happy to provide further information and to test any potential fixes.

System:

Dell Studio 17 running Fedora 18  
Linux wks001.ise.net 3.8.2-206.fc18.x86_64 #1 SMP Fri Mar 8 15:03:34 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Broadcom BCM 4312 wireless card:

08:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g LP-PHY [14e4:4315] (rev 01)

08:00.0 0280: 14e4:4315 (rev 01)
        Subsystem: 1028:000c
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Firmware was obtained as per b43 wiki page, namely http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2.

In both examples below, I've added a single b43dbg statement to 'b43_dma_handle_txstatus()' which prints out the DMA ring and slot number after the out-of-order sanity check. 

I've tried using the driver from Fedora 18 kernel-3.8.2-206.fc18.x86_64 (which is practically the same as the current driver on torvalds/linux.git) and from the latest commit on linville/wireless-testing.git. In both cases, I end up with an 'out of order TX status on DMA ring 3' on slot 138 which leads to an AP disconnect after a while due to inactivity timeout.

In the first case, I get a 'TX-status contains invalid cookie: 0x0000' when slot 138 is the first slot in ring 3. In the second case, it's 'Out of order TX status report on DMA ring 3. Expected 138, but got 126'. After the error, status is given for what would have been the correct slot (i.e. 140, 142, etc...) but obviously slot 138 was not processed so all subsequent status reports get dropped.

The error, at least on my laptop, is easy to reproduce - it happens within a couple of minutes (or less) every time I start using the b43 driver. 

The same laptop running Fedora 16 (3.6.11) with the broadcom-wl driver or running Windows 7 works perfectly (at least, no noticeable disconnects). The b43 driver on Fedora 16 (3.6.11) and Fedora 17 (3.7.9) also disconnected but I don't have any debug info to provide for those cases. The broadcom-wl driver on Fedora 18 also works fine until it causes a panic - but before then, no disconnects 

I've tried against two different AP with same results.


Using the driver from Fedora 18 kernel-3.8.2-206.fc18.x86_64, the sequence leading up to the failure is:

[ 7813.857650] cfg80211: World regulatory domain updated:
[ 7813.857658] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 7813.857665] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7813.857672] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7813.857678] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 7813.857685] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7813.857691] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7813.857978] cfg80211: Calling CRDA for country: IT
[ 7813.872325] cfg80211: Regulatory domain changed to country: IT
[ 7813.872334] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 7813.872341] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 7813.872347] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 7813.872353] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 7813.872359] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[ 7813.872365] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[10226.231819] ssb: Found chip with id 0x4312, rev 0x01 and package 0x00
[10226.231959] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
[10226.232093] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
[10226.232230] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
[10226.232364] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
[10226.273825] ssb: Sonics Silicon Backplane found on PCI device 0000:08:00.0
[10226.302682] cfg80211: Calling CRDA to update world regulatory domain
[10226.309553] cfg80211: World regulatory domain updated:
[10226.309560] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[10226.309565] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[10226.309569] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[10226.309573] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[10226.309576] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[10226.309580] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[10226.351857] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[10226.366408] b43-phy0: Found PHY: Analog 6, Type 5 (LP), Revision 1
[10226.366458] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
[10226.373908] Broadcom 43xx driver loaded [ Features: PMNLS ]
[10226.376913] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[10226.386903] CE: hpet increased min_delta_ns to 30169 nsec
[10226.407881] cfg80211: Calling CRDA for country: IT
[10226.410574] cfg80211: Regulatory domain changed to country: IT
[10226.410577] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[10226.410580] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[10226.410582] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[10226.410584] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[10226.410586] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[10226.410588] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[10226.571407] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[10226.575295] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[10227.963115] b43-phy0 debug: Chip initialized
[10227.963578] b43-phy0 debug: 64-bit DMA initialized
[10227.963689] b43-phy0 debug: QoS enabled
[10227.975034] b43-phy0 debug: Wireless interface started
[10227.979312] b43-phy0 debug: Adding Interface type 2
[10227.980304] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[10228.052855] b43-phy0 debug: DMA ring 3 slot 0.
[10228.121660] b43-phy0 ERROR: PHY transmission error
[10228.121739] b43-phy0 debug: DMA ring 3 slot 2.
[10228.190536] b43-phy0 debug: DMA ring 3 slot 4.
[10228.259123] b43-phy0 debug: DMA ring 3 slot 6.
[10228.328973] b43-phy0 debug: DMA ring 3 slot 8.
[10228.398307] b43-phy0 debug: DMA ring 3 slot 10.
[10228.467265] b43-phy0 debug: DMA ring 3 slot 12.
[10228.535794] b43-phy0 debug: DMA ring 3 slot 14.
[10228.604772] b43-phy0 debug: DMA ring 3 slot 16.
[10228.677115] b43-phy0 debug: DMA ring 3 slot 18.
[10228.744996] b43-phy0 debug: DMA ring 3 slot 20.
[10228.818880] b43-phy0 debug: DMA ring 3 slot 22.
[10228.887719] b43-phy0 debug: DMA ring 3 slot 24.
[10251.086064] b43-phy0 debug: DMA ring 3 slot 26.
[10251.155056] b43-phy0 debug: DMA ring 3 slot 28.
[10251.224319] b43-phy0 debug: DMA ring 3 slot 30.
[10251.293053] b43-phy0 debug: DMA ring 3 slot 32.
[10251.362314] b43-phy0 debug: DMA ring 3 slot 34.
[10251.431257] b43-phy0 debug: DMA ring 3 slot 36.
[10251.501387] b43-phy0 debug: DMA ring 3 slot 38.
[10251.568804] b43-phy0 debug: DMA ring 3 slot 40.
[10251.637499] b43-phy0 debug: DMA ring 3 slot 42.
[10251.706885] b43-phy0 debug: DMA ring 3 slot 44.
[10251.777551] b43-phy0 debug: DMA ring 3 slot 46.
[10251.846896] b43-phy0 debug: DMA ring 3 slot 48.
[10251.916025] b43-phy0 debug: DMA ring 3 slot 50.
[10252.007155] b43-phy0 debug: DMA ring 3 slot 52.
[10252.007842] b43-phy0 debug: DMA ring 3 slot 54.
[10252.076407] b43-phy0 debug: DMA ring 3 slot 56.
[10252.077438] b43-phy0 debug: DMA ring 3 slot 58.
[10252.145070] b43-phy0 debug: DMA ring 3 slot 60.
[10252.146155] b43-phy0 debug: DMA ring 3 slot 62.
[10252.214077] b43-phy0 ERROR: PHY transmission error
[10252.214115] b43-phy0 debug: DMA ring 3 slot 64.
[10252.214180] b43-phy0 debug: DMA ring 3 slot 66.
[10252.283054] b43-phy0 debug: DMA ring 3 slot 68.
[10252.284047] b43-phy0 debug: DMA ring 3 slot 70.
[10252.351809] b43-phy0 debug: DMA ring 3 slot 72.
[10252.352947] b43-phy0 debug: DMA ring 3 slot 74.
[10252.420822] b43-phy0 debug: DMA ring 3 slot 76.
[10252.421505] b43-phy0 debug: DMA ring 3 slot 78.
[10252.489874] b43-phy0 debug: DMA ring 3 slot 80.
[10252.490817] b43-phy0 debug: DMA ring 3 slot 82.
[10252.559210] b43-phy0 debug: DMA ring 3 slot 84.
[10252.559916] b43-phy0 debug: DMA ring 3 slot 86.
[10252.627740] b43-phy0 debug: DMA ring 3 slot 88.
[10252.628684] b43-phy0 debug: DMA ring 3 slot 90.
[10252.698563] b43-phy0 debug: DMA ring 3 slot 92.
[10252.699431] b43-phy0 debug: DMA ring 3 slot 94.
[10252.767375] b43-phy0 debug: DMA ring 3 slot 96.
[10252.768623] b43-phy0 debug: DMA ring 3 slot 98.
[10252.836728] b43-phy0 ERROR: PHY transmission error
[10252.836783] b43-phy0 debug: DMA ring 3 slot 100.
[10252.837246] b43-phy0 debug: DMA ring 3 slot 102.
[10252.867641] wlan0: authenticate with e0:91:53:56:f0:ad
[10252.875267] wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[10252.884491] wlan0: send auth to e0:91:53:56:f0:ad (try 1/3)
[10252.885652] b43-phy0 debug: DMA ring 3 slot 104.
[10252.886988] wlan0: authenticated
[10252.887954] wlan0: associate with e0:91:53:56:f0:ad (try 1/3)
[10252.890166] b43-phy0 debug: DMA ring 3 slot 106.
[10252.891817] wlan0: RX AssocResp from e0:91:53:56:f0:ad (capab=0x431 status=0 aid=1)
[10252.892904] wlan0: associated
[10252.892950] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[10252.893027] cfg80211: Calling CRDA for country: IT
[10252.898442] cfg80211: Regulatory domain changed to country: IT
[10252.898449] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[10252.898456] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[10252.898462] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[10252.898468] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[10252.898473] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[10252.898479] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[10252.901143] b43-phy0 debug: DMA ring 1 slot 0.
[10252.909940] b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: e0:91:53:56:f0:ad
[10252.910308] b43-phy0 debug: Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[10252.911624] b43-phy0 debug: DMA ring 1 slot 2.
[10253.204622] b43-phy0 debug: DMA ring 1 slot 4.
[10254.204703] b43-phy0 debug: DMA ring 1 slot 6.
[10256.758088] b43-phy0 debug: DMA ring 3 slot 108.
[10258.212861] b43-phy0 debug: DMA ring 1 slot 8.
[10259.747293] b43-phy0 debug: DMA ring 3 slot 110.
[10261.330670] b43-phy0 debug: DMA ring 1 slot 10.
[10262.217511] b43-phy0 debug: DMA ring 1 slot 12.
[10262.744251] b43-phy0 debug: DMA ring 3 slot 112.
[10265.742042] b43-phy0 debug: DMA ring 3 slot 114.
[10268.738872] b43-phy0 debug: DMA ring 3 slot 116.
[10271.736376] b43-phy0 debug: DMA ring 3 slot 118.
[10274.733344] b43-phy0 debug: DMA ring 3 slot 120.
[10277.730636] b43-phy0 debug: DMA ring 3 slot 122.
[10280.728237] b43-phy0 debug: DMA ring 3 slot 124.
[10283.725525] b43-phy0 debug: DMA ring 3 slot 126.
[10284.031830] b43-phy0 debug: DMA ring 3 slot 128.
[10284.061704] b43-phy0 debug: DMA ring 3 slot 130.
[10284.130623] b43-phy0 debug: DMA ring 3 slot 132.
[10284.199890] b43-phy0 debug: DMA ring 3 slot 134.
[10284.269002] b43-phy0 debug: DMA ring 3 slot 136.
[10284.337647] b43-phy0 debug: TX-status contains invalid cookie: 0x0000
[10284.406370] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 140
[10284.475308] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 142
[10284.544219] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 144
[10284.613465] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 146
[10284.682521] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 148

Using the b43 driver compiled from commit d41d9c7419e3ac9c81841f43bbd7639dd0a5819e (Wed Mar 13 14:46:11 2013 -0400) from git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git:

[11716.327942] ssb: Found chip with id 0x4312, rev 0x01 and package 0x00
[11716.328082] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
[11716.328216] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
[11716.328353] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
[11716.328487] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
[11716.365095] ssb: Sonics Silicon Backplane found on PCI device 0000:08:00.0
[11716.384429] cfg80211: Calling CRDA to update world regulatory domain
[11716.391467] cfg80211: World regulatory domain updated:
[11716.391473] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[11716.391478] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[11716.391482] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[11716.391486] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[11716.391490] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[11716.391528] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[11716.422638] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[11716.437604] b43-phy0: Found PHY: Analog 6, Type 5 (LP), Revision 1
[11716.437651] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
[11716.445008] Broadcom 43xx driver loaded [ Features: PMNLS ]
[11716.447753] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[11716.471947] cfg80211: Calling CRDA for country: IT
[11716.478615] cfg80211: Regulatory domain changed to country: IT
[11716.478622] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[11716.478629] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[11716.478635] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[11716.478641] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[11716.478647] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[11716.478653] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[11716.633541] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[11716.637589] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[11718.028304] b43-phy0 debug: Chip initialized
[11718.028694] b43-phy0 debug: 64-bit DMA initialized
[11718.028808] b43-phy0 debug: QoS enabled
[11718.038689] b43-phy0 debug: Wireless interface started
[11718.043523] b43-phy0 debug: Adding Interface type 2
[11718.044504] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[11718.114760] b43-phy0 debug: DMA ring 3 slot 0.
[11718.183468] b43-phy0 ERROR: PHY transmission error
[11718.183502] b43-phy0 debug: DMA ring 3 slot 2.
[11718.252602] b43-phy0 debug: DMA ring 3 slot 4.
[11718.321559] b43-phy0 debug: DMA ring 3 slot 6.
[11718.390009] b43-phy0 debug: DMA ring 3 slot 8.
[11718.459025] b43-phy0 debug: DMA ring 3 slot 10.
[11718.528598] b43-phy0 debug: DMA ring 3 slot 12.
[11718.596907] b43-phy0 debug: DMA ring 3 slot 14.
[11718.665827] b43-phy0 debug: DMA ring 3 slot 16.
[11718.736213] b43-phy0 debug: DMA ring 3 slot 18.
[11718.805424] b43-phy0 debug: DMA ring 3 slot 20.
[11718.873616] b43-phy0 debug: DMA ring 3 slot 22.
[11718.943168] b43-phy0 debug: DMA ring 3 slot 24.
[11741.713698] b43-phy0 debug: DMA ring 3 slot 26.
[11741.782711] b43-phy0 debug: DMA ring 3 slot 28.
[11741.852316] b43-phy0 debug: DMA ring 3 slot 30.
[11741.920798] b43-phy0 debug: DMA ring 3 slot 32.
[11741.989955] b43-phy0 debug: DMA ring 3 slot 34.
[11742.058667] b43-phy0 debug: DMA ring 3 slot 36.
[11742.127301] b43-phy0 debug: DMA ring 3 slot 38.
[11742.196276] b43-phy0 debug: DMA ring 3 slot 40.
[11742.265185] b43-phy0 debug: DMA ring 3 slot 42.
[11742.334446] b43-phy0 debug: DMA ring 3 slot 44.
[11742.403438] b43-phy0 debug: DMA ring 3 slot 46.
[11742.472509] b43-phy0 debug: DMA ring 3 slot 48.
[11742.541014] b43-phy0 debug: DMA ring 3 slot 50.
[11742.639980] b43-phy0 debug: DMA ring 3 slot 52.
[11742.640725] b43-phy0 debug: DMA ring 3 slot 54.
[11742.708748] b43-phy0 debug: DMA ring 3 slot 56.
[11742.709563] b43-phy0 debug: DMA ring 3 slot 58.
[11742.777698] b43-phy0 debug: DMA ring 3 slot 60.
[11742.778736] b43-phy0 debug: DMA ring 3 slot 62.
[11742.846647] b43-phy0 debug: DMA ring 3 slot 64.
[11742.847371] b43-phy0 debug: DMA ring 3 slot 66.
[11742.916310] b43-phy0 debug: DMA ring 3 slot 68.
[11742.916910] b43-phy0 debug: DMA ring 3 slot 70.
[11742.984535] b43-phy0 debug: DMA ring 3 slot 72.
[11742.985450] b43-phy0 debug: DMA ring 3 slot 74.
[11743.055580] b43-phy0 debug: DMA ring 3 slot 76.
[11743.056451] b43-phy0 debug: DMA ring 3 slot 78.
[11743.124278] b43-phy0 debug: DMA ring 3 slot 80.
[11743.125413] b43-phy0 debug: DMA ring 3 slot 82.
[11743.194425] b43-phy0 debug: DMA ring 3 slot 84.
[11743.195400] b43-phy0 debug: DMA ring 3 slot 86.
[11743.263413] b43-phy0 debug: DMA ring 3 slot 88.
[11743.264128] b43-phy0 debug: DMA ring 3 slot 90.
[11743.332371] b43-phy0 debug: DMA ring 3 slot 92.
[11743.333341] b43-phy0 debug: DMA ring 3 slot 94.
[11743.401073] b43-phy0 debug: DMA ring 3 slot 96.
[11743.402389] b43-phy0 debug: DMA ring 3 slot 98.
[11743.470221] b43-phy0 debug: DMA ring 3 slot 100.
[11743.471055] b43-phy0 debug: DMA ring 3 slot 102.
[11743.501443] wlan0: authenticate with e0:91:53:56:f0:ad
[11743.509894] wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[11743.519126] wlan0: send auth to e0:91:53:56:f0:ad (try 1/3)
[11743.520581] b43-phy0 debug: DMA ring 3 slot 104.
[11743.521910] wlan0: authenticated
[11743.522623] wlan0: associate with e0:91:53:56:f0:ad (try 1/3)
[11743.524228] b43-phy0 debug: DMA ring 3 slot 106.
[11743.525891] wlan0: RX AssocResp from e0:91:53:56:f0:ad (capab=0x431 status=0 aid=1)
[11743.526656] wlan0: associated
[11743.526709] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[11743.526820] cfg80211: Calling CRDA for country: IT
[11743.531765] cfg80211: Regulatory domain changed to country: IT
[11743.531771] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[11743.531776] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[11743.531780] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[11743.531783] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[11743.531787] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[11743.531790] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[11743.534289] b43-phy0 debug: DMA ring 1 slot 0.
[11743.543874] b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: e0:91:53:56:f0:ad
[11743.544297] b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[11743.545278] b43-phy0 debug: DMA ring 1 slot 2.
[11744.476694] b43-phy0 debug: DMA ring 1 slot 4.
[11745.478607] b43-phy0 debug: DMA ring 1 slot 6.
[11747.385740] b43-phy0 debug: DMA ring 3 slot 108.
[11749.480238] b43-phy0 debug: DMA ring 1 slot 8.
[11750.375256] b43-phy0 debug: DMA ring 3 slot 110.
[11751.030677] b43-phy0 debug: DMA ring 1 slot 10.
[11753.372513] b43-phy0 debug: DMA ring 3 slot 112.
[11753.484286] b43-phy0 debug: DMA ring 1 slot 12.
[11756.369324] b43-phy0 debug: DMA ring 3 slot 114.
[11759.366577] b43-phy0 debug: DMA ring 3 slot 116.
[11762.363796] b43-phy0 debug: DMA ring 3 slot 118.
[11765.361195] b43-phy0 debug: DMA ring 3 slot 120.
[11768.358493] b43-phy0 debug: DMA ring 3 slot 122.
[11771.355663] b43-phy0 debug: DMA ring 3 slot 124.
[11774.352940] b43-phy0 debug: DMA ring 3 slot 126.
[11774.660317] b43-phy0 debug: DMA ring 3 slot 128.
[11774.690273] b43-phy0 debug: DMA ring 3 slot 130.
[11774.759303] b43-phy0 debug: DMA ring 3 slot 132.
[11774.828665] b43-phy0 debug: DMA ring 3 slot 134.
[11774.897446] b43-phy0 debug: DMA ring 3 slot 136.
[11774.966354] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 126
[11775.035204] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 140
[11775.104113] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 142
[11775.173070] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 144
[11775.241811] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 146
[11775.311094] b43-phy0 debug: Out of order TX status report on DMA ring 3. Expected 138, but got 148

-- 
-- isedev
-- 
-- isedev
