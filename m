Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54249 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2GEVeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 17:34:46 -0400
Received: by yhmm54 with SMTP id m54so8741532yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 14:34:45 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 22:34:45 +0100
Message-ID: <CAJrANNJutyjAUPeQsLK4M30oe0PqArHJUVeJKUUJ6GExSEv6Eg@mail.gmail.com> (sfid-20120705_233452_812976_EEB692AC)
Subject: PROBLEM: RTL8192CU / TRENDnet TEW-648UBM V1.1 USB Wireless
From: David Moore <spasysheep@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- TRENDware/TRENDnet TEW-648UBM V1.1 USB Wireless doesn't work properly
- Driver (RTL8192CU) loads, device appears to work, but will not pick
up most networks and will not connect to any. Fails with bad
passphrase if connected through Wicd or DHCPCD times out waiting for
carrier carrier if connected manually (WPA2-PSK)
- Linux version 3.4.4-2-ARCH (tobias@T-POWA-LX) (gcc version 4.7.1
(GCC) ) #1 SMP PREEMPT Sun Jun 24 18:59:47 CEST 2012
- Recreated by trying to connect to wireless networks with TEW-648UBM V1.1
- http://www.wikidevi.com/wiki/TRENDnet_TEW-648UBM
- http://ubuntuforums.org/showthread.php?t=1667682


ver_linux:
Linux Buttstop 3.4.4-2-ARCH #1 SMP PREEMPT Sun Jun 24 18:59:47 CEST
2012 x86_64 GNU/Linux

Gnu C                  4.7.1
Gnu make               3.82
binutils               2.22.0.20120323
util-linux             2.21.2
mount                  debug
module-init-tools      9
e2fsprogs              1.42.4
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      6.0.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.17
wireless-tools         29
Modules Loaded         nvidia snd_hda_codec_conexant snd_hda_intel
arc4 snd_hda_codec snd_hwdep joydev rtl8192cu snd_pcm snd_page_alloc
snd_timer rtlwifi rtl8192c_common snd mac80211 hp_wmi edac_mce_amd
serio_raw sparse_keymap cfg80211 edac_core i2c_nforce2 powernow_k8
i2c_core soundcore forcedeth nv_tco rfkill mperf psmouse evdev pcspkr
processor k8temp wmi button thermal battery ac video ext4 crc16 jbd2
mbcache sr_mod cdrom sd_mod pata_acpi ohci_hcd pata_amd sata_nv
ata_generic ehci_hcd libata usbcore scsi_mod usb_common


/proc/cpuinfo:
processor : 0
vendor_id : AuthenticAMD
cpu family : 15
model : 72
model name : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping : 2
microcode : 0x62
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 2
core id : 0
cpu cores : 2
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 1
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm
cmp_legacy svm extapic cr8_legacy
bogomips : 1607.32
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor : 1
vendor_id : AuthenticAMD
cpu family : 15
model : 72
model name : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping : 2
microcode : 0x62
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 2
core id : 1
cpu cores : 2
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 1
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm
cmp_legacy svm extapic cr8_legacy
bogomips : 1607.32
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


