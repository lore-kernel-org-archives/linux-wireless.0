Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:60496 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3KMQsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 11:48:38 -0500
Message-ID: <5283AACC.7040505@einfach.org> (sfid-20131113_174848_895193_9B572F18)
Date: Wed, 13 Nov 2013 16:37:32 +0000
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Sujith Manoharan <sujith@msujith.org>, nbd@openwrt.org,
	Ingo Randolf <ingo.randolf@qupik.com>, mcgrof@do-not-panic.com
Subject: ath9k AR9382 high latency ping
References: <52492FB0.3010201@einfach.org>	<5249443E.3080700@rempel-privat.de>	<524954BE.8060603@einfach.org>	<52497C2E.1060406@rempel-privat.de>	<5249A2F7.5090908@einfach.org>	<524DA3DC.6060806@einfach.org> <21087.18050.72635.617321@gargle.gargle.HOWL>
In-Reply-To: <21087.18050.72635.617321@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All!

Here is another ath9k PCIe card I have problems with in a Intel Atom
N2600 embedded board (Advantech MIO-2261N). This is the same board I was
reporting problems with the AR9287 before. I exchanged the card for an
AR9382 and at least I can associate now.

It's a AR9382 (Unex DNXA-116) and the PCI ID 168c:0030 subsystem
168c:3116, reported as "AR9300 Rev:3"...

The symptom are ping times of around 1000ms, when connected to an AP
(very close, I expect around 2ms), eg.

64 bytes from 192.168.5.1: icmp_seq=1 ttl=64 time=1237 ms
64 bytes from 192.168.5.1: icmp_seq=2 ttl=64 time=1403 ms
64 bytes from 192.168.5.1: icmp_seq=3 ttl=64 time=1567 ms
64 bytes from 192.168.5.1: icmp_seq=4 ttl=64 time=1728 ms

The same card works fine in another Laptop, BTW, so it must be a problem
specific to this board.

I run wireless-testing from yesterday and I tried with different
combinations of enabling/disabling ASPM in the BIOS and booting with
pcie_aspm=off pcie_aspm=force all of which has the same result...

Below is the output of debug=0x8f49, please let me know if you have any
idea what else I can try...

Thanks,
bruno

---

