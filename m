Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39602 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab2HHSvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 14:51:41 -0400
Received: by bkwj10 with SMTP id j10so413749bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 11:51:39 -0700 (PDT)
Message-ID: <1344451889.3325.22.camel@buzz-dee-desktop> (sfid-20120808_205148_618186_0B58BC5E)
Subject: 168c:0023 ath9k wifi slow, and frequently disconnects/reconnects
From: Sebastian Schlatow <deezzub@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: 1032826@bugs.launchpad.net
Date: Wed, 08 Aug 2012 20:51:29 +0200
Content-Type: multipart/mixed; boundary="=-l+0egmynJP1OctBRRwI5"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l+0egmynJP1OctBRRwI5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

The connection to the wireless network often gets lost and then
reconnects. Furthermore the connection to the wireless network is often
very slow (1 Mb/s). Sometimes after I have reloaded the ath9k kernel
module, I can get a connection to the network and sometimes not.
Sometimes I have to reboot the pc, because I can't get a connection, but
often I can't get a connection after that.

wireless card:
TP-Link TL-WN951N (AR5416 / AR5008 / 168c:0023)

I tested the following mainline kernels.:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.4-precise/
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.4.1-quantal/
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.4.6-quantal/
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.5-quantal/
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6-rc1-quantal/

In those upstream kernel versions the bug is still present.

I had this problem also with Ubuntu Oneiric Ocelot 11.10 and with Ubuntu
Natty Narwhal 11.04, but with Natty the problem was not so bad because
it was very rare.


ProblemType: Bug
DistroRelease: Ubuntu 12.04
Package: linux-image-3.2.0-27-generic 3.2.0-27.43
ProcVersionSignature: Ubuntu 3.2.0-27.43-generic 3.2.21
Uname: Linux 3.2.0-27-generic x86_64
AlsaVersion: Advanced Linux Sound Architecture Driver Version 1.0.24.
ApportVersion: 2.0.1-0ubuntu11
Architecture: amd64
AudioDevicesInUse:
 USER PID ACCESS COMMAND
 /dev/snd/controlC1: buzz-dee 2462 F.... pulseaudio
 /dev/snd/controlC0: buzz-dee 2462 F.... pulseaudio
Card0.Amixer.info:
 Card hw:0 'VT82xx'/'HDA VIA VT82xx at 0xfbffc000 irq 17'
   Mixer name : 'Realtek ALC660-VD'
   Components : 'HDA:10ec0660,1043c603,00100001'
   Controls : 36
   Simple ctrls : 19
Card1.Amixer.info:
 Card hw:1 'SAA7134'/'saa7133[0] at 0xfbeef800 irq 18'
   Mixer name : 'SAA7134 Mixer'
   Components : ''
   Controls : 6
   Simple ctrls : 3
CurrentDmesg:
 [ 51.480531] vboxdrv: fAsync=1 offMin=0x3600c offMax=0x3600c
 [ 51.480654] vboxdrv: TSC mode is 'asynchronous', kernel timer mode is
'normal'.
 [ 51.480656] vboxdrv: Successfully loaded version 4.1.12_Ubuntu
(interface 0x00190000).
 [ 51.525894] vboxpci: IOMMU not found (not registered)
 [ 52.102129] init: plymouth-stop pre-start process (2156) terminated
with status 1
Date: Fri Aug 3 22:12:57 2012
HibernationDevice: RESUME=UUID=7a9c200e-f813-4561-9c36-0d50f5e42f84
InstallationMedia: Ubuntu 9.10 "Karmic Koala" - Release amd64 (20091027)
MachineType: System manufacturer M2V
ProcEnviron:
 TERM=xterm
 PATH=(custom, no user)
 LANG=de_DE.UTF-8
 SHELL=/bin/zsh
ProcFB: 0 nouveaufb
ProcKernelCmdLine: BOOT_IMAGE=/boot/vmlinuz-3.2.0-27-generic
root=UUID=837266ea-e282-4520-9b4d-8cf22d49c9cd ro quiet splash
vt.handoff=7
RelatedPackageVersions:
 linux-restricted-modules-3.2.0-27-generic N/A
 linux-backports-modules-3.2.0-27-generic N/A
 linux-firmware 1.79