/proc/modules:
nvidia 10832296 53 - Live 0xffffffffa039d000 (PO)
snd_hda_codec_conexant 46154 1 - Live 0xffffffffa01c9000
snd_hda_intel 24053 1 - Live 0xffffffffa0391000
arc4 1410 2 - Live 0xffffffffa01c7000
snd_hda_codec 94273 2 snd_hda_codec_conexant,snd_hda_intel, Live
0xffffffffa0368000
snd_hwdep 6300 1 snd_hda_codec, Live 0xffffffffa0362000
joydev 9991 0 - Live 0xffffffffa035c000
rtl8192cu 63635 0 - Live 0xffffffffa0346000
snd_pcm 74958 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0329000
snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01e9000
snd_timer 18966 1 snd_pcm, Live 0xffffffffa031f000
rtlwifi 61929 1 rtl8192cu, Live 0xffffffffa0308000
rtl8192c_common 36351 1 rtl8192cu, Live 0xffffffffa02fe000
snd 58997 8 snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa02e5000
mac80211 395680 3 rtl8192cu,rtlwifi,rtl8192c_common, Live 0xffffffffa0267000
hp_wmi 7866 0 - Live 0xffffffffa01c1000
edac_mce_amd 12469 0 - Live 0xffffffffa01b1000
serio_raw 4653 0 - Live 0xffffffffa013d000
sparse_keymap 3056 1 hp_wmi, Live 0xffffffffa00ca000
cfg80211 170074 2 rtlwifi,mac80211, Live 0xffffffffa023c000
edac_core 36656 0 - Live 0xffffffffa00b0000
i2c_nforce2 5064 0 - Live 0xffffffffa0056000
powernow_k8 13360 1 - Live 0xffffffffa002d000
i2c_core 20369 2 nvidia,i2c_nforce2, Live 0xffffffffa005c000
soundcore 5410 1 snd, Live 0xffffffffa003f000
forcedeth 56065 0 - Live 0xffffffffa0228000
nv_tco 4864 0 - Live 0xffffffffa0223000
rfkill 15604 2 hp_wmi,cfg80211, Live 0xffffffffa021a000
mperf 1267 1 powernow_k8, Live 0xffffffffa0212000
psmouse 70792 0 - Live 0xffffffffa01f8000
evdev 9754 7 - Live 0xffffffffa01f1000
pcspkr 1899 0 - Live 0xffffffffa01ed000
processor 26567 1 powernow_k8, Live 0xffffffffa01b9000
k8temp 3403 0 - Live 0xffffffffa0120000
wmi 8475 1 hp_wmi, Live 0xffffffffa0119000
button 4502 0 - Live 0xffffffffa00da000
thermal 7959 0 - Live 0xffffffffa00d4000
battery 6517 0 - Live 0xffffffffa00cf000
ac 2376 0 - Live 0xffffffffa006c000
video 11307 0 - Live 0xffffffffa00c2000
ext4 424175 3 - Live 0xffffffffa0148000
crc16 1359 1 ext4, Live 0xffffffffa0068000
jbd2 73919 1 ext4, Live 0xffffffffa0094000
mbcache 5977 1 ext4, Live 0xffffffffa0059000
sr_mod 14823 0 - Live 0xffffffffa0051000
cdrom 35648 1 sr_mod, Live 0xffffffffa0043000
sd_mod 29239 5 - Live 0xffffffffa0036000
pata_acpi 3408 0 - Live 0xffffffffa0002000
ohci_hcd 21720 0 - Live 0xffffffffa0026000
pata_amd 11427 0 - Live 0xffffffffa0141000
sata_nv 21220 4 - Live 0xffffffffa0136000
ata_generic 3295 0 - Live 0xffffffffa0132000
ehci_hcd 41026 0 - Live 0xffffffffa0122000
libata 167611 4 pata_acpi,pata_amd,sata_nv,ata_generic, Live 0xffffffffa00e3000
usbcore 147565 5 rtl8192cu,rtlwifi,ohci_hcd,ehci_hcd, Live 0xffffffffa006e000
scsi_mod 132942 3 sr_mod,sd_mod,libata, Live 0xffffffffa0004000
usb_common 954 1 usbcore, Live 0xffffffffa0000000


