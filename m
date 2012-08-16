Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s11.blu0.hotmail.com ([65.55.111.86]:7486 "EHLO
	blu0-omc2-s11.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab2HPDWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 23:22:33 -0400
Message-ID: <BLU0-SMTP344F6F7B3E1F2CD39D5B52CF2B50@phx.gbl> (sfid-20120816_052248_208284_1A6D06D2)
Date: Wed, 15 Aug 2012 23:22:27 -0400
From: Richie Gress <searchfgold67899@live.com>
To: linux-wireless@vger.kernel.org
CC: 1030858@bugs.launchpad.net
Subject: 0bda:8176 RTL8188CUS does not connect to wireless networks
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1] Summary of Problem.
0bda:8176 RTL8188CUS does not connect to wireless networks

[2] Full description of the Problem.
The RTL8188CUS USB wireless card will not connect to wireless networks. The connection is attempted over and over again, and the password prompt reappears each time if the network has one, but a connection is never established.
There is a workaround for this bug: Drivers can be obtained from the Realtek website. But they are required in order for the hardware to function properly.

[3] Keywords. (I have no idea what these are so I did my best)
wireless, rtl8192CU, rtlwifi, rtl8192cu_common, RTL8188CUS, kernel, upstream

[4] Kernel version.
`cat /proc/version'
Linux version 3.6.0-030600rc1-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201208022056 SMP Fri Aug 3 01:04:00 UTC 2012

[5] Not a kernel oops.

[6] Not applicable.

[7] Environment.
`lsb_release -rd'
Description:	Ubuntu 12.04 LTS
Release:	12.04

[7.1] Software.
`sh /usr/src/linux-headers-3.6.0-030600rc1/scripts/ver_linux'
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux richie-abacus 3.6.0-030600rc1-generic #201208022056 SMP Fri Aug 3 01:04:00 UTC 2012 i686 i686 i386 GNU/Linux
 
Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         arc4 rtl8192cu rtl8192c_common rtlwifi mac80211 cfg80211 nls_iso8859_1 bnep rfcomm bluetooth dm_crypt snd_maestro3 snd_ac97_codec xircom_cb ac97_bus snd_pcm joydev snd_page_alloc snd_seq_midi ppdev snd_rawmidi snd_seq_midi_event snd_seq dell_laptop snd_timer snd_seq_device dcdbas snd psmouse pcmcia microcode serio_raw mac_hid i2c_piix4 yenta_socket soundcore pcmcia_rsrc shpchp pcmcia_core parport_pc lp parport video floppy usb_storage

[7.2] Processor information.
`cat /proc/cpuinfo'
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 3
microcode	: 0x8
cpu MHz		: 647.188
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36 mmx fxsr sse up
bogomips	: 1294.37
clflush size	: 32
cache_alignment	: 32
address sizes	: 36 bits physical, 32 bits virtual
power management:

[7.3] Module information.
`cat /proc/modules'
arc4 12509 2 - Live 0x00000000
rtl8192cu 67453 0 - Live 0x00000000
rtl8192c_common 47695 1 rtl8192cu, Live 0x00000000
rtlwifi 65237 1 rtl8192cu, Live 0x00000000
mac80211 480685 3 rtl8192cu,rtl8192c_common,rtlwifi, Live 0x00000000
cfg80211 185470 2 rtlwifi,mac80211, Live 0x00000000
nls_iso8859_1 12617 0 - Live 0x00000000
bnep 17850 2 - Live 0x00000000
rfcomm 38400 0 - Live 0x00000000
bluetooth 191687 8 bnep,rfcomm, Live 0x00000000
dm_crypt 22564 0 - Live 0x00000000
snd_maestro3 23086 2 - Live 0x00000000
snd_ac97_codec 106082 1 snd_maestro3, Live 0x00000000
xircom_cb 17393 0 - Live 0x00000000
ac97_bus 12670 1 snd_ac97_codec, Live 0x00000000
snd_pcm 81246 2 snd_maestro3,snd_ac97_codec, Live 0x00000000
joydev 17393 0 - Live 0x00000000
snd_page_alloc 14108 1 snd_pcm, Live 0x00000000
snd_seq_midi 13132 0 - Live 0x00000000
ppdev 12849 0 - Live 0x00000000
snd_rawmidi 25425 1 snd_seq_midi, Live 0x00000000
snd_seq_midi_event 14475 1 snd_seq_midi, Live 0x00000000
snd_seq 51568 2 snd_seq_midi,snd_seq_midi_event, Live 0x00000000
dell_laptop 17209 0 - Live 0x00000000
snd_timer 28931 2 snd_pcm,snd_seq, Live 0x00000000
snd_seq_device 14137 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x00000000
dcdbas 14098 1 dell_laptop, Live 0x00000000
snd 62520 11 snd_maestro3,snd_ac97_codec,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0x00000000
psmouse 77485 0 - Live 0x00000000
pcmcia 39819 0 - Live 0x00000000
microcode 18406 0 - Live 0x00000000
serio_raw 13031 0 - Live 0x00000000
mac_hid 13077 0 - Live 0x00000000
i2c_piix4 13264 0 - Live 0x00000000
yenta_socket 27464 0 - Live 0x00000000
soundcore 14635 1 snd, Live 0x00000000
pcmcia_rsrc 18367 1 yenta_socket, Live 0x00000000
shpchp 32325 0 - Live 0x00000000
pcmcia_core 21511 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0x00000000
parport_pc 32114 1 - Live 0x00000000
lp 17455 0 - Live 0x00000000
parport 40930 3 ppdev,parport_pc,lp, Live 0x00000000
video 18908 0 - Live 0x00000000
floppy 60213 0 - Live 0x00000000
usb_storage 39719 0 - Live 0x00000000


[7.4] Loaded driver and hardware information.
`cat /proc/ioports'
0000-001f : dma1
0020-0021 : pic1
0022-0022 : ACPI PM2_CNT_BLK
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:07.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:07.1
  01f0-01f7 : ata_piix
