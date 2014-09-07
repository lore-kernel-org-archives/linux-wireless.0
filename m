Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sto15.st-oneline.net ([195.225.241.75]:58468 "EHLO
	sto15.st-oneline.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaIGRkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 13:40:18 -0400
Received: from [192.168.100.9] (pD9E50316.dip0.t-ipconnect.de [217.229.3.22])
	(authenticated bits=0)
	by sto15.st-oneline.net  with ESMTP id s87HWQPe028256
	for <linux-wireless@vger.kernel.org>; Sun, 7 Sep 2014 19:32:28 +0200
Message-ID: <540C96A8.3020708@czekalla.com> (sfid-20140907_194025_553488_B611C291)
Date: Sun, 07 Sep 2014 19:32:24 +0200
From: "Dr. Ralf Czekalla" <ralf@czekalla.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Fwd: [opensuse-kernel] rtl8187se - serious regressions since merge
 out of staging into 818x
References: <540C8E35.10908@czekalla.com>
In-Reply-To: <540C8E35.10908@czekalla.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Guys,

I have several serious regressions since the rtl8187se staging driver
was merged into the generic rtl818x_pci driver with kernel 3.15.

With my Netbook for travels I have now...

1. Wireless transfer rate dropped seriously from about 2.5 MByte/s
crushed down to 700 kByte/s in Linux kernels 3.15 and 3.16!

2. Signal rate always says 15% even if I'm right next to the WLAN
router! No possibility any more to determine which WLAN router is the
strongest (most nearby) in hotels. Weaker WLANs in neighborhood seems
not to be shown also because of this weakness.

3. The device can not be switched off any more by keyboard or plasma-nm
and is always switched on - security risk!


I'm now forced to go back to 3.14 - and the staging driver for rtl8187se 
- where I only can find an early 3.14.4 on my private local copy of OBS 
stable kernels.
There, with 3.14, everything is back to normal!

I like to test the newest kernels but this seriously prevents me.

BTW, I'm not the only one facing these problems:
http://www.pclinuxos.com/forum/index.php?topic=127276.0

Here some data:

:~ # iwlist wlan0 scan
wlan0     Scan completed :
           Cell 01 - Address: BC:xx:xx:xx:xx:3D
                     Channel:3
                     Frequency:2.422 GHz (Channel 3)
                     Quality=15/100  Signal level=15/100
                     Encryption key:on
                     ESSID:"xxxxxxxxxxxxxxxx"
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s
                     Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                     Mode:Master
                     Extra:tsf=000011886cd93c9c
                     Extra: Last beacon: 6ms ago
                     IE: IEEE 802.11i/WPA2 Version 1
                         Group Cipher : CCMP
                         Pairwise Ciphers (1) : CCMP
                         Authentication Suites (1) : PSK

:~ # lspci -vvv
05:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8187SE
Wireless LAN Controller (rev 22)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL8187SE Wireless
LAN Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: I/O ports at e800 [size=256]
         Region 1: Memory at febfc000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<128ns, L1 <2us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                         ClockPM+ Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn-
ChkCap+ ChkEn-
         Capabilities: [140 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 00-00-xx-xx-xx-xx-10-00
         Kernel driver in use: rtl818x_pci
         Kernel modules: rtl818x_pci


:~ # iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"xxxxxxxxxxxx"
           Mode:Managed  Frequency:2.422 GHz  Access Point: 
xx:xx:xx:xx:xx:3D
           Bit Rate=11 Mb/s   Tx-Power=20 dBm
           Retry short limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=15/100  Signal level=15/100
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:430  Invalid misc:486   Missed beacon:0



:~ # ifconfig
wlan0     Link encap:Ethernet  HWaddr 00:xx:xx:xx:xx:AD
           inet addr:xx.xx.xx.1  Bcast:xx.xx.xx.255  Mask:255.255.255.0
           inet6 addr: xxxx::xxx:xxxx:xxxx:xxxx/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:3321100 errors:0 dropped:0 overruns:0 frame:0
           TX packets:1946015 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:4926099909 (4697.8 Mb)  TX bytes:182336218 (173.8 Mb)




Best regards
Ralf