SourcePackage: linux
UpgradeStatus: Upgraded to precise on 2012-06-10 (54 days ago)
dmi.bios.date: 02/21/2008
dmi.bios.vendor: American Megatrends Inc.
dmi.bios.version: 2101
dmi.board.asset.tag: To Be Filled By O.E.M.
dmi.board.name: M2V
dmi.board.vendor: ASUSTeK Computer INC.
dmi.board.version: Rev 1.xx
dmi.chassis.asset.tag: Asset-1234567890
dmi.chassis.type: 3
dmi.chassis.vendor: Chassis Manufacture
dmi.chassis.version: Chassis Version
dmi.modalias:
dmi:bvnAmericanMegatrendsInc.:bvr2101:bd02/21/2008:svnSystemmanufacturer:pnM2V:pvrSystemVersion:rvnASUSTeKComputerINC.:rnM2V:rvrRev1.xx:cvnChassisManufacture:ct3:cvrChassisVersion:
dmi.product.name: M2V
dmi.product.version: System Version
dmi.sys.vendor: System manufacturer


natty, oneiric, precise, kernel-wifi, modules, ath9k, amd64, networking,
kernel, wireless


~$ cat /proc/version 
Linux version 3.6.0-030600rc1-generic (apw@gomeisa) (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201208022056 SMP Fri Aug 3 00:57:36
UTC 2012


~$ lsb_release -rd 
Description:	Ubuntu 12.04 LTS
Release:	12.04


/usr/src/linux-headers-3.6.0-030600rc1/scripts$ sh ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux buzz-dee-desktop 3.6.0-030600rc1-generic #201208022056 SMP Fri Aug
3 00:57:36 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
reiserfsprogs          3.6.21
pcmciautils            018
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         rfcomm bnep binfmt_misc dm_crypt
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event ppdev arc4 snd_seq snd_timer
snd_seq_device btusb hid_generic ath9k bluetooth snd kvm_amd kvm
mac80211 ath9k_common ath9k_hw amd64_edac_mod soundcore dm_multipath
edac_core snd_page_alloc scsi_dh ath edac_mce_amd cfg80211 psmouse
serio_raw asus_atk0110 i2c_viapro max6650 parport_pc mac_hid hwmon_vid
shpchp k8temp lp parport dm_mirror dm_region_hash dm_log usbhid hid
nouveau pata_marvell ttm drm_kms_helper drm i2c_algo_bit mxm_wmi video
wmi atl1 floppy usb_storage


~$ cat /proc/cpuinfo 
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping	: 2
microcode	: 0x62
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp
lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy
svm extapic cr8_legacy
bogomips	: 1999.81
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping	: 2
microcode	: 0x62
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp
lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy
svm extapic cr8_legacy
bogomips	: 1999.81
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


~$ cat /proc/modules 
rfcomm 47922 0 - Live 0x0000000000000000
bnep 18315 2 - Live 0x0000000000000000
binfmt_misc 17540 1 - Live 0x0000000000000000
dm_crypt 23120 0 - Live 0x0000000000000000
snd_hda_codec_realtek 79668 1 - Live 0x0000000000000000
snd_hda_intel 34147 3 - Live 0x0000000000000000
snd_hda_codec 135376 2 snd_hda_codec_realtek,snd_hda_intel, Live
0x0000000000000000
snd_hwdep 13668 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 97661 2 snd_hda_intel,snd_hda_codec, Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_rawmidi 30749 1 snd_seq_midi, Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
ppdev 17113 0 - Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
snd_seq 61897 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_timer 29989 2 snd_pcm,snd_seq, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
0x0000000000000000
btusb 18291 0 - Live 0x0000000000000000
hid_generic 12493 0 - Live 0x0000000000000000
ath9k 147330 0 - Live 0x0000000000000000
bluetooth 218450 14 rfcomm,bnep,btusb, Live 0x0000000000000000
snd 79391 15
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0x0000000000000000
kvm_amd 56135 0 - Live 0x0000000000000000
kvm 437453 1 kvm_amd, Live 0x0000000000000000
mac80211 564667 1 ath9k, Live 0x0000000000000000
ath9k_common 14053 1 ath9k, Live 0x0000000000000000
ath9k_hw 399588 2 ath9k,ath9k_common, Live 0x0000000000000000
amd64_edac_mod 24584 0 - Live 0x0000000000000000
soundcore 15091 1 snd, Live 0x0000000000000000
dm_multipath 23260 0 - Live 0x0000000000000000
edac_core 62764 2 amd64_edac_mod, Live 0x0000000000000000
snd_page_alloc 18572 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
scsi_dh 14791 1 dm_multipath, Live 0x0000000000000000
ath 24123 3 ath9k,ath9k_common,ath9k_hw, Live 0x0000000000000000
edac_mce_amd 23547 1 amd64_edac_mod, Live 0x0000000000000000
cfg80211 212876 3 ath9k,mac80211,ath, Live 0x0000000000000000
psmouse 92362 0 - Live 0x0000000000000000
serio_raw 13215 0 - Live 0x0000000000000000
asus_atk0110 18078 0 - Live 0x0000000000000000
i2c_viapro 13153 0 - Live 0x0000000000000000
max6650 14328 0 - Live 0x0000000000000000
parport_pc 32866 1 - Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
hwmon_vid 12827 0 - Live 0x0000000000000000
shpchp 37277 0 - Live 0x0000000000000000
k8temp 13064 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 46562 3 ppdev,parport_pc,lp, Live 0x0000000000000000
dm_mirror 22203 0 - Live 0x0000000000000000
dm_region_hash 20918 1 dm_mirror, Live 0x0000000000000000
dm_log 18527 2 dm_mirror,dm_region_hash, Live 0x0000000000000000
usbhid 47307 0 - Live 0x0000000000000000
hid 100579 2 hid_generic,usbhid, Live 0x0000000000000000
nouveau 923628 3 - Live 0x0000000000000000
pata_marvell 12923 0 - Live 0x0000000000000000
ttm 88492 1 nouveau, Live 0x0000000000000000
drm_kms_helper 46931 1 nouveau, Live 0x0000000000000000
drm 277108 5 nouveau,ttm,drm_kms_helper, Live 0x0000000000000000
i2c_algo_bit 13564 1 nouveau, Live 0x0000000000000000
mxm_wmi 12979 1 nouveau, Live 0x0000000000000000
video 19412 1 nouveau, Live 0x0000000000000000
wmi 19256 2 nouveau,mxm_wmi, Live 0x0000000000000000
atl1 45310 0 - Live 0x0000000000000000
floppy 70244 0 - Live 0x0000000000000000
usb_storage 49287 0 - Live 0x0000000000000000


~$ cat /proc/ioports 
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:0f.1
    0170-0177 : pata_acpi
  01f0-01f7 : 0000:00:0f.1
    01f0-01f7 : pata_acpi
  0376-0376 : 0000:00:0f.1
    0376-0376 : pata_acpi
  0378-037a : parport0
  037b-037f : parport0
  03e0-03e7 : pnp 00:08
  03f2-03f2 : floppy
  03f4-03f5 : floppy
  03f6-03f6 : 0000:00:0f.1
    03f6-03f6 : pata_acpi
  03f7-03f7 : floppy
  03f8-03ff : serial
  0400-041f : pnp 00:08
    0400-0407 : vt596_smbus
  04d0-04d1 : pnp 00:08
  0800-087f : pnp 00:08
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0823 : ACPI GPE0_BLK
  0a20-0a2f : pnp 00:06
  0a30-0a3f : pnp 00:06
  0c00-0c0f : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  0d00-0d0f : pnp 00:06
  1000-1fff : PCI Bus 0000:05
  2000-2fff : PCI Bus 0000:04
  3000-3fff : PCI Bus 0000:03
  b480-b49f : 0000:00:10.0
    b480-b49f : uhci_hcd
  b800-b81f : 0000:00:10.1
    b800-b81f : uhci_hcd
  b880-b89f : 0000:00:10.2
    b880-b89f : uhci_hcd
  bc00-bc1f : 0000:00:10.3
    bc00-bc1f : uhci_hcd
  c000-c0ff : 0000:00:0f.0
  c400-c40f : 0000:00:0f.0
    c400-c40f : pata_acpi
  c480-c483 : 0000:00:0f.0
    c480-c483 : pata_acpi
  c800-c807 : 0000:00:0f.0
    c800-c807 : pata_acpi
  c880-c883 : 0000:00:0f.0
    c880-c883 : pata_acpi
  cc00-cc07 : 0000:00:0f.0
    cc00-cc07 : pata_acpi
  d000-dfff : PCI Bus 0000:02
    dc00-dc7f : 0000:02:00.0
  e000-efff : PCI Bus 0000:06
    e400-e40f : 0000:06:00.0
      e400-e40f : pata_marvell
    e480-e483 : 0000:06:00.0
      e480-e483 : pata_marvell
    e800-e807 : 0000:06:00.0
      e800-e807 : pata_marvell
    e880-e883 : 0000:06:00.0
      e880-e883 : pata_marvell
    ec00-ec07 : 0000:06:00.0
      ec00-ec07 : pata_marvell
  fc00-fc0f : 0000:00:0f.1
    fc00-fc0f : pata_acpi


~$ cat /proc/iomem 
00000000-0000ffff : reserved
00010000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ce1ff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cffaffff : System RAM
  01000000-016a876a : Kernel code
  016a876b-01cdfe7f : Kernel data
  01dd5000-01f2ffff : Kernel bss
cffb0000-cffbdfff : ACPI Tables
cffbe000-cffdffff : ACPI Non-volatile Storage
cffe0000-cfffffff : reserved
d0000000-ff37ffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:02
    d0000000-dfffffff : 0000:02:00.0
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : pnp 00:0f
  f0000000-f01fffff : PCI Bus 0000:06
  f0200000-f05fffff : PCI Bus 0000:05
  f0600000-f07fffff : PCI Bus 0000:04
  f0800000-f0bfffff : PCI Bus 0000:03
  f6e00000-f6efffff : PCI Bus 0000:03
  f6f00000-f6ffffff : PCI Bus 0000:05
  f7fffc00-f7fffcff : 0000:00:10.4
    f7fffc00-f7fffcff : ehci_hcd
  f8000000-fbbfffff : PCI Bus 0000:02
    f8000000-f9ffffff : 0000:02:00.0
    fa000000-faffffff : 0000:02:00.0
    fbbe0000-fbbfffff : 0000:02:00.0
  fbc00000-fbcfffff : PCI Bus 0000:04
    fbca0000-fbcbffff : 0000:04:00.0
    fbcc0000-fbcfffff : 0000:04:00.0
      fbcc0000-fbcfffff : atl1
  fbd00000-fbdfffff : PCI Bus 0000:06
    fbdffc00-fbdfffff : 0000:06:00.0
  fbe00000-fbefffff : PCI Bus 0000:07
    fbeef800-fbeeffff : 0000:07:08.0
    fbef0000-fbefffff : 0000:07:07.0
      fbef0000-fbefffff : ath9k
  fbf00000-fbffffff : PCI Bus 0000:80
    fbffc000-fbffffff : 0000:80:01.0
      fbffc000-fbffffff : ICH HD audio
  fec00000-fec00fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fecc0000-fecc0fff : reserved
    fecc0000-fecc03ff : IOAPIC 1
  fed00000-fed003ff : HPET 0
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0b
ff780000-ffffffff : reserved
100000000-1afffffff : System RAM


~$ cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3500418AS      Rev: CC34
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD6400AAKS-2 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CD/DVDW TS-H552U Rev: US08
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 01 Lun: 00
  Vendor: Optiarc  Model: DVD RW AD-7173A  Rev: 1-01
  Type:   CD-ROM                           ANSI  SCSI revision: 05


~$ ls /proc/
1      1319   1723  2445  2678	2996  405	 cmdline	mounts
10     13253  1755  2449  2679	2999  406	 consoles	mtrr
100    13265  1758  2451  2692	3     407	 cpuinfo	net
1006   13266  1772  2460  2694	30    43	 crypto		pagetypeinfo
10566  1328   1784  2468  27	3002  4676	 devices	partitions
1057   13280  1799  2474  2708	3006  5		 diskstats	sched_debug
1106   1330   18    2484  2711	3007  574	 dma		schedstat
1107   1338   1806  2487  2712	3008  6585	 dri		scsi
1170   1345   1823  2489  2715	3009  7		 driver		self
11749  1347   19    2491  2716	3011  700	 execdomains	slabinfo
1176   1363   1947  2492  2761	31    703	 fb		softirqs
12     1381   1948  2493  2775	3115  8		 filesystems	stat
120    1384   1963  2494  2780	3116  8277	 fs		swaps
121    1388   2     2495  28	3154  8320	 interrupts	sys
122    1397   20    2497  2809	3160  85	 iomem		sysrq-trigger
1229   14     21    2499  2812	3177  86	 ioports	sysvipc
12514  1405   2174  25	  2820	3178  89	 irq		timer_list
12553  15     2175  2501  2826	318   9		 kallsyms	timer_stats
1258   1551   22    2510  2832	3187  90	 kcore		tty
126    16     2280  2519  2844	319   906	 key-users	uptime
1289   1620   23    2521  2845	3191  917	 kmsg		version
12926  1625   2300  2523  2852	32    947	 kpagecount	vmallocinfo
12927  1644   2331  2526  2860	3231  95	 kpageflags	vmstat
13     1650   2345  2528  2867	3248  971	 latency_stats	zoneinfo
13003  1659   2379  2533  2874	33    972	 loadavg
13026  1686   2390  2597  2875	3325  acpi	 locks
13042  1688   24    2628  2883	337   asound	 mdstat
13043  1691   2440  2630  29	34    buddyinfo  meminfo
1307   17     2441  2638  2931	3955  bus	 misc
1318   1704   2444  2672  2975	4035  cgroups	 modules

--=-l+0egmynJP1OctBRRwI5
Content-Disposition: attachment; filename="lspci.txt"
Content-Type: text/plain; name="lspci.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge: VIA Technologies, Inc. K8T890CF Host Bridge
	Subsystem: VIA Technologies, Inc. K8T890CF Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=3 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [58] #00 [0000]

00:00.1 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:00.2 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:00.3 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:00.4 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:00.5 PIC: VIA Technologies, Inc. VT3351 I/O APIC Interrupt Controller (prog-if 20 [IO(X)-APIC])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:00.6 Host bridge: VIA Technologies, Inc. Device 6238
	Subsystem: Device 0008:0000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:00.7 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes

00:01.0 PCI bridge: VIA Technologies, Inc. [K8T890 North / VT8237 South] PCI Bridge (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:02.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: f8000000-fbbfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 0d, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=1 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	0000000000000000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:03.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
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
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=1 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	0000000000000000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:03.1 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: f0200000-f05fffff
	Prefetchable memory behind bridge: 00000000f6f00000-00000000f6ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000001  Pending: 00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
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
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=1 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=03 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	0000000000000000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:03.2 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000f0600000-00000000f07fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 0d, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:03.3 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f0800000-f0bfffff
	Prefetchable memory behind bridge: 00000000f6e00000-00000000f6efffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
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
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	0000000000000000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: VIA Technologies, Inc. VT8237A SATA 2-Port Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin B routed to IRQ 21
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at c880 [size=4]
	Region 2: I/O ports at c800 [size=8]
	Region 3: I/O ports at c480 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Region 5: I/O ports at c000 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_acpi
	Kernel modules: sata_via

00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07) (prog-if 8a [Master SecP PriP])
	Subsystem: VIA Technologies, Inc. VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at fc00 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_acpi
	Kernel modules: pata_via

00:10.0 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at b480 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.1 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at b800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.2 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at b880 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.3 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 23
	Region 4: I/O ports at bc00 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.4 USB controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if 20 [EHCI])
	Subsystem: VIA Technologies, Inc. USB 2.0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 21
	Region 0: Memory at f7fffc00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
	Subsystem: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: i2c-viapro

