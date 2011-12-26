Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59415 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1LZA77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 19:59:59 -0500
Received: by eekc4 with SMTP id c4so10769179eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Dec 2011 16:59:58 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 25 Dec 2011 16:59:57 -0800
Message-ID: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com> (sfid-20111226_020034_171907_DADE6E59)
Subject: Realtek rtl8192se in AP mode?
From: Jean-Luc Duprat <jld@acm.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to find out whether the Realtek rtl8192se is
known to be stable and reliable in AP mode.  It certainly
became functional with kernel 3.0 and I can get the interface
into master mode, but whenever I try to connect to it my laptop reports
connection timeouts.  Digging a little more with wireshark, it
seems that authentication packets exchanged, but no association
packets are coming through...

I have detailed the details of my configuration in a post in the fedora forums:
http://forums.fedoraforum.org/showthread.php?p=1533542

Since this is a small-factor mini-ITX box, I'd like to get the
built-in adapter to work.  Any reports of success using this chip in AP mode?
I'm happy to help track down and debug any issues.

JL

--

Details on the setup follow:

$ uname -a
Linux foo.bar.net 3.1.6-1.fc16.i686 #1 SMP Wed Dec 21 23:18:01 UTC
2011 i686 i686 i386 GNU/Linux

$ lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory
Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME
Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express
Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express
Port 3 (rev 02)
00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 02)
01:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
03:00.0 Network controller: Realtek Semiconductor Co., Ltd.
RTL8191SEvA Wireless LAN Controller (rev 10)

$ lspci -vv -s 03:00.0
03:00.0 Network controller: Realtek Semiconductor Co., Ltd.
RTL8191SEvA Wireless LAN Controller (rev 10)
	Subsystem: AzureWave Device 1107
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at ec00 [size=256]
	Region 1: Memory at febfc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se
	Kernel modules: rtl8192se

