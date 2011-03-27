Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout8.freenet.de ([195.4.92.98]:33803 "EHLO mout8.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab1C0MHa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 08:07:30 -0400
Received: from [195.4.92.14] (helo=4.mx.freenet.de)
	by mout8.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #3)
	id 1Q3okg-0003aS-7S
	for linux-wireless@vger.kernel.org; Sun, 27 Mar 2011 14:07:26 +0200
Received: from p54a18467.dip0.t-ipconnect.de ([84.161.132.103]:51691 helo=mail.maya.org)
	by 4.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1Q3okf-0005cc-RH
	for linux-wireless@vger.kernel.org; Sun, 27 Mar 2011 14:07:26 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p2RC7KJa003366
	for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2011 14:07:20 +0200
Message-ID: <4D8F28C1.4060402@justmail.de>
Date: Sun, 27 Mar 2011 14:08:33 +0200
From: =?ISO-8859-1?Q?Klaus_M=FCller?= <kmueller@justmail.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: broken ath9k-driver - problems with creating new TCP-connections.
 Bad performance
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm running kernel 2.6.38.1 (from the OpenSuSE buildservice on OpenSuSE
11.4) and compat-wireless-2011-03-26 (the performance / functionality of
the driver delivered with 2.6.38.1 is unusable).


Hardware is:

05:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
Network Adapter (PCI-Express) (rev 01)
        Subsystem: AzureWave Device 1089
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1+,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
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
        Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
        Capabilities: [170 v1] Power Budgeting <?>
        Kernel driver in use: ath9k


iwconfig wlan0

wlan0     IEEE 802.11bgn  ESSID:"ssid"
          Mode:Managed  Frequency:2.412 GHz  Access Point:
00:25:33:22:11:00
          Bit Rate=150 Mb/s   Tx-Power=17 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=14/70  Signal level=-63 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:4  Invalid misc:1423   Missed beacon:0


I run iwconfig 3 times in 7 seconds. The link quality alternated between
47 and 14.



from dmesg:

[44322.665996] cfg80211: Calling CRDA to update world regulatory domain
[44322.671992] cfg80211: World regulatory domain updated:
[44322.672013] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[44322.672016] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[44322.672018] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[44322.672020] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[44322.672022] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[44322.672024] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[44322.672040] cfg80211: Calling CRDA for country: DE
[44322.675940] cfg80211: Regulatory domain changed to country: DE
[44322.675943] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[44322.675945] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[44322.675946] cfg80211:     (5150000 KHz - 5350000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[44322.675948] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz),
(N/A, 2698 mBm)
[44322.718450] ath9k 0000:05:00.0: PCI INT A -> GSI 19 (level, low) ->
IRQ 19
[44322.718464] ath9k 0000:05:00.0: setting latency timer to 64
[44322.769376] ath: EEPROM regdomain: 0x60
[44322.769377] ath: EEPROM indicates we should expect a direct regpair map
[44322.769380] ath: Country alpha2 being used: 00
[44322.769381] ath: Regpair used: 0x60
[44322.771077] ieee80211 phy0: Selected rate control algorithm
'ath9k_rate_control'
[44322.771635] Registered led device: ath9k-phy0
[44322.771649] ieee80211 phy0: Atheros AR9285 Rev:2
mem=0xffffc900049e0000, irq=19
[44352.572121] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[44353.795313] wlan0: authenticate with 00:25:33:22:11:00 (try 1)
[44353.797269] wlan0: authenticated
[44353.797297] wlan0: associate with 00:25:33:22:11:00 (try 1)
[44353.800439] wlan0: RX AssocResp from 00:25:33:22:11:00 (capab=0x431
status=0 aid=31)
[44353.800444] wlan0: associated
[44353.800447] wlan0: invalid aid value 31; bits 15:14 not set
[44353.807136] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[44364.240181] wlan0: no IPv6 routers present
lines 2150-2187/2187 (END)


The connection to the AP is built with wpa_supplicant's driver wext
(WPA2-TLS).


What are the problems?

1. The performance of the driver alternates (at the same point of the
antenna) very highly. Measured with netperf, it is between 10 and 72^6
bits/sec (input). It seems to be relevant, if the notebook has just been
booted or if the driver has been reloaded / reconnected (reconnection
with wpa_supplicant often doesn't work at all without reloading the driver).
Output is more stable, it's mostly at about 70^6 bits/sec.

2. Running audio data via upnp e.g., must be continuous. It is
impossible with ath9k to get a continuous data stream (input). There are
all few minutes / seconds distortions.
I traced the wlan0-device with wireshark. I can see, that the distortion
happens after closing the old TCP-connection (FIN/ACK-sequence) and
building the new TCP-connection with SYN. Between the FIN/ACK and the
next SYN-package can be more than 3 seconds!
After that break, I can see 3 (!!!) SYN packets at the same time going out.

3. The connection is unstable - the link quality alternates between 14
and 47 at the same place. This sould be more constant.

4. The Tx-Power is 17 - it should be 20.

5. iwconfig says, that the encryption key is off. Does this mean, that
hardware encryption doesn't work at all?

iwlist wlan0 encryption says:

wlan0     2 key sizes : 40, 104bits
          4 keys available :
                [1]: off
                [2]: 1234-5678-9012-3456-6789-0123-4567-8901 (128 bits)
                [3]: 0123-4567-8901-2345-6789-0123-5678-1234 (128 bits)
                [4]: off
          Current Transmit Key: [1]




What is not the problem:
- the server
- the AP
- the WLAN


Why can't these elements be the problem?
I've got a WUSB600N rt3572sta-based wlan usb stick, running with the
ralink driver (on the same notebook at the same place). If this usb wlan
chip is used, the data stream is always continuous and the performance
(in- and output) is above 76^6 bits/sec.


I would be happy if somebody could fix these problems. If you need more
information, please ask - I will try to provide it.


Klaus Mueller
