Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.earth.li ([194.106.34.144]:38340 "EHLO
	matrix.matrix.chaos.earth.li" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbZGJOzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 10:55:07 -0400
Date: Fri, 10 Jul 2009 15:32:53 +0100
From: Ian Lynagh <igloo@earth.li>
To: dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: PROBLEM: USB wlan device stops working; ehci "kernel BUG"
Message-ID: <20090710143253.GA4133@matrix.chaos.earth.li>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi all,

[1.] PROBLEM: USB wlan device stops working; ehci "kernel BUG"

[2.]

I am having a problem with an rt73usb and/or ehci. I /think/ the bug is
in ehci, and the rt73usb problems are just a symptom, but I'm not sure.

The actual problem is that after a while (generally a few days, I think)
my USB wireless device stops working. I've attached the dmesg log at the
point that I noticed it stopped working today; unfortunately, I don't
know exactly when it broke. My guess is it was at this line, though:

[582576.209231] ehci_hcd 0000:00:12.2: force halt; handhake ffffc20000636024 00004000 00000000 -> -110

Then there are lots of lines saying things like:

[582715.780075] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x30c4 with error -108.
[582716.780031] hub 2-1:1.0: hub_port_status failed (err = -108)

I haven't found a way to fix this problem short of rebooting. If I
"rmmod ehci_hcd" then I get a "kernel BUG" error, in the second
attachment and reproduced below.

All the info below, with the exception of the attachments and the
"kernel BUG", was taken when everything was working.

[3.] wlan USB ehci

[4.] I'm using 2.6.30 (but it's happened on earlier kernels too) from Debian's linux-image-2.6.30-1-amd64 2.6.30-1

[4.1.] Linux version 2.6.30-1-amd64 (Debian 2.6.30-1) (waldi@debian.org) (gcc version 4.3.3 (Debian 4.3.3-10) ) #1 SMP Sun Jun 14 15:00:29 UTC 2009

[5.] N/A

[6.]