/proc/ioports:
0000-ffff : PCI Bus #00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:0d.0
    0170-0177 : pata_amd
  01f0-01f7 : 0000:00:0d.0
    01f0-01f7 : pata_amd
  0360-0361 : pnp 00:05
  0376-0376 : 0000:00:0d.0
    0376-0376 : pata_amd
  0380-0383 : pnp 00:05
  03c0-03df : vga+
  03f6-03f6 : 0000:00:0d.0
    03f6-03f6 : pata_amd
  04d0-04d1 : pnp 00:05
  0cf8-0cff : PCI conf1
  1000-107f : pnp 00:04
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1027 : ACPI GPE0_BLK
  1080-10ff : pnp 00:04
  1400-147f : pnp 00:04
    1440-144f : NV TCO
  1480-14ff : pnp 00:04
    1484-1484 : ACPI PM2_CNT_BLK
  1800-187f : pnp 00:04
  1880-18ff : pnp 00:04
  1d00-1d7f : 0000:00:0a.0
  2000-203f : pnp 00:04
  3000-303f : 0000:00:0a.1
    3000-303f : nForce2_smbus
  3040-307f : 0000:00:0a.1
    3040-307f : nForce2_smbus
  3080-308f : 0000:00:0d.0
    3080-308f : pata_amd
  3090-309f : 0000:00:0e.0
    3090-309f : sata_nv
  30b0-30b3 : 0000:00:0e.0
    30b0-30b3 : sata_nv
  30b4-30b7 : 0000:00:0e.0
    30b4-30b7 : sata_nv
  30b8-30bf : 0000:00:0e.0
    30b8-30bf : sata_nv
  30c0-30c7 : 0000:00:0e.0
    30c0-30c7 : sata_nv
  30e0-30e7 : 0000:00:14.0
    30e0-30e7 : forcedeth
  4000-4fff : PCI Bus 0000:01
  5000-5fff : PCI Bus 0000:03


/proc/iomem:
0000-ffff : PCI Bus #00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:0d.0
    0170-0177 : pata_amd
  01f0-01f7 : 0000:00:0d.0
    01f0-01f7 : pata_amd
  0360-0361 : pnp 00:05
  0376-0376 : 0000:00:0d.0
    0376-0376 : pata_amd
  0380-0383 : pnp 00:05
  03c0-03df : vga+
  03f6-03f6 : 0000:00:0d.0
    03f6-03f6 : pata_amd
  04d0-04d1 : pnp 00:05
  0cf8-0cff : PCI conf1
  1000-107f : pnp 00:04
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1027 : ACPI GPE0_BLK
  1080-10ff : pnp 00:04
  1400-147f : pnp 00:04
    1440-144f : NV TCO
  1480-14ff : pnp 00:04
    1484-1484 : ACPI PM2_CNT_BLK
  1800-187f : pnp 00:04
  1880-18ff : pnp 00:04
  1d00-1d7f : 0000:00:0a.0
  2000-203f : pnp 00:04
  3000-303f : 0000:00:0a.1
    3000-303f : nForce2_smbus
  3040-307f : 0000:00:0a.1
    3040-307f : nForce2_smbus
  3080-308f : 0000:00:0d.0
    3080-308f : pata_amd
  3090-309f : 0000:00:0e.0
    3090-309f : sata_nv
  30b0-30b3 : 0000:00:0e.0
    30b0-30b3 : sata_nv
  30b4-30b7 : 0000:00:0e.0
    30b4-30b7 : sata_nv
  30b8-30bf : 0000:00:0e.0
    30b8-30bf : sata_nv
  30c0-30c7 : 0000:00:0e.0
    30c0-30c7 : sata_nv
  30e0-30e7 : 0000:00:14.0
    30e0-30e7 : forcedeth
  4000-4fff : PCI Bus 0000:01
  5000-5fff : PCI Bus 0000:03
david@Buttstop:~/Downloads$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000c0000-000cf1ff : Video ROM
000cf800-000d0fff : Adapter ROM
000d2000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-a7efffff : System RAM
  01000000-0146e802 : Kernel code
  0146e803-018a38bf : Kernel data
  01963000-01aa3fff : Kernel bss
  9c000000-9fffffff : GART
