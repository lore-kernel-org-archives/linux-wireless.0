Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48994 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3DNCmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 22:42:55 -0400
Received: from [50.54.140.2] (50-54-140-2.evrt.wa.frontiernet.net [50.54.140.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r3E2gsQ7014642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 13 Apr 2013 19:42:54 -0700
Message-ID: <516A17AE.3030501@candelatech.com> (sfid-20130414_044311_857720_B5426FFE)
Date: Sat, 13 Apr 2013 19:42:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Associated but not 'connected' in hacked 3.8.0 on Samsung 5 550 chromebook.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm testing out a Chromos Samsung series 5 550 netbook, with an AR9300 2x2
NIC in it (as it came from factory..haven't cracked it open yet).

I'm using the 3.8.0 kernel-next chromos kernel, with my own hacks on top
of this, so of course it could be my problem.  Not the easiest thing to
upgrade a kernel on, so I haven't tried bisecting yet...

OS is ChrUbuntu 11.04, 64-bit.

My problem is that when I use several virtual-stations, it seems only one
of them actually connects.  For the rest, I see only associated messages,
for instance, wlan0 works fine:

2013-04-13 19:23:03.833  1.1:  wlan0 (phy #0): scan started
2013-04-13 19:23:03.833  1.1:  wlan0 (phy #0): scan finished: 5180, ""
2013-04-13 19:23:03.833  1.1:  wlan0: new station 00:00:00:10:10:03
2013-04-13 19:23:03.833  1.1:  wlan0 (phy #0): auth 00:00:00:10:10:03 -> 74:e5:43:d6:07:b3 status: 0: Successful
2013-04-13 19:23:03.833  1.1:  wlan0 (phy #0): assoc 00:00:00:10:10:03 -> 74:e5:43:d6:07:b3 status: 0: Successful
2013-04-13 19:23:03.833  1.1:  wlan0 (phy #0): connected to 00:00:00:10:10:03


But at least most of the time, the others do not:

2013-04-13 19:32:54.345  1.1:  sta1 (phy #0): scan started
2013-04-13 19:32:54.345  1.1:  sta1 (phy #0): scan aborted: 5180, ""
2013-04-13 19:32:54.345  1.1:  sta1: new station 00:00:00:10:10:03
2013-04-13 19:32:54.345  1.1:  sta1 (phy #0): auth 00:00:00:10:10:03 -> 00:ff:ff:00:00:02 status: 0: Successful
2013-04-13 19:32:55.343  1.1:  sta1 (phy #0): assoc 00:00:00:10:10:03 -> 00:ff:ff:00:00:02 status: 0: Successful
2013-04-13 19:33:07.917  1.1:  sta2: del station 00:00:00:10:10:03
2013-04-13 19:33:11.571  1.1:  sta2 (phy #0): scan started
2013-04-13 19:33:11.571  1.1:  sta2 (phy #0): scan aborted: 5180, ""
2013-04-13 19:33:11.571  1.1:  sta2: new station 00:00:00:10:10:03
2013-04-13 19:33:11.571  1.1:  sta2 (phy #0): auth 00:00:00:10:10:03 -> 00:ff:ff:00:00:03 status: 0: Successful
2013-04-13 19:33:11.605  1.1:  sta2 (phy #0): assoc 00:00:00:10:10:03 -> 00:ff:ff:00:00:03 status: 0: Successful


01:00.0 Network controller: Atheros Communications Inc. AR9300 Wireless LAN adaptor (rev 01)
	Subsystem: Samsung Electronics Co Ltd Device 4107
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e0400000 (64-bit, non-prefetchable) [size=128K]
	Expansion ROM at e0420000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [300 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k
	Kernel modules: ath9k

dmesg looks like this:

[102429.235352] sta1: dropped data frame to not associated station 00:00:00:10:10:03
[102429.282128] sta1: authenticate with 00:00:00:10:10:03
[102429.282159] sta1: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[102429.282341] sta1: send auth to 00:00:00:10:10:03 (try 1/3)
[102429.284391] sta1: authenticated
[102429.285360] sta1: associate with 00:00:00:10:10:03 (try 1/3)
[102429.287160] sta1: RX AssocResp from 00:00:00:10:10:03 (capab=0x1 status=0 aid=2)
[102429.287333] sta1: associated
[102429.287762] IPv6: ADDRCONF(NETDEV_CHANGE): sta1: link becomes ready
[102469.857761] IPv6: ADDRCONF(NETDEV_UP): sta0: link is not ready
[102469.857947] wiphy0: start_sw_scan: running-other-vifs: 1  running-station-vifs: 3, associated-stations: 2 scanning current channel: 5180 MHz
[102469.857972] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 6, associated-stations: 4 scanning current channel: 5180 MHz
[102469.885805] IPv6: ADDRCONF(NETDEV_UP): sta0: link is not ready
[102469.905588] sta0: authenticate with 00:00:00:10:10:03
[102469.905625] sta0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[102469.905796] sta0: send auth to 00:00:00:10:10:03 (try 1/3)
[102469.907424] sta0: authenticated
[102469.908554] sta0: associate with 00:00:00:10:10:03 (try 1/3)
[102469.910534] sta0: RX AssocResp from 00:00:00:10:10:03 (capab=0x1 status=0 aid=1)
[102469.910702] sta0: associated
[102469.911152] IPv6: ADDRCONF(NETDEV_CHANGE): sta0: link becomes ready


I'm curious if anyone has any suggestions as to what might be the cause or where
to start digging in the code.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

