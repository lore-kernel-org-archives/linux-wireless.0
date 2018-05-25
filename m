Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.228]:3115 "EHLO
        dnvrco-cmomta01.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S968275AbeEYUun (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 16:50:43 -0400
Message-ID: <20180525205041.G88EK.47571.root@dnvrco-web17> (sfid-20180525_225052_149417_447D5223)
Date: Fri, 25 May 2018 20:50:41 +0000
From: <mgreger@cinci.rr.com>
To: sedat.dilek@gmail.com
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CA+icZUX+p2feWOnXSA=m3i+r560Mo2kHsadT4qFhx8VvUv_k8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- Sedat Dilek <sedat.dilek@gmail.com> wrote: 
> On Tue, May 22, 2018 at 7:21 PM,  <mgreger@cinci.rr.com> wrote:
> > I've run out of ideas and am hoping someone here can help.
> >
> > All I want to do is connect a client to my 5Ghz network.
> >
> > My client:
> >   OS is Debian stable "Stretch" with sysvinit instead of systemd
> >   Atheros AR9462 (World roaming 0x64 regdomain in EEPROM)
> >   "iw reg set US"
> >   "iw list" shows both 2.4Ghz and 5Ghz bands available.
> >   "iw wlp3s0 survey dump" shows received traffic on 5Ghz bands.
> >
> > There are oodles of 5Ghz AP's within range, but scans (including passive scans) reveal only 2.4Ghz networks. My only guess was that it won't transmit due to regulatory requirements, but I cannot make it work.
> >
> > What I've tried:
> >   Running with and without CRDA
> >   Running latest mainline kernel
> >   Hacking around on the ath9k driver and nl80211 to remove all regulatory enforcement.
> >
> > Nothing works and I'm pulling my hair out. Any help would be greatly appreciated.
> 
> Hi,
> 
> I try to give some initial help.
> 
> The linux-wireless driver is supported by ath9k driver see [1] and [2].
> 
> Unfortunately, you have not sent any log-files at least your dmesg-log.
> No output of the above userspace commands or userspace-tools versions.
> No information to VendorID/ProductID (PCI, USB, whatever).
> It's not clear to me if this is a kernelspace (ath9k-driver) or
> userspace (CRDA/regulatory) problem.
> How should someone help you effectively?
> 
> The linux-wireless wiki has somne informations on how to debug
> Atheros/Qualcomm ath9k-driver, see [3].
> 
> As a debianist I say try Linux v4.16 Debian packages from
> stretch-backports (and maybe a higher version of wireless-regdb).
> 
> Try to ask questions the smart way [4] :-).
> 
> Hope this helps.
> 
> Regards,
> - Sedat -
> 
> [1] https://wireless.wiki.kernel.org/en/users/drivers/ath9k
> [2] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/devices
> [3] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/debug
> [4] http://www.catb.org/esr/faqs/smart-questions.html



Including dmesg | grep 'ath:' output:


[   24.603097] ath: phy0: TPC[00] 0x00000000
[   24.603098] ath: phy0: TPC[01] 0x00000000
[   24.603098] ath: phy0: TPC[02] 0x00000000
[   24.603099] ath: phy0: TPC[03] 0x00000000
[   24.603099] ath: phy0: TPC[04] 0x00000000
[   24.603100] ath: phy0: TPC[05] 0x00000000
[   24.603100] ath: phy0: TPC[06] 0x00000000
[   24.603101] ath: phy0: TPC[07] 0x00000000
[   24.603101] ath: phy0: TPC[08] 0x00000000
[   24.603102] ath: phy0: TPC[09] 0x00000000
[   24.603102] ath: phy0: TPC[10] 0x00000000
[   24.603103] ath: phy0: TPC[11] 0x00000000
[   24.603103] ath: phy0: TPC[12] 0x00000000
[   24.603104] ath: phy0: TPC[13] 0x00000000
[   24.603104] ath: phy0: TPC[14] 0x00000000
[   24.603105] ath: phy0: TPC[15] 0x00000000
[   24.603105] ath: phy0: TPC[16] 0x00000000
[   24.603106] ath: phy0: TPC[17] 0x00000000
[   24.603106] ath: phy0: TPC[18] 0x00000000
[   24.603107] ath: phy0: TPC[19] 0x00000000
[   24.603107] ath: phy0: TPC[20] 0x00000000
[   24.603108] ath: phy0: TPC[21] 0x00000000
[   24.603108] ath: phy0: TPC[22] 0x00000000
[   24.603109] ath: phy0: TPC[23] 0x00000000
[   24.603109] ath: phy0: TPC[24] 0x00000000
[   24.603110] ath: phy0: TPC[25] 0x00000000
[   24.603110] ath: phy0: TPC[26] 0x00000000
[   24.603111] ath: phy0: TPC[27] 0x00000000
[   24.603111] ath: phy0: TPC[28] 0x00000000
[   24.603112] ath: phy0: TPC[29] 0x00000000
[   24.603112] ath: phy0: TPC[30] 0x00000000
[   24.603113] ath: phy0: TPC[31] 0x00000000
[   24.603113] ath: phy0: TPC[32] 0x00000000
[   24.603114] ath: phy0: TPC[33] 0x00000000
[   24.603114] ath: phy0: TPC[34] 0x00000000
[   24.603115] ath: phy0: TPC[35] 0x00000000
[   24.603117] ath: phy0: ch=0 f=2412 low=2412 -21 h=2412 -21
[   24.603117] ath: phy0: ch=1 f=2412 low=2412 -15 h=2412 -15
[   24.603118] ath: phy0: ch=2 f=2412 low=2412 0 h=2412 0
[   24.603129] ath: phy0: for frequency=2412, calibration correction = -21 -15 0
[   24.603130] ath: phy0: MCI Reset (full_sleep = 0, is_2g = 1)
[   24.603782] ath: phy0: MCI Wait for Reg 0x00001838 = 0x00000800 timeout
[   24.603785] ath: phy0: MCI INT_RAW = 0x00000000, RX_MSG_RAW = 0x00000000
[   24.603873] ath: phy0: Reset TX queue: 0
[   24.603874] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603875] ath: phy0: Reset TX queue: 1
[   24.603876] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603876] ath: phy0: Reset TX queue: 2
[   24.603878] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603878] ath: phy0: Reset TX queue: 3
[   24.603879] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603880] ath: phy0: Reset TXQ, inactive queue: 4
[   24.603880] ath: phy0: Reset TXQ, inactive queue: 5
[   24.603881] ath: phy0: Reset TXQ, inactive queue: 6
[   24.603881] ath: phy0: Reset TX queue: 7
[   24.603893] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603894] ath: phy0: Reset TX queue: 8
[   24.603901] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603902] ath: phy0: Reset TX queue: 9
[   24.603909] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.603910] ath: phy0: ver 640.3 opmode 2 chan 2412 Mhz
[   24.603921] ath: phy0: ah->misc_mode 0x10000004
[   24.603939] ath: phy0: TS Start 0x28050000 End 0x28054800 Virt ffff8ce3a8050000, Size 512
[   24.604279] ath: phy0: Load RTT value at idx 0, chain 0: 0x541c531
[   24.604286] ath: phy0: Load RTT value at idx 1, chain 0: 0x541c579
[   24.604292] ath: phy0: Load RTT value at idx 2, chain 0: 0x5416409
[   24.604298] ath: phy0: Load RTT value at idx 3, chain 0: 0x5580001
[   24.604304] ath: phy0: Load RTT value at idx 4, chain 0: 0x55833c2
[   24.604310] ath: phy0: Load RTT value at idx 5, chain 0: 0x5200
[   24.604317] ath: phy0: Load RTT value at idx 0, chain 1: 0x5407371
[   24.604323] ath: phy0: Load RTT value at idx 1, chain 1: 0x5407379
[   24.604329] ath: phy0: Load RTT value at idx 2, chain 1: 0x540e2c9
[   24.604335] ath: phy0: Load RTT value at idx 3, chain 1: 0x5580001
[   24.604341] ath: phy0: Load RTT value at idx 4, chain 1: 0x55833c2
[   24.604347] ath: phy0: Load RTT value at idx 5, chain 1: 0xf800
[   24.606811] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.606819] ath: phy0: IQ_RES[0]=0x315eefad IQ_RES[1]=0x610
[   24.606825] ath: phy0: IQ_RES[2]=0xeaff05ec IQ_RES[3]=0x436f
[   24.606831] ath: phy0: IQ_RES[4]=0x3bff502c IQ_RES[5]=0xfa64
[   24.606832] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.606832] ath: phy0: tx chain 0: mag corr=-1  phase corr=7
[   24.606833] ath: phy0: tx chain 0: iq corr coeff=ffffff87
[   24.606833] ath: phy0: rx chain 0: mag corr=12  phase corr=-9
[   24.606834] ath: phy0: rx chain 0: iq corr coeff=677
[   24.606834] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.606842] ath: phy0: IQ_RES[0]=0x32659fb2 IQ_RES[1]=0x700
[   24.606848] ath: phy0: IQ_RES[2]=0xe8ffe659 IQ_RES[3]=0x480f
[   24.606854] ath: phy0: IQ_RES[4]=0x8300202a IQ_RES[5]=0xfa14
[   24.606854] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.606855] ath: phy0: tx chain 0: mag corr=-1  phase corr=5
[   24.606856] ath: phy0: tx chain 0: iq corr coeff=ffffff85
[   24.606856] ath: phy0: rx chain 0: mag corr=10  phase corr=-9
[   24.606857] ath: phy0: rx chain 0: iq corr coeff=577
[   24.606857] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.606864] ath: phy0: IQ_RES[0]=0x3062dfb5 IQ_RES[1]=0x760
[   24.606871] ath: phy0: IQ_RES[2]=0xea003632 IQ_RES[3]=0x468f
[   24.606877] ath: phy0: IQ_RES[4]=0x6b00c027 IQ_RES[5]=0xfa04
[   24.606877] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.606878] ath: phy0: tx chain 0: mag corr=-2  phase corr=5
[   24.606878] ath: phy0: tx chain 0: iq corr coeff=ffffff05
[   24.606879] ath: phy0: rx chain 0: mag corr=9  phase corr=-10
[   24.606879] ath: phy0: rx chain 0: iq corr coeff=4f6
[   24.606880] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.606887] ath: phy0: IQ_RES[0]=0x32631fbf IQ_RES[1]=0x790
[   24.606893] ath: phy0: IQ_RES[2]=0xed008633 IQ_RES[3]=0x468f
[   24.606899] ath: phy0: IQ_RES[4]=0x6800d022 IQ_RES[5]=0xf9b4
[   24.606900] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.606900] ath: phy0: tx chain 0: mag corr=-2  phase corr=3
[   24.606901] ath: phy0: tx chain 0: iq corr coeff=ffffff03
[   24.606902] ath: phy0: rx chain 0: mag corr=8  phase corr=-11
[   24.606902] ath: phy0: rx chain 0: iq corr coeff=475
[   24.606904] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.606911] ath: phy0: IQ_RES[0]=0x962c028 IQ_RES[1]=0x9a0
[   24.606917] ath: phy0: IQ_RES[2]=0x2af6a639 IQ_RES[3]=0x3610
[   24.606923] ath: phy0: IQ_RES[4]=0x68000fff IQ_RES[5]=0xf9b3
[   24.606924] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.606925] ath: phy0: tx chain 1: mag corr=-1  phase corr=6
[   24.606925] ath: phy0: tx chain 1: iq corr coeff=ffffff86
[   24.606926] ath: phy0: rx chain 1: mag corr=0  phase corr=2
[   24.606926] ath: phy0: rx chain 1: iq corr coeff=2
[   24.606927] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.606934] ath: phy0: IQ_RES[0]=0x166f02d IQ_RES[1]=0xb80
[   24.606940] ath: phy0: IQ_RES[2]=0x28f7167c IQ_RES[3]=0x3870
[   24.606946] ath: phy0: IQ_RES[4]=0x8c00dfff IQ_RES[5]=0xf923
[   24.606947] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.606947] ath: phy0: tx chain 1: mag corr=0  phase corr=4
[   24.606948] ath: phy0: tx chain 1: iq corr coeff=4
[   24.606948] ath: phy0: rx chain 1: mag corr=-1  phase corr=2
[   24.606949] ath: phy0: rx chain 1: iq corr coeff=ffffff82
[   24.606949] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.606957] ath: phy0: IQ_RES[0]=0xf7629028 IQ_RES[1]=0xbaf
[   24.606963] ath: phy0: IQ_RES[2]=0x1ff7463b IQ_RES[3]=0x3620
[   24.606969] ath: phy0: IQ_RES[4]=0x6900cffb IQ_RES[5]=0xf923
[   24.606969] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.606970] ath: phy0: tx chain 1: mag corr=0  phase corr=2
[   24.606971] ath: phy0: tx chain 1: iq corr coeff=2
[   24.606971] ath: phy0: rx chain 1: mag corr=-1  phase corr=2
[   24.606972] ath: phy0: rx chain 1: iq corr coeff=ffffff82
[   24.606972] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.606979] ath: phy0: IQ_RES[0]=0xf660802b IQ_RES[1]=0xbcf
[   24.606985] ath: phy0: IQ_RES[2]=0x20f7b617 IQ_RES[3]=0x34c0
[   24.606992] ath: phy0: IQ_RES[4]=0x56010ff9 IQ_RES[5]=0xf923
[   24.606992] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.606993] ath: phy0: tx chain 1: mag corr=0  phase corr=2
[   24.606993] ath: phy0: tx chain 1: iq corr coeff=2
[   24.606994] ath: phy0: rx chain 1: mag corr=-2  phase corr=2
[   24.606994] ath: phy0: rx chain 1: iq corr coeff=ffffff02
[   24.607054] ath: phy0: starting IQ Mismatch Calibration
[   24.607112] ath: phy0: Enabled BB Watchdog timeout (25 ms)
[   24.607118] ath: phy0: disable IER
[   24.607122] ath: phy0: New interrupt mask 0xf4000673
[   24.607123] ath: phy0: new IMR 0x81800175
[   24.607123] ath: phy0: Do not enable IER ref count -1
[   24.607124] ath: phy0: New interrupt mask 0xf4000673
[   24.607124] ath: phy0: new IMR 0x81800175
[   24.607125] ath: phy0: macaddr: 74:c6:3b:bf:90:a3, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[   24.607166] ath: phy0: Enable MIB counters
[   24.607173] ath: phy0: Restore history: opmode 2 chan 2412 Mhz is_scanning=0 ofdm:3 cck:2
[   24.607174] ath: phy0: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   24.607175] ath: phy0: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   24.607185] ath: phy0: New interrupt mask 0xf4000673
[   24.607186] ath: phy0: new IMR 0x81800175
[   24.607186] ath: phy0: enable IER
[   24.607190] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.607215] ath: phy0: Set channel: 2447 MHz width: 1
[   24.607222] ath: phy0: New interrupt mask 0xf4000643
[   24.607222] ath: phy0: new IMR 0x81800145
[   24.607223] ath: phy0: disable IER
[   24.607224] ath: phy0: disable IER
[   24.607237] ath: phy0: New interrupt mask 0xf4000673
[   24.607237] ath: phy0: new IMR 0x81800175
[   24.607238] ath: phy0: enable IER
[   24.607254] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.607254] ath: phy0: Stopping ANI
[   24.607255] ath: phy0: disable IER
[   24.607261] ath: phy0: Disable MIB counters
[   24.607316] ath: phy0: Reset to 2447 MHz, HT40: 0 fastcc: 0
[   24.607318] ath: phy0: NF did not complete in calibration window
[   24.607753] ath: phy0: TPC[00] 0x00000020
[   24.607754] ath: phy0: TPC[01] 0x0000001e
[   24.607755] ath: phy0: TPC[02] 0x0000001c
[   24.607755] ath: phy0: TPC[03] 0x0000001a
[   24.607756] ath: phy0: TPC[04] 0x00000020
[   24.607756] ath: phy0: TPC[05] 0x00000020
[   24.607757] ath: phy0: TPC[06] 0x00000020
[   24.607757] ath: phy0: TPC[07] 0x00000020
[   24.607758] ath: phy0: TPC[08] 0x0000001e
[   24.607758] ath: phy0: TPC[09] 0x0000001e
[   24.607759] ath: phy0: TPC[10] 0x0000001e
[   24.607759] ath: phy0: TPC[11] 0x0000001c
[   24.607760] ath: phy0: TPC[12] 0x0000001a
[   24.607760] ath: phy0: TPC[13] 0x00000018
[   24.607761] ath: phy0: TPC[14] 0x0000001e
[   24.607761] ath: phy0: TPC[15] 0x0000001c
[   24.607762] ath: phy0: TPC[16] 0x0000001a
[   24.607762] ath: phy0: TPC[17] 0x00000018
[   24.607763] ath: phy0: TPC[18] 0x00000000
[   24.607763] ath: phy0: TPC[19] 0x00000000
[   24.607764] ath: phy0: TPC[20] 0x00000000
[   24.607764] ath: phy0: TPC[21] 0x00000000
[   24.607765] ath: phy0: TPC[22] 0x00000000
[   24.607765] ath: phy0: TPC[23] 0x00000000
[   24.607766] ath: phy0: TPC[24] 0x00000000
[   24.607766] ath: phy0: TPC[25] 0x00000000
[   24.607767] ath: phy0: TPC[26] 0x00000000
[   24.607767] ath: phy0: TPC[27] 0x00000000
[   24.607768] ath: phy0: TPC[28] 0x00000000
[   24.607768] ath: phy0: TPC[29] 0x00000000
[   24.607769] ath: phy0: TPC[30] 0x00000000
[   24.607769] ath: phy0: TPC[31] 0x00000000
[   24.607770] ath: phy0: TPC[32] 0x00000000
[   24.607770] ath: phy0: TPC[33] 0x00000000
[   24.607771] ath: phy0: TPC[34] 0x00000000
[   24.607771] ath: phy0: TPC[35] 0x00000000
[   24.607772] ath: phy0: LOOP-Mode ctlMode 0 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.607773] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x11 chan 2447
[   24.607774] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x12 chan 2447
[   24.607774] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x15 chan 2447
[   24.607775] ath: phy0: LOOP-Ctlidx 3: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x17 chan 2447
[   24.607776] ath: phy0: LOOP-Ctlidx 4: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x41 chan 2447
[   24.607777] ath: phy0: LOOP-Ctlidx 5: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x42 chan 2447
[   24.607777] ath: phy0: LOOP-Ctlidx 6: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x45 chan 2447
[   24.607778] ath: phy0: LOOP-Ctlidx 7: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x47 chan 2447
[   24.607779] ath: phy0: LOOP-Ctlidx 8: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x31 chan 2447
[   24.607779] ath: phy0: LOOP-Ctlidx 9: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x32 chan 2447
[   24.607780] ath: phy0: LOOP-Ctlidx 10: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x35 chan 2447
[   24.607781] ath: phy0: LOOP-Ctlidx 11: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x37 chan 2447
[   24.607782] ath: phy0: SEL-Min ctlMode 0 pCtlMode 1 2xMaxEdge 23 sP 0 minCtlPwr 0
[   24.607782] ath: phy0: LOOP-Mode ctlMode 1 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.607783] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x11 chan 2447
[   24.607784] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x12 chan 2447
[   24.607785] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x15 chan 2447
[   24.607785] ath: phy0: LOOP-Ctlidx 3: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x17 chan 2447
[   24.607786] ath: phy0: LOOP-Ctlidx 4: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x41 chan 2447
[   24.607787] ath: phy0: LOOP-Ctlidx 5: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x42 chan 2447
[   24.607787] ath: phy0: LOOP-Ctlidx 6: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x45 chan 2447
[   24.607788] ath: phy0: LOOP-Ctlidx 7: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x47 chan 2447
[   24.607789] ath: phy0: LOOP-Ctlidx 8: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x31 chan 2447
[   24.607789] ath: phy0: LOOP-Ctlidx 9: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x32 chan 2447
[   24.607790] ath: phy0: LOOP-Ctlidx 10: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x35 chan 2447
[   24.607791] ath: phy0: LOOP-Ctlidx 11: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x37 chan 2447
[   24.607792] ath: phy0: SEL-Min ctlMode 1 pCtlMode 2 2xMaxEdge 25 sP 0 minCtlPwr 0
[   24.607792] ath: phy0: LOOP-Mode ctlMode 2 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.607793] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x11 chan 2447
[   24.607794] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x12 chan 2447
[   24.607794] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x15 chan 2447
[   24.607795] ath: phy0: LOOP-Ctlidx 3: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x17 chan 2447
[   24.607796] ath: phy0: LOOP-Ctlidx 4: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x41 chan 2447
[   24.607797] ath: phy0: LOOP-Ctlidx 5: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x42 chan 2447
[   24.607797] ath: phy0: LOOP-Ctlidx 6: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x45 chan 2447
[   24.607798] ath: phy0: LOOP-Ctlidx 7: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x47 chan 2447
[   24.607799] ath: phy0: LOOP-Ctlidx 8: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x31 chan 2447
[   24.607799] ath: phy0: LOOP-Ctlidx 9: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x32 chan 2447
[   24.607800] ath: phy0: LOOP-Ctlidx 10: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x35 chan 2447
[   24.607801] ath: phy0: LOOP-Ctlidx 11: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x37 chan 2447
[   24.607802] ath: phy0: SEL-Min ctlMode 2 pCtlMode 5 2xMaxEdge 25 sP 0 minCtlPwr 0
[   24.607802] ath: phy0: TPC[00] 0x00000000
[   24.607803] ath: phy0: TPC[01] 0x00000000
[   24.607803] ath: phy0: TPC[02] 0x00000000
[   24.607804] ath: phy0: TPC[03] 0x00000000
[   24.607804] ath: phy0: TPC[04] 0x00000000
[   24.607805] ath: phy0: TPC[05] 0x00000000
[   24.607805] ath: phy0: TPC[06] 0x00000000
[   24.607806] ath: phy0: TPC[07] 0x00000000
[   24.607806] ath: phy0: TPC[08] 0x00000000
[   24.607807] ath: phy0: TPC[09] 0x00000000
[   24.607807] ath: phy0: TPC[10] 0x00000000
[   24.607808] ath: phy0: TPC[11] 0x00000000
[   24.607808] ath: phy0: TPC[12] 0x00000000
[   24.607809] ath: phy0: TPC[13] 0x00000000
[   24.607809] ath: phy0: TPC[14] 0x00000000
[   24.607810] ath: phy0: TPC[15] 0x00000000
[   24.607810] ath: phy0: TPC[16] 0x00000000
[   24.607811] ath: phy0: TPC[17] 0x00000000
[   24.607811] ath: phy0: TPC[18] 0x00000000
[   24.607812] ath: phy0: TPC[19] 0x00000000
[   24.607812] ath: phy0: TPC[20] 0x00000000
[   24.607813] ath: phy0: TPC[21] 0x00000000
[   24.607813] ath: phy0: TPC[22] 0x00000000
[   24.607814] ath: phy0: TPC[23] 0x00000000
[   24.607814] ath: phy0: TPC[24] 0x00000000
[   24.607815] ath: phy0: TPC[25] 0x00000000
[   24.607815] ath: phy0: TPC[26] 0x00000000
[   24.607816] ath: phy0: TPC[27] 0x00000000
[   24.607816] ath: phy0: TPC[28] 0x00000000
[   24.607817] ath: phy0: TPC[29] 0x00000000
[   24.607818] ath: phy0: TPC[30] 0x00000000
[   24.607818] ath: phy0: TPC[31] 0x00000000
[   24.607819] ath: phy0: TPC[32] 0x00000000
[   24.607819] ath: phy0: TPC[33] 0x00000000
[   24.607820] ath: phy0: TPC[34] 0x00000000
[   24.607820] ath: phy0: TPC[35] 0x00000000
[   24.607822] ath: phy0: ch=0 f=2447 low=2442 -18 h=2472 -16
[   24.607822] ath: phy0: ch=1 f=2447 low=2442 -13 h=2472 -12
[   24.607823] ath: phy0: ch=2 f=2447 low=2442 0 h=2472 0
[   24.607834] ath: phy0: for frequency=2447, calibration correction = -18 -13 0
[   24.607835] ath: phy0: MCI Reset (full_sleep = 0, is_2g = 1)
[   24.608487] ath: phy0: MCI Wait for Reg 0x00001838 = 0x00000800 timeout
[   24.608490] ath: phy0: MCI INT_RAW = 0x00000000, RX_MSG_RAW = 0x00000000
[   24.608578] ath: phy0: Reset TX queue: 0
[   24.608579] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608579] ath: phy0: Reset TX queue: 1
[   24.608580] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608581] ath: phy0: Reset TX queue: 2
[   24.608582] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608583] ath: phy0: Reset TX queue: 3
[   24.608584] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608584] ath: phy0: Reset TXQ, inactive queue: 4
[   24.608585] ath: phy0: Reset TXQ, inactive queue: 5
[   24.608585] ath: phy0: Reset TXQ, inactive queue: 6
[   24.608586] ath: phy0: Reset TX queue: 7
[   24.608598] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608599] ath: phy0: Reset TX queue: 8
[   24.608606] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608607] ath: phy0: Reset TX queue: 9
[   24.608613] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.608615] ath: phy0: ver 640.3 opmode 2 chan 2447 Mhz
[   24.608625] ath: phy0: ah->misc_mode 0x10000004
[   24.608644] ath: phy0: TS Start 0x28050000 End 0x28054800 Virt ffff8ce3a8050000, Size 512
[   24.608967] ath: phy0: RTT calibration to be done
[   24.612639] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.612646] ath: phy0: IQ_RES[0]=0x456e2fbe IQ_RES[1]=0x580
[   24.612652] ath: phy0: IQ_RES[2]=0xeffa46e2 IQ_RES[3]=0x4d4f
[   24.612658] ath: phy0: IQ_RES[4]=0xd9fbb026 IQ_RES[5]=0xf954
[   24.612659] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.612659] ath: phy0: tx chain 0: mag corr=-1  phase corr=5
[   24.612660] ath: phy0: tx chain 0: iq corr coeff=ffffff85
[   24.612660] ath: phy0: rx chain 0: mag corr=8  phase corr=-8
[   24.612661] ath: phy0: rx chain 0: iq corr coeff=478
[   24.612661] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.612669] ath: phy0: IQ_RES[0]=0x43745fc0 IQ_RES[1]=0x6c0
[   24.612675] ath: phy0: IQ_RES[2]=0xeefaf747 IQ_RES[3]=0x51df
[   24.612681] ath: phy0: IQ_RES[4]=0x21fc3020 IQ_RES[5]=0xf875
[   24.612681] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.612682] ath: phy0: tx chain 0: mag corr=-1  phase corr=4
[   24.612682] ath: phy0: tx chain 0: iq corr coeff=ffffff84
[   24.612683] ath: phy0: rx chain 0: mag corr=7  phase corr=-9
[   24.612684] ath: phy0: rx chain 0: iq corr coeff=3f7
[   24.612684] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.612691] ath: phy0: IQ_RES[0]=0x43706fc7 IQ_RES[1]=0x740
[   24.612697] ath: phy0: IQ_RES[2]=0xf0fba706 IQ_RES[3]=0x4eef
[   24.612703] ath: phy0: IQ_RES[4]=0xf3fcc01d IQ_RES[5]=0xf844
[   24.612704] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.612705] ath: phy0: tx chain 0: mag corr=-2  phase corr=3
[   24.612705] ath: phy0: tx chain 0: iq corr coeff=ffffff03
[   24.612706] ath: phy0: rx chain 0: mag corr=7  phase corr=-11
[   24.612706] ath: phy0: rx chain 0: iq corr coeff=3f5
[   24.612707] ath: phy0: Doing Tx IQ Cal for chain 0
[   24.612714] ath: phy0: IQ_RES[0]=0x406f1fd0 IQ_RES[1]=0x7d0
[   24.612720] ath: phy0: IQ_RES[2]=0xf0fb66f7 IQ_RES[3]=0x4e1f
[   24.612726] ath: phy0: IQ_RES[4]=0xe8fcf01c IQ_RES[5]=0xf834
[   24.612727] ath: phy0: chain 0: mag mismatch=0 phase mismatch=0
[   24.612727] ath: phy0: tx chain 0: mag corr=-2  phase corr=2
[   24.612728] ath: phy0: tx chain 0: iq corr coeff=ffffff02
[   24.612728] ath: phy0: rx chain 0: mag corr=5  phase corr=-11
[   24.612729] ath: phy0: rx chain 0: iq corr coeff=2f5
[   24.612731] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.612738] ath: phy0: IQ_RES[0]=0x56b4042 IQ_RES[1]=0x570
[   24.612744] ath: phy0: IQ_RES[2]=0x2ef2d6c2 IQ_RES[3]=0x3b10
[   24.612750] ath: phy0: IQ_RES[4]=0xb6fceff5 IQ_RES[5]=0xfad3
[   24.612751] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.612751] ath: phy0: tx chain 1: mag corr=-1  phase corr=3
[   24.612752] ath: phy0: tx chain 1: iq corr coeff=ffffff83
[   24.612752] ath: phy0: rx chain 1: mag corr=-3  phase corr=2
[   24.612753] ath: phy0: rx chain 1: iq corr coeff=fffffe82
[   24.612753] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.612761] ath: phy0: IQ_RES[0]=0x6f6046 IQ_RES[1]=0x790
[   24.612767] ath: phy0: IQ_RES[2]=0x2df28704 IQ_RES[3]=0x3d30
[   24.612773] ath: phy0: IQ_RES[4]=0xd6fd8ff4 IQ_RES[5]=0xf9c3
[   24.612773] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.612774] ath: phy0: tx chain 1: mag corr=-1  phase corr=2
[   24.612774] ath: phy0: tx chain 1: iq corr coeff=ffffff82
[   24.612775] ath: phy0: rx chain 1: mag corr=-3  phase corr=1
[   24.612775] ath: phy0: rx chain 1: iq corr coeff=fffffe81
[   24.612776] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.612783] ath: phy0: IQ_RES[0]=0xf26a1037 IQ_RES[1]=0x7ef
[   24.612789] ath: phy0: IQ_RES[2]=0x22f2b6af IQ_RES[3]=0x3a40
[   24.612795] ath: phy0: IQ_RES[4]=0xadfd7ff6 IQ_RES[5]=0xf9b3
[   24.612796] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.612797] ath: phy0: tx chain 1: mag corr=0  phase corr=1
[   24.612797] ath: phy0: tx chain 1: iq corr coeff=1
[   24.612798] ath: phy0: rx chain 1: mag corr=-3  phase corr=2
[   24.612798] ath: phy0: rx chain 1: iq corr coeff=fffffe82
[   24.612799] ath: phy0: Doing Tx IQ Cal for chain 1
[   24.612806] ath: phy0: IQ_RES[0]=0xef67303d IQ_RES[1]=0x86f
[   24.612812] ath: phy0: IQ_RES[2]=0x20f30682 IQ_RES[3]=0x38d0
[   24.612818] ath: phy0: IQ_RES[4]=0x92fddff2 IQ_RES[5]=0xf963
[   24.612819] ath: phy0: chain 1: mag mismatch=0 phase mismatch=0
[   24.612819] ath: phy0: tx chain 1: mag corr=0  phase corr=0
[   24.612820] ath: phy0: tx chain 1: iq corr coeff=0
[   24.612820] ath: phy0: rx chain 1: mag corr=-4  phase corr=1
[   24.612821] ath: phy0: rx chain 1: iq corr coeff=fffffe01
[   24.612886] ath: phy0: RTT value at idx 0, chain 0 is: 0x541d531
[   24.612891] ath: phy0: RTT value at idx 1, chain 0 is: 0x541d579
[   24.612896] ath: phy0: RTT value at idx 2, chain 0 is: 0x5416409
[   24.612901] ath: phy0: RTT value at idx 3, chain 0 is: 0x5580001
[   24.612906] ath: phy0: RTT value at idx 4, chain 0 is: 0x55833c2
[   24.612913] ath: phy0: RTT value at idx 5, chain 0 is: 0x5200
[   24.612918] ath: phy0: RTT value at idx 0, chain 1 is: 0x5407371
[   24.612923] ath: phy0: RTT value at idx 1, chain 1 is: 0x5408379
[   24.612928] ath: phy0: RTT value at idx 2, chain 1 is: 0x540e2c9
[   24.612933] ath: phy0: RTT value at idx 3, chain 1 is: 0x5580001
[   24.612938] ath: phy0: RTT value at idx 4, chain 1 is: 0x55833c2
[   24.612945] ath: phy0: RTT value at idx 5, chain 1 is: 0xf800
[   24.612951] ath: phy0: Load RTT value at idx 0, chain 0: 0x541d531
[   24.612957] ath: phy0: Load RTT value at idx 1, chain 0: 0x541d579
[   24.612963] ath: phy0: Load RTT value at idx 2, chain 0: 0x5416409
[   24.612970] ath: phy0: Load RTT value at idx 3, chain 0: 0x5580001
[   24.612976] ath: phy0: Load RTT value at idx 4, chain 0: 0x55833c2
[   24.612982] ath: phy0: Load RTT value at idx 5, chain 0: 0x5200
[   24.612988] ath: phy0: Load RTT value at idx 0, chain 1: 0x5407371
[   24.612994] ath: phy0: Load RTT value at idx 1, chain 1: 0x5408379
[   24.613001] ath: phy0: Load RTT value at idx 2, chain 1: 0x540e2c9
[   24.613007] ath: phy0: Load RTT value at idx 3, chain 1: 0x5580001
[   24.613013] ath: phy0: Load RTT value at idx 4, chain 1: 0x55833c2
[   24.613019] ath: phy0: Load RTT value at idx 5, chain 1: 0xf800
[   24.613341] ath: phy0: starting IQ Mismatch Calibration
[   24.613399] ath: phy0: Enabled BB Watchdog timeout (25 ms)
[   24.613405] ath: phy0: disable IER
[   24.613409] ath: phy0: New interrupt mask 0xf4000673
[   24.613409] ath: phy0: new IMR 0x81800175
[   24.613410] ath: phy0: Do not enable IER ref count -1
[   24.613410] ath: phy0: New interrupt mask 0xf4000673
[   24.613411] ath: phy0: new IMR 0x81800175
[   24.613412] ath: phy0: macaddr: 74:c6:3b:bf:90:a3, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[   24.613452] ath: phy0: Enable MIB counters
[   24.613459] ath: phy0: Restore history: opmode 2 chan 2447 Mhz is_scanning=0 ofdm:3 cck:2
[   24.613460] ath: phy0: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   24.613461] ath: phy0: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   24.613471] ath: phy0: New interrupt mask 0xf4000673
[   24.613471] ath: phy0: new IMR 0x81800175
[   24.613472] ath: phy0: enable IER
[   24.613475] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.613478] ath: phy0: vif 74:c6:3b:bf:90:a3 power 16 dbm power_type 0
[   24.613480] ath: phy0: TPC[00] 0x00000020
[   24.613498] ath: phy0: TPC[01] 0x0000001e
[   24.613499] ath: phy0: TPC[02] 0x0000001c
[   24.613500] ath: phy0: TPC[03] 0x0000001a
[   24.613500] ath: phy0: TPC[04] 0x00000020
[   24.613501] ath: phy0: TPC[05] 0x00000020
[   24.613501] ath: phy0: TPC[06] 0x00000020
[   24.613502] ath: phy0: TPC[07] 0x00000020
[   24.613503] ath: phy0: New interrupt mask 0xf4000643
[   24.613503] ath: phy0: new IMR 0x81800145
[   24.613504] ath: phy0: TPC[08] 0x0000001e
[   24.613504] ath: phy0: disable IER
[   24.613505] ath: phy0: TPC[09] 0x0000001e
[   24.613506] ath: phy0: TPC[10] 0x0000001e
[   24.613506] ath: phy0: TPC[11] 0x0000001c
[   24.613507] ath: phy0: TPC[12] 0x0000001a
[   24.613507] ath: phy0: TPC[13] 0x00000018
[   24.613508] ath: phy0: TPC[14] 0x0000001e
[   24.613509] ath: phy0: TPC[15] 0x0000001c
[   24.613509] ath: phy0: TPC[16] 0x0000001a
[   24.613510] ath: phy0: TPC[17] 0x00000018
[   24.613511] ath: phy0: TPC[18] 0x00000000
[   24.613511] ath: phy0: TPC[19] 0x00000000
[   24.613512] ath: phy0: TPC[20] 0x00000000
[   24.613512] ath: phy0: TPC[21] 0x00000000
[   24.613513] ath: phy0: TPC[22] 0x00000000
[   24.613513] ath: phy0: New interrupt mask 0xf4000673
[   24.613514] ath: phy0: new IMR 0x81800175
[   24.613515] ath: phy0: TPC[23] 0x00000000
[   24.613515] ath: phy0: enable IER
[   24.613516] ath: phy0: TPC[24] 0x00000000
[   24.613516] ath: phy0: TPC[25] 0x00000000
[   24.613517] ath: phy0: TPC[26] 0x00000000
[   24.613517] ath: phy0: TPC[27] 0x00000000
[   24.613518] ath: phy0: TPC[28] 0x00000000
[   24.613519] ath: phy0: TPC[29] 0x00000000
[   24.613519] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.613520] ath: phy0: TPC[30] 0x00000000
[   24.613521] ath: phy0: TPC[31] 0x00000000
[   24.613521] ath: phy0: TPC[32] 0x00000000
[   24.613522] ath: phy0: TPC[33] 0x00000000
[   24.613523] ath: phy0: TPC[34] 0x00000000
[   24.613523] ath: phy0: TPC[35] 0x00000000
[   24.613524] ath: phy0: LOOP-Mode ctlMode 0 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.613525] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x11 chan 2447
[   24.613526] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x12 chan 2447
[   24.613526] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x15 chan 2447
[   24.613540] ath: phy0: LOOP-Ctlidx 3: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x17 chan 2447
[   24.613540] ath: phy0: LOOP-Ctlidx 4: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x41 chan 2447
[   24.613541] ath: phy0: LOOP-Ctlidx 5: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x42 chan 2447
[   24.613542] ath: phy0: LOOP-Ctlidx 6: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x45 chan 2447
[   24.613543] ath: phy0: LOOP-Ctlidx 7: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x47 chan 2447
[   24.613543] ath: phy0: LOOP-Ctlidx 8: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x31 chan 2447
[   24.613544] ath: phy0: LOOP-Ctlidx 9: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x32 chan 2447
[   24.613545] ath: phy0: LOOP-Ctlidx 10: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x35 chan 2447
[   24.613546] ath: phy0: LOOP-Ctlidx 11: cfgCtl 0xe2 pCtlMode 0x01 ctlIndex 0x37 chan 2447
[   24.613546] ath: phy0: SEL-Min ctlMode 0 pCtlMode 1 2xMaxEdge 23 sP 26 minCtlPwr 23
[   24.613547] ath: phy0: LOOP-Mode ctlMode 1 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.613548] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x11 chan 2447
[   24.613548] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x12 chan 2447
[   24.613549] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x15 chan 2447
[   24.613550] ath: phy0: LOOP-Ctlidx 3: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x17 chan 2447
[   24.613551] ath: phy0: LOOP-Ctlidx 4: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x41 chan 2447
[   24.613551] ath: phy0: LOOP-Ctlidx 5: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x42 chan 2447
[   24.613552] ath: phy0: LOOP-Ctlidx 6: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x45 chan 2447
[   24.613553] ath: phy0: LOOP-Ctlidx 7: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x47 chan 2447
[   24.613554] ath: phy0: LOOP-Ctlidx 8: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x31 chan 2447
[   24.613554] ath: phy0: LOOP-Ctlidx 9: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x32 chan 2447
[   24.613555] ath: phy0: LOOP-Ctlidx 10: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x35 chan 2447
[   24.613556] ath: phy0: LOOP-Ctlidx 11: cfgCtl 0xe2 pCtlMode 0x02 ctlIndex 0x37 chan 2447
[   24.613556] ath: phy0: SEL-Min ctlMode 1 pCtlMode 2 2xMaxEdge 25 sP 26 minCtlPwr 25
[   24.613557] ath: phy0: LOOP-Mode ctlMode 2 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.613558] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x11 chan 2447
[   24.613558] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x12 chan 2447
[   24.613559] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x15 chan 2447
[   24.613560] ath: phy0: LOOP-Ctlidx 3: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x17 chan 2447
[   24.613561] ath: phy0: LOOP-Ctlidx 4: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x41 chan 2447
[   24.613561] ath: phy0: LOOP-Ctlidx 5: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x42 chan 2447
[   24.613562] ath: phy0: LOOP-Ctlidx 6: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x45 chan 2447
[   24.613563] ath: phy0: LOOP-Ctlidx 7: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x47 chan 2447
[   24.613563] ath: phy0: LOOP-Ctlidx 8: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x31 chan 2447
[   24.613564] ath: phy0: LOOP-Ctlidx 9: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x32 chan 2447
[   24.613565] ath: phy0: LOOP-Ctlidx 10: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x35 chan 2447
[   24.613566] ath: phy0: LOOP-Ctlidx 11: cfgCtl 0xe2 pCtlMode 0x05 ctlIndex 0x37 chan 2447
[   24.613566] ath: phy0: SEL-Min ctlMode 2 pCtlMode 5 2xMaxEdge 25 sP 26 minCtlPwr 25
[   24.613567] ath: phy0: TPC[00] 0x00000019
[   24.613568] ath: phy0: TPC[01] 0x00000019
[   24.613568] ath: phy0: TPC[02] 0x00000019
[   24.613569] ath: phy0: TPC[03] 0x00000019
[   24.613569] ath: phy0: TPC[04] 0x00000017
[   24.613570] ath: phy0: TPC[05] 0x00000017
[   24.613570] ath: phy0: TPC[06] 0x00000017
[   24.613571] ath: phy0: TPC[07] 0x00000017
[   24.613571] ath: phy0: TPC[08] 0x00000019
[   24.613572] ath: phy0: TPC[09] 0x00000019
[   24.613572] ath: phy0: TPC[10] 0x00000019
[   24.613573] ath: phy0: TPC[11] 0x00000019
[   24.613573] ath: phy0: TPC[12] 0x00000019
[   24.613574] ath: phy0: TPC[13] 0x00000018
[   24.613574] ath: phy0: TPC[14] 0x00000019
[   24.613575] ath: phy0: TPC[15] 0x00000019
[   24.613575] ath: phy0: TPC[16] 0x00000019
[   24.613576] ath: phy0: TPC[17] 0x00000018
[   24.613576] ath: phy0: TPC[18] 0x00000000
[   24.613577] ath: phy0: TPC[19] 0x00000000
[   24.613577] ath: phy0: TPC[20] 0x00000000
[   24.613578] ath: phy0: TPC[21] 0x00000000
[   24.613578] ath: phy0: TPC[22] 0x00000000
[   24.613579] ath: phy0: TPC[23] 0x00000000
[   24.613579] ath: phy0: TPC[24] 0x00000000
[   24.613580] ath: phy0: TPC[25] 0x00000000
[   24.613580] ath: phy0: TPC[26] 0x00000000
[   24.613581] ath: phy0: TPC[27] 0x00000000
[   24.613581] ath: phy0: TPC[28] 0x00000000
[   24.613582] ath: phy0: TPC[29] 0x00000000
[   24.613582] ath: phy0: TPC[30] 0x00000000
[   24.613583] ath: phy0: TPC[31] 0x00000000
[   24.613583] ath: phy0: TPC[32] 0x00000000
[   24.613584] ath: phy0: TPC[33] 0x00000000
[   24.613584] ath: phy0: TPC[34] 0x00000000
[   24.613585] ath: phy0: TPC[35] 0x00000000
[   24.613587] ath: phy0: ch=0 f=2447 low=2442 -18 h=2472 -16
[   24.613587] ath: phy0: ch=1 f=2447 low=2442 -13 h=2472 -12
[   24.613588] ath: phy0: ch=2 f=2447 low=2442 0 h=2472 0
[   24.613599] ath: phy0: for frequency=2447, calibration correction = -18 -13 0
[   24.613606] ath: phy0: disable IER
[   24.613611] ath: phy0: New interrupt mask 0xf4000673
[   24.613611] ath: phy0: new IMR 0x81800175
[   24.613612] ath: phy0: enable IER
[   24.613615] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.613616] ath: phy0: New interrupt mask 0xf4000673
[   24.613616] ath: phy0: new IMR 0x81800175
[   24.613617] ath: phy0: macaddr: 74:c6:3b:bf:90:a3, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[   24.613619] ath: phy0: Add station: c0:56:27:62:ac:49
[   24.613635] ath: phy0: transmitting packet, skb: ffff8ceba8414b00
[   24.613638] ath: phy0: qnum: 3, txq depth: 0
[   24.613639] ath: phy0: TXDP[3] = 28040a00 (ffff8ce3a8040a00)
[   24.614577] ath: phy0: disable IER
[   24.614587] ath: phy0: TX complete: skb: ffff8ceba8414b00
[   24.614594] ath: phy0: enable IER
[   24.614598] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.616134] ath: phy0: disable IER
[   24.616156] ath: phy0: enable IER
[   24.616160] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.616934] ath: phy0: transmitting packet, skb: ffff8cebcafd7400
[   24.616937] ath: phy0: qnum: 3, txq depth: 0
[   24.616938] ath: phy0: TXDP[3] = 28040a80 (ffff8ce3a8040a80)
[   24.618573] ath: phy0: disable IER
[   24.618583] ath: phy0: TX complete: skb: ffff8cebcafd7400
[   24.618590] ath: phy0: enable IER
[   24.618594] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.629838] ath: phy0: disable IER
[   24.629861] ath: phy0: enable IER
[   24.629865] ath: phy0: AR_IMR 0x81800175 IER 0x1
[   24.629906] ath: phy0: Configure tx [queue/halq] [0/3], aifs: 2, cw_min: 3, cw_max: 7, txop: 47
[   24.629907] ath: phy0: Set queue properties for: 3
[   24.629908] ath: phy0: Reset TX queue: 3
[   24.629909] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.629911] ath: phy0: Configure tx [queue/halq] [1/2], aifs: 2, cw_min: 7, cw_max: 15, txop: 94
[   24.629912] ath: phy0: Set queue properties for: 2
[   24.629912] ath: phy0: Reset TX queue: 2
[   24.629914] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.629915] ath: phy0: Configure tx [queue/halq] [2/1], aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
[   24.629916] ath: phy0: Set queue properties for: 1
[   24.629917] ath: phy0: Reset TX queue: 1
[   24.629918] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.629919] ath: phy0: Configure tx [queue/halq] [3/0], aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
[   24.629920] ath: phy0: Set queue properties for: 0
[   24.629920] ath: phy0: Reset TX queue: 0
[   24.629922] ath: phy0: tx ok 0x38f err 0x38f desc 0x0 eol 0x0 urn 0x0
[   24.629924] ath: phy0: BSSID c0:56:27:62:ac:49 Changed ASSOC 1
[   24.629930] ath: phy0: WLAN current channel 45 mask BT channel 28 - 62
[   24.629931] ath: phy0: Primary Station interface: 74:c6:3b:bf:90:a3, BSSID: c0:56:27:62:ac:49
[   24.629932] ath: phy0: Caching beacon data for BSS: c0:56:27:62:ac:49
[   24.629937] ath: phy0: bmiss: 10 sleep: 102400
[   24.629937] ath: phy0: disable IER
[   24.629944] ath: phy0: next DTIM 3276800
[   24.629945] ath: phy0: next beacon 3174400
[   24.629945] ath: phy0: beacon period 102400
[   24.629946] ath: phy0: DTIM period 204800
[   24.629949] ath: phy0: New interrupt mask 0xf4040673
[   24.629950] ath: phy0: new IMR 0x81840175
[   24.629950] ath: phy0: enable IER
[   24.629954] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.629955] ath: phy0: New interrupt mask 0xf4040673
[   24.629955] ath: phy0: new IMR 0x81840175
[   24.629956] ath: phy0: ah->misc_mode 0x10000004
[   24.629966] ath: phy0: macaddr: 74:c6:3b:bf:90:a3, bssid: c0:56:27:62:ac:49, bssidmask: ff:ff:ff:ff:ff:ff
[   24.629972] ath: phy0: WLAN current channel 45 mask BT channel 28 - 62
[   24.629973] ath: phy0: Primary Station interface: 74:c6:3b:bf:90:a3, BSSID: c0:56:27:62:ac:49
[   24.629973] ath: phy0: Caching beacon data for BSS: c0:56:27:62:ac:49
[   24.629977] ath: phy0: bmiss: 10 sleep: 102400
[   24.629978] ath: phy0: disable IER
[   24.629985] ath: phy0: next DTIM 3276800
[   24.629985] ath: phy0: next beacon 3174400
[   24.629986] ath: phy0: beacon period 102400
[   24.629986] ath: phy0: DTIM period 204800
[   24.629990] ath: phy0: New interrupt mask 0xf4040673
[   24.629991] ath: phy0: new IMR 0x81840175
[   24.629991] ath: phy0: enable IER
[   24.629995] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.629995] ath: phy0: New interrupt mask 0xf4040673
[   24.629996] ath: phy0: new IMR 0x81840175
[   24.629997] ath: phy0: macaddr: 74:c6:3b:bf:90:a3, bssid: c0:56:27:62:ac:49, bssidmask: ff:ff:ff:ff:ff:ff
[   24.629998] ath: phy0: ah->misc_mode 0x10000004
[   24.630007] ath: phy0: Starting ANI
[   24.632199] ath: phy0: disable IER
[   24.632226] ath: phy0: enable IER
[   24.632231] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.632405] ath: phy0: transmitting packet, skb: ffff8ceba8dd0c00
[   24.632409] ath: phy0: qnum: 3, txq depth: 0
[   24.632411] ath: phy0: TXDP[3] = 28040b00 (ffff8ce3a8040b00)
[   24.632702] ath: EEPROM regdomain: 0x8348
[   24.632703] ath: EEPROM indicates we should expect a country code
[   24.632703] ath: doing EEPROM country->regdmn map search
[   24.632704] ath: country maps to regdmn code: 0x3a
[   24.632704] ath: Country alpha2 being used: US
[   24.632705] ath: Regpair used: 0x3a
[   24.632705] ath: regdomain 0x8348 dynamically updated by country IE
[   24.632709] ath: phy0: TPC[00] 0x00000020
[   24.632710] ath: phy0: TPC[01] 0x0000001e
[   24.632710] ath: phy0: TPC[02] 0x0000001c
[   24.632711] ath: phy0: TPC[03] 0x0000001a
[   24.632712] ath: phy0: TPC[04] 0x00000020
[   24.632712] ath: phy0: TPC[05] 0x00000020
[   24.632713] ath: phy0: TPC[06] 0x00000020
[   24.632714] ath: phy0: TPC[07] 0x00000020
[   24.632714] ath: phy0: TPC[08] 0x0000001e
[   24.632715] ath: phy0: TPC[09] 0x0000001e
[   24.632716] ath: phy0: TPC[10] 0x0000001e
[   24.632716] ath: phy0: TPC[11] 0x0000001c
[   24.632717] ath: phy0: TPC[12] 0x0000001a
[   24.632718] ath: phy0: TPC[13] 0x00000018
[   24.632718] ath: phy0: TPC[14] 0x0000001e
[   24.632719] ath: phy0: TPC[15] 0x0000001c
[   24.632720] ath: phy0: TPC[16] 0x0000001a
[   24.632720] ath: phy0: TPC[17] 0x00000018
[   24.632721] ath: phy0: TPC[18] 0x00000000
[   24.632722] ath: phy0: TPC[19] 0x00000000
[   24.632722] ath: phy0: TPC[20] 0x00000000
[   24.632723] ath: phy0: TPC[21] 0x00000000
[   24.632724] ath: phy0: TPC[22] 0x00000000
[   24.632724] ath: phy0: TPC[23] 0x00000000
[   24.632725] ath: phy0: TPC[24] 0x00000000
[   24.632726] ath: phy0: TPC[25] 0x00000000
[   24.632726] ath: phy0: TPC[26] 0x00000000
[   24.632727] ath: phy0: TPC[27] 0x00000000
[   24.632728] ath: phy0: TPC[28] 0x00000000
[   24.632728] ath: phy0: TPC[29] 0x00000000
[   24.632729] ath: phy0: TPC[30] 0x00000000
[   24.632730] ath: phy0: TPC[31] 0x00000000
[   24.632731] ath: phy0: TPC[32] 0x00000000
[   24.632731] ath: phy0: TPC[33] 0x00000000
[   24.632732] ath: phy0: TPC[34] 0x00000000
[   24.632733] ath: phy0: TPC[35] 0x00000000
[   24.632734] ath: phy0: LOOP-Mode ctlMode 0 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.632735] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0x12 pCtlMode 0x01 ctlIndex 0x11 chan 2447
[   24.632736] ath: phy0: SEL-Min ctlMode 0 pCtlMode 1 2xMaxEdge 33 sP 54 minCtlPwr 33
[   24.632738] ath: phy0: LOOP-Mode ctlMode 1 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.632739] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0x12 pCtlMode 0x02 ctlIndex 0x11 chan 2447
[   24.632740] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0x12 pCtlMode 0x02 ctlIndex 0x12 chan 2447
[   24.632741] ath: phy0: SEL-Min ctlMode 1 pCtlMode 2 2xMaxEdge 33 sP 54 minCtlPwr 33
[   24.632741] ath: phy0: LOOP-Mode ctlMode 2 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.632742] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0x12 pCtlMode 0x05 ctlIndex 0x11 chan 2447
[   24.632743] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0x12 pCtlMode 0x05 ctlIndex 0x12 chan 2447
[   24.632744] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0x12 pCtlMode 0x05 ctlIndex 0x15 chan 2447
[   24.632745] ath: phy0: SEL-Min ctlMode 2 pCtlMode 5 2xMaxEdge 31 sP 54 minCtlPwr 31
[   24.632746] ath: phy0: TPC[00] 0x00000020
[   24.632747] ath: phy0: TPC[01] 0x0000001e
[   24.632748] ath: phy0: TPC[02] 0x0000001c
[   24.632748] ath: phy0: TPC[03] 0x0000001a
[   24.632749] ath: phy0: TPC[04] 0x00000020
[   24.632750] ath: phy0: TPC[05] 0x00000020
[   24.632750] ath: phy0: TPC[06] 0x00000020
[   24.632751] ath: phy0: TPC[07] 0x00000020
[   24.632752] ath: phy0: TPC[08] 0x0000001e
[   24.632752] ath: phy0: TPC[09] 0x0000001e
[   24.632753] ath: phy0: TPC[10] 0x0000001e
[   24.632754] ath: phy0: TPC[11] 0x0000001c
[   24.632754] ath: phy0: TPC[12] 0x0000001a
[   24.632755] ath: phy0: TPC[13] 0x00000018
[   24.632756] ath: phy0: TPC[14] 0x0000001e
[   24.632756] ath: phy0: TPC[15] 0x0000001c
[   24.632757] ath: phy0: TPC[16] 0x0000001a
[   24.632758] ath: phy0: TPC[17] 0x00000018
[   24.632759] ath: phy0: TPC[18] 0x00000000
[   24.632759] ath: phy0: TPC[19] 0x00000000
[   24.632760] ath: phy0: TPC[20] 0x00000000
[   24.632761] ath: phy0: TPC[21] 0x00000000
[   24.632761] ath: phy0: TPC[22] 0x00000000
[   24.632762] ath: phy0: TPC[23] 0x00000000
[   24.632763] ath: phy0: TPC[24] 0x00000000
[   24.632763] ath: phy0: TPC[25] 0x00000000
[   24.632764] ath: phy0: TPC[26] 0x00000000
[   24.632765] ath: phy0: TPC[27] 0x00000000
[   24.632765] ath: phy0: TPC[28] 0x00000000
[   24.632766] ath: phy0: TPC[29] 0x00000000
[   24.632767] ath: phy0: TPC[30] 0x00000000
[   24.632767] ath: phy0: TPC[31] 0x00000000
[   24.632768] ath: phy0: TPC[32] 0x00000000
[   24.632769] ath: phy0: TPC[33] 0x00000000
[   24.632769] ath: phy0: TPC[34] 0x00000000
[   24.632770] ath: phy0: TPC[35] 0x00000000
[   24.632772] ath: phy0: ch=0 f=2447 low=2442 -18 h=2472 -16
[   24.632773] ath: phy0: ch=1 f=2447 low=2442 -13 h=2472 -12
[   24.632774] ath: phy0: ch=2 f=2447 low=2442 0 h=2472 0
[   24.632786] ath: phy0: for frequency=2447, calibration correction = -18 -13 0
[   24.634218] ath: phy0: disable IER
[   24.634226] ath: phy0: TX complete: skb: ffff8ceba8dd0c00
[   24.634229] ath: phy0: enable IER
[   24.634233] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.637294] ath: phy0: disable IER
[   24.637323] ath: phy0: enable IER
[   24.637327] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.637424] ath: phy0: transmitting packet, skb: ffff8ceba8a62600
[   24.637428] ath: phy0: qnum: 3, txq depth: 0
[   24.637429] ath: phy0: TXDP[3] = 28040b80 (ffff8ce3a8040b80)
[   24.639104] ath: phy0: disable IER
[   24.639114] ath: phy0: TX complete: skb: ffff8ceba8a62600
[   24.639117] ath: phy0: enable IER
[   24.639121] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.652080] ath: phy0: Set HW Key 0
[   24.652293] ath: phy0: Set HW Key 0
[   24.652649] ath: phy0: Set HW RX filter: 0x80607
[   24.653233] ath: phy0: disable IER
[   24.653255] ath: phy0: Reconfigure beacon timers based on synchronized timestamp
[   24.653263] ath: phy0: bmiss: 10 sleep: 102400
[   24.653265] ath: phy0: disable IER
[   24.653274] ath: phy0: next DTIM 571506688
[   24.653276] ath: phy0: next beacon 571506688
[   24.653278] ath: phy0: beacon period 102400
[   24.653280] ath: phy0: DTIM period 204800
[   24.653286] ath: phy0: New interrupt mask 0xf4040673
[   24.653288] ath: phy0: new IMR 0x81840175
[   24.653290] ath: phy0: enable IER
[   24.653296] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.653312] ath: phy0: enable IER
[   24.653318] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.653767] ath: phy0: disable IER
[   24.653783] ath: phy0: enable IER
[   24.653790] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.659458] ath: phy0: disable IER
[   24.659498] ath: phy0: enable IER
[   24.659505] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.660985] ath: phy0: transmitting packet, skb: ffff8cebda4af900
[   24.660997] ath: phy0: qnum: 1, txq depth: 0
[   24.661001] ath: phy0: TXDP[1] = 28040c00 (ffff8ce3a8040c00)
[   24.662232] ath: phy0: disable IER
[   24.662253] ath: phy0: TX complete: skb: ffff8cebda4af900
[   24.662263] ath: phy0: enable IER
[   24.662270] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.705037] ath: phy0: ath_tx_aggr_start called
[   24.705061] ath: phy0: transmitting packet, skb: ffff8ceba84fde00
[   24.705071] ath: phy0: qnum: 3, txq depth: 0
[   24.705075] ath: phy0: TXDP[3] = 28040c80 (ffff8ce3a8040c80)
[   24.706016] ath: phy0: disable IER
[   24.706037] ath: phy0: TX complete: skb: ffff8ceba84fde00
[   24.706053] ath: phy0: enable IER
[   24.706060] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.707064] ath: phy0: disable IER
[   24.707110] ath: phy0: enable IER
[   24.707118] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.707161] ath: phy0: ath_tx_aggr_resume called
[   24.756273] ath: phy0: disable IER
[   24.756324] ath: phy0: enable IER
[   24.756333] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.757509] ath: phy0: disable IER
[   24.757556] ath: phy0: enable IER
[   24.757563] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.858672] ath: phy0: disable IER
[   24.858723] ath: phy0: enable IER
[   24.858731] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.865007] ath: phy0: TPC[00] 0x00000020
[   24.865011] ath: phy0: TPC[01] 0x0000001e
[   24.865013] ath: phy0: TPC[02] 0x0000001c
[   24.865015] ath: phy0: TPC[03] 0x0000001a
[   24.865018] ath: phy0: TPC[04] 0x00000020
[   24.865020] ath: phy0: TPC[05] 0x00000020
[   24.865023] ath: phy0: TPC[06] 0x00000020
[   24.865025] ath: phy0: TPC[07] 0x00000020
[   24.865028] ath: phy0: TPC[08] 0x0000001e
[   24.865030] ath: phy0: TPC[09] 0x0000001e
[   24.865033] ath: phy0: TPC[10] 0x0000001e
[   24.865036] ath: phy0: TPC[11] 0x0000001c
[   24.865038] ath: phy0: TPC[12] 0x0000001a
[   24.865040] ath: phy0: TPC[13] 0x00000018
[   24.865043] ath: phy0: TPC[14] 0x0000001e
[   24.865045] ath: phy0: TPC[15] 0x0000001c
[   24.865048] ath: phy0: TPC[16] 0x0000001a
[   24.865050] ath: phy0: TPC[17] 0x00000018
[   24.865053] ath: phy0: TPC[18] 0x00000000
[   24.865055] ath: phy0: TPC[19] 0x00000000
[   24.865058] ath: phy0: TPC[20] 0x00000000
[   24.865060] ath: phy0: TPC[21] 0x00000000
[   24.865063] ath: phy0: TPC[22] 0x00000000
[   24.865065] ath: phy0: TPC[23] 0x00000000
[   24.865067] ath: phy0: TPC[24] 0x00000000
[   24.865070] ath: phy0: TPC[25] 0x00000000
[   24.865072] ath: phy0: TPC[26] 0x00000000
[   24.865075] ath: phy0: TPC[27] 0x00000000
[   24.865077] ath: phy0: TPC[28] 0x00000000
[   24.865079] ath: phy0: TPC[29] 0x00000000
[   24.865082] ath: phy0: TPC[30] 0x00000000
[   24.865084] ath: phy0: TPC[31] 0x00000000
[   24.865087] ath: phy0: TPC[32] 0x00000000
[   24.865089] ath: phy0: TPC[33] 0x00000000
[   24.865092] ath: phy0: TPC[34] 0x00000000
[   24.865094] ath: phy0: TPC[35] 0x00000000
[   24.865099] ath: phy0: LOOP-Mode ctlMode 0 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.865103] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0x12 pCtlMode 0x01 ctlIndex 0x11 chan 2447
[   24.865108] ath: phy0: SEL-Min ctlMode 0 pCtlMode 1 2xMaxEdge 33 sP 54 minCtlPwr 33
[   24.865111] ath: phy0: LOOP-Mode ctlMode 1 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.865115] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0x12 pCtlMode 0x02 ctlIndex 0x11 chan 2447
[   24.865118] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0x12 pCtlMode 0x02 ctlIndex 0x12 chan 2447
[   24.865122] ath: phy0: SEL-Min ctlMode 1 pCtlMode 2 2xMaxEdge 33 sP 54 minCtlPwr 33
[   24.865125] ath: phy0: LOOP-Mode ctlMode 2 < 3, isHt40CtlMode 0, EXT_ADDITIVE 0
[   24.865128] ath: phy0: LOOP-Ctlidx 0: cfgCtl 0x12 pCtlMode 0x05 ctlIndex 0x11 chan 2447
[   24.865132] ath: phy0: LOOP-Ctlidx 1: cfgCtl 0x12 pCtlMode 0x05 ctlIndex 0x12 chan 2447
[   24.865135] ath: phy0: LOOP-Ctlidx 2: cfgCtl 0x12 pCtlMode 0x05 ctlIndex 0x15 chan 2447
[   24.865139] ath: phy0: SEL-Min ctlMode 2 pCtlMode 5 2xMaxEdge 31 sP 54 minCtlPwr 31
[   24.865142] ath: phy0: TPC[00] 0x00000020
[   24.865145] ath: phy0: TPC[01] 0x0000001e
[   24.865147] ath: phy0: TPC[02] 0x0000001c
[   24.865150] ath: phy0: TPC[03] 0x0000001a
[   24.865152] ath: phy0: TPC[04] 0x00000020
[   24.865155] ath: phy0: TPC[05] 0x00000020
[   24.865157] ath: phy0: TPC[06] 0x00000020
[   24.865159] ath: phy0: TPC[07] 0x00000020
[   24.865162] ath: phy0: TPC[08] 0x00000014
[   24.865164] ath: phy0: TPC[09] 0x00000014
[   24.865167] ath: phy0: TPC[10] 0x00000014
[   24.865169] ath: phy0: TPC[11] 0x00000014
[   24.865172] ath: phy0: TPC[12] 0x00000014
[   24.865174] ath: phy0: TPC[13] 0x00000014
[   24.865176] ath: phy0: TPC[14] 0x00000014
[   24.865179] ath: phy0: TPC[15] 0x00000014
[   24.865181] ath: phy0: TPC[16] 0x00000014
[   24.865184] ath: phy0: TPC[17] 0x00000014
[   24.865186] ath: phy0: TPC[18] 0x00000000
[   24.865189] ath: phy0: TPC[19] 0x00000000
[   24.865191] ath: phy0: TPC[20] 0x00000000
[   24.865194] ath: phy0: TPC[21] 0x00000000
[   24.865196] ath: phy0: TPC[22] 0x00000000
[   24.865199] ath: phy0: TPC[23] 0x00000000
[   24.865201] ath: phy0: TPC[24] 0x00000000
[   24.865203] ath: phy0: TPC[25] 0x00000000
[   24.865206] ath: phy0: TPC[26] 0x00000000
[   24.865208] ath: phy0: TPC[27] 0x00000000
[   24.865211] ath: phy0: TPC[28] 0x00000000
[   24.865213] ath: phy0: TPC[29] 0x00000000
[   24.865216] ath: phy0: TPC[30] 0x00000000
[   24.865218] ath: phy0: TPC[31] 0x00000000
[   24.865220] ath: phy0: TPC[32] 0x00000000
[   24.865223] ath: phy0: TPC[33] 0x00000000
[   24.865225] ath: phy0: TPC[34] 0x00000000
[   24.865228] ath: phy0: TPC[35] 0x00000000
[   24.865236] ath: phy0: ch=0 f=2447 low=2442 -18 h=2472 -16
[   24.865240] ath: phy0: ch=1 f=2447 low=2442 -13 h=2472 -12
[   24.865243] ath: phy0: ch=2 f=2447 low=2442 0 h=2472 0
[   24.865259] ath: phy0: for frequency=2447, calibration correction = -18 -13 0
[   24.933072] ath: phy0: transmitting packet, skb: ffff8ceba80c4200
[   24.933086] ath: phy0: qnum: 1, txq depth: 0
[   24.933092] ath: phy0: TXDP[1] = 28040d00 (ffff8ce3a8040d00)
[   24.938591] ath: phy0: disable IER
[   24.938613] ath: phy0: TX complete: skb: ffff8ceba80c4200
[   24.938633] ath: phy0: enable IER
[   24.938640] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.961069] ath: phy0: disable IER
[   24.961120] ath: phy0: enable IER
[   24.961128] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   24.962212] ath: phy0: disable IER
[   24.962253] ath: phy0: enable IER
[   24.962261] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.063474] ath: phy0: disable IER
[   25.063523] ath: phy0: enable IER
[   25.063531] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.165876] ath: phy0: disable IER
[   25.165926] ath: phy0: enable IER
[   25.165934] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.268275] ath: phy0: disable IER
[   25.268327] ath: phy0: enable IER
[   25.268335] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.370675] ath: phy0: disable IER
[   25.370727] ath: phy0: enable IER
[   25.370735] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.473075] ath: phy0: disable IER
[   25.473126] ath: phy0: enable IER
[   25.473133] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.575476] ath: phy0: disable IER
[   25.575528] ath: phy0: enable IER
[   25.575535] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.594985] ath: phy0: transmitting packet, skb: ffff8ceba7f39f00
[   25.595000] ath: phy0: qnum: 1, txq depth: 0
[   25.595005] ath: phy0: TXDP[1] = 28040d80 (ffff8ce3a8040d80)
[   25.595238] ath: phy0: disable IER
[   25.595260] ath: phy0: TX complete: skb: ffff8ceba7f39f00
[   25.595281] ath: phy0: enable IER
[   25.595289] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.599373] ath: phy0: disable IER
[   25.599429] ath: phy0: enable IER
[   25.599436] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.637022] ath: phy0: listenTime=4400 OFDM:3 errs=98/s CCK:2 errs=32/s ofdm_turn=1
[   25.637027] ath: phy0: **** ofdmlevel 3=>2, rssi=71[lo=7 hi=40]
[   25.637035] ath: phy0: ** ch 2447: level 3=>2[def:3] cycpwrThr1[level]=4 ini=6
[   25.637039] ath: phy0: ** ch 2447: level 3=>2[def:3] cycpwrThr1Ext[level]=6 ini=8
[   25.637044] ath: phy0: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on listenTime=4400 ofdmErrs=433 cckErrs=143
[   25.637070] ath: phy0: 0: Chn 0 pmi=0x0094f3d8;pmq=0x009cbf06;iqcm=0x0001b71b;
[   25.637078] ath: phy0: 0: Chn 1 pmi=0x01dd8757;pmq=0x01d2246a;iqcm=0x000638b3;
[   25.637081] ath: phy0: Starting IQ Cal and Correction for Chain 0
[   25.637084] ath: phy0: Original: Chn 0 iq_corr_meas = 0x0001b71b
[   25.637087] ath: phy0: Chn 0 pwr_meas_i = 0x0094f3d8
[   25.637089] ath: phy0: Chn 0 pwr_meas_q = 0x009cbf06
[   25.637091] ath: phy0: iqCorrNeg is 0x00000000
[   25.637094] ath: phy0: Chn 0 iCoff = 0x00000002
[   25.637097] ath: phy0: Chn 0 qCoff = 0xfffffffc
[   25.637100] ath: phy0: Chn 0 : iCoff = 0x7e  qCoff = 0x7c
[   25.637104] ath: phy0: Register offset (0x98dc) before update = 0x20000000
[   25.637112] ath: phy0: Register offset (0x98dc) QI COFF (bitfields 0x00003f80) after update = 0x20003f7c
[   25.637117] ath: phy0: Register offset (0x98dc) QQ COFF (bitfields 0x0000007f) after update = 0x20003f7c
[   25.637119] ath: phy0: IQ Cal and Correction done for Chain 0
[   25.637122] ath: phy0: Starting IQ Cal and Correction for Chain 1
[   25.637124] ath: phy0: Original: Chn 1 iq_corr_meas = 0x000638b3
[   25.637127] ath: phy0: Chn 1 pwr_meas_i = 0x01dd8757
[   25.637130] ath: phy0: Chn 1 pwr_meas_q = 0x01d2246a
[   25.637132] ath: phy0: iqCorrNeg is 0x00000000
[   25.637134] ath: phy0: Chn 1 iCoff = 0x00000003
[   25.637137] ath: phy0: Chn 1 qCoff = 0x00000001
[   25.637140] ath: phy0: Chn 1 : iCoff = 0x7d  qCoff = 0x1
[   25.637144] ath: phy0: Register offset (0xa8dc) before update = 0x0
[   25.637152] ath: phy0: Register offset (0xa8dc) QI COFF (bitfields 0x00003f80) after update = 0x3e81
[   25.637156] ath: phy0: Register offset (0xa8dc) QQ COFF (bitfields 0x0000007f) after update = 0x3e81
[   25.637158] ath: phy0: IQ Cal and Correction done for Chain 1
[   25.637165] ath: phy0: IQ Cal and Correction (offset 0x98dc) enabled (bit position 0x00004000). New Value 0x20007f7c
[   25.637169] ath: phy0: Calibration @4294898704 finished:  short ani, caldone: true
[   25.669034] ath: phy0: transmitting packet, skb: ffff8cebdb784a00
[   25.669049] ath: phy0: qnum: 1, txq depth: 0
[   25.669054] ath: phy0: TXDP[1] = 28040e00 (ffff8ce3a8040e00)
[   25.670368] ath: phy0: disable IER
[   25.670390] ath: phy0: TX complete: skb: ffff8cebdb784a00
[   25.670411] ath: phy0: enable IER
[   25.670418] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.677844] ath: phy0: disable IER
[   25.677894] ath: phy0: enable IER
[   25.677902] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.780276] ath: phy0: disable IER
[   25.780327] ath: phy0: enable IER
[   25.780334] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.783552] ath: phy0: disable IER
[   25.783598] ath: phy0: enable IER
[   25.783606] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.784786] ath: phy0: disable IER
[   25.784828] ath: phy0: enable IER
[   25.784836] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.882679] ath: phy0: disable IER
[   25.882730] ath: phy0: enable IER
[   25.882737] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.957083] ath: phy0: transmitting packet, skb: ffff8ceba7f3d500
[   25.957098] ath: phy0: qnum: 1, txq depth: 0
[   25.957103] ath: phy0: TXDP[1] = 28040e80 (ffff8ce3a8040e80)
[   25.957120] ath: phy0: transmitting packet, skb: ffff8ceba8bb4a00
[   25.957125] ath: phy0: qnum: 1, txq depth: 1
[   25.957128] ath: phy0: TXDP[1] = 28040f00 (ffff8ce3a8040f00)
[   25.963308] ath: phy0: disable IER
[   25.963330] ath: phy0: TX complete: skb: ffff8ceba7f3d500
[   25.963351] ath: phy0: enable IER
[   25.963358] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.968140] ath: phy0: disable IER
[   25.968162] ath: phy0: TX complete: skb: ffff8ceba8bb4a00
[   25.968173] ath: phy0: enable IER
[   25.968180] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.985073] ath: phy0: disable IER
[   25.985124] ath: phy0: enable IER
[   25.985132] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.986323] ath: phy0: disable IER
[   25.986365] ath: phy0: enable IER
[   25.986373] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   25.987425] ath: phy0: disable IER
[   25.987466] ath: phy0: enable IER
[   25.987474] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.087472] ath: phy0: disable IER
[   26.087524] ath: phy0: enable IER
[   26.087531] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.189846] ath: phy0: disable IER
[   26.189897] ath: phy0: enable IER
[   26.189905] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.205047] ath: phy0: transmitting packet, skb: ffff8ceba8100d00
[   26.205062] ath: phy0: qnum: 1, txq depth: 0
[   26.205067] ath: phy0: TXDP[1] = 28040f80 (ffff8ce3a8040f80)
[   26.205314] ath: phy0: disable IER
[   26.205336] ath: phy0: TX complete: skb: ffff8ceba8100d00
[   26.205357] ath: phy0: enable IER
[   26.205364] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.292279] ath: phy0: disable IER
[   26.292331] ath: phy0: enable IER
[   26.292338] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.394679] ath: phy0: disable IER
[   26.394731] ath: phy0: enable IER
[   26.394738] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.395914] ath: phy0: disable IER
[   26.395956] ath: phy0: enable IER
[   26.395963] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.497081] ath: phy0: disable IER
[   26.497131] ath: phy0: enable IER
[   26.497138] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.599480] ath: phy0: disable IER
[   26.599529] ath: phy0: enable IER
[   26.599537] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.661014] ath: phy0: listenTime=920 OFDM:2 errs=553/s CCK:2 errs=141/s ofdm_turn=0
[   26.661027] ath: phy0: Calibration @4294898960 finished:   ani, caldone: true
[   26.701896] ath: phy0: disable IER
[   26.701950] ath: phy0: enable IER
[   26.701958] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.804281] ath: phy0: disable IER
[   26.804332] ath: phy0: enable IER
[   26.804339] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   26.906682] ath: phy0: disable IER
[   26.906735] ath: phy0: enable IER
[   26.906743] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.009096] ath: phy0: disable IER
[   27.009147] ath: phy0: enable IER
[   27.009155] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.111482] ath: phy0: disable IER
[   27.111534] ath: phy0: enable IER
[   27.111541] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.213882] ath: phy0: disable IER
[   27.213934] ath: phy0: enable IER
[   27.213942] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.316929] ath: phy0: disable IER
[   27.316981] ath: phy0: enable IER
[   27.316988] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.418683] ath: phy0: disable IER
[   27.418736] ath: phy0: enable IER
[   27.418744] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.521080] ath: phy0: disable IER
[   27.521131] ath: phy0: enable IER
[   27.521139] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.623465] ath: phy0: disable IER
[   27.623515] ath: phy0: enable IER
[   27.623522] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.685022] ath: phy0: listenTime=1826 OFDM:2 errs=575/s CCK:2 errs=161/s ofdm_turn=0
[   27.685034] ath: phy0: Calibration @4294899216 finished:   ani, caldone: true
[   27.725853] ath: phy0: disable IER
[   27.725904] ath: phy0: enable IER
[   27.725912] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.828286] ath: phy0: disable IER
[   27.828338] ath: phy0: enable IER
[   27.828345] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   27.930700] ath: phy0: disable IER
[   27.930751] ath: phy0: enable IER
[   27.930759] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.033640] ath: phy0: disable IER
[   28.033695] ath: phy0: enable IER
[   28.033702] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.135467] ath: phy0: disable IER
[   28.135517] ath: phy0: enable IER
[   28.135524] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.237888] ath: phy0: disable IER
[   28.237938] ath: phy0: enable IER
[   28.237945] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.340288] ath: phy0: disable IER
[   28.340339] ath: phy0: enable IER
[   28.340347] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.442688] ath: phy0: disable IER
[   28.442741] ath: phy0: enable IER
[   28.442748] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.545088] ath: phy0: disable IER
[   28.545140] ath: phy0: enable IER
[   28.545147] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.606158] ath: phy0: disable IER
[   28.606230] ath: phy0: enable IER
[   28.606238] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.606491] ath: phy0: transmitting packet, skb: ffff8ceba8b91500
[   28.606504] ath: phy0: qnum: 1, txq depth: 0
[   28.606508] ath: phy0: TXDP[1] = 28041000 (ffff8ce3a8041000)
[   28.607100] ath: phy0: disable IER
[   28.607122] ath: phy0: TX complete: skb: ffff8ceba8b91500
[   28.607143] ath: phy0: enable IER
[   28.607152] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.613935] ath: phy0: disable IER
[   28.614002] ath: phy0: enable IER
[   28.614009] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.647359] ath: phy0: disable IER
[   28.647406] ath: phy0: enable IER
[   28.647414] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.650640] ath: phy0: disable IER
[   28.650677] ath: phy0: enable IER
[   28.650685] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.708937] ath: phy0: listenTime=2750 OFDM:2 errs=582/s CCK:2 errs=143/s ofdm_turn=0
[   28.708949] ath: phy0: Calibration @4294899472 finished:   ani, caldone: true
[   28.749758] ath: phy0: disable IER
[   28.749806] ath: phy0: enable IER
[   28.749814] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.852158] ath: phy0: disable IER
[   28.852203] ath: phy0: enable IER
[   28.852212] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   28.954679] ath: phy0: disable IER
[   28.954704] ath: phy0: enable IER
[   28.954708] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.057091] ath: phy0: disable IER
[   29.057142] ath: phy0: enable IER
[   29.057150] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.159490] ath: phy0: disable IER
[   29.159542] ath: phy0: enable IER
[   29.159549] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.261889] ath: phy0: disable IER
[   29.261941] ath: phy0: enable IER
[   29.261948] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.364276] ath: phy0: disable IER
[   29.364329] ath: phy0: enable IER
[   29.364337] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.466667] ath: phy0: disable IER
[   29.466720] ath: phy0: enable IER
[   29.466728] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.571633] ath: phy0: disable IER
[   29.571683] ath: phy0: enable IER
[   29.571691] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.671496] ath: phy0: disable IER
[   29.671547] ath: phy0: enable IER
[   29.671555] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.733004] ath: phy0: listenTime=3664 OFDM:2 errs=566/s CCK:2 errs=144/s ofdm_turn=0
[   29.733017] ath: phy0: Calibration @4294899728 finished:   ani, caldone: true
[   29.773894] ath: phy0: disable IER
[   29.773961] ath: phy0: enable IER
[   29.773969] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.876295] ath: phy0: disable IER
[   29.876346] ath: phy0: enable IER
[   29.876353] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   29.978559] ath: phy0: disable IER
[   29.978598] ath: phy0: enable IER
[   29.978605] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.080952] ath: phy0: disable IER
[   30.080971] ath: phy0: enable IER
[   30.080988] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.181017] ath: phy0: transmitting packet, skb: ffff8ceba8b99c00
[   30.181045] ath: phy0: qnum: 1, txq depth: 0
[   30.181051] ath: phy0: TXDP[1] = 28041080 (ffff8ce3a8041080)
[   30.183231] ath: phy0: disable IER
[   30.183267] ath: phy0: TX complete: skb: ffff8ceba8b99c00
[   30.183287] ath: phy0: enable IER
[   30.183295] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.285895] ath: phy0: disable IER
[   30.285959] ath: phy0: enable IER
[   30.285967] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.287002] ath: phy0: disable IER
[   30.287059] ath: phy0: enable IER
[   30.287067] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.388296] ath: phy0: disable IER
[   30.388357] ath: phy0: enable IER
[   30.388365] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.490696] ath: phy0: disable IER
[   30.490757] ath: phy0: enable IER
[   30.490765] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.593097] ath: phy0: disable IER
[   30.593158] ath: phy0: enable IER
[   30.593166] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.695497] ath: phy0: disable IER
[   30.695573] ath: phy0: enable IER
[   30.695581] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   30.757002] ath: phy0: listenTime=4588 OFDM:2 errs=613/s CCK:2 errs=149/s ofdm_turn=0
[   30.757028] ath: phy0: Calibration @4294899984 finished:   ani, caldone: true
[   30.797896] ath: phy0: disable IER
[   30.797957] ath: phy0: enable IER
[   30.797965] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   31.104998] ath: phy0: disable IER
[   31.105061] ath: phy0: enable IER
[   31.105069] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   31.106965] ath: phy0: disable IER
[   31.107031] ath: phy0: enable IER
[   31.107039] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   31.311808] ath: phy0: disable IER
[   31.311876] ath: phy0: enable IER
[   31.311883] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   31.514705] ath: phy0: disable IER
[   31.514766] ath: phy0: enable IER
[   31.514774] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   31.721418] ath: phy0: disable IER
[   31.721485] ath: phy0: enable IER
[   31.721493] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   31.780998] ath: phy0: listenTime=5497 OFDM:2 errs=573/s CCK:2 errs=146/s ofdm_turn=0
[   31.781025] ath: phy0: Calibration @4294900240 finished:   ani, caldone: true
[   31.924305] ath: phy0: disable IER
[   31.924366] ath: phy0: enable IER
[   31.924374] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   32.026706] ath: phy0: disable IER
[   32.026766] ath: phy0: enable IER
[   32.026774] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   32.231505] ath: phy0: disable IER
[   32.231567] ath: phy0: enable IER
[   32.231575] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   32.538705] ath: phy0: disable IER
[   32.538782] ath: phy0: enable IER
[   32.538789] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   32.743487] ath: phy0: disable IER
[   32.743547] ath: phy0: enable IER
[   32.743554] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   32.804997] ath: phy0: listenTime=6430 OFDM:2 errs=544/s CCK:2 errs=146/s ofdm_turn=0
[   32.805025] ath: phy0: Calibration @4294900496 finished:   ani, caldone: true
[   32.845876] ath: phy0: disable IER
[   32.845937] ath: phy0: enable IER
[   32.845944] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   32.948327] ath: phy0: disable IER
[   32.948387] ath: phy0: enable IER
[   32.948395] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.153110] ath: phy0: disable IER
[   33.153171] ath: phy0: enable IER
[   33.153179] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.357910] ath: phy0: disable IER
[   33.357975] ath: phy0: enable IER
[   33.357983] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.562710] ath: phy0: disable IER
[   33.562770] ath: phy0: enable IER
[   33.562778] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.614934] ath: phy0: disable IER
[   33.615028] ath: phy0: transmitting packet, skb: ffff8ceba8aaf100
[   33.615039] ath: phy0: qnum: 1, txq depth: 0
[   33.615043] ath: phy0: TXDP[1] = 28041100 (ffff8ce3a8041100)
[   33.615051] ath: phy0: enable IER
[   33.615058] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.618716] ath: phy0: disable IER
[   33.618752] ath: phy0: TX complete: skb: ffff8ceba8aaf100
[   33.618771] ath: phy0: enable IER
[   33.618778] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.767511] ath: phy0: disable IER
[   33.767571] ath: phy0: enable IER
[   33.767579] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   33.828984] ath: phy0: listenTime=7357 OFDM:2 errs=519/s CCK:2 errs=156/s ofdm_turn=0
[   33.829010] ath: phy0: Calibration @4294900752 finished:   ani, caldone: true
[   34.279456] ath: phy0: disable IER
[   34.279519] ath: phy0: enable IER
[   34.279527] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   34.852935] ath: phy0: listenTime=8292 OFDM:2 errs=501/s CCK:2 errs=154/s ofdm_turn=0
[   34.852961] ath: phy0: Calibration @4294901008 finished:   ani, caldone: true
[   35.301653] ath: phy0: disable IER
[   35.301683] ath: phy0: enable IER
[   35.301690] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   35.405917] ath: phy0: disable IER
[   35.405978] ath: phy0: enable IER
[   35.405986] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   35.508318] ath: phy0: disable IER
[   35.508377] ath: phy0: enable IER
[   35.508385] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   35.610718] ath: phy0: disable IER
[   35.610779] ath: phy0: enable IER
[   35.610786] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   35.713304] ath: phy0: disable IER
[   35.713364] ath: phy0: enable IER
[   35.713372] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   35.815501] ath: phy0: disable IER
[   35.815561] ath: phy0: enable IER
[   35.815569] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   35.876984] ath: phy0: listenTime=9210 OFDM:2 errs=472/s CCK:2 errs=152/s ofdm_turn=0
[   35.877012] ath: phy0: Calibration @4294901264 finished:   ani, caldone: true
[   35.917917] ath: phy0: disable IER
[   35.917978] ath: phy0: enable IER
[   35.917986] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.224991] ath: phy0: disable IER
[   36.225053] ath: phy0: enable IER
[   36.225060] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.327501] ath: phy0: disable IER
[   36.327560] ath: phy0: enable IER
[   36.327568] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.429921] ath: phy0: disable IER
[   36.429981] ath: phy0: enable IER
[   36.429989] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.532322] ath: phy0: disable IER
[   36.532386] ath: phy0: enable IER
[   36.532394] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.634722] ath: phy0: disable IER
[   36.634800] ath: phy0: enable IER
[   36.634807] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.737710] ath: phy0: disable IER
[   36.737770] ath: phy0: enable IER
[   36.737778] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.839506] ath: phy0: disable IER
[   36.839566] ath: phy0: enable IER
[   36.839574] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   36.900981] ath: phy0: listenTime=10147 OFDM:2 errs=445/s CCK:2 errs=145/s ofdm_turn=0
[   36.901007] ath: phy0: Calibration @4294901520 finished:   ani, caldone: true
[   36.941924] ath: phy0: disable IER
[   36.941986] ath: phy0: enable IER
[   36.941994] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.146725] ath: phy0: disable IER
[   37.146786] ath: phy0: enable IER
[   37.146794] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.249125] ath: phy0: disable IER
[   37.249186] ath: phy0: enable IER
[   37.249193] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.351506] ath: phy0: disable IER
[   37.351569] ath: phy0: enable IER
[   37.351577] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.556312] ath: phy0: disable IER
[   37.556388] ath: phy0: enable IER
[   37.556396] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.658707] ath: phy0: disable IER
[   37.658767] ath: phy0: enable IER
[   37.658774] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.760997] ath: phy0: disable IER
[   37.761057] ath: phy0: enable IER
[   37.761064] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.863508] ath: phy0: disable IER
[   37.863567] ath: phy0: enable IER
[   37.863575] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   37.924977] ath: phy0: listenTime=11081 OFDM:2 errs=433/s CCK:2 errs=138/s ofdm_turn=0
[   37.925003] ath: phy0: Calibration @4294901776 finished:   ani, caldone: true
[   38.068330] ath: phy0: disable IER
[   38.068392] ath: phy0: enable IER
[   38.068400] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.375511] ath: phy0: disable IER
[   38.375575] ath: phy0: enable IER
[   38.375583] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.580331] ath: phy0: disable IER
[   38.580396] ath: phy0: enable IER
[   38.580404] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.628989] ath: phy0: transmitting packet, skb: ffff8ceba8901100
[   38.629019] ath: phy0: qnum: 1, txq depth: 0
[   38.629024] ath: phy0: TXDP[1] = 28041180 (ffff8ce3a8041180)
[   38.629174] ath: phy0: disable IER
[   38.629208] ath: phy0: TX complete: skb: ffff8ceba8901100
[   38.629230] ath: phy0: enable IER
[   38.629239] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.683852] ath: phy0: disable IER
[   38.683910] ath: phy0: enable IER
[   38.683917] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.785215] ath: phy0: disable IER
[   38.785276] ath: phy0: enable IER
[   38.785284] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.887536] ath: phy0: disable IER
[   38.887595] ath: phy0: enable IER
[   38.887603] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   38.948968] ath: phy0: listenTime=12003 OFDM:2 errs=442/s CCK:2 errs=133/s ofdm_turn=0
[   38.948994] ath: phy0: Calibration @4294902032 finished:   ani, caldone: true
[   38.989930] ath: phy0: disable IER
[   38.989991] ath: phy0: enable IER
[   38.989999] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   39.194713] ath: phy0: disable IER
[   39.194773] ath: phy0: enable IER
[   39.194781] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   39.604335] ath: phy0: disable IER
[   39.604397] ath: phy0: enable IER
[   39.604405] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   39.706735] ath: phy0: disable IER
[   39.706796] ath: phy0: enable IER
[   39.706804] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   39.809152] ath: phy0: disable IER
[   39.809213] ath: phy0: enable IER
[   39.809221] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   39.911536] ath: phy0: disable IER
[   39.911598] ath: phy0: enable IER
[   39.911606] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   39.972972] ath: phy0: listenTime=12899 OFDM:2 errs=448/s CCK:2 errs=136/s ofdm_turn=0
[   39.972998] ath: phy0: Calibration @4294902288 finished:   ani, caldone: true
[   40.218739] ath: phy0: disable IER
[   40.218800] ath: phy0: enable IER
[   40.218808] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   40.321137] ath: phy0: disable IER
[   40.321198] ath: phy0: enable IER
[   40.321206] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   40.423539] ath: phy0: disable IER
[   40.423600] ath: phy0: enable IER
[   40.423608] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   40.628325] ath: phy0: disable IER
[   40.628393] ath: phy0: enable IER
[   40.628400] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   40.996941] ath: phy0: listenTime=13830 OFDM:2 errs=444/s CCK:2 errs=135/s ofdm_turn=0
[   40.996954] ath: phy0: Calibration @4294902544 finished:   ani, caldone: true
[   41.140341] ath: phy0: disable IER
[   41.140403] ath: phy0: enable IER
[   41.140410] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.142230] ath: phy0: disable IER
[   41.142296] ath: phy0: enable IER
[   41.142304] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.242742] ath: phy0: disable IER
[   41.242803] ath: phy0: enable IER
[   41.242811] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.345143] ath: phy0: disable IER
[   41.345204] ath: phy0: enable IER
[   41.345212] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.347005] ath: phy0: disable IER
[   41.347057] ath: phy0: enable IER
[   41.347065] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.447543] ath: phy0: disable IER
[   41.447604] ath: phy0: enable IER
[   41.447612] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.549943] ath: phy0: disable IER
[   41.550005] ath: phy0: enable IER
[   41.550013] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.754729] ath: phy0: disable IER
[   41.754790] ath: phy0: enable IER
[   41.754798] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.756592] ath: phy0: disable IER
[   41.756657] ath: phy0: enable IER
[   41.756665] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   41.857148] ath: phy0: disable IER
[   41.857209] ath: phy0: enable IER
[   41.857217] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   42.020962] ath: phy0: listenTime=14763 OFDM:2 errs=439/s CCK:2 errs=132/s ofdm_turn=0
[   42.020988] ath: phy0: Calibration @4294902800 finished:   ani, caldone: true
[   42.266744] ath: phy0: disable IER
[   42.266806] ath: phy0: enable IER
[   42.266814] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   42.369144] ath: phy0: disable IER
[   42.369206] ath: phy0: enable IER
[   42.369213] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   42.471528] ath: phy0: disable IER
[   42.471593] ath: phy0: enable IER
[   42.471601] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   42.576457] ath: phy0: disable IER
[   42.576517] ath: phy0: enable IER
[   42.576525] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.044950] ath: phy0: listenTime=15665 OFDM:2 errs=430/s CCK:2 errs=136/s ofdm_turn=0
[   43.044977] ath: phy0: Calibration @4294903056 finished:   ani, caldone: true
[   43.085953] ath: phy0: disable IER
[   43.086017] ath: phy0: enable IER
[   43.086024] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.190138] ath: phy0: disable IER
[   43.190205] ath: phy0: enable IER
[   43.190213] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.290753] ath: phy0: disable IER
[   43.290814] ath: phy0: enable IER
[   43.290822] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.393153] ath: phy0: disable IER
[   43.393214] ath: phy0: enable IER
[   43.393222] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.700363] ath: phy0: disable IER
[   43.700424] ath: phy0: enable IER
[   43.700432] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.802753] ath: phy0: disable IER
[   43.802814] ath: phy0: enable IER
[   43.802822] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   43.905153] ath: phy0: disable IER
[   43.905214] ath: phy0: enable IER
[   43.905222] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.007535] ath: phy0: disable IER
[   44.007595] ath: phy0: enable IER
[   44.007602] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.068954] ath: phy0: listenTime=16566 OFDM:2 errs=420/s CCK:2 errs=136/s ofdm_turn=0
[   44.068980] ath: phy0: Calibration @4294903312 finished:   ani, caldone: true
[   44.109971] ath: phy0: disable IER
[   44.110035] ath: phy0: enable IER
[   44.110043] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.212355] ath: phy0: disable IER
[   44.212416] ath: phy0: enable IER
[   44.212424] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.314755] ath: phy0: disable IER
[   44.314817] ath: phy0: enable IER
[   44.314825] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.418365] ath: phy0: disable IER
[   44.418437] ath: phy0: enable IER
[   44.418444] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.519555] ath: phy0: disable IER
[   44.519615] ath: phy0: enable IER
[   44.519623] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.621956] ath: phy0: disable IER
[   44.622017] ath: phy0: enable IER
[   44.622024] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.724356] ath: phy0: disable IER
[   44.724418] ath: phy0: enable IER
[   44.724425] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.826772] ath: phy0: disable IER
[   44.826833] ath: phy0: enable IER
[   44.826841] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   44.929157] ath: phy0: disable IER
[   44.929217] ath: phy0: enable IER
[   44.929225] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.031559] ath: phy0: disable IER
[   45.031619] ath: phy0: enable IER
[   45.031627] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.092954] ath: phy0: listenTime=17465 OFDM:2 errs=413/s CCK:2 errs=135/s ofdm_turn=0
[   45.092980] ath: phy0: Calibration @4294903568 finished:   ani, caldone: true
[   45.133959] ath: phy0: disable IER
[   45.134023] ath: phy0: enable IER
[   45.134031] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.236359] ath: phy0: disable IER
[   45.236420] ath: phy0: enable IER
[   45.236428] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.338759] ath: phy0: disable IER
[   45.338820] ath: phy0: enable IER
[   45.338829] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.441160] ath: phy0: disable IER
[   45.441221] ath: phy0: enable IER
[   45.441229] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.543560] ath: phy0: disable IER
[   45.543621] ath: phy0: enable IER
[   45.543628] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.645958] ath: phy0: disable IER
[   45.646019] ath: phy0: enable IER
[   45.646027] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.748349] ath: phy0: disable IER
[   45.748428] ath: phy0: enable IER
[   45.748435] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   45.850737] ath: phy0: disable IER
[   45.850797] ath: phy0: enable IER
[   45.850805] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   46.055544] ath: phy0: disable IER
[   46.055604] ath: phy0: enable IER
[   46.055612] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   46.116945] ath: phy0: listenTime=18389 OFDM:2 errs=409/s CCK:2 errs=134/s ofdm_turn=0
[   46.116971] ath: phy0: Calibration @4294903824 finished:   ani, caldone: true
[   46.260375] ath: phy0: disable IER
[   46.260436] ath: phy0: enable IER
[   46.260444] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   46.567565] ath: phy0: disable IER
[   46.567625] ath: phy0: enable IER
[   46.567633] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   46.669983] ath: phy0: disable IER
[   46.670043] ath: phy0: enable IER
[   46.670050] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   47.140944] ath: phy0: listenTime=19325 OFDM:2 errs=403/s CCK:2 errs=131/s ofdm_turn=0
[   47.140970] ath: phy0: Calibration @4294904080 finished:   ani, caldone: true
[   47.181965] ath: phy0: disable IER
[   47.182026] ath: phy0: enable IER
[   47.182034] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   47.284353] ath: phy0: disable IER
[   47.284416] ath: phy0: enable IER
[   47.284424] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   47.489152] ath: phy0: disable IER
[   47.489211] ath: phy0: enable IER
[   47.489219] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   47.796370] ath: phy0: disable IER
[   47.796432] ath: phy0: enable IER
[   47.796440] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   47.898770] ath: phy0: disable IER
[   47.898831] ath: phy0: enable IER
[   47.898839] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   48.001171] ath: phy0: disable IER
[   48.001232] ath: phy0: enable IER
[   48.001240] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   48.164940] ath: phy0: listenTime=20261 OFDM:2 errs=399/s CCK:2 errs=129/s ofdm_turn=0
[   48.164958] ath: phy0: **** ccklevel 2=>1, rssi=69[lo=7 hi=40]
[   48.164978] ath: phy0: Calibration @4294904336 finished:   ani, caldone: true
[   48.205971] ath: phy0: disable IER
[   48.206032] ath: phy0: enable IER
[   48.206040] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   48.410773] ath: phy0: disable IER
[   48.410841] ath: phy0: enable IER
[   48.410849] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   48.717944] ath: phy0: disable IER
[   48.718004] ath: phy0: enable IER
[   48.718011] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   48.820373] ath: phy0: disable IER
[   48.820434] ath: phy0: enable IER
[   48.820442] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   48.922750] ath: phy0: disable IER
[   48.922810] ath: phy0: enable IER
[   48.922818] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   49.025173] ath: phy0: disable IER
[   49.025234] ath: phy0: enable IER
[   49.025241] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   49.188936] ath: phy0: listenTime=940 OFDM:2 errs=512/s CCK:1 errs=92/s ofdm_turn=1
[   49.188962] ath: phy0: Calibration @4294904592 finished:   ani, caldone: true
[   49.229949] ath: phy0: disable IER
[   49.230010] ath: phy0: enable IER
[   49.230017] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   49.434776] ath: phy0: disable IER
[   49.434851] ath: phy0: enable IER
[   49.434859] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   49.537171] ath: phy0: disable IER
[   49.537232] ath: phy0: enable IER
[   49.537240] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   49.639578] ath: phy0: disable IER
[   49.639639] ath: phy0: enable IER
[   49.639646] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   49.946777] ath: phy0: disable IER
[   49.946838] ath: phy0: enable IER
[   49.946846] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   50.049179] ath: phy0: disable IER
[   50.049240] ath: phy0: enable IER
[   50.049248] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   50.212932] ath: phy0: listenTime=1828 OFDM:2 errs=585/s CCK:1 errs=150/s ofdm_turn=1
[   50.212958] ath: phy0: Calibration @4294904848 finished:   ani, caldone: true
[   50.356380] ath: phy0: disable IER
[   50.356458] ath: phy0: enable IER
[   50.356466] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   50.765968] ath: phy0: disable IER
[   50.766027] ath: phy0: enable IER
[   50.766035] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   50.868368] ath: phy0: disable IER
[   50.868432] ath: phy0: enable IER
[   50.868440] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.073184] ath: phy0: disable IER
[   51.073244] ath: phy0: enable IER
[   51.073252] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.175458] ath: phy0: disable IER
[   51.175481] ath: phy0: enable IER
[   51.175485] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.177347] ath: phy0: disable IER
[   51.177364] ath: phy0: enable IER
[   51.177368] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.236803] ath: phy0: listenTime=2742 OFDM:2 errs=587/s CCK:1 errs=141/s ofdm_turn=1
[   51.236809] ath: phy0: Calibration @4294905104 finished:   ani, caldone: true
[   51.277839] ath: phy0: disable IER
[   51.277852] ath: phy0: enable IER
[   51.277856] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.382271] ath: phy0: disable IER
[   51.382285] ath: phy0: enable IER
[   51.382289] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.482640] ath: phy0: disable IER
[   51.482655] ath: phy0: enable IER
[   51.482659] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.585041] ath: phy0: disable IER
[   51.585053] ath: phy0: enable IER
[   51.585057] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.586921] ath: phy0: disable IER
[   51.586934] ath: phy0: enable IER
[   51.586938] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.687441] ath: phy0: disable IER
[   51.687453] ath: phy0: enable IER
[   51.687457] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.892241] ath: phy0: disable IER
[   51.892254] ath: phy0: enable IER
[   51.892258] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   51.994643] ath: phy0: disable IER
[   51.994655] ath: phy0: enable IER
[   51.994659] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   52.199443] ath: phy0: disable IER
[   52.199456] ath: phy0: enable IER
[   52.199460] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   52.260799] ath: phy0: listenTime=3627 OFDM:2 errs=540/s CCK:1 errs=171/s ofdm_turn=1
[   52.260805] ath: phy0: Calibration @4294905360 finished:   ani, caldone: true
[   52.404244] ath: phy0: disable IER
[   52.404256] ath: phy0: enable IER
[   52.404260] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   52.609155] ath: phy0: disable IER
[   52.609189] ath: phy0: enable IER
[   52.609196] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   52.813988] ath: phy0: disable IER
[   52.814046] ath: phy0: enable IER
[   52.814053] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   52.916389] ath: phy0: disable IER
[   52.916446] ath: phy0: enable IER
[   52.916453] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.018817] ath: phy0: disable IER
[   53.018873] ath: phy0: enable IER
[   53.018880] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.121155] ath: phy0: disable IER
[   53.121213] ath: phy0: enable IER
[   53.121220] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.223593] ath: phy0: disable IER
[   53.223651] ath: phy0: enable IER
[   53.223658] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.284918] ath: phy0: listenTime=4562 OFDM:2 errs=530/s CCK:1 errs=155/s ofdm_turn=1
[   53.284943] ath: phy0: Calibration @4294905616 finished:   ani, caldone: true
[   53.325994] ath: phy0: disable IER
[   53.326051] ath: phy0: enable IER
[   53.326058] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.428394] ath: phy0: disable IER
[   53.428450] ath: phy0: enable IER
[   53.428458] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.530794] ath: phy0: disable IER
[   53.530851] ath: phy0: enable IER
[   53.530858] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.633193] ath: phy0: disable IER
[   53.633253] ath: phy0: enable IER
[   53.633260] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.735578] ath: phy0: disable IER
[   53.735639] ath: phy0: enable IER
[   53.735647] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.837994] ath: phy0: disable IER
[   53.838059] ath: phy0: enable IER
[   53.838066] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   53.940380] ath: phy0: disable IER
[   53.940441] ath: phy0: enable IER
[   53.940449] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.042770] ath: phy0: disable IER
[   54.042828] ath: phy0: enable IER
[   54.042835] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.145151] ath: phy0: disable IER
[   54.145209] ath: phy0: enable IER
[   54.145217] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.247596] ath: phy0: disable IER
[   54.247658] ath: phy0: enable IER
[   54.247665] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.308913] ath: phy0: listenTime=5497 OFDM:2 errs=492/s CCK:1 errs=146/s ofdm_turn=1
[   54.308937] ath: phy0: Calibration @4294905872 finished:   ani, caldone: true
[   54.349996] ath: phy0: disable IER
[   54.350053] ath: phy0: enable IER
[   54.350061] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.452397] ath: phy0: disable IER
[   54.452473] ath: phy0: enable IER
[   54.452481] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.554797] ath: phy0: disable IER
[   54.554854] ath: phy0: enable IER
[   54.554861] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.759599] ath: phy0: disable IER
[   54.759661] ath: phy0: enable IER
[   54.759669] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.862000] ath: phy0: disable IER
[   54.862060] ath: phy0: enable IER
[   54.862068] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   54.964400] ath: phy0: disable IER
[   54.964460] ath: phy0: enable IER
[   54.964468] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.066800] ath: phy0: disable IER
[   55.066861] ath: phy0: enable IER
[   55.066869] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.169200] ath: phy0: disable IER
[   55.169261] ath: phy0: enable IER
[   55.169269] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.332920] ath: phy0: listenTime=6422 OFDM:2 errs=479/s CCK:1 errs=148/s ofdm_turn=1
[   55.332950] ath: phy0: NF calibrated [ctl] [chain 0] is -114
[   55.332953] ath: phy0: NF calibrated [ctl] [chain 1] is -111
[   55.332978] ath: phy0: Calibration @4294906128 finished: long  ani, caldone: true
[   55.374000] ath: phy0: disable IER
[   55.374083] ath: phy0: enable IER
[   55.374091] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.476401] ath: phy0: disable IER
[   55.476461] ath: phy0: enable IER
[   55.476469] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.578801] ath: phy0: disable IER
[   55.578862] ath: phy0: enable IER
[   55.578870] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.681198] ath: phy0: disable IER
[   55.681259] ath: phy0: enable IER
[   55.681266] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.783583] ath: phy0: disable IER
[   55.783647] ath: phy0: enable IER
[   55.783654] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.885975] ath: phy0: disable IER
[   55.886034] ath: phy0: enable IER
[   55.886042] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   55.988404] ath: phy0: disable IER
[   55.988464] ath: phy0: enable IER
[   55.988472] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.193205] ath: phy0: disable IER
[   56.193265] ath: phy0: enable IER
[   56.193273] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.292926] ath: phy0: transmitting packet, skb: ffff8cebce3cc600
[   56.292957] ath: phy0: qnum: 1, txq depth: 0
[   56.292962] ath: phy0: TXDP[1] = 28041200 (ffff8ce3a8041200)
[   56.293111] ath: phy0: disable IER
[   56.293140] ath: phy0: TX complete: skb: ffff8cebce3cc600
[   56.293158] ath: phy0: enable IER
[   56.293166] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.295585] ath: phy0: disable IER
[   56.295644] ath: phy0: enable IER
[   56.295652] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.356910] ath: phy0: listenTime=7356 OFDM:2 errs=457/s CCK:1 errs=147/s ofdm_turn=1
[   56.356937] ath: phy0: Calibration @4294906384 finished:   ani, caldone: true
[   56.398006] ath: phy0: disable IER
[   56.398067] ath: phy0: enable IER
[   56.398075] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.500406] ath: phy0: disable IER
[   56.500467] ath: phy0: enable IER
[   56.500475] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.501487] ath: phy0: disable IER
[   56.501543] ath: phy0: enable IER
[   56.501551] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.602806] ath: phy0: disable IER
[   56.602866] ath: phy0: enable IER
[   56.602874] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.705213] ath: phy0: disable IER
[   56.705278] ath: phy0: enable IER
[   56.705285] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.807606] ath: phy0: disable IER
[   56.807669] ath: phy0: enable IER
[   56.807676] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   56.910007] ath: phy0: disable IER
[   56.910068] ath: phy0: enable IER
[   56.910076] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   57.012408] ath: phy0: disable IER
[   57.012468] ath: phy0: enable IER
[   57.012475] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   57.114808] ath: phy0: disable IER
[   57.114869] ath: phy0: enable IER
[   57.114876] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   57.217206] ath: phy0: disable IER
[   57.217277] ath: phy0: enable IER
[   57.217285] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   57.380908] ath: phy0: listenTime=8293 OFDM:2 errs=436/s CCK:1 errs=144/s ofdm_turn=1
[   57.380934] ath: phy0: Calibration @4294906640 finished:   ani, caldone: true
[   57.729211] ath: phy0: disable IER
[   57.729273] ath: phy0: enable IER
[   57.729280] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   57.831592] ath: phy0: disable IER
[   57.831655] ath: phy0: enable IER
[   57.831663] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   58.036412] ath: phy0: disable IER
[   58.036474] ath: phy0: enable IER
[   58.036482] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   58.138813] ath: phy0: disable IER
[   58.138873] ath: phy0: enable IER
[   58.138881] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   58.241201] ath: phy0: disable IER
[   58.241262] ath: phy0: enable IER
[   58.241270] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   58.343595] ath: phy0: disable IER
[   58.343656] ath: phy0: enable IER
[   58.343663] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   58.404906] ath: phy0: listenTime=9218 OFDM:2 errs=423/s CCK:1 errs=144/s ofdm_turn=1
[   58.404933] ath: phy0: Calibration @4294906896 finished:   ani, caldone: true
[   58.445993] ath: phy0: disable IER
[   58.446027] ath: phy0: enable IER
[   58.446032] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   58.958015] ath: phy0: disable IER
[   58.958083] ath: phy0: enable IER
[   58.958091] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.162794] ath: phy0: disable IER
[   59.162854] ath: phy0: enable IER
[   59.162861] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.367600] ath: phy0: disable IER
[   59.367660] ath: phy0: enable IER
[   59.367667] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.428901] ath: phy0: listenTime=10161 OFDM:2 errs=415/s CCK:1 errs=138/s ofdm_turn=1
[   59.428926] ath: phy0: Calibration @4294907152 finished:   ani, caldone: true
[   59.470033] ath: phy0: disable IER
[   59.470096] ath: phy0: enable IER
[   59.470104] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.572419] ath: phy0: disable IER
[   59.572481] ath: phy0: enable IER
[   59.572488] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.674820] ath: phy0: disable IER
[   59.674880] ath: phy0: enable IER
[   59.674888] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.778192] ath: phy0: disable IER
[   59.778269] ath: phy0: enable IER
[   59.778276] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.879601] ath: phy0: disable IER
[   59.879661] ath: phy0: enable IER
[   59.879668] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   59.982021] ath: phy0: disable IER
[   59.982083] ath: phy0: enable IER
[   59.982091] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.084421] ath: phy0: disable IER
[   60.084482] ath: phy0: enable IER
[   60.084490] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.186821] ath: phy0: disable IER
[   60.186883] ath: phy0: enable IER
[   60.186891] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.289222] ath: phy0: disable IER
[   60.289282] ath: phy0: enable IER
[   60.289290] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.391622] ath: phy0: disable IER
[   60.391697] ath: phy0: enable IER
[   60.391704] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.452897] ath: phy0: listenTime=11038 OFDM:2 errs=415/s CCK:1 errs=144/s ofdm_turn=1
[   60.452923] ath: phy0: Calibration @4294907408 finished:   ani, caldone: true
[   60.494020] ath: phy0: disable IER
[   60.494087] ath: phy0: enable IER
[   60.494095] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.596430] ath: phy0: disable IER
[   60.596490] ath: phy0: enable IER
[   60.596498] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.801199] ath: phy0: disable IER
[   60.801259] ath: phy0: enable IER
[   60.801267] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   60.903625] ath: phy0: disable IER
[   60.903686] ath: phy0: enable IER
[   60.903694] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.006025] ath: phy0: disable IER
[   61.006089] ath: phy0: enable IER
[   61.006097] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.007879] ath: phy0: disable IER
[   61.007946] ath: phy0: enable IER
[   61.007953] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.108425] ath: phy0: disable IER
[   61.108487] ath: phy0: enable IER
[   61.108495] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.210826] ath: phy0: disable IER
[   61.210887] ath: phy0: enable IER
[   61.210895] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.313261] ath: phy0: disable IER
[   61.313322] ath: phy0: enable IER
[   61.313329] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.415627] ath: phy0: disable IER
[   61.415688] ath: phy0: enable IER
[   61.415696] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.417484] ath: phy0: disable IER
[   61.417550] ath: phy0: enable IER
[   61.417558] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.476895] ath: phy0: listenTime=11964 OFDM:2 errs=408/s CCK:1 errs=136/s ofdm_turn=1
[   61.476922] ath: phy0: Calibration @4294907664 finished:   ani, caldone: true
[   61.518028] ath: phy0: disable IER
[   61.518089] ath: phy0: enable IER
[   61.518097] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.620427] ath: phy0: disable IER
[   61.620487] ath: phy0: enable IER
[   61.620495] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.622278] ath: phy0: disable IER
[   61.622348] ath: phy0: enable IER
[   61.622356] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.722828] ath: phy0: disable IER
[   61.722889] ath: phy0: enable IER
[   61.722897] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.825228] ath: phy0: disable IER
[   61.825290] ath: phy0: enable IER
[   61.825297] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   61.927631] ath: phy0: disable IER
[   61.927692] ath: phy0: enable IER
[   61.927700] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.030029] ath: phy0: disable IER
[   62.030090] ath: phy0: enable IER
[   62.030098] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.234829] ath: phy0: disable IER
[   62.234907] ath: phy0: enable IER
[   62.234915] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.337226] ath: phy0: disable IER
[   62.337287] ath: phy0: enable IER
[   62.337295] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.439613] ath: phy0: disable IER
[   62.439674] ath: phy0: enable IER
[   62.439682] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.500891] ath: phy0: listenTime=12898 OFDM:2 errs=399/s CCK:1 errs=136/s ofdm_turn=1
[   62.500908] ath: phy0: **** ofdmlevel 2=>1, rssi=70[lo=7 hi=40]
[   62.500917] ath: phy0: ** ch 2447: level 2=>1[def:3] cycpwrThr1[level]=2 ini=6
[   62.500920] ath: phy0: ** ch 2447: level 2=>1[def:3] cycpwrThr1Ext[level]=4 ini=8
[   62.500925] ath: phy0: ANI parameters: SI=1, ofdmWS=on FS=2 MRCcck=on listenTime=12898 ofdmErrs=5149 cckErrs=1762
[   62.500933] ath: phy0: ** ch 2447: level 2=>1[def:2] firstep[level]=4 ini=6
[   62.500936] ath: phy0: ** ch 2447: level 2=>1[def:2] firstep_low[level]=4 ini=6
[   62.500940] ath: phy0: ANI parameters: SI=1, ofdmWS=on FS=1 MRCcck=on listenTime=12898 ofdmErrs=5149 cckErrs=1762
[   62.500960] ath: phy0: Calibration @4294907920 finished:   ani, caldone: true
[   62.542002] ath: phy0: disable IER
[   62.542063] ath: phy0: enable IER
[   62.542070] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.644432] ath: phy0: disable IER
[   62.644494] ath: phy0: enable IER
[   62.644502] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.746832] ath: phy0: disable IER
[   62.746892] ath: phy0: enable IER
[   62.746900] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.849232] ath: phy0: disable IER
[   62.849294] ath: phy0: enable IER
[   62.849301] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   62.951633] ath: phy0: disable IER
[   62.951695] ath: phy0: enable IER
[   62.951702] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.054033] ath: phy0: disable IER
[   63.054101] ath: phy0: enable IER
[   63.054109] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.156433] ath: phy0: disable IER
[   63.156494] ath: phy0: enable IER
[   63.156503] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.258834] ath: phy0: disable IER
[   63.258895] ath: phy0: enable IER
[   63.258903] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.260569] ath: phy0: disable IER
[   63.260636] ath: phy0: enable IER
[   63.260644] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.361235] ath: phy0: disable IER
[   63.361297] ath: phy0: enable IER
[   63.361304] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.463635] ath: phy0: disable IER
[   63.463696] ath: phy0: enable IER
[   63.463703] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.524891] ath: phy0: listenTime=905 OFDM:1 errs=570/s CCK:1 errs=128/s ofdm_turn=0
[   63.524917] ath: phy0: Calibration @4294908176 finished:   ani, caldone: true
[   63.566043] ath: phy0: disable IER
[   63.566105] ath: phy0: enable IER
[   63.566112] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.668436] ath: phy0: disable IER
[   63.668497] ath: phy0: enable IER
[   63.668504] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.770836] ath: phy0: disable IER
[   63.770897] ath: phy0: enable IER
[   63.770904] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.873252] ath: phy0: disable IER
[   63.873313] ath: phy0: enable IER
[   63.873320] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   63.975570] ath: phy0: disable IER
[   63.975638] ath: phy0: enable IER
[   63.975647] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.078009] ath: phy0: disable IER
[   64.078074] ath: phy0: enable IER
[   64.078082] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.180438] ath: phy0: disable IER
[   64.180500] ath: phy0: enable IER
[   64.180507] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.282839] ath: phy0: disable IER
[   64.282900] ath: phy0: enable IER
[   64.282908] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.385239] ath: phy0: disable IER
[   64.385304] ath: phy0: enable IER
[   64.385312] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.484909] ath: phy0: transmitting packet, skb: ffff8ceba8530e00
[   64.484921] ath: phy0: qnum: 3, txq depth: 0
[   64.484926] ath: phy0: TXDP[3] = 28041280 (ffff8ce3a8041280)
[   64.485795] ath: phy0: disable IER
[   64.485815] ath: phy0: TX complete: skb: ffff8ceba8530e00
[   64.485850] ath: phy0: enable IER
[   64.485857] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.488061] ath: phy0: disable IER
[   64.488110] ath: phy0: enable IER
[   64.488118] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.548874] ath: phy0: listenTime=1801 OFDM:1 errs=661/s CCK:1 errs=200/s ofdm_turn=0
[   64.548900] ath: phy0: Calibration @4294908432 finished:   ani, caldone: true
[   64.590040] ath: phy0: disable IER
[   64.590103] ath: phy0: enable IER
[   64.590111] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.692440] ath: phy0: disable IER
[   64.692501] ath: phy0: enable IER
[   64.692508] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.794841] ath: phy0: disable IER
[   64.794901] ath: phy0: enable IER
[   64.794909] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.897242] ath: phy0: disable IER
[   64.897303] ath: phy0: enable IER
[   64.897311] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   64.999623] ath: phy0: disable IER
[   64.999685] ath: phy0: enable IER
[   64.999693] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.102043] ath: phy0: disable IER
[   65.102105] ath: phy0: enable IER
[   65.102113] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.204442] ath: phy0: disable IER
[   65.204503] ath: phy0: enable IER
[   65.204510] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.306843] ath: phy0: disable IER
[   65.306904] ath: phy0: enable IER
[   65.306912] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.409244] ath: phy0: disable IER
[   65.409310] ath: phy0: enable IER
[   65.409317] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.511643] ath: phy0: disable IER
[   65.511704] ath: phy0: enable IER
[   65.511712] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.572879] ath: phy0: listenTime=2732 OFDM:1 errs=652/s CCK:1 errs=178/s ofdm_turn=0
[   65.572905] ath: phy0: Calibration @4294908688 finished:   ani, caldone: true
[   65.614043] ath: phy0: disable IER
[   65.614105] ath: phy0: enable IER
[   65.614113] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.716416] ath: phy0: disable IER
[   65.716480] ath: phy0: enable IER
[   65.716488] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.818821] ath: phy0: disable IER
[   65.818883] ath: phy0: enable IER
[   65.818891] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   65.921206] ath: phy0: disable IER
[   65.921266] ath: phy0: enable IER
[   65.921273] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.023632] ath: phy0: disable IER
[   66.023692] ath: phy0: enable IER
[   66.023700] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.126047] ath: phy0: disable IER
[   66.126126] ath: phy0: enable IER
[   66.126134] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.228447] ath: phy0: disable IER
[   66.228507] ath: phy0: enable IER
[   66.228515] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.330855] ath: phy0: disable IER
[   66.330923] ath: phy0: enable IER
[   66.330931] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.433249] ath: phy0: disable IER
[   66.433310] ath: phy0: enable IER
[   66.433318] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.535648] ath: phy0: disable IER
[   66.535709] ath: phy0: enable IER
[   66.535717] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.596875] ath: phy0: listenTime=3665 OFDM:1 errs=650/s CCK:1 errs=171/s ofdm_turn=0
[   66.596901] ath: phy0: Calibration @4294908944 finished:   ani, caldone: true
[   66.638049] ath: phy0: disable IER
[   66.638111] ath: phy0: enable IER
[   66.638118] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.740449] ath: phy0: disable IER
[   66.740508] ath: phy0: enable IER
[   66.740516] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.842849] ath: phy0: disable IER
[   66.842910] ath: phy0: enable IER
[   66.842918] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   66.945249] ath: phy0: disable IER
[   66.945310] ath: phy0: enable IER
[   66.945318] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.047649] ath: phy0: disable IER
[   67.047715] ath: phy0: enable IER
[   67.047723] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.150048] ath: phy0: disable IER
[   67.150110] ath: phy0: enable IER
[   67.150118] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.252436] ath: phy0: disable IER
[   67.252512] ath: phy0: enable IER
[   67.252520] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.354829] ath: phy0: disable IER
[   67.354889] ath: phy0: enable IER
[   67.354897] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.457213] ath: phy0: disable IER
[   67.457274] ath: phy0: enable IER
[   67.457281] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.559653] ath: phy0: disable IER
[   67.559714] ath: phy0: enable IER
[   67.559722] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.620870] ath: phy0: listenTime=4580 OFDM:1 errs=652/s CCK:1 errs=167/s ofdm_turn=0
[   67.620897] ath: phy0: Calibration @4294909200 finished:   ani, caldone: true
[   67.662053] ath: phy0: disable IER
[   67.662115] ath: phy0: enable IER
[   67.662123] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.764453] ath: phy0: disable IER
[   67.764515] ath: phy0: enable IER
[   67.764523] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.866854] ath: phy0: disable IER
[   67.866914] ath: phy0: enable IER
[   67.866922] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   67.969254] ath: phy0: disable IER
[   67.969314] ath: phy0: enable IER
[   67.969322] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.071654] ath: phy0: disable IER
[   68.071715] ath: phy0: enable IER
[   68.071723] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.174055] ath: phy0: disable IER
[   68.174133] ath: phy0: enable IER
[   68.174140] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.276455] ath: phy0: disable IER
[   68.276517] ath: phy0: enable IER
[   68.276524] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.378855] ath: phy0: disable IER
[   68.378919] ath: phy0: enable IER
[   68.378927] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.481259] ath: phy0: disable IER
[   68.481319] ath: phy0: enable IER
[   68.481327] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.583656] ath: phy0: disable IER
[   68.583717] ath: phy0: enable IER
[   68.583725] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.644868] ath: phy0: listenTime=5514 OFDM:1 errs=644/s CCK:1 errs=159/s ofdm_turn=0
[   68.644894] ath: phy0: Calibration @4294909456 finished:   ani, caldone: true
[   68.686056] ath: phy0: disable IER
[   68.686120] ath: phy0: enable IER
[   68.686127] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.788633] ath: phy0: disable IER
[   68.788694] ath: phy0: enable IER
[   68.788702] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.893009] ath: phy0: disable IER
[   68.893069] ath: phy0: enable IER
[   68.893077] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   68.993254] ath: phy0: disable IER
[   68.993315] ath: phy0: enable IER
[   68.993323] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.095624] ath: phy0: disable IER
[   69.095684] ath: phy0: enable IER
[   69.095692] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.198031] ath: phy0: disable IER
[   69.198094] ath: phy0: enable IER
[   69.198103] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.300459] ath: phy0: disable IER
[   69.300521] ath: phy0: enable IER
[   69.300530] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.402861] ath: phy0: disable IER
[   69.402923] ath: phy0: enable IER
[   69.402931] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.668856] ath: phy0: listenTime=6426 OFDM:1 errs=644/s CCK:1 errs=159/s ofdm_turn=0
[   69.668881] ath: phy0: Calibration @4294909712 finished:   ani, caldone: true
[   69.710061] ath: phy0: disable IER
[   69.710125] ath: phy0: enable IER
[   69.710132] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.812461] ath: phy0: disable IER
[   69.812522] ath: phy0: enable IER
[   69.812530] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   69.914862] ath: phy0: disable IER
[   69.914926] ath: phy0: enable IER
[   69.914934] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   70.692860] ath: phy0: listenTime=7268 OFDM:1 errs=616/s CCK:1 errs=171/s ofdm_turn=0
[   70.692885] ath: phy0: Calibration @4294909968 finished:   ani, caldone: true
[   70.820908] ath: phy0: transmitting packet, skb: ffff8ceba8d2bf00
[   70.820921] ath: phy0: qnum: 3, txq depth: 0
[   70.820926] ath: phy0: TXDP[3] = 28041300 (ffff8ce3a8041300)
[   70.823462] ath: phy0: disable IER
[   70.823497] ath: phy0: TX complete: skb: ffff8ceba8d2bf00
[   70.823528] ath: phy0: enable IER
[   70.823535] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   70.836451] ath: phy0: disable IER
[   70.836502] ath: phy0: enable IER
[   70.836509] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   70.837412] ath: phy0: disable IER
[   70.837463] ath: phy0: enable IER
[   70.837470] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   70.839103] ath: phy0: disable IER
[   70.839155] ath: phy0: enable IER
[   70.839163] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   70.840760] ath: phy0: disable IER
[   70.840833] ath: phy0: enable IER
[   70.840840] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   70.938866] ath: phy0: disable IER
[   70.938928] ath: phy0: enable IER
[   70.938936] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.043138] ath: phy0: disable IER
[   71.043207] ath: phy0: enable IER
[   71.043215] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.089378] ath: phy0: disable IER
[   71.089418] ath: phy0: enable IER
[   71.089426] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.089855] ath: phy0: disable IER
[   71.089890] ath: phy0: enable IER
[   71.089897] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.090695] ath: phy0: disable IER
[   71.090734] ath: phy0: enable IER
[   71.090742] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.091178] ath: phy0: disable IER
[   71.091213] ath: phy0: enable IER
[   71.091221] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.093704] ath: phy0: disable IER
[   71.093744] ath: phy0: enable IER
[   71.093752] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.094208] ath: phy0: disable IER
[   71.094242] ath: phy0: enable IER
[   71.094250] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.116565] ath: phy0: disable IER
[   71.116605] ath: phy0: enable IER
[   71.116613] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.117041] ath: phy0: disable IER
[   71.117075] ath: phy0: enable IER
[   71.117082] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.143829] ath: phy0: disable IER
[   71.143890] ath: phy0: enable IER
[   71.143898] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.150195] ath: phy0: disable IER
[   71.150234] ath: phy0: enable IER
[   71.150242] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.150691] ath: phy0: disable IER
[   71.150725] ath: phy0: enable IER
[   71.150733] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.160317] ath: phy0: disable IER
[   71.160356] ath: phy0: enable IER
[   71.160364] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.160814] ath: phy0: disable IER
[   71.160850] ath: phy0: enable IER
[   71.160857] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.247092] ath: phy0: disable IER
[   71.247159] ath: phy0: enable IER
[   71.247166] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.348481] ath: phy0: disable IER
[   71.348540] ath: phy0: enable IER
[   71.348548] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.450869] ath: phy0: disable IER
[   71.450929] ath: phy0: enable IER
[   71.450936] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.452716] ath: phy0: disable IER
[   71.452782] ath: phy0: enable IER
[   71.452789] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.553270] ath: phy0: disable IER
[   71.553329] ath: phy0: enable IER
[   71.553337] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.655670] ath: phy0: disable IER
[   71.655734] ath: phy0: enable IER
[   71.655742] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.657516] ath: phy0: disable IER
[   71.657598] ath: phy0: enable IER
[   71.657606] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.716782] ath: phy0: listenTime=8118 OFDM:1 errs=608/s CCK:1 errs=168/s ofdm_turn=0
[   71.716809] ath: phy0: Calibration @4294910224 finished:   ani, caldone: true
[   71.758070] ath: phy0: disable IER
[   71.758131] ath: phy0: enable IER
[   71.758138] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   71.862147] ath: phy0: disable IER
[   71.862214] ath: phy0: enable IER
[   71.862222] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   72.270071] ath: phy0: disable IER
[   72.270148] ath: phy0: enable IER
[   72.270155] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   72.740855] ath: phy0: listenTime=9050 OFDM:1 errs=589/s CCK:1 errs=161/s ofdm_turn=0
[   72.740881] ath: phy0: Calibration @4294910480 finished:   ani, caldone: true
[   72.884476] ath: phy0: disable IER
[   72.884536] ath: phy0: enable IER
[   72.884544] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   72.886074] ath: phy0: disable IER
[   72.886141] ath: phy0: enable IER
[   72.886148] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   73.191676] ath: phy0: disable IER
[   73.191747] ath: phy0: enable IER
[   73.191755] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   73.498881] ath: phy0: disable IER
[   73.498944] ath: phy0: enable IER
[   73.498952] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   73.764852] ath: phy0: listenTime=9976 OFDM:1 errs=578/s CCK:1 errs=153/s ofdm_turn=0
[   73.764878] ath: phy0: Calibration @4294910736 finished:   ani, caldone: true
[   74.421161] ath: phy0: disable IER
[   74.421222] ath: phy0: enable IER
[   74.421230] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   74.788850] ath: phy0: listenTime=10874 OFDM:1 errs=593/s CCK:1 errs=151/s ofdm_turn=0
[   74.788876] ath: phy0: Calibration @4294910992 finished:   ani, caldone: true
[   75.442595] ath: phy0: disable IER
[   75.442627] ath: phy0: enable IER
[   75.442634] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   75.812852] ath: phy0: listenTime=11809 OFDM:1 errs=604/s CCK:1 errs=147/s ofdm_turn=0
[   75.812878] ath: phy0: Calibration @4294911248 finished:   ani, caldone: true
[   75.812961] ath: phy0: transmitting packet, skb: ffff8ceba8b91a00
[   75.812974] ath: phy0: qnum: 3, txq depth: 0
[   75.812979] ath: phy0: TXDP[3] = 28041380 (ffff8ce3a8041380)
[   75.815362] ath: phy0: disable IER
[   75.815411] ath: phy0: TX complete: skb: ffff8ceba8b91a00
[   75.815439] ath: phy0: enable IER
[   75.815447] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   75.854059] ath: phy0: disable IER
[   75.854119] ath: phy0: enable IER
[   75.854127] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   76.468488] ath: phy0: disable IER
[   76.468550] ath: phy0: enable IER
[   76.468558] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   76.570890] ath: phy0: disable IER
[   76.570950] ath: phy0: enable IER
[   76.570958] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   76.836854] ath: phy0: listenTime=12680 OFDM:1 errs=600/s CCK:1 errs=151/s ofdm_turn=0
[   76.836880] ath: phy0: Calibration @4294911504 finished:   ani, caldone: true
[   77.082892] ath: phy0: disable IER
[   77.082956] ath: phy0: enable IER
[   77.082964] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   77.287677] ath: phy0: disable IER
[   77.287753] ath: phy0: enable IER
[   77.287761] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   77.860837] ath: phy0: listenTime=13618 OFDM:1 errs=605/s CCK:1 errs=149/s ofdm_turn=0
[   77.860863] ath: phy0: Calibration @4294911760 finished:   ani, caldone: true
[   77.902097] ath: phy0: disable IER
[   77.902160] ath: phy0: enable IER
[   77.902168] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   78.004497] ath: phy0: disable IER
[   78.004557] ath: phy0: enable IER
[   78.004565] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   78.107516] ath: phy0: disable IER
[   78.107594] ath: phy0: enable IER
[   78.107602] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   78.516498] ath: phy0: disable IER
[   78.516558] ath: phy0: enable IER
[   78.516566] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   78.618899] ath: phy0: disable IER
[   78.618959] ath: phy0: enable IER
[   78.618966] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   78.823681] ath: phy0: disable IER
[   78.823741] ath: phy0: enable IER
[   78.823749] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   78.884837] ath: phy0: listenTime=14504 OFDM:1 errs=605/s CCK:1 errs=152/s ofdm_turn=0
[   78.884863] ath: phy0: Calibration @4294912016 finished:   ani, caldone: true
[   78.926099] ath: phy0: disable IER
[   78.926163] ath: phy0: enable IER
[   78.926171] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.028486] ath: phy0: disable IER
[   79.028546] ath: phy0: enable IER
[   79.028553] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.130878] ath: phy0: disable IER
[   79.130955] ath: phy0: enable IER
[   79.130963] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.233264] ath: phy0: disable IER
[   79.233323] ath: phy0: enable IER
[   79.233331] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.438103] ath: phy0: disable IER
[   79.438164] ath: phy0: enable IER
[   79.438171] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.642903] ath: phy0: disable IER
[   79.642967] ath: phy0: enable IER
[   79.642975] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.847686] ath: phy0: disable IER
[   79.847746] ath: phy0: enable IER
[   79.847754] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   79.908828] ath: phy0: listenTime=15440 OFDM:1 errs=592/s CCK:1 errs=152/s ofdm_turn=0
[   79.908854] ath: phy0: Calibration @4294912272 finished:   ani, caldone: true
[   80.564493] ath: phy0: disable IER
[   80.564557] ath: phy0: enable IER
[   80.564565] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   80.666885] ath: phy0: disable IER
[   80.666945] ath: phy0: enable IER
[   80.666953] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   80.871690] ath: phy0: disable IER
[   80.871749] ath: phy0: enable IER
[   80.871757] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   80.932823] ath: phy0: listenTime=16375 OFDM:1 errs=590/s CCK:1 errs=149/s ofdm_turn=0
[   80.932849] ath: phy0: Calibration @4294912528 finished:   ani, caldone: true
[   81.078390] ath: phy0: disable IER
[   81.078458] ath: phy0: enable IER
[   81.078466] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   81.283209] ath: phy0: disable IER
[   81.283277] ath: phy0: enable IER
[   81.283285] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   81.796893] ath: phy0: transmitting packet, skb: ffff8ceba75b9000
[   81.796906] ath: phy0: qnum: 3, txq depth: 0
[   81.796911] ath: phy0: TXDP[3] = 28041400 (ffff8ce3a8041400)
[   81.799376] ath: phy0: disable IER
[   81.799414] ath: phy0: TX complete: skb: ffff8ceba75b9000
[   81.799441] ath: phy0: enable IER
[   81.799449] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   81.893846] ath: phy0: disable IER
[   81.893876] ath: phy0: enable IER
[   81.893883] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   81.895687] ath: phy0: disable IER
[   81.895746] ath: phy0: enable IER
[   81.895754] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   81.956822] ath: phy0: listenTime=17314 OFDM:1 errs=582/s CCK:1 errs=150/s ofdm_turn=0
[   81.956848] ath: phy0: Calibration @4294912784 finished:   ani, caldone: true
[   82.100512] ath: phy0: disable IER
[   82.100574] ath: phy0: enable IER
[   82.100582] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   82.407697] ath: phy0: disable IER
[   82.407757] ath: phy0: enable IER
[   82.407765] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   82.510087] ath: phy0: disable IER
[   82.510146] ath: phy0: enable IER
[   82.510154] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   82.612518] ath: phy0: disable IER
[   82.612579] ath: phy0: enable IER
[   82.612587] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   82.980808] ath: phy0: listenTime=18251 OFDM:1 errs=584/s CCK:1 errs=148/s ofdm_turn=0
[   82.980834] ath: phy0: Calibration @4294913040 finished:   ani, caldone: true
[   83.022119] ath: phy0: disable IER
[   83.022181] ath: phy0: enable IER
[   83.022189] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   83.126314] ath: phy0: disable IER
[   83.126386] ath: phy0: enable IER
[   83.126394] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   83.431718] ath: phy0: disable IER
[   83.431780] ath: phy0: enable IER
[   83.431787] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   83.534123] ath: phy0: disable IER
[   83.534184] ath: phy0: enable IER
[   83.534192] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   83.636524] ath: phy0: disable IER
[   83.636586] ath: phy0: enable IER
[   83.636593] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   83.738923] ath: phy0: disable IER
[   83.738984] ath: phy0: enable IER
[   83.738993] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   83.943705] ath: phy0: disable IER
[   83.943765] ath: phy0: enable IER
[   83.943773] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   84.004813] ath: phy0: listenTime=19183 OFDM:1 errs=578/s CCK:1 errs=144/s ofdm_turn=0
[   84.004839] ath: phy0: Calibration @4294913296 finished:   ani, caldone: true
[   84.046096] ath: phy0: disable IER
[   84.046156] ath: phy0: enable IER
[   84.046164] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   84.148523] ath: phy0: disable IER
[   84.148597] ath: phy0: enable IER
[   84.148605] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   84.353323] ath: phy0: disable IER
[   84.353385] ath: phy0: enable IER
[   84.353393] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   84.455723] ath: phy0: disable IER
[   84.455783] ath: phy0: enable IER
[   84.455791] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   84.558124] ath: phy0: disable IER
[   84.558185] ath: phy0: enable IER
[   84.558193] ath: phy0: AR_IMR 0x81840175 IER 0x1
[   85.028816] ath: phy0: listenTime=20125 OFDM:1 errs=590/s CCK:1 errs=142/s ofdm_turn=0
[   85.028843] ath: phy0: Calibration @4294913552 finished:   ani, caldone: true
[   85.580247] ath: phy0: disable IER
[   85.580278] ath: phy0: enable IER
[   85.580286] ath: phy0: AR_IMR 0x81840175 IER 0x1