00:11.7 Host bridge: VIA Technologies, Inc. VT8237/8251 Ultra VLINK Controller
	Subsystem: VIA Technologies, Inc. Device 337e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128
	Capabilities: [58] HyperTransport: Interrupt Discovery and Configuration

00:13.0 PCI bridge: VIA Technologies, Inc. VT8237A Host Bridge (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=80, subordinate=80, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fbf00000-fbffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed+
	Capabilities: [70] Subsystem: VIA Technologies, Inc. VT8237A Host Bridge
	Kernel modules: shpchp

00:13.1 PCI bridge: VIA Technologies, Inc. VT8237A PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed+
	Capabilities: [70] Subsystem: VIA Technologies, Inc. VT8237A PCI to PCI Bridge

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: amd64_edac
	Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp

02:00.0 VGA compatible controller: NVIDIA Corporation G98 [GeForce 8400 GS] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Device 1acc:851f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 24
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at dc00 [size=128]
	Expansion ROM at fbbe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb

04:00.0 Ethernet controller: Atheros Communications Inc. Attansic L1 Gigabit Ethernet (rev b0)
	Subsystem: ASUSTeK Computer Inc. P5KPL-VM Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 36
	Region 0: Memory at fbcc0000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at fbca0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [6c] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: atl1
	Kernel modules: atl1

06:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b1) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: ASUSTeK Computer Inc. Device 8212
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at ec00 [size=8]
	Region 1: I/O ports at e880 [size=4]
	Region 2: I/O ports at e800 [size=8]
	Region 3: I/O ports at e480 [size=4]
	Region 4: I/O ports at e400 [size=16]
	Region 5: Memory at fbdffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME+
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
	Kernel driver in use: pata_marvell
	Kernel modules: pata_marvell

07:07.0 Network controller: Atheros Communications Inc. AR5416 Wireless Network Adapter [AR5008 802.11(a)bgn] (rev 01)
	Subsystem: Atheros Communications Inc. Device 3071
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbef0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] #80 [0000]
	Kernel driver in use: ath9k
	Kernel modules: ath9k

07:08.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
	Subsystem: Hauppauge computer works Inc. WinTV HVR-1110
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (21000ns min, 8000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fbeef800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-

80:01.0 Audio device: VIA Technologies, Inc. VT8237A/VT8251 HDA Controller (rev 10)
	Subsystem: ASUSTeK Computer Inc. Device 81e7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend+
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel


--=-l+0egmynJP1OctBRRwI5--