[582730.178207] ------------[ cut here ]------------
[582730.178212] kernel BUG at /build/buildd/linux-2.6-2.6.30/debian/build/source_amd64_none/drivers/usb/host/ehci-mem.c:74!
[582730.178215] invalid opcode: 0000 [#1] SMP
[582730.178218] last sysfs file: /sys/devices/pci0000:00/0000:00:12.2/usb2/2-1/2-1:1.0/bInterfaceProtocol
[582730.178220] CPU 3
[582730.178222] Modules linked in: tcp_diag inet_diag nls_utf8 nls_cp437 vfat fat binfmt_misc isofs nls_base loop dm_snapshot dm_mirror dm_region_hash dm_log dm_mod it87 hwmon_vid eeprom psmouse ide_generic ide_gd_mod arc4 ecb rt73usb rt2x00usb rt2x00lib led_class input_polldev mac80211 snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm cfg80211 snd_page_alloc snd_usb_lib snd_hwdep snd_seq_midi pcspkr snd_rawmidi snd_seq_midi_event evdev i2c_piix4 i2c_core snd_seq snd_timer snd_seq_device snd wmi soundcore button processor shpchp pci_hotplug ext3 jbd mbcache ide_cd_mod cdrom ide_pci_generic usb_storage usbhid hid sd_mod crc_t10dif atiixp ide_core ata_generic ahci firewire_ohci firewire_core crc_itu_t floppy libata r8169 mii ehci_hcd(-) scsi_mod ohci_hcd thermal fan thermal_sys
[582730.178267] Pid: 11270, comm: rmmod Not tainted 2.6.30-1-amd64 #1 Unknow
[582730.178269] RIP: 0010:[<ffffffffa004e836>]  [<ffffffffa004e836>] qh_put+0x30/0x67 [ehci_hcd]
[582730.178278] RSP: 0018:ffff88002ca19d98  EFLAGS: 00010286
[582730.178281] RAX: ffff880037802058 RBX: ffff880037802000 RCX: ffff88012d146558
[582730.178283] RDX: 00000000ffffffff RSI: ffff88012c41b2d0 RDI: ffff880037802000
[582730.178285] RBP: ffff88012d146578 R08: 0000000000000004 R09: 0000000000000f7b
[582730.178287] R10: ffff88012fab32b0 R11: 00000000000003c0 R12: ffff88012d146594
[582730.178290] R13: 00007ffffb8fa2d0 R14: 0000000000000000 R15: 0000000000000000
[582730.178292] FS:  00007ff81ceeb6e0(0000) GS:ffff880028070000(0000) knlGS:00000000f7e1b6c0
[582730.178295] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[582730.178297] CR2: 00007fb4e6213000 CR3: 00000000051f8000 CR4: 00000000000006e0
[582730.178299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[582730.178301] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[582730.178304] Process rmmod (pid: 11270, threadinfo ffff88002ca18000, task ffff8800ad912ee0)
[582730.178306] Stack:
[582730.178307]  ffff88012d146578 ffff88012d146578 ffff88012d146578 ffffffffa0052b69
[582730.178310]  ffff88012c41b820 ffff88012d146594 ffff88012d146578 ffff88012d146594
[582730.178314]  00007ffffb8fa2d0 0000000000000000 0000000000000000 ffffffffa0052d53
[582730.178318] Call Trace:
[582730.178320]  [<ffffffffa0052b69>] ? ehci_mem_cleanup+0x24/0x12a [ehci_hcd]
[582730.178327]  [<ffffffffa0052d53>] ? ehci_stop+0xe4/0xf3 [ehci_hcd]
[582730.178333]  [<ffffffff803ddfb2>] ? usb_remove_hcd+0xb6/0xf9
[582730.178344]  [<ffffffff803e94b6>] ? usb_hcd_pci_remove+0x1d/0x7f
[582730.178348]  [<ffffffff803601ac>] ? pci_device_remove+0x24/0x47
[582730.178353]  [<ffffffff803d1e54>] ? __device_release_driver+0x77/0x9e
[582730.178357]  [<ffffffff803d1eef>] ? driver_detach+0x74/0x9a
[582730.178360]  [<ffffffff803d12fe>] ? bus_remove_driver+0x7d/0xad
[582730.178365]  [<ffffffff80360433>] ? pci_unregister_driver+0x38/0x89
[582730.178371]  [<ffffffffa0053994>] ? ehci_hcd_cleanup+0x10/0x1a [ehci_hcd]
[582730.178377]  [<ffffffff80264be7>] ? sys_delete_module+0x1bf/0x22a
[582730.178382]  [<ffffffff8035019f>] ? __up_write+0x12/0x45
[582730.178386]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[582730.178391] Code: 48 83 ec 08 8b 87 80 00 00 00 ff c8 85 c0 89 87 80 00 00 00 75 48 48 8d 47 58 48 39 47 58 48 8b 6f 78 75 07 48 83 7f 50 00 74 04 <0f> 0b eb fe 48 8b 77 68 48 85 f6 74 10 48 8b 56 38 48 8b bd 20
[582730.178425] RIP  [<ffffffffa004e836>] qh_put+0x30/0x67 [ehci_hcd]
[582730.178431]  RSP <ffff88002ca19d98>
[582730.178433] ---[ end trace 15b415fb85c0dfb1 ]---

[7.] N/A

[8.]

[8.1.]

ver_linux output:
--------------------------------------
Linux matrix 2.6.30-1-amd64 #1 SMP Sun Jun 14 15:00:29 UTC 2009 x86_64 GNU/Linux
 
Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      found
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         tcp_diag inet_diag binfmt_misc isofs nls_base loop dm_snapshot dm_mirror dm_region_hash dm_log dm_mod it87 hwmon_vid eeprom psmouse ide_generic ide_gd_mod arc4 ecb snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_usb_lib snd_hwdep snd_seq_midi snd_rawmidi snd_seq_midi_event rt73usb rt2x00usb rt2x00lib led_class snd_seq input_polldev mac80211 snd_timer snd_seq_device pcspkr snd soundcore cfg80211 i2c_piix4 evdev i2c_core wmi button processor shpchp pci_hotplug ext3 jbd mbcache usbhid hid ide_cd_mod cdrom ide_pci_generic sd_mod crc_t10dif atiixp ide_core ahci ata_generic firewire_ohci firewire_core crc_itu_t r8169 mii floppy libata ohci_hcd ehci_hcd scsi_mod thermal fan thermal_sys
--------------------------------------

[8.2.]

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: AMD Phenom(tm) 9650 Quad-Core Processor
stepping	: 3
cpu MHz		: 2304.679
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
bogomips	: 4609.35
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: AMD Phenom(tm) 9650 Quad-Core Processor
stepping	: 3
cpu MHz		: 2304.679
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
bogomips	: 4609.93
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 2
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: AMD Phenom(tm) 9650 Quad-Core Processor
stepping	: 3
cpu MHz		: 2304.679
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
bogomips	: 4609.76
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 3
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: AMD Phenom(tm) 9650 Quad-Core Processor
stepping	: 3
cpu MHz		: 2304.679
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
bogomips	: 4609.80
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

[8.3.]

tcp_diag 1728 0 - Live 0xffffffffa005d000
inet_diag 9664 5 tcp_diag, Live 0xffffffffa008d000
binfmt_misc 9244 1 - Live 0xffffffffa0371000
isofs 31096 2 - Live 0xffffffffa0364000
nls_base 8740 1 isofs, Live 0xffffffffa035f000
loop 15948 4 - Live 0xffffffffa0356000
dm_snapshot 22524 0 - Live 0xffffffffa034b000
dm_mirror 14504 0 - Live 0xffffffffa0342000
dm_region_hash 12688 1 dm_mirror, Live 0xffffffffa033c000
dm_log 9924 2 dm_mirror,dm_region_hash, Live 0xffffffffa0334000
dm_mod 59096 3 dm_snapshot,dm_mirror,dm_log, Live 0xffffffffa0320000
it87 23624 0 - Live 0xffffffffa0315000
hwmon_vid 3088 1 it87, Live 0xffffffffa0312000
eeprom 6336 0 - Live 0xffffffffa030b000
psmouse 42140 0 - Live 0xffffffffa02fb000
ide_generic 2452 0 [permanent], Live 0xffffffffa02f5000
ide_gd_mod 23384 0 - Live 0xffffffffa02ea000
arc4 2048 2 - Live 0xffffffffa02e4000
ecb 3072 2 - Live 0xffffffffa02de000
snd_usb_audio 90288 0 - Live 0xffffffffa02c2000
snd_pcm_oss 37200 0 - Live 0xffffffffa02b3000
snd_mixer_oss 15072 1 snd_pcm_oss, Live 0xffffffffa02aa000
snd_pcm 78440 2 snd_usb_audio,snd_pcm_oss, Live 0xffffffffa0291000
snd_page_alloc 9936 1 snd_pcm, Live 0xffffffffa0289000
snd_usb_lib 16560 1 snd_usb_audio, Live 0xffffffffa0282000
snd_hwdep 8120 1 snd_usb_audio, Live 0xffffffffa027b000
snd_seq_midi 6976 0 - Live 0xffffffffa0274000
snd_rawmidi 22992 2 snd_usb_lib,snd_seq_midi, Live 0xffffffffa0269000
snd_seq_midi_event 7696 1 snd_seq_midi, Live 0xffffffffa0262000
rt73usb 26452 0 - Live 0xffffffffa0256000
rt2x00usb 12352 1 rt73usb, Live 0xffffffffa0250000
rt2x00lib 30320 2 rt73usb,rt2x00usb, Live 0xffffffffa0246000
led_class 5048 1 rt2x00lib, Live 0xffffffffa023f000
snd_seq 51248 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa022d000
input_polldev 4544 1 rt2x00lib, Live 0xffffffffa0229000
mac80211 160272 2 rt2x00usb,rt2x00lib, Live 0xffffffffa01fc000
snd_timer 21824 2 snd_pcm,snd_seq, Live 0xffffffffa01f1000
snd_seq_device 7476 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa01ea000
pcspkr 2800 0 - Live 0xffffffffa01e4000
snd 63848 9 snd_usb_audio,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_hwdep,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xffffffffa01cf000
soundcore 7984 1 snd, Live 0xffffffffa01c8000
cfg80211 65032 2 rt2x00lib,mac80211, Live 0xffffffffa01b6000
i2c_piix4 11040 0 - Live 0xffffffffa01ae000
evdev 10448 3 - Live 0xffffffffa01a6000
i2c_core 25424 2 eeprom,i2c_piix4, Live 0xffffffffa019a000
wmi 7488 0 - Live 0xffffffffa0193000
button 6512 0 - Live 0xffffffffa018c000
processor 40080 0 - Live 0xffffffffa017d000
shpchp 32588 0 - Live 0xffffffffa0170000
pci_hotplug 29040 1 shpchp, Live 0xffffffffa0163000
ext3 122560 5 - Live 0xffffffffa0143000
jbd 47976 1 ext3, Live 0xffffffffa0135000
mbcache 8804 1 ext3, Live 0xffffffffa0130000
usbhid 37216 0 - Live 0xffffffffa0124000
hid 41296 1 usbhid, Live 0xffffffffa0117000
ide_cd_mod 29000 1 - Live 0xffffffffa010d000
cdrom 34360 1 ide_cd_mod, Live 0xffffffffa0102000
ide_pci_generic 4964 0 - Live 0xffffffffa00b8000
sd_mod 33656 9 - Live 0xffffffffa00f7000
crc_t10dif 2096 1 sd_mod, Live 0xffffffffa0007000
atiixp 4292 1 - Live 0xffffffffa0017000
ide_core 104864 5 ide_generic,ide_gd_mod,ide_cd_mod,ide_pci_generic,atiixp, Live 0xffffffffa00db000
ahci 36448 7 - Live 0xffffffffa00cd000
ata_generic 5924 0 - Live 0xffffffffa00c6000
firewire_ohci 22372 0 - Live 0xffffffffa00bb000
firewire_core 44852 1 firewire_ohci, Live 0xffffffffa00ab000
crc_itu_t 2720 2 rt73usb,firewire_core, Live 0xffffffffa0043000
r8169 32500 0 - Live 0xffffffffa00a1000
mii 5600 1 r8169, Live 0xffffffffa000e000
floppy 55384 0 - Live 0xffffffffa0091000
libata 174892 2 ahci,ata_generic, Live 0xffffffffa0060000
ohci_hcd 22700 0 - Live 0xffffffffa0055000
ehci_hcd 33580 0 - Live 0xffffffffa0047000
scsi_mod 158352 2 sd_mod,libata, Live 0xffffffffa001a000
thermal 15952 0 - Live 0xffffffffa0011000
fan 5224 0 - Live 0xffffffffa000a000
thermal_sys 16496 3 processor,thermal,fan, Live 0xffffffffa0000000

[8.4.]

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:14.1
  0170-0177 : atiixp
01f0-01f7 : 0000:00:14.1
  01f0-01f7 : atiixp
0220-0225 : pnp 00:01
0228-022f : pnp 00:02
  022d-022e : it87
    022d-022e : it87
0238-023f : pnp 00:02
0290-0294 : pnp 00:01
0376-0376 : 0000:00:14.1
  0376-0376 : atiixp
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:14.1
  03f6-03f6 : atiixp
03f7-03f7 : floppy
040b-040b : pnp 00:02
04d0-04d1 : pnp 00:01
04d6-04d6 : pnp 00:02
0b00-0b0f : pnp 00:02
  0b00-0b07 : piix4_smbus
0b10-0b1f : pnp 00:02
0b20-0b3f : pnp 00:02
0c00-0c01 : pnp 00:02
0c14-0c14 : pnp 00:02
0c50-0c52 : pnp 00:02
0c6c-0c6d : pnp 00:02
0c6f-0c6f : pnp 00:02
0cd0-0cd1 : pnp 00:02
0cd2-0cd3 : pnp 00:02
0cd4-0cdf : pnp 00:02
0cf8-0cff : PCI conf1
4000-40fe : pnp 00:02
  4000-4003 : ACPI PM1a_EVT_BLK
  4004-4005 : ACPI PM1a_CNT_BLK
  4008-400b : ACPI PM_TMR
  4010-4015 : ACPI CPU throttle
  4020-4027 : ACPI GPE0_BLK
  4050-4050 : ACPI PM2_CNT_BLK
4100-411f : pnp 00:02
4210-4217 : pnp 00:02
c000-cfff : PCI Bus 0000:03
d000-dfff : PCI Bus 0000:02
  de00-deff : 0000:02:00.0
    de00-deff : r8169
e000-efff : PCI Bus 0000:01
  ee00-eeff : 0000:01:05.0
fa00-fa0f : 0000:00:14.1
  fa00-fa0f : atiixp
fb00-fb0f : 0000:00:11.0
  fb00-fb0f : ahci
fc00-fc03 : 0000:00:11.0
  fc00-fc03 : ahci
fd00-fd07 : 0000:00:11.0
  fd00-fd07 : ahci
fe00-fe03 : 0000:00:11.0
  fe00-fe03 : ahci
ff00-ff07 : 0000:00:11.0
  ff00-ff07 : ahci


00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000f0000-000fffff : reserved
00100000-bfedffff : System RAM
  00200000-004b7891 : Kernel code
  004b7892-0061523f : Kernel data
  006d7000-007d98cb : Kernel bss
  20000000-23ffffff : GART
bfee0000-bfee2fff : ACPI Non-volatile Storage
bfee3000-bfeeffff : ACPI Tables
bfef0000-bfefffff : reserved
bfff0000-cffeffff : pnp 00:0b
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:0a
fda00000-fdafffff : PCI Bus 0000:02
  fda00000-fda0ffff : 0000:02:00.0
  fdae0000-fdaeffff : 0000:02:00.0
    fdae0000-fdaeffff : r8169
  fdaff000-fdafffff : 0000:02:00.0
    fdaff000-fdafffff : r8169
fdb00000-fdbfffff : PCI Bus 0000:03
fdc00000-fdcfffff : PCI Bus 0000:03
  fdcf8000-fdcfbfff : 0000:03:0e.0
  fdcff000-fdcff7ff : 0000:03:0e.0
    fdcff000-fdcff7ff : firewire_ohci
fdd00000-fddfffff : PCI Bus 0000:02
fde00000-fdffffff : PCI Bus 0000:01
  fde00000-fdefffff : 0000:01:05.0
  fdfe0000-fdfeffff : 0000:01:05.0
  fdffc000-fdffffff : 0000:01:05.1
fe024000-fe027fff : 0000:00:14.2
fe028000-fe028fff : 0000:00:14.5
  fe028000-fe028fff : ohci_hcd
fe029000-fe0290ff : 0000:00:13.2
  fe029000-fe0290ff : ehci_hcd
fe02a000-fe02afff : 0000:00:13.1
  fe02a000-fe02afff : ohci_hcd
fe02b000-fe02bfff : 0000:00:13.0
  fe02b000-fe02bfff : ohci_hcd
fe02c000-fe02c0ff : 0000:00:12.2
  fe02c000-fe02c0ff : ehci_hcd
fe02d000-fe02dfff : 0000:00:12.1
  fe02d000-fe02dfff : ohci_hcd
fe02e000-fe02efff : 0000:00:12.0
  fe02e000-fe02efff : ohci_hcd
fe02f000-fe02f3ff : 0000:00:11.0
  fe02f000-fe02f3ff : ahci
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
    fec00000-fec00fff : pnp 00:0b
  fed00000-fed003ff : HPET 0
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0b
  fff80000-fffeffff : pnp 00:0b
  ffff0000-ffffffff : pnp 00:0b
100000000-12fffffff : System RAM

[8.5.]

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
	Subsystem: Advanced Micro Devices [AMD] RS780 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32
	Region 3: Memory at <ignored> (64-bit, non-prefetchable)

00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 99
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fde00000-fdffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)
	Kernel modules: shpchp

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: 00000000fda00000-00000000fdafffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  a, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4159
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 9600
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode] (prog-if 01 [AHCI 1.0])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 27
	Region 0: I/O ports at ff00 [size=8]
	Region 1: I/O ports at fe00 [size=4]
	Region 2: I/O ports at fd00 [size=8]
	Region 3: I/O ports at fc00 [size=4]
	Region 4: I/O ports at fb00 [size=16]
	Region 5: Memory at fe02f000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable+
		Address: 00000000fee0f00c  Data: 4189
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at fe029000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
	Subsystem: Giga-byte Technology Device 4385
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR+ <PERR+ INTx-
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: piix4_smbus
	Kernel modules: i2c-piix4

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at fa00 [size=16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=0/1 Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ATIIXP_IDE
	Kernel modules: ide-pci-generic, atiixp, ata_generic

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
	Subsystem: Giga-byte Technology Device a022
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fe024000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
	Subsystem: ATI Technologies Inc SB700/SB800 LPC host controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fdc00000-fdcfffff
	Prefetchable memory behind bridge: fdb00000-fdbfffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fe028000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [a]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Graphics (prog-if 00 [VGA controller])
	Subsystem: Giga-byte Technology Device d000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at ee00 [size=256]
	Region 2: Memory at fdfe0000 (32-bit, non-prefetchable) [size=64K]
	Region 5: Memory at fde00000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
	Subsystem: ATI Technologies Inc RS780 Azalia controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin B routed to IRQ 7
	Region 0: Memory at fdffc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel modules: snd-hda-intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 26
	Region 0: I/O ports at de00 [size=256]
	Region 2: Memory at fdaff000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at fdae0000 (64-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at fda00000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0f00c  Data: 4171
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 78-56-34-12-78-56-34-12
	Kernel driver in use: r8169
	Kernel modules: r8169

03:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 1000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fdcff000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at fdcf8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci


[8.6.] N/A

[8.7.] See attached

[X.] N/A


Thanks
Ian


--h31gzZEtNLTqOjlF
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="rt2x00usb.dmesg.log.gz"
Content-Transfer-Encoding: base64

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

--h31gzZEtNLTqOjlF
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="rt2x00usb.dmesg.rmmod-ehci_hcd.log.gz"
Content-Transfer-Encoding: base64

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

--h31gzZEtNLTqOjlF--