a7f00000-a7f14fff : ACPI Tables
a7f15000-a7f7ffff : ACPI Non-volatile Storage
a7f80000-afffffff : reserved
b0000000-ffffffff : PCI Bus #00
  b0000000-b0003fff : 0000:00:10.1
    b0000000-b0003fff : ICH HD audio
  b0004000-b0004fff : 0000:00:0b.0
    b0004000-b0004fff : ohci_hcd
  b0005000-b00050ff : 0000:00:0b.1
    b0005000-b00050ff : ehci_hcd
  b0006000-b0006fff : 0000:00:0e.0
    b0006000-b0006fff : sata_nv
  b0008000-b0008fff : 0000:00:14.0
    b0008000-b0008fff : forcedeth
  b0020000-b003ffff : 0000:00:05.0
  b0040000-b007ffff : 0000:00:0a.3
  b1000000-b1ffffff : 0000:00:05.0
  b2000000-b2ffffff : 0000:00:05.0
    b2000000-b2ffffff : nvidia
  b4000000-b7ffffff : PCI Bus 0000:01
  b8000000-bbffffff : PCI Bus 0000:03
  c0000000-cfffffff : 0000:00:05.0
  d0000000-d01fffff : PCI Bus 0000:01
  d0200000-d03fffff : PCI Bus 0000:03
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:00
      e0000000-efffffff : pnp 00:03
        e0000000-e06fffff : PCI MMCONFIG 0000 [bus 00-06]
  fec00000-fec0ffff : reserved
    fec00000-fec003ff : IOAPIC 0
  fed00000-fed00fff : pnp 00:01
    fed00000-fed003ff : HPET 0
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : reserved
  fff80000-ffffffff : reserved
100000000-14fffffff : System RAM
150000000-fcffffffff : PCI Bus #00


lspci -vvv:
00:00.0 RAM memory: NVIDIA Corporation C51 Host Bridge (rev a2)
Subsystem: Hewlett-Packard Company Device 30b7
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [44] HyperTransport: Slave or Primary Interface
Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b-
Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Link Control 1: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b-
Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
Revision ID: 1.03
Link Frequency 0: 800MHz
Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
Link Frequency 1: 800MHz
Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 1: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
Prefetchable memory behind bridge Upper: 00-00
Bus Number: 00
Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
Mapping Address Base: 00000000fee00000