0376-0376 : 0000:00:07.1
  0376-0376 : ata_piix
0378-037a : parport0
03f0-03f1 : pnp 00:09
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:07.1
  03f6-03f6 : ata_piix
03f7-03f7 : floppy
03f8-03ff : serial
04d0-04d1 : pnp 00:02
0778-077a : parport0
0800-083f : 0000:00:07.3
  0800-0803 : ACPI PM1a_EVT_BLK
  0808-080b : ACPI PM_TMR
  080c-080f : ACPI GPE0_BLK
  0810-0815 : ACPI CPU throttle
0840-084f : 0000:00:07.3
  0840-084f : pnp 00:03
    0840-0847 : piix4_smbus
0850-0853 : pnp 00:03
0854-0855 : pnp 00:02
  0854-0855 : ACPI PM1a_CNT_BLK
0856-085f : pnp 00:03
0860-086f : 0000:00:07.1
  0860-086f : ata_piix
0a00-0a7f : pnp 00:03
0a80-0aff : pnp 00:03
0cf8-0cff : PCI conf1
1000-10ff : PCI CardBus 0000:02
  1000-107f : 0000:02:00.0
    1000-107f : xircom_cb
  1080-1087 : 0000:02:00.1
    1080-1087 : serial
1400-14ff : PCI CardBus 0000:02
1800-18ff : PCI CardBus 0000:06
1c00-1cff : PCI CardBus 0000:06
d800-d8ff : 0000:00:08.0
  d800-d8ff : Maestro3
dce0-dcff : 0000:00:07.2
  dce0-dcff : uhci_hcd
e000-efff : PCI Bus 0000:01
  ec00-ecff : 0000:01:00.0
f400-f4fe : pnp 00:04




`cat /proc/iomem'

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cffff : Video ROM
  000c0000-000cbfff : reserved
000f0000-000fffff : System ROM
00100000-0ffebfff : System RAM
  01000000-015e9860 : Kernel code
  015e9861-018d763f : Kernel data
  0199c000-01a74fff : Kernel bss
0ffec000-0ffeffff : reserved
0fff0000-0fffffff : RAM buffer
100a0000-100fffff : reserved
10100000-101fffff : PCI Bus 0000:01
  10100000-1011ffff : 0000:01:00.0
14000000-14000fff : 0000:00:03.0
  14000000-14000fff : yenta_socket
18000000-1bffffff : PCI CardBus 0000:02
  18000000-18003fff : 0000:02:00.0
  18004000-18007fff : 0000:02:00.1
1c000000-1fffffff : PCI CardBus 0000:02
  1c000000-1c0007ff : 0000:02:00.0
    1c000000-1c0007ff : xircom_cb
  1c000800-1c000fff : 0000:02:00.0
    1c000800-1c000fff : xircom_cb
  1c001000-1c0017ff : 0000:02:00.1
  1c001800-1c001fff : 0000:02:00.1
20000000-20000fff : 0000:00:03.1
  20000000-20000fff : yenta_socket
24000000-27ffffff : PCI CardBus 0000:06
28000000-2bffffff : PCI CardBus 0000:06
ed000000-edffffff : pnp 00:04
f4000000-f7ffffff : 0000:00:00.0
faffe000-faffffff : 0000:00:08.0
  faffe000-faffffff : Maestro3
fc000000-feffffff : PCI Bus 0000:01
  fcfff000-fcffffff : 0000:01:00.0
  fd000000-fdffffff : 0000:01:00.0
ffe00000-ffffffff : reserved
  ffe00000-ffffffff : pnp 00:00


[7.5] PCI information.
`sudo lspci -vvv'
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32
	Region 0: Memory at f4000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 1.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fc000000-feffffff
	Prefetchable memory behind bridge: 10100000-101fffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp

00:03.0 CardBus bridge: Texas Instruments PCI1225 (rev 01)
	Subsystem: Dell Device 00bb
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 14000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 18000000-1bfff000 (prefetchable)
	Memory window 1: 1c000000-1ffff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

00:03.1 CardBus bridge: Texas Instruments PCI1225 (rev 01)
	Subsystem: Dell Device 00bb
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 20000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
	Memory window 0: 24000000-27fff000 (prefetchable)
	Memory window 1: 28000000-2bfff000
	I/O window 0: 00001800-000018ff
	I/O window 1: 00001c00-00001cff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at 0860 [size=16]
	Kernel driver in use: ata_piix

00:07.2 USB controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at dce0 [size=32]
	Kernel driver in use: uhci_hcd

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin ? routed to IRQ 9
	Kernel driver in use: piix4_smbus
	Kernel modules: i2c-piix4

00:08.0 Multimedia audio controller: ESS Technology ES1983S Maestro-3i PCI Audio Accelerator (rev 10)
	Subsystem: Dell Device 00bb
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at faffe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_maestro3
	Kernel modules: snd-maestro3

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Rage Mobility P/M AGP 2x (rev 64) (prog-if 00 [VGA controller])
	Subsystem: Dell Latitude CPx
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: I/O ports at ec00 [size=256]
	Region 2: Memory at fcfff000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 10100000 [disabled] [size=128K]
	Capabilities: [50] AGP version 1.0
		Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [5c] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: atyfb

02:00.0 Ethernet controller: Xircom Cardbus Ethernet 10/100 (rev 03)
	Subsystem: Xircom Cardbus Ethernet 10/100
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5000ns min, 10000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 1000 [size=128]
	Region 1: Memory at 1c000000 (32-bit, non-prefetchable) [size=2K]
	Region 2: Memory at 1c000800 (32-bit, non-prefetchable) [size=2K]
	[virtual] Expansion ROM at 18000000 [disabled] [size=16K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: xircom_cb
	Kernel modules: xircom_cb

02:00.1 Serial controller: Xircom Cardbus Ethernet + 56k Modem (rev 03) (prog-if 02 [16550])
	Subsystem: Xircom CBEM56G-100 Ethernet + 56k Modem
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 1080 [size=8]
	Region 1: Memory at 1c001000 (32-bit, non-prefetchable) [size=2K]
	Region 2: Memory at 1c001800 (32-bit, non-prefetchable) [size=2K]
	[virtual] Expansion ROM at 18004000 [disabled] [size=16K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: serial


[7.6] SCSI information.
`cat /proc/scsi/scsi'
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: FUJITSU MHK2120A Rev: D834
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: SAMSUNG  Model: CD-ROM SN-124    Rev: S004
  Type:   CD-ROM                           ANSI  SCSI revision: 05


[7.7] '/proc' contents.
`ls /proc'
1     1161  19     370  8       buddyinfo    key-users      softirqs
10    1167  2      38   815     bus          kmsg           stat
1065  1170  20     39   816     cgroups      kpagecount     swaps
1092  1171  21     41   854     cmdline      kpageflags     sys
1095  1175  22     42   889     consoles     latency_stats  sysrq-trigger
1096  1178  23     5    893     cpuinfo      loadavg        sysvipc
11    1179  23554  504  894     crypto       locks          timer_list
1101  12    23567  517  9       devices      mdstat         timer_stats
1107  123   23589  526  907     diskstats    meminfo        tty
1110  1298  23593  606  928     dma          misc           uptime
1111  13    23601  61   936     driver       modules        version
1114  1355  237    62   941     execdomains  mounts         vmallocinfo
1116  14    238    63   942     fb           mtrr           vmstat
1118  1493  24     64   943     filesystems  net            zoneinfo
1123  1494  25     697  949     fs           pagetypeinfo
1132  1495  258    7    955     interrupts   partitions
1134  15    26     772  980     iomem        sched_debug
1138  16    27     777  984     ioports      schedstat
1140  17    3      791  990     irq          scsi
1143  1710  339    793  acpi    kallsyms     self
1144  1726  36     798  asound  kcore        slabinfo