[   18.707340] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   45.583338] ath: phy0: unsupported hw bitrate detected 0x1b using 1 Mbit
[   91.072822] *** L1 disable
[   91.076231] ath: phy1: UNDEFINED -> AWAKE
[   91.076310] ath: phy1: serialize_regmode is 0
[   91.081767] ath: phy1: Eeprom VER: 2, REV: 0
[   91.081773] ath: phy1: Initialize ANI
[   91.081777] ath: phy1: Enable MIB counters
[   91.083041] ***aspm init
[   91.083048] ***aspm is 64
[   91.083054] ath: phy1: TX streams 2, RX streams: 2
[   91.083059] ath: phy1: TX streams 2, RX streams: 2
[   91.083063] ath: EEPROM regdomain: 0x65
[   91.083067] ath: EEPROM indicates we should expect a direct regpair map
[   91.083073] ath: Country alpha2 being used: 00
[   91.083076] ath: Regpair used: 0x65
[   91.083088] ath: phy1: tx DMA: 512 buffers 1 desc/buf
[   91.083124] ath: phy1: tx DMA map: f2970000 (65536) -> 32970000 (65536)
[   91.083177] ath: phy1: beacon DMA: 8 buffers 1 desc/buf
[   91.083186] ath: phy1: beacon DMA map: f2b9f000 (1024) -> 32b9f000 (1024)
[   91.085646] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[   91.087244] ieee80211 phy1: Atheros AR9300 Rev:3 mem=0xf90c0000, irq=21
[   91.101837] ath: phy1: Starting driver with initial channel: 2412 MHz
[   91.102783] ath: phy1: ver 448.3 opmode 0 chan 2412 Mhz
[   91.102810] ath: phy1: ah->misc_mode 0x10000004
[   91.105319] ath: phy1: enabling IQ Calibration
[   91.105332] ath: phy1: starting IQ Mismatch Calibration
[   91.105532] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   91.105644] ath: phy1: Enable MIB counters
[   91.105667] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.105675] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.108108] ath: phy1: Attach a VIF of type: 2
[   91.108143] ath: phy1: ah->misc_mode 0x10000004
[   91.108669] ath: phy1: Configure tx [queue/halq] [0/0], aifs: 2,
cw_min: 15, cw_max: 1023, txop: 0
[   91.108698] ath: phy1: Configure tx [queue/halq] [1/1], aifs: 2,
cw_min: 15, cw_max: 1023, txop: 0
[   91.108720] ath: phy1: Configure tx [queue/halq] [2/2], aifs: 2,
cw_min: 15, cw_max: 1023, txop: 0
[   91.108743] ath: phy1: Configure tx [queue/halq] [3/3], aifs: 2,
cw_min: 15, cw_max: 1023, txop: 0
[   91.108771] ath: phy1: PowerSave disabled
[   91.108778] ath: phy1: Monitor mode is disabled
[   91.108786] ath: phy1: Set channel: 2412 MHz width: 0
[   91.108813] ath: phy1: Stopping ANI
[   91.108919] ath: phy1: Disable MIB counters
[   91.108993] ath: phy1: Reset to 2412 MHz, HT40: 0 fastcc: 0
[   91.109005] ath: phy1: NF did not complete in calibration window
[   91.109944] ath: phy1: ver 448.3 opmode 2 chan 2412 Mhz
[   91.109970] ath: phy1: ah->misc_mode 0x10000004
[   91.112830] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.112856] ath: phy1: IQ_RES[0]=0x114d1028 IQ_RES[1]=0xb00
[   91.112875] ath: phy1: IQ_RES[2]=0xdfd74da IQ_RES[3]=0x2330
[   91.112894] ath: phy1: IQ_RES[4]=0x38011002 IQ_RES[5]=0xfbc2
[   91.112904] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.112911] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   91.112918] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   91.112925] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   91.112932] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   91.112939] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.112963] ath: phy1: IQ_RES[0]=0x1152d02d IQ_RES[1]=0xc90
[   91.112982] ath: phy1: IQ_RES[2]=0xefe0541 IQ_RES[3]=0x25d0
[   91.113000] ath: phy1: IQ_RES[4]=0x6501a001 IQ_RES[5]=0xfb62
[   91.113009] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.113017] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   91.113024] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   91.113032] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[   91.113039] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[   91.113045] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.113066] ath: phy1: IQ_RES[0]=0x1451402d IQ_RES[1]=0xcb0
[   91.113084] ath: phy1: IQ_RES[2]=0x10ff2525 IQ_RES[3]=0x2510
[   91.113103] ath: phy1: IQ_RES[4]=0x59023002 IQ_RES[5]=0xfb82
[   91.113113] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.113120] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   91.113127] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   91.113135] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   91.113142] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   91.113148] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.113168] ath: phy1: IQ_RES[0]=0x12516030 IQ_RES[1]=0xce0
[   91.113186] ath: phy1: IQ_RES[2]=0x11fec52c IQ_RES[3]=0x2570
[   91.113205] ath: phy1: IQ_RES[4]=0x5a022ffe IQ_RES[5]=0xfb72
[   91.113214] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.113221] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   91.113228] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   91.113236] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[   91.113243] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[   91.113250] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.113269] ath: phy1: IQ_RES[0]=0x1956a033 IQ_RES[1]=0xe00
[   91.113287] ath: phy1: IQ_RES[2]=0x12ff457c IQ_RES[3]=0x27c0
[   91.113304] ath: phy1: IQ_RES[4]=0x7f028000 IQ_RES[5]=0xfb32
[   91.113312] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.113319] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   91.113326] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   91.113333] ath: phy1: rx chain 0: mag corr=-6  phase corr=-7
[   91.113340] ath: phy1: rx chain 0: iq corr coeff=fffffcf9
[   91.113347] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.113366] ath: phy1: IQ_RES[0]=0x12678046 IQ_RES[1]=0x10f0
[   91.113385] ath: phy1: IQ_RES[2]=0x11fe268f IQ_RES[3]=0x2f60
[   91.113403] ath: phy1: IQ_RES[4]=0x29ff9 IQ_RES[5]=0xf9f3
[   91.113412] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.113420] ath: phy1: tx chain 0: mag corr=0  phase corr=-7
[   91.113427] ath: phy1: tx chain 0: iq corr coeff=fffffff9
[   91.113435] ath: phy1: rx chain 0: mag corr=-8  phase corr=-4
[   91.113442] ath: phy1: rx chain 0: iq corr coeff=fffffbfc
[   91.113451] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.113471] ath: phy1: IQ_RES[0]=0x451f008 IQ_RES[1]=0xa20
[   91.113489] ath: phy1: IQ_RES[2]=0x1dfd5525 IQ_RES[3]=0x2640
[   91.113507] ath: phy1: IQ_RES[4]=0x6b02afff IQ_RES[5]=0xfb52
[   91.113517] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.113524] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   91.113531] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   91.113539] ath: phy1: rx chain 1: mag corr=3  phase corr=-6
[   91.113546] ath: phy1: rx chain 1: iq corr coeff=17a
[   91.113552] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.113572] ath: phy1: IQ_RES[0]=0xfe582fff IQ_RES[1]=0xa9f
[   91.113590] ath: phy1: IQ_RES[2]=0x1cfdf58f IQ_RES[3]=0x2930
[   91.113608] ath: phy1: IQ_RES[4]=0x9d032000 IQ_RES[5]=0xfb22
[   91.113617] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.113625] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   91.113632] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   91.113639] ath: phy1: rx chain 1: mag corr=4  phase corr=-5
[   91.113646] ath: phy1: rx chain 1: iq corr coeff=1fb
[   91.113653] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.113672] ath: phy1: IQ_RES[0]=0xfa562ffd IQ_RES[1]=0xa4f
[   91.113690] ath: phy1: IQ_RES[2]=0x1bfe5569 IQ_RES[3]=0x2830
[   91.113709] ath: phy1: IQ_RES[4]=0x8a032002 IQ_RES[5]=0xfb52
[   91.113718] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.113725] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   91.113732] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   91.113739] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   91.113745] ath: phy1: rx chain 1: iq corr coeff=1fc
[   91.113750] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.113769] ath: phy1: IQ_RES[0]=0xf955fffb IQ_RES[1]=0xa1f
[   91.113786] ath: phy1: IQ_RES[2]=0x17fe656b IQ_RES[3]=0x2840
[   91.113804] ath: phy1: IQ_RES[4]=0x8b034003 IQ_RES[5]=0xfb72
[   91.113812] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.113819] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   91.113826] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   91.113834] ath: phy1: rx chain 1: mag corr=5  phase corr=-3
[   91.113841] ath: phy1: rx chain 1: iq corr coeff=27d
[   91.113847] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.113866] ath: phy1: IQ_RES[0]=0xf65a6ffb IQ_RES[1]=0xaaf
[   91.113882] ath: phy1: IQ_RES[2]=0x1bfe95b1 IQ_RES[3]=0x2a60
[   91.113899] ath: phy1: IQ_RES[4]=0xaa037001 IQ_RES[5]=0xfb42
[   91.113908] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.113915] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   91.113921] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   91.113928] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   91.113935] ath: phy1: rx chain 1: iq corr coeff=1fc
[   91.113941] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.113959] ath: phy1: IQ_RES[0]=0xf76a6ffd IQ_RES[1]=0xc8f
[   91.113976] ath: phy1: IQ_RES[2]=0x1ffdb6b5 IQ_RES[3]=0x31f0
[   91.113994] ath: phy1: IQ_RES[4]=0x2703f005 IQ_RES[5]=0xfa43
[   91.114003] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.114010] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   91.114017] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   91.114025] ath: phy1: rx chain 1: mag corr=5  phase corr=-3
[   91.114031] ath: phy1: rx chain 1: iq corr coeff=27d
[   91.114083] ath: phy1: enabling IQ Calibration
[   91.114092] ath: phy1: starting IQ Mismatch Calibration
[   91.114136] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   91.114241] ath: phy1: Enable MIB counters
[   91.114264] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   91.114273] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.114282] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.114406] ath: phy1: Set power: 15
[   91.114498] ath: phy1: Set HW RX filter: 0x207
[   91.114550] ath: phy1: Set HW RX filter: 0x207
[   91.114663] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   91.114687] ath: phy1: Set HW RX filter: 0x207
[   91.185926] ath: phy1: Set HW RX filter: 0x17
[   91.187009] ath: phy1: Set channel: 2412 MHz width: 0
[   91.187040] ath: phy1: Stopping ANI
[   91.187142] ath: phy1: Disable MIB counters
[   91.187211] ath: phy1: Reset to 2412 MHz, HT40: 0 fastcc: 0
[   91.187228] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   91.187235] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   91.188202] ath: phy1: ver 448.3 opmode 2 chan 2412 Mhz
[   91.188229] ath: phy1: ah->misc_mode 0x10000004
[   91.191121] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.191141] ath: phy1: IQ_RES[0]=0x144c5028 IQ_RES[1]=0xaf0
[   91.191156] ath: phy1: IQ_RES[2]=0xefd54d2 IQ_RES[3]=0x22e0
[   91.191171] ath: phy1: IQ_RES[4]=0x33010002 IQ_RES[5]=0xfc02
[   91.191178] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.191183] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   91.191188] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   91.191193] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   91.191197] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   91.191202] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.191218] ath: phy1: IQ_RES[0]=0x1152602b IQ_RES[1]=0xc50
[   91.191233] ath: phy1: IQ_RES[2]=0xefe5536 IQ_RES[3]=0x25a0
[   91.191247] ath: phy1: IQ_RES[4]=0x6001b001 IQ_RES[5]=0xfba2
[   91.191253] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.191258] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   91.191262] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   91.191267] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[   91.191272] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[   91.191276] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.191292] ath: phy1: IQ_RES[0]=0x1550902d IQ_RES[1]=0xc90
[   91.191307] ath: phy1: IQ_RES[2]=0x11fef51f IQ_RES[3]=0x2500
[   91.191320] ath: phy1: IQ_RES[4]=0x53021fff IQ_RES[5]=0xfbb2
[   91.191326] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.191331] ath: phy1: tx chain 0: mag corr=-1  phase corr=-4
[   91.191335] ath: phy1: tx chain 0: iq corr coeff=ffffff7c
[   91.191340] ath: phy1: rx chain 0: mag corr=-5  phase corr=-7
[   91.191345] ath: phy1: rx chain 0: iq corr coeff=fffffd79
[   91.191349] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.191365] ath: phy1: IQ_RES[0]=0x1050e02f IQ_RES[1]=0xcd0
[   91.191380] ath: phy1: IQ_RES[2]=0x10ff1523 IQ_RES[3]=0x2500
[   91.191394] ath: phy1: IQ_RES[4]=0x56020000 IQ_RES[5]=0xfb82
[   91.191399] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.191404] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   91.191409] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   91.191413] ath: phy1: rx chain 0: mag corr=-6  phase corr=-4
[   91.191418] ath: phy1: rx chain 0: iq corr coeff=fffffcfc
[   91.191422] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.191439] ath: phy1: IQ_RES[0]=0x1455c032 IQ_RES[1]=0xdd0
[   91.191453] ath: phy1: IQ_RES[2]=0x11ff2572 IQ_RES[3]=0x2750
[   91.191467] ath: phy1: IQ_RES[4]=0x7a027fff IQ_RES[5]=0xfb12
[   91.191473] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.191478] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   91.191482] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   91.191487] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[   91.191492] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[   91.191496] ath: phy1: Doing Tx IQ Cal for chain 0
[   91.191512] ath: phy1: IQ_RES[0]=0x1066a04b IQ_RES[1]=0x10e0
[   91.191528] ath: phy1: IQ_RES[2]=0x12fe0684 IQ_RES[3]=0x2f50
[   91.191545] ath: phy1: IQ_RES[4]=0xfb027ff9 IQ_RES[5]=0xf9e2
[   91.191553] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   91.191559] ath: phy1: tx chain 0: mag corr=0  phase corr=-7
[   91.191565] ath: phy1: tx chain 0: iq corr coeff=fffffff9
[   91.191572] ath: phy1: rx chain 0: mag corr=-8  phase corr=-3
[   91.191578] ath: phy1: rx chain 0: iq corr coeff=fffffbfd
[   91.191586] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.191604] ath: phy1: IQ_RES[0]=0x3512009 IQ_RES[1]=0xa20
[   91.191621] ath: phy1: IQ_RES[2]=0x1efd951d IQ_RES[3]=0x25f0
[   91.191640] ath: phy1: IQ_RES[4]=0x6702bffd IQ_RES[5]=0xfb42
[   91.191650] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.191656] ath: phy1: tx chain 1: mag corr=-4  phase corr=6
[   91.191662] ath: phy1: tx chain 1: iq corr coeff=fffffe06
[   91.191669] ath: phy1: rx chain 1: mag corr=3  phase corr=-6
[   91.191675] ath: phy1: rx chain 1: iq corr coeff=17a
[   91.191681] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.191701] ath: phy1: IQ_RES[0]=0xfe576002 IQ_RES[1]=0xadf
[   91.191719] ath: phy1: IQ_RES[2]=0x1afdf582 IQ_RES[3]=0x28f0
[   91.191735] ath: phy1: IQ_RES[4]=0x95032000 IQ_RES[5]=0xfb02
[   91.191743] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.191749] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   91.191755] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   91.191762] ath: phy1: rx chain 1: mag corr=3  phase corr=-5
[   91.191768] ath: phy1: rx chain 1: iq corr coeff=17b
[   91.191774] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.191792] ath: phy1: IQ_RES[0]=0xfa557fff IQ_RES[1]=0xa7f
[   91.191809] ath: phy1: IQ_RES[2]=0x19fe8562 IQ_RES[3]=0x27f0
[   91.191825] ath: phy1: IQ_RES[4]=0x85034001 IQ_RES[5]=0xfb52
[   91.191832] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.191839] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   91.191846] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   91.191853] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   91.191860] ath: phy1: rx chain 1: iq corr coeff=1fc
[   91.191866] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.191886] ath: phy1: IQ_RES[0]=0xf8551ffe IQ_RES[1]=0xa6f
[   91.191903] ath: phy1: IQ_RES[2]=0x18fe455d IQ_RES[3]=0x27e0
[   91.191919] ath: phy1: IQ_RES[4]=0x84032001 IQ_RES[5]=0xfb62
[   91.191928] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.191934] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   91.191940] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   91.191946] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   91.191952] ath: phy1: rx chain 1: iq corr coeff=1fd
[   91.191957] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.191976] ath: phy1: IQ_RES[0]=0xf7597ffb IQ_RES[1]=0xadf
[   91.191994] ath: phy1: IQ_RES[2]=0x19fe75a3 IQ_RES[3]=0x29c0
[   91.192013] ath: phy1: IQ_RES[4]=0xa6035002 IQ_RES[5]=0xfb32
[   91.192023] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.192029] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   91.192035] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   91.192041] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   91.192048] ath: phy1: rx chain 1: iq corr coeff=1fd
[   91.192054] ath: phy1: Doing Tx IQ Cal for chain 1
[   91.192073] ath: phy1: IQ_RES[0]=0xf4698ffa IQ_RES[1]=0xcbf
[   91.192092] ath: phy1: IQ_RES[2]=0x1dfdf6a8 IQ_RES[3]=0x3150
[   91.192110] ath: phy1: IQ_RES[4]=0x1e03c001 IQ_RES[5]=0xfa73
[   91.192119] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   91.192126] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   91.192169] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   91.192177] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   91.192182] ath: phy1: rx chain 1: iq corr coeff=1fd
[   91.192243] ath: phy1: enabling IQ Calibration
[   91.192255] ath: phy1: starting IQ Mismatch Calibration
[   91.192303] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   91.192436] ath: phy1: Enable MIB counters
[   91.192473] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   91.192498] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.192518] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.248211] ath: phy1: Set channel: 2417 MHz width: 0
[   91.248248] ath: phy1: Stopping ANI
[   91.248367] ath: phy1: Disable MIB counters
[   91.248435] ath: phy1: Reset to 2417 MHz, HT40: 0 fastcc: 1
[   91.248450] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   91.248457] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   91.248467] ath: phy1: MAC Hang signature not found at DCU complete
[   91.248474] ath: phy1: FastChannelChange for 2412 -> 2417
[   91.249400] ath: phy1: Enable MIB counters
[   91.249420] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.249428] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.249452] ath: phy1: Set power: 16
[   91.304404] ath: phy1: Set channel: 2422 MHz width: 0
[   91.304441] ath: phy1: Stopping ANI
[   91.304558] ath: phy1: Disable MIB counters
[   91.304675] ath: phy1: Reset to 2422 MHz, HT40: 0 fastcc: 1
[   91.304693] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   91.304700] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   91.304711] ath: phy1: MAC Hang signature not found at DCU complete
[   91.304718] ath: phy1: FastChannelChange for 2417 -> 2422
[   91.305648] ath: phy1: Enable MIB counters
[   91.305669] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.305677] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.360362] ath: phy1: Set channel: 2427 MHz width: 0
[   91.360415] ath: phy1: Stopping ANI
[   91.360566] ath: phy1: Disable MIB counters
[   91.360773] ath: phy1: Reset to 2427 MHz, HT40: 0 fastcc: 1
[   91.360801] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   91.360815] ath: phy1: NF calibrated [ctl] [chain 1] is -104
[   91.360833] ath: phy1: MAC Hang signature not found at DCU complete
[   91.360847] ath: phy1: FastChannelChange for 2422 -> 2427
[   91.361846] ath: phy1: Enable MIB counters
[   91.361876] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.361891] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.416386] ath: phy1: Set channel: 2432 MHz width: 0
[   91.416445] ath: phy1: Stopping ANI
[   91.416596] ath: phy1: Disable MIB counters
[   91.416776] ath: phy1: Reset to 2432 MHz, HT40: 0 fastcc: 1
[   91.416804] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   91.416818] ath: phy1: NF calibrated [ctl] [chain 1] is -104
[   91.416836] ath: phy1: MAC Hang signature not found at DCU complete
[   91.416850] ath: phy1: FastChannelChange for 2427 -> 2432
[   91.417852] ath: phy1: Enable MIB counters
[   91.417882] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.417897] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.472338] ath: phy1: Set channel: 2437 MHz width: 0
[   91.472401] ath: phy1: Stopping ANI
[   91.472553] ath: phy1: Disable MIB counters
[   91.472772] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 1
[   91.472802] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   91.472815] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   91.472833] ath: phy1: MAC Hang signature not found at DCU complete
[   91.472846] ath: phy1: FastChannelChange for 2432 -> 2437
[   91.473852] ath: phy1: Enable MIB counters
[   91.473882] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.473897] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.528307] ath: phy1: Set channel: 2442 MHz width: 0
[   91.528355] ath: phy1: Stopping ANI
[   91.528488] ath: phy1: Disable MIB counters
[   91.528753] ath: phy1: Reset to 2442 MHz, HT40: 0 fastcc: 1
[   91.528778] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   91.528788] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   91.528802] ath: phy1: MAC Hang signature not found at DCU complete
[   91.528812] ath: phy1: FastChannelChange for 2437 -> 2442
[   91.529770] ath: phy1: Enable MIB counters
[   91.529795] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.529806] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.584303] ath: phy1: Set channel: 2447 MHz width: 0
[   91.584359] ath: phy1: Stopping ANI
[   91.584503] ath: phy1: Disable MIB counters
[   91.584731] ath: phy1: Reset to 2447 MHz, HT40: 0 fastcc: 1
[   91.584762] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   91.584776] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   91.584794] ath: phy1: MAC Hang signature not found at DCU complete
[   91.584807] ath: phy1: FastChannelChange for 2442 -> 2447
[   91.585813] ath: phy1: Enable MIB counters
[   91.585843] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.585858] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.640255] ath: phy1: Set channel: 2452 MHz width: 0
[   91.640318] ath: phy1: Stopping ANI
[   91.640466] ath: phy1: Disable MIB counters
[   91.640666] ath: phy1: Reset to 2452 MHz, HT40: 0 fastcc: 1
[   91.640696] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   91.640710] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   91.640727] ath: phy1: MAC Hang signature not found at DCU complete
[   91.640741] ath: phy1: FastChannelChange for 2447 -> 2452
[   91.641733] ath: phy1: Enable MIB counters
[   91.641763] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.641778] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.696239] ath: phy1: Set channel: 2457 MHz width: 0
[   91.696294] ath: phy1: Stopping ANI
[   91.696439] ath: phy1: Disable MIB counters
[   91.696615] ath: phy1: Reset to 2457 MHz, HT40: 0 fastcc: 1
[   91.696644] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   91.696658] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   91.696676] ath: phy1: MAC Hang signature not found at DCU complete
[   91.696689] ath: phy1: FastChannelChange for 2452 -> 2457
[   91.697749] ath: phy1: Enable MIB counters
[   91.697780] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.697795] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.752207] ath: phy1: Set channel: 2462 MHz width: 0
[   91.752253] ath: phy1: Stopping ANI
[   91.752385] ath: phy1: Disable MIB counters
[   91.752556] ath: phy1: Reset to 2462 MHz, HT40: 0 fastcc: 1
[   91.752585] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   91.752599] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   91.752617] ath: phy1: MAC Hang signature not found at DCU complete
[   91.752631] ath: phy1: FastChannelChange for 2457 -> 2462
[   91.753688] ath: phy1: Enable MIB counters
[   91.753718] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.753733] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.753771] ath: phy1: Set power: 15
[   91.808192] ath: phy1: Set channel: 2467 MHz width: 0
[   91.808249] ath: phy1: Stopping ANI
[   91.808391] ath: phy1: Disable MIB counters
[   91.808565] ath: phy1: Reset to 2467 MHz, HT40: 0 fastcc: 1
[   91.808594] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   91.808608] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   91.808626] ath: phy1: MAC Hang signature not found at DCU complete
[   91.808640] ath: phy1: FastChannelChange for 2462 -> 2467
[   91.809699] ath: phy1: Enable MIB counters
[   91.809729] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.809744] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   91.809783] ath: phy1: Set power: 16
[   91.916129] ath: phy1: Set channel: 2472 MHz width: 0
[   91.916177] ath: phy1: Stopping ANI
[   91.916293] ath: phy1: Disable MIB counters
[   91.916453] ath: phy1: Reset to 2472 MHz, HT40: 0 fastcc: 1
[   91.916478] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   91.916488] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   91.916503] ath: phy1: MAC Hang signature not found at DCU complete
[   91.916513] ath: phy1: FastChannelChange for 2467 -> 2472
[   91.917527] ath: phy1: Enable MIB counters
[   91.917552] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   91.917564] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.024117] ath: phy1: Set channel: 5180 MHz width: 0
[   92.024173] ath: phy1: Stopping ANI
[   92.024298] ath: phy1: Disable MIB counters
[   92.024355] ath: phy1: unsupported hw bitrate detected 0x1b using 1 Mbit
[   92.024407] ath: phy1: Reset to 5180 MHz, HT40: 0 fastcc: 1
[   92.024431] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   92.024444] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   92.025346] ath: phy1: ver 448.3 opmode 2 chan 5180 Mhz
[   92.025380] ath: phy1: ah->misc_mode 0x10000004
[   92.027946] ath: phy1: enabling IQ Calibration
[   92.027968] ath: phy1: starting IQ Mismatch Calibration
[   92.028163] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   92.028359] ath: phy1: Enable MIB counters
[   92.028398] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.028419] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.028512] ath: phy1: Set power: 15
[   92.136072] ath: phy1: Set channel: 5200 MHz width: 0
[   92.136129] ath: phy1: Stopping ANI
[   92.136250] ath: phy1: Disable MIB counters
[   92.136342] ath: phy1: Reset to 5200 MHz, HT40: 0 fastcc: 1
[   92.136367] ath: phy1: NF calibrated [ctl] [chain 0] is -111
[   92.136381] ath: phy1: NF calibrated [ctl] [chain 1] is -111
[   92.136398] ath: phy1: MAC Hang signature not found at DCU complete
[   92.136411] ath: phy1: FastChannelChange for 5180 -> 5200
[   92.137362] ath: phy1: Enable MIB counters
[   92.137392] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.137407] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.243985] ath: phy1: Set channel: 5220 MHz width: 0
[   92.244041] ath: phy1: Stopping ANI
[   92.244165] ath: phy1: Disable MIB counters
[   92.244258] ath: phy1: Reset to 5220 MHz, HT40: 0 fastcc: 1
[   92.244283] ath: phy1: NF calibrated [ctl] [chain 0] is -109
[   92.244296] ath: phy1: NF calibrated [ctl] [chain 1] is -110
[   92.244314] ath: phy1: MAC Hang signature not found at DCU complete
[   92.244329] ath: phy1: FastChannelChange for 5200 -> 5220
[   92.245272] ath: phy1: Enable MIB counters
[   92.245303] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.245319] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.351952] ath: phy1: Set channel: 5240 MHz width: 0
[   92.352010] ath: phy1: Stopping ANI
[   92.352134] ath: phy1: Disable MIB counters
[   92.352223] ath: phy1: Reset to 5240 MHz, HT40: 0 fastcc: 1
[   92.352248] ath: phy1: NF calibrated [ctl] [chain 0] is -110
[   92.352261] ath: phy1: NF calibrated [ctl] [chain 1] is -110
[   92.352279] ath: phy1: MAC Hang signature not found at DCU complete
[   92.352292] ath: phy1: FastChannelChange for 5220 -> 5240
[   92.353244] ath: phy1: Enable MIB counters
[   92.353275] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.353290] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.353329] ath: phy1: Set power: 16
[   92.459882] ath: phy1: Set channel: 5260 MHz width: 0
[   92.459929] ath: phy1: Stopping ANI
[   92.460044] ath: phy1: Disable MIB counters
[   92.460126] ath: phy1: Reset to 5260 MHz, HT40: 0 fastcc: 1
[   92.460145] ath: phy1: NF calibrated [ctl] [chain 0] is -108
[   92.460155] ath: phy1: NF calibrated [ctl] [chain 1] is -109
[   92.460169] ath: phy1: MAC Hang signature not found at DCU complete
[   92.460179] ath: phy1: FastChannelChange for 5240 -> 5260
[   92.461087] ath: phy1: Enable MIB counters
[   92.461113] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.461124] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.461158] ath: phy1: Set power: 15
[   92.567816] ath: phy1: Set channel: 5280 MHz width: 0
[   92.567864] ath: phy1: Stopping ANI
[   92.567980] ath: phy1: Disable MIB counters
[   92.568058] ath: phy1: Reset to 5280 MHz, HT40: 0 fastcc: 1
[   92.568078] ath: phy1: NF calibrated [ctl] [chain 0] is -108
[   92.568088] ath: phy1: NF calibrated [ctl] [chain 1] is -109
[   92.568101] ath: phy1: MAC Hang signature not found at DCU complete
[   92.568111] ath: phy1: FastChannelChange for 5260 -> 5280
[   92.569026] ath: phy1: Enable MIB counters
[   92.569052] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.569063] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.675796] ath: phy1: Set channel: 5300 MHz width: 0
[   92.675851] ath: phy1: Stopping ANI
[   92.675974] ath: phy1: Disable MIB counters
[   92.676068] ath: phy1: Reset to 5300 MHz, HT40: 0 fastcc: 1
[   92.676093] ath: phy1: NF calibrated [ctl] [chain 0] is -108
[   92.676107] ath: phy1: NF calibrated [ctl] [chain 1] is -110
[   92.676124] ath: phy1: MAC Hang signature not found at DCU complete
[   92.676137] ath: phy1: FastChannelChange for 5280 -> 5300
[   92.677085] ath: phy1: Enable MIB counters
[   92.677116] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.677131] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.783712] ath: phy1: Set channel: 5320 MHz width: 0
[   92.783769] ath: phy1: Stopping ANI
[   92.783891] ath: phy1: Disable MIB counters
[   92.783980] ath: phy1: Reset to 5320 MHz, HT40: 0 fastcc: 1
[   92.784005] ath: phy1: NF calibrated [ctl] [chain 0] is -108
[   92.784018] ath: phy1: NF calibrated [ctl] [chain 1] is -109
[   92.784035] ath: phy1: MAC Hang signature not found at DCU complete
[   92.784049] ath: phy1: FastChannelChange for 5300 -> 5320
[   92.784997] ath: phy1: Enable MIB counters
[   92.785027] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.785042] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.891658] ath: phy1: Set channel: 5745 MHz width: 0
[   92.891715] ath: phy1: Stopping ANI
[   92.891841] ath: phy1: Disable MIB counters
[   92.891936] ath: phy1: Reset to 5745 MHz, HT40: 0 fastcc: 1
[   92.891961] ath: phy1: NF calibrated [ctl] [chain 0] is -108
[   92.891974] ath: phy1: NF calibrated [ctl] [chain 1] is -109
[   92.891992] ath: phy1: MAC Hang signature not found at DCU complete
[   92.892005] ath: phy1: FastChannelChange for 5320 -> 5745
[   92.892957] ath: phy1: Enable MIB counters
[   92.892988] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   92.893003] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   92.893041] ath: phy1: Set power: 18
[   92.999585] ath: phy1: Set channel: 5765 MHz width: 0
[   92.999642] ath: phy1: Stopping ANI
[   92.999767] ath: phy1: Disable MIB counters
[   92.999859] ath: phy1: Reset to 5765 MHz, HT40: 0 fastcc: 1
[   92.999883] ath: phy1: NF calibrated [ctl] [chain 0] is -112
[   92.999897] ath: phy1: NF calibrated [ctl] [chain 1] is -111
[   92.999914] ath: phy1: MAC Hang signature not found at DCU complete
[   92.999928] ath: phy1: FastChannelChange for 5745 -> 5765
[   93.000874] ath: phy1: Enable MIB counters
[   93.000904] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.000919] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.107580] ath: phy1: Set channel: 5785 MHz width: 0
[   93.107636] ath: phy1: Stopping ANI
[   93.107760] ath: phy1: Disable MIB counters
[   93.107850] ath: phy1: Reset to 5785 MHz, HT40: 0 fastcc: 1
[   93.107874] ath: phy1: NF calibrated [ctl] [chain 0] is -113
[   93.107888] ath: phy1: NF calibrated [ctl] [chain 1] is -112
[   93.107905] ath: phy1: MAC Hang signature not found at DCU complete
[   93.107919] ath: phy1: FastChannelChange for 5765 -> 5785
[   93.108875] ath: phy1: Enable MIB counters
[   93.108905] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.108921] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.215528] ath: phy1: Set channel: 5805 MHz width: 0
[   93.215585] ath: phy1: Stopping ANI
[   93.215709] ath: phy1: Disable MIB counters
[   93.215802] ath: phy1: Reset to 5805 MHz, HT40: 0 fastcc: 1
[   93.215826] ath: phy1: NF calibrated [ctl] [chain 0] is -113
[   93.215840] ath: phy1: NF calibrated [ctl] [chain 1] is -113
[   93.215857] ath: phy1: MAC Hang signature not found at DCU complete
[   93.215871] ath: phy1: FastChannelChange for 5785 -> 5805
[   93.216812] ath: phy1: Enable MIB counters
[   93.216842] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.216858] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.323475] ath: phy1: Set channel: 5825 MHz width: 0
[   93.323532] ath: phy1: Stopping ANI
[   93.323656] ath: phy1: Disable MIB counters
[   93.323745] ath: phy1: Reset to 5825 MHz, HT40: 0 fastcc: 1
[   93.323769] ath: phy1: NF calibrated [ctl] [chain 0] is -113
[   93.323783] ath: phy1: NF calibrated [ctl] [chain 1] is -113
[   93.323800] ath: phy1: MAC Hang signature not found at DCU complete
[   93.323814] ath: phy1: FastChannelChange for 5805 -> 5825
[   93.324768] ath: phy1: Enable MIB counters
[   93.324799] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.324814] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.431425] ath: phy1: Set channel: 2412 MHz width: 0
[   93.431488] ath: phy1: Stopping ANI
[   93.431611] ath: phy1: Disable MIB counters
[   93.431713] ath: phy1: Reset to 2412 MHz, HT40: 0 fastcc: 0
[   93.431740] ath: phy1: NF calibrated [ctl] [chain 0] is -113
[   93.431754] ath: phy1: NF calibrated [ctl] [chain 1] is -113
[   93.432728] ath: phy1: ver 448.3 opmode 2 chan 2412 Mhz
[   93.432762] ath: phy1: ah->misc_mode 0x10000004
[   93.435680] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.435721] ath: phy1: IQ_RES[0]=0x114a7029 IQ_RES[1]=0xab0
[   93.435754] ath: phy1: IQ_RES[2]=0xcfd44b4 IQ_RES[3]=0x2200
[   93.435785] ath: phy1: IQ_RES[4]=0x2200f002 IQ_RES[5]=0xfc12
[   93.435808] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.435827] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   93.435846] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   93.435866] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   93.435884] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   93.435901] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.435936] ath: phy1: IQ_RES[0]=0x1350402a IQ_RES[1]=0xc00
[   93.435968] ath: phy1: IQ_RES[2]=0xefe5512 IQ_RES[3]=0x24b0
[   93.436000] ath: phy1: IQ_RES[4]=0x4f019000 IQ_RES[5]=0xfbb2
[   93.436024] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.436044] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   93.436062] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   93.436082] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   93.436101] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   93.436119] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.436153] ath: phy1: IQ_RES[0]=0x154eb02c IQ_RES[1]=0xc30
[   93.436186] ath: phy1: IQ_RES[2]=0x10fee4fb IQ_RES[3]=0x23f0
[   93.436220] ath: phy1: IQ_RES[4]=0x4501d002 IQ_RES[5]=0xfbc2
[   93.436244] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.436264] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   93.436283] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   93.436303] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   93.436322] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   93.436339] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.436370] ath: phy1: IQ_RES[0]=0x124ef030 IQ_RES[1]=0xc70
[   93.436400] ath: phy1: IQ_RES[2]=0xefee500 IQ_RES[3]=0x2420
[   93.436430] ath: phy1: IQ_RES[4]=0x49020ffe IQ_RES[5]=0xfbb2
[   93.436454] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.436473] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   93.436492] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   93.436513] ath: phy1: rx chain 0: mag corr=-7  phase corr=-5
[   93.436532] ath: phy1: rx chain 0: iq corr coeff=fffffc7b
[   93.436550] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.436585] ath: phy1: IQ_RES[0]=0x1753c035 IQ_RES[1]=0xd50
[   93.436617] ath: phy1: IQ_RES[2]=0x13ff354a IQ_RES[3]=0x2650
[   93.436649] ath: phy1: IQ_RES[4]=0x6b024ffe IQ_RES[5]=0xfb52
[   93.436673] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.436693] ath: phy1: tx chain 0: mag corr=-1  phase corr=-5
[   93.436712] ath: phy1: tx chain 0: iq corr coeff=ffffff7b
[   93.436733] ath: phy1: rx chain 0: mag corr=-6  phase corr=-7
[   93.436752] ath: phy1: rx chain 0: iq corr coeff=fffffcf9
[   93.436769] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.436805] ath: phy1: IQ_RES[0]=0xc641042 IQ_RES[1]=0x1090
[   93.436838] ath: phy1: IQ_RES[2]=0x13fdc659 IQ_RES[3]=0x2db0
[   93.436870] ath: phy1: IQ_RES[4]=0xe1024ff8 IQ_RES[5]=0xfa02
[   93.436895] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.436915] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   93.436934] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   93.436954] ath: phy1: rx chain 0: mag corr=-7  phase corr=-3
[   93.436974] ath: phy1: rx chain 0: iq corr coeff=fffffc7d
[   93.436994] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.437028] ath: phy1: IQ_RES[0]=0x54f3008 IQ_RES[1]=0x9f0
[   93.437060] ath: phy1: IQ_RES[2]=0x1dfd94fc IQ_RES[3]=0x24f0
[   93.437094] ath: phy1: IQ_RES[4]=0x5602affe IQ_RES[5]=0xfb72
[   93.437119] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.437139] ath: phy1: tx chain 1: mag corr=-4  phase corr=6
[   93.437158] ath: phy1: tx chain 1: iq corr coeff=fffffe06
[   93.437178] ath: phy1: rx chain 1: mag corr=3  phase corr=-7
[   93.437197] ath: phy1: rx chain 1: iq corr coeff=179
[   93.437213] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.437244] ath: phy1: IQ_RES[0]=0xff555001 IQ_RES[1]=0xa7f
[   93.437274] ath: phy1: IQ_RES[2]=0x1cfe155d IQ_RES[3]=0x27e0
[   93.437305] ath: phy1: IQ_RES[4]=0x8302f000 IQ_RES[5]=0xfb62
[   93.437328] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.437348] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   93.437367] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   93.437386] ath: phy1: rx chain 1: mag corr=4  phase corr=-5
[   93.437405] ath: phy1: rx chain 1: iq corr coeff=1fb
[   93.437422] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.437456] ath: phy1: IQ_RES[0]=0xfe532000 IQ_RES[1]=0xa3f
[   93.437489] ath: phy1: IQ_RES[2]=0x1afe553d IQ_RES[3]=0x26e0
[   93.437521] ath: phy1: IQ_RES[4]=0x74032003 IQ_RES[5]=0xfb72
[   93.437545] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.437564] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   93.437583] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   93.437602] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   93.437621] ath: phy1: rx chain 1: iq corr coeff=1fc
[   93.437639] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.437673] ath: phy1: IQ_RES[0]=0xfa52efff IQ_RES[1]=0xa2f
[   93.437706] ath: phy1: IQ_RES[2]=0x18fe853d IQ_RES[3]=0x26d0
[   93.437738] ath: phy1: IQ_RES[4]=0x72031002 IQ_RES[5]=0xfb82
[   93.437762] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.437781] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   93.437800] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   93.437820] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   93.437839] ath: phy1: rx chain 1: iq corr coeff=1fc
[   93.437856] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.437890] ath: phy1: IQ_RES[0]=0xfb573ffc IQ_RES[1]=0xa8f
[   93.437921] ath: phy1: IQ_RES[2]=0x19fe957f IQ_RES[3]=0x28d0
[   93.437951] ath: phy1: IQ_RES[4]=0x95034003 IQ_RES[5]=0xfb62
[   93.437972] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.437989] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   93.438007] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   93.438024] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   93.438041] ath: phy1: rx chain 1: iq corr coeff=1fc
[   93.438054] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.438080] ath: phy1: IQ_RES[0]=0xf666cffd IQ_RES[1]=0xc6f
[   93.438103] ath: phy1: IQ_RES[2]=0x1efde67c IQ_RES[3]=0x3020
[   93.438126] ath: phy1: IQ_RES[4]=0xa03a004 IQ_RES[5]=0xfa83
[   93.438141] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.438154] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   93.438166] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   93.438179] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[   93.438191] ath: phy1: rx chain 1: iq corr coeff=1fe
[   93.438249] ath: phy1: enabling IQ Calibration
[   93.438263] ath: phy1: starting IQ Mismatch Calibration
[   93.438311] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   93.438462] ath: phy1: Enable MIB counters
[   93.438491] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   93.438506] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.438521] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.438626] ath: phy1: Set power: 15
[   93.438739] ath: phy1: Set HW RX filter: 0x207
[   93.438864] ath: phy1: AWAKE -> FULL-SLEEP
[   93.606606] ath: phy1: FULL-SLEEP -> AWAKE
[   93.610126] ath: phy1: Set channel: 2412 MHz width: 0
[   93.610160] ath: phy1: Stopping ANI
[   93.610311] ath: phy1: Disable MIB counters
[   93.610393] ath: phy1: Reset to 2412 MHz, HT40: 0 fastcc: 0
[   93.611419] ath: phy1: ver 448.3 opmode 2 chan 2412 Mhz
[   93.611448] ath: phy1: ah->misc_mode 0x10000004
[   93.614331] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.614356] ath: phy1: IQ_RES[0]=0x144b6028 IQ_RES[1]=0xac0
[   93.614374] ath: phy1: IQ_RES[2]=0xdfd44c5 IQ_RES[3]=0x2260
[   93.614391] ath: phy1: IQ_RES[4]=0x2c011003 IQ_RES[5]=0xfc02
[   93.614402] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.614409] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   93.614416] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   93.614424] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   93.614431] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   93.614438] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.614457] ath: phy1: IQ_RES[0]=0x1451502a IQ_RES[1]=0xc40
[   93.614474] ath: phy1: IQ_RES[2]=0x10fe3524 IQ_RES[3]=0x2530
[   93.614491] ath: phy1: IQ_RES[4]=0x59018001 IQ_RES[5]=0xfba2
[   93.614500] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.614507] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   93.614514] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   93.614521] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   93.614528] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   93.614535] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.614554] ath: phy1: IQ_RES[0]=0x1650002e IQ_RES[1]=0xc60
[   93.614571] ath: phy1: IQ_RES[2]=0x10fef50e IQ_RES[3]=0x2460
[   93.614589] ath: phy1: IQ_RES[4]=0x4c01e001 IQ_RES[5]=0xfbb2
[   93.614597] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.614604] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   93.614610] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   93.614617] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[   93.614624] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[   93.614629] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.614648] ath: phy1: IQ_RES[0]=0x10504031 IQ_RES[1]=0xcb0
[   93.614666] ath: phy1: IQ_RES[2]=0x11fed512 IQ_RES[3]=0x2490
[   93.614684] ath: phy1: IQ_RES[4]=0x4e021ffe IQ_RES[5]=0xfb92
[   93.614692] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.614698] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   93.614704] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   93.614712] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[   93.614719] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[   93.614725] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.614745] ath: phy1: IQ_RES[0]=0x1854c036 IQ_RES[1]=0xdb0
[   93.614763] ath: phy1: IQ_RES[2]=0x13ff3564 IQ_RES[3]=0x26e0
[   93.614781] ath: phy1: IQ_RES[4]=0x75025000 IQ_RES[5]=0xfb42
[   93.614790] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.614798] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   93.614805] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   93.614812] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[   93.614820] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[   93.614826] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.614845] ath: phy1: IQ_RES[0]=0xe65b047 IQ_RES[1]=0x10b0
[   93.614862] ath: phy1: IQ_RES[2]=0x12fde671 IQ_RES[3]=0x2e80
[   93.614880] ath: phy1: IQ_RES[4]=0xee025ff9 IQ_RES[5]=0xfa12
[   93.614888] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.614896] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[   93.614903] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[   93.614911] ath: phy1: rx chain 0: mag corr=-8  phase corr=-3
[   93.614956] ath: phy1: rx chain 0: iq corr coeff=fffffbfd
[   93.614965] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.614984] ath: phy1: IQ_RES[0]=0x5508006 IQ_RES[1]=0x9e0
[   93.615006] ath: phy1: IQ_RES[2]=0x1cfd6510 IQ_RES[3]=0x2590
[   93.615023] ath: phy1: IQ_RES[4]=0x60028fff IQ_RES[5]=0xfb72
[   93.615032] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.615040] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   93.615062] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   93.615089] ath: phy1: rx chain 1: mag corr=3  phase corr=-6
[   93.615114] ath: phy1: rx chain 1: iq corr coeff=17a
[   93.615137] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.615173] ath: phy1: IQ_RES[0]=0x56b001 IQ_RES[1]=0xac0
[   93.615210] ath: phy1: IQ_RES[2]=0x1cfde577 IQ_RES[3]=0x2880
[   93.615248] ath: phy1: IQ_RES[4]=0x9002f001 IQ_RES[5]=0xfb32
[   93.615275] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.615302] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   93.615328] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   93.615351] ath: phy1: rx chain 1: mag corr=4  phase corr=-5
[   93.615374] ath: phy1: rx chain 1: iq corr coeff=1fb
[   93.615381] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.615400] ath: phy1: IQ_RES[0]=0xfb54bffe IQ_RES[1]=0xa6f
[   93.615417] ath: phy1: IQ_RES[2]=0x1afe3556 IQ_RES[3]=0x27b0
[   93.615434] ath: phy1: IQ_RES[4]=0x80031004 IQ_RES[5]=0xfb82
[   93.615442] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.615449] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   93.615456] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   93.615463] ath: phy1: rx chain 1: mag corr=5  phase corr=-3
[   93.615470] ath: phy1: rx chain 1: iq corr coeff=27d
[   93.615476] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.615495] ath: phy1: IQ_RES[0]=0xfc549ffb IQ_RES[1]=0xa1f
[   93.615513] ath: phy1: IQ_RES[2]=0x17fe7553 IQ_RES[3]=0x2770
[   93.615530] ath: phy1: IQ_RES[4]=0x81030002 IQ_RES[5]=0xfb72
[   93.615539] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.615546] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   93.615553] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   93.615561] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   93.615568] ath: phy1: rx chain 1: iq corr coeff=1fc
[   93.615574] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.615593] ath: phy1: IQ_RES[0]=0xf858cffb IQ_RES[1]=0xaaf
[   93.615611] ath: phy1: IQ_RES[2]=0x19fe959b IQ_RES[3]=0x2970
[   93.615628] ath: phy1: IQ_RES[4]=0x9f035003 IQ_RES[5]=0xfb72
[   93.615636] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.615643] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   93.615650] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   93.615657] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   93.615663] ath: phy1: rx chain 1: iq corr coeff=1fc
[   93.615668] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.615688] ath: phy1: IQ_RES[0]=0xf968effe IQ_RES[1]=0xcaf
[   93.615705] ath: phy1: IQ_RES[2]=0x1dfde69a IQ_RES[3]=0x3120
[   93.615723] ath: phy1: IQ_RES[4]=0x1a03c003 IQ_RES[5]=0xfa53
[   93.615731] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.615738] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   93.615745] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   93.615752] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   93.615759] ath: phy1: rx chain 1: iq corr coeff=1fd
[   93.615810] ath: phy1: enabling IQ Calibration
[   93.615820] ath: phy1: starting IQ Mismatch Calibration
[   93.615862] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   93.615967] ath: phy1: Enable MIB counters
[   93.615990] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   93.615999] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.616008] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.616119] ath: phy1: Set HW RX filter: 0x17
[   93.616158] ath: phy1: Set channel: 2412 MHz width: 0
[   93.616198] ath: phy1: Stopping ANI
[   93.616316] ath: phy1: Disable MIB counters
[   93.616376] ath: phy1: Reset to 2412 MHz, HT40: 0 fastcc: 0
[   93.616386] ath: phy1: NF did not complete in calibration window
[   93.617316] ath: phy1: ver 448.3 opmode 2 chan 2412 Mhz
[   93.617356] ath: phy1: ah->misc_mode 0x10000004
[   93.620237] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.620260] ath: phy1: IQ_RES[0]=0x124b402b IQ_RES[1]=0xad0
[   93.620278] ath: phy1: IQ_RES[2]=0xcfd54c5 IQ_RES[3]=0x2270
[   93.620296] ath: phy1: IQ_RES[4]=0x2a00f003 IQ_RES[5]=0xfc22
[   93.620305] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.620313] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   93.620320] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   93.620327] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[   93.620334] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[   93.620340] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.620359] ath: phy1: IQ_RES[0]=0xd51502b IQ_RES[1]=0xc40
[   93.620376] ath: phy1: IQ_RES[2]=0xdfdf522 IQ_RES[3]=0x2530
[   93.620393] ath: phy1: IQ_RES[4]=0x57019001 IQ_RES[5]=0xfba2
[   93.620402] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.620409] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   93.620416] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   93.620423] ath: phy1: rx chain 0: mag corr=-5  phase corr=-3
[   93.620430] ath: phy1: rx chain 0: iq corr coeff=fffffd7d
[   93.620435] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.620454] ath: phy1: IQ_RES[0]=0x144fc02a IQ_RES[1]=0xc40
[   93.620471] ath: phy1: IQ_RES[2]=0x10fee50e IQ_RES[3]=0x2460
[   93.620490] ath: phy1: IQ_RES[4]=0x4d01d001 IQ_RES[5]=0xfb92
[   93.620498] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.620505] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   93.620512] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   93.620518] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   93.620524] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   93.620530] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.620550] ath: phy1: IQ_RES[0]=0xe50402e IQ_RES[1]=0xcb0
[   93.620568] ath: phy1: IQ_RES[2]=0xffec513 IQ_RES[3]=0x2480
[   93.620585] ath: phy1: IQ_RES[4]=0x4f020fff IQ_RES[5]=0xfb92
[   93.620592] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.620599] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   93.620606] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   93.620613] ath: phy1: rx chain 0: mag corr=-6  phase corr=-3
[   93.620619] ath: phy1: rx chain 0: iq corr coeff=fffffcfd
[   93.620625] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.620645] ath: phy1: IQ_RES[0]=0x1454f034 IQ_RES[1]=0xdc0
[   93.620662] ath: phy1: IQ_RES[2]=0x14ff3560 IQ_RES[3]=0x26e0
[   93.620680] ath: phy1: IQ_RES[4]=0x75025ffd IQ_RES[5]=0xfb32
[   93.620689] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.620697] ath: phy1: tx chain 0: mag corr=-1  phase corr=-4
[   93.620704] ath: phy1: tx chain 0: iq corr coeff=ffffff7c
[   93.620711] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[   93.620719] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[   93.620725] ath: phy1: Doing Tx IQ Cal for chain 0
[   93.620745] ath: phy1: IQ_RES[0]=0xc65b048 IQ_RES[1]=0x10c0
[   93.620763] ath: phy1: IQ_RES[2]=0x11fda66e IQ_RES[3]=0x2e70
[   93.620780] ath: phy1: IQ_RES[4]=0xed025ff9 IQ_RES[5]=0xf9f2
[   93.620788] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   93.620796] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[   93.620803] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[   93.620810] ath: phy1: rx chain 0: mag corr=-8  phase corr=-2
[   93.620817] ath: phy1: rx chain 0: iq corr coeff=fffffbfe
[   93.620826] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.620845] ath: phy1: IQ_RES[0]=0x6505009 IQ_RES[1]=0x9f0
[   93.620862] ath: phy1: IQ_RES[2]=0x1dfd750c IQ_RES[3]=0x2570
[   93.620879] ath: phy1: IQ_RES[4]=0x5e02afff IQ_RES[5]=0xfb72
[   93.620887] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.620895] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   93.620902] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   93.620909] ath: phy1: rx chain 1: mag corr=3  phase corr=-6
[   93.620915] ath: phy1: rx chain 1: iq corr coeff=17a
[   93.620921] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.620941] ath: phy1: IQ_RES[0]=0x567fff IQ_RES[1]=0xa70
[   93.620960] ath: phy1: IQ_RES[2]=0x1cfdf571 IQ_RES[3]=0x2880
[   93.620978] ath: phy1: IQ_RES[4]=0x8e032001 IQ_RES[5]=0xfb52
[   93.620986] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.620993] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   93.621000] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   93.621007] ath: phy1: rx chain 1: mag corr=4  phase corr=-6
[   93.621014] ath: phy1: rx chain 1: iq corr coeff=1fa
[   93.621020] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.621042] ath: phy1: IQ_RES[0]=0xff545ffe IQ_RES[1]=0xa2f
[   93.621059] ath: phy1: IQ_RES[2]=0x1afea555 IQ_RES[3]=0x27a0
[   93.621077] ath: phy1: IQ_RES[4]=0x7e031002 IQ_RES[5]=0xfb72
[   93.621086] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.621093] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   93.621101] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   93.621108] ath: phy1: rx chain 1: mag corr=4  phase corr=-5
[   93.621115] ath: phy1: rx chain 1: iq corr coeff=1fb
[   93.621122] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.621141] ath: phy1: IQ_RES[0]=0xfa543ffc IQ_RES[1]=0xa1f
[   93.621160] ath: phy1: IQ_RES[2]=0x17fe6551 IQ_RES[3]=0x2760
[   93.621178] ath: phy1: IQ_RES[4]=0x7f033003 IQ_RES[5]=0xfb92
[   93.621187] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.621195] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   93.621202] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   93.621209] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   93.621216] ath: phy1: rx chain 1: iq corr coeff=1fd
[   93.621222] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.621242] ath: phy1: IQ_RES[0]=0xf9589000 IQ_RES[1]=0xacf
[   93.621260] ath: phy1: IQ_RES[2]=0x19fe9596 IQ_RES[3]=0x2970
[   93.621297] ath: phy1: IQ_RES[4]=0xa1034002 IQ_RES[5]=0xfb32
[   93.621307] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.621315] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   93.621321] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   93.621329] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   93.621335] ath: phy1: rx chain 1: iq corr coeff=17d
[   93.621342] ath: phy1: Doing Tx IQ Cal for chain 1
[   93.621361] ath: phy1: IQ_RES[0]=0xf8686ff8 IQ_RES[1]=0xcbf
[   93.621380] ath: phy1: IQ_RES[2]=0x1cfe0695 IQ_RES[3]=0x30d0
[   93.621397] ath: phy1: IQ_RES[4]=0x1503d003 IQ_RES[5]=0xfa53
[   93.621406] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   93.621413] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   93.621420] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   93.621428] ath: phy1: rx chain 1: mag corr=5  phase corr=-4
[   93.621434] ath: phy1: rx chain 1: iq corr coeff=27c
[   93.621485] ath: phy1: enabling IQ Calibration
[   93.621494] ath: phy1: starting IQ Mismatch Calibration
[   93.621538] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   93.621646] ath: phy1: Enable MIB counters
[   93.621669] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   93.621677] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.621685] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.675208] ath: phy1: Set channel: 2417 MHz width: 0
[   93.675236] ath: phy1: Stopping ANI
[   93.675344] ath: phy1: Disable MIB counters
[   93.675404] ath: phy1: Reset to 2417 MHz, HT40: 0 fastcc: 1
[   93.675417] ath: phy1: NF calibrated [ctl] [chain 0] is -101
[   93.675422] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   93.675431] ath: phy1: MAC Hang signature not found at DCU complete
[   93.675436] ath: phy1: FastChannelChange for 2412 -> 2417
[   93.676353] ath: phy1: Enable MIB counters
[   93.676373] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.676378] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.676403] ath: phy1: Set power: 16
[   93.731005] ath: phy1: Set channel: 2422 MHz width: 0
[   93.731061] ath: phy1: Stopping ANI
[   93.731218] ath: phy1: Disable MIB counters
[   93.731423] ath: phy1: Reset to 2422 MHz, HT40: 0 fastcc: 1
[   93.731459] ath: phy1: NF calibrated [ctl] [chain 0] is -101
[   93.731470] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   93.731483] ath: phy1: MAC Hang signature not found at DCU complete
[   93.731494] ath: phy1: FastChannelChange for 2417 -> 2422
[   93.732550] ath: phy1: Enable MIB counters
[   93.732589] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.732609] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.787211] ath: phy1: Set channel: 2427 MHz width: 0
[   93.787269] ath: phy1: Stopping ANI
[   93.787426] ath: phy1: Disable MIB counters
[   93.787627] ath: phy1: Reset to 2427 MHz, HT40: 0 fastcc: 1
[   93.787655] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   93.787669] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   93.787687] ath: phy1: MAC Hang signature not found at DCU complete
[   93.787701] ath: phy1: FastChannelChange for 2422 -> 2427
[   93.788702] ath: phy1: Enable MIB counters
[   93.788731] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.788746] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.843117] ath: phy1: Set channel: 2432 MHz width: 0
[   93.843153] ath: phy1: Stopping ANI
[   93.843265] ath: phy1: Disable MIB counters
[   93.843328] ath: phy1: Reset to 2432 MHz, HT40: 0 fastcc: 1
[   93.843341] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   93.843347] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   93.843355] ath: phy1: MAC Hang signature not found at DCU complete
[   93.843360] ath: phy1: FastChannelChange for 2427 -> 2432
[   93.844279] ath: phy1: Enable MIB counters
[   93.844298] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.844304] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.899132] ath: phy1: Set channel: 2437 MHz width: 0
[   93.899190] ath: phy1: Stopping ANI
[   93.899343] ath: phy1: Disable MIB counters
[   93.899607] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 1
[   93.899638] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[   93.899652] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   93.899669] ath: phy1: MAC Hang signature not found at DCU complete
[   93.899683] ath: phy1: FastChannelChange for 2432 -> 2437
[   93.900681] ath: phy1: Enable MIB counters
[   93.900711] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.900726] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   93.955086] ath: phy1: Set channel: 2442 MHz width: 0
[   93.955145] ath: phy1: Stopping ANI
[   93.955296] ath: phy1: Disable MIB counters
[   93.955502] ath: phy1: Reset to 2442 MHz, HT40: 0 fastcc: 1
[   93.955521] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   93.955529] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   93.955539] ath: phy1: MAC Hang signature not found at DCU complete
[   93.955546] ath: phy1: FastChannelChange for 2437 -> 2442
[   93.956549] ath: phy1: Enable MIB counters
[   93.956579] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   93.956594] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.011081] ath: phy1: Set channel: 2447 MHz width: 0
[   94.011141] ath: phy1: Stopping ANI
[   94.011292] ath: phy1: Disable MIB counters
[   94.011559] ath: phy1: Reset to 2447 MHz, HT40: 0 fastcc: 1
[   94.011588] ath: phy1: NF calibrated [ctl] [chain 0] is -97
[   94.011602] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.011619] ath: phy1: MAC Hang signature not found at DCU complete
[   94.011632] ath: phy1: FastChannelChange for 2442 -> 2447
[   94.012635] ath: phy1: Enable MIB counters
[   94.012665] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.012680] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.067072] ath: phy1: Set channel: 2452 MHz width: 0
[   94.067133] ath: phy1: Stopping ANI
[   94.067284] ath: phy1: Disable MIB counters
[   94.067508] ath: phy1: Reset to 2452 MHz, HT40: 0 fastcc: 1
[   94.067539] ath: phy1: NF calibrated [ctl] [chain 0] is -97
[   94.067553] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.067570] ath: phy1: MAC Hang signature not found at DCU complete
[   94.067583] ath: phy1: FastChannelChange for 2447 -> 2452
[   94.068581] ath: phy1: Enable MIB counters
[   94.068612] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.068627] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.122801] ath: phy1: Set channel: 2457 MHz width: 0
[   94.122836] ath: phy1: Stopping ANI
[   94.122951] ath: phy1: Disable MIB counters
[   94.123074] ath: phy1: Reset to 2457 MHz, HT40: 0 fastcc: 1
[   94.123089] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   94.123095] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.123104] ath: phy1: MAC Hang signature not found at DCU complete
[   94.123110] ath: phy1: FastChannelChange for 2452 -> 2457
[   94.124085] ath: phy1: Enable MIB counters
[   94.124104] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.124110] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.179002] ath: phy1: Set channel: 2462 MHz width: 0
[   94.179060] ath: phy1: Stopping ANI
[   94.179211] ath: phy1: Disable MIB counters
[   94.179457] ath: phy1: Reset to 2462 MHz, HT40: 0 fastcc: 1
[   94.179489] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   94.179502] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.179519] ath: phy1: MAC Hang signature not found at DCU complete
[   94.179533] ath: phy1: FastChannelChange for 2457 -> 2462
[   94.180586] ath: phy1: Enable MIB counters
[   94.180616] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.180631] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.180670] ath: phy1: Set power: 15
[   94.234726] ath: phy1: Set channel: 2467 MHz width: 0
[   94.234762] ath: phy1: Stopping ANI
[   94.234878] ath: phy1: Disable MIB counters
[   94.234987] ath: phy1: Reset to 2467 MHz, HT40: 0 fastcc: 1
[   94.235003] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   94.235009] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.235020] ath: phy1: MAC Hang signature not found at DCU complete
[   94.235027] ath: phy1: FastChannelChange for 2462 -> 2467
[   94.236009] ath: phy1: Enable MIB counters
[   94.236030] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.236037] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.236063] ath: phy1: Set power: 16
[   94.342947] ath: phy1: Set channel: 2472 MHz width: 0
[   94.343009] ath: phy1: Stopping ANI
[   94.343126] ath: phy1: Disable MIB counters
[   94.343311] ath: phy1: Reset to 2472 MHz, HT40: 0 fastcc: 1
[   94.343332] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[   94.343341] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.343353] ath: phy1: MAC Hang signature not found at DCU complete
[   94.343363] ath: phy1: FastChannelChange for 2467 -> 2472
[   94.344434] ath: phy1: Enable MIB counters
[   94.344469] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.344485] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.450873] ath: phy1: Set channel: 5180 MHz width: 0
[   94.450933] ath: phy1: Stopping ANI
[   94.451058] ath: phy1: Disable MIB counters
[   94.451150] ath: phy1: Reset to 5180 MHz, HT40: 0 fastcc: 1
[   94.451174] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   94.451188] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[   94.452099] ath: phy1: ver 448.3 opmode 2 chan 5180 Mhz
[   94.452133] ath: phy1: ah->misc_mode 0x10000004
[   94.454702] ath: phy1: enabling IQ Calibration
[   94.454725] ath: phy1: starting IQ Mismatch Calibration
[   94.454918] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   94.455114] ath: phy1: Enable MIB counters
[   94.455153] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   94.455174] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   94.455273] ath: phy1: Set power: 15
root@mio:~# ping 192.168.5.1
PING 192.168.5.1 (192.168.5.1) 56(84) bytes of data.
>From 192.168.5.147 icmp_seq=1 Destination Host Unreachable
>From 192.168.5.147 icmp_seq=2 Destination Host Unreachable
64 bytes from 192.168.5.1: icmp_seq=5 ttl=64 time=2204 ms
64 bytes from 192.168.5.1: icmp_seq=6 ttl=64 time=1204 ms
64 bytes from 192.168.5.1: icmp_seq=7 ttl=64 time=204 ms
64 bytes from 192.168.5.1: icmp_seq=8 ttl=64 time=1153 ms
^C
--- 192.168.5.1 ping statistics ---
9 packets transmitted, 4 received, +2 errors, 55% packet loss, time 8009ms
rtt min/avg/max/mdev = 204.923/1191.893/2204.392/707.262 ms, pipe 4
root@mio:~# dmesg
[   95.863718] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.863740] ath: phy1: IQ_RES[0]=0xfc529ffb IQ_RES[1]=0x9ff
[   95.863760] ath: phy1: IQ_RES[2]=0x1afe6535 IQ_RES[3]=0x2680
[   95.863780] ath: phy1: IQ_RES[4]=0x6d02f001 IQ_RES[5]=0xfba2
[   95.863791] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.863800] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   95.863809] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   95.863819] ath: phy1: rx chain 1: mag corr=5  phase corr=-5
[   95.863827] ath: phy1: rx chain 1: iq corr coeff=27b
[   95.863836] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.863857] ath: phy1: IQ_RES[0]=0xfb56bffd IQ_RES[1]=0xa4f
[   95.863877] ath: phy1: IQ_RES[2]=0x19fe5578 IQ_RES[3]=0x28a0
[   95.863896] ath: phy1: IQ_RES[4]=0x91033004 IQ_RES[5]=0xfb62
[   95.863907] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.863916] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   95.863925] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   95.863935] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   95.863944] ath: phy1: rx chain 1: iq corr coeff=1fd
[   95.863952] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.863974] ath: phy1: IQ_RES[0]=0xfa662ffb IQ_RES[1]=0xc5f
[   95.863994] ath: phy1: IQ_RES[2]=0x1efd9673 IQ_RES[3]=0x2fd0
[   95.864013] ath: phy1: IQ_RES[4]=0x703a004 IQ_RES[5]=0xfa83
[   95.864024] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.864034] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[   95.864043] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[   95.864052] ath: phy1: rx chain 1: mag corr=5  phase corr=-3
[   95.864061] ath: phy1: rx chain 1: iq corr coeff=27d
[   95.864114] ath: phy1: enabling IQ Calibration
[   95.864125] ath: phy1: starting IQ Mismatch Calibration
[   95.864177] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   95.864333] ath: phy1: Enable MIB counters
[   95.864391] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   95.864441] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   95.864490] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   95.864603] ath: phy1: Set power: 15
[   95.864706] ath: phy1: Set HW RX filter: 0x207
[   95.864849] ath: phy1: AWAKE -> FULL-SLEEP
[   95.864910] ath: phy1: FULL-SLEEP -> AWAKE
[   95.867772] ath: phy1: Set channel: 2412 MHz width: 0
[   95.867810] ath: phy1: Stopping ANI
[   95.867965] ath: phy1: Disable MIB counters
[   95.868035] ath: phy1: Reset to 2412 MHz, HT40: 0 fastcc: 0
[   95.869037] ath: phy1: ver 448.3 opmode 2 chan 2412 Mhz
[   95.869066] ath: phy1: ah->misc_mode 0x10000004
[   95.871945] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.871965] ath: phy1: IQ_RES[0]=0x134a3026 IQ_RES[1]=0xaa0
[   95.871981] ath: phy1: IQ_RES[2]=0xdfd34ae IQ_RES[3]=0x21c0
[   95.871997] ath: phy1: IQ_RES[4]=0x21010001 IQ_RES[5]=0xfc02
[   95.872005] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.872011] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   95.872017] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   95.872024] ath: phy1: rx chain 0: mag corr=-5  phase corr=-7
[   95.872030] ath: phy1: rx chain 0: iq corr coeff=fffffd79
[   95.872036] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.872054] ath: phy1: IQ_RES[0]=0xf50102d IQ_RES[1]=0xc10
[   95.872070] ath: phy1: IQ_RES[2]=0xefe050e IQ_RES[3]=0x2490
[   95.872086] ath: phy1: IQ_RES[4]=0x4d018002 IQ_RES[5]=0xfba2
[   95.872093] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.872100] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   95.872106] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   95.872112] ath: phy1: rx chain 0: mag corr=-5  phase corr=-3
[   95.872119] ath: phy1: rx chain 0: iq corr coeff=fffffd7d
[   95.872124] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.872142] ath: phy1: IQ_RES[0]=0x124e702c IQ_RES[1]=0xc30
[   95.872158] ath: phy1: IQ_RES[2]=0x12fed4f7 IQ_RES[3]=0x23a0
[   95.872174] ath: phy1: IQ_RES[4]=0x4101e000 IQ_RES[5]=0xfbc2
[   95.872181] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.872188] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[   95.872194] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[   95.872200] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   95.872206] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   95.872212] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.872230] ath: phy1: IQ_RES[0]=0x104ec031 IQ_RES[1]=0xc50
[   95.872246] ath: phy1: IQ_RES[2]=0xffec4fe IQ_RES[3]=0x23f0
[   95.872262] ath: phy1: IQ_RES[4]=0x4401f000 IQ_RES[5]=0xfba2
[   95.872269] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.872276] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   95.872282] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   95.872288] ath: phy1: rx chain 0: mag corr=-6  phase corr=-4
[   95.872294] ath: phy1: rx chain 0: iq corr coeff=fffffcfc
[   95.872300] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.872318] ath: phy1: IQ_RES[0]=0x14537033 IQ_RES[1]=0xd60
[   95.872334] ath: phy1: IQ_RES[2]=0x12ff054b IQ_RES[3]=0x2620
[   95.872350] ath: phy1: IQ_RES[4]=0x66023ffd IQ_RES[5]=0xfb42
[   95.872357] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.872363] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   95.872369] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   95.872376] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[   95.872382] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[   95.872388] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.872405] ath: phy1: IQ_RES[0]=0xc63f044 IQ_RES[1]=0x1060
[   95.872422] ath: phy1: IQ_RES[2]=0x13fdb653 IQ_RES[3]=0x2da0
[   95.872438] ath: phy1: IQ_RES[4]=0xe1025ff9 IQ_RES[5]=0xfa12
[   95.872445] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.872451] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   95.872457] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   95.872464] ath: phy1: rx chain 0: mag corr=-7  phase corr=-3
[   95.872470] ath: phy1: rx chain 0: iq corr coeff=fffffc7d
[   95.872477] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.872495] ath: phy1: IQ_RES[0]=0x64ed00a IQ_RES[1]=0x9d0
[   95.872511] ath: phy1: IQ_RES[2]=0x1dfd74f7 IQ_RES[3]=0x24e0
[   95.872527] ath: phy1: IQ_RES[4]=0x5202affe IQ_RES[5]=0xfb72
[   95.872534] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.872541] ath: phy1: tx chain 1: mag corr=-4  phase corr=6
[   95.872547] ath: phy1: tx chain 1: iq corr coeff=fffffe06
[   95.872553] ath: phy1: rx chain 1: mag corr=3  phase corr=-7
[   95.872559] ath: phy1: rx chain 1: iq corr coeff=179
[   95.872565] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.872583] ath: phy1: IQ_RES[0]=0x154ffff IQ_RES[1]=0xa70
[   95.872598] ath: phy1: IQ_RES[2]=0x1bfde559 IQ_RES[3]=0x27c0
[   95.872614] ath: phy1: IQ_RES[4]=0x80030001 IQ_RES[5]=0xfb52
[   95.872622] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.872628] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   95.872634] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   95.872640] ath: phy1: rx chain 1: mag corr=4  phase corr=-6
[   95.872646] ath: phy1: rx chain 1: iq corr coeff=1fa
[   95.872652] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.872670] ath: phy1: IQ_RES[0]=0xfb52dffe IQ_RES[1]=0xa0f
[   95.872686] ath: phy1: IQ_RES[2]=0x19fe8538 IQ_RES[3]=0x26b0
[   95.872702] ath: phy1: IQ_RES[4]=0x73030001 IQ_RES[5]=0xfb62
[   95.872709] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.872715] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   95.872722] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   95.872728] ath: phy1: rx chain 1: mag corr=4  phase corr=-4
[   95.872734] ath: phy1: rx chain 1: iq corr coeff=1fc
[   95.872740] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.872757] ath: phy1: IQ_RES[0]=0xf952cffd IQ_RES[1]=0x9df
[   95.872774] ath: phy1: IQ_RES[2]=0x18fe7537 IQ_RES[3]=0x26c0
[   95.872789] ath: phy1: IQ_RES[4]=0x73030004 IQ_RES[5]=0xfb72
[   95.872797] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.872803] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   95.872809] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   95.872815] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   95.872822] ath: phy1: rx chain 1: iq corr coeff=1fd
[   95.872827] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.872845] ath: phy1: IQ_RES[0]=0xfa56effc IQ_RES[1]=0xa7f
[   95.872861] ath: phy1: IQ_RES[2]=0x17fe857b IQ_RES[3]=0x28c0
[   95.872877] ath: phy1: IQ_RES[4]=0x91031003 IQ_RES[5]=0xfb62
[   95.872884] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.872890] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   95.872896] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   95.872903] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   95.872909] ath: phy1: rx chain 1: iq corr coeff=1fd
[   95.872914] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.872932] ath: phy1: IQ_RES[0]=0xf6667ffb IQ_RES[1]=0xc5f
[   95.872948] ath: phy1: IQ_RES[2]=0x1dfde676 IQ_RES[3]=0x3010
[   95.872964] ath: phy1: IQ_RES[4]=0x7039004 IQ_RES[5]=0xfa83
[   95.872971] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.872977] ath: phy1: tx chain 1: mag corr=-2  phase corr=8
[   95.872984] ath: phy1: tx chain 1: iq corr coeff=ffffff08
[   95.872990] ath: phy1: rx chain 1: mag corr=5  phase corr=-2
[   95.872996] ath: phy1: rx chain 1: iq corr coeff=27e
[   95.873044] ath: phy1: enabling IQ Calibration
[   95.873051] ath: phy1: starting IQ Mismatch Calibration
[   95.873091] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   95.873188] ath: phy1: Enable MIB counters
[   95.873206] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
is_scanning=0 ofdm:3 cck:2
[   95.873213] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   95.873221] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   95.873306] ath: phy1: Set channel: 2437 MHz width: 0
[   95.873329] ath: phy1: Stopping ANI
[   95.873426] ath: phy1: Disable MIB counters
[   95.873472] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[   95.873481] ath: phy1: NF did not complete in calibration window
[   95.874329] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[   95.874353] ath: phy1: ah->misc_mode 0x10000004
[   95.877189] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.877208] ath: phy1: IQ_RES[0]=0xb51902b IQ_RES[1]=0x9c0
[   95.877224] ath: phy1: IQ_RES[2]=0xcf9f526 IQ_RES[3]=0x2500
[   95.877240] ath: phy1: IQ_RES[4]=0x56ff7001 IQ_RES[5]=0xfba2
[   95.877248] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.877254] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   95.877260] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   95.877267] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[   95.877273] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[   95.877279] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.877296] ath: phy1: IQ_RES[0]=0xb57c02e IQ_RES[1]=0xba0
[   95.877312] ath: phy1: IQ_RES[2]=0xdfa858e IQ_RES[3]=0x27e0
[   95.877329] ath: phy1: IQ_RES[4]=0x84ffd001 IQ_RES[5]=0xfb52
[   95.877336] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.877342] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   95.877348] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   95.877355] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[   95.877361] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[   95.877366] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.877384] ath: phy1: IQ_RES[0]=0xf55c02e IQ_RES[1]=0xbd0
[   95.877400] ath: phy1: IQ_RES[2]=0xefaf569 IQ_RES[3]=0x2710
[   95.877416] ath: phy1: IQ_RES[4]=0x76005001 IQ_RES[5]=0xfb22
[   95.877424] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.877430] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   95.877436] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   95.877442] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   95.877449] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   95.877454] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.877472] ath: phy1: IQ_RES[0]=0xb55e032 IQ_RES[1]=0xc30
[   95.877488] ath: phy1: IQ_RES[2]=0xdfb156e IQ_RES[3]=0x2720
[   95.877504] ath: phy1: IQ_RES[4]=0x77005ffe IQ_RES[5]=0xfb02
[   95.877511] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.877518] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   95.877524] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   95.877531] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[   95.877537] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[   95.877542] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.877560] ath: phy1: IQ_RES[0]=0xe5b0035 IQ_RES[1]=0xd50
[   95.877577] ath: phy1: IQ_RES[2]=0x10fb35c0 IQ_RES[3]=0x2960
[   95.877593] ath: phy1: IQ_RES[4]=0x9e00affb IQ_RES[5]=0xfac2
[   95.877600] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.877606] ath: phy1: tx chain 0: mag corr=-1  phase corr=-4
[   95.877612] ath: phy1: tx chain 0: iq corr coeff=ffffff7c
[   95.877619] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[   95.877625] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[   95.877631] ath: phy1: Doing Tx IQ Cal for chain 0
[   95.877649] ath: phy1: IQ_RES[0]=0x76c1045 IQ_RES[1]=0xfc0
[   95.877665] ath: phy1: IQ_RES[2]=0xff916d3 IQ_RES[3]=0x3120
[   95.877681] ath: phy1: IQ_RES[4]=0x1a003ffb IQ_RES[5]=0xf973
[   95.877688] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   95.877694] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   95.877700] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   95.877707] ath: phy1: rx chain 0: mag corr=-7  phase corr=-4
[   95.877713] ath: phy1: rx chain 0: iq corr coeff=fffffc7c
[   95.877720] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.877738] ath: phy1: IQ_RES[0]=0x9565018 IQ_RES[1]=0xa20
[   95.877754] ath: phy1: IQ_RES[2]=0x23fa6574 IQ_RES[3]=0x2860
[   95.877770] ath: phy1: IQ_RES[4]=0x8a017ffa IQ_RES[5]=0xfaa2
[   95.877778] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.877805] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   95.877812] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   95.877819] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[   95.877843] ath: phy1: rx chain 1: iq corr coeff=fd
[   95.877864] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.877896] ath: phy1: IQ_RES[0]=0x55ce00f IQ_RES[1]=0xb00
[   95.877925] ath: phy1: IQ_RES[2]=0x22faa5dc IQ_RES[3]=0x2b50
[   95.877954] ath: phy1: IQ_RES[4]=0xbd01effb IQ_RES[5]=0xfa62
[   95.877975] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.877997] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   95.878022] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   95.878043] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   95.878068] ath: phy1: rx chain 1: iq corr coeff=17d
[   95.878088] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.878121] ath: phy1: IQ_RES[0]=0x55a600e IQ_RES[1]=0xad0
[   95.878149] ath: phy1: IQ_RES[2]=0x21fb65b3 IQ_RES[3]=0x2a30
[   95.878165] ath: phy1: IQ_RES[4]=0xaa022ffd IQ_RES[5]=0xfa92
[   95.878172] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.878178] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   95.878185] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   95.878191] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[   95.878197] ath: phy1: rx chain 1: iq corr coeff=17c
[   95.878202] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.878220] ath: phy1: IQ_RES[0]=0x35a100b IQ_RES[1]=0xab0
[   95.878236] ath: phy1: IQ_RES[2]=0x1efb85b2 IQ_RES[3]=0x2a20
[   95.878252] ath: phy1: IQ_RES[4]=0xa5020fff IQ_RES[5]=0xfac2
[   95.878259] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.878266] ath: phy1: tx chain 1: mag corr=-2  phase corr=6
[   95.878272] ath: phy1: tx chain 1: iq corr coeff=ffffff06
[   95.878278] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   95.878284] ath: phy1: rx chain 1: iq corr coeff=17e
[   95.878290] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.878308] ath: phy1: IQ_RES[0]=0x45e2009 IQ_RES[1]=0xb80
[   95.878324] ath: phy1: IQ_RES[2]=0x20fb45f4 IQ_RES[3]=0x2be0
[   95.878340] ath: phy1: IQ_RES[4]=0xc4025ffd IQ_RES[5]=0xfa72
[   95.878347] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.878353] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   95.878359] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   95.878366] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[   95.878372] ath: phy1: rx chain 1: iq corr coeff=17c
[   95.878377] ath: phy1: Doing Tx IQ Cal for chain 1
[   95.878395] ath: phy1: IQ_RES[0]=0x36e3008 IQ_RES[1]=0xd40
[   95.878411] ath: phy1: IQ_RES[2]=0x26fa26f6 IQ_RES[3]=0x3370
[   95.878427] ath: phy1: IQ_RES[4]=0x41028ffd IQ_RES[5]=0xf993
[   95.878434] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   95.878440] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   95.878446] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   95.878453] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[   95.878459] ath: phy1: rx chain 1: iq corr coeff=1fd
[   95.878506] ath: phy1: enabling IQ Calibration
[   95.878514] ath: phy1: starting IQ Mismatch Calibration
[   95.878553] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   95.878648] ath: phy1: Enable MIB counters
[   95.878666] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:2
[   95.878673] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   95.878680] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   95.878733] ath: phy1: Set power: 16
[   95.878801] ath: phy1: Caching beacon data for BSS: 00:02:6f:22:0a:8a
[   95.878823] ath: phy1: STA is not yet associated..skipping beacon config
[   95.878978] wlan0: send auth to 00:02:6f:22:0a:8a (try 1/3)
[   96.861417] wlan0: send auth to 00:02:6f:22:0a:8a (try 2/3)
[   96.877586] ath: phy1: tx hung, resetting the chip
[   96.877665] ath: phy1: Stopping ANI
[   96.877865] ath: phy1: Disable MIB counters
[   96.878023] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[   96.878053] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   96.878067] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   96.878814] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[   96.878847] ath: phy1: ah->misc_mode 0x10000004
[   96.881734] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.881772] ath: phy1: IQ_RES[0]=0xb517028 IQ_RES[1]=0x9b0
[   96.881803] ath: phy1: IQ_RES[2]=0xbfa0528 IQ_RES[3]=0x2510
[   96.881832] ath: phy1: IQ_RES[4]=0x56ff5002 IQ_RES[5]=0xfbb2
[   96.881853] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.881872] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   96.881890] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   96.881909] ath: phy1: rx chain 0: mag corr=-4  phase corr=-4
[   96.881926] ath: phy1: rx chain 0: iq corr coeff=fffffdfc
[   96.881941] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.881973] ath: phy1: IQ_RES[0]=0xf57b02b IQ_RES[1]=0xb80
[   96.882003] ath: phy1: IQ_RES[2]=0xcfa758c IQ_RES[3]=0x27f0
[   96.882033] ath: phy1: IQ_RES[4]=0x84ffd000 IQ_RES[5]=0xfb42
[   96.882056] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.882077] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   96.882096] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   96.882116] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[   96.882135] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[   96.882153] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.882187] ath: phy1: IQ_RES[0]=0x1255a02d IQ_RES[1]=0xbd0
[   96.882220] ath: phy1: IQ_RES[2]=0x10fb556c IQ_RES[3]=0x2710
[   96.882254] ath: phy1: IQ_RES[4]=0x78006fff IQ_RES[5]=0xfaf2
[   96.882278] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.882298] ath: phy1: tx chain 0: mag corr=-1  phase corr=-3
[   96.882318] ath: phy1: tx chain 0: iq corr coeff=ffffff7d
[   96.882338] ath: phy1: rx chain 0: mag corr=-4  phase corr=-7
[   96.882357] ath: phy1: rx chain 0: iq corr coeff=fffffdf9
[   96.882375] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.882409] ath: phy1: IQ_RES[0]=0xc559034 IQ_RES[1]=0xc00
[   96.882442] ath: phy1: IQ_RES[2]=0xdfb356c IQ_RES[3]=0x2720
[   96.882475] ath: phy1: IQ_RES[4]=0x78006ffd IQ_RES[5]=0xfb02
[   96.882499] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.882520] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   96.882539] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   96.882560] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[   96.882578] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[   96.882596] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.882629] ath: phy1: IQ_RES[0]=0xc5b0039 IQ_RES[1]=0xd40
[   96.882662] ath: phy1: IQ_RES[2]=0xefb55c0 IQ_RES[3]=0x2950
[   96.882695] ath: phy1: IQ_RES[4]=0x9c009ffc IQ_RES[5]=0xfab2
[   96.882719] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.882739] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   96.882758] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   96.882778] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[   96.882797] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[   96.882814] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.882848] ath: phy1: IQ_RES[0]=0x86c0047 IQ_RES[1]=0xfc0
[   96.882882] ath: phy1: IQ_RES[2]=0xff976d2 IQ_RES[3]=0x3110
[   96.882915] ath: phy1: IQ_RES[4]=0x16001ff9 IQ_RES[5]=0xf983
[   96.882939] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.882959] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[   96.882978] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[   96.882999] ath: phy1: rx chain 0: mag corr=-7  phase corr=-4
[   96.883018] ath: phy1: rx chain 0: iq corr coeff=fffffc7c
[   96.883039] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.883073] ath: phy1: IQ_RES[0]=0x556b018 IQ_RES[1]=0xa60
[   96.883106] ath: phy1: IQ_RES[2]=0x24fa1576 IQ_RES[3]=0x2850
[   96.883139] ath: phy1: IQ_RES[4]=0x8c018ff9 IQ_RES[5]=0xfa92
[   96.883163] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.883181] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.883198] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.883215] ath: phy1: rx chain 1: mag corr=2  phase corr=-2
[   96.883233] ath: phy1: rx chain 1: iq corr coeff=fe
[   96.883250] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.883282] ath: phy1: IQ_RES[0]=0x45cd010 IQ_RES[1]=0xb10
[   96.883315] ath: phy1: IQ_RES[2]=0x26fac5dd IQ_RES[3]=0x2b50
[   96.883347] ath: phy1: IQ_RES[4]=0xba021ffa IQ_RES[5]=0xfa72
[   96.883371] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.883391] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.883411] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.883431] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   96.883450] ath: phy1: rx chain 1: iq corr coeff=17d
[   96.883467] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.883502] ath: phy1: IQ_RES[0]=0x65a500c IQ_RES[1]=0xaf0
[   96.883534] ath: phy1: IQ_RES[2]=0x21fb45b1 IQ_RES[3]=0x2a30
[   96.883568] ath: phy1: IQ_RES[4]=0xa9020ffd IQ_RES[5]=0xfa92
[   96.883592] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.883611] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   96.883631] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   96.883651] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[   96.883669] ath: phy1: rx chain 1: iq corr coeff=17c
[   96.883686] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.883720] ath: phy1: IQ_RES[0]=0x659d009 IQ_RES[1]=0xaf0
[   96.883753] ath: phy1: IQ_RES[2]=0x20fb85ab IQ_RES[3]=0x2a00
[   96.883786] ath: phy1: IQ_RES[4]=0xa4022ffd IQ_RES[5]=0xfaa2
[   96.883810] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.883830] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   96.883849] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   96.883868] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[   96.883885] ath: phy1: rx chain 1: iq corr coeff=17c
[   96.883901] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.883933] ath: phy1: IQ_RES[0]=0x5e100a IQ_RES[1]=0xb40
[   96.883963] ath: phy1: IQ_RES[2]=0x21fb65f0 IQ_RES[3]=0x2bf0
[   96.883993] ath: phy1: IQ_RES[4]=0xc5026ffe IQ_RES[5]=0xfa62
[   96.884015] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.884034] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.884053] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.884072] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   96.884091] ath: phy1: rx chain 1: iq corr coeff=17e
[   96.884108] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.884140] ath: phy1: IQ_RES[0]=0x26e7009 IQ_RES[1]=0xd20
[   96.884170] ath: phy1: IQ_RES[2]=0x27fa46f1 IQ_RES[3]=0x3370
[   96.884199] ath: phy1: IQ_RES[4]=0x41028ffe IQ_RES[5]=0xf963
[   96.884220] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.884233] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.884245] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.884258] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[   96.884270] ath: phy1: rx chain 1: iq corr coeff=1fe
[   96.884329] ath: phy1: enabling IQ Calibration
[   96.884343] ath: phy1: starting IQ Mismatch Calibration
[   96.884389] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   96.884549] ath: phy1: Enable MIB counters
[   96.884577] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:2
[   96.884592] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   96.884607] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   96.884639] ath: phy1: STA is not yet associated..skipping beacon config
[   96.884786] wlan0: authenticated
[   96.893747] ath: phy1: AWAKE -> FULL-SLEEP
[   96.893904] ath: phy1: FULL-SLEEP -> AWAKE
[   96.896756] ath: phy1: Set channel: 2437 MHz width: 0
[   96.896796] ath: phy1: Stopping ANI
[   96.896953] ath: phy1: Disable MIB counters
[   96.897049] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[   96.897950] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[   96.897985] ath: phy1: ah->misc_mode 0x10000004
[   96.900900] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.900929] ath: phy1: IQ_RES[0]=0xb51b029 IQ_RES[1]=0x9c0
[   96.900954] ath: phy1: IQ_RES[2]=0xcf9c527 IQ_RES[3]=0x2550
[   96.900978] ath: phy1: IQ_RES[4]=0x58ff7001 IQ_RES[5]=0xfbb2
[   96.900993] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.901005] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   96.901017] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   96.901029] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[   96.901040] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[   96.901051] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.901076] ath: phy1: IQ_RES[0]=0xb58202a IQ_RES[1]=0xba0
[   96.901102] ath: phy1: IQ_RES[2]=0xdfa5590 IQ_RES[3]=0x2840
[   96.901126] ath: phy1: IQ_RES[4]=0x87ffffff IQ_RES[5]=0xfb32
[   96.901141] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.901154] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[   96.901165] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[   96.901178] ath: phy1: rx chain 0: mag corr=-4  phase corr=-4
[   96.901189] ath: phy1: rx chain 0: iq corr coeff=fffffdfc
[   96.901200] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.901225] ath: phy1: IQ_RES[0]=0x1256002e IQ_RES[1]=0xbe0
[   96.901249] ath: phy1: IQ_RES[2]=0xefb1571 IQ_RES[3]=0x2720
[   96.901272] ath: phy1: IQ_RES[4]=0x75006fff IQ_RES[5]=0xfb32
[   96.901323] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.901336] ath: phy1: tx chain 0: mag corr=-1  phase corr=-4
[   96.901346] ath: phy1: tx chain 0: iq corr coeff=ffffff7c
[   96.901357] ath: phy1: rx chain 0: mag corr=-5  phase corr=-7
[   96.901367] ath: phy1: rx chain 0: iq corr coeff=fffffd79
[   96.901379] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.901428] ath: phy1: IQ_RES[0]=0xe562031 IQ_RES[1]=0xc10
[   96.901461] ath: phy1: IQ_RES[2]=0xdfb5571 IQ_RES[3]=0x2730
[   96.901497] ath: phy1: IQ_RES[4]=0x77005000 IQ_RES[5]=0xfb12
[   96.901523] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.901545] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[   96.901568] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[   96.901576] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   96.901584] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   96.901590] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.901610] ath: phy1: IQ_RES[0]=0x115b4037 IQ_RES[1]=0xd60
[   96.901628] ath: phy1: IQ_RES[2]=0xefb45c1 IQ_RES[3]=0x2990
[   96.901647] ath: phy1: IQ_RES[4]=0x9c009ffc IQ_RES[5]=0xfac2
[   96.901656] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.901663] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   96.901670] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   96.901678] ath: phy1: rx chain 0: mag corr=-6  phase corr=-7
[   96.901685] ath: phy1: rx chain 0: iq corr coeff=fffffcf9
[   96.901691] ath: phy1: Doing Tx IQ Cal for chain 0
[   96.901711] ath: phy1: IQ_RES[0]=0x36c1043 IQ_RES[1]=0xfd0
[   96.901730] ath: phy1: IQ_RES[2]=0xcf946d7 IQ_RES[3]=0x3110
[   96.901748] ath: phy1: IQ_RES[4]=0x19004ffa IQ_RES[5]=0xf973
[   96.901757] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   96.901765] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[   96.901772] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[   96.901779] ath: phy1: rx chain 0: mag corr=-7  phase corr=-2
[   96.901786] ath: phy1: rx chain 0: iq corr coeff=fffffc7e
[   96.901795] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.901816] ath: phy1: IQ_RES[0]=0x656b01c IQ_RES[1]=0xa40
[   96.901834] ath: phy1: IQ_RES[2]=0x24fa6576 IQ_RES[3]=0x2860
[   96.901852] ath: phy1: IQ_RES[4]=0x8c018ffa IQ_RES[5]=0xfa92
[   96.901861] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.901868] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   96.901875] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   96.901883] ath: phy1: rx chain 1: mag corr=2  phase corr=-2
[   96.901889] ath: phy1: rx chain 1: iq corr coeff=fe
[   96.901896] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.901915] ath: phy1: IQ_RES[0]=0x35d1010 IQ_RES[1]=0xb20
[   96.901941] ath: phy1: IQ_RES[2]=0x25fab5e0 IQ_RES[3]=0x2b80
[   96.901975] ath: phy1: IQ_RES[4]=0xbe020ffb IQ_RES[5]=0xfa32
[   96.901995] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.902021] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.902047] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.902073] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   96.902095] ath: phy1: rx chain 1: iq corr coeff=17d
[   96.902117] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.902138] ath: phy1: IQ_RES[0]=0x45a700f IQ_RES[1]=0xb00
[   96.902156] ath: phy1: IQ_RES[2]=0x22fb55b3 IQ_RES[3]=0x2a30
[   96.902175] ath: phy1: IQ_RES[4]=0xab023ffe IQ_RES[5]=0xfa82
[   96.902185] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.902191] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.902198] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.902205] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   96.902211] ath: phy1: rx chain 1: iq corr coeff=17d
[   96.902218] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.902237] ath: phy1: IQ_RES[0]=0x5a3009 IQ_RES[1]=0xad0
[   96.902255] ath: phy1: IQ_RES[2]=0x20fb95b0 IQ_RES[3]=0x2a20
[   96.902274] ath: phy1: IQ_RES[4]=0xa8021000 IQ_RES[5]=0xfab2
[   96.902283] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.902291] ath: phy1: tx chain 1: mag corr=-2  phase corr=7
[   96.902298] ath: phy1: tx chain 1: iq corr coeff=ffffff07
[   96.902305] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   96.902312] ath: phy1: rx chain 1: iq corr coeff=17e
[   96.902319] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.902339] ath: phy1: IQ_RES[0]=0x15e200b IQ_RES[1]=0xb60
[   96.902357] ath: phy1: IQ_RES[2]=0x23fb65f1 IQ_RES[3]=0x2c10
[   96.902376] ath: phy1: IQ_RES[4]=0xc8023ffe IQ_RES[5]=0xfa72
[   96.902385] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.902393] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.902400] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.902407] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   96.902414] ath: phy1: rx chain 1: iq corr coeff=17e
[   96.902421] ath: phy1: Doing Tx IQ Cal for chain 1
[   96.902444] ath: phy1: IQ_RES[0]=0x16e700b IQ_RES[1]=0xd20
[   96.902477] ath: phy1: IQ_RES[2]=0x25fa56f7 IQ_RES[3]=0x3390
[   96.902509] ath: phy1: IQ_RES[4]=0x41028ffd IQ_RES[5]=0xf963
[   96.902535] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   96.902557] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   96.902583] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   96.902603] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   96.902611] ath: phy1: rx chain 1: iq corr coeff=17e
[   96.902661] ath: phy1: enabling IQ Calibration
[   96.902671] ath: phy1: starting IQ Mismatch Calibration
[   96.902713] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   96.902812] ath: phy1: Enable MIB counters
[   96.902836] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:2
[   96.902845] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   96.902854] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   96.902884] ath: phy1: STA is not yet associated..skipping beacon config
[   96.903025] ath: phy1: Beacon already configured for a station interface
[   96.905391] wlan0: associate with 00:02:6f:22:0a:8a (try 1/3)
[   97.860978] wlan0: associate with 00:02:6f:22:0a:8a (try 2/3)
[   98.860643] wlan0: associate with 00:02:6f:22:0a:8a (try 3/3)
[   98.900576] ath: phy1: tx hung, resetting the chip
[   98.900613] ath: phy1: Stopping ANI
[   98.900754] ath: phy1: Disable MIB counters
[   98.900976] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[   98.900997] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[   98.901004] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[   98.901938] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[   98.901960] ath: phy1: ah->misc_mode 0x10000004
[   98.904807] ath: phy1: Doing Tx IQ Cal for chain 0
[   98.904830] ath: phy1: IQ_RES[0]=0xe51602c IQ_RES[1]=0xa00
[   98.904849] ath: phy1: IQ_RES[2]=0xcf9e523 IQ_RES[3]=0x2510
[   98.904868] ath: phy1: IQ_RES[4]=0x54ff6004 IQ_RES[5]=0xfbd2
[   98.904878] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   98.904886] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   98.904893] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   98.904901] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   98.904908] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   98.904915] ath: phy1: Doing Tx IQ Cal for chain 0
[   98.904935] ath: phy1: IQ_RES[0]=0x10577030 IQ_RES[1]=0xba0
[   98.904954] ath: phy1: IQ_RES[2]=0xbfa558a IQ_RES[3]=0x27e0
[   98.904973] ath: phy1: IQ_RES[4]=0x83001000 IQ_RES[5]=0xfb42
[   98.904983] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   98.904990] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   98.904997] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   98.905004] ath: phy1: rx chain 0: mag corr=-5  phase corr=-7
[   98.905010] ath: phy1: rx chain 0: iq corr coeff=fffffd79
[   98.905016] ath: phy1: Doing Tx IQ Cal for chain 0
[   98.905035] ath: phy1: IQ_RES[0]=0x1055c02f IQ_RES[1]=0xc00
[   98.905052] ath: phy1: IQ_RES[2]=0x10fb356d IQ_RES[3]=0x2700
[   98.905071] ath: phy1: IQ_RES[4]=0x74005001 IQ_RES[5]=0xfb52
[   98.905080] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   98.905088] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[   98.905095] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[   98.905102] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[   98.905110] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[   98.905116] ath: phy1: Doing Tx IQ Cal for chain 0
[   98.905136] ath: phy1: IQ_RES[0]=0x955d02f IQ_RES[1]=0xc30
[   98.905155] ath: phy1: IQ_RES[2]=0xefb656d IQ_RES[3]=0x26f0
[   98.905173] ath: phy1: IQ_RES[4]=0x74007fff IQ_RES[5]=0xfb12
[   98.905182] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   98.905189] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[   98.905196] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[   98.905204] ath: phy1: rx chain 0: mag corr=-5  phase corr=-3
[   98.905211] ath: phy1: rx chain 0: iq corr coeff=fffffd7d
[   98.905217] ath: phy1: Doing Tx IQ Cal for chain 0
[   98.905237] ath: phy1: IQ_RES[0]=0x125a9039 IQ_RES[1]=0xd10
[   98.905255] ath: phy1: IQ_RES[2]=0xefb65ba IQ_RES[3]=0x2950
[   98.905273] ath: phy1: IQ_RES[4]=0x9900afff IQ_RES[5]=0xfab2
[   98.905282] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   98.905288] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[   98.905295] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[   98.905301] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[   98.905307] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[   98.905313] ath: phy1: Doing Tx IQ Cal for chain 0
[   98.905332] ath: phy1: IQ_RES[0]=0x66ba044 IQ_RES[1]=0xf90
[   98.905349] ath: phy1: IQ_RES[2]=0xdf946d0 IQ_RES[3]=0x30c0
[   98.905366] ath: phy1: IQ_RES[4]=0x17005ff8 IQ_RES[5]=0xf9a3
[   98.905375] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[   98.905382] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[   98.905389] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[   98.905395] ath: phy1: rx chain 0: mag corr=-7  phase corr=-4
[   98.905401] ath: phy1: rx chain 0: iq corr coeff=fffffc7c
[   98.905409] ath: phy1: Doing Tx IQ Cal for chain 1
[   98.905429] ath: phy1: IQ_RES[0]=0x756101b IQ_RES[1]=0xa40
[   98.905443] ath: phy1: IQ_RES[2]=0x21fa456f IQ_RES[3]=0x2820
[   98.905457] ath: phy1: IQ_RES[4]=0x88016ff8 IQ_RES[5]=0xfab2
[   98.905463] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   98.905468] ath: phy1: tx chain 1: mag corr=-3  phase corr=5
[   98.905472] ath: phy1: tx chain 1: iq corr coeff=fffffe85
[   98.905477] ath: phy1: rx chain 1: mag corr=1  phase corr=-3
[   98.905482] ath: phy1: rx chain 1: iq corr coeff=7d
[   98.905486] ath: phy1: Doing Tx IQ Cal for chain 1
[   98.905501] ath: phy1: IQ_RES[0]=0x15ca012 IQ_RES[1]=0xaf0
[   98.905516] ath: phy1: IQ_RES[2]=0x24fac5d8 IQ_RES[3]=0x2b20
[   98.905530] ath: phy1: IQ_RES[4]=0xb701fffa IQ_RES[5]=0xfa62
[   98.905535] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   98.905540] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   98.905545] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   98.905549] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   98.905554] ath: phy1: rx chain 1: iq corr coeff=17e
[   98.905558] ath: phy1: Doing Tx IQ Cal for chain 1
[   98.905574] ath: phy1: IQ_RES[0]=0x459d00e IQ_RES[1]=0xaa0
[   98.905588] ath: phy1: IQ_RES[2]=0x20fb25ad IQ_RES[3]=0x2a00
[   98.905602] ath: phy1: IQ_RES[4]=0xa6022ffc IQ_RES[5]=0xfa92
[   98.905607] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   98.905612] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   98.905617] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   98.905621] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   98.905626] ath: phy1: rx chain 1: iq corr coeff=17d
[   98.905630] ath: phy1: Doing Tx IQ Cal for chain 1
[   98.905646] ath: phy1: IQ_RES[0]=0xfd59d009 IQ_RES[1]=0xa9f
[   98.905660] ath: phy1: IQ_RES[2]=0x20fb75a8 IQ_RES[3]=0x29f0
[   98.905674] ath: phy1: IQ_RES[4]=0xa3022ffc IQ_RES[5]=0xfab2
[   98.905679] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   98.905684] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   98.905689] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   98.905694] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   98.905698] ath: phy1: rx chain 1: iq corr coeff=17e
[   98.905702] ath: phy1: Doing Tx IQ Cal for chain 1
[   98.905718] ath: phy1: IQ_RES[0]=0xff5dd00a IQ_RES[1]=0xb8f
[   98.905732] ath: phy1: IQ_RES[2]=0x21fb85ee IQ_RES[3]=0x2be0
[   98.905746] ath: phy1: IQ_RES[4]=0xc3027ffc IQ_RES[5]=0xfa62
[   98.905751] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   98.905756] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[   98.905761] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[   98.905765] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[   98.905770] ath: phy1: rx chain 1: iq corr coeff=17d
[   98.905774] ath: phy1: Doing Tx IQ Cal for chain 1
[   98.905790] ath: phy1: IQ_RES[0]=0xff6e000b IQ_RES[1]=0xd4f
[   98.905804] ath: phy1: IQ_RES[2]=0x24fa56f2 IQ_RES[3]=0x3370
[   98.905818] ath: phy1: IQ_RES[4]=0x3d028ffc IQ_RES[5]=0xf993
[   98.905823] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[   98.905828] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[   98.905832] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[   98.905837] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[   98.905842] ath: phy1: rx chain 1: iq corr coeff=17e
[   98.905889] ath: phy1: enabling IQ Calibration
[   98.905895] ath: phy1: starting IQ Mismatch Calibration
[   98.905932] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[   98.906029] ath: phy1: Enable MIB counters
[   98.906046] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:2
[   98.906052] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[   98.906057] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[   98.906078] ath: phy1: STA is not yet associated..skipping beacon config
[   98.906205] wlan0: RX AssocResp from 00:02:6f:22:0a:8a (capab=0x431
status=0 aid=2)
[   98.908248] ath: phy1: Configure tx [queue/halq] [2/2], aifs: 3,
cw_min: 15, cw_max: 1023, txop: 0
[   98.908369] ath: phy1: Configure tx [queue/halq] [3/3], aifs: 7,
cw_min: 15, cw_max: 1023, txop: 0
[   98.908450] ath: phy1: Configure tx [queue/halq] [1/1], aifs: 2,
cw_min: 7, cw_max: 15, txop: 94
[   98.908521] ath: phy1: Configure tx [queue/halq] [0/0], aifs: 2,
cw_min: 3, cw_max: 7, txop: 47
[   98.908587] ath: phy1: BSSID 00:02:6f:22:0a:8a Changed ASSOC 1
[   98.908629] ath: phy1: Primary Station interface: a8:54:b2:74:16:dd,
BSSID: 00:02:6f:22:0a:8a
[   98.908676] ath: phy1: ah->misc_mode 0x10000004
[   98.908727] ath: phy1: Starting ANI
[   98.908796] wlan0: associated
[   98.908867] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   98.910636] ath: phy1: Set HW RX filter: 0x207
[   99.907900] ath: phy1: listenTime=961 OFDM:3 errs=79/s CCK:2
errs=11/s ofdm_turn=1
[   99.907912] ath: phy1: **** ofdmlevel 3=>2, rssi=127[lo=7 hi=40]
[   99.907926] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[   99.907932] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[   99.907940] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=961 ofdmErrs=76 cckErrs=11
[   99.907990] ath: phy1: Calibration @4294917254 finished:  short ani,
caldone: false
[  100.743037] ath: phy1: Set HW RX filter: 0x207
[  100.907611] ath: phy1: listenTime=958 OFDM:2 errs=36/s CCK:2 errs=3/s
ofdm_turn=0
[  100.907648] ath: phy1: **** ccklevel 2=>1, rssi=127[lo=7 hi=40]
[  100.907744] ath: phy1: Calibration @4294917504 finished:  short ani,
caldone: false
[  101.291273] ath: phy1: tx hung, resetting the chip
[  101.291332] ath: phy1: Stopping ANI
[  101.291527] ath: phy1: Disable MIB counters
[  101.291707] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  101.291742] ath: phy1: tsf: 174081063249 tsftu: 170001040
[  101.291770] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170001100
[  101.291801] ath: phy1: next DTIM 170001100
[  101.291817] ath: phy1: next beacon 170001100
[  101.291834] ath: phy1: beacon period 100
[  101.291849] ath: phy1: DTIM period 100
[  101.292319] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  101.292354] ath: phy1: NF calibrated [ctl] [chain 0] is -98
[  101.292375] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[  101.293358] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  101.293400] ath: phy1: ah->misc_mode 0x10000004
[  101.296356] ath: phy1: Doing Tx IQ Cal for chain 0
[  101.296390] ath: phy1: IQ_RES[0]=0xc51502c IQ_RES[1]=0x9f0
[  101.296414] ath: phy1: IQ_RES[2]=0xdf9d520 IQ_RES[3]=0x2500
[  101.296438] ath: phy1: IQ_RES[4]=0x54ff7000 IQ_RES[5]=0xfbc2
[  101.296454] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  101.296467] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  101.296480] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  101.296494] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[  101.296507] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[  101.296518] ath: phy1: Doing Tx IQ Cal for chain 0
[  101.296544] ath: phy1: IQ_RES[0]=0xa57802e IQ_RES[1]=0xbb0
[  101.296567] ath: phy1: IQ_RES[2]=0xdfa6587 IQ_RES[3]=0x27e0
[  101.296591] ath: phy1: IQ_RES[4]=0x84fff000 IQ_RES[5]=0xfb22
[  101.296605] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  101.296619] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  101.296631] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  101.296644] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[  101.296657] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[  101.296669] ath: phy1: Doing Tx IQ Cal for chain 0
[  101.296694] ath: phy1: IQ_RES[0]=0xf55902e IQ_RES[1]=0xbe0
[  101.296718] ath: phy1: IQ_RES[2]=0x10fb1569 IQ_RES[3]=0x2700
[  101.296742] ath: phy1: IQ_RES[4]=0x76006ffe IQ_RES[5]=0xfb12
[  101.296756] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  101.296770] ath: phy1: tx chain 0: mag corr=-1  phase corr=-3
[  101.296783] ath: phy1: tx chain 0: iq corr coeff=ffffff7d
[  101.296796] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  101.296808] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  101.296820] ath: phy1: Doing Tx IQ Cal for chain 0
[  101.296845] ath: phy1: IQ_RES[0]=0x755c02f IQ_RES[1]=0xc40
[  101.296869] ath: phy1: IQ_RES[2]=0xdfb056c IQ_RES[3]=0x2720
[  101.296893] ath: phy1: IQ_RES[4]=0x76005ffd IQ_RES[5]=0xfb12
[  101.296907] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  101.296920] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  101.296932] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  101.296945] ath: phy1: rx chain 0: mag corr=-5  phase corr=-3
[  101.296958] ath: phy1: rx chain 0: iq corr coeff=fffffd7d
[  101.296969] ath: phy1: Doing Tx IQ Cal for chain 0
[  101.296994] ath: phy1: IQ_RES[0]=0xc5a7038 IQ_RES[1]=0xd50
[  101.297018] ath: phy1: IQ_RES[2]=0xefb05b7 IQ_RES[3]=0x2940
[  101.297041] ath: phy1: IQ_RES[4]=0x9700bffb IQ_RES[5]=0xfad2
[  101.297056] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  101.297068] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  101.297081] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  101.297094] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[  101.297106] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[  101.297118] ath: phy1: Doing Tx IQ Cal for chain 0
[  101.297143] ath: phy1: IQ_RES[0]=0x36b7046 IQ_RES[1]=0xff0
[  101.297166] ath: phy1: IQ_RES[2]=0xef906d3 IQ_RES[3]=0x30d0
[  101.297190] ath: phy1: IQ_RES[4]=0x18004ffc IQ_RES[5]=0xf983
[  101.297204] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  101.297217] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  101.297230] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  101.297243] ath: phy1: rx chain 0: mag corr=-7  phase corr=-2
[  101.297256] ath: phy1: rx chain 0: iq corr coeff=fffffc7e
[  101.297269] ath: phy1: Doing Tx IQ Cal for chain 1
[  101.297295] ath: phy1: IQ_RES[0]=0x456401d IQ_RES[1]=0xa10
[  101.297319] ath: phy1: IQ_RES[2]=0x25fa6570 IQ_RES[3]=0x2830
[  101.297342] ath: phy1: IQ_RES[4]=0x88018ff9 IQ_RES[5]=0xfac2
[  101.297357] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  101.297370] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  101.297383] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  101.297395] ath: phy1: rx chain 1: mag corr=2  phase corr=-1
[  101.297408] ath: phy1: rx chain 1: iq corr coeff=ff
[  101.297419] ath: phy1: Doing Tx IQ Cal for chain 1
[  101.297444] ath: phy1: IQ_RES[0]=0x45ca014 IQ_RES[1]=0xb10
[  101.297468] ath: phy1: IQ_RES[2]=0x24fad5d2 IQ_RES[3]=0x2b00
[  101.297491] ath: phy1: IQ_RES[4]=0xb801fffb IQ_RES[5]=0xfa52
[  101.297506] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  101.297519] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  101.297531] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  101.297544] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[  101.297556] ath: phy1: rx chain 1: iq corr coeff=fd
[  101.297568] ath: phy1: Doing Tx IQ Cal for chain 1
[  101.297593] ath: phy1: IQ_RES[0]=0x15a000e IQ_RES[1]=0xac0
[  101.297616] ath: phy1: IQ_RES[2]=0x25fb35ac IQ_RES[3]=0x2a10
[  101.297640] ath: phy1: IQ_RES[4]=0xa7024ffe IQ_RES[5]=0xfaa2
[  101.297654] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  101.297667] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[  101.297680] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[  101.297693] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[  101.297705] ath: phy1: rx chain 1: iq corr coeff=1fe
[  101.297716] ath: phy1: Doing Tx IQ Cal for chain 1
[  101.297742] ath: phy1: IQ_RES[0]=0x597009 IQ_RES[1]=0xae0
[  101.297765] ath: phy1: IQ_RES[2]=0x21fb55a5 IQ_RES[3]=0x29c0
[  101.297788] ath: phy1: IQ_RES[4]=0xa2022ffd IQ_RES[5]=0xfab2
[  101.297803] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  101.297816] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  101.297828] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  101.297841] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[  101.297853] ath: phy1: rx chain 1: iq corr coeff=1fe
[  101.297864] ath: phy1: Doing Tx IQ Cal for chain 1
[  101.297890] ath: phy1: IQ_RES[0]=0x25dc008 IQ_RES[1]=0xb40
[  101.297913] ath: phy1: IQ_RES[2]=0x23fb65e8 IQ_RES[3]=0x2bf0
[  101.297936] ath: phy1: IQ_RES[4]=0xc4023fff IQ_RES[5]=0xfa72
[  101.297951] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  101.297964] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[  101.297976] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[  101.297989] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[  101.298001] ath: phy1: rx chain 1: iq corr coeff=1fd
[  101.298013] ath: phy1: Doing Tx IQ Cal for chain 1
[  101.298038] ath: phy1: IQ_RES[0]=0x26d8009 IQ_RES[1]=0xd10
[  101.298061] ath: phy1: IQ_RES[2]=0x26fa66f2 IQ_RES[3]=0x3350
[  101.298084] ath: phy1: IQ_RES[4]=0x3f025ffe IQ_RES[5]=0xf993
[  101.298099] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  101.298112] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  101.298124] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  101.298137] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  101.298149] ath: phy1: rx chain 1: iq corr coeff=17e
[  101.298207] ath: phy1: enabling IQ Calibration
[  101.298220] ath: phy1: starting IQ Mismatch Calibration
[  101.298269] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  101.298426] ath: phy1: Enable MIB counters
[  101.298455] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:2 cck:1
[  101.298470] ath: phy1: **** ofdmlevel 2=>3, rssi=50[lo=7 hi=40]
[  101.298486] ath: phy1: **** ccklevel 1=>2, rssi=50[lo=7 hi=40]
[  101.298541] ath: phy1: Starting ANI
[  101.299225] ath: phy1: Set HW Key
[  101.299880] ath: phy1: Set HW Key
[  101.301554] ath: phy1: Set HW Key
[  101.301752] ath: phy1: Set HW Key
[  101.302346] ath: phy1: Set HW Key
[  101.302551] ath: phy1: Set HW Key
[  101.304061] ath: phy1: Set HW Key
[  101.304210] ath: phy1: Set HW Key
[  101.304721] ath: phy1: Set HW Key
[  101.304858] ath: phy1: Set HW Key
[  101.306448] ath: phy1: Set HW Key
[  101.306665] ath: phy1: Set HW Key
[  101.307383] ath: phy1: Set HW Key
[  101.307601] ath: phy1: Set HW Key
[  101.315485] ath: phy1: Set HW RX filter: 0x207
[  101.315505] ath: phy1: Set HW RX filter: 0x207
[  101.317376] ath: phy1: Set HW RX filter: 0x207
[  101.595052] ath: phy1: MAC Hang signature not found at DCU complete
[  101.595100] ath: phy1: Possible baseband hang, busy=11 (try 1)
[  101.894912] ath: phy1: MAC Hang signature not found at DCU complete
[  101.894960] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  102.194815] ath: phy1: MAC Hang signature not found at DCU complete
[  102.194862] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  102.294720] ath: phy1: listenTime=942 OFDM:3 errs=1/s CCK:2 errs=2/s
ofdm_turn=1
[  102.294747] ath: phy1: **** ofdmlevel 3=>2, rssi=50[lo=7 hi=40]
[  102.294772] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[  102.294788] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[  102.294805] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=942 ofdmErrs=1 cckErrs=2
[  102.294891] ath: phy1: Calibration @4294917851 finished:  short ani,
caldone: false
[  102.298717] ath: phy1: tx hung, resetting the chip
[  102.298790] ath: phy1: Stopping ANI
[  102.299019] ath: phy1: Disable MIB counters
[  102.299096] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  102.299123] ath: phy1: tsf: 174082070640 tsftu: 170002024
[  102.299140] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170002100
[  102.299164] ath: phy1: next DTIM 170002100
[  102.299177] ath: phy1: next beacon 170002100
[  102.299188] ath: phy1: beacon period 100
[  102.299199] ath: phy1: DTIM period 100
[  102.299560] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  102.299595] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  102.299614] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[  102.300607] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  102.300651] ath: phy1: ah->misc_mode 0x10000004
[  102.303637] ath: phy1: Doing Tx IQ Cal for chain 0
[  102.303681] ath: phy1: IQ_RES[0]=0xe51502c IQ_RES[1]=0x9a0
[  102.303716] ath: phy1: IQ_RES[2]=0xcf9d524 IQ_RES[3]=0x24f0
[  102.303748] ath: phy1: IQ_RES[4]=0x52ff7001 IQ_RES[5]=0xfbd2
[  102.303772] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  102.303792] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  102.303812] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  102.303833] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  102.303852] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  102.303870] ath: phy1: Doing Tx IQ Cal for chain 0
[  102.303906] ath: phy1: IQ_RES[0]=0xf57802c IQ_RES[1]=0xb70
[  102.303939] ath: phy1: IQ_RES[2]=0xdfa6584 IQ_RES[3]=0x27c0
[  102.303972] ath: phy1: IQ_RES[4]=0x84ffefff IQ_RES[5]=0xfb42
[  102.303995] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  102.304016] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  102.304035] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  102.304054] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  102.304071] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  102.304089] ath: phy1: Doing Tx IQ Cal for chain 0
[  102.304124] ath: phy1: IQ_RES[0]=0xf553033 IQ_RES[1]=0xc00
[  102.304157] ath: phy1: IQ_RES[2]=0xffb5569 IQ_RES[3]=0x26e0
[  102.304191] ath: phy1: IQ_RES[4]=0x72006001 IQ_RES[5]=0xfb12
[  102.304215] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  102.304236] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  102.304255] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  102.304276] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[  102.304295] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[  102.304313] ath: phy1: Doing Tx IQ Cal for chain 0
[  102.304347] ath: phy1: IQ_RES[0]=0x8555030 IQ_RES[1]=0xc10
[  102.304379] ath: phy1: IQ_RES[2]=0xdfb4567 IQ_RES[3]=0x26e0
[  102.304412] ath: phy1: IQ_RES[4]=0x72005ffd IQ_RES[5]=0xfb22
[  102.304435] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  102.304454] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  102.304472] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  102.304492] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[  102.304512] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[  102.304529] ath: phy1: Doing Tx IQ Cal for chain 0
[  102.304565] ath: phy1: IQ_RES[0]=0x115a1036 IQ_RES[1]=0xd30
[  102.304598] ath: phy1: IQ_RES[2]=0x10fb65b5 IQ_RES[3]=0x28f0
[  102.304631] ath: phy1: IQ_RES[4]=0x9700bffe IQ_RES[5]=0xfac2
[  102.304654] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  102.304674] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  102.304693] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  102.304713] ath: phy1: rx chain 0: mag corr=-6  phase corr=-6
[  102.304732] ath: phy1: rx chain 0: iq corr coeff=fffffcfa
[  102.304749] ath: phy1: Doing Tx IQ Cal for chain 0
[  102.304782] ath: phy1: IQ_RES[0]=0x46b0044 IQ_RES[1]=0xfc0
[  102.304814] ath: phy1: IQ_RES[2]=0xff936c7 IQ_RES[3]=0x30d0
[  102.304847] ath: phy1: IQ_RES[4]=0x15003ff9 IQ_RES[5]=0xf993
[  102.304871] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  102.304892] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  102.304911] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  102.304930] ath: phy1: rx chain 0: mag corr=-6  phase corr=-3
[  102.304950] ath: phy1: rx chain 0: iq corr coeff=fffffcfd
[  102.304971] ath: phy1: Doing Tx IQ Cal for chain 1
[  102.305003] ath: phy1: IQ_RES[0]=0x456101f IQ_RES[1]=0xa30
[  102.305032] ath: phy1: IQ_RES[2]=0x25fa5568 IQ_RES[3]=0x2810
[  102.305064] ath: phy1: IQ_RES[4]=0x86016ffa IQ_RES[5]=0xfaa2
[  102.305087] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  102.305108] ath: phy1: tx chain 1: mag corr=-2  phase corr=6
[  102.305127] ath: phy1: tx chain 1: iq corr coeff=ffffff06
[  102.305147] ath: phy1: rx chain 1: mag corr=1  phase corr=-1
[  102.305166] ath: phy1: rx chain 1: iq corr coeff=7f
[  102.305184] ath: phy1: Doing Tx IQ Cal for chain 1
[  102.305218] ath: phy1: IQ_RES[0]=0x25c3013 IQ_RES[1]=0xb20
[  102.305249] ath: phy1: IQ_RES[2]=0x23fa95d6 IQ_RES[3]=0x2b10
[  102.305281] ath: phy1: IQ_RES[4]=0xb501effa IQ_RES[5]=0xfa62
[  102.305303] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  102.305323] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  102.305342] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  102.305361] ath: phy1: rx chain 1: mag corr=2  phase corr=-2
[  102.305379] ath: phy1: rx chain 1: iq corr coeff=fe
[  102.305395] ath: phy1: Doing Tx IQ Cal for chain 1
[  102.305426] ath: phy1: IQ_RES[0]=0x359e00e IQ_RES[1]=0xb10
[  102.305457] ath: phy1: IQ_RES[2]=0x22fb25ab IQ_RES[3]=0x29e0
[  102.305485] ath: phy1: IQ_RES[4]=0xa4021fff IQ_RES[5]=0xfa92
[  102.305506] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  102.305525] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  102.305545] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  102.305565] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  102.305584] ath: phy1: rx chain 1: iq corr coeff=17e
[  102.305602] ath: phy1: Doing Tx IQ Cal for chain 1
[  102.305634] ath: phy1: IQ_RES[0]=0x59400b IQ_RES[1]=0xa90
[  102.305666] ath: phy1: IQ_RES[2]=0x20fb95a4 IQ_RES[3]=0x29b0
[  102.305698] ath: phy1: IQ_RES[4]=0xa3022ffd IQ_RES[5]=0xfaa2
[  102.305721] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  102.305740] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  102.305759] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  102.305778] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  102.305795] ath: phy1: rx chain 1: iq corr coeff=17e
[  102.305813] ath: phy1: Doing Tx IQ Cal for chain 1
[  102.305848] ath: phy1: IQ_RES[0]=0x15d700c IQ_RES[1]=0xb20
[  102.305878] ath: phy1: IQ_RES[2]=0x23fb25e7 IQ_RES[3]=0x2bb0
[  102.305910] ath: phy1: IQ_RES[4]=0xc3026ffe IQ_RES[5]=0xfaa2
[  102.305933] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  102.305951] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  102.305968] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  102.305985] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  102.306003] ath: phy1: rx chain 1: iq corr coeff=17e
[  102.306019] ath: phy1: Doing Tx IQ Cal for chain 1
[  102.306050] ath: phy1: IQ_RES[0]=0x36d600d IQ_RES[1]=0xd10
[  102.306080] ath: phy1: IQ_RES[2]=0x27fa56eb IQ_RES[3]=0x3310
[  102.306111] ath: phy1: IQ_RES[4]=0x39028ffe IQ_RES[5]=0xf973
[  102.306133] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  102.306152] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  102.306170] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  102.306190] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  102.306209] ath: phy1: rx chain 1: iq corr coeff=17e
[  102.306282] ath: phy1: enabling IQ Calibration
[  102.306306] ath: phy1: starting IQ Mismatch Calibration
[  102.306368] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  102.306638] ath: phy1: Enable MIB counters
[  102.306699] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:2 cck:2
[  102.306755] ath: phy1: **** ofdmlevel 2=>3, rssi=48[lo=7 hi=40]
[  102.306815] ath: phy1: **** ccklevel 2=>2, rssi=48[lo=7 hi=40]
[  102.306908] ath: phy1: Starting ANI
[  102.327629] ath: phy1: Set HW RX filter: 0x207
[  102.455186] ath: phy1: Set HW RX filter: 0x207
[  102.606707] ath: phy1: MAC Hang signature not found at DCU complete
[  102.606754] ath: phy1: Possible baseband hang, busy=15 (try 1)
[  102.906442] ath: phy1: MAC Hang signature not found at DCU complete
[  102.906490] ath: phy1: Possible baseband hang, busy=10 (try 1)
[  103.210285] ath: phy1: MAC Hang signature not found at DCU complete
[  103.210323] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  103.306182] ath: phy1: listenTime=917 OFDM:3 errs=9/s CCK:2 errs=4/s
ofdm_turn=0
[  103.306215] ath: phy1: **** ccklevel 2=>1, rssi=48[lo=7 hi=40]
[  103.306273] ath: phy1: Calibration @4294918104 finished:  short ani,
caldone: false
[  103.510122] ath: phy1: MAC Hang signature not found at DCU complete
[  103.510151] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  103.810149] ath: phy1: MAC Hang signature not found at DCU complete
[  103.810186] ath: phy1: Possible baseband hang, busy=3 (try 1)
[  104.305904] ath: phy1: listenTime=958 OFDM:3 errs=8/s CCK:1 errs=3/s
ofdm_turn=1
[  104.305931] ath: phy1: **** ofdmlevel 3=>2, rssi=48[lo=7 hi=40]
[  104.305955] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[  104.305971] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[  104.305988] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=958 ofdmErrs=8 cckErrs=3
[  104.306072] ath: phy1: Calibration @4294918354 finished:  short ani,
caldone: false
[  104.316427] ath: phy1: MAC Hang signature not found at DCU complete
[  104.316455] ath: phy1: Possible baseband hang, busy=0 (try 1)
[  104.316468] ath: phy1: tx hung, resetting the chip
[  104.316510] ath: phy1: Stopping ANI
[  104.316737] ath: phy1: Disable MIB counters
[  104.316805] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  104.316823] ath: phy1: tsf: 174084088419 tsftu: 170003994
[  104.316834] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170004000
[  104.316853] ath: phy1: next DTIM 170004000
[  104.316860] ath: phy1: next beacon 170004000
[  104.316867] ath: phy1: beacon period 100
[  104.316874] ath: phy1: DTIM period 100
[  104.316887] ath: phy1: Received DTIM beacon indicating buffered
broadcast/multicast frame(s)
[  104.316931] ath: phy1: All PS CAB frames received, back to sleep
[  104.317392] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  104.317421] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  104.317432] ath: phy1: NF calibrated [ctl] [chain 1] is -102
[  104.318395] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  104.318429] ath: phy1: ah->misc_mode 0x10000004
[  104.321349] ath: phy1: Doing Tx IQ Cal for chain 0
[  104.321375] ath: phy1: IQ_RES[0]=0xb51502a IQ_RES[1]=0x9c0
[  104.321394] ath: phy1: IQ_RES[2]=0xbf9e520 IQ_RES[3]=0x24f0
[  104.321412] ath: phy1: IQ_RES[4]=0x51ff7000 IQ_RES[5]=0xfbe2
[  104.321422] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  104.321430] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  104.321438] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  104.321446] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[  104.321454] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[  104.321461] ath: phy1: Doing Tx IQ Cal for chain 0
[  104.321480] ath: phy1: IQ_RES[0]=0xb57302a IQ_RES[1]=0xbb0
[  104.321498] ath: phy1: IQ_RES[2]=0xdfa4586 IQ_RES[3]=0x27a0
[  104.321516] ath: phy1: IQ_RES[4]=0x82ffe002 IQ_RES[5]=0xfb32
[  104.321524] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  104.321532] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[  104.321540] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[  104.321548] ath: phy1: rx chain 0: mag corr=-4  phase corr=-3
[  104.321603] ath: phy1: rx chain 0: iq corr coeff=fffffdfd
[  104.321611] ath: phy1: Doing Tx IQ Cal for chain 0
[  104.321631] ath: phy1: IQ_RES[0]=0x1155302e IQ_RES[1]=0xbf0
[  104.321649] ath: phy1: IQ_RES[2]=0xefb1567 IQ_RES[3]=0x26d0
[  104.321667] ath: phy1: IQ_RES[4]=0x73006fff IQ_RES[5]=0xfb22
[  104.321676] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  104.321684] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  104.321692] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  104.321700] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[  104.321728] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[  104.321775] ath: phy1: Doing Tx IQ Cal for chain 0
[  104.321830] ath: phy1: IQ_RES[0]=0xb554030 IQ_RES[1]=0xbf0
[  104.321886] ath: phy1: IQ_RES[2]=0xdfb4568 IQ_RES[3]=0x26d0
[  104.321942] ath: phy1: IQ_RES[4]=0x74006ffd IQ_RES[5]=0xfb02
[  104.321989] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  104.322035] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  104.322082] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  104.322110] ath: phy1: rx chain 0: mag corr=-5  phase corr=-5
[  104.322117] ath: phy1: rx chain 0: iq corr coeff=fffffd7b
[  104.322124] ath: phy1: Doing Tx IQ Cal for chain 0
[  104.322144] ath: phy1: IQ_RES[0]=0x115a6036 IQ_RES[1]=0xd10
[  104.322162] ath: phy1: IQ_RES[2]=0x11fb05b8 IQ_RES[3]=0x2900
[  104.322180] ath: phy1: IQ_RES[4]=0x99008ffd IQ_RES[5]=0xfac2
[  104.322188] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  104.322196] ath: phy1: tx chain 0: mag corr=-1  phase corr=-4
[  104.322204] ath: phy1: tx chain 0: iq corr coeff=ffffff7c
[  104.322212] ath: phy1: rx chain 0: mag corr=-5  phase corr=-7
[  104.322219] ath: phy1: rx chain 0: iq corr coeff=fffffd79
[  104.322226] ath: phy1: Doing Tx IQ Cal for chain 0
[  104.322248] ath: phy1: IQ_RES[0]=0x46b4045 IQ_RES[1]=0xfa0
[  104.322269] ath: phy1: IQ_RES[2]=0xdf926c8 IQ_RES[3]=0x30e0
[  104.322291] ath: phy1: IQ_RES[4]=0x14005ffb IQ_RES[5]=0xf9a3
[  104.322304] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  104.322314] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[  104.322324] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[  104.322334] ath: phy1: rx chain 0: mag corr=-7  phase corr=-3
[  104.322344] ath: phy1: rx chain 0: iq corr coeff=fffffc7d
[  104.322356] ath: phy1: Doing Tx IQ Cal for chain 1
[  104.322379] ath: phy1: IQ_RES[0]=0x655e01a IQ_RES[1]=0xa30
[  104.322400] ath: phy1: IQ_RES[2]=0x24fa0569 IQ_RES[3]=0x27f0
[  104.322421] ath: phy1: IQ_RES[4]=0x85018ff6 IQ_RES[5]=0xfab2
[  104.322434] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  104.322446] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  104.322456] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  104.322466] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[  104.322477] ath: phy1: rx chain 1: iq corr coeff=fd
[  104.322487] ath: phy1: Doing Tx IQ Cal for chain 1
[  104.322511] ath: phy1: IQ_RES[0]=0x45c800f IQ_RES[1]=0xad0
[  104.322532] ath: phy1: IQ_RES[2]=0x24faa5d4 IQ_RES[3]=0x2b10
[  104.322555] ath: phy1: IQ_RES[4]=0xb601effa IQ_RES[5]=0xfa82
[  104.322567] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  104.322578] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  104.322589] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  104.322600] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  104.322610] ath: phy1: rx chain 1: iq corr coeff=17d
[  104.322620] ath: phy1: Doing Tx IQ Cal for chain 1
[  104.322646] ath: phy1: IQ_RES[0]=0x459e00c IQ_RES[1]=0xa80
[  104.322669] ath: phy1: IQ_RES[2]=0x21fb35ab IQ_RES[3]=0x29e0
[  104.322692] ath: phy1: IQ_RES[4]=0xa6024ffa IQ_RES[5]=0xfa72
[  104.322705] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  104.322717] ath: phy1: tx chain 1: mag corr=-4  phase corr=6
[  104.322728] ath: phy1: tx chain 1: iq corr coeff=fffffe06
[  104.322739] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[  104.322749] ath: phy1: rx chain 1: iq corr coeff=17c
[  104.322758] ath: phy1: Doing Tx IQ Cal for chain 1
[  104.322782] ath: phy1: IQ_RES[0]=0x159900c IQ_RES[1]=0xa90
[  104.322805] ath: phy1: IQ_RES[2]=0x21fb55a5 IQ_RES[3]=0x29b0
[  104.322827] ath: phy1: IQ_RES[4]=0xa3023ffe IQ_RES[5]=0xfac2
[  104.322841] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  104.322851] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  104.322862] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  104.322873] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  104.322885] ath: phy1: rx chain 1: iq corr coeff=17e
[  104.322895] ath: phy1: Doing Tx IQ Cal for chain 1
[  104.322919] ath: phy1: IQ_RES[0]=0xfe5d7008 IQ_RES[1]=0xb4f
[  104.322942] ath: phy1: IQ_RES[2]=0x21fb45e7 IQ_RES[3]=0x2bc0
[  104.322964] ath: phy1: IQ_RES[4]=0xc0024ffd IQ_RES[5]=0xfa52
[  104.322978] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  104.322991] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  104.323047] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  104.323099] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[  104.323151] ath: phy1: rx chain 1: iq corr coeff=1fe
[  104.323201] ath: phy1: Doing Tx IQ Cal for chain 1
[  104.323260] ath: phy1: IQ_RES[0]=0x16d9006 IQ_RES[1]=0xce0
[  104.323321] ath: phy1: IQ_RES[2]=0x25fa66e7 IQ_RES[3]=0x3350
[  104.323381] ath: phy1: IQ_RES[4]=0x3c027ffd IQ_RES[5]=0xf983
[  104.323433] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  104.323482] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  104.323531] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  104.323580] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[  104.323629] ath: phy1: rx chain 1: iq corr coeff=1fd
[  104.323721] ath: phy1: enabling IQ Calibration
[  104.323765] ath: phy1: starting IQ Mismatch Calibration
[  104.323814] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  104.323955] ath: phy1: Enable MIB counters
[  104.323982] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:2 cck:1
[  104.323997] ath: phy1: **** ofdmlevel 2=>3, rssi=48[lo=7 hi=40]
[  104.324010] ath: phy1: **** ccklevel 1=>2, rssi=48[lo=7 hi=40]
[  104.324075] ath: phy1: Starting ANI
[  104.621727] ath: phy1: MAC Hang signature not found at DCU complete
[  104.621773] ath: phy1: Possible baseband hang, busy=19 (try 1)
[  104.921598] ath: phy1: MAC Hang signature not found at DCU complete
[  104.921646] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  105.221384] ath: phy1: MAC Hang signature not found at DCU complete
[  105.221433] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  105.321412] ath: phy1: listenTime=928 OFDM:3 errs=7/s CCK:2 errs=1/s
ofdm_turn=0
[  105.321420] ath: phy1: tx hung, resetting the chip
[  105.321459] ath: phy1: **** ccklevel 2=>1, rssi=48[lo=7 hi=40]
[  105.321465] ath: phy1: Stopping ANI
[  105.321559] ath: phy1: Calibration @4294918608 finished:  short ani,
caldone: false
[  105.321806] ath: phy1: Disable MIB counters
[  105.321902] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  105.321938] ath: phy1: tsf: 174085093533 tsftu: 170004976
[  105.321959] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170005000
[  105.321991] ath: phy1: next DTIM 170005000
[  105.322008] ath: phy1: next beacon 170005000
[  105.322023] ath: phy1: beacon period 100
[  105.322039] ath: phy1: DTIM period 100
[  105.322679] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  105.322719] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  105.322738] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[  105.323747] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  105.323793] ath: phy1: ah->misc_mode 0x10000004
[  105.326702] ath: phy1: Doing Tx IQ Cal for chain 0
[  105.326731] ath: phy1: IQ_RES[0]=0xd50e02c IQ_RES[1]=0x9d0
[  105.326756] ath: phy1: IQ_RES[2]=0xef9d51d IQ_RES[3]=0x24c0
[  105.326780] ath: phy1: IQ_RES[4]=0x4fff7002 IQ_RES[5]=0xfbe2
[  105.326796] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  105.326810] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[  105.326823] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[  105.326837] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[  105.326850] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[  105.326862] ath: phy1: Doing Tx IQ Cal for chain 0
[  105.326888] ath: phy1: IQ_RES[0]=0xc570030 IQ_RES[1]=0xbb0
[  105.326916] ath: phy1: IQ_RES[2]=0xdfa8582 IQ_RES[3]=0x27a0
[  105.326945] ath: phy1: IQ_RES[4]=0x80001001 IQ_RES[5]=0xfb32
[  105.326967] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  105.326986] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  105.327002] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  105.327020] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[  105.327038] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[  105.327054] ath: phy1: Doing Tx IQ Cal for chain 0
[  105.327087] ath: phy1: IQ_RES[0]=0x1155102d IQ_RES[1]=0xbd0
[  105.327118] ath: phy1: IQ_RES[2]=0xffb3563 IQ_RES[3]=0x2690
[  105.327150] ath: phy1: IQ_RES[4]=0x71007fff IQ_RES[5]=0xfb22
[  105.327173] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  105.327192] ath: phy1: tx chain 0: mag corr=-1  phase corr=-3
[  105.327210] ath: phy1: tx chain 0: iq corr coeff=ffffff7d
[  105.327228] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  105.327246] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  105.327263] ath: phy1: Doing Tx IQ Cal for chain 0
[  105.327292] ath: phy1: IQ_RES[0]=0xa55102f IQ_RES[1]=0xc20
[  105.327315] ath: phy1: IQ_RES[2]=0xdfb2567 IQ_RES[3]=0x26d0
[  105.327339] ath: phy1: IQ_RES[4]=0x72005fff IQ_RES[5]=0xfb32
[  105.327354] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  105.327367] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  105.327380] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  105.327393] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[  105.327405] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[  105.327417] ath: phy1: Doing Tx IQ Cal for chain 0
[  105.327442] ath: phy1: IQ_RES[0]=0x105a303a IQ_RES[1]=0xd40
[  105.327466] ath: phy1: IQ_RES[2]=0x10fb55b1 IQ_RES[3]=0x2900
[  105.327489] ath: phy1: IQ_RES[4]=0x9500bffc IQ_RES[5]=0xfac2
[  105.327504] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  105.327517] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  105.327529] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  105.327542] ath: phy1: rx chain 0: mag corr=-6  phase corr=-7
[  105.327555] ath: phy1: rx chain 0: iq corr coeff=fffffcf9
[  105.327566] ath: phy1: Doing Tx IQ Cal for chain 0
[  105.327591] ath: phy1: IQ_RES[0]=0x16ae040 IQ_RES[1]=0xfb0
[  105.327615] ath: phy1: IQ_RES[2]=0xdf936c5 IQ_RES[3]=0x3090
[  105.327639] ath: phy1: IQ_RES[4]=0x10004ffa IQ_RES[5]=0xf9a3
[  105.327654] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  105.327667] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  105.327679] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  105.327692] ath: phy1: rx chain 0: mag corr=-6  phase corr=-2
[  105.327704] ath: phy1: rx chain 0: iq corr coeff=fffffcfe
[  105.327718] ath: phy1: Doing Tx IQ Cal for chain 1
[  105.327743] ath: phy1: IQ_RES[0]=0x755c01b IQ_RES[1]=0xa20
[  105.327767] ath: phy1: IQ_RES[2]=0x24fa4569 IQ_RES[3]=0x27e0
[  105.327790] ath: phy1: IQ_RES[4]=0x86018ff7 IQ_RES[5]=0xfaa2
[  105.327805] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  105.327818] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  105.327830] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  105.327843] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[  105.327855] ath: phy1: rx chain 1: iq corr coeff=fd
[  105.327867] ath: phy1: Doing Tx IQ Cal for chain 1
[  105.327892] ath: phy1: IQ_RES[0]=0x25c1011 IQ_RES[1]=0xaf0
[  105.327915] ath: phy1: IQ_RES[2]=0x25faa5d2 IQ_RES[3]=0x2b00
[  105.327940] ath: phy1: IQ_RES[4]=0xb601dffa IQ_RES[5]=0xfa62
[  105.327954] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  105.327967] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  105.327980] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  105.327995] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  105.328012] ath: phy1: rx chain 1: iq corr coeff=17e
[  105.328029] ath: phy1: Doing Tx IQ Cal for chain 1
[  105.328063] ath: phy1: IQ_RES[0]=0x159d009 IQ_RES[1]=0xaa0
[  105.328093] ath: phy1: IQ_RES[2]=0x21fb35a9 IQ_RES[3]=0x29f0
[  105.328122] ath: phy1: IQ_RES[4]=0xa4023ffb IQ_RES[5]=0xfaa2
[  105.328143] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  105.328162] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  105.328181] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  105.328200] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[  105.328219] ath: phy1: rx chain 1: iq corr coeff=1fd
[  105.328234] ath: phy1: Doing Tx IQ Cal for chain 1
[  105.328268] ath: phy1: IQ_RES[0]=0x59600a IQ_RES[1]=0xac0
[  105.328300] ath: phy1: IQ_RES[2]=0x20fb35a4 IQ_RES[3]=0x29b0
[  105.328331] ath: phy1: IQ_RES[4]=0xa1021ffc IQ_RES[5]=0xfac2
[  105.328354] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  105.328372] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  105.328387] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  105.328400] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  105.328412] ath: phy1: rx chain 1: iq corr coeff=17d
[  105.328424] ath: phy1: Doing Tx IQ Cal for chain 1
[  105.328449] ath: phy1: IQ_RES[0]=0x25d800b IQ_RES[1]=0xb30
[  105.328473] ath: phy1: IQ_RES[2]=0x21fb55e7 IQ_RES[3]=0x2bb0
[  105.328496] ath: phy1: IQ_RES[4]=0xc2024ffb IQ_RES[5]=0xfa72
[  105.328510] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  105.328523] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  105.328536] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  105.328549] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[  105.328561] ath: phy1: rx chain 1: iq corr coeff=17c
[  105.328572] ath: phy1: Doing Tx IQ Cal for chain 1
[  105.328597] ath: phy1: IQ_RES[0]=0xff6d9008 IQ_RES[1]=0xd0f
[  105.328621] ath: phy1: IQ_RES[2]=0x26fa76e9 IQ_RES[3]=0x3320
[  105.328644] ath: phy1: IQ_RES[4]=0x38029ffc IQ_RES[5]=0xf993
[  105.328658] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  105.328671] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  105.328684] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  105.328697] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[  105.328709] ath: phy1: rx chain 1: iq corr coeff=1fe
[  105.328767] ath: phy1: enabling IQ Calibration
[  105.328780] ath: phy1: starting IQ Mismatch Calibration
[  105.328829] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  105.328980] ath: phy1: Enable MIB counters
[  105.329009] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:1
[  105.329025] ath: phy1: **** ofdmlevel 3=>3, rssi=49[lo=7 hi=40]
[  105.329040] ath: phy1: **** ccklevel 1=>2, rssi=49[lo=7 hi=40]
[  105.329163] ath: phy1: Starting ANI
[  105.629259] ath: phy1: MAC Hang signature not found at DCU complete
[  105.629308] ath: phy1: Possible baseband hang, busy=16 (try 1)
[  105.929102] ath: phy1: MAC Hang signature not found at DCU complete
[  105.929150] ath: phy1: Possible baseband hang, busy=7 (try 1)
[  106.229022] ath: phy1: MAC Hang signature not found at DCU complete
[  106.229068] ath: phy1: Possible baseband hang, busy=3 (try 1)
[  106.328871] ath: phy1: listenTime=920 OFDM:3 errs=9/s CCK:2 errs=9/s
ofdm_turn=1
[  106.328897] ath: phy1: **** ofdmlevel 3=>2, rssi=49[lo=7 hi=40]
[  106.328921] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[  106.328937] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[  106.328954] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=920 ofdmErrs=9 cckErrs=9
[  106.329040] ath: phy1: Calibration @4294918860 finished:  short ani,
caldone: false
[  106.329168] ath: phy1: tx hung, resetting the chip
[  106.329247] ath: phy1: Stopping ANI
[  106.329489] ath: phy1: Disable MIB counters
[  106.329582] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  106.329617] ath: phy1: tsf: 174086101219 tsftu: 170005960
[  106.329639] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170006000
[  106.329679] ath: phy1: next DTIM 170006000
[  106.329710] ath: phy1: next beacon 170006000
[  106.329727] ath: phy1: beacon period 100
[  106.329743] ath: phy1: DTIM period 100
[  106.330441] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  106.330483] ath: phy1: NF calibrated [ctl] [chain 0] is -100
[  106.330506] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[  106.331500] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  106.331542] ath: phy1: ah->misc_mode 0x10000004
[  106.334486] ath: phy1: Doing Tx IQ Cal for chain 0
[  106.334518] ath: phy1: IQ_RES[0]=0xb50d02d IQ_RES[1]=0x9b0
[  106.334542] ath: phy1: IQ_RES[2]=0xbf9a51b IQ_RES[3]=0x24c0
[  106.334566] ath: phy1: IQ_RES[4]=0x51ff6001 IQ_RES[5]=0xfbc2
[  106.334582] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  106.334595] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  106.334608] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  106.334622] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[  106.334634] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[  106.334646] ath: phy1: Doing Tx IQ Cal for chain 0
[  106.334671] ath: phy1: IQ_RES[0]=0x957202a IQ_RES[1]=0xb60
[  106.334695] ath: phy1: IQ_RES[2]=0xcfa6580 IQ_RES[3]=0x2790
[  106.334718] ath: phy1: IQ_RES[4]=0x7fffd001 IQ_RES[5]=0xfb32
[  106.334733] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  106.334746] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[  106.334759] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[  106.334772] ath: phy1: rx chain 0: mag corr=-4  phase corr=-3
[  106.334785] ath: phy1: rx chain 0: iq corr coeff=fffffdfd
[  106.334796] ath: phy1: Doing Tx IQ Cal for chain 0
[  106.334821] ath: phy1: IQ_RES[0]=0xd54c033 IQ_RES[1]=0xc00
[  106.334845] ath: phy1: IQ_RES[2]=0xefb4561 IQ_RES[3]=0x26d0
[  106.334868] ath: phy1: IQ_RES[4]=0x6f006fff IQ_RES[5]=0xfb32
[  106.334883] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  106.334895] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  106.334908] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  106.334921] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[  106.334933] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[  106.334945] ath: phy1: Doing Tx IQ Cal for chain 0
[  106.334970] ath: phy1: IQ_RES[0]=0x9550035 IQ_RES[1]=0xbf0
[  106.334993] ath: phy1: IQ_RES[2]=0xbfb2561 IQ_RES[3]=0x26d0
[  106.335017] ath: phy1: IQ_RES[4]=0x70005ffc IQ_RES[5]=0xfaf2
[  106.335031] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  106.335044] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[  106.335056] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[  106.335069] ath: phy1: rx chain 0: mag corr=-7  phase corr=-5
[  106.335082] ath: phy1: rx chain 0: iq corr coeff=fffffc7b
[  106.335093] ath: phy1: Doing Tx IQ Cal for chain 0
[  106.335118] ath: phy1: IQ_RES[0]=0xe5a2036 IQ_RES[1]=0xd20
[  106.335142] ath: phy1: IQ_RES[2]=0x10fb05b0 IQ_RES[3]=0x2910
[  106.335165] ath: phy1: IQ_RES[4]=0x9400affe IQ_RES[5]=0xfab2
[  106.335179] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  106.335192] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  106.335205] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  106.335218] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[  106.335230] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[  106.335242] ath: phy1: Doing Tx IQ Cal for chain 0
[  106.335267] ath: phy1: IQ_RES[0]=0x76ac047 IQ_RES[1]=0xf70
[  106.335290] ath: phy1: IQ_RES[2]=0xef916c4 IQ_RES[3]=0x30d0
[  106.335313] ath: phy1: IQ_RES[4]=0x15004ff7 IQ_RES[5]=0xf973
[  106.335328] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  106.335341] ath: phy1: tx chain 0: mag corr=0  phase corr=-7
[  106.335353] ath: phy1: tx chain 0: iq corr coeff=fffffff9
[  106.335366] ath: phy1: rx chain 0: mag corr=-7  phase corr=-5
[  106.335379] ath: phy1: rx chain 0: iq corr coeff=fffffc7b
[  106.335392] ath: phy1: Doing Tx IQ Cal for chain 1
[  106.335417] ath: phy1: IQ_RES[0]=0x555901c IQ_RES[1]=0xa10
[  106.335440] ath: phy1: IQ_RES[2]=0x25fa3569 IQ_RES[3]=0x27e0
[  106.335464] ath: phy1: IQ_RES[4]=0x83016ff8 IQ_RES[5]=0xfaa2
[  106.335478] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  106.335491] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  106.335504] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  106.335516] ath: phy1: rx chain 1: mag corr=2  phase corr=-2
[  106.335529] ath: phy1: rx chain 1: iq corr coeff=fe
[  106.335540] ath: phy1: Doing Tx IQ Cal for chain 1
[  106.335565] ath: phy1: IQ_RES[0]=0x55c4010 IQ_RES[1]=0xb30
[  106.335588] ath: phy1: IQ_RES[2]=0x24fac5ce IQ_RES[3]=0x2ad0
[  106.335612] ath: phy1: IQ_RES[4]=0xb401eff7 IQ_RES[5]=0xfa62
[  106.335626] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  106.335639] ath: phy1: tx chain 1: mag corr=-4  phase corr=6
[  106.335651] ath: phy1: tx chain 1: iq corr coeff=fffffe06
[  106.335664] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[  106.335676] ath: phy1: rx chain 1: iq corr coeff=17c
[  106.335688] ath: phy1: Doing Tx IQ Cal for chain 1
[  106.335713] ath: phy1: IQ_RES[0]=0x359800e IQ_RES[1]=0xab0
[  106.335736] ath: phy1: IQ_RES[2]=0x20fb25a7 IQ_RES[3]=0x29d0
[  106.335760] ath: phy1: IQ_RES[4]=0xa1021ffc IQ_RES[5]=0xfa92
[  106.335774] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  106.335787] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  106.335799] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  106.335812] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  106.335824] ath: phy1: rx chain 1: iq corr coeff=17d
[  106.335835] ath: phy1: Doing Tx IQ Cal for chain 1
[  106.335861] ath: phy1: IQ_RES[0]=0x594009 IQ_RES[1]=0xab0
[  106.335884] ath: phy1: IQ_RES[2]=0x1ffb55a3 IQ_RES[3]=0x2990
[  106.335907] ath: phy1: IQ_RES[4]=0xa0022ffd IQ_RES[5]=0xfad2
[  106.335922] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  106.335934] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  106.335947] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  106.335960] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  106.335972] ath: phy1: rx chain 1: iq corr coeff=17e
[  106.335983] ath: phy1: Doing Tx IQ Cal for chain 1
[  106.336008] ath: phy1: IQ_RES[0]=0x15d700d IQ_RES[1]=0xb20
[  106.336032] ath: phy1: IQ_RES[2]=0x20fb55e6 IQ_RES[3]=0x2b80
[  106.336055] ath: phy1: IQ_RES[4]=0xc0023ffc IQ_RES[5]=0xfa82
[  106.336069] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  106.336082] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  106.336095] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  106.336107] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  106.336119] ath: phy1: rx chain 1: iq corr coeff=17d
[  106.336131] ath: phy1: Doing Tx IQ Cal for chain 1
[  106.336156] ath: phy1: IQ_RES[0]=0x16d600c IQ_RES[1]=0xd20
[  106.336179] ath: phy1: IQ_RES[2]=0x26fa56e6 IQ_RES[3]=0x3320
[  106.336203] ath: phy1: IQ_RES[4]=0x3a029ffd IQ_RES[5]=0xf993
[  106.336217] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  106.336230] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  106.336242] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  106.336255] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  106.336267] ath: phy1: rx chain 1: iq corr coeff=17e
[  106.336325] ath: phy1: enabling IQ Calibration
[  106.336338] ath: phy1: starting IQ Mismatch Calibration
[  106.336386] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  106.336586] ath: phy1: Enable MIB counters
[  106.336618] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:2 cck:2
[  106.336633] ath: phy1: **** ofdmlevel 2=>3, rssi=49[lo=7 hi=40]
[  106.336649] ath: phy1: **** ccklevel 2=>2, rssi=49[lo=7 hi=40]
[  106.336723] ath: phy1: Starting ANI
[  106.636841] ath: phy1: MAC Hang signature not found at DCU complete
[  106.636887] ath: phy1: Possible baseband hang, busy=16 (try 1)
[  106.936617] ath: phy1: MAC Hang signature not found at DCU complete
[  106.936663] ath: phy1: Possible baseband hang, busy=20 (try 1)
[  107.236501] ath: phy1: MAC Hang signature not found at DCU complete
[  107.236549] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  107.336236] ath: phy1: listenTime=883 OFDM:3 errs=14/s CCK:2
errs=15/s ofdm_turn=0
[  107.336264] ath: phy1: **** ccklevel 2=>1, rssi=49[lo=7 hi=40]
[  107.336349] ath: phy1: Calibration @4294919112 finished:  short ani,
caldone: false
[  107.336508] ath: phy1: tx hung, resetting the chip
[  107.336580] ath: phy1: Stopping ANI
[  107.336798] ath: phy1: Disable MIB counters
[  107.336985] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  107.337019] ath: phy1: tsf: 174087108629 tsftu: 170006944
[  107.337043] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170007000
[  107.337074] ath: phy1: next DTIM 170007000
[  107.337091] ath: phy1: next beacon 170007000
[  107.337108] ath: phy1: beacon period 100
[  107.337124] ath: phy1: DTIM period 100
[  107.337537] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  107.337573] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  107.337594] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[  107.338572] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  107.338614] ath: phy1: ah->misc_mode 0x10000004
[  107.341567] ath: phy1: Doing Tx IQ Cal for chain 0
[  107.341609] ath: phy1: IQ_RES[0]=0xd51002a IQ_RES[1]=0x970
[  107.341644] ath: phy1: IQ_RES[2]=0xbf9a51d IQ_RES[3]=0x24e0
[  107.341677] ath: phy1: IQ_RES[4]=0x50ff6001 IQ_RES[5]=0xfbc2
[  107.341703] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  107.341725] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  107.341744] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  107.341764] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  107.341784] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  107.341802] ath: phy1: Doing Tx IQ Cal for chain 0
[  107.341836] ath: phy1: IQ_RES[0]=0xe570029 IQ_RES[1]=0xb50
[  107.341870] ath: phy1: IQ_RES[2]=0xafa657f IQ_RES[3]=0x2760
[  107.341903] ath: phy1: IQ_RES[4]=0x80ffd001 IQ_RES[5]=0xfb32
[  107.341929] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  107.341949] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  107.341968] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  107.341989] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[  107.342008] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[  107.342025] ath: phy1: Doing Tx IQ Cal for chain 0
[  107.342060] ath: phy1: IQ_RES[0]=0x1054f031 IQ_RES[1]=0xbf0
[  107.342093] ath: phy1: IQ_RES[2]=0xefb2562 IQ_RES[3]=0x26b0
[  107.342127] ath: phy1: IQ_RES[4]=0x72005fff IQ_RES[5]=0xfb02
[  107.342152] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  107.342172] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  107.342191] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  107.342211] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[  107.342231] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[  107.342248] ath: phy1: Doing Tx IQ Cal for chain 0
[  107.342282] ath: phy1: IQ_RES[0]=0x954f032 IQ_RES[1]=0xc30
[  107.342315] ath: phy1: IQ_RES[2]=0xcfb4564 IQ_RES[3]=0x26c0
[  107.342348] ath: phy1: IQ_RES[4]=0x71005ffd IQ_RES[5]=0xfb32
[  107.342373] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  107.342393] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  107.342412] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  107.342433] ath: phy1: rx chain 0: mag corr=-6  phase corr=-4
[  107.342451] ath: phy1: rx chain 0: iq corr coeff=fffffcfc
[  107.342468] ath: phy1: Doing Tx IQ Cal for chain 0
[  107.342499] ath: phy1: IQ_RES[0]=0xd5a4036 IQ_RES[1]=0xd30
[  107.342531] ath: phy1: IQ_RES[2]=0xefaf5b0 IQ_RES[3]=0x2910
[  107.342564] ath: phy1: IQ_RES[4]=0x9600affd IQ_RES[5]=0xfac2
[  107.342588] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  107.342609] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  107.342628] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  107.342648] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[  107.342667] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[  107.342685] ath: phy1: Doing Tx IQ Cal for chain 0
[  107.342719] ath: phy1: IQ_RES[0]=0x16b1046 IQ_RES[1]=0xf50
[  107.342752] ath: phy1: IQ_RES[2]=0xbf946c0 IQ_RES[3]=0x30c0
[  107.342785] ath: phy1: IQ_RES[4]=0x13003ff9 IQ_RES[5]=0xf973
[  107.342808] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  107.342828] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[  107.342848] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[  107.342868] ath: phy1: rx chain 0: mag corr=-7  phase corr=-2
[  107.342887] ath: phy1: rx chain 0: iq corr coeff=fffffc7e
[  107.342907] ath: phy1: Doing Tx IQ Cal for chain 1
[  107.342941] ath: phy1: IQ_RES[0]=0x555d01a IQ_RES[1]=0xa00
[  107.342975] ath: phy1: IQ_RES[2]=0x24fa4567 IQ_RES[3]=0x27e0
[  107.343008] ath: phy1: IQ_RES[4]=0x84016ff6 IQ_RES[5]=0xfaa2
[  107.343031] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  107.343052] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  107.343071] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  107.343091] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[  107.343109] ath: phy1: rx chain 1: iq corr coeff=fd
[  107.343127] ath: phy1: Doing Tx IQ Cal for chain 1
[  107.343161] ath: phy1: IQ_RES[0]=0x35c000f IQ_RES[1]=0xb10
[  107.343194] ath: phy1: IQ_RES[2]=0x23fa85ce IQ_RES[3]=0x2ad0
[  107.343227] ath: phy1: IQ_RES[4]=0xb401dff9 IQ_RES[5]=0xfa52
[  107.343251] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  107.343271] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  107.343290] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  107.343309] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  107.343328] ath: phy1: rx chain 1: iq corr coeff=17d
[  107.343345] ath: phy1: Doing Tx IQ Cal for chain 1
[  107.343379] ath: phy1: IQ_RES[0]=0x159a00b IQ_RES[1]=0xa90
[  107.343412] ath: phy1: IQ_RES[2]=0x21fb45a7 IQ_RES[3]=0x29d0
[  107.343444] ath: phy1: IQ_RES[4]=0xa3020ffb IQ_RES[5]=0xfa92
[  107.343468] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  107.343488] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  107.343507] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  107.343526] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  107.343545] ath: phy1: rx chain 1: iq corr coeff=17d
[  107.343561] ath: phy1: Doing Tx IQ Cal for chain 1
[  107.343593] ath: phy1: IQ_RES[0]=0x159400c IQ_RES[1]=0xa80
[  107.343624] ath: phy1: IQ_RES[2]=0x1dfb65a2 IQ_RES[3]=0x2990
[  107.343655] ath: phy1: IQ_RES[4]=0xa0021ffd IQ_RES[5]=0xfab2
[  107.343677] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  107.343695] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  107.343708] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  107.343721] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  107.343733] ath: phy1: rx chain 1: iq corr coeff=17e
[  107.343744] ath: phy1: Doing Tx IQ Cal for chain 1
[  107.343770] ath: phy1: IQ_RES[0]=0x5d700b IQ_RES[1]=0xb30
[  107.343794] ath: phy1: IQ_RES[2]=0x21fb55e4 IQ_RES[3]=0x2ba0
[  107.343817] ath: phy1: IQ_RES[4]=0xbe023ffd IQ_RES[5]=0xfa82
[  107.343831] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  107.343844] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  107.343857] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  107.343869] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  107.343882] ath: phy1: rx chain 1: iq corr coeff=17e
[  107.343893] ath: phy1: Doing Tx IQ Cal for chain 1
[  107.343918] ath: phy1: IQ_RES[0]=0x46d2006 IQ_RES[1]=0xcf0
[  107.343941] ath: phy1: IQ_RES[2]=0x25fa66e8 IQ_RES[3]=0x3320
[  107.343964] ath: phy1: IQ_RES[4]=0x37028ffe IQ_RES[5]=0xf993
[  107.343979] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  107.343991] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  107.344004] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  107.344017] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[  107.344029] ath: phy1: rx chain 1: iq corr coeff=1fd
[  107.344147] ath: phy1: enabling IQ Calibration
[  107.344193] ath: phy1: starting IQ Mismatch Calibration
[  107.344267] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  107.344470] ath: phy1: Enable MIB counters
[  107.344519] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:1
[  107.344561] ath: phy1: **** ofdmlevel 3=>3, rssi=48[lo=7 hi=40]
[  107.344602] ath: phy1: **** ccklevel 1=>2, rssi=48[lo=7 hi=40]
[  107.344684] ath: phy1: Starting ANI
[  107.644336] ath: phy1: MAC Hang signature not found at DCU complete
[  107.644384] ath: phy1: Possible baseband hang, busy=15 (try 1)
[  107.944164] ath: phy1: MAC Hang signature not found at DCU complete
[  107.944211] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  108.243962] ath: phy1: MAC Hang signature not found at DCU complete
[  108.244007] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  108.343899] ath: phy1: listenTime=933 OFDM:3 errs=8/s CCK:2 errs=8/s
ofdm_turn=1
[  108.343926] ath: phy1: **** ofdmlevel 3=>2, rssi=48[lo=7 hi=40]
[  108.343950] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[  108.343966] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[  108.343983] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=933 ofdmErrs=8 cckErrs=8
[  108.344068] ath: phy1: Calibration @4294919364 finished:  short ani,
caldone: false
[  108.344198] ath: phy1: tx hung, resetting the chip
[  108.344283] ath: phy1: Stopping ANI
[  108.344615] ath: phy1: Disable MIB counters
[  108.344862] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  108.344903] ath: phy1: tsf: 174088116519 tsftu: 170007928
[  108.344925] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170008000
[  108.344959] ath: phy1: next DTIM 170008000
[  108.344977] ath: phy1: next beacon 170008000
[  108.344992] ath: phy1: beacon period 100
[  108.345006] ath: phy1: DTIM period 100
[  108.345445] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  108.345482] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  108.345504] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[  108.346491] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  108.346534] ath: phy1: ah->misc_mode 0x10000004
[  108.349470] ath: phy1: Doing Tx IQ Cal for chain 0
[  108.349512] ath: phy1: IQ_RES[0]=0xa50e02a IQ_RES[1]=0x9a0
[  108.349548] ath: phy1: IQ_RES[2]=0xcf9d51a IQ_RES[3]=0x24c0
[  108.349581] ath: phy1: IQ_RES[4]=0x50ff6002 IQ_RES[5]=0xfbc2
[  108.349607] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  108.349627] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  108.349646] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  108.349665] ath: phy1: rx chain 0: mag corr=-4  phase corr=-4
[  108.349684] ath: phy1: rx chain 0: iq corr coeff=fffffdfc
[  108.349702] ath: phy1: Doing Tx IQ Cal for chain 0
[  108.349737] ath: phy1: IQ_RES[0]=0xc56e02c IQ_RES[1]=0xb50
[  108.349769] ath: phy1: IQ_RES[2]=0xcfa1582 IQ_RES[3]=0x2790
[  108.349802] ath: phy1: IQ_RES[4]=0x7fffd000 IQ_RES[5]=0xfb42
[  108.349827] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  108.349847] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  108.349867] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  108.349887] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[  108.349906] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[  108.349924] ath: phy1: Doing Tx IQ Cal for chain 0
[  108.349956] ath: phy1: IQ_RES[0]=0xe54f02e IQ_RES[1]=0xbf0
[  108.349986] ath: phy1: IQ_RES[2]=0xffb3561 IQ_RES[3]=0x26a0
[  108.350019] ath: phy1: IQ_RES[4]=0x72005ffe IQ_RES[5]=0xfb32
[  108.350042] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  108.350063] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  108.350083] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  108.350102] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[  108.350122] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[  108.350139] ath: phy1: Doing Tx IQ Cal for chain 0
[  108.350173] ath: phy1: IQ_RES[0]=0xa54e032 IQ_RES[1]=0xc20
[  108.350206] ath: phy1: IQ_RES[2]=0xdfb4564 IQ_RES[3]=0x26c0
[  108.350239] ath: phy1: IQ_RES[4]=0x71003ffd IQ_RES[5]=0xfaf2
[  108.350263] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  108.350283] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  108.350303] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  108.350322] ath: phy1: rx chain 0: mag corr=-6  phase corr=-4
[  108.350341] ath: phy1: rx chain 0: iq corr coeff=fffffcfc
[  108.350359] ath: phy1: Doing Tx IQ Cal for chain 0
[  108.350393] ath: phy1: IQ_RES[0]=0xd5a0036 IQ_RES[1]=0xd30
[  108.350426] ath: phy1: IQ_RES[2]=0x11fb05b2 IQ_RES[3]=0x28f0
[  108.350460] ath: phy1: IQ_RES[4]=0x96009fff IQ_RES[5]=0xfad2
[  108.350484] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  108.350504] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  108.350523] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  108.350543] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[  108.350562] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[  108.350580] ath: phy1: Doing Tx IQ Cal for chain 0
[  108.350614] ath: phy1: IQ_RES[0]=0x26ae046 IQ_RES[1]=0xf90
[  108.350647] ath: phy1: IQ_RES[2]=0xef936c2 IQ_RES[3]=0x30b0
[  108.350680] ath: phy1: IQ_RES[4]=0x16005ff9 IQ_RES[5]=0xf973
[  108.350704] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  108.350724] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[  108.350742] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[  108.350763] ath: phy1: rx chain 0: mag corr=-7  phase corr=-3
[  108.350782] ath: phy1: rx chain 0: iq corr coeff=fffffc7d
[  108.350802] ath: phy1: Doing Tx IQ Cal for chain 1
[  108.350836] ath: phy1: IQ_RES[0]=0x555801a IQ_RES[1]=0xa20
[  108.350869] ath: phy1: IQ_RES[2]=0x22fa5568 IQ_RES[3]=0x27e0
[  108.350901] ath: phy1: IQ_RES[4]=0x83016ff8 IQ_RES[5]=0xfab2
[  108.350925] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  108.350945] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  108.350963] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  108.350981] ath: phy1: rx chain 1: mag corr=2  phase corr=-2
[  108.350998] ath: phy1: rx chain 1: iq corr coeff=fe
[  108.351014] ath: phy1: Doing Tx IQ Cal for chain 1
[  108.351047] ath: phy1: IQ_RES[0]=0x45c3012 IQ_RES[1]=0xae0
[  108.351071] ath: phy1: IQ_RES[2]=0x22fac5ce IQ_RES[3]=0x2ae0
[  108.351095] ath: phy1: IQ_RES[4]=0xb701fff9 IQ_RES[5]=0xfa52
[  108.351110] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  108.351123] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  108.351135] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  108.351148] ath: phy1: rx chain 1: mag corr=2  phase corr=-4
[  108.351161] ath: phy1: rx chain 1: iq corr coeff=fc
[  108.351172] ath: phy1: Doing Tx IQ Cal for chain 1
[  108.351197] ath: phy1: IQ_RES[0]=0x359800d IQ_RES[1]=0xac0
[  108.351220] ath: phy1: IQ_RES[2]=0x1ffb35a6 IQ_RES[3]=0x29c0
[  108.351244] ath: phy1: IQ_RES[4]=0xa3021ff9 IQ_RES[5]=0xfab2
[  108.351258] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  108.351271] ath: phy1: tx chain 1: mag corr=-3  phase corr=5
[  108.351284] ath: phy1: tx chain 1: iq corr coeff=fffffe85
[  108.351297] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[  108.351309] ath: phy1: rx chain 1: iq corr coeff=17c
[  108.351320] ath: phy1: Doing Tx IQ Cal for chain 1
[  108.351345] ath: phy1: IQ_RES[0]=0x1593008 IQ_RES[1]=0xa90
[  108.351369] ath: phy1: IQ_RES[2]=0x1efb75a2 IQ_RES[3]=0x29b0
[  108.351393] ath: phy1: IQ_RES[4]=0xa0023ffd IQ_RES[5]=0xfaa2
[  108.351407] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  108.351420] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  108.351432] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  108.351445] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  108.351457] ath: phy1: rx chain 1: iq corr coeff=17d
[  108.351468] ath: phy1: Doing Tx IQ Cal for chain 1
[  108.351494] ath: phy1: IQ_RES[0]=0x15d4009 IQ_RES[1]=0xb20
[  108.351517] ath: phy1: IQ_RES[2]=0x21fb45e5 IQ_RES[3]=0x2ba0
[  108.351605] ath: phy1: IQ_RES[4]=0xc0024fff IQ_RES[5]=0xfa62
[  108.351629] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  108.351648] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  108.351665] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  108.351685] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[  108.351725] ath: phy1: rx chain 1: iq corr coeff=1fe
[  108.351762] ath: phy1: Doing Tx IQ Cal for chain 1
[  108.351809] ath: phy1: IQ_RES[0]=0x36d6006 IQ_RES[1]=0xce0
[  108.351856] ath: phy1: IQ_RES[2]=0x25fa86e3 IQ_RES[3]=0x3330
[  108.351904] ath: phy1: IQ_RES[4]=0x3b027fff IQ_RES[5]=0xf983
[  108.351943] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  108.351982] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  108.352020] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  108.352059] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[  108.352097] ath: phy1: rx chain 1: iq corr coeff=1fd
[  108.352177] ath: phy1: enabling IQ Calibration
[  108.352214] ath: phy1: starting IQ Mismatch Calibration
[  108.352288] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  108.352501] ath: phy1: Enable MIB counters
[  108.352541] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:2 cck:2
[  108.352565] ath: phy1: **** ofdmlevel 2=>3, rssi=49[lo=7 hi=40]
[  108.352588] ath: phy1: **** ccklevel 2=>2, rssi=49[lo=7 hi=40]
[  108.352659] ath: phy1: Starting ANI
[  108.651824] ath: phy1: MAC Hang signature not found at DCU complete
[  108.651870] ath: phy1: Possible baseband hang, busy=12 (try 1)
[  108.951460] ath: phy1: MAC Hang signature not found at DCU complete
[  108.951506] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  109.251305] ath: phy1: MAC Hang signature not found at DCU complete
[  109.251353] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  109.351190] ath: phy1: listenTime=944 OFDM:3 errs=1/s CCK:2 errs=7/s
ofdm_turn=0
[  109.351225] ath: phy1: **** ccklevel 2=>1, rssi=49[lo=7 hi=40]
[  109.351318] ath: phy1: Calibration @4294919616 finished:  short ani,
caldone: false
[  109.351401] ath: phy1: tx hung, resetting the chip
[  109.351478] ath: phy1: Stopping ANI
[  109.351676] ath: phy1: Disable MIB counters
[  109.351910] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  109.351945] ath: phy1: tsf: 174089123568 tsftu: 170008911
[  109.351967] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170009000
[  109.351997] ath: phy1: next DTIM 170009000
[  109.352014] ath: phy1: next beacon 170009000
[  109.352030] ath: phy1: beacon period 100
[  109.352045] ath: phy1: DTIM period 100
[  109.352455] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  109.352497] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  109.352537] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[  109.353356] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  109.353399] ath: phy1: ah->misc_mode 0x10000004
[  109.356363] ath: phy1: Doing Tx IQ Cal for chain 0
[  109.356404] ath: phy1: IQ_RES[0]=0xe50d029 IQ_RES[1]=0x9c0
[  109.356439] ath: phy1: IQ_RES[2]=0xdf9e518 IQ_RES[3]=0x24b0
[  109.356472] ath: phy1: IQ_RES[4]=0x4eff6001 IQ_RES[5]=0xfbc2
[  109.356498] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  109.356519] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[  109.356538] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[  109.356559] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  109.356578] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  109.356595] ath: phy1: Doing Tx IQ Cal for chain 0
[  109.356629] ath: phy1: IQ_RES[0]=0xc56d02c IQ_RES[1]=0xb80
[  109.356662] ath: phy1: IQ_RES[2]=0xefa2580 IQ_RES[3]=0x27b0
[  109.356694] ath: phy1: IQ_RES[4]=0x7effe002 IQ_RES[5]=0xfb32
[  109.356718] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  109.356738] ath: phy1: tx chain 0: mag corr=0  phase corr=-2
[  109.356758] ath: phy1: tx chain 0: iq corr coeff=fffffffe
[  109.356778] ath: phy1: rx chain 0: mag corr=-4  phase corr=-4
[  109.356797] ath: phy1: rx chain 0: iq corr coeff=fffffdfc
[  109.356815] ath: phy1: Doing Tx IQ Cal for chain 0
[  109.356849] ath: phy1: IQ_RES[0]=0xf54f031 IQ_RES[1]=0xbc0
[  109.356882] ath: phy1: IQ_RES[2]=0xefaf55d IQ_RES[3]=0x26a0
[  109.356914] ath: phy1: IQ_RES[4]=0x70007fff IQ_RES[5]=0xfb42
[  109.356938] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  109.356958] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  109.356975] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  109.356994] ath: phy1: rx chain 0: mag corr=-5  phase corr=-6
[  109.357013] ath: phy1: rx chain 0: iq corr coeff=fffffd7a
[  109.357030] ath: phy1: Doing Tx IQ Cal for chain 0
[  109.357065] ath: phy1: IQ_RES[0]=0x854f030 IQ_RES[1]=0xc10
[  109.357097] ath: phy1: IQ_RES[2]=0xcfb1563 IQ_RES[3]=0x26c0
[  109.357130] ath: phy1: IQ_RES[4]=0x71008ffd IQ_RES[5]=0xfb22
[  109.357154] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  109.357174] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  109.357194] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  109.357214] ath: phy1: rx chain 0: mag corr=-6  phase corr=-4
[  109.357233] ath: phy1: rx chain 0: iq corr coeff=fffffcfc
[  109.357250] ath: phy1: Doing Tx IQ Cal for chain 0
[  109.357285] ath: phy1: IQ_RES[0]=0xb5a103a IQ_RES[1]=0xd50
[  109.357316] ath: phy1: IQ_RES[2]=0xffb35b0 IQ_RES[3]=0x28b0
[  109.357348] ath: phy1: IQ_RES[4]=0x8f009ffb IQ_RES[5]=0xfae2
[  109.357371] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  109.357390] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  109.357410] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  109.357429] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[  109.357448] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[  109.357466] ath: phy1: Doing Tx IQ Cal for chain 0
[  109.357499] ath: phy1: IQ_RES[0]=0x46a8044 IQ_RES[1]=0xf70
[  109.357529] ath: phy1: IQ_RES[2]=0xdf916c0 IQ_RES[3]=0x3060
[  109.357559] ath: phy1: IQ_RES[4]=0xe005ff9 IQ_RES[5]=0xf983
[  109.357582] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  109.357599] ath: phy1: tx chain 0: mag corr=0  phase corr=-6
[  109.357616] ath: phy1: tx chain 0: iq corr coeff=fffffffa
[  109.357635] ath: phy1: rx chain 0: mag corr=-7  phase corr=-3
[  109.357652] ath: phy1: rx chain 0: iq corr coeff=fffffc7d
[  109.357672] ath: phy1: Doing Tx IQ Cal for chain 1
[  109.357704] ath: phy1: IQ_RES[0]=0x755b01b IQ_RES[1]=0xa20
[  109.357736] ath: phy1: IQ_RES[2]=0x24fa4565 IQ_RES[3]=0x27e0
[  109.357768] ath: phy1: IQ_RES[4]=0x83016ff8 IQ_RES[5]=0xfa92
[  109.357790] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  109.357809] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  109.357826] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  109.357844] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[  109.357861] ath: phy1: rx chain 1: iq corr coeff=fd
[  109.357875] ath: phy1: Doing Tx IQ Cal for chain 1
[  109.357903] ath: phy1: IQ_RES[0]=0x35be011 IQ_RES[1]=0xae0
[  109.357926] ath: phy1: IQ_RES[2]=0x22faa5cd IQ_RES[3]=0x2af0
[  109.357949] ath: phy1: IQ_RES[4]=0xb401effb IQ_RES[5]=0xfa62
[  109.357964] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  109.357977] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  109.357990] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  109.358003] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  109.358015] ath: phy1: rx chain 1: iq corr coeff=17e
[  109.358026] ath: phy1: Doing Tx IQ Cal for chain 1
[  109.358051] ath: phy1: IQ_RES[0]=0x259500d IQ_RES[1]=0xac0
[  109.358075] ath: phy1: IQ_RES[2]=0x21fb35a5 IQ_RES[3]=0x29f0
[  109.358098] ath: phy1: IQ_RES[4]=0xa3021ffd IQ_RES[5]=0xfaa2
[  109.358112] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  109.358125] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  109.358138] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  109.358151] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  109.358163] ath: phy1: rx chain 1: iq corr coeff=17d
[  109.358174] ath: phy1: Doing Tx IQ Cal for chain 1
[  109.358200] ath: phy1: IQ_RES[0]=0x358d00b IQ_RES[1]=0xab0
[  109.358223] ath: phy1: IQ_RES[2]=0x20fb85a1 IQ_RES[3]=0x2990
[  109.358245] ath: phy1: IQ_RES[4]=0xa0021ffd IQ_RES[5]=0xfac2
[  109.358260] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  109.358273] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  109.358285] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  109.358298] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  109.358310] ath: phy1: rx chain 1: iq corr coeff=17d
[  109.358322] ath: phy1: Doing Tx IQ Cal for chain 1
[  109.358347] ath: phy1: IQ_RES[0]=0x15d5008 IQ_RES[1]=0xb60
[  109.358370] ath: phy1: IQ_RES[2]=0x23fb55e2 IQ_RES[3]=0x2b90
[  109.358393] ath: phy1: IQ_RES[4]=0xc0025ffd IQ_RES[5]=0xfa72
[  109.358408] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  109.358420] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  109.358433] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  109.358446] ath: phy1: rx chain 1: mag corr=4  phase corr=-3
[  109.358458] ath: phy1: rx chain 1: iq corr coeff=1fd
[  109.358469] ath: phy1: Doing Tx IQ Cal for chain 1
[  109.358494] ath: phy1: IQ_RES[0]=0x36d4008 IQ_RES[1]=0xd20
[  109.358518] ath: phy1: IQ_RES[2]=0x27fa46e8 IQ_RES[3]=0x3320
[  109.358540] ath: phy1: IQ_RES[4]=0x39028fff IQ_RES[5]=0xf983
[  109.358555] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  109.358568] ath: phy1: tx chain 1: mag corr=-3  phase corr=8
[  109.358580] ath: phy1: tx chain 1: iq corr coeff=fffffe88
[  109.358593] ath: phy1: rx chain 1: mag corr=4  phase corr=-2
[  109.358605] ath: phy1: rx chain 1: iq corr coeff=1fe
[  109.358662] ath: phy1: enabling IQ Calibration
[  109.358676] ath: phy1: starting IQ Mismatch Calibration
[  109.358722] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  109.358875] ath: phy1: Enable MIB counters
[  109.358903] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:3 cck:1
[  109.358918] ath: phy1: **** ofdmlevel 3=>3, rssi=52[lo=7 hi=40]
[  109.358934] ath: phy1: **** ccklevel 1=>2, rssi=52[lo=7 hi=40]
[  109.359000] ath: phy1: Starting ANI
[  109.655265] ath: phy1: MAC Hang signature not found at DCU complete
[  109.655313] ath: phy1: Possible baseband hang, busy=6 (try 1)
[  109.955105] ath: phy1: MAC Hang signature not found at DCU complete
[  109.955153] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  110.254784] ath: phy1: MAC Hang signature not found at DCU complete
[  110.254829] ath: phy1: Possible baseband hang, busy=5 (try 1)
[  110.354855] ath: phy1: listenTime=953 OFDM:3 errs=8/s CCK:2 errs=7/s
ofdm_turn=1
[  110.354883] ath: phy1: **** ofdmlevel 3=>2, rssi=52[lo=7 hi=40]
[  110.354908] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[  110.354924] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[  110.354941] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=953 ofdmErrs=8 cckErrs=7
[  110.355022] ath: phy1: Calibration @4294919867 finished:  short ani,
caldone: false
[  110.554771] ath: phy1: MAC Hang signature not found at DCU complete
[  110.554801] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  110.854631] ath: phy1: MAC Hang signature not found at DCU complete
[  110.854681] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  111.301634] ath: phy1: MAC Hang signature not found at DCU complete
[  111.301675] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  111.301698] ath: phy1: tx hung, resetting the chip
[  111.301765] ath: phy1: Stopping ANI
[  111.302042] ath: phy1: Disable MIB counters
[  111.302132] ath: phy1: Reconfigure beacon timers based on
synchronized timestamp
[  111.302160] ath: phy1: tsf: 174091073820 tsftu: 170010816
[  111.302177] ath: phy1: bmiss: 10 sleep: 100 cfp-period: 100 maxdur: 0
next: 170010900
[  111.302203] ath: phy1: next DTIM 170010900
[  111.302215] ath: phy1: next beacon 170010900
[  111.302227] ath: phy1: beacon period 100
[  111.302238] ath: phy1: DTIM period 100
[  111.302817] ath: phy1: Reset to 2437 MHz, HT40: 0 fastcc: 0
[  111.302855] ath: phy1: NF calibrated [ctl] [chain 0] is -99
[  111.302875] ath: phy1: NF calibrated [ctl] [chain 1] is -103
[  111.303876] ath: phy1: ver 448.3 opmode 2 chan 2437 Mhz
[  111.303920] ath: phy1: ah->misc_mode 0x10000004
[  111.306883] ath: phy1: Doing Tx IQ Cal for chain 0
[  111.306924] ath: phy1: IQ_RES[0]=0xe50c02a IQ_RES[1]=0x9b0
[  111.306954] ath: phy1: IQ_RES[2]=0xbf9d517 IQ_RES[3]=0x24b0
[  111.306986] ath: phy1: IQ_RES[4]=0x4fff6001 IQ_RES[5]=0xfbd2
[  111.307010] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  111.307031] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  111.307050] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  111.307070] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  111.307089] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  111.307107] ath: phy1: Doing Tx IQ Cal for chain 0
[  111.307142] ath: phy1: IQ_RES[0]=0xf56b02c IQ_RES[1]=0xb60
[  111.307175] ath: phy1: IQ_RES[2]=0xdfa6581 IQ_RES[3]=0x27a0
[  111.307208] ath: phy1: IQ_RES[4]=0x7dffd002 IQ_RES[5]=0xfb42
[  111.307233] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  111.307253] ath: phy1: tx chain 0: mag corr=0  phase corr=-3
[  111.307273] ath: phy1: tx chain 0: iq corr coeff=fffffffd
[  111.307293] ath: phy1: rx chain 0: mag corr=-4  phase corr=-5
[  111.307311] ath: phy1: rx chain 0: iq corr coeff=fffffdfb
[  111.307328] ath: phy1: Doing Tx IQ Cal for chain 0
[  111.307362] ath: phy1: IQ_RES[0]=0x1054a02c IQ_RES[1]=0xbd0
[  111.307394] ath: phy1: IQ_RES[2]=0x10fb755d IQ_RES[3]=0x2670
[  111.307427] ath: phy1: IQ_RES[4]=0x6f005fff IQ_RES[5]=0xfb22
[  111.307451] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  111.307472] ath: phy1: tx chain 0: mag corr=-1  phase corr=-2
[  111.307491] ath: phy1: tx chain 0: iq corr coeff=ffffff7e
[  111.307509] ath: phy1: rx chain 0: mag corr=-4  phase corr=-6
[  111.307527] ath: phy1: rx chain 0: iq corr coeff=fffffdfa
[  111.307543] ath: phy1: Doing Tx IQ Cal for chain 0
[  111.307574] ath: phy1: IQ_RES[0]=0xb54e02f IQ_RES[1]=0xc00
[  111.307603] ath: phy1: IQ_RES[2]=0xcfb6562 IQ_RES[3]=0x26a0
[  111.307630] ath: phy1: IQ_RES[4]=0x71004fff IQ_RES[5]=0xfb32
[  111.307646] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  111.307659] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  111.307671] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  111.307684] ath: phy1: rx chain 0: mag corr=-5  phase corr=-4
[  111.307697] ath: phy1: rx chain 0: iq corr coeff=fffffd7c
[  111.307708] ath: phy1: Doing Tx IQ Cal for chain 0
[  111.307733] ath: phy1: IQ_RES[0]=0xf5a0039 IQ_RES[1]=0xd40
[  111.307757] ath: phy1: IQ_RES[2]=0x11fb55ae IQ_RES[3]=0x28e0
[  111.307780] ath: phy1: IQ_RES[4]=0x9200affe IQ_RES[5]=0xfad2
[  111.307795] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  111.307808] ath: phy1: tx chain 0: mag corr=0  phase corr=-4
[  111.307820] ath: phy1: tx chain 0: iq corr coeff=fffffffc
[  111.307833] ath: phy1: rx chain 0: mag corr=-6  phase corr=-5
[  111.307846] ath: phy1: rx chain 0: iq corr coeff=fffffcfb
[  111.307857] ath: phy1: Doing Tx IQ Cal for chain 0
[  111.307882] ath: phy1: IQ_RES[0]=0x26aa041 IQ_RES[1]=0xf70
[  111.307905] ath: phy1: IQ_RES[2]=0xdf956bd IQ_RES[3]=0x3060
[  111.307929] ath: phy1: IQ_RES[4]=0xf004ffa IQ_RES[5]=0xf9a3
[  111.307944] ath: phy1: chain 0: mag mismatch=0 phase mismatch=0
[  111.307956] ath: phy1: tx chain 0: mag corr=0  phase corr=-5
[  111.307969] ath: phy1: tx chain 0: iq corr coeff=fffffffb
[  111.307982] ath: phy1: rx chain 0: mag corr=-6  phase corr=-2
[  111.307994] ath: phy1: rx chain 0: iq corr coeff=fffffcfe
[  111.308008] ath: phy1: Doing Tx IQ Cal for chain 1
[  111.308033] ath: phy1: IQ_RES[0]=0x8557019 IQ_RES[1]=0xa30
[  111.308057] ath: phy1: IQ_RES[2]=0x24fa3564 IQ_RES[3]=0x27c0
[  111.308080] ath: phy1: IQ_RES[4]=0x80015ff7 IQ_RES[5]=0xfab2
[  111.308094] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  111.308107] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  111.308120] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  111.308133] ath: phy1: rx chain 1: mag corr=2  phase corr=-3
[  111.308145] ath: phy1: rx chain 1: iq corr coeff=fd
[  111.308156] ath: phy1: Doing Tx IQ Cal for chain 1
[  111.308182] ath: phy1: IQ_RES[0]=0x5be010 IQ_RES[1]=0xb00
[  111.308205] ath: phy1: IQ_RES[2]=0x22fab5ce IQ_RES[3]=0x2ad0
[  111.308229] ath: phy1: IQ_RES[4]=0xb401eff9 IQ_RES[5]=0xfa42
[  111.308243] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  111.308256] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  111.308269] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  111.308282] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  111.308294] ath: phy1: rx chain 1: iq corr coeff=17e
[  111.308305] ath: phy1: Doing Tx IQ Cal for chain 1
[  111.308330] ath: phy1: IQ_RES[0]=0x559500e IQ_RES[1]=0xab0
[  111.308354] ath: phy1: IQ_RES[2]=0x23fb45a3 IQ_RES[3]=0x29c0
[  111.308377] ath: phy1: IQ_RES[4]=0xa3021ffc IQ_RES[5]=0xfa92
[  111.308391] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  111.308404] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  111.308417] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  111.308430] ath: phy1: rx chain 1: mag corr=3  phase corr=-4
[  111.308442] ath: phy1: rx chain 1: iq corr coeff=17c
[  111.308453] ath: phy1: Doing Tx IQ Cal for chain 1
[  111.308478] ath: phy1: IQ_RES[0]=0xff59300a IQ_RES[1]=0xabf
[  111.308502] ath: phy1: IQ_RES[2]=0x20fb45a0 IQ_RES[3]=0x2980
[  111.308525] ath: phy1: IQ_RES[4]=0xa1021ffc IQ_RES[5]=0xfab2
[  111.308539] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  111.308552] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  111.308565] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  111.308578] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  111.308590] ath: phy1: rx chain 1: iq corr coeff=17e
[  111.308601] ath: phy1: Doing Tx IQ Cal for chain 1
[  111.308626] ath: phy1: IQ_RES[0]=0x25d300b IQ_RES[1]=0xb50
[  111.308649] ath: phy1: IQ_RES[2]=0x20fb35e2 IQ_RES[3]=0x2b70
[  111.308673] ath: phy1: IQ_RES[4]=0xbd023ffd IQ_RES[5]=0xfa72
[  111.308687] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  111.308700] ath: phy1: tx chain 1: mag corr=-3  phase corr=6
[  111.308712] ath: phy1: tx chain 1: iq corr coeff=fffffe86
[  111.308725] ath: phy1: rx chain 1: mag corr=3  phase corr=-3
[  111.308737] ath: phy1: rx chain 1: iq corr coeff=17d
[  111.308748] ath: phy1: Doing Tx IQ Cal for chain 1
[  111.308774] ath: phy1: IQ_RES[0]=0x16d000a IQ_RES[1]=0xce0
[  111.308797] ath: phy1: IQ_RES[2]=0x25fa66e2 IQ_RES[3]=0x32c0
[  111.308820] ath: phy1: IQ_RES[4]=0x36029ffe IQ_RES[5]=0xf983
[  111.308835] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
[  111.308848] ath: phy1: tx chain 1: mag corr=-3  phase corr=7
[  111.308860] ath: phy1: tx chain 1: iq corr coeff=fffffe87
[  111.308873] ath: phy1: rx chain 1: mag corr=3  phase corr=-2
[  111.308885] ath: phy1: rx chain 1: iq corr coeff=17e
[  111.308942] ath: phy1: enabling IQ Calibration
[  111.308956] ath: phy1: starting IQ Mismatch Calibration
[  111.309004] ath: phy1: Enabled BB Watchdog timeout (25 ms)
[  111.309157] ath: phy1: Enable MIB counters
[  111.309185] ath: phy1: Restore history: opmode 2 chan 2437 Mhz
is_scanning=0 ofdm:2 cck:2
[  111.309200] ath: phy1: **** ofdmlevel 2=>3, rssi=47[lo=7 hi=40]
[  111.309216] ath: phy1: **** ccklevel 2=>2, rssi=47[lo=7 hi=40]
[  111.309280] ath: phy1: Starting ANI
[  111.606868] ath: phy1: MAC Hang signature not found at DCU complete
[  111.606914] ath: phy1: Possible baseband hang, busy=5 (try 1)
[  111.906952] ath: phy1: MAC Hang signature not found at DCU complete
[  111.906990] ath: phy1: Possible baseband hang, busy=3 (try 1)
[  112.207226] ath: phy1: MAC Hang signature not found at DCU complete
[  112.207273] ath: phy1: Possible baseband hang, busy=3 (try 1)
[  112.307242] ath: phy1: listenTime=1867 OFDM:3 errs=6/s CCK:2 errs=2/s
ofdm_turn=0
[  112.307276] ath: phy1: **** ccklevel 2=>1, rssi=47[lo=7 hi=40]
[  112.307376] ath: phy1: Calibration @4294920355 finished:  short ani,
caldone: false
[  112.507301] ath: phy1: MAC Hang signature not found at DCU complete
[  112.507348] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  112.807426] ath: phy1: MAC Hang signature not found at DCU complete
[  112.807472] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  113.307654] ath: phy1: listenTime=957 OFDM:3 errs=10/s CCK:1 errs=3/s
ofdm_turn=1
[  113.307680] ath: phy1: **** ofdmlevel 3=>2, rssi=47[lo=7 hi=40]
[  113.307704] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1[level]=6 ini=8
[  113.307720] ath: phy1: ** ch 2437: level 3=>2[def:3]
cycpwrThr1Ext[level]=6 ini=8
[  113.307737] ath: phy1: ANI parameters: SI=2, ofdmWS=on FS=2 MRCcck=on
listenTime=957 ofdmErrs=10 cckErrs=3
[  113.307822] ath: phy1: Calibration @4294920605 finished:  short ani,
caldone: false
[  113.312507] ath: phy1: MAC Hang signature not found at DCU complete
[  113.312553] ath: phy1: Possible baseband hang, busy=0 (try 1)