00:00.1 RAM memory: NVIDIA Corporation C51 Memory Controller 0 (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 RAM memory: NVIDIA Corporation C51 Memory Controller 1 (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.3 RAM memory: NVIDIA Corporation C51 Memory Controller 5 (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.4 RAM memory: NVIDIA Corporation C51 Memory Controller 4 (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:00.5 RAM memory: NVIDIA Corporation C51 Host Bridge (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [44] #00 [00fe]
Capabilities: [fc] #00 [0000]

00:00.6 RAM memory: NVIDIA Corporation C51 Memory Controller 3 (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.7 RAM memory: NVIDIA Corporation C51 Memory Controller 2 (rev a2)
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 PCI bridge: NVIDIA Corporation C51 PCI Express Bridge (rev a1)
(prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 00004000-00004fff
Memory behind bridge: b4000000-b7ffffff
Prefetchable memory behind bridge: 00000000d0000000-00000000d01fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: NVIDIA Corporation Device 0000
Capabilities: [48] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
Address: 00000000fee0300c  Data: 4149
Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
Mapping Address Base: 00000000fee00000
Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
ExtTag- RBE- FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn+ PwrFlt+ MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Off, PwrInd On, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=WRR32
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: pcieport

00:03.0 PCI bridge: NVIDIA Corporation C51 PCI Express Bridge (rev a1)
(prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 00005000-00005fff
Memory behind bridge: b8000000-bbffffff
Prefetchable memory behind bridge: 00000000d0200000-00000000d03fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: NVIDIA Corporation Device 0000
Capabilities: [48] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
Address: 00000000fee0300c  Data: 4151
Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
Mapping Address Base: 00000000fee00000
Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
ExtTag- RBE- FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn+ PwrFlt+ MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Off, PwrInd On, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=WRR32
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: pcieport

00:05.0 VGA compatible controller: NVIDIA Corporation C51 [GeForce Go
6100] (rev a2) (prog-if 00 [VGA controller])
Subsystem: Hewlett-Packard Company Device 30b7
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 18
Region 0: Memory at b2000000 (32-bit, non-prefetchable) [size=16M]
Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
Region 3: Memory at b1000000 (64-bit, non-prefetchable) [size=16M]
[virtual] Expansion ROM at b0020000 [disabled] [size=128K]
Capabilities: [48] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Kernel driver in use: nvidia

00:09.0 RAM memory: NVIDIA Corporation MCP51 Host Bridge (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [44] HyperTransport: Slave or Primary Interface
Command: BaseUnitID=9 UnitCnt=15 MastHost- DefDir- DUL-
Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b-
Link Config 0: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-
Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-
Revision ID: 1.03
Link Frequency 0: 800MHz
Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
Link Frequency 1: 200MHz
Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
Prefetchable memory behind bridge Upper: 00-00
Bus Number: 00
Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
Mapping Address Base: 00000000fee00000

00:0a.0 ISA bridge: NVIDIA Corporation MCP51 LPC Bridge (rev a3)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Region 0: I/O ports at 1d00 [size=128]

00:0a.1 SMBus: NVIDIA Corporation MCP51 SMBus (rev a3)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 10
Region 4: I/O ports at 3040 [size=64]
Region 5: I/O ports at 3000 [size=64]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: nForce2_smbus

00:0a.3 Co-processor: NVIDIA Corporation MCP51 PMU (rev a3)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (750ns min, 250ns max)
Interrupt: pin B routed to IRQ 10
Region 0: Memory at b0040000 (32-bit, non-prefetchable) [size=256K]

00:0b.0 USB controller: NVIDIA Corporation MCP51 USB Controller (rev
a3) (prog-if 10 [OHCI])
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (750ns min, 250ns max)
Interrupt: pin A routed to IRQ 23
Region 0: Memory at b0004000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ohci_hcd

00:0b.1 USB controller: NVIDIA Corporation MCP51 USB Controller (rev
a3) (prog-if 20 [EHCI])
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (750ns min, 250ns max)
Interrupt: pin B routed to IRQ 22
Region 0: Memory at b0005000 (32-bit, non-prefetchable) [size=256]
Capabilities: [44] Debug port: BAR=1 offset=0098
Capabilities: [80] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ehci_hcd

00:0d.0 IDE interface: NVIDIA Corporation MCP51 IDE (rev f1) (prog-if
8a [Master SecP PriP])
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (750ns min, 250ns max)
Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
Region 4: I/O ports at 3080 [size=16]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pata_amd

00:0e.0 IDE interface: NVIDIA Corporation MCP51 Serial ATA Controller
(rev f1) (prog-if 85 [Master SecO PriO])
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (750ns min, 250ns max)
Interrupt: pin A routed to IRQ 21
Region 0: I/O ports at 30c0 [size=8]
Region 1: I/O ports at 30b4 [size=4]
Region 2: I/O ports at 30b8 [size=8]
Region 3: I/O ports at 30b0 [size=4]
Region 4: I/O ports at 3090 [size=16]
Region 5: Memory at b0006000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
Kernel driver in use: sata_nv

00:10.0 PCI bridge: NVIDIA Corporation MCP51 PCI Bridge (rev a2)
(prog-if 01 [Subtractive decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
Capabilities: [b8] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
Mapping Address Base: 00000000fee00000

00:10.1 Audio device: NVIDIA Corporation MCP51 High Definition Audio (rev a2)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (500ns min, 1250ns max)
Interrupt: pin B routed to IRQ 19
Region 0: Memory at b0000000 (32-bit, non-prefetchable) [size=16K]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
Address: 0000000000000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
Kernel driver in use: snd_hda_intel

00:14.0 Bridge: NVIDIA Corporation MCP51 Ethernet Controller (rev a3)
Subsystem: Hewlett-Packard Company Presario V6133CL
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0 (250ns min, 5000ns max)
Interrupt: pin A routed to IRQ 20
Region 0: Memory at b0008000 (32-bit, non-prefetchable) [size=4K]
Region 1: I/O ports at 30e0 [size=8]
Capabilities: [44] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
Kernel driver in use: forcedeth

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [80] HyperTransport: Host or Secondary Interface
Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=8
IsocEn- LSEn+ ExtCTL- 64b+
Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Revision ID: 1.02
Link Frequency: 800MHz
Link Error: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [f0] Secure device <?>
Kernel driver in use: k8temp


/proc/scsi/scsi:
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200BEVT-2 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: Optiarc  Model: DVD RW AD-7560A  Rev: DH10
  Type:   CD-ROM                           ANSI  SCSI revision: 05