$ iw list
Wiphy phy0
	Band 1:
		Capabilities: 0x1862
			HT20/HT40
			Static SM Power Save
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 16 usec (0x07)
		HT TX/RX MCS rate indexes supported: 0-7, 32
		Frequencies:
			* 2412 MHz [1] (20.0 dBm)
			* 2417 MHz [2] (20.0 dBm)
			* 2422 MHz [3] (20.0 dBm)
			* 2427 MHz [4] (20.0 dBm)
			* 2432 MHz [5] (20.0 dBm)
			* 2437 MHz [6] (20.0 dBm)
			* 2442 MHz [7] (20.0 dBm)
			* 2447 MHz [8] (20.0 dBm)
			* 2452 MHz [9] (20.0 dBm)
			* 2457 MHz [10] (20.0 dBm)
			* 2462 MHz [11] (20.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
		Bitrates (non-HT):
			* 1.0 Mbps
			* 2.0 Mbps
			* 5.5 Mbps
			* 11.0 Mbps
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	RTS threshold: 2347
	Coverage class: 0 (up to 0m)
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	interface combinations are not supported
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * new_beacon
		 * new_station
		 * new_mpath
		 * set_mesh_params
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * join_mesh
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * action
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
	Supported RX frame types:
		 * IBSS: 0x00d0
		 * managed: 0x0040 0x00d0
		 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * mesh point: 0x00b0 0x00c0 0x00d0
		 * P2P-client: 0x0040 0x00d0
		 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0

$ iw dev wlan0 info
Interface wlan0
	ifindex 4
	type AP
	wiphy 3

$ iwconfig wlan0
wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=20 dBm
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:on

I have the output of hostapd in the linked post, it shows:

wlan0: STA 00:1e:c2:bb:c0:42 IEEE 802.11: authentication OK (open system)

but there never are any association messages going through.
Here is a wireshark capture of the packets seen on the server:

$ cat wscap
1MOyoQIABAAAAAAAAAAAAP//AAB/AAAAJcX3To+QAQBYAAAAWAAAAAAADgAOAAAAAAJsCYAEQAAA
AP///////wAnEEy69P///////6DAAAR0ZXN0AQgCBAsWDBIYJDIEMEhgbC0aNAkX//8AAAAAAAAA
AAAAAAAAAAAAAAAAAAAlxfdOJpEBAEEAAABBAAAAAAAOAALAAAAMAAAAAABQAAAAACcQTLr04Lml
cpxY4LmlcpxYAAAAAAAAAAAAAGQAAQAABHRlc3QBBIKECxYDAQElxfdOvA4CACwAAAAsAAAAAAAO
AA4AAAAADGwJgASwADwA4LmlcpxYACcQTLr04LmlcpxYsMAAAAEAAAAlxfdOLBACACwAAAAsAAAA
AAAOAALAAAAIAAAAAACwAAAAACcQTLr04LmlcpxY4LmlcpxYAAAAAAIAAAAlxfdOpjEFADIAAAAy
AAAAAAAOAA4AAAAADGwJgATAADwA4LmlcpxYACcQTLr04LmlcpxYwMABAN0IABc1AQgADAAlxfdO
jrAFAFgAAABYAAAAAAAOAA4AAAAAAmwJgARAAAAA////////ACcQTLr0////////AMEABHRlc3QB
CAIECxYMEhgkMgQwSGBsLRowCRf//wAAAAAAAAAAAAAAAAAAAAAAAAAAACXF904jsQUAQQAAAEEA
AAAAAA4AAsAAAAwAAAAAAFAAAAAAJxBMuvTguaVynFjguaVynFgAAAAAAAAAAAAAZAABAAAEdGVz
dAEEgoQLFgMBASXF904dEQkAWAAAAFgAAAAAAA4ADgAAAAACbAmABEAAAAD///////8AJxBMuvT/
///////wwQAEdGVzdAEIAgQLFgwSGCQyBDBIYGwtGjAJF///AAAAAAAAAAAAAAAAAAAAAAAAAAAA
JcX3TrQRCQBBAAAAQQAAAAAADgACwAAADAAAAAAAUAAAAAAnEEy69OC5pXKcWOC5pXKcWAAAAAAA
AAAAAABkAAEAAAR0ZXN0AQSChAsWAwEBJcX3TrYVCQBYAAAAWAAAAAAADgAOAAAAAAJsCYAEQAAA
AP///////wAnEEy69P///////wDCAAR0ZXN0AQgCBAsWDBIYJDIEMEhgbC0aMAkX//8AAAAAAAAA
AAAAAAAAAAAAAAAAAAAlxfdOLxYJAEEAAABBAAAAAAAOAALAAAAMAAAAAABQAAAAACcQTLr04Lml
cpxY4LmlcpxYAAAAAAAAAAAAAGQAAQAABHRlc3QBBIKECxYDAQElxfdORYQJAFgAAABYAAAAAAAO
AA4AAAAAAmwJgARAAAAA////////ACcQTLr0////////IMIABHRlc3QBCAIECxYMEhgkMgQwSGBs
LRowCRf//wAAAAAAAAAAAAAAAAAAAAAAAAAAACXF907XhAkAQQAAAEEAAAAAAA4AAsAAAAwAAAAA
AFAAAAAAJxBMuvTguaVynFjguaVynFgAAAAAAAAAAAAAZAABAAAEdGVzdAEEgoQLFgMBASjF9052
JAoAWAAAAFgAAAAAAA4ADgAAAAACbAmABEAAAAD///////8AJxBMuvT///////9QwgAEdGVzdAEI
AgQLFgwSGCQyBDBIYGwtGjAJF///AAAAAAAAAAAAAAAAAAAAAAAAAAAAKMX3TkUlCgBBAAAAQQAA
AAAADgACwAAADAAAAAAAUAAAAAAnEEy69OC5pXKcWOC5pXKcWAAAAAAAAAAAAABkAAEAAAR0ZXN0
AQSChAsWAwEBKMX3TuEnCgBYAAAAWAAAAAAADgAOAAAAAAJsCYAEQAAAAP///////wAnEEy69P//
/////2DCAAR0ZXN0AQgCBAsWDBIYJDIEMEhgbC0aMAkX//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAo
xfdOgSgKAEEAAABBAAAAAAAOAALAAAAMAAAAAABQAAAAACcQTLr04LmlcpxY4LmlcpxYAAAAAAAA
AAAAAGQAAQAABHRlc3QBBIKECxYDAQEoxfdOmo0NAFgAAABYAAAAAAAOAA4AAAAAAmwJgARAAAAA
////////ACcQTLr0////////UMMABHRlc3QBCAIECxYMEhgkMgQwSGBsLRowCRf//wAAAAAAAAAA
AAAAAAAAAAAAAAAAACjF904Djg0AQQAAAEEAAAAAAA4AAsAAAAwAAAAAAFAAAAAAJxBMuvTguaVy
nFjguaVynFgAAAAAAAAAAAAAZAABAAAEdGVzdAEEgoQLFgMBASjF906Hkw0AWAAAAFgAAAAAAA4A
DgAAAAACbAmABEAAAAD///////8AJxBMuvT///////9gwwAEdGVzdAEIAgQLFgwSGCQyBDBIYGwt
GjAJF///AAAAAAAAAAAAAAAAAAAAAAAAAAAAKMX3TseTDQBBAAAAQQAAAAAADgACwAAADAAAAAAA
UAAAAAAnEEy69OC5pXKcWOC5pXKcWAAAAAAAAAAAAABkAAEAAAR0ZXN0AQSChAsWAwEBKMX3TtP6
DQBYAAAAWAAAAAAADgAOAAAAAAJsCYAEQAAAAP///////wAnEEy69P///////3DDAAR0ZXN0AQgC
BAsWDBIYJDIEMEhgbC0aMAkX//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAoxfdOXfsNAEEAAABBAAAA
AAAOAALAAAAMAAAAAABQAAAAACcQTLr04LmlcpxY4LmlcpxYAAAAAAAAAAAAAGQAAQAABHRlc3QB
BIKECxYDAQEoxfdOeAAOAFgAAABYAAAAAAAOAA4AAAAAAmwJgARAAAAA////////ACcQTLr0////
////gMMABHRlc3QBCAIECxYMEhgkMgQwSGBsLRowCRf//wAAAAAAAAAAAAAAAAAAAAAAAAAAACjF
907gAA4AQQAAAEEAAAAAAA4AAsAAAAwAAAAAAFAAAAAAJxBMuvTguaVynFjguaVynFgAAAAAAAAA
AAAAZAABAAAEdGVzdAEEgoQLFgMBASvF9063PQ4ALAAAACwAAAAAAA4ADgAAAAAMbAmABLAAPADg
uaVynFgAJxBMuvTguaVynFiQwwAAAQAAACvF906ePg4ALAAAACwAAAAAAA4AAsAAAAgAAAAAALAA
AAAAJxBMuvTguaVynFjguaVynFgAAAAAAgAAACzF904BGgIAMgAAADIAAAAAAA4ADgAAAAAMbAmA
BMAAPADguaVynFgAJxBMuvTguaVynFigwwEA3QgAFzUBCAAMAA==
