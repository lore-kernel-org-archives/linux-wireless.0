Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from danu.mythicnet.org ([69.36.14.47]:47247 "EHLO
	danu.mythicnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1AJDGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 22:06:49 -0500
Received: from localhost (localhost [127.0.0.1])
	by danu.mythicnet.org (Postfix) with SMTP id CB2D778327
	for <linux-wireless@vger.kernel.org>; Sun,  9 Jan 2011 21:57:23 -0500 (EST)
Received: from [10.1.42.78] (cpe-184-57-88-200.columbus.res.rr.com [184.57.88.200])
	by danu.mythicnet.org (Postfix) with ESMTPSA id 7DEEC782E9
	for <linux-wireless@vger.kernel.org>; Sun,  9 Jan 2011 21:57:13 -0500 (EST)
Message-ID: <4D2A7585.6080708@mythicnet.org>
Date: Sun, 09 Jan 2011 21:57:09 -0500
From: Ilya Kogan <ikogan@mythicnet.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: brcm80211 problem with BCM43225
Content-Type: multipart/mixed;
 boundary="------------020904000209070006050309"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020904000209070006050309
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

Firstly, sorry about the huge e-mail but I figured more information=20
would help. I purchased an Acer Aspire 1551=20
(http://support.acer.com/acerpanam/notebook/2010/Acer/Aspire/Aspire1551/A=
spire1551sp2.shtml)=20
that contains a Broadcom BCM43225 and have been having a world of issues=20
trying to get it to work. I'm trying to do this with Ubuntu 10.10 64-bit=20
which includes Kernel 2.6.35-24. Thus far I have tried the following=20
drivers with various failure modes:

1. Broadcom STA, their closed-source driver. This was from Ubuntu's=20
"Additional Drivers" tool.
2. =93Broadcom 802.11n Wireless LAN Driver=94, which I assume was brcm802=
11=20
but can't quite recall, also from "Additional Drivers".
3. brcm80211 from=20
=93linux-backports-modules-compat-wireless-2.6.36-2.6.35-24-generic=94.
4. brcm80211 from http://ubuntuforums.org/showthread.php?t=3D1617380. Thi=
s=20
involves getting a copy of linux-next, hacking up the Makefile so that=20
it can build the driver without the the rest of the kernel, and manually=20
copying brcm80211.ko and the firmware into the right place.
5. brcm80211 from the latest compat-wireless tarball.
6. brcm80211 from the latest compat-wireless git.

The Broadcom STA driver detected the card as BCM4357 and every command I=20
tried with iwconfig gave me =93Invalid Argument=94. The rest of the drive=
rs=20
detected the card correctly, but some strange things happened. First,=20
here's the relevant entries from the kernel log during module init:

[ 572.439045] Compat-wireless backport release: compat-wireless-2011-01-0=
6
[ 572.439052] Backport based on linux-next.git next-20110107
[ 572.465233] cfg80211: Calling CRDA to update world regulatory domain
[ 572.478124] cfg80211: World regulatory domain updated:
[ 572.478129] cfg80211: (start_freq - end_freq @ bandwidth),=20
(max_antenna_gain, max_eirp)
[ 572.478135] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (300=20
mBi, 2000 mBm)
[ 572.478139] cfg80211: (2457000 KHz - 2482000 KHz @ 20000 KHz), (300=20
mBi, 2000 mBm)
[ 572.478143] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz), (300=20
mBi, 2000 mBm)
[ 572.478147] cfg80211: (5170000 KHz - 5250000 KHz @ 40000 KHz), (300=20
mBi, 2000 mBm)
[ 572.478151] cfg80211: (5735000 KHz - 5835000 KHz @ 40000 KHz), (300=20
mBi, 2000 mBm)
[ 572.501499] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low)=20
-> IRQ 17
[ 572.501511] brcm80211 0000:06:00.0: setting latency timer to 64
[ 572.508965] Found chip type AI (0x13a1a8d9)
[ 572.519912] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021=20
macaddr: c4:46:19:6c:a9:c0
[ 572.520270] cfg80211: Updating information on frequency 2412 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520275] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520279] cfg80211: Updating information on frequency 2417 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520283] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520286] cfg80211: Updating information on frequency 2422 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520290] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520294] cfg80211: Updating information on frequency 2427 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520300] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520306] cfg80211: Updating information on frequency 2432 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520312] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520318] cfg80211: Updating information on frequency 2437 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520325] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520331] cfg80211: Updating information on frequency 2442 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520337] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520343] cfg80211: Updating information on frequency 2447 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520350] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520356] cfg80211: Updating information on frequency 2452 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520363] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520369] cfg80211: Updating information on frequency 2457 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520376] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520382] cfg80211: Updating information on frequency 2462 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520388] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520395] cfg80211: Updating information on frequency 2467 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520402] cfg80211: 2457000 KHz - 2482000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520407] cfg80211: Updating information on frequency 2472 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520414] cfg80211: 2457000 KHz - 2482000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520420] cfg80211: Updating information on frequency 2484 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.520427] cfg80211: 2474000 KHz - 2494000 KHz @ KHz), (300 mBi, 2000=20
mBm)
[ 572.520785] ieee80211 phy0: Selected rate control algorithm 'minstrel_h=
t'
[ 572.524533] wl_set_hint: Sending country code US to MAC80211
[ 572.524542] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0)=20
(Compiled at 15:18:31 on Jan 9 2011)
[ 572.524566] cfg80211: Calling CRDA for country: US
[ 572.530110] cfg80211: Updating information on frequency 2412 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530117] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530122] cfg80211: Updating information on frequency 2417 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530126] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530130] cfg80211: Updating information on frequency 2422 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530134] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530137] cfg80211: Updating information on frequency 2427 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530141] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530144] cfg80211: Updating information on frequency 2432 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530148] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530152] cfg80211: Updating information on frequency 2437 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530156] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530159] cfg80211: Updating information on frequency 2442 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530163] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530166] cfg80211: Updating information on frequency 2447 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530170] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530174] cfg80211: Updating information on frequency 2452 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530177] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530181] cfg80211: Updating information on frequency 2457 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530185] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530188] cfg80211: Updating information on frequency 2462 MHz for a=20
20 MHz width channel with regulatory rule:
[ 572.530192] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (300 mBi, 2700=20
mBm)
[ 572.530195] cfg80211: Disabling freq 2467 MHz
[ 572.530198] cfg80211: Disabling freq 2472 MHz
[ 572.530200] cfg80211: Disabling freq 2484 MHz
[ 572.530204] cfg80211: Regulatory domain changed to country: US
[ 572.530207] cfg80211: (start_freq - end_freq @ bandwidth),=20
(max_antenna_gain, max_eirp)
[ 572.530211] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (300=20
mBi, 2700 mBm)
[ 572.530215] cfg80211: (5170000 KHz - 5250000 KHz @ 40000 KHz), (300=20
mBi, 1700 mBm)
[ 572.530219] cfg80211: (5250000 KHz - 5330000 KHz @ 40000 KHz), (300=20
mBi, 2000 mBm)
[ 572.530223] cfg80211: (5490000 KHz - 5600000 KHz @ 40000 KHz), (300=20
mBi, 2000 mBm)
[ 572.530226] cfg80211: (5650000 KHz - 5710000 KHz @ 40000 KHz), (300=20
mBi, 2000 mBm)
[ 572.530230] cfg80211: (5735000 KHz - 5835000 KHz @ 40000 KHz), (300=20
mBi, 3000 mBm)

The first brcm80211 that I tried was the one from (4). This one actually=20
lit up the LED claiming that wireless was on and managed to show me a=20
list of wireless networks through iwlist scan. NetworkManager, however,=20
continue to claim that wireless was disabled. Figuring this was an NM=20
problem, I rebooted. As soon as the kernel finished booting, the=20
wireless LED turned off and has not turned back on since. At one point,=20
I forced the interface to be up via =93ifconfig wlan0 up=94 and then did=20
=93iwlist wlan0 scan=94 with hilarious results. Sometimes the system woul=
d=20
explode with white and black bars, sometimes I would get a white screen,=20
and sometimes I would get scan results that were totally wonky (see=20
scan.log). One of those versions would log the following when Itried to=20
toggle the wireless switch:

Jan 8 22:48:44 Lulzer kernel: [ 259.727970] wl0: MAC Detected a change=20
on the RF Disable Input 0x10000
Jan 8 22:48:44 Lulzer kernel: [ 260.327466] wl0: MAC Detected a change=20
on the RF Disable Input 0x0
Jan 8 22:48:53 Lulzer kernel: [ 268.753399] wl0: MAC Detected a change=20
on the RF Disable Input 0x10000

Below are the relevant details as command output, also, a hwinfo dump=20
and kernel log are attached. =93iw event -t=94 yields no output during=20
insertion or removal of the module. I'm willing to be a guinea pig to=20
help debug this and possibly hack on it a bit myself once I figure out=20
how these things work. Also, please let me know if I'm not actually=20
running with the recommend debug options, I modified config.mk to set=20
the ones mentioned on the website.

Thanks very much,
Ilya Kogan

ikogan@Lulzer:~$ lspci
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge=20
Alternate
00:01.0 PCI bridge: Acer Incorporated [ALI] Device 9602
00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge=20
(PCIE port 0)
00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge=20
(PCIE port 1)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA=20
Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0=20
Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI=20
Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0=20
Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI=20
Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 41)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller=20
(rev 40)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev=20
40)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller=20
(rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:16.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0=20
Controller
00:16.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI=20
Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor=20
HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor=20
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor=20
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor=20
Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor=20
Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility=20
Radeon HD 4200]
01:05.1 Audio device: ATI Technologies Inc RS880 Audio Device [Radeon HD=20
4200]
03:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit=20
Ethernet (rev c0)
06:00.0 Network controller: Broadcom Corporation BCM43225 802.11b/g/n=20
(rev 01)

ikogan@Lulzer:~$ cat /proc/cpuinfo
processor : 0
vendor_id : AuthenticAMD
cpu family : 16
model : 6
model name : AMD Athlon(tm) II Neo K325 Dual-Core Processor
stepping : 3
cpu MHz : 800.000
cache size : 1024 KB
physical id : 0
siblings : 2
core id : 0
cpu cores : 2
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov=20
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt=20
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc=20
extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic=20
cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt=20
lbrv svm_lock nrip_save
bogomips : 2593.60
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 1
vendor_id : AuthenticAMD
cpu family : 16
model : 6
model name : AMD Athlon(tm) II Neo K325 Dual-Core Processor
stepping : 3
cpu MHz : 800.000
cache size : 1024 KB
physical id : 0
siblings : 2
core id : 1
cpu cores : 2
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov=20
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt=20
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc=20
extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic=20
cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt=20
lbrv svm_lock nrip_save
bogomips : 2593.49
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

ikogan@Lulzer:~$ uname -a
Linux Lulzer 2.6.35-24-generic #42-Ubuntu SMP Thu Dec 2 02:41:37 UTC=20
2010 x86_64 GNU/Linux

ikogan@Lulzer:~$ lsmod
Module Size Used by
binfmt_misc 7984 1
vboxnetadp 5395 0
vboxnetflt 19131 0
vboxdrv 1818472 2 vboxnetadp,vboxnetflt
parport_pc 30086 0
ppdev 6804 0
snd_hda_codec_atihdmi 3079 1
snd_hda_codec_realtek 299844 1
arc4 1497 2
snd_hda_intel 26019 2
snd_hda_codec 100919 3=20
snd_hda_codec_atihdmi,snd_hda_codec_realtek,snd_hda_intel
brcm80211 732072 0
snd_hwdep 6660 1 snd_hda_codec
snd_pcm 89104 2 snd_hda_intel,snd_hda_codec
uvcvideo 62379 0
videodev 49359 1 uvcvideo
snd_seq_midi 5932 0
v4l1_compat 15519 2 uvcvideo,videodev
mac80211 289506 1 brcm80211
v4l2_compat_ioctl32 12614 1 videodev
snd_rawmidi 22207 1 snd_seq_midi
snd_seq_midi_event 7291 1 snd_seq_midi
fglrx 2523725 32
snd_seq 57512 2 snd_seq_midi,snd_seq_midi_event
cfg80211 173372 2 brcm80211,mac80211
snd_timer 23850 2 snd_pcm,snd_seq
acer_wmi 15969 0
snd_seq_device 6912 3 snd_seq_midi,snd_rawmidi,snd_seq
compat 7653 2 mac80211,cfg80211
snd 64181 13=20
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_r=
awmidi,snd_seq,snd_timer,snd_seq_device=20

led_class 3393 2 acer_wmi,compat
psmouse 62080 0
serio_raw 4910 0
soundcore 1240 1 snd
video 22176 0
edac_core 46822 0
snd_page_alloc 8588 2 snd_hda_intel,snd_pcm
output 2527 1 video
i2c_piix4 10047 0
edac_mce_amd 9387 0
k10temp 3535 0
shpchp 34910 0
lp 10201 0
parport 37032 3 parport_pc,ppdev,lp
usb_storage 50372 0
ahci 22210 2
libahci 26052 1 ahci
pata_atiixp 4405 0
atl1c 34955 0

ikogan@Lulzer:~$ sudo iwconfig
lo no wireless extensions.

eth0 no wireless extensions.

vboxnet0 no wireless extensions.

wlan0 IEEE 802.11bgn ESSID:off/any
Mode:Managed Access Point: Not-Associated Tx-Power=3D0 dBm
Retry long limit:7 RTS thr:off Fragment thr:off
Encryption key:off
Power Management:off

ikogan@Lulzer:~$ sudo iwlist scan
lo Interface doesn't support scanning.

eth0 Interface doesn't support scanning.

vboxnet0 Interface doesn't support scanning.

wlan0 Interface doesn't support scanning : Network is down

ikogan@Lulzer:~$ sudo iw wlan0 info
Interface wlan0
ifindex 5
type managed

ikogan@Lulzer:/lib/firmware/brcm$ ls -la
total 376
drwxr-xr-x 2 root root 4096 2011-01-09 21:53 .
drwxr-xr-x 51 root root 4096 2011-01-08 23:57 ..
-rw-r--r-- 1 root root 269595 2011-01-09 21:53=20
bcm4329-fullmac-4-218-248-5.bin
-rw-r--r-- 1 root root 1604 2011-01-09 21:53 bcm4329-fullmac-4-218-248-5.=
txt
lrwxrwxrwx 1 root root 31 2011-01-09 21:53 bcm4329-fullmac-4.bin ->=20
bcm4329-fullmac-4-218-248-5.bin
lrwxrwxrwx 1 root root 31 2011-01-09 21:53 bcm4329-fullmac-4.txt ->=20
bcm4329-fullmac-4-218-248-5.txt
-rw-r--r-- 1 root root 97376 2011-01-08 11:58 bcm43xx-0-610-809-0.fw
lrwxrwxrwx 1 root root 22 2011-01-08 11:58 bcm43xx-0.fw ->=20
bcm43xx-0-610-809-0.fw
-rw-r--r-- 1 root root 180 2011-01-08 11:58 bcm43xx_hdr-0-610-809-0.fw
lrwxrwxrwx 1 root root 26 2011-01-08 11:59 bcm43xx_hdr-0.fw ->=20
bcm43xx_hdr-0-610-809-0.fw

Thanks again,
-- Ilya Kogan




--------------020904000209070006050309
Content-Type: text/x-log;
 name="hwinfo.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hwinfo.log"

============ start debug info ============
libhd version 16.0 (x86-64)
using /var/lib/hardware
kernel version is 2.6
----- /proc/cmdline -----
  BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=85c51aea-99ce-4a1a-9c1a-5af285a7f145 ro quiet splash
----- /proc/cmdline end -----
debug = 0xff7ffff7
probe = 0x00138fc4aa17fcf9fffe (+memory +pci +isapnp +net +floppy +misc +misc.serial +misc.par +misc.floppy +serial +cpu +bios +monitor +mouse +scsi +usb -usb.mods +modem +modem.usb +parallel +parallel.lp +parallel.zip -isa -isa.isdn +isdn +kbd +prom +sbus +int +braille +braille.alva +braille.fhp +braille.ht -ignx11 +sys -bios.vbe -isapnp.old -isapnp.new -isapnp.mod +braille.baum -manual +fb +pppoe -scan +pcmcia -fork -parallel.imm +s390 -cpuemu -sysfs -s390disks +udev +block +block.cdrom +block.part +edd +edd.mod -bios.ddc -bios.fb -bios.mode +input +block.mods +bios.vesa -cpuemu.debug -scsi.noserial +wlan -bios.crc -hal -bios.vram -bios.acpi -bios.ddc.ports -modules.pata -net.eeprom -x86emu -max -lxrc)
shm: attached segment 123404315 at 0x7f8cbca5c000
>> hal.1: read hal data
  hal: connected to: :1.285
----- hal device list -----
  0: udi = '/org/freedesktop/Hal/devices/volume_part2_size_1024'
  volume.fstype = ''
  volume.fsusage = 'partitiontable'
  volume.fsversion = ''
  volume.uuid = ''
  block.minor = 2 (0x2)
  block.is_volume = true
  volume.is_mounted = false
  linux.hotplug_type = 3 (0x3)
  volume.is_mounted_read_only = false
  volume.is_disc = false
  volume.is_partition = true
  volume.mount_point = ''
  info.capabilities = { 'volume', 'block' }
  volume.num_blocks = 2ull (0x2ull)
  volume.linux.is_device_mapper = false
  volume.block_size = 512 (0x200)
  volume.partition.start = 244674722816ull (0x38f7bffc00ull)
  volume.size = 1024ull (0x400ull)
  info.category = 'volume'
  volume.partition.media_size = 250059350016ull (0x3a38b2e000ull)
  info.product = 'Volume'
  volume.partition.number = 2 (0x2)
  volume.partition.label = ''
  volume.partition.scheme = 'mbr'
  volume.partition.type = '0x05'
  volume.label = ''
  volume.partition.uuid = ''
  volume.partition.flags = {  }
  block.device = '/dev/sda2'
  block.major = 8 (0x8)
  info.udi = '/org/freedesktop/Hal/devices/volume_part2_size_1024'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda2'
  info.parent = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'
  block.storage_device = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'

  1: udi = '/org/freedesktop/Hal/devices/volume_uuid_6138fe8c_9476_4396_aa5f_a88c0dc55e29'
  block.minor = 5 (0x5)
  block.is_volume = true
  linux.hotplug_type = 3 (0x3)
  volume.uuid = '6138fe8c-9476-4396-aa5f-a88c0dc55e29'
  volume.is_mounted = false
  volume.is_mounted_read_only = false
  volume.mount_point = ''
  volume.is_disc = false
  volume.is_partition = true
  volume.linux.is_device_mapper = false
  info.capabilities = { 'volume', 'block' }
  volume.num_blocks = 10516480ull (0xa07800ull)
  info.category = 'volume'
  volume.block_size = 512 (0x200)
  volume.partition.start = 244674723840ull (0x38f7c00000ull)
  volume.size = 5384437760ull (0x140f00000ull)
  volume.partition.number = 5 (0x5)
  volume.partition.media_size = 250059350016ull (0x3a38b2e000ull)
  info.product = 'Volume (swap)'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda5'
  info.parent = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'
  info.udi = '/org/freedesktop/Hal/devices/volume_uuid_6138fe8c_9476_4396_aa5f_a88c0dc55e29'
  block.storage_device = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'
  volume.fstype = 'swap'
  volume.fsusage = 'other'
  volume.fsversion = '2'
  block.device = '/dev/sda5'
  block.major = 8 (0x8)
  volume.label = ''

  2: udi = '/org/freedesktop/Hal/devices/volume_uuid_85c51aea_99ce_4a1a_9c1a_5af285a7f145'
  volume.fstype = 'ext4'
  volume.fsusage = 'filesystem'
  volume.fsversion = '1.0'
  volume.uuid = '85c51aea-99ce-4a1a-9c1a-5af285a7f145'
  block.minor = 1 (0x1)
  block.is_volume = true
  volume.is_mounted = true
  linux.hotplug_type = 3 (0x3)
  volume.is_mounted_read_only = false
  volume.is_disc = false
  volume.is_partition = true
  volume.mount_point = '/'
  info.capabilities = { 'volume', 'block' }
  volume.num_blocks = 477876224ull (0x1c7bd000ull)
  volume.linux.is_device_mapper = false
  volume.block_size = 512 (0x200)
  volume.partition.start = 1048576ull (0x100000ull)
  volume.size = 244672626688ull (0x38f7a00000ull)
  info.category = 'volume'
  volume.partition.media_size = 250059350016ull (0x3a38b2e000ull)
  info.product = 'Volume (ext4)'
  volume.partition.number = 1 (0x1)
  volume.ignore = false
  info.udi = '/org/freedesktop/Hal/devices/volume_uuid_85c51aea_99ce_4a1a_9c1a_5af285a7f145'
  block.major = 8 (0x8)
  volume.label = ''
  org.freedesktop.Hal.Device.Volume.method_names = { 'Mount', 'Unmount', 'Eject' }
  org.freedesktop.Hal.Device.Volume.method_signatures = { 'ssas', 'as', 'as' }
  org.freedesktop.Hal.Device.Volume.method_argnames = { 'mount_point fstype extra_options', 'extra_options', 'extra_options' }
  org.freedesktop.Hal.Device.Volume.method_execpaths = { 'hal-storage-mount', 'hal-storage-unmount', 'hal-storage-eject' }
  block.device = '/dev/sda1'
  volume.unmount.valid_options = { 'lazy' }
  volume.mount.valid_options = { 'ro', 'sync', 'dirsync', 'noatime', 'nodiratime', 'relatime', 'noexec', 'quiet', 'remount', 'exec' }
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda1'
  info.parent = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'
  info.interfaces = { 'org.freedesktop.Hal.Device.Volume' }
  block.storage_device = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'

  3: udi = '/org/freedesktop/Hal/devices/computer'
  org.freedesktop.Hal.Device.SystemPowerManagement.method_argnames = { 'num_seconds_to_sleep', 'num_seconds_to_sleep', '', '', '', 'enable_power_save' }
  org.freedesktop.Hal.Device.SystemPowerManagement.method_execpaths = { 'hal-system-power-suspend', 'hal-system-power-suspend-hybrid', 'hal-system-power-hibernate', 'hal-system-power-shutdown', 'hal-system-power-reboot', 'hal-system-power-set-power-save' }
  info.addons = { 'hald-addon-cpufreq', 'hald-addon-acpi' }
  info.capabilities = { 'cpufreq_control' }
  info.subsystem = 'unknown'
  info.product = 'Computer'
  info.udi = '/org/freedesktop/Hal/devices/computer'
  org.freedesktop.Hal.version = '0.5.14'
  org.freedesktop.Hal.version.major = 0 (0x0)
  org.freedesktop.Hal.version.minor = 5 (0x5)
  org.freedesktop.Hal.version.micro = 14 (0xe)
  system.kernel.name = 'Linux'
  system.kernel.version = '2.6.35-24-generic'
  system.kernel.version.major = 2 (0x2)
  system.kernel.version.minor = 6 (0x6)
  system.kernel.version.micro = 35 (0x23)
  system.kernel.machine = 'x86_64'
  power_management.can_suspend = true
  power_management.can_suspend_hybrid = true
  power_management.can_hibernate = true
  system.hardware.primary_video.vendor = 4098 (0x1002)
  system.hardware.primary_video.product = 38674 (0x9712)
  system.hardware.serial = 'LXSBB02075028006C22000'
  system.hardware.uuid = '6B582D00-8EC2-11DF-BDDF-BC5869AF0651'
  system.board.serial = 'LXSBB02075028006C22000'
  system.firmware.vendor = 'Phoenix Technologies LTD'
  system.firmware.version = 'V1.11'
  system.firmware.release_date = '05/14/2010'
  system.hardware.vendor = 'Acer'
  system.hardware.product = 'Aspire 1551'
  system.hardware.version = 'V1.11'
  system.chassis.manufacturer = 'Acer'
  system.board.product = 'Aspire 1551'
  system.board.version = 'V1.11'
  system.board.vendor = 'Acer'
  system.chassis.type = 'Notebook'
  system.formfactor = 'laptop'
  power_management.quirk.vbe_post = true
  power_management.quirk.dpms_on = true
  power_management.quirk.vbestate_restore = true
  power_management.type = 'acpi'
  power_management.acpi.linux.version = '20100428'
  power_management.quirk.vga_mode_3 = true
  org.freedesktop.Hal.Device.SystemPowerManagement.method_names = { 'Suspend', 'SuspendHybrid', 'Hibernate', 'Shutdown', 'Reboot', 'SetPowerSave' }
  info.interfaces = { 'org.freedesktop.Hal.Device.SystemPowerManagement', 'org.freedesktop.Hal.Device.CPUFreq' }
  power_management.quirk.vbemode_restore = true
  power_management.quirk.dpms_suspend = true
  power_management.is_powersave_set = false
  info.callouts.add = { 'hal-storage-cleanup-all-mountpoints' }
  org.freedesktop.Hal.Device.SystemPowerManagement.method_signatures = { 'i', 'i', '', '', '', 'b' }

  4: udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_3'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event1'
  info.category = 'input'
  info.capabilities = { 'input', 'input.switch', 'button' }
  input.device = '/dev/input/event1'
  input.product = 'Lid Switch'
  button.has_state = true
  button.type = 'lid'
  button.state.value = false
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = 'Lid Switch'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1/event1'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_3'

  5: udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0_video4linux'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'video4linux'
  linux.device_file = '/dev/video0'
  info.category = 'video4linux'
  info.capabilities = { 'video4linux', 'video4linux.video_capture' }
  info.subsystem = 'video4linux'
  info.product = '1.3M WebCam'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/video4linux/video0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0'
  video4linux.device = '/dev/video0'
  video4linux.version = '2'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0_video4linux'

  6: udi = '/org/freedesktop/Hal/devices/storage_serial_Generic__Multi_Card_20090516388200000_0_0'
  info.vendor = 'Generic-'
  block.device = '/dev/sdb'
  block.major = 8 (0x8)
  block.minor = 16 (0x10)
  block.is_volume = false
  storage.bus = 'usb'
  linux.hotplug_type = 3 (0x3)
  storage.no_partitions_hint = false
  storage.media_check_enabled = true
  storage.automount_enabled_hint = true
  storage.drive_type = 'disk'
  storage.model = 'Multi-Card'
  storage.vendor = 'Generic-'
  storage.serial = 'Generic-_Multi-Card_20090516388200000-0:0'
  storage.firmware_version = '1.00'
  storage.lun = 0 (0x0)
  storage.originating_device = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0'
  storage.removable.media_available = false
  storage.removable = true
  storage.size = 0ull (0x0ull)
  storage.hotpluggable = true
  info.product = 'Multi-Card'
  info.udi = '/org/freedesktop/Hal/devices/storage_serial_Generic__Multi_Card_20090516388200000_0_0'
  info.capabilities = { 'storage', 'block' }
  storage.removable.support_async_notification = false
  storage.requires_eject = false
  info.category = 'storage'
  info.addons = { 'hald-addon-storage' }
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/block/sdb'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_device_lun0'
  info.interfaces = { 'org.freedesktop.Hal.Device.Storage.Removable' }
  storage.partitioning_scheme = ''
  block.storage_device = '/org/freedesktop/Hal/devices/storage_serial_Generic__Multi_Card_20090516388200000_0_0'

  7: udi = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'
  info.vendor = 'ATA'
  block.device = '/dev/sda'
  block.major = 8 (0x8)
  block.minor = 0 (0x0)
  block.is_volume = false
  storage.bus = 'pci'
  linux.hotplug_type = 3 (0x3)
  storage.no_partitions_hint = false
  storage.media_check_enabled = false
  storage.automount_enabled_hint = true
  storage.drive_type = 'disk'
  storage.model = 'WDC WD2500BEVT-2'
  storage.vendor = 'ATA'
  storage.serial = 'WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727'
  storage.firmware_version = '01.01A10'
  storage.lun = 0 (0x0)
  storage.originating_device = '/org/freedesktop/Hal/devices/computer'
  storage.removable.media_available = true
  storage.removable = false
  storage.size = 250059350016ull (0x3a38b2e000ull)
  storage.hotpluggable = false
  info.product = 'WDC WD2500BEVT-2'
  info.category = 'storage'
  info.capabilities = { 'storage', 'block' }
  info.udi = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'
  storage.requires_eject = false
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_device_lun0'
  storage.removable.media_size = 250059350016ull (0x3a38b2e000ull)
  storage.partitioning_scheme = 'mbr'
  block.storage_device = '/org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727'

  8: udi = '/org/freedesktop/Hal/devices/acpi_CPU0'
  linux.hotplug_type = 4 (0x4)
  info.category = 'processor'
  info.capabilities = { 'processor' }
  linux.acpi_path = '/proc/acpi/processor/CPU0'
  linux.acpi_type = 1 (0x1)
  info.parent = '/org/freedesktop/Hal/devices/computer'
  processor.can_throttle = false
  info.udi = '/org/freedesktop/Hal/devices/acpi_CPU0'
  processor.number = 0 (0x0)
  info.product = 'AMD Athlon(tm) II Neo K325 Dual-Core Processor'

  9: udi = '/org/freedesktop/Hal/devices/acpi_CPU1'
  linux.hotplug_type = 4 (0x4)
  info.category = 'processor'
  info.capabilities = { 'processor' }
  linux.acpi_path = '/proc/acpi/processor/CPU1'
  linux.acpi_type = 1 (0x1)
  info.parent = '/org/freedesktop/Hal/devices/computer'
  processor.can_throttle = false
  info.udi = '/org/freedesktop/Hal/devices/acpi_CPU1'
  processor.number = 1 (0x1)
  info.product = 'AMD Athlon(tm) II Neo K325 Dual-Core Processor'

  10: udi = '/org/freedesktop/Hal/devices/computer_alsa_timer'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/timer'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/timer'
  alsa.type = 'timer'
  info.subsystem = 'sound'
  info.product = 'ALSA Timer Device'
  linux.sysfs_path = '/sys/devices/virtual/sound/timer'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_alsa_timer'

  11: udi = '/org/freedesktop/Hal/devices/computer_alsa_sequencer'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/seq'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/seq'
  alsa.type = 'sequencer'
  info.subsystem = 'sound'
  info.product = 'ALSA Sequencer Device'
  linux.sysfs_path = '/sys/devices/virtual/sound/seq'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_alsa_sequencer'

  12: udi = '/org/freedesktop/Hal/devices/net_0a_00_27_00_00_00'
  org.freedesktop.Hal.Device.WakeOnLan.method_signatures = { '', '', 'b' }
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'net'
  info.category = 'net.80203'
  info.capabilities = { 'net', 'net.80203', 'wake_on_lan' }
  info.subsystem = 'net'
  net.originating_device = '/org/freedesktop/Hal/devices/computer'
  linux.sysfs_path = '/sys/devices/virtual/net/vboxnet0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  net.linux.ifindex = 4 (0x4)
  net.interface = 'vboxnet0'
  net.address = '0a:00:27:00:00:00'
  info.product = 'Networking Interface'
  net.arp_proto_hw_id = 1 (0x1)
  net.80203.mac_address = 10995770589184ull (0xa0027000000ull)
  info.interfaces = { 'org.freedesktop.Hal.Device.WakeOnLan' }
  org.freedesktop.Hal.Device.WakeOnLan.method_names = { 'GetSupported', 'GetEnabled', 'SetEnabled' }
  info.udi = '/org/freedesktop/Hal/devices/net_0a_00_27_00_00_00'
  org.freedesktop.Hal.Device.WakeOnLan.method_argnames = { '', '', 'enable' }
  org.freedesktop.Hal.Device.WakeOnLan.method_execpaths = { 'hal-system-wol-supported', 'hal-system-wol-enabled', 'hal-system-wol-enable' }

  13: udi = '/org/freedesktop/Hal/devices/net_computer_loopback'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'net'
  info.category = 'net.loopback'
  info.capabilities = { 'net', 'net.loopback' }
  info.subsystem = 'net'
  net.originating_device = '/org/freedesktop/Hal/devices/computer'
  linux.sysfs_path = '/sys/devices/virtual/net/lo'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  net.linux.ifindex = 1 (0x1)
  net.interface = 'lo'
  net.address = '00:00:00:00:00:00'
  info.product = 'Loopback device Interface'
  net.arp_proto_hw_id = 772 (0x304)
  info.udi = '/org/freedesktop/Hal/devices/net_computer_loopback'

  14: udi = '/org/freedesktop/Hal/devices/computer_backlight'
  laptop_panel.access_method = 'general'
  laptop_panel.brightness_in_hardware = true
  laptop_panel.num_levels = 10 (0xa)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'backlight'
  info.category = 'laptop_panel'
  info.capabilities = { 'laptop_panel' }
  info.addons = { 'hald-addon-generic-backlight' }
  info.subsystem = 'backlight'
  info.product = 'Generic Backlight Device'
  linux.sysfs_path = '/sys/devices/virtual/backlight/acpi_video0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_backlight'
  info.interfaces = { 'org.freedesktop.Hal.Device.LaptopPanel' }

  15: udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port_logicaldev_input'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event7'
  info.category = 'input'
  info.capabilities = { 'input', 'input.mouse' }
  input.device = '/dev/input/event7'
  input.product = 'PS/2 Generic Mouse'
  info.subsystem = 'input'
  info.product = 'PS/2 Generic Mouse'
  linux.sysfs_path = '/sys/devices/platform/i8042/serio1/input/input7/event7'
  input.originating_device = '/org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port'
  info.parent = '/org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port'
  info.udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port_logicaldev_input'

  16: udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port_logicaldev_input'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event4'
  info.category = 'input'
  info.capabilities = { 'input', 'input.keyboard', 'input.keypad', 'input.keys', 'input.keymap', 'button' }
  input.device = '/dev/input/event4'
  input.product = 'AT Translated Set 2 keyboard'
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = 'AT Translated Set 2 keyboard'
  linux.sysfs_path = '/sys/devices/platform/i8042/serio0/input/input4/event4'
  input.originating_device = '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port'
  info.parent = '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port'
  info.udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port_logicaldev_input'
  input.keymap.data = { 'e025:help', 'e026:setup', 'e027:battery', 'e029:switchvideomode', 'e033:euro', 'e034:dollar', 'e04e:brightnessup', 'e054:bluetooth', 'e055:wlan', 'e056:wlan', 'e057:bluetooth', 'e058:bluetooth', 'e059:brightnessup', 'e06e:brightnessup', 'e06f:brightnessdown', 'e071:f22', 'e072:f22', 'e073:prog2', 'e074:prog1', 'e075:presentation', 'e078:fn', 'e079:f23' }

  17: udi = '/org/freedesktop/Hal/devices/platform_acer_wmi_rfkill_acer_wireless_wlan'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'rfkill'
  info.category = 'killswitch'
  info.capabilities = { 'killswitch' }
  info.addons.singleton = { 'hald-addon-rfkill-killswitch' }
  info.subsystem = 'rfkill'
  info.product = 'acer-wireless wlan Killswitch'
  linux.sysfs_path = '/sys/devices/platform/acer-wmi/rfkill/rfkill0'
  info.parent = '/org/freedesktop/Hal/devices/platform_acer_wmi'
  killswitch.type = 'wlan'
  killswitch.state = 0 (0x0)
  killswitch.access_method = 'rfkill'
  killswitch.name = 'acer-wireless'
  info.interfaces = { 'org.freedesktop.Hal.Device.KillSwitch' }
  info.udi = '/org/freedesktop/Hal/devices/platform_acer_wmi_rfkill_acer_wireless_wlan'

  18: udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_playback_1'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/pcmC0D1p'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/pcmC0D1p'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  alsa.card = 0 (0x0)
  alsa.type = 'playback'
  alsa.card_id = 'HDA ATI SB'
  alsa.device = 1 (0x1)
  alsa.pcm_class = 'generic'
  alsa.device_id = 'ALC271X Digital'
  info.product = 'ALC271X Digital ALSA Playback Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D1p'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_playback_1'
  info.subsystem = 'sound'

  19: udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_playback_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/pcmC0D0p'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/pcmC0D0p'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  alsa.card = 0 (0x0)
  alsa.type = 'playback'
  alsa.card_id = 'HDA ATI SB'
  alsa.device = 0 (0x0)
  alsa.pcm_class = 'generic'
  alsa.device_id = 'ALC271X Analog'
  info.product = 'ALC271X Analog ALSA Playback Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0p'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_playback_0'
  info.subsystem = 'sound'

  20: udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_capture_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/pcmC0D0c'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/pcmC0D0c'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  alsa.card = 0 (0x0)
  alsa.type = 'capture'
  alsa.card_id = 'HDA ATI SB'
  alsa.device = 0 (0x0)
  alsa.pcm_class = 'generic'
  alsa.device_id = 'ALC271X Analog'
  info.product = 'ALC271X Analog ALSA Capture Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0c'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_capture_0'
  info.subsystem = 'sound'

  21: udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_hw_specific_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/hwC0D0'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/hwC0D0'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  alsa.card = 0 (0x0)
  alsa.type = 'hw_specific'
  alsa.card_id = 'HDA ATI SB'
  alsa.device = 0 (0x0)
  info.subsystem = 'sound'
  info.product = 'HDA ATI SB ALSA hardware specific Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2/sound/card0/hwC0D0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_hw_specific_0'

  22: udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_control__1'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/controlC0'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/controlC0'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  alsa.card = 0 (0x0)
  alsa.type = 'control'
  alsa.card_id = 'HDA ATI SB'
  info.subsystem = 'sound'
  info.product = 'HDA ATI SB ALSA Control Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2/sound/card0/controlC0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0_alsa_control__1'

  23: udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  info.category = 'sound'
  sound.originating_device = '/org/freedesktop/Hal/devices/pci_1002_4383'
  info.capabilities = { 'sound' }
  sound.card_id = 'HDA ATI SB'
  sound.card = 0 (0x0)
  info.subsystem = 'sound'
  info.product = 'HDA ATI SB Sound Card'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2/sound/card0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4383'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383_sound_card_0'

  24: udi = '/org/freedesktop/Hal/devices/pci_1002_439c_scsi_host_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_host'
  scsi_host.host = 1 (0x1)
  info.category = 'scsi_host'
  info.capabilities = { 'scsi_host' }
  info.subsystem = 'scsi_host'
  info.product = 'SCSI Host Adapter'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.1/host1/scsi_host/host1'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_439c'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_439c_scsi_host_0'

  25: udi = '/org/freedesktop/Hal/devices/pci_1002_439c_scsi_host'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_host'
  scsi_host.host = 0 (0x0)
  info.category = 'scsi_host'
  info.capabilities = { 'scsi_host' }
  info.subsystem = 'scsi_host'
  info.product = 'SCSI Host Adapter'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.1/host0/scsi_host/host0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_439c'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_439c_scsi_host'

  26: udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0_logicaldev_input'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event6'
  info.category = 'input'
  info.capabilities = { 'input', 'button', 'input.keys' }
  input.device = '/dev/input/event6'
  input.product = '1.3M WebCam'
  button.has_state = false
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = '1.3M WebCam'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6/event6'
  input.originating_device = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0_logicaldev_input'

  27: udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_device_lun0_scsi_generic'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_generic'
  linux.device_file = '/dev/sg1'
  info.category = 'scsi_generic'
  info.capabilities = { 'scsi_generic' }
  info.subsystem = 'scsi_generic'
  info.product = 'SCSI Generic Interface'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_generic/sg1'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_device_lun0'
  scsi_generic.device = '/dev/sg1'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_device_lun0_scsi_generic'

  28: udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_host'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_host'
  scsi_host.host = 3 (0x3)
  info.category = 'scsi_host'
  info.capabilities = { 'scsi_host' }
  info.subsystem = 'scsi_host'
  info.product = 'SCSI Host Adapter'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/scsi_host/host3'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_host'

  29: udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_device_lun0_scsi_generic'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_generic'
  linux.device_file = '/dev/sg0'
  info.category = 'scsi_generic'
  info.capabilities = { 'scsi_generic' }
  info.subsystem = 'scsi_generic'
  info.product = 'SCSI Generic Interface'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_generic/sg0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_device_lun0'
  scsi_generic.device = '/dev/sg0'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_device_lun0_scsi_generic'

  30: udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_host'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_host'
  scsi_host.host = 2 (0x2)
  info.category = 'scsi_host'
  info.capabilities = { 'scsi_host' }
  info.subsystem = 'scsi_host'
  info.product = 'SCSI Host Adapter'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/scsi_host/host2'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_host'

  31: udi = '/org/freedesktop/Hal/devices/net_20_6a_8a_0b_39_bf'
  org.freedesktop.Hal.Device.WakeOnLan.method_signatures = { '', '', 'b' }
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'net'
  info.category = 'net.80203'
  info.capabilities = { 'net', 'net.80203', 'wake_on_lan' }
  info.subsystem = 'net'
  net.originating_device = '/org/freedesktop/Hal/devices/pci_1969_1073'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0/net/eth0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1969_1073'
  net.linux.ifindex = 5 (0x5)
  net.interface = 'eth0'
  net.address = '20:6a:8a:0b:39:bf'
  info.product = 'Networking Interface'
  net.arp_proto_hw_id = 1 (0x1)
  net.80203.mac_address = 35641954613695ull (0x206a8a0b39bfull)
  info.interfaces = { 'org.freedesktop.Hal.Device.WakeOnLan' }
  org.freedesktop.Hal.Device.WakeOnLan.method_names = { 'GetSupported', 'GetEnabled', 'SetEnabled' }
  info.udi = '/org/freedesktop/Hal/devices/net_20_6a_8a_0b_39_bf'
  org.freedesktop.Hal.Device.WakeOnLan.method_argnames = { '', '', 'enable' }
  org.freedesktop.Hal.Device.WakeOnLan.method_execpaths = { 'hal-system-wol-supported', 'hal-system-wol-enabled', 'hal-system-wol-enable' }

  32: udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1_alsa_playback_3'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/pcmC1D3p'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/pcmC1D3p'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  alsa.card = 1 (0x1)
  alsa.type = 'playback'
  alsa.card_id = 'HDA ATI HDMI'
  alsa.device = 3 (0x3)
  alsa.pcm_class = 'generic'
  alsa.device_id = 'ATI HDMI'
  info.product = 'ATI HDMI ALSA Playback Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/pcmC1D3p'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1_alsa_playback_3'
  info.subsystem = 'sound'

  33: udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1_alsa_hw_specific_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/hwC1D0'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/hwC1D0'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  alsa.card = 1 (0x1)
  alsa.type = 'hw_specific'
  alsa.card_id = 'HDA ATI HDMI'
  alsa.device = 0 (0x0)
  info.subsystem = 'sound'
  info.product = 'HDA ATI HDMI ALSA hardware specific Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/hwC1D0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1_alsa_hw_specific_0'

  34: udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1_alsa_control__1'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  linux.device_file = '/dev/snd/controlC1'
  info.category = 'alsa'
  info.capabilities = { 'alsa' }
  alsa.device_file = '/dev/snd/controlC1'
  alsa.originating_device = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  alsa.card = 1 (0x1)
  alsa.type = 'control'
  alsa.card_id = 'HDA ATI HDMI'
  info.subsystem = 'sound'
  info.product = 'HDA ATI HDMI ALSA Control Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/controlC1'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1_alsa_control__1'

  35: udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'sound'
  info.category = 'sound'
  sound.originating_device = '/org/freedesktop/Hal/devices/pci_1002_970f'
  info.capabilities = { 'sound' }
  sound.card_id = 'HDA ATI HDMI'
  sound.card = 1 (0x1)
  info.subsystem = 'sound'
  info.product = 'HDA ATI HDMI Sound Card'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_970f'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_970f_sound_card_1'

  36: udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event2'
  info.category = 'input'
  info.capabilities = { 'input', 'button', 'input.keys' }
  input.device = '/dev/input/event2'
  input.product = 'Sleep Button'
  button.has_state = false
  button.type = 'sleep'
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = 'Sleep Button'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2/event2'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'

  37: udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_1'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event0'
  info.category = 'input'
  info.capabilities = { 'input', 'button', 'input.keys' }
  input.device = '/dev/input/event0'
  input.product = 'Power Button'
  button.has_state = false
  button.type = 'power'
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = 'Power Button'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_1'

  38: udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event5'
  info.category = 'input'
  info.capabilities = { 'input', 'input.keys', 'button' }
  input.device = '/dev/input/event5'
  input.product = 'Video Bus'
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = 'Video Bus'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5/event5'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_0'

  39: udi = '/org/freedesktop/Hal/devices/computer_power_supply_battery_BAT0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'power_supply'
  info.category = 'battery'
  info.capabilities = { 'battery' }
  battery.type = 'primary'
  info.subsystem = 'power_supply'
  battery.reporting.technology = 'Li-ion'
  battery.technology = 'lithium-ion'
  battery.model = 'AL10C31'
  info.product = 'AL10C31'
  battery.voltage.design = 11100 (0x2b5c)
  battery.vendor = 'SANYO'
  battery.reporting.design = 4400 (0x1130)
  battery.voltage.unit = 'mV'
  battery.serial = '10814'
  battery.reporting.unit = 'mAh'
  battery.voltage.current = 12834 (0x3222)
  battery.present = true
  battery.is_rechargeable = true
  battery.rechargeable.is_discharging = false
  battery.reporting.current = 3852 (0xf0c)
  battery.reporting.last_full = 3852 (0xf0c)
  battery.charge_level.current = 42757 (0xa705)
  battery.charge_level.last_full = 42757 (0xa705)
  battery.charge_level.design = 48840 (0xbec8)
  battery.charge_level.rate = 0 (0x0)
  battery.charge_level.percentage = 100 (0x64)
  battery.rechargeable.is_charging = false
  battery.reporting.rate = 0 (0x0)
  info.udi = '/org/freedesktop/Hal/devices/computer_power_supply_battery_BAT0'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00/power_supply/BAT0'
  info.parent = '/org/freedesktop/Hal/devices/computer'

  40: udi = '/org/freedesktop/Hal/devices/computer_power_supply_ac_adapter_ADP1'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'power_supply'
  info.category = 'ac_adapter'
  info.capabilities = { 'ac_adapter' }
  ac_adapter.present = true
  info.subsystem = 'power_supply'
  info.product = 'Generic AC Adapter Device'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00/power_supply/ADP1'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_power_supply_ac_adapter_ADP1'

  41: udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'input'
  linux.device_file = '/dev/input/event3'
  info.category = 'input'
  info.capabilities = { 'input', 'button', 'input.keys' }
  input.device = '/dev/input/event3'
  input.product = 'Power Button'
  button.has_state = false
  button.type = 'power'
  info.addons.singleton = { 'hald-addon-input' }
  info.subsystem = 'input'
  info.product = 'Power Button'
  linux.sysfs_path = '/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input'

  42: udi = '/org/freedesktop/Hal/devices/pnp_SYN1b37'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  info.linux.driver = 'i8042 aux'
  pnp.id = 'SYN1b37'
  info.subsystem = 'pnp'
  info.product = 'PnP Device (SYN1b37)'
  linux.sysfs_path = '/sys/devices/pnp0/00:09'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_SYN1b37'

  43: udi = '/org/freedesktop/Hal/devices/pnp_PNP0303'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  info.linux.driver = 'i8042 kbd'
  pnp.id = 'PNP0303'
  pnp.description = 'IBM Enhanced (101/102-key, PS/2 mouse support)'
  info.subsystem = 'pnp'
  info.product = 'IBM Enhanced (101/102-key, PS/2 mouse support)'
  linux.sysfs_path = '/sys/devices/pnp0/00:08'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0303'

  44: udi = '/org/freedesktop/Hal/devices/pnp_PNP0c01'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  info.linux.driver = 'system'
  pnp.id = 'PNP0c01'
  pnp.description = 'System Board'
  info.subsystem = 'pnp'
  info.product = 'System Board'
  linux.sysfs_path = '/sys/devices/pnp0/00:07'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0c01'

  45: udi = '/org/freedesktop/Hal/devices/pnp_PNP0c02_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  info.linux.driver = 'system'
  pnp.id = 'PNP0c02'
  pnp.description = 'General ID for reserving resources required by PnP motherboard registers. (Not device specific.)'
  info.subsystem = 'pnp'
  info.product = 'General ID for reserving resources required by PnP motherboard registers. (Not device specific.)'
  linux.sysfs_path = '/sys/devices/pnp0/00:06'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0c02_0'

  46: udi = '/org/freedesktop/Hal/devices/pnp_PNP0800'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  pnp.id = 'PNP0800'
  pnp.description = 'AT-style speaker sound'
  info.subsystem = 'pnp'
  info.product = 'AT-style speaker sound'
  linux.sysfs_path = '/sys/devices/pnp0/00:05'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0800'

  47: udi = '/org/freedesktop/Hal/devices/pnp_PNP0b00'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  info.linux.driver = 'rtc_cmos'
  pnp.id = 'PNP0b00'
  pnp.description = 'AT Real-Time Clock'
  info.subsystem = 'pnp'
  info.product = 'AT Real-Time Clock'
  linux.sysfs_path = '/sys/devices/pnp0/00:04'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0b00'

  48: udi = '/org/freedesktop/Hal/devices/pnp_PNP0c04'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  pnp.id = 'PNP0c04'
  pnp.description = 'Math Coprocessor'
  info.subsystem = 'pnp'
  info.product = 'Math Coprocessor'
  linux.sysfs_path = '/sys/devices/pnp0/00:03'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0c04'

  49: udi = '/org/freedesktop/Hal/devices/pnp_PNP0200'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  pnp.id = 'PNP0200'
  pnp.description = 'AT DMA Controller'
  info.subsystem = 'pnp'
  info.product = 'AT DMA Controller'
  linux.sysfs_path = '/sys/devices/pnp0/00:02'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0200'

  50: udi = '/org/freedesktop/Hal/devices/pnp_PNP0c02'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  info.linux.driver = 'system'
  pnp.id = 'PNP0c02'
  pnp.description = 'General ID for reserving resources required by PnP motherboard registers. (Not device specific.)'
  info.subsystem = 'pnp'
  info.product = 'General ID for reserving resources required by PnP motherboard registers. (Not device specific.)'
  linux.sysfs_path = '/sys/devices/pnp0/00:01'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0c02'

  51: udi = '/org/freedesktop/Hal/devices/pnp_PNP0a08'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pnp'
  pnp.id = 'PNP0a08'
  info.subsystem = 'pnp'
  info.product = 'PnP Device (PNP0a08)'
  linux.sysfs_path = '/sys/devices/pnp0/00:00'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/pnp_PNP0a08'

  52: udi = '/org/freedesktop/Hal/devices/platform_vboxdrv_0'
  linux.hotplug_type = 2 (0x2)
  platform.id = 'vboxdrv.0'
  info.linux.driver = 'vboxdrv'
  linux.subsystem = 'platform'
  info.subsystem = 'platform'
  info.product = 'Platform Device (vboxdrv.0)'
  linux.sysfs_path = '/sys/devices/platform/vboxdrv.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/platform_vboxdrv_0'

  53: udi = '/org/freedesktop/Hal/devices/platform_serial8250'
  linux.hotplug_type = 2 (0x2)
  platform.id = 'serial8250'
  info.linux.driver = 'serial8250'
  linux.subsystem = 'platform'
  info.subsystem = 'platform'
  info.product = 'Platform Device (serial8250)'
  linux.sysfs_path = '/sys/devices/platform/serial8250'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/platform_serial8250'

  54: udi = '/org/freedesktop/Hal/devices/platform_pcspkr'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'platform'
  platform.id = 'pcspkr'
  info.subsystem = 'platform'
  info.product = 'Platform Device (pcspkr)'
  linux.sysfs_path = '/sys/devices/platform/pcspkr'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/platform_pcspkr'

  55: udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'serio'
  info.linux.driver = 'psmouse'
  serio.description = 'i8042 AUX port'
  serio.id = 'serio1'
  info.subsystem = 'serio'
  info.product = 'i8042 AUX port'
  linux.sysfs_path = '/sys/devices/platform/i8042/serio1'
  info.parent = '/org/freedesktop/Hal/devices/platform_i8042'
  info.udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port'

  56: udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'serio'
  info.linux.driver = 'atkbd'
  serio.description = 'i8042 KBD port'
  serio.id = 'serio0'
  info.subsystem = 'serio'
  info.product = 'i8042 KBD port'
  linux.sysfs_path = '/sys/devices/platform/i8042/serio0'
  info.parent = '/org/freedesktop/Hal/devices/platform_i8042'
  info.udi = '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port'

  57: udi = '/org/freedesktop/Hal/devices/platform_i8042'
  linux.hotplug_type = 2 (0x2)
  platform.id = 'i8042'
  info.linux.driver = 'i8042'
  linux.subsystem = 'platform'
  info.subsystem = 'platform'
  info.product = 'Platform Device (i8042)'
  linux.sysfs_path = '/sys/devices/platform/i8042'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/platform_i8042'

  58: udi = '/org/freedesktop/Hal/devices/platform_acer_wmi'
  linux.hotplug_type = 2 (0x2)
  platform.id = 'acer-wmi'
  info.linux.driver = 'acer-wmi'
  linux.subsystem = 'platform'
  info.subsystem = 'platform'
  info.product = 'Platform Device (acer-wmi)'
  linux.sysfs_path = '/sys/devices/platform/acer-wmi'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/platform_acer_wmi'

  59: udi = '/org/freedesktop/Hal/devices/platform_Fixed_MDIO_bus_0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'platform'
  platform.id = 'Fixed MDIO bus.0'
  info.subsystem = 'platform'
  info.product = 'Platform Device (Fixed MDIO bus.0)'
  linux.sysfs_path = '/sys/devices/platform/Fixed MDIO bus.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  info.udi = '/org/freedesktop/Hal/devices/platform_Fixed_MDIO_bus_0'

  60: udi = '/org/freedesktop/Hal/devices/pci_1022_1204'
  pci.product = 'Family 10h Processor Link Control'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_1204'
  info.subsystem = 'pci'
  info.product = 'Family 10h Processor Link Control'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.4'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.4'
  pci.product_id = 4612 (0x1204)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  61: udi = '/org/freedesktop/Hal/devices/pci_1022_1203'
  pci.product = 'Family 10h Processor Miscellaneous Control'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'k10temp'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_1203'
  info.subsystem = 'pci'
  info.product = 'Family 10h Processor Miscellaneous Control'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.3'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.3'
  pci.product_id = 4611 (0x1203)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  62: udi = '/org/freedesktop/Hal/devices/pci_1022_1202'
  pci.product = 'Family 10h Processor DRAM Controller'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_1202'
  info.subsystem = 'pci'
  info.product = 'Family 10h Processor DRAM Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.2'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.2'
  pci.product_id = 4610 (0x1202)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  63: udi = '/org/freedesktop/Hal/devices/pci_1022_1201'
  pci.product = 'Family 10h Processor Address Map'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_1201'
  info.subsystem = 'pci'
  info.product = 'Family 10h Processor Address Map'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.1'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.1'
  pci.product_id = 4609 (0x1201)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  64: udi = '/org/freedesktop/Hal/devices/pci_1022_1200'
  pci.product = 'Family 10h Processor HyperTransport Configuration'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_1200'
  info.subsystem = 'pci'
  info.product = 'Family 10h Processor HyperTransport Configuration'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:18.0'
  pci.product_id = 4608 (0x1200)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  65: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2_if0'
  usb.interface.class = 9 (0x9)
  usb.interface.subclass = 0 (0x0)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'hub'
  info.subsystem = 'usb'
  info.product = 'USB Hub Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 9 (0x9)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 7531 (0x1d6b)
  usb.product_id = 2 (0x2)
  usb.max_power = 0 (0x0)
  usb.product = 'USB Hub Interface'
  usb.linux.device_number = 1 (0x1)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2'
  usb.speed = 480.000
  usb.serial = '0000:00:16.2'
  usb.is_self_powered = true
  usb.version = 2.00000
  usb.bus_number = 3 (0x3)
  usb.can_wake_up = true
  usb.vendor = 'Linux Foundation'
  usb.num_ports = 4 (0x4)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 518 (0x206)

  66: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2'
  info.vendor = 'Linux Foundation'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.2/usb3'
  usb_device.configuration_value = 1 (0x1)
  info.product = '2.0 root hub'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_class = 9 (0x9)
  usb_device.device_subclass = 0 (0x0)
  usb_device.device_protocol = 0 (0x0)
  usb_device.vendor_id = 7531 (0x1d6b)
  usb_device.product_id = 2 (0x2)
  usb_device.max_power = 0 (0x0)
  usb_device.product = '2.0 root hub'
  usb_device.linux.device_number = 1 (0x1)
  usb_device.serial = '0000:00:16.2'
  usb_device.speed = 480.000
  usb_device.version = 2.00000
  usb_device.is_self_powered = true
  usb_device.can_wake_up = true
  usb_device.bus_number = 3 (0x3)
  linux.device_file = '/dev/bus/usb/003/001'
  usb_device.num_ports = 4 (0x4)
  usb_device.vendor = 'Linux Foundation'
  usb_device.device_revision_bcd = 518 (0x206)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.2/usb3'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4396_1'

  67: udi = '/org/freedesktop/Hal/devices/pci_1002_4396_1'
  pci.product = 'SB700/SB800 USB EHCI Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ehci_hcd'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4396_1'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 USB EHCI Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.2'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.2'
  pci.product_id = 17302 (0x4396)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 32 (0x20)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  68: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0_if0'
  usb.interface.class = 9 (0x9)
  usb.interface.subclass = 0 (0x0)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'hub'
  info.subsystem = 'usb'
  info.product = 'USB Hub Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 9 (0x9)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 7531 (0x1d6b)
  usb.product_id = 1 (0x1)
  usb.max_power = 0 (0x0)
  usb.product = 'USB Hub Interface'
  usb.linux.device_number = 1 (0x1)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0'
  usb.speed = 12.0000
  usb.serial = '0000:00:16.0'
  usb.is_self_powered = true
  usb.version = 1.10000
  usb.bus_number = 6 (0x6)
  usb.can_wake_up = true
  usb.vendor = 'Linux Foundation'
  usb.num_ports = 4 (0x4)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 518 (0x206)

  69: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0'
  info.vendor = 'Linux Foundation'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.0/usb6'
  usb_device.configuration_value = 1 (0x1)
  info.product = '1.1 root hub'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_class = 9 (0x9)
  usb_device.device_subclass = 0 (0x0)
  usb_device.device_protocol = 0 (0x0)
  usb_device.vendor_id = 7531 (0x1d6b)
  usb_device.product_id = 1 (0x1)
  usb_device.max_power = 0 (0x0)
  usb_device.product = '1.1 root hub'
  usb_device.linux.device_number = 1 (0x1)
  usb_device.serial = '0000:00:16.0'
  usb_device.speed = 12.0000
  usb_device.version = 1.10000
  usb_device.is_self_powered = true
  usb_device.can_wake_up = true
  usb_device.bus_number = 6 (0x6)
  linux.device_file = '/dev/bus/usb/006/001'
  usb_device.num_ports = 4 (0x4)
  usb_device.vendor = 'Linux Foundation'
  usb_device.device_revision_bcd = 518 (0x206)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.0/usb6'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4397_1'

  70: udi = '/org/freedesktop/Hal/devices/pci_1002_4397_1'
  pci.product = 'SB700/SB800 USB OHCI0 Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ohci_hcd'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4397_1'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 USB OHCI0 Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:16.0'
  pci.product_id = 17303 (0x4397)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 16 (0x10)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  71: udi = '/org/freedesktop/Hal/devices/pci_1002_4384'
  pci.product = 'SBx00 PCI to PCI Bridge'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4384'
  info.subsystem = 'pci'
  info.product = 'SBx00 PCI to PCI Bridge'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.4'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.4'
  pci.product_id = 17284 (0x4384)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 4 (0x4)
  pci.device_protocol = 1 (0x1)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  72: udi = '/org/freedesktop/Hal/devices/pci_1002_439d'
  pci.product = 'SB700/SB800 LPC host controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_439d'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 LPC host controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.3'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.3'
  pci.product_id = 17309 (0x439d)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 1 (0x1)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  73: udi = '/org/freedesktop/Hal/devices/pci_1002_4383'
  pci.product = 'SBx00 Azalia (Intel HDA)'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'HDA Intel'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4383'
  info.subsystem = 'pci'
  info.product = 'SBx00 Azalia (Intel HDA)'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.2'
  pci.product_id = 17283 (0x4383)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 4 (0x4)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  74: udi = '/org/freedesktop/Hal/devices/pci_1002_439c'
  pci.product = 'SB700/SB800 IDE Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'pata_atiixp'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_439c'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 IDE Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.1'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.1'
  pci.product_id = 17308 (0x439c)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 1 (0x1)
  pci.device_subclass = 1 (0x1)
  pci.device_protocol = 138 (0x8a)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  75: udi = '/org/freedesktop/Hal/devices/pci_1002_4385'
  pci.product = 'SBx00 SMBus Controller'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4385'
  info.subsystem = 'pci'
  info.product = 'SBx00 SMBus Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:14.0'
  pci.product_id = 17285 (0x4385)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 0 (0x0)
  pci.subsys_vendor_id = 0 (0x0)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 5 (0x5)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  76: udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if1'
  usb.interface.class = 14 (0xe)
  usb.interface.subclass = 2 (0x2)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  usb.interface.description = '1.3M WebCam'
  info.linux.driver = 'uvcvideo'
  linux.subsystem = 'usb'
  info.subsystem = 'usb'
  info.product = 'USB Video Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if1'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 2 (0x2)
  usb.device_class = 239 (0xef)
  usb.device_subclass = 2 (0x2)
  usb.device_protocol = 1 (0x1)
  usb.vendor_id = 1614 (0x64e)
  usb.product_id = 41497 (0xa219)
  usb.max_power = 500 (0x1f4)
  usb.product = 'USB Video Interface'
  usb.linux.device_number = 3 (0x3)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05'
  usb.speed = 480.000
  usb.serial = 'HF1315-S32B-OV01-VA-R02.01.05'
  usb.is_self_powered = false
  usb.version = 2.00000
  usb.bus_number = 2 (0x2)
  usb.can_wake_up = false
  usb.vendor = 'Suyin Corp.'
  usb.num_ports = 0 (0x0)
  usb.interface.number = 1 (0x1)
  usb.device_revision_bcd = 533 (0x215)

  77: udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0'
  usb.interface.class = 14 (0xe)
  usb.interface.subclass = 1 (0x1)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  usb.interface.description = '1.3M WebCam'
  info.linux.driver = 'uvcvideo'
  linux.subsystem = 'usb'
  info.subsystem = 'usb'
  info.product = 'USB Video Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 2 (0x2)
  usb.device_class = 239 (0xef)
  usb.device_subclass = 2 (0x2)
  usb.device_protocol = 1 (0x1)
  usb.vendor_id = 1614 (0x64e)
  usb.product_id = 41497 (0xa219)
  usb.max_power = 500 (0x1f4)
  usb.product = 'USB Video Interface'
  usb.linux.device_number = 3 (0x3)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05'
  usb.speed = 480.000
  usb.serial = 'HF1315-S32B-OV01-VA-R02.01.05'
  usb.is_self_powered = false
  usb.version = 2.00000
  usb.bus_number = 2 (0x2)
  usb.can_wake_up = false
  usb.vendor = 'Suyin Corp.'
  usb.num_ports = 0 (0x0)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 533 (0x215)

  78: udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05'
  info.vendor = 'Suyin Corp.'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5'
  usb_device.configuration_value = 1 (0x1)
  info.product = '1.3M WebCam'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 2 (0x2)
  usb_device.device_class = 239 (0xef)
  usb_device.device_subclass = 2 (0x2)
  usb_device.device_protocol = 1 (0x1)
  usb_device.vendor_id = 1614 (0x64e)
  usb_device.product_id = 41497 (0xa219)
  usb_device.max_power = 500 (0x1f4)
  usb_device.product = '1.3M WebCam'
  usb_device.linux.device_number = 3 (0x3)
  usb_device.serial = 'HF1315-S32B-OV01-VA-R02.01.05'
  usb_device.speed = 480.000
  usb_device.version = 2.00000
  usb_device.is_self_powered = false
  usb_device.can_wake_up = false
  usb_device.bus_number = 2 (0x2)
  linux.device_file = '/dev/bus/usb/002/003'
  usb_device.num_ports = 0 (0x0)
  usb_device.vendor = 'Suyin Corp.'
  usb_device.device_revision_bcd = 533 (0x215)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-5'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2'

  79: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2_if0'
  usb.interface.class = 9 (0x9)
  usb.interface.subclass = 0 (0x0)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'hub'
  info.subsystem = 'usb'
  info.product = 'USB Hub Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 9 (0x9)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 7531 (0x1d6b)
  usb.product_id = 2 (0x2)
  usb.max_power = 0 (0x0)
  usb.product = 'USB Hub Interface'
  usb.linux.device_number = 1 (0x1)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2'
  usb.speed = 480.000
  usb.serial = '0000:00:13.2'
  usb.is_self_powered = true
  usb.version = 2.00000
  usb.bus_number = 2 (0x2)
  usb.can_wake_up = true
  usb.vendor = 'Linux Foundation'
  usb.num_ports = 5 (0x5)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 518 (0x206)

  80: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2'
  info.vendor = 'Linux Foundation'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2'
  usb_device.configuration_value = 1 (0x1)
  info.product = '2.0 root hub'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_class = 9 (0x9)
  usb_device.device_subclass = 0 (0x0)
  usb_device.device_protocol = 0 (0x0)
  usb_device.vendor_id = 7531 (0x1d6b)
  usb_device.product_id = 2 (0x2)
  usb_device.max_power = 0 (0x0)
  usb_device.product = '2.0 root hub'
  usb_device.linux.device_number = 1 (0x1)
  usb_device.serial = '0000:00:13.2'
  usb_device.speed = 480.000
  usb_device.version = 2.00000
  usb_device.is_self_powered = true
  usb_device.can_wake_up = true
  usb_device.bus_number = 2 (0x2)
  linux.device_file = '/dev/bus/usb/002/001'
  usb_device.num_ports = 5 (0x5)
  usb_device.vendor = 'Linux Foundation'
  usb_device.device_revision_bcd = 518 (0x206)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2/usb2'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4396_0'

  81: udi = '/org/freedesktop/Hal/devices/pci_1002_4396_0'
  pci.product = 'SB700/SB800 USB EHCI Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ehci_hcd'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4396_0'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 USB EHCI Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.2'
  pci.product_id = 17302 (0x4396)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 32 (0x20)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  82: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0_if0'
  usb.interface.class = 9 (0x9)
  usb.interface.subclass = 0 (0x0)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'hub'
  info.subsystem = 'usb'
  info.product = 'USB Hub Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 9 (0x9)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 7531 (0x1d6b)
  usb.product_id = 1 (0x1)
  usb.max_power = 0 (0x0)
  usb.product = 'USB Hub Interface'
  usb.linux.device_number = 1 (0x1)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0'
  usb.speed = 12.0000
  usb.serial = '0000:00:13.0'
  usb.is_self_powered = true
  usb.version = 1.10000
  usb.bus_number = 5 (0x5)
  usb.can_wake_up = true
  usb.vendor = 'Linux Foundation'
  usb.num_ports = 5 (0x5)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 518 (0x206)

  83: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0'
  info.vendor = 'Linux Foundation'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.0/usb5'
  usb_device.configuration_value = 1 (0x1)
  info.product = '1.1 root hub'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_class = 9 (0x9)
  usb_device.device_subclass = 0 (0x0)
  usb_device.device_protocol = 0 (0x0)
  usb_device.vendor_id = 7531 (0x1d6b)
  usb_device.product_id = 1 (0x1)
  usb_device.max_power = 0 (0x0)
  usb_device.product = '1.1 root hub'
  usb_device.linux.device_number = 1 (0x1)
  usb_device.serial = '0000:00:13.0'
  usb_device.speed = 12.0000
  usb_device.version = 1.10000
  usb_device.is_self_powered = true
  usb_device.can_wake_up = true
  usb_device.bus_number = 5 (0x5)
  linux.device_file = '/dev/bus/usb/005/001'
  usb_device.num_ports = 5 (0x5)
  usb_device.vendor = 'Linux Foundation'
  usb_device.device_revision_bcd = 518 (0x206)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.0/usb5'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4397_0'

  84: udi = '/org/freedesktop/Hal/devices/pci_1002_4397_0'
  pci.product = 'SB700/SB800 USB OHCI0 Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ohci_hcd'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4397_0'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 USB OHCI0 Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:13.0'
  pci.product_id = 17303 (0x4397)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 16 (0x10)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  85: udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_device_lun0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi'
  info.linux.driver = 'sd'
  scsi.host = 3 (0x3)
  scsi.bus = 0 (0x0)
  scsi.target = 0 (0x0)
  scsi.lun = 0 (0x0)
  scsi.model = 'Multi-Card'
  scsi.vendor = 'Generic-'
  scsi.type = 'disk'
  info.subsystem = 'scsi'
  info.product = 'SCSI Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host_scsi_device_lun0'

  86: udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_host'
  scsi_host.host = 3 (0x3)
  info.category = 'scsi_host'
  info.capabilities = { 'scsi_host' }
  info.subsystem = 'scsi_host'
  info.product = 'SCSI Host Adapter'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0_scsi_host'

  87: udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0'
  usb.interface.class = 8 (0x8)
  usb.interface.subclass = 6 (0x6)
  usb.interface.protocol = 80 (0x50)
  usb.configuration = 'CARD READER'
  usb.interface.description = 'Bulk-In, Bulk-Out, Interface'
  info.linux.driver = 'usb-storage'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.subsystem = 'usb'
  info.product = 'USB Mass Storage Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 0 (0x0)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 3034 (0xbda)
  usb.product_id = 312 (0x138)
  usb.max_power = 500 (0x1f4)
  usb.product = 'USB Mass Storage Interface'
  usb.linux.device_number = 2 (0x2)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000'
  usb.speed = 480.000
  usb.serial = '20090516388200000'
  usb.can_wake_up = true
  usb.version = 2.00000
  usb.num_ports = 0 (0x0)
  usb.vendor = 'Realtek Semiconductor Corp.'
  usb.bus_number = 1 (0x1)
  usb.is_self_powered = false
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 14466 (0x3882)

  88: udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000'
  info.vendor = 'Realtek Semiconductor Corp.'
  usb_device.configuration = 'CARD READER'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5'
  usb_device.configuration_value = 1 (0x1)
  info.product = 'USB2.0-CRW'
  usb_device.num_configurations = 1 (0x1)
  info.subsystem = 'usb_device'
  usb_device.device_class = 0 (0x0)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_protocol = 0 (0x0)
  usb_device.device_subclass = 0 (0x0)
  usb_device.product_id = 312 (0x138)
  usb_device.vendor_id = 3034 (0xbda)
  usb_device.product = 'USB2.0-CRW'
  usb_device.max_power = 500 (0x1f4)
  usb_device.num_ports = 0 (0x0)
  usb_device.linux.device_number = 2 (0x2)
  usb_device.serial = '20090516388200000'
  usb_device.speed = 480.000
  usb_device.version = 2.00000
  usb_device.is_self_powered = false
  usb_device.can_wake_up = true
  usb_device.bus_number = 1 (0x1)
  linux.device_file = '/dev/bus/usb/001/002'
  usb_device.vendor = 'Realtek Semiconductor Corp.'
  usb_device.device_revision_bcd = 14466 (0x3882)
  info.udi = '/org/freedesktop/Hal/devices/usb_device_bda_138_20090516388200000'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-5'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2'

  89: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2_if0'
  usb.interface.class = 9 (0x9)
  usb.interface.subclass = 0 (0x0)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'hub'
  info.subsystem = 'usb'
  info.product = 'USB Hub Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 9 (0x9)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 7531 (0x1d6b)
  usb.product_id = 2 (0x2)
  usb.max_power = 0 (0x0)
  usb.product = 'USB Hub Interface'
  usb.linux.device_number = 1 (0x1)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2'
  usb.speed = 480.000
  usb.serial = '0000:00:12.2'
  usb.is_self_powered = true
  usb.version = 2.00000
  usb.bus_number = 1 (0x1)
  usb.can_wake_up = true
  usb.vendor = 'Linux Foundation'
  usb.num_ports = 5 (0x5)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 518 (0x206)

  90: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2'
  info.vendor = 'Linux Foundation'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1'
  usb_device.configuration_value = 1 (0x1)
  info.product = '2.0 root hub'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_class = 9 (0x9)
  usb_device.device_subclass = 0 (0x0)
  usb_device.device_protocol = 0 (0x0)
  usb_device.vendor_id = 7531 (0x1d6b)
  usb_device.product_id = 2 (0x2)
  usb_device.max_power = 0 (0x0)
  usb_device.product = '2.0 root hub'
  usb_device.linux.device_number = 1 (0x1)
  usb_device.serial = '0000:00:12.2'
  usb_device.speed = 480.000
  usb_device.version = 2.00000
  usb_device.is_self_powered = true
  usb_device.can_wake_up = true
  usb_device.bus_number = 1 (0x1)
  linux.device_file = '/dev/bus/usb/001/001'
  usb_device.num_ports = 5 (0x5)
  usb_device.vendor = 'Linux Foundation'
  usb_device.device_revision_bcd = 518 (0x206)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2/usb1'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4396'

  91: udi = '/org/freedesktop/Hal/devices/pci_1002_4396'
  pci.product = 'SB700/SB800 USB EHCI Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ehci_hcd'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4396'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 USB EHCI Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.2'
  pci.product_id = 17302 (0x4396)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 32 (0x20)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  92: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0_if0'
  usb.interface.class = 9 (0x9)
  usb.interface.subclass = 0 (0x0)
  usb.interface.protocol = 0 (0x0)
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'hub'
  info.subsystem = 'usb'
  info.product = 'USB Hub Interface'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0_if0'
  usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0'
  usb.configuration_value = 1 (0x1)
  usb.num_configurations = 1 (0x1)
  usb.num_interfaces = 1 (0x1)
  usb.device_class = 9 (0x9)
  usb.device_subclass = 0 (0x0)
  usb.device_protocol = 0 (0x0)
  usb.vendor_id = 7531 (0x1d6b)
  usb.product_id = 1 (0x1)
  usb.max_power = 0 (0x0)
  usb.product = 'USB Hub Interface'
  usb.linux.device_number = 1 (0x1)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0'
  info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0'
  usb.speed = 12.0000
  usb.serial = '0000:00:12.0'
  usb.is_self_powered = true
  usb.version = 1.10000
  usb.bus_number = 4 (0x4)
  usb.can_wake_up = true
  usb.vendor = 'Linux Foundation'
  usb.num_ports = 5 (0x5)
  usb.interface.number = 0 (0x0)
  usb.device_revision_bcd = 518 (0x206)

  93: udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0'
  info.vendor = 'Linux Foundation'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.0/usb4'
  usb_device.configuration_value = 1 (0x1)
  info.product = '1.1 root hub'
  info.udi = '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0'
  info.subsystem = 'usb_device'
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.device_class = 9 (0x9)
  usb_device.device_subclass = 0 (0x0)
  usb_device.device_protocol = 0 (0x0)
  usb_device.vendor_id = 7531 (0x1d6b)
  usb_device.product_id = 1 (0x1)
  usb_device.max_power = 0 (0x0)
  usb_device.product = '1.1 root hub'
  usb_device.linux.device_number = 1 (0x1)
  usb_device.serial = '0000:00:12.0'
  usb_device.speed = 12.0000
  usb_device.version = 1.10000
  usb_device.is_self_powered = true
  usb_device.can_wake_up = true
  usb_device.bus_number = 4 (0x4)
  linux.device_file = '/dev/bus/usb/004/001'
  usb_device.num_ports = 5 (0x5)
  usb_device.vendor = 'Linux Foundation'
  usb_device.device_revision_bcd = 518 (0x206)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.0/usb4'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4397'

  94: udi = '/org/freedesktop/Hal/devices/pci_1002_4397'
  pci.product = 'SB700/SB800 USB OHCI0 Controller'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ohci_hcd'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4397'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 USB OHCI0 Controller'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:12.0'
  pci.product_id = 17303 (0x4397)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 12 (0xc)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 16 (0x10)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  95: udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_device_lun0'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi'
  info.linux.driver = 'sd'
  scsi.host = 2 (0x2)
  scsi.bus = 0 (0x0)
  scsi.target = 0 (0x0)
  scsi.lun = 0 (0x0)
  scsi.model = 'WDC WD2500BEVT-2'
  scsi.vendor = 'ATA'
  scsi.type = 'disk'
  info.subsystem = 'scsi'
  info.product = 'SCSI Device'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host_scsi_device_lun0'

  96: udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'scsi_host'
  scsi_host.host = 2 (0x2)
  info.category = 'scsi_host'
  info.capabilities = { 'scsi_host' }
  info.subsystem = 'scsi_host'
  info.product = 'SCSI Host Adapter'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0/host2'
  info.parent = '/org/freedesktop/Hal/devices/pci_1002_4391'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4391_scsi_host'

  97: udi = '/org/freedesktop/Hal/devices/pci_1002_4391'
  pci.product = 'SB700/SB800 SATA Controller [AHCI mode]'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'ahci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_4391'
  info.subsystem = 'pci'
  info.product = 'SB700/SB800 SATA Controller [AHCI mode]'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:11.0'
  pci.product_id = 17297 (0x4391)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 1 (0x1)
  pci.device_subclass = 6 (0x6)
  pci.device_protocol = 1 (0x1)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  98: udi = '/org/freedesktop/Hal/devices/pci_14e4_4357'
  pci.product = 'BCM43225 802.11b/g/n'
  pci.subsys_vendor = 'Foxconn International, Inc.'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'brcm80211'
  info.udi = '/org/freedesktop/Hal/devices/pci_14e4_4357'
  info.subsystem = 'pci'
  info.product = 'BCM43225 802.11b/g/n'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:05.0/0000:06:00.0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1022_9605'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:05.0/0000:06:00.0'
  pci.product_id = 17239 (0x4357)
  pci.vendor_id = 5348 (0x14e4)
  pci.subsys_product_id = 57377 (0xe021)
  pci.subsys_vendor_id = 4187 (0x105b)
  pci.device_class = 2 (0x2)
  pci.device_subclass = 128 (0x80)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Broadcom Corporation'
  info.vendor = 'Broadcom Corporation'

  99: udi = '/org/freedesktop/Hal/devices/pci_1022_9605'
  pci.product = 'RS780 PCI to PCI bridge (PCIE port 1)'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'pcieport'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_9605'
  info.subsystem = 'pci'
  info.product = 'RS780 PCI to PCI bridge (PCIE port 1)'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:05.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:05.0'
  pci.product_id = 38405 (0x9605)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 4 (0x4)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  100: udi = '/org/freedesktop/Hal/devices/pci_1969_1073'
  pci.product = 'AR8151 v1.0 Gigabit Ethernet'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'atl1c'
  info.udi = '/org/freedesktop/Hal/devices/pci_1969_1073'
  info.subsystem = 'pci'
  info.product = 'AR8151 v1.0 Gigabit Ethernet'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1022_9604'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0'
  pci.product_id = 4211 (0x1073)
  pci.vendor_id = 6505 (0x1969)
  pci.subsys_product_id = 1037 (0x40d)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 2 (0x2)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Atheros Communications'
  info.vendor = 'Atheros Communications'

  101: udi = '/org/freedesktop/Hal/devices/pci_1022_9604'
  pci.product = 'RS780 PCI to PCI bridge (PCIE port 0)'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'pcieport'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_9604'
  info.subsystem = 'pci'
  info.product = 'RS780 PCI to PCI bridge (PCIE port 0)'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:04.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:04.0'
  pci.product_id = 38404 (0x9604)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 4 (0x4)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'

  102: udi = '/org/freedesktop/Hal/devices/pci_1002_970f'
  pci.product = 'RS880 Audio Device [Radeon HD 4200]'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'HDA Intel'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_970f'
  info.subsystem = 'pci'
  info.product = 'RS880 Audio Device [Radeon HD 4200]'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.1'
  info.parent = '/org/freedesktop/Hal/devices/pci_1025_9602'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.1'
  pci.product_id = 38671 (0x970f)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 4 (0x4)
  pci.device_subclass = 3 (0x3)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  103: udi = '/org/freedesktop/Hal/devices/pci_1002_9712'
  pci.product = 'M880G [Mobility Radeon HD 4200]'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.linux.driver = 'fglrx_pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1002_9712'
  info.subsystem = 'pci'
  info.product = 'M880G [Mobility Radeon HD 4200]'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0'
  info.parent = '/org/freedesktop/Hal/devices/pci_1025_9602'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0'
  pci.product_id = 38674 (0x9712)
  pci.vendor_id = 4098 (0x1002)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 3 (0x3)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'ATI Technologies Inc'
  info.vendor = 'ATI Technologies Inc'

  104: udi = '/org/freedesktop/Hal/devices/pci_1025_9602'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1025_9602'
  info.subsystem = 'pci'
  info.product = 'Unknown (0x9602)'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0'
  pci.product_id = 38402 (0x9602)
  pci.vendor_id = 4133 (0x1025)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 4 (0x4)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Acer Incorporated [ALI]'
  info.vendor = 'Acer Incorporated [ALI]'

  105: udi = '/org/freedesktop/Hal/devices/pci_1022_9601'
  pci.product = 'RS780 Host Bridge Alternate'
  pci.subsys_vendor = 'Acer Incorporated [ALI]'
  linux.hotplug_type = 2 (0x2)
  linux.subsystem = 'pci'
  info.udi = '/org/freedesktop/Hal/devices/pci_1022_9601'
  info.subsystem = 'pci'
  info.product = 'RS780 Host Bridge Alternate'
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:00.0'
  info.parent = '/org/freedesktop/Hal/devices/computer'
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:00.0'
  pci.product_id = 38401 (0x9601)
  pci.vendor_id = 4130 (0x1022)
  pci.subsys_product_id = 1065 (0x429)
  pci.subsys_vendor_id = 4133 (0x1025)
  pci.device_class = 6 (0x6)
  pci.device_subclass = 0 (0x0)
  pci.device_protocol = 0 (0x0)
  pci.vendor = 'Advanced Micro Devices [AMD]'
  info.vendor = 'Advanced Micro Devices [AMD]'
----- hal device list end -----
>> floppy.1: get nvram
>> floppy.2: klog info
>> bios.1: cmdline
>> bios.1.1: apm
>> bios.2: ram
/dev/mem[0x400, 256]: mmap(, 4096,,,, 0x0) ok
/dev/mem[0xc0000, 262144]: mmap(, 262144,,,, 0xc0000) ok
  bios: 1 disks
  bios: 631k low mem
/dev/mem[0x9dc00, 1]: mmap(, 4096,,,, 0x9d000) ok
/dev/mem[0x9dc00, 2048]: mmap(, 8192,,,, 0x9d000) ok
  bios: EBDA 0x00800 bytes at 0x9dc00
>> bios.2: rom
----- SMBIOS Entry Point 0xf7f20 - 0xf7f3e -----
  f7f20  5f 53 4d 5f da 1f 02 06 a1 00 00 00 00 00 00 00  "_SM_............"
  f7f30  5f 44 4d 49 5f e4 bc 04 00 50 ec 6f 19 00 00  "_DMI_....P.o..."
----- SMBIOS Entry Point end -----
/dev/mem[0x6fec5000, 1212]: mmap(, 4096,,,, 0x6fec5000) ok
----- SMBIOS Structure Table 0x6fec5000 - 0x6fec54bb -----
  6fec5000  00 18 00 00 01 02 65 e2 03 1f 80 da cb 7d 00 00  "......e......}.."
  6fec5010  00 00 33 05 ff ff ff ff 50 68 6f 65 6e 69 78 20  "..3.....Phoenix "
  6fec5020  54 65 63 68 6e 6f 6c 6f 67 69 65 73 20 4c 54 44  "Technologies LTD"
  6fec5030  00 56 31 2e 31 31 20 20 20 20 20 20 20 20 20 20  ".V1.11          "
  6fec5040  00 30 35 2f 31 34 2f 32 30 31 30 00 00 01 1b 01  ".05/14/2010....."
  6fec5050  00 01 02 03 04 6b 58 2d 00 8e c2 11 df bd df bc  ".....kX-........"
  6fec5060  58 69 af 06 51 06 00 00 41 63 65 72 20 20 20 20  "Xi..Q...Acer    "
  6fec5070  20 20 20 20 20 20 20 00 41 73 70 69 72 65 20 31  "       .Aspire 1"
  6fec5080  35 35 31 20 20 20 20 20 20 20 20 20 20 20 20 20  "551             "
  6fec5090  20 20 20 20 20 20 20 00 56 31 2e 31 31 20 20 20  "       .V1.11   "
  6fec50a0  20 20 20 20 20 20 20 00 4c 58 53 42 42 30 32 30  "       .LXSBB020"
  6fec50b0  37 35 30 32 38 30 30 36 43 32 32 30 30 30 20 20  "75028006C22000  "
  6fec50c0  20 20 20 20 20 20 00 00 02 11 02 00 01 02 03 04  "      .........."
  6fec50d0  05 09 06 03 00 0a 01 00 00 41 63 65 72 20 20 20  ".........Acer   "
  6fec50e0  20 20 20 20 20 20 20 20 00 41 73 70 69 72 65 20  "        .Aspire "
  6fec50f0  31 35 35 31 20 20 20 20 20 20 20 20 20 20 20 20  "1551            "
  6fec5100  20 20 20 20 20 20 20 20 00 56 31 2e 31 31 20 20  "        .V1.11  "
  6fec5110  20 20 20 20 20 20 20 20 00 4c 58 53 42 42 30 32  "        .LXSBB02"
  6fec5120  30 37 35 30 32 38 30 30 36 43 32 32 30 30 30 20  "075028006C22000 "
  6fec5130  20 20 20 20 20 20 20 00 4e 6f 20 41 73 73 65 74  "       .No Asset"
  6fec5140  20 54 61 67 20 20 20 20 20 20 20 20 20 20 20 20  " Tag            "
  6fec5150  20 20 20 20 20 20 20 20 00 4e 6f 74 20 41 70 70  "        .Not App"
  6fec5160  6c 69 63 61 62 6c 65 00 00 03 15 03 00 01 0a 02  "licable........."
  6fec5170  03 04 03 03 03 03 34 12 00 00 00 00 00 00 41 63  "......4.......Ac"
  6fec5180  65 72 20 20 20 20 20 20 20 20 20 20 20 00 56 31  "er           .V1"
  6fec5190  2e 31 31 20 20 20 20 20 20 20 20 20 20 00 4c 58  ".11          .LX"
  6fec51a0  53 42 42 30 32 30 37 35 30 32 38 30 30 36 43 32  "SBB02075028006C2"
  6fec51b0  32 30 30 30 20 20 20 20 20 20 20 20 00 4e 6f 20  "2000        .No "
  6fec51c0  41 73 73 65 74 20 54 61 67 20 20 20 20 20 20 20  "Asset Tag       "
  6fec51d0  20 20 20 20 20 20 20 20 20 20 20 20 20 00 00 04  "             ..."
  6fec51e0  2a 04 00 01 03 3a 02 63 0f 10 00 ff fb 8b 17 03  "*....:.c........"
  6fec51f0  8a c8 00 14 05 14 05 41 06 05 00 06 00 ff ff 00  ".......A........"
  6fec5200  00 00 02 02 02 04 00 3a 00 53 6f 63 6b 65 74 20  ".......:.Socket "
  6fec5210  41 53 42 32 00 41 4d 44 00 4e 65 77 20 50 72 6f  "ASB2.AMD.New Pro"
  6fec5220  63 65 73 73 6f 72 20 54 65 63 68 6e 6f 6c 6f 67  "cessor Technolog"
  6fec5230  79 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20  "y               "
  6fec5240  20 20 20 20 20 20 20 20 20 00 00 07 13 05 00 01  "         ......."
  6fec5250  80 01 00 01 00 01 10 00 10 00 01 06 05 04 4c 31  "..............L1"
  6fec5260  20 43 61 63 68 65 00 00 07 13 06 00 01 81 01 00  " Cache.........."
  6fec5270  08 00 08 10 00 10 00 01 06 05 08 4c 32 20 43 61  "...........L2 Ca"
  6fec5280  63 68 65 00 00 09 11 07 00 01 06 05 03 01 01 00  "che............."
  6fec5290  06 01 00 00 44 08 4d 49 4e 49 20 50 43 49 31 00  "....D.MINI PCI1."
  6fec52a0  00 09 11 08 00 01 06 05 03 01 02 00 06 01 00 00  "................"
  6fec52b0  44 10 4d 49 4e 49 20 50 43 49 32 00 00 0a 06 09  "D.MINI PCI2....."
  6fec52c0  00 03 01 41 4d 44 20 52 53 38 38 30 4d 00 00 0a  "...AMD RS880M..."
  6fec52d0  06 0a 00 07 01 45 53 53 20 31 38 36 39 00 00 0b  ".....ESS 1869..."
  6fec52e0  05 0b 00 03 20 00 20 00 20 00 00 0c 05 0c 00 01  ".... . . ......."
  6fec52f0  4a 31 33 20 31 2d 32 20 4e 6f 72 6d 61 6c 20 4f  "J13 1-2 Normal O"
  6fec5300  70 65 72 61 74 69 6f 6e 2c 20 32 2d 33 20 43 6c  "peration, 2-3 Cl"
  6fec5310  65 61 72 20 43 4d 4f 53 00 00 10 0f 0d 00 03 03  "ear CMOS........"
  6fec5320  05 00 00 00 02 fe ff 04 00 00 00 11 1c 0e 00 0d  "................"
  6fec5330  00 fe ff 00 00 00 00 00 00 09 01 01 02 15 80 00  "................"
  6fec5340  00 00 03 04 05 06 00 53 31 00 44 49 4d 4d 31 00  ".......S1.DIMM1."
  6fec5350  20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20  "                "
  6fec5360  00 20 20 20 20 20 20 20 20 00 20 20 20 20 00 20  ".        .    . "
  6fec5370  20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20  "                "
  6fec5380  20 00 00 11 1c 0f 00 0d 00 fe ff 40 00 40 00 00  " ..........@.@.."
  6fec5390  08 09 02 01 02 18 80 00 9b 02 03 04 05 06 00 53  "...............S"
  6fec53a0  32 00 44 49 4d 4d 32 00 38 30 43 45 20 20 20 20  "2.DIMM2.80CE    "
  6fec53b0  20 20 20 20 20 20 20 20 00 36 35 46 44 35 42 43  "        .65FD5BC"
  6fec53c0  37 00 31 30 32 31 00 4d 34 37 31 42 35 36 37 33  "7.1021.M471B5673"
  6fec53d0  46 48 30 2d 43 48 39 20 20 00 00 13 0f 10 00 00  "FH0-CH9  ......."
  6fec53e0  00 00 00 ff ff 1f 00 0d 00 02 00 00 14 13 11 00  "................"
  6fec53f0  00 00 00 00 00 00 00 00 0e 00 10 00 02 01 06 00  "................"
  6fec5400  00 14 13 12 00 00 00 00 00 ff ff 1f 00 0f 00 10  "................"
  6fec5410  00 02 01 06 00 00 20 14 13 00 00 00 00 00 00 00  "...... ........."
  6fec5420  0c 01 02 03 04 05 06 07 08 09 00 00 aa 46 14 00  ".............F.."
  6fec5430  01 00 00 00 7f 00 0f 00 06 00 04 02 01 00 41 02  "..............A."
  6fec5440  01 00 42 02 02 00 43 02 04 00 44 02 08 00 45 02  "..B...C...D...E."
  6fec5450  10 00 46 02 20 00 47 02 40 00 61 02 01 00 62 02  "..F. .G.@.a...b."
  6fec5460  02 00 63 02 04 00 64 02 08 00 82 02 02 00 83 02  "..c...d........."
  6fec5470  04 00 00 00 ab 18 15 00 01 02 10 12 97 02 69 19  "..............i."
  6fec5480  73 10 05 02 10 83 43 07 e4 14 57 43 00 00 ac 06  "s.....C...WC...."
  6fec5490  16 00 01 00 00 00 c8 07 17 00 01 02 03 31 37 43  ".............17C"
  6fec54a0  30 00 20 20 20 20 20 20 20 20 20 20 20 20 20 00  "0.             ."
  6fec54b0  30 30 30 31 00 00 7f 04 18 00 00 00  "0001........"
----- SMBIOS Structure Table end -----
  type 0x00 [0x0000]: 00 18 00 00 01 02 65 e2 03 1f 80 da cb 7d 00 00 00 00 33 05 ff ff ff ff
       str1: "Phoenix Technologies LTD"
       str2: "V1.11"
       str3: "05/14/2010"
  type 0x01 [0x0001]: 01 1b 01 00 01 02 03 04 6b 58 2d 00 8e c2 11 df bd df bc 58 69 af 06 51 06 00 00
       str1: "Acer"
       str2: "Aspire 1551"
       str3: "V1.11"
       str4: "LXSBB02075028006C22000"
  type 0x02 [0x0002]: 02 11 02 00 01 02 03 04 05 09 06 03 00 0a 01 00 00
       str1: "Acer"
       str2: "Aspire 1551"
       str3: "V1.11"
       str4: "LXSBB02075028006C22000"
       str5: "No Asset Tag"
       str6: "Not Applicable"
  type 0x03 [0x0003]: 03 15 03 00 01 0a 02 03 04 03 03 03 03 34 12 00 00 00 00 00 00
       str1: "Acer"
       str2: "V1.11"
       str3: "LXSBB02075028006C22000"
       str4: "No Asset Tag"
  type 0x04 [0x0004]: 04 2a 04 00 01 03 3a 02 63 0f 10 00 ff fb 8b 17 03 8a c8 00 14 05 14 05 41 06 05 00 06 00 ff ff 00 00 00 02 02 02 04 00 3a 00
       str1: "Socket ASB2"
       str2: "AMD"
       str3: "New Processor Technology"
  type 0x07 [0x0005]: 07 13 05 00 01 80 01 00 01 00 01 10 00 10 00 01 06 05 04
       str1: "L1 Cache"
  type 0x07 [0x0006]: 07 13 06 00 01 81 01 00 08 00 08 10 00 10 00 01 06 05 08
       str1: "L2 Cache"
  type 0x09 [0x0007]: 09 11 07 00 01 06 05 03 01 01 00 06 01 00 00 44 08
       str1: "MINI PCI1"
  type 0x09 [0x0008]: 09 11 08 00 01 06 05 03 01 02 00 06 01 00 00 44 10
       str1: "MINI PCI2"
  type 0x0a [0x0009]: 0a 06 09 00 03 01
       str1: "AMD RS880M"
  type 0x0a [0x000a]: 0a 06 0a 00 07 01
       str1: "ESS 1869"
  type 0x0b [0x000b]: 0b 05 0b 00 03
  type 0x0c [0x000c]: 0c 05 0c 00 01
       str1: "J13 1-2 Normal Operation, 2-3 Clear CMOS"
  type 0x10 [0x000d]: 10 0f 0d 00 03 03 05 00 00 00 02 fe ff 04 00
  type 0x11 [0x000e]: 11 1c 0e 00 0d 00 fe ff 00 00 00 00 00 00 09 01 01 02 15 80 00 00 00 03 04 05 06 00
       str1: "S1"
       str2: "DIMM1"
  type 0x11 [0x000f]: 11 1c 0f 00 0d 00 fe ff 40 00 40 00 00 08 09 02 01 02 18 80 00 9b 02 03 04 05 06 00
       str1: "S2"
       str2: "DIMM2"
       str3: "80CE"
       str4: "65FD5BC7"
       str5: "1021"
       str6: "M471B5673FH0-CH9"
  type 0x13 [0x0010]: 13 0f 10 00 00 00 00 00 ff ff 1f 00 0d 00 02
  type 0x14 [0x0011]: 14 13 11 00 00 00 00 00 00 00 00 00 0e 00 10 00 02 01 06
  type 0x14 [0x0012]: 14 13 12 00 00 00 00 00 ff ff 1f 00 0f 00 10 00 02 01 06
  type 0x20 [0x0013]: 20 14 13 00 00 00 00 00 00 00 0c 01 02 03 04 05 06 07 08 09
  type 0xaa [0x0014]: aa 46 14 00 01 00 00 00 7f 00 0f 00 06 00 04 02 01 00 41 02 01 00 42 02 02 00 43 02 04 00 44 02 08 00 45 02 10 00 46 02 20 00 47 02 40 00 61 02 01 00 62 02 02 00 63 02 04 00 64 02 08 00 82 02 02 00 83 02 04 00
  type 0xab [0x0015]: ab 18 15 00 01 02 10 12 97 02 69 19 73 10 05 02 10 83 43 07 e4 14 57 43
  type 0xac [0x0016]: ac 06 16 00 01 00
  type 0xc8 [0x0017]: c8 07 17 00 01 02 03
       str1: "17C0"
       str3: "0001"
  type 0x7f [0x0018]: 7f 04 18 00
  smbios: stopped at end tag
>> bios.3: smp
  smp: valid MP FP at 0xf8080 (size 0x10, rev 4), MP config at 0x9e071
/dev/mem[0x9e071, 64]: mmap(, 4096,,,, 0x9e000) ok
  MP config table size: 500
/dev/mem[0x9e071, 500]: mmap(, 4096,,,, 0x9e000) ok
  base MP config table (36 entries):
  type 0, len 20
    00 00 10 03 63 0f 10 00 ff fb 8b 17 00 00 00 00 00 00 00 00  "....c..............."
  type 0, len 20
    00 01 10 01 63 0f 10 00 ff fb 8b 17 00 00 00 00 00 00 00 00  "....c..............."
  type 1, len 8
    01 00 50 43 49 20 20 20  "..PCI   "
  type 1, len 8
    01 01 50 43 49 20 20 20  "..PCI   "
  type 1, len 8
    01 03 50 43 49 20 20 20  "..PCI   "
  type 1, len 8
    01 06 50 43 49 20 20 20  "..PCI   "
  type 1, len 8
    01 07 49 53 41 20 20 20  "..ISA   "
  type 2, len 8
    02 02 21 01 00 00 c0 fe  "..!....."
  type 3, len 8
    03 00 05 00 07 00 02 00  "........"
  type 3, len 8
    03 00 05 00 07 01 02 01  "........"
  type 3, len 8
    03 03 05 00 07 00 02 02  "........"
  type 3, len 8
    03 00 05 00 07 03 02 03  "........"
  type 3, len 8
    03 00 05 00 07 04 02 04  "........"
  type 3, len 8
    03 00 0f 00 00 44 02 13  ".....D.."
  type 3, len 8
    03 00 05 00 07 06 02 06  "........"
  type 3, len 8
    03 00 05 00 07 07 02 07  "........"
  type 3, len 8
    03 00 05 00 07 08 02 08  "........"
  type 3, len 8
    03 00 05 00 07 09 02 09  "........"
  type 3, len 8
    03 00 0f 00 00 14 02 11  "........"
  type 3, len 8
    03 00 0f 00 00 10 02 10  "........"
  type 3, len 8
    03 00 05 00 07 0c 02 0c  "........"
  type 3, len 8
    03 00 05 00 07 0d 02 0d  "........"
  type 3, len 8
    03 00 05 00 07 0e 02 0e  "........"
  type 3, len 8
    03 00 05 00 07 0f 02 0f  "........"
  type 3, len 8
    03 00 0f 00 00 48 02 12  ".....H.."
  type 3, len 8
    03 00 0f 00 00 49 02 11  ".....I.."
  type 3, len 8
    03 00 0f 00 00 4c 02 12  ".....L.."
  type 3, len 8
    03 00 0f 00 00 4d 02 11  ".....M.."
  type 3, len 8
    03 00 0f 00 00 51 02 11  ".....Q.."
  type 3, len 8
    03 00 0f 00 00 50 02 10  ".....P.."
  type 3, len 8
    03 00 0f 00 00 58 02 12  ".....X.."
  type 3, len 8
    03 00 0f 00 00 59 02 11  ".....Y.."
  type 3, len 8
    03 00 0f 00 03 00 02 10  "........"
  type 3, len 8
    03 00 0f 00 06 00 02 11  "........"
  type 4, len 8
    04 03 05 00 07 00 ff 00  "........"
  type 4, len 8
    04 01 05 00 07 00 ff 01  "........"
  extended MP config table:
  type 128, len 20
    80 14 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00  "...................."
  type 128, len 20
    80 14 00 01 00 00 00 80 00 00 00 00 00 00 00 40 00 00 00 00  "...............@...."
  type 128, len 20
    80 14 00 02 00 00 00 c0 00 00 00 00 00 00 00 10 00 00 00 00  "...................."
  type 128, len 20
    80 14 00 01 00 00 00 d0 00 00 00 00 00 00 e0 2e 00 00 00 00  "...................."
  type 128, len 20
    80 14 00 01 00 10 e0 fe 00 00 00 00 00 f0 1f 01 00 00 00 00  "...................."
  type 128, len 20
    80 14 00 01 00 00 0a 00 00 00 00 00 00 00 06 00 00 00 00 00  "...................."
  type 129, len 8
    81 08 07 01 00 00 00 00  "........"
  type 130, len 8
    82 08 00 00 00 00 00 00  "........"
  type 130, len 8
    82 08 00 00 01 00 00 00  "........"
----- BIOS data 0x00400 - 0x004ff -----
  400  00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 9d  "................"
  410  26 00 00 77 02 28 00 00 00 00 1e 00 1e 00 00 00  "&..w.(.........."
  420  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  430  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  440  08 00 ff 08 40 93 cc e0 25 03 50 00 00 10 00 00  "....@...%.P....."
  450  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  460  0e 0d 00 d4 03 29 30 00 00 00 00 00 00 00 00 00  ".....)0........."
  470  00 20 00 00 00 01 00 00 14 14 14 00 01 01 01 01  ". .............."
  480  1e 00 3e 00 18 10 00 60 f9 11 0b 01 50 00 00 00  "..>....`....P..."
  490  00 00 00 00 00 00 20 00 00 00 00 00 00 00 00 00  "...... ........."
  4a0  00 00 00 00 00 00 00 00 70 68 00 c0 00 00 00 00  "........ph......"
  4b0  00 00 00 00 00 00 44 89 00 00 00 00 00 00 00 00  "......D........."
  4c0  40 01 00 01 00 00 40 84 32 84 e0 00 05 10 09 04  "@.....@.2......."
  4d0  1f 2a 00 00 10 2b 04 00 00 00 00 00 00 00 00 00  ".*...+.........."
  4e0  00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  4f0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
----- BIOS data end -----
----- EBDA 0x9dc00 - 0x9e3ff -----
  9dc00  02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc20  00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00  "................"
  9dc30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dc90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dca0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dcb0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dcc0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dcd0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dce0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dcf0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dd00  00 00 00 00 ca 02 70 06 00 00 00 00 9b 02 e2 4a  "......p........J"
  9dd10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dd20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dd30  00 00 00 00 40 04 00 00 00 00 00 00 00 00 00 00  "....@..........."
  9dd40  88 00 00 84 00 00 00 84 00 00 00 00 00 00 00 00  "................"
  9dd50  00 10 00 00 00 00 00 00 00 68 00 00 80 00 01 00  ".........h......"
  9dd60  00 80 06 00 00 10 00 80 00 00 00 00 00 00 00 00  "................"
  9dd70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dd80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dd90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dda0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9ddb0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9ddc0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9ddd0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dde0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9ddf0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9de90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dea0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9deb0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dec0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9ded0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dee0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9def0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df00  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df10  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df20  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df30  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df40  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df60  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df70  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9df90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dfa0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dfb0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dfc0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dfd0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dfe0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9dff0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e020  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e030  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e040  00 72 c3 00 00 00 00 00 00 00 00 00 00 00 00 00  ".r.............."
  9e050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e060  02 05 00 01 00 00 01 07 02 a3 01 00 00 00 00 00  "................"
  9e070  00 50 43 4d 50 64 01 04 b9 41 4d 44 20 20 20 20  ".PCMPd...AMD    "
  9e080  20 50 4f 4f 48 20 20 20 20 20 20 20 20 00 00 00  " POOH        ..."
  9e090  00 00 00 24 00 00 00 e0 fe 90 00 5f 00 00 00 10  "...$......._...."
  9e0a0  03 63 0f 10 00 ff fb 8b 17 00 00 00 00 00 00 00  ".c.............."
  9e0b0  00 00 01 10 01 63 0f 10 00 ff fb 8b 17 00 00 00  ".....c.........."
  9e0c0  00 00 00 00 00 01 00 50 43 49 20 20 20 01 01 50  ".......PCI   ..P"
  9e0d0  43 49 20 20 20 01 03 50 43 49 20 20 20 01 06 50  "CI   ..PCI   ..P"
  9e0e0  43 49 20 20 20 01 07 49 53 41 20 20 20 02 02 21  "CI   ..ISA   ..!"
  9e0f0  01 00 00 c0 fe 03 00 05 00 07 00 02 00 03 00 05  "................"
  9e100  00 07 01 02 01 03 03 05 00 07 00 02 02 03 00 05  "................"
  9e110  00 07 03 02 03 03 00 05 00 07 04 02 04 03 00 0f  "................"
  9e120  00 00 44 02 13 03 00 05 00 07 06 02 06 03 00 05  "..D............."
  9e130  00 07 07 02 07 03 00 05 00 07 08 02 08 03 00 05  "................"
  9e140  00 07 09 02 09 03 00 0f 00 00 14 02 11 03 00 0f  "................"
  9e150  00 00 10 02 10 03 00 05 00 07 0c 02 0c 03 00 05  "................"
  9e160  00 07 0d 02 0d 03 00 05 00 07 0e 02 0e 03 00 05  "................"
  9e170  00 07 0f 02 0f 03 00 0f 00 00 48 02 12 03 00 0f  "..........H....."
  9e180  00 00 49 02 11 03 00 0f 00 00 4c 02 12 03 00 0f  "..I.......L....."
  9e190  00 00 4d 02 11 03 00 0f 00 00 51 02 11 03 00 0f  "..M.......Q....."
  9e1a0  00 00 50 02 10 03 00 0f 00 00 58 02 12 03 00 0f  "..P.......X....."
  9e1b0  00 00 59 02 11 03 00 0f 00 03 00 02 10 03 00 0f  "..Y............."
  9e1c0  00 06 00 02 11 04 03 05 00 07 00 ff 00 04 01 05  "................"
  9e1d0  00 07 00 ff 01 80 14 00 00 00 00 00 00 00 00 00  "................"
  9e1e0  00 00 00 01 00 00 00 00 00 80 14 00 01 00 00 00  "................"
  9e1f0  80 00 00 00 00 00 00 00 40 00 00 00 00 80 14 00  "........@......."
  9e200  02 00 00 00 c0 00 00 00 00 00 00 00 10 00 00 00  "................"
  9e210  00 80 14 00 01 00 00 00 d0 00 00 00 00 00 00 e0  "................"
  9e220  2e 00 00 00 00 80 14 00 01 00 10 e0 fe 00 00 00  "................"
  9e230  00 00 f0 1f 01 00 00 00 00 80 14 00 01 00 00 0a  "................"
  9e240  00 00 00 00 00 00 00 06 00 00 00 00 00 81 08 07  "................"
  9e250  01 00 00 00 00 82 08 00 00 00 00 00 00 82 08 00  "................"
  9e260  00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e270  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e280  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e290  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e2a0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e2b0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e2c0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e2d0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e2e0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e2f0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e300  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e310  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e320  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e330  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e340  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e350  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e360  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e370  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e380  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e390  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e3a0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e3b0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e3c0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e3d0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e3e0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  9e3f0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
----- EBDA end -----
/dev/mem[0xf8080, 16]: mmap(, 4096,,,, 0xf8000) ok
----- MP FP 0xf8080 - 0xf808f -----
  f8080  5f 4d 50 5f 71 e0 09 00 01 04 46 00 00 00 00 00  "_MP_q.....F....."
----- MP FP end -----
/dev/mem[0x9e071, 500]: mmap(, 4096,,,, 0x9e000) ok
----- MP config table 0x9e071 - 0x9e264 -----
  9e071  50 43 4d 50 64 01 04 b9 41 4d 44 20 20 20 20 20  "PCMPd...AMD     "
  9e081  50 4f 4f 48 20 20 20 20 20 20 20 20 00 00 00 00  "POOH        ...."
  9e091  00 00 24 00 00 00 e0 fe 90 00 5f 00 00 00 10 03  "..$......._....."
  9e0a1  63 0f 10 00 ff fb 8b 17 00 00 00 00 00 00 00 00  "c..............."
  9e0b1  00 01 10 01 63 0f 10 00 ff fb 8b 17 00 00 00 00  "....c..........."
  9e0c1  00 00 00 00 01 00 50 43 49 20 20 20 01 01 50 43  "......PCI   ..PC"
  9e0d1  49 20 20 20 01 03 50 43 49 20 20 20 01 06 50 43  "I   ..PCI   ..PC"
  9e0e1  49 20 20 20 01 07 49 53 41 20 20 20 02 02 21 01  "I   ..ISA   ..!."
  9e0f1  00 00 c0 fe 03 00 05 00 07 00 02 00 03 00 05 00  "................"
  9e101  07 01 02 01 03 03 05 00 07 00 02 02 03 00 05 00  "................"
  9e111  07 03 02 03 03 00 05 00 07 04 02 04 03 00 0f 00  "................"
  9e121  00 44 02 13 03 00 05 00 07 06 02 06 03 00 05 00  ".D.............."
  9e131  07 07 02 07 03 00 05 00 07 08 02 08 03 00 05 00  "................"
  9e141  07 09 02 09 03 00 0f 00 00 14 02 11 03 00 0f 00  "................"
  9e151  00 10 02 10 03 00 05 00 07 0c 02 0c 03 00 05 00  "................"
  9e161  07 0d 02 0d 03 00 05 00 07 0e 02 0e 03 00 05 00  "................"
  9e171  07 0f 02 0f 03 00 0f 00 00 48 02 12 03 00 0f 00  ".........H......"
  9e181  00 49 02 11 03 00 0f 00 00 4c 02 12 03 00 0f 00  ".I.......L......"
  9e191  00 4d 02 11 03 00 0f 00 00 51 02 11 03 00 0f 00  ".M.......Q......"
  9e1a1  00 50 02 10 03 00 0f 00 00 58 02 12 03 00 0f 00  ".P.......X......"
  9e1b1  00 59 02 11 03 00 0f 00 03 00 02 10 03 00 0f 00  ".Y.............."
  9e1c1  06 00 02 11 04 03 05 00 07 00 ff 00 04 01 05 00  "................"
  9e1d1  07 00 ff 01 80 14 00 00 00 00 00 00 00 00 00 00  "................"
  9e1e1  00 00 01 00 00 00 00 00 80 14 00 01 00 00 00 80  "................"
  9e1f1  00 00 00 00 00 00 00 40 00 00 00 00 80 14 00 02  ".......@........"
  9e201  00 00 00 c0 00 00 00 00 00 00 00 10 00 00 00 00  "................"
  9e211  80 14 00 01 00 00 00 d0 00 00 00 00 00 00 e0 2e  "................"
  9e221  00 00 00 00 80 14 00 01 00 10 e0 fe 00 00 00 00  "................"
  9e231  00 f0 1f 01 00 00 00 00 80 14 00 01 00 00 0a 00  "................"
  9e241  00 00 00 00 00 00 06 00 00 00 00 00 81 08 07 01  "................"
  9e251  00 00 00 00 82 08 00 00 00 00 00 00 82 08 00 00  "................"
  9e261  01 00 00 00  "...."
----- MP config table end -----
>> bios.4: vbe
/dev/mem[0xc0000, 3]: mmap(, 4096,,,, 0xc0000) ok
/dev/mem[0xc0000, 60928]: mmap(, 61440,,,, 0xc0000) ok
/dev/mem[0xa0000, 131071]: mmap(, 131071,,,, 0xa0000) ok
/dev/mem[0x0, 4096]: mmap(, 4096,,,, 0x0) ok
  vbe: int 10h points to c000:03c8: e8 e2 0b e8 b4 14 74 10
>> bios.4.1: vbe info
vm86: using CPU emulation
>> bios.5: 32
  bios32: valid SD header at 0xf8030 (size 0x10, rev 0), SD at 0xfd770
>> bios.6: acpi
>> sys.1: cpu
  vm check: vm_1 = 0, vm_2 = 0
  is_vmware = 0, has_vmware_mouse = 0
>> misc.9: kernel log
----- kernel log -----
  <6>[54346.061759] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <6>[54346.061765] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
  <6>[54777.828004] lo: Disabled Privacy Extensions
  <6>[55346.221534] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Down
  <6>[55349.666190] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
  <6>[55383.077421] lo: Disabled Privacy Extensions
  <6>[55985.942913] brcm80211 0000:06:00.0: PCI INT A disabled
  <6>[56011.247387] Compat-wireless backport release: compat-wireless-2011-01-06
  <6>[56011.247392] Backport based on linux-next.git next-20110107
  <6>[56011.270931] cfg80211: Calling CRDA to update world regulatory domain
  <6>[56011.315836] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
  <7>[56011.315852] brcm80211 0000:06:00.0: setting latency timer to 64
  <6>[56011.478013] cfg80211: World regulatory domain updated:
  <6>[56011.478022] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
  <6>[56011.478030] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.478038] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.478044] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.478050] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.478056] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <4>[56011.544348] Found chip type AI (0x13a1a8d9)
  <4>[56011.555671] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021 macaddr: c4:46:19:6c:a9:c0
  <7>[56011.555944] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.555953] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.555960] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.555968] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.555974] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.555981] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.555987] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.555995] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556001] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556008] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556014] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556021] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556027] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556035] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556041] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556048] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556054] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556061] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556067] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556075] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556081] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556088] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556094] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556102] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556108] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556115] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556121] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.556129] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
  <7>[56011.556566] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
  <4>[56011.558269] wl_set_hint: Sending country code US to MAC80211
  <4>[56011.558280] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (Compiled at 15:18:31 on Jan  9 2011)
  <6>[56011.558315] cfg80211: Calling CRDA for country: US
  <7>[56011.569824] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569833] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569838] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569842] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569846] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569850] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569853] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569857] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569860] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569864] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569868] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569872] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569875] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569879] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569882] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569886] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569889] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569893] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569897] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569900] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569904] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
  <7>[56011.569908] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
  <7>[56011.569911] cfg80211: Disabling freq 2467 MHz
  <7>[56011.569913] cfg80211: Disabling freq 2472 MHz
  <7>[56011.569916] cfg80211: Disabling freq 2484 MHz
  <6>[56011.569920] cfg80211: Regulatory domain changed to country: US
  <6>[56011.569922] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
  <6>[56011.569926] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
  <6>[56011.569930] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
  <6>[56011.569934] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.569938] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.569942] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  <6>[56011.569946] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
  <6>[56435.290530] brcm80211 0000:06:00.0: PCI INT A disabled
  <6>[56578.819540] lp: driver loaded but no devices found
  <6>[56579.388439] st: Version 20081215, fixed bufsize 32768, s/g segs 256
----- kernel log end -----
>> misc.1: misc data
>> misc.1.1: open serial
>> misc.1.2: open parallel
----- exec: "/sbin/rmmod lp" -----
----- return code: ? -----
----- exec: "/sbin/rmmod parport_pc" -----
----- return code: ? -----
----- exec: "/sbin/rmmod parport" -----
  ERROR: Module parport is in use by ppdev
----- return code: ? -----
----- exec: "/sbin/modprobe parport_pc " -----
----- return code: ? -----
>> misc.2.1: io
>> misc.2.2: dma
>> misc.2.3: irq
----- /proc/ioports -----
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
    0170-0177 : 0000:00:14.1
      0170-0177 : pata_atiixp
    01f0-01f7 : 0000:00:14.1
      01f0-01f7 : pata_atiixp
    0220-022f : pnp 00:06
    0376-0376 : 0000:00:14.1
      0376-0376 : pata_atiixp
    03c0-03df : vga+
    03f6-03f6 : 0000:00:14.1
      03f6-03f6 : pata_atiixp
    040b-040b : pnp 00:06
    04d0-04d1 : pnp 00:06
    04d6-04d6 : pnp 00:06
    0530-0537 : pnp 00:06
    087f-087f : pnp 00:06
    0c00-0c01 : pnp 00:06
    0c14-0c14 : pnp 00:06
    0c50-0c52 : pnp 00:06
    0c6c-0c6c : pnp 00:06
    0c6f-0c6f : pnp 00:06
    0cd0-0cd1 : pnp 00:06
    0cd2-0cd3 : pnp 00:06
    0cd4-0cd5 : pnp 00:06
    0cd6-0cd7 : pnp 00:06
    0cd8-0cdf : pnp 00:06
  0cf8-0cff : PCI conf1
  0d00-ffff : PCI Bus 0000:00
    0f40-0f47 : pnp 00:06
    0f50-0f51 : pnp 00:01
    8000-805f : pnp 00:06
      8000-8003 : ACPI PM1a_EVT_BLK
      8004-8005 : ACPI PM1a_CNT_BLK
      8008-800b : ACPI PM_TMR
      8010-8015 : ACPI CPU throttle
      8020-8027 : ACPI GPE0_BLK
    8100-81ff : pnp 00:06
    8200-82ff : pnp 00:06
      8200-8200 : ACPI PM2_CNT_BLK
    8400-840f : 0000:00:11.0
      8400-840f : ahci
    8410-8413 : 0000:00:11.0
      8410-8413 : ahci
    8420-8427 : 0000:00:11.0
      8420-8427 : ahci
    8430-8433 : 0000:00:11.0
      8430-8433 : ahci
    8440-8447 : 0000:00:11.0
      8440-8447 : ahci
    8450-845f : 0000:00:14.1
      8450-845f : pata_atiixp
    9000-9fff : PCI Bus 0000:01
      9000-90ff : 0000:01:05.0
    a000-afff : PCI Bus 0000:03
      a000-a07f : 0000:03:00.0
        a000-a07f : atl1c
----- /proc/ioports end -----
----- /proc/interrupts -----
    0:     141232    9819144   IO-APIC-edge      timer
    1:      55245      49316   IO-APIC-edge      i8042
    7:          1          0   IO-APIC-edge    
    8:          0          1   IO-APIC-edge      rtc0
    9:      16692      79199   IO-APIC-fasteoi   acpi
   12:     287859     438122   IO-APIC-edge      i8042
   14:          0          0   IO-APIC-edge      pata_atiixp
   15:          0          0   IO-APIC-edge      pata_atiixp
   16:       7539       7271   IO-APIC-fasteoi   hda_intel
   17:     237698     932077   IO-APIC-fasteoi   ehci_hcd:usb1, ehci_hcd:usb2, ehci_hcd:usb3
   18:      11689      32569   IO-APIC-fasteoi   ohci_hcd:usb4, ohci_hcd:usb5, ohci_hcd:usb6, fglrx[0]@PCI:1:5:0
   19:          0         50   IO-APIC-fasteoi   hda_intel
   42:     165355     717725   PCI-MSI-edge      ahci
   43:      61397    3878707   PCI-MSI-edge      eth0
  NMI:          0          0   Non-maskable interrupts
  LOC:    6229245    1829807   Local timer interrupts
  SPU:          0          0   Spurious interrupts
  PMI:          0          0   Performance monitoring interrupts
  PND:          0          0   Performance pending work
  RES:   11777713   11203110   Rescheduling interrupts
  CAL:       8377      12859   Function call interrupts
  TLB:     326086     319121   TLB shootdowns
  TRM:          0          0   Thermal event interrupts
  THR:          0          0   Threshold APIC interrupts
  MCE:          0          0   Machine check exceptions
  MCP:        189        189   Machine check polls
  ERR:          1
  MIS:          0
----- /proc/interrupts end -----
----- /proc/dma -----
   4: cascade
----- /proc/dma end -----
>> misc.3: FPU
>> misc.3.1: DMA
>> misc.3.2: PIC
>> misc.3.3: timer
>> misc.3.4: RTC
>> cpu.1: cpuinfo
----- /proc/cpuinfo -----
  processor	: 0
  vendor_id	: AuthenticAMD
  cpu family	: 16
  model		: 6
  model name	: AMD Athlon(tm) II Neo K325 Dual-Core Processor
  stepping	: 3
  cpu MHz		: 1300.000
  cache size	: 1024 KB
  physical id	: 0
  siblings	: 2
  core id		: 0
  cpu cores	: 2
  apicid		: 0
  initial apicid	: 0
  fpu		: yes
  fpu_exception	: yes
  cpuid level	: 5
  wp		: yes
  flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt lbrv svm_lock nrip_save
  bogomips	: 2593.53
  TLB size	: 1024 4K pages
  clflush size	: 64
  cache_alignment	: 64
  address sizes	: 48 bits physical, 48 bits virtual
  power management: ts ttp tm stc 100mhzsteps hwpstate
  
  processor	: 1
  vendor_id	: AuthenticAMD
  cpu family	: 16
  model		: 6
  model name	: AMD Athlon(tm) II Neo K325 Dual-Core Processor
  stepping	: 3
  cpu MHz		: 1300.000
  cache size	: 1024 KB
  physical id	: 0
  siblings	: 2
  core id		: 1
  cpu cores	: 2
  apicid		: 1
  initial apicid	: 1
  fpu		: yes
  fpu_exception	: yes
  cpuid level	: 5
  wp		: yes
  flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt lbrv svm_lock nrip_save
  bogomips	: 2593.50
  TLB size	: 1024 4K pages
  clflush size	: 64
  cache_alignment	: 64
  address sizes	: 48 bits physical, 48 bits virtual
  power management: ts ttp tm stc 100mhzsteps hwpstate
  
----- /proc/cpuinfo end -----
>> memory.1: main memory size
  kcore mem:  0x7fffffe01000
  klog mem 0: 0x0
  klog mem 1: 0x0
  klog mem:   0x0
  bios mem:   0x0
  meminfo:    0x6d988000
>> pci.1: sysfs drivers
----- sysfs driver list (id 0x7a2cb1ba3ba5bfac) -----
      serial8250: /devices/platform/serial8250
           i8042: /devices/platform/i8042
      parport_pc: module = parport_pc
        acer-wmi: module = acer_wmi
        acer-wmi: /devices/platform/acer-wmi
         vboxdrv: /devices/platform/vboxdrv.0
        pcieport: /devices/pci0000:00/0000:00:04.0
        pcieport: /devices/pci0000:00/0000:00:05.0
        ehci_hcd: /devices/pci0000:00/0000:00:12.2
        ehci_hcd: /devices/pci0000:00/0000:00:13.2
        ehci_hcd: /devices/pci0000:00/0000:00:16.2
        ehci_hcd: module = ehci_hcd
        ohci_hcd: /devices/pci0000:00/0000:00:12.0
        ohci_hcd: /devices/pci0000:00/0000:00:13.0
        ohci_hcd: /devices/pci0000:00/0000:00:16.0
        uhci_hcd: module = uhci_hcd
           atl1c: module = atl1c
           atl1c: /devices/pci0000:00/0000:00:04.0/0000:03:00.0
     pata_atiixp: /devices/pci0000:00/0000:00:14.1
     pata_atiixp: module = pata_atiixp
            ahci: /devices/pci0000:00/0000:00:11.0
            ahci: module = ahci
      parport_pc: module = parport_pc
     piix4_smbus: module = i2c_piix4
         k10temp: /devices/pci0000:00/0000:00:18.3
         k10temp: module = k10temp
          shpchp: module = shpchp
       fglrx_pci: /devices/pci0000:00/0000:00:01.0/0000:01:05.0
       fglrx_pci: module = fglrx
       HDA Intel: /devices/pci0000:00/0000:00:14.2
       HDA Intel: /devices/pci0000:00/0000:00:01.0/0000:01:05.1
       HDA Intel: module = snd_hda_intel
              ec: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00
        pci_root: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:00
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:01
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:02
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:03
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:04
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:05
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:06
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:07
             wmi: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00
             wmi: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:01
              ac: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00
          button: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00
          button: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00
          button: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00
          button: /devices/LNXSYSTM:00/LNXPWRBN:00
       processor: /devices/LNXSYSTM:00/LNXCPU:00
       processor: /devices/LNXSYSTM:00/LNXCPU:01
         thermal: /devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:01
         thermal: /devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:02
         battery: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00
           video: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02
          system: /devices/pnp0/00:01
          system: /devices/pnp0/00:06
          system: /devices/pnp0/00:07
       i8042 kbd: /devices/pnp0/00:08
       i8042 aux: /devices/pnp0/00:09
        rtc_cmos: /devices/pnp0/00:04
              sd: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
              sd: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
           usbfs: module = usbcore
             hub: module = usbcore
             hub: /devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
             hub: /devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
             hub: /devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
             hub: /devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
             hub: /devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
             hub: /devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
             usb: /devices/pci0000:00/0000:00:12.2/usb1
             usb: /devices/pci0000:00/0000:00:13.2/usb2
             usb: /devices/pci0000:00/0000:00:16.2/usb3
             usb: /devices/pci0000:00/0000:00:12.0/usb4
             usb: /devices/pci0000:00/0000:00:13.0/usb5
             usb: /devices/pci0000:00/0000:00:16.0/usb6
             usb: /devices/pci0000:00/0000:00:12.2/usb1/1-5
             usb: /devices/pci0000:00/0000:00:13.2/usb2/2-5
     usb-storage: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0
     usb-storage: module = usb_storage
          hiddev: module = usbhid
          usbhid: module = usbhid
        uvcvideo: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
        uvcvideo: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
        uvcvideo: module = uvcvideo
           atkbd: /devices/platform/i8042/serio0
       serio_raw: module = serio_raw
         psmouse: module = psmouse
         psmouse: /devices/platform/i8042/serio1
     generic-usb: module = usbhid
----- sysfs driver list end -----
>> pci.2: get sysfs pci data
  pci device: name = 0000:00:00.0
    path = /devices/pci0000:00/0000:00:00.0
    modalias = "pci:v00001022d00009601sv00001025sd00000429bc06sc00i00"
    class = 0x60000
    vendor = 0x1022
    device = 0x9601
    subvendor = 0x1025
    subdevice = 0x429
    irq = 0
    config[64]
  pci device: name = 0000:00:01.0
    path = /devices/pci0000:00/0000:00:01.0
    modalias = "pci:v00001025d00009602sv00001025sd00000429bc06sc04i00"
    class = 0x60400
    vendor = 0x1025
    device = 0x9602
    subvendor = 0x1025
    subdevice = 0x429
    irq = 0
    config[64]
  pci device: name = 0000:00:04.0
    path = /devices/pci0000:00/0000:00:04.0
    modalias = "pci:v00001022d00009604sv00001025sd00000429bc06sc04i00"
    class = 0x60400
    vendor = 0x1022
    device = 0x9604
    subvendor = 0x1025
    subdevice = 0x429
    irq = 40
    config[64]
  pci device: name = 0000:00:05.0
    path = /devices/pci0000:00/0000:00:05.0
    modalias = "pci:v00001022d00009605sv00001025sd00000429bc06sc04i00"
    class = 0x60400
    vendor = 0x1022
    device = 0x9605
    subvendor = 0x1025
    subdevice = 0x429
    irq = 41
    config[64]
  pci device: name = 0000:00:11.0
    path = /devices/pci0000:00/0000:00:11.0
    modalias = "pci:v00001002d00004391sv00001025sd00000429bc01sc06i01"
    class = 0x10601
    vendor = 0x1002
    device = 0x4391
    subvendor = 0x1025
    subdevice = 0x429
    irq = 42
    res[0] = 0x8440 0x8447 0x40101
    res[1] = 0x8430 0x8433 0x40101
    res[2] = 0x8420 0x8427 0x40101
    res[3] = 0x8410 0x8413 0x40101
    res[4] = 0x8400 0x840f 0x40101
    res[5] = 0xd0607c00 0xd0607fff 0x40200
    config[64]
  pci device: name = 0000:00:12.0
    path = /devices/pci0000:00/0000:00:12.0
    modalias = "pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10"
    class = 0xc0310
    vendor = 0x1002
    device = 0x4397
    subvendor = 0x1025
    subdevice = 0x429
    irq = 18
    res[0] = 0xd0404000 0xd0404fff 0x40200
    config[64]
  pci device: name = 0000:00:12.2
    path = /devices/pci0000:00/0000:00:12.2
    modalias = "pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20"
    class = 0xc0320
    vendor = 0x1002
    device = 0x4396
    subvendor = 0x1025
    subdevice = 0x429
    irq = 17
    res[0] = 0xd0607000 0xd06070ff 0x40200
    config[64]
  pci device: name = 0000:00:13.0
    path = /devices/pci0000:00/0000:00:13.0
    modalias = "pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10"
    class = 0xc0310
    vendor = 0x1002
    device = 0x4397
    subvendor = 0x1025
    subdevice = 0x429
    irq = 18
    res[0] = 0xd0405000 0xd0405fff 0x40200
    config[64]
  pci device: name = 0000:00:13.2
    path = /devices/pci0000:00/0000:00:13.2
    modalias = "pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20"
    class = 0xc0320
    vendor = 0x1002
    device = 0x4396
    subvendor = 0x1025
    subdevice = 0x429
    irq = 17
    res[0] = 0xd0607400 0xd06074ff 0x40200
    config[64]
  pci device: name = 0000:00:14.0
    path = /devices/pci0000:00/0000:00:14.0
    modalias = "pci:v00001002d00004385sv00000000sd00000000bc0Csc05i00"
    class = 0xc0500
    vendor = 0x1002
    device = 0x4385
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:00:14.1
    path = /devices/pci0000:00/0000:00:14.1
    modalias = "pci:v00001002d0000439Csv00001025sd00000429bc01sc01i8a"
    class = 0x1018a
    vendor = 0x1002
    device = 0x439c
    subvendor = 0x1025
    subdevice = 0x429
    irq = 17
    res[0] = 0x1f0 0x1f7 0x110
    res[1] = 0x3f6 0x3f6 0x110
    res[2] = 0x170 0x177 0x110
    res[3] = 0x376 0x376 0x110
    res[4] = 0x8450 0x845f 0x40101
    config[64]
  pci device: name = 0000:00:14.2
    path = /devices/pci0000:00/0000:00:14.2
    modalias = "pci:v00001002d00004383sv00001025sd00000429bc04sc03i00"
    class = 0x40300
    vendor = 0x1002
    device = 0x4383
    subvendor = 0x1025
    subdevice = 0x429
    irq = 16
    res[0] = 0xd0400000 0xd0403fff 0x140204
    config[64]
  pci device: name = 0000:00:14.3
    path = /devices/pci0000:00/0000:00:14.3
    modalias = "pci:v00001002d0000439Dsv00001025sd00000429bc06sc01i00"
    class = 0x60100
    vendor = 0x1002
    device = 0x439d
    subvendor = 0x1025
    subdevice = 0x429
    irq = 0
    config[64]
  pci device: name = 0000:00:14.4
    path = /devices/pci0000:00/0000:00:14.4
    modalias = "pci:v00001002d00004384sv00000000sd00000000bc06sc04i01"
    class = 0x60401
    vendor = 0x1002
    device = 0x4384
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:00:16.0
    path = /devices/pci0000:00/0000:00:16.0
    modalias = "pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10"
    class = 0xc0310
    vendor = 0x1002
    device = 0x4397
    subvendor = 0x1025
    subdevice = 0x429
    irq = 18
    res[0] = 0xd0406000 0xd0406fff 0x40200
    config[64]
  pci device: name = 0000:00:16.2
    path = /devices/pci0000:00/0000:00:16.2
    modalias = "pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20"
    class = 0xc0320
    vendor = 0x1002
    device = 0x4396
    subvendor = 0x1025
    subdevice = 0x429
    irq = 17
    res[0] = 0xd0607800 0xd06078ff 0x40200
    config[64]
  pci device: name = 0000:00:18.0
    path = /devices/pci0000:00/0000:00:18.0
    modalias = "pci:v00001022d00001200sv00000000sd00000000bc06sc00i00"
    class = 0x60000
    vendor = 0x1022
    device = 0x1200
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:00:18.1
    path = /devices/pci0000:00/0000:00:18.1
    modalias = "pci:v00001022d00001201sv00000000sd00000000bc06sc00i00"
    class = 0x60000
    vendor = 0x1022
    device = 0x1201
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:00:18.2
    path = /devices/pci0000:00/0000:00:18.2
    modalias = "pci:v00001022d00001202sv00000000sd00000000bc06sc00i00"
    class = 0x60000
    vendor = 0x1022
    device = 0x1202
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:00:18.3
    path = /devices/pci0000:00/0000:00:18.3
    modalias = "pci:v00001022d00001203sv00000000sd00000000bc06sc00i00"
    class = 0x60000
    vendor = 0x1022
    device = 0x1203
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:00:18.4
    path = /devices/pci0000:00/0000:00:18.4
    modalias = "pci:v00001022d00001204sv00000000sd00000000bc06sc00i00"
    class = 0x60000
    vendor = 0x1022
    device = 0x1204
    subvendor = 0x0
    subdevice = 0x0
    irq = 0
    config[64]
  pci device: name = 0000:01:05.0
    path = /devices/pci0000:00/0000:00:01.0/0000:01:05.0
    modalias = "pci:v00001002d00009712sv00001025sd00000429bc03sc00i00"
    class = 0x30000
    vendor = 0x1002
    device = 0x9712
    subvendor = 0x1025
    subdevice = 0x429
    irq = 18
    res[0] = 0xc0000000 0xcfffffff 0x42208
    res[1] = 0x9000 0x90ff 0x40101
    res[2] = 0xd0100000 0xd010ffff 0x40200
    res[5] = 0xd0000000 0xd00fffff 0x40200
    config[64]
  pci device: name = 0000:01:05.1
    path = /devices/pci0000:00/0000:00:01.0/0000:01:05.1
    modalias = "pci:v00001002d0000970Fsv00001025sd00000429bc04sc03i00"
    class = 0x40300
    vendor = 0x1002
    device = 0x970f
    subvendor = 0x1025
    subdevice = 0x429
    irq = 19
    res[0] = 0xd0110000 0xd0113fff 0x40200
    config[64]
  pci device: name = 0000:03:00.0
    path = /devices/pci0000:00/0000:00:04.0/0000:03:00.0
    modalias = "pci:v00001969d00001073sv00001025sd0000040Dbc02sc00i00"
    class = 0x20000
    vendor = 0x1969
    device = 0x1073
    subvendor = 0x1025
    subdevice = 0x40d
    irq = 43
    res[0] = 0xd0200000 0xd023ffff 0x140204
    res[2] = 0xa000 0xa07f 0x40101
    config[64]
  pci device: name = 0000:06:00.0
    path = /devices/pci0000:00/0000:00:05.0/0000:06:00.0
    modalias = "pci:v000014E4d00004357sv0000105Bsd0000E021bc02sc80i00"
    class = 0x28000
    vendor = 0x14e4
    device = 0x4357
    subvendor = 0x105b
    subdevice = 0xe021
    irq = 17
    res[0] = 0xd0300000 0xd0303fff 0x140204
    config[64]
---------- PCI raw data ----------
bus 00, slot 00, func 0, vend:dev:s_vend:s_dev:rev 1022:9601:1025:0429:00
class 06, sub_class 00 prog_if 00, hdr 0, flags <>, irq 0
  00: 22 10 01 96 06 00 30 22 00 00 00 06 00 00 00 00  "".....0"........"
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 c4 00 00 00 00 00 00 00 00 00 00 00  "................"
  40: 08 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 00 00 00 00 08 40 00 00 00 00 00 00 00 00 00 00  ".....@.........."
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 08 f8 00 00  "................"
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  c0: 00 00 00 00 08 54 00 00 00 00 00 00 00 00 00 00  ".....T.........."
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  f0: 00 00 00 00 00 00 00 00 08 00  ".........."

bus 00->01, slot 01, func 0, vend:dev:s_vend:s_dev:rev 1025:9602:1025:0429:00
class 06, sub_class 04 prog_if 00, hdr 1, flags <>, irq 0
  00: 25 10 02 96 07 00 30 02 00 00 04 06 00 40 01 00  "%.....0......@.."
  10: 00 00 00 00 00 00 00 00 00 01 01 40 91 91 20 02  "...........@.. ."
  20: 00 d0 10 d0 01 c0 f1 cf 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 0c 00  "....D..........."

bus 00->03, slot 04, func 0, vend:dev:s_vend:s_dev:rev 1022:9604:1025:0429:00
class 06, sub_class 04 prog_if 00, hdr 1, flags <>, irq 40
  00: 22 10 04 96 07 04 10 00 00 00 04 06 08 00 01 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 03 03 00 a1 a1 00 00  "................"
  20: 20 d0 20 d0 f1 ff 01 00 00 00 00 00 00 00 00 00  " . ............."
  30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 04 00  "....P..........."

bus 00->06, slot 05, func 0, vend:dev:s_vend:s_dev:rev 1022:9605:1025:0429:00
class 06, sub_class 04 prog_if 00, hdr 1, flags <>, irq 41
  00: 22 10 05 96 07 04 10 00 00 00 04 06 08 00 01 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 06 06 00 f1 01 00 20  "............... "
  20: 30 d0 30 d0 f1 ff 01 00 00 00 00 00 00 00 00 00  "0.0............."
  30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 04 00  "....P..........."

bus 00, slot 11, func 0, vend:dev:s_vend:s_dev:rev 1002:4391:1025:0429:00
class 01, sub_class 06 prog_if 01, hdr 0, flags <>, irq 42
  addr0 00008440, size 00000008
  addr1 00008430, size 00000004
  addr2 00008420, size 00000008
  addr3 00008410, size 00000004
  addr4 00008400, size 00000010
  addr5 d0607c00, size 00000400
  00: 02 10 91 43 07 04 30 02 00 01 06 01 00 40 00 00  "...C..0......@.."
  10: 41 84 00 00 31 84 00 00 21 84 00 00 11 84 00 00  "A...1...!......."
  20: 01 84 00 00 00 7c 60 d0 00 00 00 00 25 10 29 04  ".....|`.....%.)."
  30: 00 00 00 00 50 00 00 00 00 00 00 00 05 01 00 00  "....P..........."
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 05 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ".p.............."
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 12 a4 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 00 00 00 00 13 00  "......"

bus 00, slot 12, func 0, vend:dev:s_vend:s_dev:rev 1002:4397:1025:0429:00
class 0c, sub_class 03 prog_if 10, hdr 0, flags <>, irq 18
  addr0 d0404000, size 00001000
  00: 02 10 97 43 17 00 a0 02 00 10 03 0c 08 40 80 00  "...C.........@.."
  10: 00 40 40 d0 00 00 00 00 00 00 00 00 00 00 00 00  ".@@............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00  "................"

bus 00, slot 12, func 2, vend:dev:s_vend:s_dev:rev 1002:4396:1025:0429:00
class 0c, sub_class 03 prog_if 20, hdr 0, flags <pm>, irq 17
  addr0 d0607000, size 00000100
  00: 02 10 96 43 17 00 b0 02 00 20 03 0c 08 40 00 00  "...C..... ...@.."
  10: 00 70 60 d0 00 00 00 00 00 00 00 00 00 00 00 00  ".p`............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00  "................"
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  c0: 01 e4 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  e0: 00 00 00 00 0a 00  "......"

bus 00, slot 13, func 0, vend:dev:s_vend:s_dev:rev 1002:4397:1025:0429:00
class 0c, sub_class 03 prog_if 10, hdr 0, flags <>, irq 18
  addr0 d0405000, size 00001000
  00: 02 10 97 43 17 00 a0 02 00 10 03 0c 08 40 80 00  "...C.........@.."
  10: 00 50 40 d0 00 00 00 00 00 00 00 00 00 00 00 00  ".P@............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00  "................"

bus 00, slot 13, func 2, vend:dev:s_vend:s_dev:rev 1002:4396:1025:0429:00
class 0c, sub_class 03 prog_if 20, hdr 0, flags <pm>, irq 17
  addr0 d0607400, size 00000100
  00: 02 10 96 43 17 00 b0 02 00 20 03 0c 08 40 00 00  "...C..... ...@.."
  10: 00 74 60 d0 00 00 00 00 00 00 00 00 00 00 00 00  ".t`............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00  "................"
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  c0: 01 e4 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  e0: 00 00 00 00 0a 00  "......"

bus 00, slot 14, func 0, vend:dev:s_vend:s_dev:rev 1002:4385:0000:0000:41
class 0c, sub_class 05 prog_if 00, hdr 0, flags <>, irq 0
  00: 02 10 85 43 03 00 20 02 41 00 05 0c 00 00 80 00  "...C.. .A......."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"

bus 00, slot 14, func 1, vend:dev:s_vend:s_dev:rev 1002:439c:1025:0429:40
class 01, sub_class 01 prog_if 8a, hdr 0, flags <>, irq 17
  addr0 000001f0, size 00000008
  addr1 000003f6, size 00000001
  addr2 00000170, size 00000008
  addr3 00000376, size 00000001
  addr4 00008450, size 00000010
  00: 02 10 9c 43 07 00 20 02 40 8a 01 01 00 40 00 00  "...C.. .@....@.."
  10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00  "................"
  20: 51 84 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "Q...........%.)."
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 02 00 00  "................"

bus 00, slot 14, func 2, vend:dev:s_vend:s_dev:rev 1002:4383:1025:0429:40
class 04, sub_class 03 prog_if 00, hdr 0, flags <pm>, irq 16
  addr0 d0400000, size 00004000
  00: 02 10 83 43 06 00 10 04 40 00 03 04 08 40 00 00  "...C....@....@.."
  10: 04 00 40 d0 00 00 00 00 00 00 00 00 00 00 00 00  "..@............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 00 00 00  "....P..........."
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 01 00  ".."

bus 00, slot 14, func 3, vend:dev:s_vend:s_dev:rev 1002:439d:1025:0429:40
class 06, sub_class 01 prog_if 00, hdr 0, flags <>, irq 0
  00: 02 10 9d 43 0f 00 20 02 40 00 01 06 00 00 80 00  "...C.. .@......."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"

bus 00->07, slot 14, func 4, vend:dev:s_vend:s_dev:rev 1002:4384:0000:0000:40
class 06, sub_class 04 prog_if 01, hdr 1, flags <>, irq 0
  00: 02 10 84 43 07 00 a0 02 40 01 04 06 00 40 81 00  "...C....@....@.."
  10: 00 00 00 00 00 00 00 00 00 07 07 40 f0 00 80 22  "...........@...""
  20: f0 ff 00 00 f0 ff 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"

bus 00, slot 16, func 0, vend:dev:s_vend:s_dev:rev 1002:4397:1025:0429:00
class 0c, sub_class 03 prog_if 10, hdr 0, flags <>, irq 18
  addr0 d0406000, size 00001000
  00: 02 10 97 43 17 00 a0 02 00 10 03 0c 08 40 80 00  "...C.........@.."
  10: 00 60 40 d0 00 00 00 00 00 00 00 00 00 00 00 00  ".`@............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00  "................"

bus 00, slot 16, func 2, vend:dev:s_vend:s_dev:rev 1002:4396:1025:0429:00
class 0c, sub_class 03 prog_if 20, hdr 0, flags <pm>, irq 17
  addr0 d0607800, size 00000100
  00: 02 10 96 43 17 00 b0 02 00 20 03 0c 08 40 00 00  "...C..... ...@.."
  10: 00 78 60 d0 00 00 00 00 00 00 00 00 00 00 00 00  ".x`............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00  "................"
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  c0: 01 e4 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  e0: 00 00 00 00 0a 00  "......"

bus 00, slot 18, func 0, vend:dev:s_vend:s_dev:rev 1022:1200:0000:0000:00
class 06, sub_class 00 prog_if 00, hdr 0, flags <>, irq 0
  00: 22 10 00 12 00 00 10 00 00 00 00 06 00 00 80 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00  "................"
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 08 00  ".."

bus 00, slot 18, func 1, vend:dev:s_vend:s_dev:rev 1022:1201:0000:0000:00
class 06, sub_class 00 prog_if 00, hdr 0, flags <>, irq 0
  00: 22 10 01 12 00 00 00 00 00 00 00 06 00 00 80 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"

bus 00, slot 18, func 2, vend:dev:s_vend:s_dev:rev 1022:1202:0000:0000:00
class 06, sub_class 00 prog_if 00, hdr 0, flags <>, irq 0
  00: 22 10 02 12 00 00 00 00 00 00 00 06 00 00 80 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"

bus 00, slot 18, func 3, vend:dev:s_vend:s_dev:rev 1022:1203:0000:0000:00
class 06, sub_class 00 prog_if 00, hdr 0, flags <>, irq 0
  00: 22 10 03 12 00 00 10 00 00 00 00 06 00 00 80 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00  "................"
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  f0: 0f 00  ".."

bus 00, slot 18, func 4, vend:dev:s_vend:s_dev:rev 1022:1204:0000:0000:00
class 06, sub_class 00 prog_if 00, hdr 0, flags <>, irq 0
  00: 22 10 04 12 00 00 00 00 00 00 00 06 00 00 80 00  ""..............."
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"

bus 01, slot 05, func 0, vend:dev:s_vend:s_dev:rev 1002:9712:1025:0429:00
class 03, sub_class 00 prog_if 00, hdr 0, flags <pm>, irq 18
  addr0 c0000000, size 10000000
  addr1 00009000, size 00000100
  addr2 d0100000, size 00010000
  addr5 d0000000, size 00100000
  00: 02 10 12 97 07 00 10 00 00 00 00 03 08 00 80 00  "................"
  10: 08 00 00 c0 01 90 00 00 00 00 10 d0 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 d0 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00  "....P..........."
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 01 a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 05 00  ".."

bus 01, slot 05, func 1, vend:dev:s_vend:s_dev:rev 1002:970f:1025:0429:00
class 04, sub_class 03 prog_if 00, hdr 0, flags <pm>, irq 19
  addr0 d0110000, size 00004000
  00: 02 10 0f 97 07 00 10 00 00 00 03 04 08 00 80 00  "................"
  10: 00 00 11 d0 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 29 04  "............%.)."
  30: 00 00 00 00 50 00 00 00 00 00 00 00 05 02 00 00  "....P..........."
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  50: 01 a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 05 00  ".."

bus 03, slot 00, func 0, vend:dev:s_vend:s_dev:rev 1969:1073:1025:040d:c0
class 02, sub_class 00 prog_if 00, hdr 0, flags <pm>, irq 43
  addr0 d0200000, size 00040000
  addr2 0000a000, size 00000080
  00: 69 19 73 10 07 04 10 00 c0 00 00 02 08 00 00 00  "i.s............."
  10: 04 00 20 d0 00 00 00 00 01 a0 00 00 00 00 00 00  ".. ............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 0d 04  "............%..."
  30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00  "....@..........."
  40: 01 48 00 00 00 00 00 00 05 58 00 00 00 00 00 00  ".H.......X......"
  50: 00 00 00 00 00 00 00 00 10 6c 00 00 00 00 00 00  ".........l......"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 03 00  ".............."

bus 06, slot 00, func 0, vend:dev:s_vend:s_dev:rev 14e4:4357:105b:e021:01
class 02, sub_class 80 prog_if 00, hdr 0, flags <pm>, irq 17
  addr0 d0300000, size 00004000
  00: e4 14 57 43 02 00 10 00 01 00 80 02 08 00 00 00  "..WC............"
  10: 04 00 30 d0 00 00 00 00 00 00 00 00 00 00 00 00  "..0............."
  20: 00 00 00 00 00 00 00 00 00 00 00 00 5b 10 21 e0  "............[.!."
  30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00  "....@..........."
  40: 01 58 00 00 00 00 00 00 05 d0 00 00 00 00 00 00  ".X.............."
  50: 00 00 00 00 00 00 00 00 09 48 00 00 00 00 00 00  ".........H......"
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  "................"
  d0: 10 00  ".."
---------- PCI raw data end ----------
>> pci.4: build list
>> pci.3: macio
sysfs: no such bus: macio
>> pci.4: vio
sysfs: no such bus: vio
>> pci.5: xen
sysfs: no such bus: xen
>> pci.6: ps3
sysfs: no such bus: ps3_system_bus
>> pci.7: platform
  platform device: name = pcspkr
    path = /devices/platform/pcspkr
    type = "platform:pcspkr"
  platform device: sf_eth_net = (null) sf_eth_dev = (nil)
  platform device: name = serial8250
    path = /devices/platform/serial8250
    type = "platform:serial8250"
  platform device: sf_eth_net = (null) sf_eth_dev = (nil)
  platform device: name = Fixed MDIO bus.0
    path = /devices/platform/Fixed MDIO bus.0
    type = "platform:Fixed MDIO bus"
  platform device: sf_eth_net = (null) sf_eth_dev = (nil)
  platform device: name = i8042
    path = /devices/platform/i8042
    type = "platform:i8042"
  platform device: sf_eth_net = (null) sf_eth_dev = (nil)
  platform device: name = acer-wmi
    path = /devices/platform/acer-wmi
    type = "platform:acer-wmi"
  platform device: sf_eth_net = (null) sf_eth_dev = (nil)
  platform device: name = vboxdrv.0
    path = /devices/platform/vboxdrv.0
    type = "platform:vboxdrv"
  platform device: sf_eth_net = (null) sf_eth_dev = (nil)
>> pci.8: of_platform
sysfs: no such bus: of_platform
>> pci.9: vm
sysfs: no such bus: vm
>> pci.10: virtio
sysfs: no such bus: virtio
>> pci.11: ibmebus
sysfs: no such bus: ibmebus
>> monitor.1: ddc
>> monitor.2: bios
>> monitor.3: pci
>> monitor.4: internal db
>> monitor.5: prom
>> pcmcia.1: sysfs drivers
>> pcmcia.2: pcmcia
sysfs: no such bus: pcmcia
>> pcmcia.3: pcmcia ctrl
sysfs: no such class: pcmcia_socket
>> serial.1: read info
----- /proc/tty/driver/serial -----
  0: uart:unknown port:000003F8 irq:4
  1: uart:unknown port:000002F8 irq:3
  2: uart:unknown port:000003E8 irq:4
  3: uart:unknown port:000002E8 irq:3
----- /proc/tty/driver/serial end -----
----- serial info -----
----- serial info end -----
>> serial.2: build list
>> misc.5: misc data
----- misc resources -----
i/o:0 0x0000 - 0x0cf7 (0xcf8) "PCI Bus 0000:00"
i/o:1 0x0000 - 0x001f (0x20) "dma1"
i/o:1 0x0020 - 0x0021 (0x02) "pic1"
i/o:0 0x0040 - 0x0043 (0x04) "timer0"
i/o:0 0x0050 - 0x0053 (0x04) "timer1"
i/o:1 0x0060 - 0x0060 (0x01) "keyboard"
i/o:1 0x0064 - 0x0064 (0x01) "keyboard"
i/o:0 0x0070 - 0x0071 (0x02) "rtc0"
i/o:1 0x0080 - 0x008f (0x10) "dma page reg"
i/o:1 0x00a0 - 0x00a1 (0x02) "pic2"
i/o:1 0x00c0 - 0x00df (0x20) "dma2"
i/o:1 0x00f0 - 0x00ff (0x10) "fpu"
i/o:0 0x0170 - 0x0177 (0x08) "0000:00:14.1"
i/o:0 0x0170 - 0x0177 (0x08) "pata_atiixp"
i/o:0 0x01f0 - 0x01f7 (0x08) "0000:00:14.1"
i/o:0 0x01f0 - 0x01f7 (0x08) "pata_atiixp"
i/o:0 0x0220 - 0x022f (0x10) "pnp 00:06"
i/o:0 0x0376 - 0x0376 (0x01) "0000:00:14.1"
i/o:0 0x0376 - 0x0376 (0x01) "pata_atiixp"
i/o:1 0x03c0 - 0x03df (0x20) "vga+"
i/o:0 0x03f6 - 0x03f6 (0x01) "0000:00:14.1"
i/o:0 0x03f6 - 0x03f6 (0x01) "pata_atiixp"
i/o:0 0x040b - 0x040b (0x01) "pnp 00:06"
i/o:0 0x04d0 - 0x04d1 (0x02) "pnp 00:06"
i/o:0 0x04d6 - 0x04d6 (0x01) "pnp 00:06"
i/o:0 0x0530 - 0x0537 (0x08) "pnp 00:06"
i/o:0 0x087f - 0x087f (0x01) "pnp 00:06"
i/o:0 0x0c00 - 0x0c01 (0x02) "pnp 00:06"
i/o:0 0x0c14 - 0x0c14 (0x01) "pnp 00:06"
i/o:0 0x0c50 - 0x0c52 (0x03) "pnp 00:06"
i/o:0 0x0c6c - 0x0c6c (0x01) "pnp 00:06"
i/o:0 0x0c6f - 0x0c6f (0x01) "pnp 00:06"
i/o:0 0x0cd0 - 0x0cd1 (0x02) "pnp 00:06"
i/o:0 0x0cd2 - 0x0cd3 (0x02) "pnp 00:06"
i/o:0 0x0cd4 - 0x0cd5 (0x02) "pnp 00:06"
i/o:0 0x0cd6 - 0x0cd7 (0x02) "pnp 00:06"
i/o:0 0x0cd8 - 0x0cdf (0x08) "pnp 00:06"
i/o:0 0x0cf8 - 0x0cff (0x08) "PCI conf1"
i/o:0 0x0d00 - 0xffff (0xf300) "PCI Bus 0000:00"
i/o:0 0x0f40 - 0x0f47 (0x08) "pnp 00:06"
i/o:0 0x0f50 - 0x0f51 (0x02) "pnp 00:01"
i/o:0 0x8000 - 0x805f (0x60) "pnp 00:06"
i/o:0 0x8000 - 0x8003 (0x04) "ACPI PM1a_EVT_BLK"
i/o:0 0x8004 - 0x8005 (0x02) "ACPI PM1a_CNT_BLK"
i/o:0 0x8008 - 0x800b (0x04) "ACPI PM_TMR"
i/o:0 0x8010 - 0x8015 (0x06) "ACPI CPU throttle"
i/o:0 0x8020 - 0x8027 (0x08) "ACPI GPE0_BLK"
i/o:0 0x8100 - 0x81ff (0x100) "pnp 00:06"
i/o:0 0x8200 - 0x82ff (0x100) "pnp 00:06"
i/o:0 0x8200 - 0x8200 (0x01) "ACPI PM2_CNT_BLK"
i/o:0 0x8400 - 0x840f (0x10) "0000:00:11.0"
i/o:0 0x8400 - 0x840f (0x10) "ahci"
i/o:0 0x8410 - 0x8413 (0x04) "0000:00:11.0"
i/o:0 0x8410 - 0x8413 (0x04) "ahci"
i/o:0 0x8420 - 0x8427 (0x08) "0000:00:11.0"
i/o:0 0x8420 - 0x8427 (0x08) "ahci"
i/o:0 0x8430 - 0x8433 (0x04) "0000:00:11.0"
i/o:0 0x8430 - 0x8433 (0x04) "ahci"
i/o:0 0x8440 - 0x8447 (0x08) "0000:00:11.0"
i/o:0 0x8440 - 0x8447 (0x08) "ahci"
i/o:0 0x8450 - 0x845f (0x10) "0000:00:14.1"
i/o:0 0x8450 - 0x845f (0x10) "pata_atiixp"
i/o:0 0x9000 - 0x9fff (0x1000) "PCI Bus 0000:01"
i/o:0 0x9000 - 0x90ff (0x100) "0000:01:05.0"
i/o:0 0xa000 - 0xafff (0x1000) "PCI Bus 0000:03"
i/o:0 0xa000 - 0xa07f (0x80) "0000:03:00.0"
i/o:0 0xa000 - 0xa07f (0x80) "atl1c"
irq:1  0 (  9960376) "timer"
irq:0  1 (   104561) "i8042"
irq:0  8 (        1) "rtc0"
irq:0  9 (    95891) "acpi"
irq:0 12 (   725981) "i8042"
irq:0 14 (        0) "pata_atiixp"
irq:0 15 (        0) "pata_atiixp"
irq:0 16 (    14810) "hda_intel"
irq:0 17 (  1169775) "ehci_hcd:usb1" "ehci_hcd:usb2" "ehci_hcd:usb3"
irq:0 18 (    44258) "ohci_hcd:usb4" "ohci_hcd:usb5" "ohci_hcd:usb6" "fglrx[0]@PCI:1:5:0"
irq:0 19 (       50) "hda_intel"
irq:0 42 (   883080) "ahci"
irq:0 43 (  3940104) "eth0"
dma:1 4 "cascade"
----- misc resources end -----
>> parallel.1: pp mod
----- exec: "/sbin/rmmod parport_pc" -----
----- return code: ? -----
----- exec: "/sbin/modprobe parport_pc" -----
----- return code: ? -----
----- exec: "/sbin/modprobe lp" -----
----- return code: ? -----
>> parallel.2.1: lp read info
>> parallel.2.2: lp read info
>> parallel.2.3: lp read info
----- parallel info -----
----- parallel info end -----
>> block.1: block modules
----- exec: "/sbin/modprobe ide-cd_mod " -----
  FATAL: Module ide_cd_mod not found.
----- return code: ? -----
----- exec: "/sbin/modprobe ide-disk " -----
  FATAL: Module ide_disk not found.
----- return code: ? -----
----- exec: "/sbin/modprobe sr_mod " -----
----- return code: ? -----
----- exec: "/sbin/modprobe sd_mod " -----
----- return code: ? -----
>> block.2: sysfs drivers
----- sysfs driver list (id 0x9a80bb7b28f699ee) -----
      serial8250: /devices/platform/serial8250
           i8042: /devices/platform/i8042
      parport_pc: module = parport_pc
        acer-wmi: module = acer_wmi
        acer-wmi: /devices/platform/acer-wmi
         vboxdrv: /devices/platform/vboxdrv.0
        pcieport: /devices/pci0000:00/0000:00:04.0
        pcieport: /devices/pci0000:00/0000:00:05.0
        ehci_hcd: /devices/pci0000:00/0000:00:12.2
        ehci_hcd: /devices/pci0000:00/0000:00:13.2
        ehci_hcd: /devices/pci0000:00/0000:00:16.2
        ehci_hcd: module = ehci_hcd
        ohci_hcd: /devices/pci0000:00/0000:00:12.0
        ohci_hcd: /devices/pci0000:00/0000:00:13.0
        ohci_hcd: /devices/pci0000:00/0000:00:16.0
        uhci_hcd: module = uhci_hcd
           atl1c: module = atl1c
           atl1c: /devices/pci0000:00/0000:00:04.0/0000:03:00.0
     pata_atiixp: /devices/pci0000:00/0000:00:14.1
     pata_atiixp: module = pata_atiixp
            ahci: /devices/pci0000:00/0000:00:11.0
            ahci: module = ahci
      parport_pc: module = parport_pc
     piix4_smbus: module = i2c_piix4
         k10temp: /devices/pci0000:00/0000:00:18.3
         k10temp: module = k10temp
          shpchp: module = shpchp
       fglrx_pci: /devices/pci0000:00/0000:00:01.0/0000:01:05.0
       fglrx_pci: module = fglrx
       HDA Intel: /devices/pci0000:00/0000:00:14.2
       HDA Intel: /devices/pci0000:00/0000:00:01.0/0000:01:05.1
       HDA Intel: module = snd_hda_intel
              ec: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00
        pci_root: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:00
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:01
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:02
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:03
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:04
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:05
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:06
        pci_link: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:07
             wmi: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00
             wmi: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:01
              ac: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00
          button: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00
          button: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00
          button: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00
          button: /devices/LNXSYSTM:00/LNXPWRBN:00
       processor: /devices/LNXSYSTM:00/LNXCPU:00
       processor: /devices/LNXSYSTM:00/LNXCPU:01
         thermal: /devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:01
         thermal: /devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:02
         battery: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00
           video: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02
          system: /devices/pnp0/00:01
          system: /devices/pnp0/00:06
          system: /devices/pnp0/00:07
       i8042 kbd: /devices/pnp0/00:08
       i8042 aux: /devices/pnp0/00:09
        rtc_cmos: /devices/pnp0/00:04
              sd: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
              sd: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
           usbfs: module = usbcore
             hub: module = usbcore
             hub: /devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
             hub: /devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
             hub: /devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
             hub: /devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
             hub: /devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
             hub: /devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
             usb: /devices/pci0000:00/0000:00:12.2/usb1
             usb: /devices/pci0000:00/0000:00:13.2/usb2
             usb: /devices/pci0000:00/0000:00:16.2/usb3
             usb: /devices/pci0000:00/0000:00:12.0/usb4
             usb: /devices/pci0000:00/0000:00:13.0/usb5
             usb: /devices/pci0000:00/0000:00:16.0/usb6
             usb: /devices/pci0000:00/0000:00:12.2/usb1/1-5
             usb: /devices/pci0000:00/0000:00:13.2/usb2/2-5
     usb-storage: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0
     usb-storage: module = usb_storage
          hiddev: module = usbhid
          usbhid: module = usbhid
        uvcvideo: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
        uvcvideo: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
        uvcvideo: module = uvcvideo
           atkbd: /devices/platform/i8042/serio0
       serio_raw: module = serio_raw
         psmouse: module = psmouse
         psmouse: /devices/platform/i8042/serio1
     generic-usb: module = usbhid
----- sysfs driver list end -----
>> block.3: cdrom
----- /proc/sys/dev/cdrom/info -----
drive name:	
drive speed:	
drive # of slots:
Can close tray:	
Can open tray:	
Can lock tray:	
Can change speed:
Can select disk:
Can read multisession:
Can read MCN:	
Reports media changed:
Can play audio:	
Can write CD-R:	
Can write CD-RW:
Can read DVD:	
Can write DVD-R:
Can write DVD-RAM:
Can read MRW:	
Can write MRW:	
Can write RAM:	
----- /proc/sys/dev/cdrom/info end -----
>> block.4: partition
----- /proc/partitions -----
     8        0  244198584 sda
     8        1  238938112 sda1
     8        2          1 sda2
     8        5    5258240 sda5
----- /proc/partitions end -----
disks:
  sda
partitions:
  sda1
  sda2
  sda5
>> block.5: get sysfs block dev data
-----  lsscsi -----
-----  lsscsi end -----
  block: name = ram0, path = /class/block/ram0
    dev = 1:0
    range = 1
  block: name = ram1, path = /class/block/ram1
    dev = 1:1
    range = 1
  block: name = ram2, path = /class/block/ram2
    dev = 1:2
    range = 1
  block: name = ram3, path = /class/block/ram3
    dev = 1:3
    range = 1
  block: name = ram4, path = /class/block/ram4
    dev = 1:4
    range = 1
  block: name = ram5, path = /class/block/ram5
    dev = 1:5
    range = 1
  block: name = ram6, path = /class/block/ram6
    dev = 1:6
    range = 1
  block: name = ram7, path = /class/block/ram7
    dev = 1:7
    range = 1
  block: name = ram8, path = /class/block/ram8
    dev = 1:8
    range = 1
  block: name = ram9, path = /class/block/ram9
    dev = 1:9
    range = 1
  block: name = ram10, path = /class/block/ram10
    dev = 1:10
    range = 1
  block: name = ram11, path = /class/block/ram11
    dev = 1:11
    range = 1
  block: name = ram12, path = /class/block/ram12
    dev = 1:12
    range = 1
  block: name = ram13, path = /class/block/ram13
    dev = 1:13
    range = 1
  block: name = ram14, path = /class/block/ram14
    dev = 1:14
    range = 1
  block: name = ram15, path = /class/block/ram15
    dev = 1:15
    range = 1
  block: name = loop0, path = /class/block/loop0
    dev = 7:0
    range = 1
  block: name = loop1, path = /class/block/loop1
    dev = 7:1
    range = 1
  block: name = loop2, path = /class/block/loop2
    dev = 7:2
    range = 1
  block: name = loop3, path = /class/block/loop3
    dev = 7:3
    range = 1
  block: name = loop4, path = /class/block/loop4
    dev = 7:4
    range = 1
  block: name = loop5, path = /class/block/loop5
    dev = 7:5
    range = 1
  block: name = loop6, path = /class/block/loop6
    dev = 7:6
    range = 1
  block: name = loop7, path = /class/block/loop7
    dev = 7:7
    range = 1
  block: name = sda, path = /class/block/sda
    dev = 8:0
    range = 16
    block device: bus = scsi, bus_id = 2:0:0:0 driver = sd
      path = /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
    vendor = ATA
    model = WDC WD2500BEVT-2
    rev = 01.0
    type = 0
>> block.5: /dev/sda
>> block.5.1: /dev/sda geo
  dev = /dev/sda, fd = 4
  open ok, fd = 4
/dev/sda: ioctl(geo) ok
/dev/sda: ioctl(block size) ok
/dev/sda: ioctl(disk size) ok
>> block.5.2: /dev/sda serial
  serial id len: 20
  block: name = sda1, path = /class/block/sda1
    dev = 8:1
  block: name = sda2, path = /class/block/sda2
    dev = 8:2
  block: name = sda5, path = /class/block/sda5
    dev = 8:5
  block: name = sdb, path = /class/block/sdb
    dev = 8:16
    range = 16
    block device: bus = scsi, bus_id = 3:0:0:0 driver = sd
      path = /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
    vendor = Generic-
    model = Multi-Card
    rev = 1.00
    type = 0
>> block.5: /dev/sdb
>> block.5.1: /dev/sdb geo
  dev = /dev/sdb, fd = 4
  open ok, fd = 4
/dev/sdb: ioctl(geo) ok
/dev/sdb: ioctl(block size) ok
/dev/sdb: ioctl(disk size) ok
>> block.5.2: /dev/sdb serial
  serial id len: 1
>> scsi.1: scsi modules
----- exec: "/sbin/modprobe sg " -----
----- return code: ? -----
>> scsi.2: scsi tape
sysfs: no such class: scsi_tape
>> scsi.3: scsi generic
  scsi: name = sg0, path = /class/scsi_generic/sg0
    dev = 21:0
    scsi device: bus_id = 2:0:0:0 driver = sd
      path = /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
  scsi: name = sg1, path = /class/scsi_generic/sg1
    dev = 21:1
    scsi device: bus_id = 3:0:0:0 driver = sd
      path = /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
>> usb.1: sysfs drivers
>> usb.2: usb
  usb dev: /devices/pci0000:00/0000:00:12.2/usb1
  usb dev: /devices/pci0000:00/0000:00:13.2/usb2
  usb dev: /devices/pci0000:00/0000:00:16.2/usb3
  usb dev: /devices/pci0000:00/0000:00:12.0/usb4
  usb dev: /devices/pci0000:00/0000:00:13.0/usb5
  usb dev: /devices/pci0000:00/0000:00:16.0/usb6
  usb dev: /devices/pci0000:00/0000:00:12.2/usb1/1-5
  usb dev: /devices/pci0000:00/0000:00:13.2/usb2/2-5
  usb device: name = usb1
    path = /devices/pci0000:00/0000:00:12.2/usb1
  usb device: name = 1-0:1.0
    path = /devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
    modalias = "usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 9
    bInterfaceSubClass = 0
    bInterfaceProtocol = 0
    if: 1-0:1.0 @ /devices/pci0000:00/0000:00:12.2/usb1
    bDeviceClass = 9
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x1d6b
    idProduct = 0x0002
    manufacturer = "Linux 2.6.35-24-generic ehci_hcd"
    product = "EHCI Host Controller"
    serial = "0000:00:12.2"
    bcdDevice = 0206
    speed = "480"
  usb device: name = usb2
    path = /devices/pci0000:00/0000:00:13.2/usb2
  usb device: name = 2-0:1.0
    path = /devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
    modalias = "usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 9
    bInterfaceSubClass = 0
    bInterfaceProtocol = 0
    if: 2-0:1.0 @ /devices/pci0000:00/0000:00:13.2/usb2
    bDeviceClass = 9
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x1d6b
    idProduct = 0x0002
    manufacturer = "Linux 2.6.35-24-generic ehci_hcd"
    product = "EHCI Host Controller"
    serial = "0000:00:13.2"
    bcdDevice = 0206
    speed = "480"
  usb device: name = usb3
    path = /devices/pci0000:00/0000:00:16.2/usb3
  usb device: name = 3-0:1.0
    path = /devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
    modalias = "usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 9
    bInterfaceSubClass = 0
    bInterfaceProtocol = 0
    if: 3-0:1.0 @ /devices/pci0000:00/0000:00:16.2/usb3
    bDeviceClass = 9
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x1d6b
    idProduct = 0x0002
    manufacturer = "Linux 2.6.35-24-generic ehci_hcd"
    product = "EHCI Host Controller"
    serial = "0000:00:16.2"
    bcdDevice = 0206
    speed = "480"
  usb device: name = usb4
    path = /devices/pci0000:00/0000:00:12.0/usb4
  usb device: name = 4-0:1.0
    path = /devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
    modalias = "usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 9
    bInterfaceSubClass = 0
    bInterfaceProtocol = 0
    if: 4-0:1.0 @ /devices/pci0000:00/0000:00:12.0/usb4
    bDeviceClass = 9
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x1d6b
    idProduct = 0x0001
    manufacturer = "Linux 2.6.35-24-generic ohci_hcd"
    product = "OHCI Host Controller"
    serial = "0000:00:12.0"
    bcdDevice = 0206
    speed = "12"
  usb device: name = usb5
    path = /devices/pci0000:00/0000:00:13.0/usb5
  usb device: name = 5-0:1.0
    path = /devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
    modalias = "usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 9
    bInterfaceSubClass = 0
    bInterfaceProtocol = 0
    if: 5-0:1.0 @ /devices/pci0000:00/0000:00:13.0/usb5
    bDeviceClass = 9
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x1d6b
    idProduct = 0x0001
    manufacturer = "Linux 2.6.35-24-generic ohci_hcd"
    product = "OHCI Host Controller"
    serial = "0000:00:13.0"
    bcdDevice = 0206
    speed = "12"
  usb device: name = usb6
    path = /devices/pci0000:00/0000:00:16.0/usb6
  usb device: name = 6-0:1.0
    path = /devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
    modalias = "usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 9
    bInterfaceSubClass = 0
    bInterfaceProtocol = 0
    if: 6-0:1.0 @ /devices/pci0000:00/0000:00:16.0/usb6
    bDeviceClass = 9
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x1d6b
    idProduct = 0x0001
    manufacturer = "Linux 2.6.35-24-generic ohci_hcd"
    product = "OHCI Host Controller"
    serial = "0000:00:16.0"
    bcdDevice = 0206
    speed = "12"
  usb device: name = 1-5
    path = /devices/pci0000:00/0000:00:12.2/usb1/1-5
  usb device: name = 1-5:1.0
    path = /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0
    modalias = "usb:v0BDAp0138d3882dc00dsc00dp00ic08isc06ip50"
    bInterfaceNumber = 0
    bInterfaceClass = 8
    bInterfaceSubClass = 6
    bInterfaceProtocol = 80
    if: 1-5:1.0 @ /devices/pci0000:00/0000:00:12.2/usb1/1-5
    bDeviceClass = 0
    bDeviceSubClass = 0
    bDeviceProtocol = 0
    idVendor = 0x0bda
    idProduct = 0x0138
    manufacturer = "Generic"
    product = "USB2.0-CRW"
    serial = "20090516388200000"
    bcdDevice = 3882
    speed = "480"
  usb device: name = 2-5
    path = /devices/pci0000:00/0000:00:13.2/usb2/2-5
  usb device: name = 2-5:1.0
    path = /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
    modalias = "usb:v064EpA219d0215dcEFdsc02dp01ic0Eisc01ip00"
    bInterfaceNumber = 0
    bInterfaceClass = 14
    bInterfaceSubClass = 1
    bInterfaceProtocol = 0
    if: 2-5:1.0 @ /devices/pci0000:00/0000:00:13.2/usb2/2-5
    bDeviceClass = 239
    bDeviceSubClass = 2
    bDeviceProtocol = 1
    idVendor = 0x064e
    idProduct = 0xa219
    manufacturer = "Suyin"
    product = "1.3M WebCam"
    serial = "HF1315-S32B-OV01-VA-R02.01.05"
    bcdDevice = 0215
    speed = "480"
  usb device: name = 2-5:1.1
    path = /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
    modalias = "usb:v064EpA219d0215dcEFdsc02dp01ic0Eisc02ip00"
    bInterfaceNumber = 1
    bInterfaceClass = 14
    bInterfaceSubClass = 2
    bInterfaceProtocol = 0
    if: 2-5:1.1 @ /devices/pci0000:00/0000:00:13.2/usb2/2-5
    bDeviceClass = 239
    bDeviceSubClass = 2
    bDeviceProtocol = 1
    idVendor = 0x064e
    idProduct = 0xa219
    manufacturer = "Suyin"
    product = "1.3M WebCam"
    serial = "HF1315-S32B-OV01-VA-R02.01.05"
    bcdDevice = 0215
    speed = "480"
removed: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
>> usb.3.1: joydev mod
>> usb.3.2: evdev mod
----- exec: "/sbin/modprobe evdev " -----
----- return code: ? -----
>> usb.3.3: input
  input: name = input0, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
    no dev - ignored
  input: name = input1, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
    no dev - ignored
  input: name = input2, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
    no dev - ignored
  input: name = input3, path = /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
    no dev - ignored
  input: name = mice, path = /devices/virtual/input/mice
    dev = 13:63
  input: name = event0, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0
    dev = 13:64
    input device: bus = acpi, bus_id = PNP0C0C:00 driver = button
      path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00
  input: name = event1, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1/event1
    dev = 13:65
    input device: bus = acpi, bus_id = PNP0C0D:00 driver = button
      path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00
  input: name = event2, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2/event2
    dev = 13:66
    input device: bus = acpi, bus_id = PNP0C0E:00 driver = button
      path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00
  input: name = event3, path = /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3
    dev = 13:67
    input device: bus = acpi, bus_id = LNXPWRBN:00 driver = button
      path = /devices/LNXSYSTM:00/LNXPWRBN:00
  input: name = input4, path = /devices/platform/i8042/serio0/input/input4
    no dev - ignored
  input: name = event4, path = /devices/platform/i8042/serio0/input/input4/event4
    dev = 13:68
    input device: bus = serio, bus_id = serio0 driver = atkbd
      path = /devices/platform/i8042/serio0
  input: name = input5, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5
    no dev - ignored
  input: name = event5, path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5/event5
    dev = 13:69
    input device: bus = acpi, bus_id = LNXVIDEO:02 driver = video
      path = /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02
  input: name = input6, path = /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6
    no dev - ignored
  input: name = event6, path = /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6/event6
    dev = 13:70
    input device: bus = usb, bus_id = 2-5:1.0 driver = uvcvideo
      path = /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
  input: name = input7, path = /devices/platform/i8042/serio1/input/input7
    no dev - ignored
  input: name = mouse0, path = /devices/platform/i8042/serio1/input/input7/mouse0
    dev = 13:32
    input device: bus = serio, bus_id = serio1 driver = psmouse
      path = /devices/platform/i8042/serio1
  input: name = event7, path = /devices/platform/i8042/serio1/input/input7/event7
    dev = 13:71
    input device: bus = serio, bus_id = serio1 driver = psmouse
      path = /devices/platform/i8042/serio1
>> usb.3.4: lp
sysfs: no such class: usb
>> usb.3.5: serial
>> edd.1: edd mod
----- exec: "/sbin/modprobe edd " -----
----- return code: ? -----
>> edd.2: edd info
>> modem.1: serial
******  started child process 31026 (15s/120s)  ******
******  stopped child process 31026 (120s)  ******
>> mouse.2: serial
******  started child process 31027 (20s/20s)  ******
******  stopped child process 31027 (20s)  ******
>> input.1: joydev mod
>> input.1.1: evdev mod
----- exec: "/sbin/modprobe evdev " -----
----- return code: ? -----
>> input.2: input
----- /proc/bus/input/devices -----
  I: Bus=0019 Vendor=0000 Product=0001 Version=0000
  N: Name="Power Button"
  P: Phys=PNP0C0C/button/input0
  S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
  U: Uniq=
  H: Handlers=kbd event0 
  B: EV=3
  B: KEY=10000000000000 0
  
  I: Bus=0019 Vendor=0000 Product=0005 Version=0000
  N: Name="Lid Switch"
  P: Phys=PNP0C0D/button/input0
  S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
  U: Uniq=
  H: Handlers=event1 
  B: EV=21
  B: SW=1
  
  I: Bus=0019 Vendor=0000 Product=0003 Version=0000
  N: Name="Sleep Button"
  P: Phys=PNP0C0E/button/input0
  S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
  U: Uniq=
  H: Handlers=kbd event2 
  B: EV=3
  B: KEY=4000 0 0
  
  I: Bus=0019 Vendor=0000 Product=0001 Version=0000
  N: Name="Power Button"
  P: Phys=LNXPWRBN/button/input0
  S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
  U: Uniq=
  H: Handlers=kbd event3 
  B: EV=3
  B: KEY=10000000000000 0
  
  I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
  N: Name="AT Translated Set 2 keyboard"
  P: Phys=isa0060/serio0/input0
  S: Sysfs=/devices/platform/i8042/serio0/input/input4
  U: Uniq=
  H: Handlers=sysrq kbd event4 
  B: EV=120013
  B: KEY=10000 c020000000000 0 0 700f02000003 3803078f830f401 febfffdfffefffff fffffffffffffffe
  B: MSC=10
  B: LED=7
  
  I: Bus=0019 Vendor=0000 Product=0006 Version=0000
  N: Name="Video Bus"
  P: Phys=LNXVIDEO/video/input0
  S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5
  U: Uniq=
  H: Handlers=kbd event5 
  B: EV=3
  B: KEY=3e000b00000000 0 0 0
  
  I: Bus=0003 Vendor=064e Product=a219 Version=0215
  N: Name="1.3M WebCam"
  P: Phys=usb-0000:00:13.2-5/button
  S: Sysfs=/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6
  U: Uniq=
  H: Handlers=kbd event6 
  B: EV=3
  B: KEY=100000 0 0 0
  
  I: Bus=0011 Vendor=0002 Product=0001 Version=0000
  N: Name="PS/2 Generic Mouse"
  P: Phys=isa0060/serio1/input0
  S: Sysfs=/devices/platform/i8042/serio1/input/input7
  U: Uniq=
  H: Handlers=mouse0 event7 
  B: EV=7
  B: KEY=70000 0 0 0 0
  B: REL=3
  
----- /proc/bus/input/devices end -----
bus = 25, name = Power Button
  handlers = kbd event0
  key = 00100000000000000000000000000000
  mouse buttons = 0
  mouse wheels = 0
bus = 25, name = Lid Switch
  handlers = event1
  mouse buttons = 0
  mouse wheels = 0
bus = 25, name = Sleep Button
  handlers = kbd event2
  key = 000000000000400000000000000000000000000000000000
  mouse buttons = 0
  mouse wheels = 0
bus = 25, name = Power Button
  handlers = kbd event3
  key = 00100000000000000000000000000000
  mouse buttons = 0
  mouse wheels = 0
bus = 17, name = AT Translated Set 2 keyboard
  handlers = sysrq kbd event4
  key = 0000000000010000000c020000000000000000000000000000000000000000000000700f0200000303803078f830f401febfffdfffeffffffffffffffffffffe
  mouse buttons = 0
  mouse wheels = 0
bus = 25, name = Video Bus
  handlers = kbd event5
  key = 003e000b00000000000000000000000000000000000000000000000000000000
  mouse buttons = 0
  mouse wheels = 0
bus = 3, name = 1.3M WebCam
  handlers = kbd event6
  key = 0000000000100000000000000000000000000000000000000000000000000000
  mouse buttons = 0
  mouse wheels = 0
bus = 17, name = PS/2 Generic Mouse
  handlers = mouse0 event7
  key = 00000000000700000000000000000000000000000000000000000000000000000000000000000000
  rel = 0000000000000003
  mouse buttons = 3
  mouse wheels = 0
>> kbd.2: uml
>> cpu.1: cpuinfo
----- /proc/cpuinfo -----
  processor	: 0
  vendor_id	: AuthenticAMD
  cpu family	: 16
  model		: 6
  model name	: AMD Athlon(tm) II Neo K325 Dual-Core Processor
  stepping	: 3
  cpu MHz		: 800.000
  cache size	: 1024 KB
  physical id	: 0
  siblings	: 2
  core id		: 0
  cpu cores	: 2
  apicid		: 0
  initial apicid	: 0
  fpu		: yes
  fpu_exception	: yes
  cpuid level	: 5
  wp		: yes
  flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt lbrv svm_lock nrip_save
  bogomips	: 2593.53
  TLB size	: 1024 4K pages
  clflush size	: 64
  cache_alignment	: 64
  address sizes	: 48 bits physical, 48 bits virtual
  power management: ts ttp tm stc 100mhzsteps hwpstate
  
  processor	: 1
  vendor_id	: AuthenticAMD
  cpu family	: 16
  model		: 6
  model name	: AMD Athlon(tm) II Neo K325 Dual-Core Processor
  stepping	: 3
  cpu MHz		: 1100.000
  cache size	: 1024 KB
  physical id	: 0
  siblings	: 2
  core id		: 1
  cpu cores	: 2
  apicid		: 1
  initial apicid	: 1
  fpu		: yes
  fpu_exception	: yes
  cpuid level	: 5
  wp		: yes
  flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt lbrv svm_lock nrip_save
  bogomips	: 2593.50
  TLB size	: 1024 4K pages
  clflush size	: 64
  cache_alignment	: 64
  address sizes	: 48 bits physical, 48 bits virtual
  power management: ts ttp tm stc 100mhzsteps hwpstate
  
----- /proc/cpuinfo end -----
>> kbd.3: serial console
>> fb.1: read info
>> net.1: get network data
  net interface: name = lo, path = /class/net/lo
    type = 772
    carrier = 1
    hw_addr = 00:00:00:00:00:00
    GDRVINFO ethtool error: Operation not supported
  net interface: name = eth0, path = /class/net/eth0
    type = 1
    carrier = 1
    hw_addr = 20:6a:8a:0b:39:bf
    net device: path = /devices/pci0000:00/0000:00:04.0/0000:03:00.0
    net driver: name = atl1c, path = /bus/pci/drivers/atl1c
  net interface: name = vboxnet0, path = /class/net/vboxnet0
    type = 1
    hw_addr = 0a:00:27:00:00:00
    GDRVINFO ethtool error: Operation not supported
>> net.2: eeprom dump
>> net.2: eeprom dump
>> net.2: eeprom dump
  vboxnet0: GLINK ethtool error: Operation not supported
>> pppoe.1: looking for pppoe
>> pppoe.2: discovery
Attempt number 1
eth0: Sending PADI packet
vboxnet0: Sending PADI packet
send failed: Network is down
recv failed: Network is down
Timeout waiting for PADO packets
Attempt number 2
eth0: Sending PADI packet
vboxnet0: Sending PADI packet
send failed: Network is down
Timeout waiting for PADO packets
>> wlan.1: detecting wlan features
>> wlan.2: assign udi
>> isdn.1: list
>> dsl.1: list
>> int.2: cdrom
>> int.3: media
>> int.4.1: /dev/sda
  read_block0: 512 bytes (4s, 999995us)
  mbr sig: 0x000d24f0
>> int.4.2: /dev/sdb
  read_block0: open(/dev/sdb) failed
>> int.4: floppy
>> int.5: edd
>> int.5.1: bios
  bios ctrl 0: 16
  bios ctrl 1: 18
  bios ctrl 2: 42
>> int.6: mouse
>> int.15: system info
  system type: notebook
  acpi: 1
>> int.7: hdb
>> int.7.1: modules
>> int.8: usbscsi
>> int.9: hotplug
>> int.10: modem
>> int.11: wlan
>> int.12: udev
-----  udevinfo -----
  P: /devices/LNXSYSTM:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:LNXSYSTM:
  
  P: /devices/LNXSYSTM:00/LNXCPU:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXCPU:00
  E: SUBSYSTEM=acpi
  E: DRIVER=processor
  E: MODALIAS=acpi:LNXCPU:
  
  P: /devices/LNXSYSTM:00/LNXCPU:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXCPU:01
  E: SUBSYSTEM=acpi
  E: DRIVER=processor
  E: MODALIAS=acpi:LNXCPU:
  
  P: /devices/LNXSYSTM:00/LNXPWRBN:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXPWRBN:00
  E: SUBSYSTEM=acpi
  E: DRIVER=button
  E: MODALIAS=acpi:LNXPWRBN:
  
  P: /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
  E: SUBSYSTEM=input
  E: PRODUCT=19/0/1/0
  E: NAME="Power Button"
  E: PHYS="LNXPWRBN/button/input0"
  E: EV==3
  E: KEY==10000000000000 0
  E: MODALIAS=input:b0019v0000p0001e0000-e0,1,k74,ramlsfw
  
  P: /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3
  N: input/event3
  S: char/13:67
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3
  E: SUBSYSTEM=input
  E: DEVNAME=input/event3
  E: ID_INPUT=1
  E: ID_INPUT_KEY=1
  E: XKBMODEL=pc105
  E: XKBLAYOUT=us
  E: MAJOR=13
  E: MINOR=67
  E: DEVLINKS=/dev/char/13:67
  E: DMI_VENDOR=Acer
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:LNXSYBUS:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_root
  E: MODALIAS=acpi:PNP0A08:PNP0A03:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C02:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C02:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0C02:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:LNXVIDEO:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:01
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:02
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:02
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:03
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:03
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:04
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:04
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/device:05
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/device:05
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:LNXVIDEO:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:07
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:07
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:08
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:08
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:09
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:09
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:0a
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:0a
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/device:0b
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/device:0b
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/device:0d
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/device:0d
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e/device:0f
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e/device:0f
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10/device:11
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10/device:11
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12/device:13
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12/device:13
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14/device:15
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14/device:15
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:16
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:16
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:16/device:17
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:16/device:17
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/device:19
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/device:19
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/device:19/device:1a
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/device:19/device:1a
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b/device:1c
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b/device:1c
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b/device:1c/device:1d
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b/device:1c/device:1d
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:21
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:21
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23/device:24
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23/device:24
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23/device:25
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23/device:25
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27/device:28
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27/device:28
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27/device:29
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27/device:29
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b/device:2c
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b/device:2c
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b/device:2d
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b/device:2d
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2e
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2e
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2f
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2f
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:30
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:30
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:32
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:32
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:33
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:33
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:34
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:34
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:35
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:35
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0000:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0000:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0000:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0100:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0100:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0100:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0200:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0200:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0200:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0303:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0303:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0303:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0800:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0800:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0800:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0B00:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0B00:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0B00:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C01:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C01:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0C01:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C02:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C02:01
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0C02:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C04:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C04:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:PNP0C04:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00
  E: SUBSYSTEM=acpi
  E: DRIVER=ec
  E: MODALIAS=acpi:PNP0C09:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00
  E: SUBSYSTEM=acpi
  E: DRIVER=ac
  E: MODALIAS=acpi:ACPI0003:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00/power_supply/ADP1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00/power_supply/ADP1
  E: SUBSYSTEM=power_supply
  E: POWER_SUPPLY_NAME=ADP1
  E: POWER_SUPPLY_ONLINE=1
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00
  E: SUBSYSTEM=acpi
  E: DRIVER=battery
  E: MODALIAS=acpi:PNP0C0A:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00/power_supply/BAT0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00/power_supply/BAT0
  E: SUBSYSTEM=power_supply
  E: POWER_SUPPLY_NAME=BAT0
  E: POWER_SUPPLY_STATUS=Full
  E: POWER_SUPPLY_PRESENT=1
  E: POWER_SUPPLY_TECHNOLOGY=Li-ion
  E: POWER_SUPPLY_CYCLE_COUNT=0
  E: POWER_SUPPLY_VOLTAGE_MIN_DESIGN=11100000
  E: POWER_SUPPLY_VOLTAGE_NOW=12834000
  E: POWER_SUPPLY_CURRENT_NOW=0
  E: POWER_SUPPLY_CHARGE_FULL_DESIGN=4400000
  E: POWER_SUPPLY_CHARGE_FULL=3852000
  E: POWER_SUPPLY_CHARGE_NOW=3852000
  E: POWER_SUPPLY_MODEL_NAME=AL10C31
  E: POWER_SUPPLY_MANUFACTURER=SANYO
  E: POWER_SUPPLY_SERIAL_NUMBER=10814
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:00
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:01
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:02
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:02
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:03
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:03
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:04
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:04
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:05
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:05
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:06
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:06
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:07
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:07
  E: SUBSYSTEM=acpi
  E: DRIVER=pci_link
  E: MODALIAS=acpi:PNP0C0F:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/SYN1B37:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/SYN1B37:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:SYN1B37:SYN1B00:SYN0002:PNP0F13:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:37
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:37
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:38
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:38
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:38/device:39
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:38/device:39
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a/device:3b
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a/device:3b
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3c
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3c
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3d
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3d
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02
  E: SUBSYSTEM=acpi
  E: DRIVER=video
  E: MODALIAS=acpi:LNXVIDEO:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:3f
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:3f
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:40
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:40
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:41
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:41
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:42
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:42
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:device:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5
  E: SUBSYSTEM=input
  E: PRODUCT=19/0/6/0
  E: NAME="Video Bus"
  E: PHYS="LNXVIDEO/video/input0"
  E: EV==3
  E: KEY==3e000b00000000 0 0 0
  E: MODALIAS=input:b0019v0000p0006e0000-e0,1,kE0,E1,E3,F1,F2,F3,F4,F5,ramlsfw
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5/event5
  N: input/event5
  S: char/13:69
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5/event5
  E: SUBSYSTEM=input
  E: DEVNAME=input/event5
  E: ID_INPUT=1
  E: ID_INPUT_KEY=1
  E: XKBMODEL=pc105
  E: XKBLAYOUT=us
  E: MAJOR=13
  E: MINOR=69
  E: DEVLINKS=/dev/char/13:69
  E: DMI_VENDOR=Acer
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00
  E: SUBSYSTEM=acpi
  E: DRIVER=button
  E: MODALIAS=acpi:PNP0C0C:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
  E: SUBSYSTEM=input
  E: PRODUCT=19/0/1/0
  E: NAME="Power Button"
  E: PHYS="PNP0C0C/button/input0"
  E: EV==3
  E: KEY==10000000000000 0
  E: MODALIAS=input:b0019v0000p0001e0000-e0,1,k74,ramlsfw
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0
  N: input/event0
  S: char/13:64
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0
  E: SUBSYSTEM=input
  E: DEVNAME=input/event0
  E: ID_INPUT=1
  E: ID_INPUT_KEY=1
  E: XKBMODEL=pc105
  E: XKBLAYOUT=us
  E: MAJOR=13
  E: MINOR=64
  E: DEVLINKS=/dev/char/13:64
  E: DMI_VENDOR=Acer
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00
  E: SUBSYSTEM=acpi
  E: DRIVER=button
  E: MODALIAS=acpi:PNP0C0D:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
  E: SUBSYSTEM=input
  E: PRODUCT=19/0/5/0
  E: NAME="Lid Switch"
  E: PHYS="PNP0C0D/button/input0"
  E: EV==21
  E: SW==1
  E: MODALIAS=input:b0019v0000p0005e0000-e0,5,kramlsfw0,
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1/event1
  N: input/event1
  S: char/13:65
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1/event1
  E: SUBSYSTEM=input
  E: DEVNAME=input/event1
  E: ID_INPUT=1
  E: DMI_VENDOR=Acer
  E: MAJOR=13
  E: MINOR=65
  E: DEVLINKS=/dev/char/13:65
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00
  E: SUBSYSTEM=acpi
  E: DRIVER=button
  E: MODALIAS=acpi:PNP0C0E:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
  E: SUBSYSTEM=input
  E: PRODUCT=19/0/3/0
  E: NAME="Sleep Button"
  E: PHYS="PNP0C0E/button/input0"
  E: EV==3
  E: KEY==4000 0 0
  E: MODALIAS=input:b0019v0000p0003e0000-e0,1,k8E,ramlsfw
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2/event2
  N: input/event2
  S: char/13:66
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2/event2
  E: SUBSYSTEM=input
  E: DEVNAME=input/event2
  E: ID_INPUT=1
  E: ID_INPUT_KEY=1
  E: XKBMODEL=pc105
  E: XKBLAYOUT=us
  E: MAJOR=13
  E: MINOR=66
  E: DEVLINKS=/dev/char/13:66
  E: DMI_VENDOR=Acer
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00
  E: SUBSYSTEM=acpi
  E: DRIVER=wmi
  E: MODALIAS=acpi:PNP0C14:
  
  P: /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:01
  E: SUBSYSTEM=acpi
  E: DRIVER=wmi
  E: MODALIAS=acpi:PNP0C14:
  
  P: /devices/LNXSYSTM:00/LNXTHERM:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXTHERM:00
  E: SUBSYSTEM=acpi
  E: MODALIAS=acpi:LNXTHERM:
  
  P: /devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:01
  E: SUBSYSTEM=acpi
  E: DRIVER=thermal
  E: MODALIAS=acpi:LNXTHERM:
  
  P: /devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:02
  E: UDEV_LOG=3
  E: DEVPATH=/devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:02
  E: SUBSYSTEM=acpi
  E: DRIVER=thermal
  E: MODALIAS=acpi:LNXTHERM:
  
  P: /devices/pci0000:00/0000:00:00.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:00.0
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60000
  E: PCI_ID=1022:9601
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:00.0
  E: MODALIAS=pci:v00001022d00009601sv00001025sd00000429bc06sc00i00
  
  P: /devices/pci0000:00/0000:00:01.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60400
  E: PCI_ID=1025:9602
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:01.0
  E: MODALIAS=pci:v00001025d00009602sv00001025sd00000429bc06sc04i00
  
  P: /devices/pci0000:00/0000:00:01.0/0000:01:05.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:05.0
  E: SUBSYSTEM=pci
  E: DRIVER=fglrx_pci
  E: PCI_CLASS=30000
  E: PCI_ID=1002:9712
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:01:05.0
  E: MODALIAS=pci:v00001002d00009712sv00001025sd00000429bc03sc00i00
  
  P: /devices/pci0000:00/0000:00:01.0/0000:01:05.1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:05.1
  E: SUBSYSTEM=pci
  E: DRIVER=HDA Intel
  E: PCI_CLASS=40300
  E: PCI_ID=1002:970F
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:01:05.1
  E: MODALIAS=pci:v00001002d0000970Fsv00001025sd00000429bc04sc03i00
  
  P: /devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1
  E: SUBSYSTEM=sound
  E: SOUND_INITIALIZED=1
  E: ID_VENDOR_FROM_DATABASE=ATI Technologies Inc
  E: ID_MODEL_FROM_DATABASE=RS880 Audio Device [Radeon HD 4200]
  E: ID_BUS=pci
  E: ID_VENDOR_ID=0x1002
  E: ID_MODEL_ID=0x970f
  E: ID_PATH=pci-0000:01:05.1
  
  P: /devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/hwC1D0
  N: snd/hwC1D0
  S: char/116:10
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/hwC1D0
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/hwC1D0
  E: MAJOR=116
  E: MINOR=10
  E: DEVLINKS=/dev/char/116:10
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/pcmC1D3p
  N: snd/pcmC1D3p
  S: char/116:9
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/pcmC1D3p
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/pcmC1D3p
  E: MAJOR=116
  E: MINOR=9
  E: DEVLINKS=/dev/char/116:9
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/controlC1
  N: snd/controlC1
  S: char/116:11
  S: snd/by-path/pci-0000:01:05.1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/controlC1
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/controlC1
  E: ID_PATH=pci-0000:01:05.1
  E: MAJOR=116
  E: MINOR=11
  E: DEVLINKS=/dev/char/116:11 /dev/snd/by-path/pci-0000:01:05.1
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:01.0/pci_bus/0000:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:01.0/pci_bus/0000:01
  E: SUBSYSTEM=pci_bus
  
  P: /devices/pci0000:00/0000:00:04.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:04.0
  E: SUBSYSTEM=pci
  E: DRIVER=pcieport
  E: PCI_CLASS=60400
  E: PCI_ID=1022:9604
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:04.0
  E: MODALIAS=pci:v00001022d00009604sv00001025sd00000429bc06sc04i00
  
  P: /devices/pci0000:00/0000:00:04.0/0000:00:04.0:pcie01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:04.0/0000:00:04.0:pcie01
  E: SUBSYSTEM=pci_express
  
  P: /devices/pci0000:00/0000:00:04.0/0000:00:04.0:pcie08
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:04.0/0000:00:04.0:pcie08
  E: SUBSYSTEM=pci_express
  
  P: /devices/pci0000:00/0000:00:04.0/0000:03:00.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:04.0/0000:03:00.0
  E: SUBSYSTEM=pci
  E: DRIVER=atl1c
  E: PCI_CLASS=20000
  E: PCI_ID=1969:1073
  E: PCI_SUBSYS_ID=1025:040D
  E: PCI_SLOT_NAME=0000:03:00.0
  E: MODALIAS=pci:v00001969d00001073sv00001025sd0000040Dbc02sc00i00
  
  P: /devices/pci0000:00/0000:00:04.0/0000:03:00.0/net/eth0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:04.0/0000:03:00.0/net/eth0
  E: SUBSYSTEM=net
  E: ID_VENDOR_FROM_DATABASE=Atheros Communications
  E: ID_MODEL_FROM_DATABASE=AR8151 v1.0 Gigabit Ethernet
  E: ID_BUS=pci
  E: ID_VENDOR_ID=0x1969
  E: ID_MODEL_ID=0x1073
  E: INTERFACE=eth0
  E: IFINDEX=5
  
  P: /devices/pci0000:00/0000:00:04.0/pci_bus/0000:03
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:04.0/pci_bus/0000:03
  E: SUBSYSTEM=pci_bus
  
  P: /devices/pci0000:00/0000:00:05.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:05.0
  E: SUBSYSTEM=pci
  E: DRIVER=pcieport
  E: PCI_CLASS=60400
  E: PCI_ID=1022:9605
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:05.0
  E: MODALIAS=pci:v00001022d00009605sv00001025sd00000429bc06sc04i00
  
  P: /devices/pci0000:00/0000:00:05.0/0000:00:05.0:pcie01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:05.0/0000:00:05.0:pcie01
  E: SUBSYSTEM=pci_express
  
  P: /devices/pci0000:00/0000:00:05.0/0000:00:05.0:pcie08
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:05.0/0000:00:05.0:pcie08
  E: SUBSYSTEM=pci_express
  
  P: /devices/pci0000:00/0000:00:05.0/0000:06:00.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:05.0/0000:06:00.0
  E: SUBSYSTEM=pci
  E: PCI_CLASS=28000
  E: PCI_ID=14E4:4357
  E: PCI_SUBSYS_ID=105B:E021
  E: PCI_SLOT_NAME=0000:06:00.0
  E: MODALIAS=pci:v000014E4d00004357sv0000105Bsd0000E021bc02sc80i00
  
  P: /devices/pci0000:00/0000:00:05.0/pci_bus/0000:06
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:05.0/pci_bus/0000:06
  E: SUBSYSTEM=pci_bus
  
  P: /devices/pci0000:00/0000:00:11.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0
  E: SUBSYSTEM=pci
  E: ID_VENDOR_FROM_DATABASE=ATI Technologies Inc
  E: ID_MODEL_FROM_DATABASE=SB700/SB800 SATA Controller [AHCI mode]
  E: DRIVER=ahci
  E: PCI_CLASS=10601
  E: PCI_ID=1002:4391
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:11.0
  E: MODALIAS=pci:v00001002d00004391sv00001025sd00000429bc01sc06i01
  
  P: /devices/pci0000:00/0000:00:11.0/host2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_host
  
  P: /devices/pci0000:00/0000:00:11.0/host2/scsi_host/host2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/scsi_host/host2
  E: SUBSYSTEM=scsi_host
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_target
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_device
  E: DRIVER=sd
  E: MODALIAS=scsi:t-0x00
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda
  N: sda
  S: block/8:0
  S: disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727
  S: disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727
  S: disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0
  S: disk/by-id/wwn-0x50014ee2af462d20
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda
  E: SUBSYSTEM=block
  E: DEVNAME=sda
  E: ID_ATA=1
  E: ID_TYPE=disk
  E: ID_BUS=ata
  E: ID_MODEL=WDC_WD2500BEVT-22A23T0
  E: ID_MODEL_ENC=WDC\x20WD2500BEVT-22A23T0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
  E: ID_REVISION=01.01A10
  E: ID_SERIAL=WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727
  E: ID_SERIAL_SHORT=WD-WXJ1A50D8727
  E: ID_ATA_WRITE_CACHE=1
  E: ID_ATA_WRITE_CACHE_ENABLED=1
  E: ID_ATA_FEATURE_SET_HPA=1
  E: ID_ATA_FEATURE_SET_HPA_ENABLED=1
  E: ID_ATA_FEATURE_SET_PM=1
  E: ID_ATA_FEATURE_SET_PM_ENABLED=1
  E: ID_ATA_FEATURE_SET_SECURITY=1
  E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
  E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_FROZEN=1
  E: ID_ATA_FEATURE_SET_SMART=1
  E: ID_ATA_FEATURE_SET_SMART_ENABLED=1
  E: ID_ATA_FEATURE_SET_AAM=1
  E: ID_ATA_FEATURE_SET_AAM_ENABLED=0
  E: ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
  E: ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
  E: ID_ATA_FEATURE_SET_APM=1
  E: ID_ATA_FEATURE_SET_APM_ENABLED=1
  E: ID_ATA_FEATURE_SET_APM_CURRENT_VALUE=254
  E: ID_ATA_DOWNLOAD_MICROCODE=1
  E: ID_ATA_SATA=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
  E: ID_ATA_ROTATION_RATE_RPM=5400
  E: ID_WWN=0x50014ee2af462d20
  E: ID_WWN_WITH_EXTENSION=0x50014ee2af462d20
  E: ID_SCSI_COMPAT=SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727
  E: ID_PATH=pci-0000:00:11.0-scsi-0:0:0:0
  E: ID_PART_TABLE_TYPE=dos
  E: UDISKS_PRESENTATION_NOPOLICY=0
  E: UDISKS_PARTITION_TABLE=1
  E: UDISKS_PARTITION_TABLE_SCHEME=mbr
  E: UDISKS_PARTITION_TABLE_COUNT=3
  E: UDISKS_ATA_SMART_IS_AVAILABLE=1
  E: MAJOR=8
  E: MINOR=0
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/8:0 /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727 /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0 /dev/disk/by-id/wwn-0x50014ee2af462d20
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda1
  N: sda1
  S: block/8:1
  S: disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part1
  S: disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part1
  S: disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part1
  S: disk/by-uuid/85c51aea-99ce-4a1a-9c1a-5af285a7f145
  S: disk/by-id/wwn-0x50014ee2af462d20-part1
  S: root
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda1
  E: SUBSYSTEM=block
  E: DEVNAME=sda1
  E: ID_ATA=1
  E: ID_TYPE=disk
  E: ID_BUS=ata
  E: ID_MODEL=WDC_WD2500BEVT-22A23T0
  E: ID_MODEL_ENC=WDC\x20WD2500BEVT-22A23T0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
  E: ID_REVISION=01.01A10
  E: ID_SERIAL=WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727
  E: ID_SERIAL_SHORT=WD-WXJ1A50D8727
  E: ID_ATA_WRITE_CACHE=1
  E: ID_ATA_WRITE_CACHE_ENABLED=1
  E: ID_ATA_FEATURE_SET_HPA=1
  E: ID_ATA_FEATURE_SET_HPA_ENABLED=1
  E: ID_ATA_FEATURE_SET_PM=1
  E: ID_ATA_FEATURE_SET_PM_ENABLED=1
  E: ID_ATA_FEATURE_SET_SECURITY=1
  E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
  E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_FROZEN=1
  E: ID_ATA_FEATURE_SET_SMART=1
  E: ID_ATA_FEATURE_SET_SMART_ENABLED=1
  E: ID_ATA_FEATURE_SET_AAM=1
  E: ID_ATA_FEATURE_SET_AAM_ENABLED=0
  E: ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
  E: ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
  E: ID_ATA_FEATURE_SET_APM=1
  E: ID_ATA_FEATURE_SET_APM_ENABLED=1
  E: ID_ATA_FEATURE_SET_APM_CURRENT_VALUE=254
  E: ID_ATA_DOWNLOAD_MICROCODE=1
  E: ID_ATA_SATA=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
  E: ID_ATA_ROTATION_RATE_RPM=5400
  E: ID_WWN=0x50014ee2af462d20
  E: ID_WWN_WITH_EXTENSION=0x50014ee2af462d20
  E: ID_SCSI_COMPAT=SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727
  E: ID_PATH=pci-0000:00:11.0-scsi-0:0:0:0
  E: ID_PART_TABLE_TYPE=dos
  E: ID_FS_UUID=85c51aea-99ce-4a1a-9c1a-5af285a7f145
  E: ID_FS_UUID_ENC=85c51aea-99ce-4a1a-9c1a-5af285a7f145
  E: ID_FS_VERSION=1.0
  E: ID_FS_TYPE=ext4
  E: ID_FS_USAGE=filesystem
  E: UDISKS_PRESENTATION_NOPOLICY=0
  E: UDISKS_PARTITION=1
  E: UDISKS_PARTITION_SCHEME=mbr
  E: UDISKS_PARTITION_NUMBER=1
  E: UDISKS_PARTITION_TYPE=0x83
  E: UDISKS_PARTITION_SIZE=244672626688
  E: UDISKS_PARTITION_FLAGS=boot
  E: UDISKS_PARTITION_SLAVE=/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda
  E: UDISKS_PARTITION_OFFSET=1048576
  E: UDISKS_PARTITION_ALIGNMENT_OFFSET=0
  E: MAJOR=8
  E: MINOR=1
  E: DEVTYPE=partition
  E: DEVLINKS=/dev/block/8:1 /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part1 /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part1 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part1 /dev/disk/by-uuid/85c51aea-99ce-4a1a-9c1a-5af285a7f145 /dev/disk/by-id/wwn-0x50014ee2af462d20-part1 /dev/root
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda2
  N: sda2
  S: block/8:2
  S: disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part2
  S: disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part2
  S: disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2
  S: disk/by-id/wwn-0x50014ee2af462d20-part2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda2
  E: SUBSYSTEM=block
  E: DEVNAME=sda2
  E: ID_ATA=1
  E: ID_TYPE=disk
  E: ID_BUS=ata
  E: ID_MODEL=WDC_WD2500BEVT-22A23T0
  E: ID_MODEL_ENC=WDC\x20WD2500BEVT-22A23T0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
  E: ID_REVISION=01.01A10
  E: ID_SERIAL=WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727
  E: ID_SERIAL_SHORT=WD-WXJ1A50D8727
  E: ID_ATA_WRITE_CACHE=1
  E: ID_ATA_WRITE_CACHE_ENABLED=1
  E: ID_ATA_FEATURE_SET_HPA=1
  E: ID_ATA_FEATURE_SET_HPA_ENABLED=1
  E: ID_ATA_FEATURE_SET_PM=1
  E: ID_ATA_FEATURE_SET_PM_ENABLED=1
  E: ID_ATA_FEATURE_SET_SECURITY=1
  E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
  E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_FROZEN=1
  E: ID_ATA_FEATURE_SET_SMART=1
  E: ID_ATA_FEATURE_SET_SMART_ENABLED=1
  E: ID_ATA_FEATURE_SET_AAM=1
  E: ID_ATA_FEATURE_SET_AAM_ENABLED=0
  E: ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
  E: ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
  E: ID_ATA_FEATURE_SET_APM=1
  E: ID_ATA_FEATURE_SET_APM_ENABLED=1
  E: ID_ATA_FEATURE_SET_APM_CURRENT_VALUE=254
  E: ID_ATA_DOWNLOAD_MICROCODE=1
  E: ID_ATA_SATA=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
  E: ID_ATA_ROTATION_RATE_RPM=5400
  E: ID_WWN=0x50014ee2af462d20
  E: ID_WWN_WITH_EXTENSION=0x50014ee2af462d20
  E: ID_SCSI_COMPAT=SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727
  E: ID_PATH=pci-0000:00:11.0-scsi-0:0:0:0
  E: ID_PART_TABLE_TYPE=dos
  E: UDISKS_PRESENTATION_NOPOLICY=0
  E: UDISKS_PARTITION=1
  E: UDISKS_PARTITION_SCHEME=mbr
  E: UDISKS_PARTITION_NUMBER=2
  E: UDISKS_PARTITION_TYPE=0x05
  E: UDISKS_PARTITION_SIZE=5384438784
  E: UDISKS_PARTITION_SLAVE=/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda
  E: UDISKS_PARTITION_OFFSET=244674722816
  E: UDISKS_PARTITION_ALIGNMENT_OFFSET=0
  E: MAJOR=8
  E: MINOR=2
  E: DEVTYPE=partition
  E: DEVLINKS=/dev/block/8:2 /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part2 /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part2 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2 /dev/disk/by-id/wwn-0x50014ee2af462d20-part2
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda5
  N: sda5
  S: block/8:5
  S: disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part5
  S: disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part5
  S: disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part5
  S: disk/by-uuid/6138fe8c-9476-4396-aa5f-a88c0dc55e29
  S: disk/by-id/wwn-0x50014ee2af462d20-part5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda5
  E: SUBSYSTEM=block
  E: DEVNAME=sda5
  E: ID_ATA=1
  E: ID_TYPE=disk
  E: ID_BUS=ata
  E: ID_MODEL=WDC_WD2500BEVT-22A23T0
  E: ID_MODEL_ENC=WDC\x20WD2500BEVT-22A23T0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
  E: ID_REVISION=01.01A10
  E: ID_SERIAL=WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727
  E: ID_SERIAL_SHORT=WD-WXJ1A50D8727
  E: ID_ATA_WRITE_CACHE=1
  E: ID_ATA_WRITE_CACHE_ENABLED=1
  E: ID_ATA_FEATURE_SET_HPA=1
  E: ID_ATA_FEATURE_SET_HPA_ENABLED=1
  E: ID_ATA_FEATURE_SET_PM=1
  E: ID_ATA_FEATURE_SET_PM_ENABLED=1
  E: ID_ATA_FEATURE_SET_SECURITY=1
  E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
  E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=70
  E: ID_ATA_FEATURE_SET_SECURITY_FROZEN=1
  E: ID_ATA_FEATURE_SET_SMART=1
  E: ID_ATA_FEATURE_SET_SMART_ENABLED=1
  E: ID_ATA_FEATURE_SET_AAM=1
  E: ID_ATA_FEATURE_SET_AAM_ENABLED=0
  E: ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
  E: ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
  E: ID_ATA_FEATURE_SET_APM=1
  E: ID_ATA_FEATURE_SET_APM_ENABLED=1
  E: ID_ATA_FEATURE_SET_APM_CURRENT_VALUE=254
  E: ID_ATA_DOWNLOAD_MICROCODE=1
  E: ID_ATA_SATA=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
  E: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
  E: ID_ATA_ROTATION_RATE_RPM=5400
  E: ID_WWN=0x50014ee2af462d20
  E: ID_WWN_WITH_EXTENSION=0x50014ee2af462d20
  E: ID_SCSI_COMPAT=SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727
  E: ID_PATH=pci-0000:00:11.0-scsi-0:0:0:0
  E: ID_PART_TABLE_TYPE=dos
  E: ID_FS_UUID=6138fe8c-9476-4396-aa5f-a88c0dc55e29
  E: ID_FS_UUID_ENC=6138fe8c-9476-4396-aa5f-a88c0dc55e29
  E: ID_FS_VERSION=2
  E: ID_FS_TYPE=swap
  E: ID_FS_USAGE=other
  E: UDISKS_PRESENTATION_NOPOLICY=0
  E: UDISKS_PARTITION=1
  E: UDISKS_PARTITION_SCHEME=mbr
  E: UDISKS_PARTITION_NUMBER=5
  E: UDISKS_PARTITION_TYPE=0x82
  E: UDISKS_PARTITION_SIZE=5384437760
  E: UDISKS_PARTITION_SLAVE=/sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda
  E: UDISKS_PARTITION_OFFSET=244674723840
  E: UDISKS_PARTITION_ALIGNMENT_OFFSET=0
  E: MAJOR=8
  E: MINOR=5
  E: DEVTYPE=partition
  E: DEVLINKS=/dev/block/8:5 /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part5 /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part5 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part5 /dev/disk/by-uuid/6138fe8c-9476-4396-aa5f-a88c0dc55e29 /dev/disk/by-id/wwn-0x50014ee2af462d20-part5
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/bsg/2:0:0:0
  N: bsg/2:0:0:0
  S: char/253:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/bsg/2:0:0:0
  E: SUBSYSTEM=bsg
  E: DEVNAME=/dev/bsg/2:0:0:0
  E: MAJOR=253
  E: MINOR=0
  E: DEVLINKS=/dev/char/253:0
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_device/2:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_device/2:0:0:0
  E: SUBSYSTEM=scsi_device
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_disk/2:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_disk/2:0:0:0
  E: SUBSYSTEM=scsi_disk
  
  P: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_generic/sg0
  N: sg0
  S: char/21:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_generic/sg0
  E: SUBSYSTEM=scsi_generic
  E: DEVNAME=/dev/sg0
  E: MAJOR=21
  E: MINOR=0
  E: DEVLINKS=/dev/char/21:0
  
  P: /devices/pci0000:00/0000:00:12.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.0
  E: SUBSYSTEM=pci
  E: DRIVER=ohci_hcd
  E: PCI_CLASS=C0310
  E: PCI_ID=1002:4397
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:12.0
  E: MODALIAS=pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10
  
  P: /devices/pci0000:00/0000:00:12.0/usb4
  N: bus/usb/004/001
  S: char/189:384
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.0/usb4
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/004/001
  E: ID_VENDOR=Linux_2.6.35-24-generic_ohci_hcd
  E: ID_VENDOR_ENC=Linux\x202.6.35-24-generic\x20ohci_hcd
  E: ID_VENDOR_ID=1d6b
  E: ID_MODEL=OHCI_Host_Controller
  E: ID_MODEL_ENC=OHCI\x20Host\x20Controller
  E: ID_MODEL_ID=0001
  E: ID_REVISION=0206
  E: ID_SERIAL=Linux_2.6.35-24-generic_ohci_hcd_OHCI_Host_Controller_0000:00:12.0
  E: ID_SERIAL_SHORT=0000:00:12.0
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:090000:
  E: MAJOR=189
  E: MINOR=384
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=1d6b/1/206
  E: TYPE=9/0/0
  E: BUSNUM=004
  E: DEVNUM=001
  E: DEVLINKS=/dev/char/189:384
  
  P: /devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=hub
  E: PRODUCT=1d6b/1/206
  E: TYPE=9/0/0
  E: INTERFACE=9/0/0
  E: MODALIAS=usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00
  
  P: /devices/pci0000:00/0000:00:12.0/usbmon/usbmon4
  N: usbmon4
  S: char/252:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.0/usbmon/usbmon4
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon4
  E: MAJOR=252
  E: MINOR=4
  E: DEVLINKS=/dev/char/252:4
  
  P: /devices/pci0000:00/0000:00:12.2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2
  E: SUBSYSTEM=pci
  E: DRIVER=ehci_hcd
  E: PCI_CLASS=C0320
  E: PCI_ID=1002:4396
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:12.2
  E: MODALIAS=pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20
  
  P: /devices/pci0000:00/0000:00:12.2/usb1
  N: bus/usb/001/001
  S: char/189:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/001/001
  E: ID_VENDOR=Linux_2.6.35-24-generic_ehci_hcd
  E: ID_VENDOR_ENC=Linux\x202.6.35-24-generic\x20ehci_hcd
  E: ID_VENDOR_ID=1d6b
  E: ID_MODEL=EHCI_Host_Controller
  E: ID_MODEL_ENC=EHCI\x20Host\x20Controller
  E: ID_MODEL_ID=0002
  E: ID_REVISION=0206
  E: ID_SERIAL=Linux_2.6.35-24-generic_ehci_hcd_EHCI_Host_Controller_0000:00:12.2
  E: ID_SERIAL_SHORT=0000:00:12.2
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:090000:
  E: MAJOR=189
  E: MINOR=0
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=1d6b/2/206
  E: TYPE=9/0/0
  E: BUSNUM=001
  E: DEVNUM=001
  E: DEVLINKS=/dev/char/189:0
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=hub
  E: PRODUCT=1d6b/2/206
  E: TYPE=9/0/0
  E: INTERFACE=9/0/0
  E: MODALIAS=usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5
  N: bus/usb/001/002
  S: char/189:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/001/002
  E: ID_VENDOR=Generic
  E: ID_VENDOR_ENC=Generic
  E: ID_VENDOR_ID=0bda
  E: ID_MODEL=USB2.0-CRW
  E: ID_MODEL_ENC=USB2.0-CRW
  E: ID_MODEL_ID=0138
  E: ID_REVISION=3882
  E: ID_SERIAL=Generic_USB2.0-CRW_20090516388200000
  E: ID_SERIAL_SHORT=20090516388200000
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:080650:
  E: MAJOR=189
  E: MINOR=1
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=bda/138/3882
  E: TYPE=0/0/0
  E: BUSNUM=001
  E: DEVNUM=002
  E: DEVLINKS=/dev/char/189:1
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=usb-storage
  E: PRODUCT=bda/138/3882
  E: TYPE=0/0/0
  E: INTERFACE=8/6/80
  E: MODALIAS=usb:v0BDAp0138d3882dc00dsc00dp00ic08isc06ip50
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_host
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/scsi_host/host3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/scsi_host/host3
  E: SUBSYSTEM=scsi_host
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_target
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_device
  E: DRIVER=sd
  E: MODALIAS=scsi:t-0x00
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/block/sdb
  N: sdb
  S: block/8:16
  S: disk/by-id/usb-Generic-_Multi-Card_20090516388200000-0:0
  S: disk/by-path/pci-0000:00:12.2-usb-0:5:1.0-scsi-0:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/block/sdb
  E: SUBSYSTEM=block
  E: DEVNAME=sdb
  E: ID_VENDOR=Generic-
  E: ID_VENDOR_ENC=Generic-
  E: ID_VENDOR_ID=0bda
  E: ID_MODEL=Multi-Card
  E: ID_MODEL_ENC=Multi-Card\x20\x20\x20\x20\x20\x20
  E: ID_MODEL_ID=0138
  E: ID_REVISION=1.00
  E: ID_SERIAL=Generic-_Multi-Card_20090516388200000-0:0
  E: ID_SERIAL_SHORT=20090516388200000
  E: ID_TYPE=disk
  E: ID_INSTANCE=0:0
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:080650:
  E: ID_USB_INTERFACE_NUM=00
  E: ID_USB_DRIVER=usb-storage
  E: ID_PATH=pci-0000:00:12.2-usb-0:5:1.0-scsi-0:0:0:0
  E: UDISKS_PRESENTATION_NOPOLICY=0
  E: MAJOR=8
  E: MINOR=16
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/8:16 /dev/disk/by-id/usb-Generic-_Multi-Card_20090516388200000-0:0 /dev/disk/by-path/pci-0000:00:12.2-usb-0:5:1.0-scsi-0:0:0:0
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/bsg/3:0:0:0
  N: bsg/3:0:0:0
  S: char/253:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/bsg/3:0:0:0
  E: SUBSYSTEM=bsg
  E: DEVNAME=/dev/bsg/3:0:0:0
  E: MAJOR=253
  E: MINOR=1
  E: DEVLINKS=/dev/char/253:1
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_device/3:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_device/3:0:0:0
  E: SUBSYSTEM=scsi_device
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_disk/3:0:0:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_disk/3:0:0:0
  E: SUBSYSTEM=scsi_disk
  
  P: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_generic/sg1
  N: sg1
  S: char/21:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_generic/sg1
  E: SUBSYSTEM=scsi_generic
  E: DEVNAME=/dev/sg1
  E: MAJOR=21
  E: MINOR=1
  E: DEVLINKS=/dev/char/21:1
  
  P: /devices/pci0000:00/0000:00:12.2/usbmon/usbmon1
  N: usbmon1
  S: char/252:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:12.2/usbmon/usbmon1
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon1
  E: MAJOR=252
  E: MINOR=1
  E: DEVLINKS=/dev/char/252:1
  
  P: /devices/pci0000:00/0000:00:13.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.0
  E: SUBSYSTEM=pci
  E: DRIVER=ohci_hcd
  E: PCI_CLASS=C0310
  E: PCI_ID=1002:4397
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:13.0
  E: MODALIAS=pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10
  
  P: /devices/pci0000:00/0000:00:13.0/usb5
  N: bus/usb/005/001
  S: char/189:512
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.0/usb5
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/005/001
  E: ID_VENDOR=Linux_2.6.35-24-generic_ohci_hcd
  E: ID_VENDOR_ENC=Linux\x202.6.35-24-generic\x20ohci_hcd
  E: ID_VENDOR_ID=1d6b
  E: ID_MODEL=OHCI_Host_Controller
  E: ID_MODEL_ENC=OHCI\x20Host\x20Controller
  E: ID_MODEL_ID=0001
  E: ID_REVISION=0206
  E: ID_SERIAL=Linux_2.6.35-24-generic_ohci_hcd_OHCI_Host_Controller_0000:00:13.0
  E: ID_SERIAL_SHORT=0000:00:13.0
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:090000:
  E: MAJOR=189
  E: MINOR=512
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=1d6b/1/206
  E: TYPE=9/0/0
  E: BUSNUM=005
  E: DEVNUM=001
  E: DEVLINKS=/dev/char/189:512
  
  P: /devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=hub
  E: PRODUCT=1d6b/1/206
  E: TYPE=9/0/0
  E: INTERFACE=9/0/0
  E: MODALIAS=usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00
  
  P: /devices/pci0000:00/0000:00:13.0/usbmon/usbmon5
  N: usbmon5
  S: char/252:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.0/usbmon/usbmon5
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon5
  E: MAJOR=252
  E: MINOR=5
  E: DEVLINKS=/dev/char/252:5
  
  P: /devices/pci0000:00/0000:00:13.2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2
  E: SUBSYSTEM=pci
  E: DRIVER=ehci_hcd
  E: PCI_CLASS=C0320
  E: PCI_ID=1002:4396
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:13.2
  E: MODALIAS=pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20
  
  P: /devices/pci0000:00/0000:00:13.2/usb2
  N: bus/usb/002/001
  S: char/189:128
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/002/001
  E: ID_VENDOR=Linux_2.6.35-24-generic_ehci_hcd
  E: ID_VENDOR_ENC=Linux\x202.6.35-24-generic\x20ehci_hcd
  E: ID_VENDOR_ID=1d6b
  E: ID_MODEL=EHCI_Host_Controller
  E: ID_MODEL_ENC=EHCI\x20Host\x20Controller
  E: ID_MODEL_ID=0002
  E: ID_REVISION=0206
  E: ID_SERIAL=Linux_2.6.35-24-generic_ehci_hcd_EHCI_Host_Controller_0000:00:13.2
  E: ID_SERIAL_SHORT=0000:00:13.2
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:090000:
  E: MAJOR=189
  E: MINOR=128
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=1d6b/2/206
  E: TYPE=9/0/0
  E: BUSNUM=002
  E: DEVNUM=001
  E: DEVLINKS=/dev/char/189:128
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=hub
  E: PRODUCT=1d6b/2/206
  E: TYPE=9/0/0
  E: INTERFACE=9/0/0
  E: MODALIAS=usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-5
  N: bus/usb/002/003
  S: char/189:130
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-5
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/002/003
  E: ID_VENDOR=Suyin
  E: ID_VENDOR_ENC=Suyin
  E: ID_VENDOR_ID=064e
  E: ID_MODEL=1.3M_WebCam
  E: ID_MODEL_ENC=1.3M\x20WebCam
  E: ID_MODEL_ID=a219
  E: ID_REVISION=0215
  E: ID_SERIAL=Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05
  E: ID_SERIAL_SHORT=HF1315-S32B-OV01-VA-R02.01.05
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:0e0100:0e0200:
  E: MAJOR=189
  E: MINOR=130
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=64e/a219/215
  E: TYPE=239/2/1
  E: BUSNUM=002
  E: DEVNUM=003
  E: DEVLINKS=/dev/char/189:130
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=uvcvideo
  E: PRODUCT=64e/a219/215
  E: TYPE=239/2/1
  E: INTERFACE=14/1/0
  E: MODALIAS=usb:v064EpA219d0215dcEFdsc02dp01ic0Eisc01ip00
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6
  E: SUBSYSTEM=input
  E: PRODUCT=3/64e/a219/215
  E: NAME="1.3M WebCam"
  E: PHYS="usb-0000:00:13.2-5/button"
  E: EV==3
  E: KEY==100000 0 0 0
  E: MODALIAS=input:b0003v064EpA219e0215-e0,1,kD4,ramlsfw
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6/event6
  N: input/event6
  S: char/13:70
  S: input/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-event-if00
  S: input/by-path/pci-0000:00:13.2-usb-0:5:1.0-event
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6/event6
  E: SUBSYSTEM=input
  E: DEVNAME=input/event6
  E: ID_INPUT=1
  E: ID_INPUT_KEY=1
  E: ID_VENDOR=Suyin
  E: ID_VENDOR_ENC=Suyin
  E: ID_VENDOR_ID=064e
  E: ID_MODEL=1.3M_WebCam
  E: ID_MODEL_ENC=1.3M\x20WebCam
  E: ID_MODEL_ID=a219
  E: ID_REVISION=0215
  E: ID_SERIAL=Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05
  E: ID_SERIAL_SHORT=HF1315-S32B-OV01-VA-R02.01.05
  E: ID_TYPE=video
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:0e0100:0e0200:
  E: ID_USB_INTERFACE_NUM=00
  E: ID_USB_DRIVER=uvcvideo
  E: ID_PATH=pci-0000:00:13.2-usb-0:5:1.0
  E: XKBMODEL=pc105
  E: XKBLAYOUT=us
  E: MAJOR=13
  E: MINOR=70
  E: DEVLINKS=/dev/char/13:70 /dev/input/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-event-if00 /dev/input/by-path/pci-0000:00:13.2-usb-0:5:1.0-event
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/video4linux/video0
  N: video0
  S: char/81:0
  S: v4l/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-video-index0
  S: v4l/by-path/pci-0000:00:13.2-usb-0:5:1.0-video-index0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/video4linux/video0
  E: SUBSYSTEM=video4linux
  E: DEVNAME=video0
  E: ID_V4L_VERSION=2
  E: ID_V4L_PRODUCT=1.3M WebCam
  E: ID_V4L_CAPABILITIES=:capture:
  E: ID_VENDOR=Suyin
  E: ID_VENDOR_ENC=Suyin
  E: ID_VENDOR_ID=064e
  E: ID_MODEL=1.3M_WebCam
  E: ID_MODEL_ENC=1.3M\x20WebCam
  E: ID_MODEL_ID=a219
  E: ID_REVISION=0215
  E: ID_SERIAL=Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05
  E: ID_SERIAL_SHORT=HF1315-S32B-OV01-VA-R02.01.05
  E: ID_TYPE=video
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:0e0100:0e0200:
  E: ID_USB_INTERFACE_NUM=00
  E: ID_USB_DRIVER=uvcvideo
  E: ID_PATH=pci-0000:00:13.2-usb-0:5:1.0
  E: MAJOR=81
  E: MINOR=0
  E: DEVLINKS=/dev/char/81:0 /dev/v4l/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-video-index0 /dev/v4l/by-path/pci-0000:00:13.2-usb-0:5:1.0-video-index0
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=uvcvideo
  E: PRODUCT=64e/a219/215
  E: TYPE=239/2/1
  E: INTERFACE=14/2/0
  E: MODALIAS=usb:v064EpA219d0215dcEFdsc02dp01ic0Eisc02ip00
  
  P: /devices/pci0000:00/0000:00:13.2/usbmon/usbmon2
  N: usbmon2
  S: char/252:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:13.2/usbmon/usbmon2
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon2
  E: MAJOR=252
  E: MINOR=2
  E: DEVLINKS=/dev/char/252:2
  
  P: /devices/pci0000:00/0000:00:14.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.0
  E: SUBSYSTEM=pci
  E: PCI_CLASS=C0500
  E: PCI_ID=1002:4385
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:14.0
  E: MODALIAS=pci:v00001002d00004385sv00000000sd00000000bc0Csc05i00
  
  P: /devices/pci0000:00/0000:00:14.1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.1
  E: SUBSYSTEM=pci
  E: ID_VENDOR_FROM_DATABASE=ATI Technologies Inc
  E: ID_MODEL_FROM_DATABASE=SB700/SB800 IDE Controller
  E: DRIVER=pata_atiixp
  E: PCI_CLASS=1018A
  E: PCI_ID=1002:439C
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:14.1
  E: MODALIAS=pci:v00001002d0000439Csv00001025sd00000429bc01sc01i8a
  
  P: /devices/pci0000:00/0000:00:14.1/host0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.1/host0
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_host
  
  P: /devices/pci0000:00/0000:00:14.1/host0/scsi_host/host0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.1/host0/scsi_host/host0
  E: SUBSYSTEM=scsi_host
  
  P: /devices/pci0000:00/0000:00:14.1/host1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.1/host1
  E: SUBSYSTEM=scsi
  E: DEVTYPE=scsi_host
  
  P: /devices/pci0000:00/0000:00:14.1/host1/scsi_host/host1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.1/host1/scsi_host/host1
  E: SUBSYSTEM=scsi_host
  
  P: /devices/pci0000:00/0000:00:14.2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2
  E: SUBSYSTEM=pci
  E: DRIVER=HDA Intel
  E: PCI_CLASS=40300
  E: PCI_ID=1002:4383
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:14.2
  E: MODALIAS=pci:v00001002d00004383sv00001025sd00000429bc04sc03i00
  
  P: /devices/pci0000:00/0000:00:14.2/sound/card0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2/sound/card0
  E: SUBSYSTEM=sound
  E: SOUND_INITIALIZED=1
  E: ID_VENDOR_FROM_DATABASE=ATI Technologies Inc
  E: ID_MODEL_FROM_DATABASE=SBx00 Azalia (Intel HDA)
  E: ID_BUS=pci
  E: ID_VENDOR_ID=0x1002
  E: ID_MODEL_ID=0x4383
  E: ID_PATH=pci-0000:00:14.2
  E: SOUND_FORM_FACTOR=internal
  
  P: /devices/pci0000:00/0000:00:14.2/sound/card0/hwC0D0
  N: snd/hwC0D0
  S: char/116:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2/sound/card0/hwC0D0
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/hwC0D0
  E: MAJOR=116
  E: MINOR=7
  E: DEVLINKS=/dev/char/116:7
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0c
  N: snd/pcmC0D0c
  S: char/116:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0c
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/pcmC0D0c
  E: MAJOR=116
  E: MINOR=6
  E: DEVLINKS=/dev/char/116:6
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0p
  N: snd/pcmC0D0p
  S: char/116:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0p
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/pcmC0D0p
  E: MAJOR=116
  E: MINOR=5
  E: DEVLINKS=/dev/char/116:5
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D1p
  N: snd/pcmC0D1p
  S: char/116:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D1p
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/pcmC0D1p
  E: MAJOR=116
  E: MINOR=4
  E: DEVLINKS=/dev/char/116:4
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:14.2/sound/card0/controlC0
  N: snd/controlC0
  S: char/116:8
  S: snd/by-path/pci-0000:00:14.2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.2/sound/card0/controlC0
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/controlC0
  E: ID_PATH=pci-0000:00:14.2
  E: MAJOR=116
  E: MINOR=8
  E: DEVLINKS=/dev/char/116:8 /dev/snd/by-path/pci-0000:00:14.2
  E: TAGS=:udev-acl:
  
  P: /devices/pci0000:00/0000:00:14.3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.3
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60100
  E: PCI_ID=1002:439D
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:14.3
  E: MODALIAS=pci:v00001002d0000439Dsv00001025sd00000429bc06sc01i00
  
  P: /devices/pci0000:00/0000:00:14.4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.4
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60401
  E: PCI_ID=1002:4384
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:14.4
  E: MODALIAS=pci:v00001002d00004384sv00000000sd00000000bc06sc04i01
  
  P: /devices/pci0000:00/0000:00:14.4/pci_bus/0000:07
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:14.4/pci_bus/0000:07
  E: SUBSYSTEM=pci_bus
  
  P: /devices/pci0000:00/0000:00:16.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.0
  E: SUBSYSTEM=pci
  E: DRIVER=ohci_hcd
  E: PCI_CLASS=C0310
  E: PCI_ID=1002:4397
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:16.0
  E: MODALIAS=pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10
  
  P: /devices/pci0000:00/0000:00:16.0/usb6
  N: bus/usb/006/001
  S: char/189:640
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.0/usb6
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/006/001
  E: ID_VENDOR=Linux_2.6.35-24-generic_ohci_hcd
  E: ID_VENDOR_ENC=Linux\x202.6.35-24-generic\x20ohci_hcd
  E: ID_VENDOR_ID=1d6b
  E: ID_MODEL=OHCI_Host_Controller
  E: ID_MODEL_ENC=OHCI\x20Host\x20Controller
  E: ID_MODEL_ID=0001
  E: ID_REVISION=0206
  E: ID_SERIAL=Linux_2.6.35-24-generic_ohci_hcd_OHCI_Host_Controller_0000:00:16.0
  E: ID_SERIAL_SHORT=0000:00:16.0
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:090000:
  E: MAJOR=189
  E: MINOR=640
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=1d6b/1/206
  E: TYPE=9/0/0
  E: BUSNUM=006
  E: DEVNUM=001
  E: DEVLINKS=/dev/char/189:640
  
  P: /devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=hub
  E: PRODUCT=1d6b/1/206
  E: TYPE=9/0/0
  E: INTERFACE=9/0/0
  E: MODALIAS=usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00
  
  P: /devices/pci0000:00/0000:00:16.0/usbmon/usbmon6
  N: usbmon6
  S: char/252:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.0/usbmon/usbmon6
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon6
  E: MAJOR=252
  E: MINOR=6
  E: DEVLINKS=/dev/char/252:6
  
  P: /devices/pci0000:00/0000:00:16.2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.2
  E: SUBSYSTEM=pci
  E: DRIVER=ehci_hcd
  E: PCI_CLASS=C0320
  E: PCI_ID=1002:4396
  E: PCI_SUBSYS_ID=1025:0429
  E: PCI_SLOT_NAME=0000:00:16.2
  E: MODALIAS=pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20
  
  P: /devices/pci0000:00/0000:00:16.2/usb3
  N: bus/usb/003/001
  S: char/189:256
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.2/usb3
  E: SUBSYSTEM=usb
  E: DEVNAME=bus/usb/003/001
  E: ID_VENDOR=Linux_2.6.35-24-generic_ehci_hcd
  E: ID_VENDOR_ENC=Linux\x202.6.35-24-generic\x20ehci_hcd
  E: ID_VENDOR_ID=1d6b
  E: ID_MODEL=EHCI_Host_Controller
  E: ID_MODEL_ENC=EHCI\x20Host\x20Controller
  E: ID_MODEL_ID=0002
  E: ID_REVISION=0206
  E: ID_SERIAL=Linux_2.6.35-24-generic_ehci_hcd_EHCI_Host_Controller_0000:00:16.2
  E: ID_SERIAL_SHORT=0000:00:16.2
  E: ID_BUS=usb
  E: ID_USB_INTERFACES=:090000:
  E: MAJOR=189
  E: MINOR=256
  E: DEVTYPE=usb_device
  E: DRIVER=usb
  E: PRODUCT=1d6b/2/206
  E: TYPE=9/0/0
  E: BUSNUM=003
  E: DEVNUM=001
  E: DEVLINKS=/dev/char/189:256
  
  P: /devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
  E: SUBSYSTEM=usb
  E: DEVTYPE=usb_interface
  E: DRIVER=hub
  E: PRODUCT=1d6b/2/206
  E: TYPE=9/0/0
  E: INTERFACE=9/0/0
  E: MODALIAS=usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00
  
  P: /devices/pci0000:00/0000:00:16.2/usbmon/usbmon3
  N: usbmon3
  S: char/252:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:16.2/usbmon/usbmon3
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon3
  E: MAJOR=252
  E: MINOR=3
  E: DEVLINKS=/dev/char/252:3
  
  P: /devices/pci0000:00/0000:00:18.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:18.0
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60000
  E: PCI_ID=1022:1200
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:18.0
  E: MODALIAS=pci:v00001022d00001200sv00000000sd00000000bc06sc00i00
  
  P: /devices/pci0000:00/0000:00:18.1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:18.1
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60000
  E: PCI_ID=1022:1201
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:18.1
  E: MODALIAS=pci:v00001022d00001201sv00000000sd00000000bc06sc00i00
  
  P: /devices/pci0000:00/0000:00:18.2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:18.2
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60000
  E: PCI_ID=1022:1202
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:18.2
  E: MODALIAS=pci:v00001022d00001202sv00000000sd00000000bc06sc00i00
  
  P: /devices/pci0000:00/0000:00:18.3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:18.3
  E: SUBSYSTEM=pci
  E: DRIVER=k10temp
  E: PCI_CLASS=60000
  E: PCI_ID=1022:1203
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:18.3
  E: MODALIAS=pci:v00001022d00001203sv00000000sd00000000bc06sc00i00
  
  P: /devices/pci0000:00/0000:00:18.3/hwmon/hwmon1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1
  E: SUBSYSTEM=hwmon
  
  P: /devices/pci0000:00/0000:00:18.4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/0000:00:18.4
  E: SUBSYSTEM=pci
  E: PCI_CLASS=60000
  E: PCI_ID=1022:1204
  E: PCI_SUBSYS_ID=0000:0000
  E: PCI_SLOT_NAME=0000:00:18.4
  E: MODALIAS=pci:v00001022d00001204sv00000000sd00000000bc06sc00i00
  
  P: /devices/pci0000:00/pci_bus/0000:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pci0000:00/pci_bus/0000:00
  E: SUBSYSTEM=pci_bus
  
  P: /devices/platform/Fixed MDIO bus.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/Fixed MDIO bus.0
  E: SUBSYSTEM=platform
  E: MODALIAS=platform:Fixed MDIO bus
  
  P: /devices/platform/Fixed MDIO bus.0/mdio_bus/0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/Fixed MDIO bus.0/mdio_bus/0
  E: SUBSYSTEM=mdio_bus
  
  P: /devices/platform/acer-wmi
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/acer-wmi
  E: SUBSYSTEM=platform
  E: DRIVER=acer-wmi
  E: MODALIAS=platform:acer-wmi
  
  P: /devices/platform/acer-wmi/rfkill/rfkill0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/acer-wmi/rfkill/rfkill0
  E: SUBSYSTEM=rfkill
  E: RFKILL_NAME=acer-wireless
  E: RFKILL_TYPE=wlan
  E: RFKILL_STATE=0
  
  P: /devices/platform/i8042
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042
  E: SUBSYSTEM=platform
  E: DRIVER=i8042
  E: MODALIAS=platform:i8042
  
  P: /devices/platform/i8042/serio0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio0
  E: SUBSYSTEM=serio
  E: DMI_VENDOR=Acer
  E: DRIVER=atkbd
  E: SERIO_TYPE=06
  E: SERIO_PROTO=00
  E: SERIO_ID=00
  E: SERIO_EXTRA=00
  E: MODALIAS=serio:ty06pr00id00ex00
  
  P: /devices/platform/i8042/serio0/input/input4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio0/input/input4
  E: SUBSYSTEM=input
  E: PRODUCT=11/1/1/ab41
  E: NAME="AT Translated Set 2 keyboard"
  E: PHYS="isa0060/serio0/input0"
  E: EV==120013
  E: KEY==10000 c020000000000 0 0 700f02000003 3803078f830f401 febfffdfffefffff fffffffffffffffe
  E: MSC==10
  E: LED==7
  E: MODALIAS=input:b0011v0001p0001eAB41-e0,1,4,11,14,k71,72,73,74,75,77,79,7A,7B,7C,7D,7E,7F,80,8A,8C,8D,8E,8F,94,95,9B,9C,9D,9E,9F,A3,A4,A5,A6,AC,AD,B7,B8,B9,C0,C1,D9,E0,E1,E2,E3,EC,ED,EE,1A9,1B2,1B3,1D0,ram4,l0,1,2,sfw
  
  P: /devices/platform/i8042/serio0/input/input4/event4
  N: input/event4
  S: char/13:68
  S: input/by-path/platform-i8042-serio-0-event-kbd
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio0/input/input4/event4
  E: SUBSYSTEM=input
  E: DEVNAME=input/event4
  E: ID_INPUT=1
  E: ID_INPUT_KEY=1
  E: ID_INPUT_KEYBOARD=1
  E: ID_SERIAL=noserial
  E: ID_PATH=platform-i8042-serio-0
  E: XKBMODEL=pc105
  E: XKBLAYOUT=us
  E: MAJOR=13
  E: MINOR=68
  E: DEVLINKS=/dev/char/13:68 /dev/input/by-path/platform-i8042-serio-0-event-kbd
  E: DMI_VENDOR=Acer
  
  P: /devices/platform/i8042/serio1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio1
  E: SUBSYSTEM=serio
  E: DRIVER=psmouse
  E: SERIO_TYPE=01
  E: SERIO_PROTO=00
  E: SERIO_ID=00
  E: SERIO_EXTRA=00
  E: MODALIAS=serio:ty01pr00id00ex00
  
  P: /devices/platform/i8042/serio1/input/input7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio1/input/input7
  E: SUBSYSTEM=input
  E: PRODUCT=11/2/1/0
  E: NAME="PS/2 Generic Mouse"
  E: PHYS="isa0060/serio1/input0"
  E: EV==7
  E: KEY==70000 0 0 0 0
  E: REL==3
  E: MODALIAS=input:b0011v0002p0001e0000-e0,1,2,k110,111,112,r0,1,amlsfw
  
  P: /devices/platform/i8042/serio1/input/input7/event7
  N: input/event7
  S: char/13:71
  S: input/by-path/platform-i8042-serio-1-event-mouse
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio1/input/input7/event7
  E: SUBSYSTEM=input
  E: DEVNAME=input/event7
  E: ID_INPUT=1
  E: ID_INPUT_MOUSE=1
  E: ID_SERIAL=noserial
  E: ID_PATH=platform-i8042-serio-1
  E: DMI_VENDOR=Acer
  E: MAJOR=13
  E: MINOR=71
  E: DEVLINKS=/dev/char/13:71 /dev/input/by-path/platform-i8042-serio-1-event-mouse
  
  P: /devices/platform/i8042/serio1/input/input7/mouse0
  N: input/mouse0
  S: char/13:32
  S: input/by-path/platform-i8042-serio-1-mouse
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/i8042/serio1/input/input7/mouse0
  E: SUBSYSTEM=input
  E: DEVNAME=input/mouse0
  E: ID_INPUT=1
  E: ID_INPUT_MOUSE=1
  E: ID_SERIAL=noserial
  E: ID_PATH=platform-i8042-serio-1
  E: MAJOR=13
  E: MINOR=32
  E: DEVLINKS=/dev/char/13:32 /dev/input/by-path/platform-i8042-serio-1-mouse
  
  P: /devices/platform/pcspkr
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/pcspkr
  E: SUBSYSTEM=platform
  E: MODALIAS=platform:pcspkr
  
  P: /devices/platform/serial8250
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/serial8250
  E: SUBSYSTEM=platform
  E: DRIVER=serial8250
  E: MODALIAS=platform:serial8250
  
  P: /devices/platform/serial8250/tty/ttyS0
  N: ttyS0
  S: char/4:64
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/serial8250/tty/ttyS0
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/ttyS0
  E: MAJOR=4
  E: MINOR=64
  E: DEVLINKS=/dev/char/4:64
  
  P: /devices/platform/serial8250/tty/ttyS1
  N: ttyS1
  S: char/4:65
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/serial8250/tty/ttyS1
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/ttyS1
  E: MAJOR=4
  E: MINOR=65
  E: DEVLINKS=/dev/char/4:65
  
  P: /devices/platform/serial8250/tty/ttyS2
  N: ttyS2
  S: char/4:66
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/serial8250/tty/ttyS2
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/ttyS2
  E: MAJOR=4
  E: MINOR=66
  E: DEVLINKS=/dev/char/4:66
  
  P: /devices/platform/serial8250/tty/ttyS3
  N: ttyS3
  S: char/4:67
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/serial8250/tty/ttyS3
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/ttyS3
  E: MAJOR=4
  E: MINOR=67
  E: DEVLINKS=/dev/char/4:67
  
  P: /devices/platform/vboxdrv.0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/platform/vboxdrv.0
  E: SUBSYSTEM=platform
  E: DRIVER=vboxdrv
  E: MODALIAS=platform:vboxdrv
  
  P: /devices/pnp0/00:00
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:00
  E: SUBSYSTEM=pnp
  
  P: /devices/pnp0/00:01
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:01
  E: SUBSYSTEM=pnp
  E: DRIVER=system
  
  P: /devices/pnp0/00:02
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:02
  E: SUBSYSTEM=pnp
  
  P: /devices/pnp0/00:03
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:03
  E: SUBSYSTEM=pnp
  
  P: /devices/pnp0/00:04
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:04
  E: SUBSYSTEM=pnp
  E: DRIVER=rtc_cmos
  
  P: /devices/pnp0/00:04/rtc/rtc0
  N: rtc0
  S: char/254:0
  S: rtc
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:04/rtc/rtc0
  E: SUBSYSTEM=rtc
  E: DEVNAME=/dev/rtc0
  E: MAJOR=254
  E: MINOR=0
  E: DEVLINKS=/dev/char/254:0 /dev/rtc
  
  P: /devices/pnp0/00:05
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:05
  E: SUBSYSTEM=pnp
  
  P: /devices/pnp0/00:06
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:06
  E: SUBSYSTEM=pnp
  E: DRIVER=system
  
  P: /devices/pnp0/00:07
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:07
  E: SUBSYSTEM=pnp
  E: DRIVER=system
  
  P: /devices/pnp0/00:08
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:08
  E: SUBSYSTEM=pnp
  E: DRIVER=i8042 kbd
  
  P: /devices/pnp0/00:09
  E: UDEV_LOG=3
  E: DEVPATH=/devices/pnp0/00:09
  E: SUBSYSTEM=pnp
  E: DRIVER=i8042 aux
  
  P: /devices/virtual/backlight/acpi_video0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/backlight/acpi_video0
  E: SUBSYSTEM=backlight
  
  P: /devices/virtual/bdi/0:20
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/0:20
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:0
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:1
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:10
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:10
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:11
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:11
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:12
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:12
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:13
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:13
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:14
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:14
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:15
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:15
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:2
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:3
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:4
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:5
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:6
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:7
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:8
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:8
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/1:9
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/1:9
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:0
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:1
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:2
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:3
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:4
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:5
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:6
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/7:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/7:7
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/8:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/8:0
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/8:16
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/8:16
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/bdi/default
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/bdi/default
  E: SUBSYSTEM=bdi
  
  P: /devices/virtual/block/loop0
  N: loop0
  S: block/7:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop0
  E: SUBSYSTEM=block
  E: DEVNAME=loop0
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=0
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:0
  
  P: /devices/virtual/block/loop1
  N: loop1
  S: block/7:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop1
  E: SUBSYSTEM=block
  E: DEVNAME=loop1
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=1
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:1
  
  P: /devices/virtual/block/loop2
  N: loop2
  S: block/7:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop2
  E: SUBSYSTEM=block
  E: DEVNAME=loop2
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=2
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:2
  
  P: /devices/virtual/block/loop3
  N: loop3
  S: block/7:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop3
  E: SUBSYSTEM=block
  E: DEVNAME=loop3
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=3
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:3
  
  P: /devices/virtual/block/loop4
  N: loop4
  S: block/7:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop4
  E: SUBSYSTEM=block
  E: DEVNAME=loop4
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=4
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:4
  
  P: /devices/virtual/block/loop5
  N: loop5
  S: block/7:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop5
  E: SUBSYSTEM=block
  E: DEVNAME=loop5
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=5
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:5
  
  P: /devices/virtual/block/loop6
  N: loop6
  S: block/7:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop6
  E: SUBSYSTEM=block
  E: DEVNAME=loop6
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=6
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:6
  
  P: /devices/virtual/block/loop7
  N: loop7
  S: block/7:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/loop7
  E: SUBSYSTEM=block
  E: DEVNAME=loop7
  E: UDISKS_PRESENTATION_NOPOLICY=1
  E: MAJOR=7
  E: MINOR=7
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/7:7
  
  P: /devices/virtual/block/ram0
  N: ram0
  S: block/1:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram0
  E: SUBSYSTEM=block
  E: DEVNAME=ram0
  E: MAJOR=1
  E: MINOR=0
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:0
  
  P: /devices/virtual/block/ram1
  N: ram1
  S: block/1:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram1
  E: SUBSYSTEM=block
  E: DEVNAME=ram1
  E: MAJOR=1
  E: MINOR=1
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:1
  
  P: /devices/virtual/block/ram10
  N: ram10
  S: block/1:10
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram10
  E: SUBSYSTEM=block
  E: DEVNAME=ram10
  E: MAJOR=1
  E: MINOR=10
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:10
  
  P: /devices/virtual/block/ram11
  N: ram11
  S: block/1:11
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram11
  E: SUBSYSTEM=block
  E: DEVNAME=ram11
  E: MAJOR=1
  E: MINOR=11
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:11
  
  P: /devices/virtual/block/ram12
  N: ram12
  S: block/1:12
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram12
  E: SUBSYSTEM=block
  E: DEVNAME=ram12
  E: MAJOR=1
  E: MINOR=12
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:12
  
  P: /devices/virtual/block/ram13
  N: ram13
  S: block/1:13
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram13
  E: SUBSYSTEM=block
  E: DEVNAME=ram13
  E: MAJOR=1
  E: MINOR=13
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:13
  
  P: /devices/virtual/block/ram14
  N: ram14
  S: block/1:14
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram14
  E: SUBSYSTEM=block
  E: DEVNAME=ram14
  E: MAJOR=1
  E: MINOR=14
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:14
  
  P: /devices/virtual/block/ram15
  N: ram15
  S: block/1:15
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram15
  E: SUBSYSTEM=block
  E: DEVNAME=ram15
  E: MAJOR=1
  E: MINOR=15
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:15
  
  P: /devices/virtual/block/ram2
  N: ram2
  S: block/1:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram2
  E: SUBSYSTEM=block
  E: DEVNAME=ram2
  E: MAJOR=1
  E: MINOR=2
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:2
  
  P: /devices/virtual/block/ram3
  N: ram3
  S: block/1:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram3
  E: SUBSYSTEM=block
  E: DEVNAME=ram3
  E: MAJOR=1
  E: MINOR=3
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:3
  
  P: /devices/virtual/block/ram4
  N: ram4
  S: block/1:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram4
  E: SUBSYSTEM=block
  E: DEVNAME=ram4
  E: MAJOR=1
  E: MINOR=4
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:4
  
  P: /devices/virtual/block/ram5
  N: ram5
  S: block/1:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram5
  E: SUBSYSTEM=block
  E: DEVNAME=ram5
  E: MAJOR=1
  E: MINOR=5
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:5
  
  P: /devices/virtual/block/ram6
  N: ram6
  S: block/1:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram6
  E: SUBSYSTEM=block
  E: DEVNAME=ram6
  E: MAJOR=1
  E: MINOR=6
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:6
  
  P: /devices/virtual/block/ram7
  N: ram7
  S: block/1:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram7
  E: SUBSYSTEM=block
  E: DEVNAME=ram7
  E: MAJOR=1
  E: MINOR=7
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:7
  
  P: /devices/virtual/block/ram8
  N: ram8
  S: block/1:8
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram8
  E: SUBSYSTEM=block
  E: DEVNAME=ram8
  E: MAJOR=1
  E: MINOR=8
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:8
  
  P: /devices/virtual/block/ram9
  N: ram9
  S: block/1:9
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/block/ram9
  E: SUBSYSTEM=block
  E: DEVNAME=ram9
  E: MAJOR=1
  E: MINOR=9
  E: DEVTYPE=disk
  E: DEVLINKS=/dev/block/1:9
  
  P: /devices/virtual/dmi/id
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/dmi/id
  E: SUBSYSTEM=dmi
  E: MODALIAS=dmi:bvnPhoenixTechnologiesLTD:bvrV1.11:bd05/14/2010:svnAcer:pnAspire1551:pvrV1.11:rvnAcer:rnAspire1551:rvrV1.11:cvnAcer:ct10:cvrV1.11:
  
  P: /devices/virtual/graphics/fbcon
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/graphics/fbcon
  E: SUBSYSTEM=graphics
  
  P: /devices/virtual/hwmon/hwmon0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/hwmon/hwmon0
  E: SUBSYSTEM=hwmon
  
  P: /devices/virtual/input/mice
  N: input/mice
  S: char/13:63
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/input/mice
  E: SUBSYSTEM=input
  E: DEVNAME=/dev/input/mice
  E: MAJOR=13
  E: MINOR=63
  E: DEVLINKS=/dev/char/13:63
  
  P: /devices/virtual/mem/full
  N: full
  S: char/1:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/full
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/full
  E: MAJOR=1
  E: MINOR=7
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/1:7
  
  P: /devices/virtual/mem/kmsg
  N: kmsg
  S: char/1:11
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/kmsg
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/kmsg
  E: MAJOR=1
  E: MINOR=11
  E: DEVLINKS=/dev/char/1:11
  
  P: /devices/virtual/mem/mem
  N: mem
  S: char/1:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/mem
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/mem
  E: MAJOR=1
  E: MINOR=1
  E: DEVLINKS=/dev/char/1:1
  
  P: /devices/virtual/mem/null
  N: null
  S: char/1:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/null
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/null
  E: MAJOR=1
  E: MINOR=3
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/1:3
  
  P: /devices/virtual/mem/oldmem
  N: oldmem
  S: char/1:12
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/oldmem
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/oldmem
  E: MAJOR=1
  E: MINOR=12
  E: DEVLINKS=/dev/char/1:12
  
  P: /devices/virtual/mem/port
  N: port
  S: char/1:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/port
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/port
  E: MAJOR=1
  E: MINOR=4
  E: DEVLINKS=/dev/char/1:4
  
  P: /devices/virtual/mem/random
  N: random
  S: char/1:8
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/random
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/random
  E: MAJOR=1
  E: MINOR=8
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/1:8
  
  P: /devices/virtual/mem/urandom
  N: urandom
  S: char/1:9
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/urandom
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/urandom
  E: MAJOR=1
  E: MINOR=9
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/1:9
  
  P: /devices/virtual/mem/zero
  N: zero
  S: char/1:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/mem/zero
  E: SUBSYSTEM=mem
  E: DEVNAME=/dev/zero
  E: MAJOR=1
  E: MINOR=5
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/1:5
  
  P: /devices/virtual/misc/cpu_dma_latency
  N: cpu_dma_latency
  S: char/10:58
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/cpu_dma_latency
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/cpu_dma_latency
  E: MAJOR=10
  E: MINOR=58
  E: DEVLINKS=/dev/char/10:58
  
  P: /devices/virtual/misc/device-mapper
  N: mapper/control
  S: char/10:59
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/device-mapper
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/mapper/control
  E: MAJOR=10
  E: MINOR=59
  E: DEVLINKS=/dev/char/10:59
  
  P: /devices/virtual/misc/ecryptfs
  N: ecryptfs
  S: char/10:61
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/ecryptfs
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/ecryptfs
  E: MAJOR=10
  E: MINOR=61
  E: DEVLINKS=/dev/char/10:61
  
  P: /devices/virtual/misc/fuse
  N: fuse
  S: char/10:229
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/fuse
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/fuse
  E: MAJOR=10
  E: MINOR=229
  E: DEVLINKS=/dev/char/10:229
  
  P: /devices/virtual/misc/hpet
  N: hpet
  S: char/10:228
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/hpet
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/hpet
  E: MAJOR=10
  E: MINOR=228
  E: DEVLINKS=/dev/char/10:228
  
  P: /devices/virtual/misc/mcelog
  N: mcelog
  S: char/10:227
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/mcelog
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/mcelog
  E: MAJOR=10
  E: MINOR=227
  E: DEVLINKS=/dev/char/10:227
  
  P: /devices/virtual/misc/network_latency
  N: network_latency
  S: char/10:57
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/network_latency
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/network_latency
  E: MAJOR=10
  E: MINOR=57
  E: DEVLINKS=/dev/char/10:57
  
  P: /devices/virtual/misc/network_throughput
  N: network_throughput
  S: char/10:56
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/network_throughput
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/network_throughput
  E: MAJOR=10
  E: MINOR=56
  E: DEVLINKS=/dev/char/10:56
  
  P: /devices/virtual/misc/pktcdvd
  N: pktcdvd/control
  S: char/10:60
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/pktcdvd
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/pktcdvd/control
  E: MAJOR=10
  E: MINOR=60
  E: DEVLINKS=/dev/char/10:60
  
  P: /devices/virtual/misc/psaux
  N: psaux
  S: char/10:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/psaux
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/psaux
  E: MAJOR=10
  E: MINOR=1
  E: DEVLINKS=/dev/char/10:1
  
  P: /devices/virtual/misc/rfkill
  N: rfkill
  S: char/10:62
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/rfkill
  E: SUBSYSTEM=misc
  E: DEVNAME=rfkill
  E: MAJOR=10
  E: MINOR=62
  E: DEVLINKS=/dev/char/10:62
  E: TAGS=:udev-acl:
  
  P: /devices/virtual/misc/snapshot
  N: snapshot
  S: char/10:231
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/snapshot
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/snapshot
  E: MAJOR=10
  E: MINOR=231
  E: DEVLINKS=/dev/char/10:231
  
  P: /devices/virtual/misc/tun
  N: net/tun
  S: char/10:200
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/tun
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/net/tun
  E: MAJOR=10
  E: MINOR=200
  E: DEVLINKS=/dev/char/10:200
  
  P: /devices/virtual/misc/uinput
  N: uinput
  S: char/10:223
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/uinput
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/uinput
  E: MAJOR=10
  E: MINOR=223
  E: DEVLINKS=/dev/char/10:223
  
  P: /devices/virtual/misc/vboxdrv
  N: vboxdrv
  S: char/10:55
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/vboxdrv
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/vboxdrv
  E: MAJOR=10
  E: MINOR=55
  E: DEVLINKS=/dev/char/10:55
  
  P: /devices/virtual/misc/vboxnetctl
  N: vboxnetctl
  S: char/10:54
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/vboxnetctl
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/vboxnetctl
  E: MAJOR=10
  E: MINOR=54
  E: DEVLINKS=/dev/char/10:54
  
  P: /devices/virtual/misc/vga_arbiter
  N: vga_arbiter
  S: char/10:63
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/misc/vga_arbiter
  E: SUBSYSTEM=misc
  E: DEVNAME=/dev/vga_arbiter
  E: MAJOR=10
  E: MINOR=63
  E: DEVLINKS=/dev/char/10:63
  
  P: /devices/virtual/net/lo
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/net/lo
  E: SUBSYSTEM=net
  E: INTERFACE=lo
  E: IFINDEX=1
  
  P: /devices/virtual/net/vboxnet0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/net/vboxnet0
  E: SUBSYSTEM=net
  E: INTERFACE=vboxnet0
  E: IFINDEX=4
  
  P: /devices/virtual/ppp/ppp
  N: ppp
  S: char/108:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/ppp/ppp
  E: SUBSYSTEM=ppp
  E: DEVNAME=/dev/ppp
  E: MAJOR=108
  E: MINOR=0
  E: DEVLINKS=/dev/char/108:0
  
  P: /devices/virtual/sound/seq
  N: snd/seq
  S: char/116:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/sound/seq
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/seq
  E: MAJOR=116
  E: MINOR=3
  E: DEVLINKS=/dev/char/116:3
  E: TAGS=:udev-acl:
  
  P: /devices/virtual/sound/timer
  N: snd/timer
  S: char/116:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/sound/timer
  E: SUBSYSTEM=sound
  E: DEVNAME=snd/timer
  E: MAJOR=116
  E: MINOR=2
  E: DEVLINKS=/dev/char/116:2
  E: TAGS=:udev-acl:
  
  P: /devices/virtual/thermal/cooling_device0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/thermal/cooling_device0
  E: SUBSYSTEM=thermal
  
  P: /devices/virtual/thermal/cooling_device1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/thermal/cooling_device1
  E: SUBSYSTEM=thermal
  
  P: /devices/virtual/thermal/cooling_device2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/thermal/cooling_device2
  E: SUBSYSTEM=thermal
  
  P: /devices/virtual/thermal/thermal_zone0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/thermal/thermal_zone0
  E: SUBSYSTEM=thermal
  
  P: /devices/virtual/thermal/thermal_zone1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/thermal/thermal_zone1
  E: SUBSYSTEM=thermal
  
  P: /devices/virtual/tty/console
  N: console
  S: char/5:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/console
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/console
  E: MAJOR=5
  E: MINOR=1
  E: DEVLINKS=/dev/char/5:1
  
  P: /devices/virtual/tty/ptmx
  N: ptmx
  S: char/5:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/ptmx
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/ptmx
  E: MAJOR=5
  E: MINOR=2
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/5:2
  
  P: /devices/virtual/tty/tty
  N: tty
  S: char/5:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty
  E: MAJOR=5
  E: MINOR=0
  E: DEVMODE=0666
  E: DEVLINKS=/dev/char/5:0
  
  P: /devices/virtual/tty/tty0
  N: tty0
  S: char/4:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty0
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty0
  E: MAJOR=4
  E: MINOR=0
  E: DEVLINKS=/dev/char/4:0
  
  P: /devices/virtual/tty/tty1
  N: tty1
  S: char/4:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty1
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty1
  E: MAJOR=4
  E: MINOR=1
  E: DEVLINKS=/dev/char/4:1
  
  P: /devices/virtual/tty/tty10
  N: tty10
  S: char/4:10
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty10
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty10
  E: MAJOR=4
  E: MINOR=10
  E: DEVLINKS=/dev/char/4:10
  
  P: /devices/virtual/tty/tty11
  N: tty11
  S: char/4:11
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty11
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty11
  E: MAJOR=4
  E: MINOR=11
  E: DEVLINKS=/dev/char/4:11
  
  P: /devices/virtual/tty/tty12
  N: tty12
  S: char/4:12
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty12
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty12
  E: MAJOR=4
  E: MINOR=12
  E: DEVLINKS=/dev/char/4:12
  
  P: /devices/virtual/tty/tty13
  N: tty13
  S: char/4:13
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty13
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty13
  E: MAJOR=4
  E: MINOR=13
  E: DEVLINKS=/dev/char/4:13
  
  P: /devices/virtual/tty/tty14
  N: tty14
  S: char/4:14
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty14
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty14
  E: MAJOR=4
  E: MINOR=14
  E: DEVLINKS=/dev/char/4:14
  
  P: /devices/virtual/tty/tty15
  N: tty15
  S: char/4:15
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty15
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty15
  E: MAJOR=4
  E: MINOR=15
  E: DEVLINKS=/dev/char/4:15
  
  P: /devices/virtual/tty/tty16
  N: tty16
  S: char/4:16
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty16
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty16
  E: MAJOR=4
  E: MINOR=16
  E: DEVLINKS=/dev/char/4:16
  
  P: /devices/virtual/tty/tty17
  N: tty17
  S: char/4:17
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty17
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty17
  E: MAJOR=4
  E: MINOR=17
  E: DEVLINKS=/dev/char/4:17
  
  P: /devices/virtual/tty/tty18
  N: tty18
  S: char/4:18
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty18
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty18
  E: MAJOR=4
  E: MINOR=18
  E: DEVLINKS=/dev/char/4:18
  
  P: /devices/virtual/tty/tty19
  N: tty19
  S: char/4:19
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty19
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty19
  E: MAJOR=4
  E: MINOR=19
  E: DEVLINKS=/dev/char/4:19
  
  P: /devices/virtual/tty/tty2
  N: tty2
  S: char/4:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty2
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty2
  E: MAJOR=4
  E: MINOR=2
  E: DEVLINKS=/dev/char/4:2
  
  P: /devices/virtual/tty/tty20
  N: tty20
  S: char/4:20
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty20
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty20
  E: MAJOR=4
  E: MINOR=20
  E: DEVLINKS=/dev/char/4:20
  
  P: /devices/virtual/tty/tty21
  N: tty21
  S: char/4:21
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty21
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty21
  E: MAJOR=4
  E: MINOR=21
  E: DEVLINKS=/dev/char/4:21
  
  P: /devices/virtual/tty/tty22
  N: tty22
  S: char/4:22
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty22
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty22
  E: MAJOR=4
  E: MINOR=22
  E: DEVLINKS=/dev/char/4:22
  
  P: /devices/virtual/tty/tty23
  N: tty23
  S: char/4:23
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty23
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty23
  E: MAJOR=4
  E: MINOR=23
  E: DEVLINKS=/dev/char/4:23
  
  P: /devices/virtual/tty/tty24
  N: tty24
  S: char/4:24
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty24
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty24
  E: MAJOR=4
  E: MINOR=24
  E: DEVLINKS=/dev/char/4:24
  
  P: /devices/virtual/tty/tty25
  N: tty25
  S: char/4:25
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty25
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty25
  E: MAJOR=4
  E: MINOR=25
  E: DEVLINKS=/dev/char/4:25
  
  P: /devices/virtual/tty/tty26
  N: tty26
  S: char/4:26
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty26
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty26
  E: MAJOR=4
  E: MINOR=26
  E: DEVLINKS=/dev/char/4:26
  
  P: /devices/virtual/tty/tty27
  N: tty27
  S: char/4:27
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty27
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty27
  E: MAJOR=4
  E: MINOR=27
  E: DEVLINKS=/dev/char/4:27
  
  P: /devices/virtual/tty/tty28
  N: tty28
  S: char/4:28
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty28
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty28
  E: MAJOR=4
  E: MINOR=28
  E: DEVLINKS=/dev/char/4:28
  
  P: /devices/virtual/tty/tty29
  N: tty29
  S: char/4:29
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty29
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty29
  E: MAJOR=4
  E: MINOR=29
  E: DEVLINKS=/dev/char/4:29
  
  P: /devices/virtual/tty/tty3
  N: tty3
  S: char/4:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty3
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty3
  E: MAJOR=4
  E: MINOR=3
  E: DEVLINKS=/dev/char/4:3
  
  P: /devices/virtual/tty/tty30
  N: tty30
  S: char/4:30
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty30
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty30
  E: MAJOR=4
  E: MINOR=30
  E: DEVLINKS=/dev/char/4:30
  
  P: /devices/virtual/tty/tty31
  N: tty31
  S: char/4:31
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty31
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty31
  E: MAJOR=4
  E: MINOR=31
  E: DEVLINKS=/dev/char/4:31
  
  P: /devices/virtual/tty/tty32
  N: tty32
  S: char/4:32
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty32
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty32
  E: MAJOR=4
  E: MINOR=32
  E: DEVLINKS=/dev/char/4:32
  
  P: /devices/virtual/tty/tty33
  N: tty33
  S: char/4:33
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty33
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty33
  E: MAJOR=4
  E: MINOR=33
  E: DEVLINKS=/dev/char/4:33
  
  P: /devices/virtual/tty/tty34
  N: tty34
  S: char/4:34
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty34
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty34
  E: MAJOR=4
  E: MINOR=34
  E: DEVLINKS=/dev/char/4:34
  
  P: /devices/virtual/tty/tty35
  N: tty35
  S: char/4:35
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty35
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty35
  E: MAJOR=4
  E: MINOR=35
  E: DEVLINKS=/dev/char/4:35
  
  P: /devices/virtual/tty/tty36
  N: tty36
  S: char/4:36
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty36
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty36
  E: MAJOR=4
  E: MINOR=36
  E: DEVLINKS=/dev/char/4:36
  
  P: /devices/virtual/tty/tty37
  N: tty37
  S: char/4:37
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty37
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty37
  E: MAJOR=4
  E: MINOR=37
  E: DEVLINKS=/dev/char/4:37
  
  P: /devices/virtual/tty/tty38
  N: tty38
  S: char/4:38
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty38
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty38
  E: MAJOR=4
  E: MINOR=38
  E: DEVLINKS=/dev/char/4:38
  
  P: /devices/virtual/tty/tty39
  N: tty39
  S: char/4:39
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty39
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty39
  E: MAJOR=4
  E: MINOR=39
  E: DEVLINKS=/dev/char/4:39
  
  P: /devices/virtual/tty/tty4
  N: tty4
  S: char/4:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty4
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty4
  E: MAJOR=4
  E: MINOR=4
  E: DEVLINKS=/dev/char/4:4
  
  P: /devices/virtual/tty/tty40
  N: tty40
  S: char/4:40
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty40
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty40
  E: MAJOR=4
  E: MINOR=40
  E: DEVLINKS=/dev/char/4:40
  
  P: /devices/virtual/tty/tty41
  N: tty41
  S: char/4:41
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty41
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty41
  E: MAJOR=4
  E: MINOR=41
  E: DEVLINKS=/dev/char/4:41
  
  P: /devices/virtual/tty/tty42
  N: tty42
  S: char/4:42
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty42
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty42
  E: MAJOR=4
  E: MINOR=42
  E: DEVLINKS=/dev/char/4:42
  
  P: /devices/virtual/tty/tty43
  N: tty43
  S: char/4:43
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty43
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty43
  E: MAJOR=4
  E: MINOR=43
  E: DEVLINKS=/dev/char/4:43
  
  P: /devices/virtual/tty/tty44
  N: tty44
  S: char/4:44
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty44
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty44
  E: MAJOR=4
  E: MINOR=44
  E: DEVLINKS=/dev/char/4:44
  
  P: /devices/virtual/tty/tty45
  N: tty45
  S: char/4:45
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty45
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty45
  E: MAJOR=4
  E: MINOR=45
  E: DEVLINKS=/dev/char/4:45
  
  P: /devices/virtual/tty/tty46
  N: tty46
  S: char/4:46
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty46
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty46
  E: MAJOR=4
  E: MINOR=46
  E: DEVLINKS=/dev/char/4:46
  
  P: /devices/virtual/tty/tty47
  N: tty47
  S: char/4:47
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty47
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty47
  E: MAJOR=4
  E: MINOR=47
  E: DEVLINKS=/dev/char/4:47
  
  P: /devices/virtual/tty/tty48
  N: tty48
  S: char/4:48
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty48
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty48
  E: MAJOR=4
  E: MINOR=48
  E: DEVLINKS=/dev/char/4:48
  
  P: /devices/virtual/tty/tty49
  N: tty49
  S: char/4:49
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty49
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty49
  E: MAJOR=4
  E: MINOR=49
  E: DEVLINKS=/dev/char/4:49
  
  P: /devices/virtual/tty/tty5
  N: tty5
  S: char/4:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty5
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty5
  E: MAJOR=4
  E: MINOR=5
  E: DEVLINKS=/dev/char/4:5
  
  P: /devices/virtual/tty/tty50
  N: tty50
  S: char/4:50
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty50
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty50
  E: MAJOR=4
  E: MINOR=50
  E: DEVLINKS=/dev/char/4:50
  
  P: /devices/virtual/tty/tty51
  N: tty51
  S: char/4:51
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty51
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty51
  E: MAJOR=4
  E: MINOR=51
  E: DEVLINKS=/dev/char/4:51
  
  P: /devices/virtual/tty/tty52
  N: tty52
  S: char/4:52
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty52
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty52
  E: MAJOR=4
  E: MINOR=52
  E: DEVLINKS=/dev/char/4:52
  
  P: /devices/virtual/tty/tty53
  N: tty53
  S: char/4:53
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty53
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty53
  E: MAJOR=4
  E: MINOR=53
  E: DEVLINKS=/dev/char/4:53
  
  P: /devices/virtual/tty/tty54
  N: tty54
  S: char/4:54
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty54
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty54
  E: MAJOR=4
  E: MINOR=54
  E: DEVLINKS=/dev/char/4:54
  
  P: /devices/virtual/tty/tty55
  N: tty55
  S: char/4:55
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty55
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty55
  E: MAJOR=4
  E: MINOR=55
  E: DEVLINKS=/dev/char/4:55
  
  P: /devices/virtual/tty/tty56
  N: tty56
  S: char/4:56
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty56
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty56
  E: MAJOR=4
  E: MINOR=56
  E: DEVLINKS=/dev/char/4:56
  
  P: /devices/virtual/tty/tty57
  N: tty57
  S: char/4:57
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty57
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty57
  E: MAJOR=4
  E: MINOR=57
  E: DEVLINKS=/dev/char/4:57
  
  P: /devices/virtual/tty/tty58
  N: tty58
  S: char/4:58
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty58
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty58
  E: MAJOR=4
  E: MINOR=58
  E: DEVLINKS=/dev/char/4:58
  
  P: /devices/virtual/tty/tty59
  N: tty59
  S: char/4:59
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty59
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty59
  E: MAJOR=4
  E: MINOR=59
  E: DEVLINKS=/dev/char/4:59
  
  P: /devices/virtual/tty/tty6
  N: tty6
  S: char/4:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty6
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty6
  E: MAJOR=4
  E: MINOR=6
  E: DEVLINKS=/dev/char/4:6
  
  P: /devices/virtual/tty/tty60
  N: tty60
  S: char/4:60
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty60
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty60
  E: MAJOR=4
  E: MINOR=60
  E: DEVLINKS=/dev/char/4:60
  
  P: /devices/virtual/tty/tty61
  N: tty61
  S: char/4:61
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty61
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty61
  E: MAJOR=4
  E: MINOR=61
  E: DEVLINKS=/dev/char/4:61
  
  P: /devices/virtual/tty/tty62
  N: tty62
  S: char/4:62
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty62
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty62
  E: MAJOR=4
  E: MINOR=62
  E: DEVLINKS=/dev/char/4:62
  
  P: /devices/virtual/tty/tty63
  N: tty63
  S: char/4:63
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty63
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty63
  E: MAJOR=4
  E: MINOR=63
  E: DEVLINKS=/dev/char/4:63
  
  P: /devices/virtual/tty/tty7
  N: tty7
  S: char/4:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty7
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty7
  E: MAJOR=4
  E: MINOR=7
  E: DEVLINKS=/dev/char/4:7
  
  P: /devices/virtual/tty/tty8
  N: tty8
  S: char/4:8
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty8
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty8
  E: MAJOR=4
  E: MINOR=8
  E: DEVLINKS=/dev/char/4:8
  
  P: /devices/virtual/tty/tty9
  N: tty9
  S: char/4:9
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/tty/tty9
  E: SUBSYSTEM=tty
  E: DEVNAME=/dev/tty9
  E: MAJOR=4
  E: MINOR=9
  E: DEVLINKS=/dev/char/4:9
  
  P: /devices/virtual/usbmon/usbmon0
  N: usbmon0
  S: char/252:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/usbmon/usbmon0
  E: SUBSYSTEM=usbmon
  E: DEVNAME=/dev/usbmon0
  E: MAJOR=252
  E: MINOR=0
  E: DEVLINKS=/dev/char/252:0
  
  P: /devices/virtual/vc/vcs
  N: vcs
  S: char/7:0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs
  E: MAJOR=7
  E: MINOR=0
  E: DEVLINKS=/dev/char/7:0
  
  P: /devices/virtual/vc/vcs1
  N: vcs1
  S: char/7:1
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs1
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs1
  E: MAJOR=7
  E: MINOR=1
  E: DEVLINKS=/dev/char/7:1
  
  P: /devices/virtual/vc/vcs2
  N: vcs2
  S: char/7:2
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs2
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs2
  E: MAJOR=7
  E: MINOR=2
  E: DEVLINKS=/dev/char/7:2
  
  P: /devices/virtual/vc/vcs3
  N: vcs3
  S: char/7:3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs3
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs3
  E: MAJOR=7
  E: MINOR=3
  E: DEVLINKS=/dev/char/7:3
  
  P: /devices/virtual/vc/vcs4
  N: vcs4
  S: char/7:4
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs4
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs4
  E: MAJOR=7
  E: MINOR=4
  E: DEVLINKS=/dev/char/7:4
  
  P: /devices/virtual/vc/vcs5
  N: vcs5
  S: char/7:5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs5
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs5
  E: MAJOR=7
  E: MINOR=5
  E: DEVLINKS=/dev/char/7:5
  
  P: /devices/virtual/vc/vcs6
  N: vcs6
  S: char/7:6
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs6
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs6
  E: MAJOR=7
  E: MINOR=6
  E: DEVLINKS=/dev/char/7:6
  
  P: /devices/virtual/vc/vcs7
  N: vcs7
  S: char/7:7
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcs7
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcs7
  E: MAJOR=7
  E: MINOR=7
  E: DEVLINKS=/dev/char/7:7
  
  P: /devices/virtual/vc/vcsa
  N: vcsa
  S: char/7:128
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa
  E: MAJOR=7
  E: MINOR=128
  E: DEVLINKS=/dev/char/7:128
  
  P: /devices/virtual/vc/vcsa1
  N: vcsa1
  S: char/7:129
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa1
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa1
  E: MAJOR=7
  E: MINOR=129
  E: DEVLINKS=/dev/char/7:129
  
  P: /devices/virtual/vc/vcsa2
  N: vcsa2
  S: char/7:130
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa2
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa2
  E: MAJOR=7
  E: MINOR=130
  E: DEVLINKS=/dev/char/7:130
  
  P: /devices/virtual/vc/vcsa3
  N: vcsa3
  S: char/7:131
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa3
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa3
  E: MAJOR=7
  E: MINOR=131
  E: DEVLINKS=/dev/char/7:131
  
  P: /devices/virtual/vc/vcsa4
  N: vcsa4
  S: char/7:132
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa4
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa4
  E: MAJOR=7
  E: MINOR=132
  E: DEVLINKS=/dev/char/7:132
  
  P: /devices/virtual/vc/vcsa5
  N: vcsa5
  S: char/7:133
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa5
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa5
  E: MAJOR=7
  E: MINOR=133
  E: DEVLINKS=/dev/char/7:133
  
  P: /devices/virtual/vc/vcsa6
  N: vcsa6
  S: char/7:134
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa6
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa6
  E: MAJOR=7
  E: MINOR=134
  E: DEVLINKS=/dev/char/7:134
  
  P: /devices/virtual/vc/vcsa7
  N: vcsa7
  S: char/7:135
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vc/vcsa7
  E: SUBSYSTEM=vc
  E: DEVNAME=/dev/vcsa7
  E: MAJOR=7
  E: MINOR=135
  E: DEVLINKS=/dev/char/7:135
  
  P: /devices/virtual/video_output/acpi_video0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/video_output/acpi_video0
  E: SUBSYSTEM=video_output
  
  P: /devices/virtual/vtconsole/vtcon0
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/vtconsole/vtcon0
  E: SUBSYSTEM=vtconsole
  
  P: /devices/virtual/wmi/05901221-D566-11D1-B2F0-00A0C9062910
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/05901221-D566-11D1-B2F0-00A0C9062910
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:05901221-D566-11D1-B2F0-00A0C9062910
  
  P: /devices/virtual/wmi/40D1BF71-A82D-4E59-A168-3985E03B2E87
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/40D1BF71-A82D-4E59-A168-3985E03B2E87
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:40D1BF71-A82D-4E59-A168-3985E03B2E87
  
  P: /devices/virtual/wmi/431F16ED-0C2B-444C-B267-27DEB140CF9C
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/431F16ED-0C2B-444C-B267-27DEB140CF9C
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:431F16ED-0C2B-444C-B267-27DEB140CF9C
  
  P: /devices/virtual/wmi/5923DD45-0480-4ED5-B61A-C9EC6C90E26A
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/5923DD45-0480-4ED5-B61A-C9EC6C90E26A
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:5923DD45-0480-4ED5-B61A-C9EC6C90E26A
  
  P: /devices/virtual/wmi/61EF69EA-865C-4BC3-A502-A0DEBA0CB531
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/61EF69EA-865C-4BC3-A502-A0DEBA0CB531
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:61EF69EA-865C-4BC3-A502-A0DEBA0CB531
  
  P: /devices/virtual/wmi/676AA15E-6A47-4D9F-A2CC-1E6D18D14026
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/676AA15E-6A47-4D9F-A2CC-1E6D18D14026
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026
  
  P: /devices/virtual/wmi/67C3371D-95A3-4C37-BB61-DD47B491DAAB
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/67C3371D-95A3-4C37-BB61-DD47B491DAAB
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:67C3371D-95A3-4C37-BB61-DD47B491DAAB
  
  P: /devices/virtual/wmi/6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3
  
  P: /devices/virtual/wmi/79772EC5-04B1-4BFD-843C-61E7F77B6CC9
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/79772EC5-04B1-4BFD-843C-61E7F77B6CC9
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:79772EC5-04B1-4BFD-843C-61E7F77B6CC9
  
  P: /devices/virtual/wmi/83B9D139-CE71-45DB-A7A6-2628D3A65F4C
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/83B9D139-CE71-45DB-A7A6-2628D3A65F4C
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:83B9D139-CE71-45DB-A7A6-2628D3A65F4C
  
  P: /devices/virtual/wmi/95764E09-FB56-4E83-B31A-37761F60994A
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/95764E09-FB56-4E83-B31A-37761F60994A
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:95764E09-FB56-4E83-B31A-37761F60994A
  
  P: /devices/virtual/wmi/AAE04F7B-B3C5-4865-95D6-9FAC7FF3E92B
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/AAE04F7B-B3C5-4865-95D6-9FAC7FF3E92B
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:AAE04F7B-B3C5-4865-95D6-9FAC7FF3E92B
  
  P: /devices/virtual/wmi/CC1A61AC-4256-41A3-B9E0-05A445ADE2F5
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/CC1A61AC-4256-41A3-B9E0-05A445ADE2F5
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:CC1A61AC-4256-41A3-B9E0-05A445ADE2F5
  
  P: /devices/virtual/wmi/CFF94C79-6C77-4AF7-AC56-7DD0CE01C997
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/CFF94C79-6C77-4AF7-AC56-7DD0CE01C997
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:CFF94C79-6C77-4AF7-AC56-7DD0CE01C997
  
  P: /devices/virtual/wmi/D9F41781-F633-4400-9355-601770BEC510
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/D9F41781-F633-4400-9355-601770BEC510
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:D9F41781-F633-4400-9355-601770BEC510
  
  P: /devices/virtual/wmi/E78C4453-0227-4861-9EDE-F5600B4A3D39
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/E78C4453-0227-4861-9EDE-F5600B4A3D39
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:E78C4453-0227-4861-9EDE-F5600B4A3D39
  
  P: /devices/virtual/wmi/FAAA1397-1188-448F-8516-9A07987DD38A
  E: UDEV_LOG=3
  E: DEVPATH=/devices/virtual/wmi/FAAA1397-1188-448F-8516-9A07987DD38A
  E: SUBSYSTEM=wmi
  E: MODALIAS=wmi:FAAA1397-1188-448F-8516-9A07987DD38A
  
-----  udevinfo end -----
/devices/LNXSYSTM:00
/devices/LNXSYSTM:00/LNXCPU:00
/devices/LNXSYSTM:00/LNXCPU:01
/devices/LNXSYSTM:00/LNXPWRBN:00
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3
  name: /dev/input/event3
  links: /dev/char/13:67
/devices/LNXSYSTM:00/LNXSYBUS:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C02:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:01
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:02
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:03
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/device:04
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/device:05
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:07
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:08
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:09
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/LNXVIDEO:01/device:0a
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/device:0b
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/device:0d
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e/device:0f
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10/device:11
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12/device:13
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14/device:15
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:16
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:16/device:17
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/device:19
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:18/device:19/device:1a
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b/device:1c
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1b/device:1c/device:1d
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:21
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23/device:24
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/device:23/device:25
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27/device:28
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:26/device:27/device:29
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b/device:2c
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2a/device:2b/device:2d
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2e
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2f
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:30
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:32
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:33
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:31/device:34
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:35
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0000:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0100:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0200:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0303:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0800:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0B00:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C01:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C02:01
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C04:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/ACPI0003:00/power_supply/ADP1
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C09:00/PNP0C0A:00/power_supply/BAT0
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:01
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:02
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:03
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:04
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:05
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:06
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/PNP0C0F:07
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:36/SYN1B37:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:37
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:38
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:38/device:39
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a/device:3b
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3c
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3d
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:3f
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:40
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:41
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/device:42
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5/event5
  name: /dev/input/event5
  links: /dev/char/13:69
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0
  name: /dev/input/event0
  links: /dev/char/13:64
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1/event1
  name: /dev/input/event1
  links: /dev/char/13:65
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2/event2
  name: /dev/input/event2
  links: /dev/char/13:66
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:01
/devices/LNXSYSTM:00/LNXTHERM:00
/devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:01
/devices/LNXSYSTM:00/LNXTHERM:00/LNXTHERM:02
/devices/pci0000:00/0000:00:00.0
/devices/pci0000:00/0000:00:01.0
/devices/pci0000:00/0000:00:01.0/0000:01:05.0
/devices/pci0000:00/0000:00:01.0/0000:01:05.1
/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1
/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/hwC1D0
  name: /dev/snd/hwC1D0
  links: /dev/char/116:10
/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/pcmC1D3p
  name: /dev/snd/pcmC1D3p
  links: /dev/char/116:9
/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/controlC1
  name: /dev/snd/controlC1
  links: /dev/char/116:11, /dev/snd/by-path/pci-0000:01:05.1
/devices/pci0000:00/0000:00:01.0/pci_bus/0000:01
/devices/pci0000:00/0000:00:04.0
/devices/pci0000:00/0000:00:04.0/0000:00:04.0:pcie01
/devices/pci0000:00/0000:00:04.0/0000:00:04.0:pcie08
/devices/pci0000:00/0000:00:04.0/0000:03:00.0
/devices/pci0000:00/0000:00:04.0/0000:03:00.0/net/eth0
/devices/pci0000:00/0000:00:04.0/pci_bus/0000:03
/devices/pci0000:00/0000:00:05.0
/devices/pci0000:00/0000:00:05.0/0000:00:05.0:pcie01
/devices/pci0000:00/0000:00:05.0/0000:00:05.0:pcie08
/devices/pci0000:00/0000:00:05.0/0000:06:00.0
/devices/pci0000:00/0000:00:05.0/pci_bus/0000:06
/devices/pci0000:00/0000:00:11.0
/devices/pci0000:00/0000:00:11.0/host2
/devices/pci0000:00/0000:00:11.0/host2/scsi_host/host2
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda
  name: /dev/sda
  links: /dev/block/8:0, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0, /dev/disk/by-id/wwn-0x50014ee2af462d20
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda1
  name: /dev/sda1
  links: /dev/block/8:1, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part1, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part1, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part1, /dev/disk/by-uuid/85c51aea-99ce-4a1a-9c1a-5af285a7f145, /dev/disk/by-id/wwn-0x50014ee2af462d20-part1, /dev/root
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda2
  name: /dev/sda2
  links: /dev/block/8:2, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part2, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part2, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2, /dev/disk/by-id/wwn-0x50014ee2af462d20-part2
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sda/sda5
  name: /dev/sda5
  links: /dev/block/8:5, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part5, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part5, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part5, /dev/disk/by-uuid/6138fe8c-9476-4396-aa5f-a88c0dc55e29, /dev/disk/by-id/wwn-0x50014ee2af462d20-part5
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/bsg/2:0:0:0
  name: /dev/bsg/2:0:0:0
  links: /dev/char/253:0
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_device/2:0:0:0
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_disk/2:0:0:0
/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/scsi_generic/sg0
  name: /dev/sg0
  links: /dev/char/21:0
/devices/pci0000:00/0000:00:12.0
/devices/pci0000:00/0000:00:12.0/usb4
  name: /dev/bus/usb/004/001
  links: /dev/char/189:384
/devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
/devices/pci0000:00/0000:00:12.0/usbmon/usbmon4
  name: /dev/usbmon4
  links: /dev/char/252:4
/devices/pci0000:00/0000:00:12.2
/devices/pci0000:00/0000:00:12.2/usb1
  name: /dev/bus/usb/001/001
  links: /dev/char/189:0
/devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
/devices/pci0000:00/0000:00:12.2/usb1/1-5
  name: /dev/bus/usb/001/002
  links: /dev/char/189:1
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/scsi_host/host3
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/block/sdb
  name: /dev/sdb
  links: /dev/block/8:16, /dev/disk/by-id/usb-Generic-_Multi-Card_20090516388200000-0:0, /dev/disk/by-path/pci-0000:00:12.2-usb-0:5:1.0-scsi-0:0:0:0
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/bsg/3:0:0:0
  name: /dev/bsg/3:0:0:0
  links: /dev/char/253:1
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_device/3:0:0:0
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_disk/3:0:0:0
/devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0/scsi_generic/sg1
  name: /dev/sg1
  links: /dev/char/21:1
/devices/pci0000:00/0000:00:12.2/usbmon/usbmon1
  name: /dev/usbmon1
  links: /dev/char/252:1
/devices/pci0000:00/0000:00:13.0
/devices/pci0000:00/0000:00:13.0/usb5
  name: /dev/bus/usb/005/001
  links: /dev/char/189:512
/devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
/devices/pci0000:00/0000:00:13.0/usbmon/usbmon5
  name: /dev/usbmon5
  links: /dev/char/252:5
/devices/pci0000:00/0000:00:13.2
/devices/pci0000:00/0000:00:13.2/usb2
  name: /dev/bus/usb/002/001
  links: /dev/char/189:128
/devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
/devices/pci0000:00/0000:00:13.2/usb2/2-5
  name: /dev/bus/usb/002/003
  links: /dev/char/189:130
/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6
/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6/event6
  name: /dev/input/event6
  links: /dev/char/13:70, /dev/input/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-event-if00, /dev/input/by-path/pci-0000:00:13.2-usb-0:5:1.0-event
/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/video4linux/video0
  name: /dev/video0
  links: /dev/char/81:0, /dev/v4l/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-video-index0, /dev/v4l/by-path/pci-0000:00:13.2-usb-0:5:1.0-video-index0
/devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.1
/devices/pci0000:00/0000:00:13.2/usbmon/usbmon2
  name: /dev/usbmon2
  links: /dev/char/252:2
/devices/pci0000:00/0000:00:14.0
/devices/pci0000:00/0000:00:14.1
/devices/pci0000:00/0000:00:14.1/host0
/devices/pci0000:00/0000:00:14.1/host0/scsi_host/host0
/devices/pci0000:00/0000:00:14.1/host1
/devices/pci0000:00/0000:00:14.1/host1/scsi_host/host1
/devices/pci0000:00/0000:00:14.2
/devices/pci0000:00/0000:00:14.2/sound/card0
/devices/pci0000:00/0000:00:14.2/sound/card0/hwC0D0
  name: /dev/snd/hwC0D0
  links: /dev/char/116:7
/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0c
  name: /dev/snd/pcmC0D0c
  links: /dev/char/116:6
/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D0p
  name: /dev/snd/pcmC0D0p
  links: /dev/char/116:5
/devices/pci0000:00/0000:00:14.2/sound/card0/pcmC0D1p
  name: /dev/snd/pcmC0D1p
  links: /dev/char/116:4
/devices/pci0000:00/0000:00:14.2/sound/card0/controlC0
  name: /dev/snd/controlC0
  links: /dev/char/116:8, /dev/snd/by-path/pci-0000:00:14.2
/devices/pci0000:00/0000:00:14.3
/devices/pci0000:00/0000:00:14.4
/devices/pci0000:00/0000:00:14.4/pci_bus/0000:07
/devices/pci0000:00/0000:00:16.0
/devices/pci0000:00/0000:00:16.0/usb6
  name: /dev/bus/usb/006/001
  links: /dev/char/189:640
/devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
/devices/pci0000:00/0000:00:16.0/usbmon/usbmon6
  name: /dev/usbmon6
  links: /dev/char/252:6
/devices/pci0000:00/0000:00:16.2
/devices/pci0000:00/0000:00:16.2/usb3
  name: /dev/bus/usb/003/001
  links: /dev/char/189:256
/devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
/devices/pci0000:00/0000:00:16.2/usbmon/usbmon3
  name: /dev/usbmon3
  links: /dev/char/252:3
/devices/pci0000:00/0000:00:18.0
/devices/pci0000:00/0000:00:18.1
/devices/pci0000:00/0000:00:18.2
/devices/pci0000:00/0000:00:18.3
/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1
/devices/pci0000:00/0000:00:18.4
/devices/pci0000:00/pci_bus/0000:00
/devices/platform/Fixed
/devices/platform/Fixed
/devices/platform/acer-wmi
/devices/platform/acer-wmi/rfkill/rfkill0
/devices/platform/i8042
/devices/platform/i8042/serio0
/devices/platform/i8042/serio0/input/input4
/devices/platform/i8042/serio0/input/input4/event4
  name: /dev/input/event4
  links: /dev/char/13:68, /dev/input/by-path/platform-i8042-serio-0-event-kbd
/devices/platform/i8042/serio1
/devices/platform/i8042/serio1/input/input7
/devices/platform/i8042/serio1/input/input7/event7
  name: /dev/input/event7
  links: /dev/char/13:71, /dev/input/by-path/platform-i8042-serio-1-event-mouse
/devices/platform/i8042/serio1/input/input7/mouse0
  name: /dev/input/mouse0
  links: /dev/char/13:32, /dev/input/by-path/platform-i8042-serio-1-mouse
/devices/platform/pcspkr
/devices/platform/serial8250
/devices/platform/serial8250/tty/ttyS0
  name: /dev/ttyS0
  links: /dev/char/4:64
/devices/platform/serial8250/tty/ttyS1
  name: /dev/ttyS1
  links: /dev/char/4:65
/devices/platform/serial8250/tty/ttyS2
  name: /dev/ttyS2
  links: /dev/char/4:66
/devices/platform/serial8250/tty/ttyS3
  name: /dev/ttyS3
  links: /dev/char/4:67
/devices/platform/vboxdrv.0
/devices/pnp0/00:00
/devices/pnp0/00:01
/devices/pnp0/00:02
/devices/pnp0/00:03
/devices/pnp0/00:04
/devices/pnp0/00:04/rtc/rtc0
  name: /dev/rtc0
  links: /dev/char/254:0, /dev/rtc
/devices/pnp0/00:05
/devices/pnp0/00:06
/devices/pnp0/00:07
/devices/pnp0/00:08
/devices/pnp0/00:09
/devices/virtual/backlight/acpi_video0
/devices/virtual/bdi/0:20
/devices/virtual/bdi/1:0
/devices/virtual/bdi/1:1
/devices/virtual/bdi/1:10
/devices/virtual/bdi/1:11
/devices/virtual/bdi/1:12
/devices/virtual/bdi/1:13
/devices/virtual/bdi/1:14
/devices/virtual/bdi/1:15
/devices/virtual/bdi/1:2
/devices/virtual/bdi/1:3
/devices/virtual/bdi/1:4
/devices/virtual/bdi/1:5
/devices/virtual/bdi/1:6
/devices/virtual/bdi/1:7
/devices/virtual/bdi/1:8
/devices/virtual/bdi/1:9
/devices/virtual/bdi/7:0
/devices/virtual/bdi/7:1
/devices/virtual/bdi/7:2
/devices/virtual/bdi/7:3
/devices/virtual/bdi/7:4
/devices/virtual/bdi/7:5
/devices/virtual/bdi/7:6
/devices/virtual/bdi/7:7
/devices/virtual/bdi/8:0
/devices/virtual/bdi/8:16
/devices/virtual/bdi/default
/devices/virtual/block/loop0
  name: /dev/loop0
  links: /dev/block/7:0
/devices/virtual/block/loop1
  name: /dev/loop1
  links: /dev/block/7:1
/devices/virtual/block/loop2
  name: /dev/loop2
  links: /dev/block/7:2
/devices/virtual/block/loop3
  name: /dev/loop3
  links: /dev/block/7:3
/devices/virtual/block/loop4
  name: /dev/loop4
  links: /dev/block/7:4
/devices/virtual/block/loop5
  name: /dev/loop5
  links: /dev/block/7:5
/devices/virtual/block/loop6
  name: /dev/loop6
  links: /dev/block/7:6
/devices/virtual/block/loop7
  name: /dev/loop7
  links: /dev/block/7:7
/devices/virtual/block/ram0
  name: /dev/ram0
  links: /dev/block/1:0
/devices/virtual/block/ram1
  name: /dev/ram1
  links: /dev/block/1:1
/devices/virtual/block/ram10
  name: /dev/ram10
  links: /dev/block/1:10
/devices/virtual/block/ram11
  name: /dev/ram11
  links: /dev/block/1:11
/devices/virtual/block/ram12
  name: /dev/ram12
  links: /dev/block/1:12
/devices/virtual/block/ram13
  name: /dev/ram13
  links: /dev/block/1:13
/devices/virtual/block/ram14
  name: /dev/ram14
  links: /dev/block/1:14
/devices/virtual/block/ram15
  name: /dev/ram15
  links: /dev/block/1:15
/devices/virtual/block/ram2
  name: /dev/ram2
  links: /dev/block/1:2
/devices/virtual/block/ram3
  name: /dev/ram3
  links: /dev/block/1:3
/devices/virtual/block/ram4
  name: /dev/ram4
  links: /dev/block/1:4
/devices/virtual/block/ram5
  name: /dev/ram5
  links: /dev/block/1:5
/devices/virtual/block/ram6
  name: /dev/ram6
  links: /dev/block/1:6
/devices/virtual/block/ram7
  name: /dev/ram7
  links: /dev/block/1:7
/devices/virtual/block/ram8
  name: /dev/ram8
  links: /dev/block/1:8
/devices/virtual/block/ram9
  name: /dev/ram9
  links: /dev/block/1:9
/devices/virtual/dmi/id
/devices/virtual/graphics/fbcon
/devices/virtual/hwmon/hwmon0
/devices/virtual/input/mice
  name: /dev/input/mice
  links: /dev/char/13:63
/devices/virtual/mem/full
  name: /dev/full
  links: /dev/char/1:7
/devices/virtual/mem/kmsg
  name: /dev/kmsg
  links: /dev/char/1:11
/devices/virtual/mem/mem
  name: /dev/mem
  links: /dev/char/1:1
/devices/virtual/mem/null
  name: /dev/null
  links: /dev/char/1:3
/devices/virtual/mem/oldmem
  name: /dev/oldmem
  links: /dev/char/1:12
/devices/virtual/mem/port
  name: /dev/port
  links: /dev/char/1:4
/devices/virtual/mem/random
  name: /dev/random
  links: /dev/char/1:8
/devices/virtual/mem/urandom
  name: /dev/urandom
  links: /dev/char/1:9
/devices/virtual/mem/zero
  name: /dev/zero
  links: /dev/char/1:5
/devices/virtual/misc/cpu_dma_latency
  name: /dev/cpu_dma_latency
  links: /dev/char/10:58
/devices/virtual/misc/device-mapper
  name: /dev/mapper/control
  links: /dev/char/10:59
/devices/virtual/misc/ecryptfs
  name: /dev/ecryptfs
  links: /dev/char/10:61
/devices/virtual/misc/fuse
  name: /dev/fuse
  links: /dev/char/10:229
/devices/virtual/misc/hpet
  name: /dev/hpet
  links: /dev/char/10:228
/devices/virtual/misc/mcelog
  name: /dev/mcelog
  links: /dev/char/10:227
/devices/virtual/misc/network_latency
  name: /dev/network_latency
  links: /dev/char/10:57
/devices/virtual/misc/network_throughput
  name: /dev/network_throughput
  links: /dev/char/10:56
/devices/virtual/misc/pktcdvd
  name: /dev/pktcdvd/control
  links: /dev/char/10:60
/devices/virtual/misc/psaux
  name: /dev/psaux
  links: /dev/char/10:1
/devices/virtual/misc/rfkill
  name: /dev/rfkill
  links: /dev/char/10:62
/devices/virtual/misc/snapshot
  name: /dev/snapshot
  links: /dev/char/10:231
/devices/virtual/misc/tun
  name: /dev/net/tun
  links: /dev/char/10:200
/devices/virtual/misc/uinput
  name: /dev/uinput
  links: /dev/char/10:223
/devices/virtual/misc/vboxdrv
  name: /dev/vboxdrv
  links: /dev/char/10:55
/devices/virtual/misc/vboxnetctl
  name: /dev/vboxnetctl
  links: /dev/char/10:54
/devices/virtual/misc/vga_arbiter
  name: /dev/vga_arbiter
  links: /dev/char/10:63
/devices/virtual/net/lo
/devices/virtual/net/vboxnet0
/devices/virtual/ppp/ppp
  name: /dev/ppp
  links: /dev/char/108:0
/devices/virtual/sound/seq
  name: /dev/snd/seq
  links: /dev/char/116:3
/devices/virtual/sound/timer
  name: /dev/snd/timer
  links: /dev/char/116:2
/devices/virtual/thermal/cooling_device0
/devices/virtual/thermal/cooling_device1
/devices/virtual/thermal/cooling_device2
/devices/virtual/thermal/thermal_zone0
/devices/virtual/thermal/thermal_zone1
/devices/virtual/tty/console
  name: /dev/console
  links: /dev/char/5:1
/devices/virtual/tty/ptmx
  name: /dev/ptmx
  links: /dev/char/5:2
/devices/virtual/tty/tty
  name: /dev/tty
  links: /dev/char/5:0
/devices/virtual/tty/tty0
  name: /dev/tty0
  links: /dev/char/4:0
/devices/virtual/tty/tty1
  name: /dev/tty1
  links: /dev/char/4:1
/devices/virtual/tty/tty10
  name: /dev/tty10
  links: /dev/char/4:10
/devices/virtual/tty/tty11
  name: /dev/tty11
  links: /dev/char/4:11
/devices/virtual/tty/tty12
  name: /dev/tty12
  links: /dev/char/4:12
/devices/virtual/tty/tty13
  name: /dev/tty13
  links: /dev/char/4:13
/devices/virtual/tty/tty14
  name: /dev/tty14
  links: /dev/char/4:14
/devices/virtual/tty/tty15
  name: /dev/tty15
  links: /dev/char/4:15
/devices/virtual/tty/tty16
  name: /dev/tty16
  links: /dev/char/4:16
/devices/virtual/tty/tty17
  name: /dev/tty17
  links: /dev/char/4:17
/devices/virtual/tty/tty18
  name: /dev/tty18
  links: /dev/char/4:18
/devices/virtual/tty/tty19
  name: /dev/tty19
  links: /dev/char/4:19
/devices/virtual/tty/tty2
  name: /dev/tty2
  links: /dev/char/4:2
/devices/virtual/tty/tty20
  name: /dev/tty20
  links: /dev/char/4:20
/devices/virtual/tty/tty21
  name: /dev/tty21
  links: /dev/char/4:21
/devices/virtual/tty/tty22
  name: /dev/tty22
  links: /dev/char/4:22
/devices/virtual/tty/tty23
  name: /dev/tty23
  links: /dev/char/4:23
/devices/virtual/tty/tty24
  name: /dev/tty24
  links: /dev/char/4:24
/devices/virtual/tty/tty25
  name: /dev/tty25
  links: /dev/char/4:25
/devices/virtual/tty/tty26
  name: /dev/tty26
  links: /dev/char/4:26
/devices/virtual/tty/tty27
  name: /dev/tty27
  links: /dev/char/4:27
/devices/virtual/tty/tty28
  name: /dev/tty28
  links: /dev/char/4:28
/devices/virtual/tty/tty29
  name: /dev/tty29
  links: /dev/char/4:29
/devices/virtual/tty/tty3
  name: /dev/tty3
  links: /dev/char/4:3
/devices/virtual/tty/tty30
  name: /dev/tty30
  links: /dev/char/4:30
/devices/virtual/tty/tty31
  name: /dev/tty31
  links: /dev/char/4:31
/devices/virtual/tty/tty32
  name: /dev/tty32
  links: /dev/char/4:32
/devices/virtual/tty/tty33
  name: /dev/tty33
  links: /dev/char/4:33
/devices/virtual/tty/tty34
  name: /dev/tty34
  links: /dev/char/4:34
/devices/virtual/tty/tty35
  name: /dev/tty35
  links: /dev/char/4:35
/devices/virtual/tty/tty36
  name: /dev/tty36
  links: /dev/char/4:36
/devices/virtual/tty/tty37
  name: /dev/tty37
  links: /dev/char/4:37
/devices/virtual/tty/tty38
  name: /dev/tty38
  links: /dev/char/4:38
/devices/virtual/tty/tty39
  name: /dev/tty39
  links: /dev/char/4:39
/devices/virtual/tty/tty4
  name: /dev/tty4
  links: /dev/char/4:4
/devices/virtual/tty/tty40
  name: /dev/tty40
  links: /dev/char/4:40
/devices/virtual/tty/tty41
  name: /dev/tty41
  links: /dev/char/4:41
/devices/virtual/tty/tty42
  name: /dev/tty42
  links: /dev/char/4:42
/devices/virtual/tty/tty43
  name: /dev/tty43
  links: /dev/char/4:43
/devices/virtual/tty/tty44
  name: /dev/tty44
  links: /dev/char/4:44
/devices/virtual/tty/tty45
  name: /dev/tty45
  links: /dev/char/4:45
/devices/virtual/tty/tty46
  name: /dev/tty46
  links: /dev/char/4:46
/devices/virtual/tty/tty47
  name: /dev/tty47
  links: /dev/char/4:47
/devices/virtual/tty/tty48
  name: /dev/tty48
  links: /dev/char/4:48
/devices/virtual/tty/tty49
  name: /dev/tty49
  links: /dev/char/4:49
/devices/virtual/tty/tty5
  name: /dev/tty5
  links: /dev/char/4:5
/devices/virtual/tty/tty50
  name: /dev/tty50
  links: /dev/char/4:50
/devices/virtual/tty/tty51
  name: /dev/tty51
  links: /dev/char/4:51
/devices/virtual/tty/tty52
  name: /dev/tty52
  links: /dev/char/4:52
/devices/virtual/tty/tty53
  name: /dev/tty53
  links: /dev/char/4:53
/devices/virtual/tty/tty54
  name: /dev/tty54
  links: /dev/char/4:54
/devices/virtual/tty/tty55
  name: /dev/tty55
  links: /dev/char/4:55
/devices/virtual/tty/tty56
  name: /dev/tty56
  links: /dev/char/4:56
/devices/virtual/tty/tty57
  name: /dev/tty57
  links: /dev/char/4:57
/devices/virtual/tty/tty58
  name: /dev/tty58
  links: /dev/char/4:58
/devices/virtual/tty/tty59
  name: /dev/tty59
  links: /dev/char/4:59
/devices/virtual/tty/tty6
  name: /dev/tty6
  links: /dev/char/4:6
/devices/virtual/tty/tty60
  name: /dev/tty60
  links: /dev/char/4:60
/devices/virtual/tty/tty61
  name: /dev/tty61
  links: /dev/char/4:61
/devices/virtual/tty/tty62
  name: /dev/tty62
  links: /dev/char/4:62
/devices/virtual/tty/tty63
  name: /dev/tty63
  links: /dev/char/4:63
/devices/virtual/tty/tty7
  name: /dev/tty7
  links: /dev/char/4:7
/devices/virtual/tty/tty8
  name: /dev/tty8
  links: /dev/char/4:8
/devices/virtual/tty/tty9
  name: /dev/tty9
  links: /dev/char/4:9
/devices/virtual/usbmon/usbmon0
  name: /dev/usbmon0
  links: /dev/char/252:0
/devices/virtual/vc/vcs
  name: /dev/vcs
  links: /dev/char/7:0
/devices/virtual/vc/vcs1
  name: /dev/vcs1
  links: /dev/char/7:1
/devices/virtual/vc/vcs2
  name: /dev/vcs2
  links: /dev/char/7:2
/devices/virtual/vc/vcs3
  name: /dev/vcs3
  links: /dev/char/7:3
/devices/virtual/vc/vcs4
  name: /dev/vcs4
  links: /dev/char/7:4
/devices/virtual/vc/vcs5
  name: /dev/vcs5
  links: /dev/char/7:5
/devices/virtual/vc/vcs6
  name: /dev/vcs6
  links: /dev/char/7:6
/devices/virtual/vc/vcs7
  name: /dev/vcs7
  links: /dev/char/7:7
/devices/virtual/vc/vcsa
  name: /dev/vcsa
  links: /dev/char/7:128
/devices/virtual/vc/vcsa1
  name: /dev/vcsa1
  links: /dev/char/7:129
/devices/virtual/vc/vcsa2
  name: /dev/vcsa2
  links: /dev/char/7:130
/devices/virtual/vc/vcsa3
  name: /dev/vcsa3
  links: /dev/char/7:131
/devices/virtual/vc/vcsa4
  name: /dev/vcsa4
  links: /dev/char/7:132
/devices/virtual/vc/vcsa5
  name: /dev/vcsa5
  links: /dev/char/7:133
/devices/virtual/vc/vcsa6
  name: /dev/vcsa6
  links: /dev/char/7:134
/devices/virtual/vc/vcsa7
  name: /dev/vcsa7
  links: /dev/char/7:135
/devices/virtual/video_output/acpi_video0
/devices/virtual/vtconsole/vtcon0
/devices/virtual/wmi/05901221-D566-11D1-B2F0-00A0C9062910
/devices/virtual/wmi/40D1BF71-A82D-4E59-A168-3985E03B2E87
/devices/virtual/wmi/431F16ED-0C2B-444C-B267-27DEB140CF9C
/devices/virtual/wmi/5923DD45-0480-4ED5-B61A-C9EC6C90E26A
/devices/virtual/wmi/61EF69EA-865C-4BC3-A502-A0DEBA0CB531
/devices/virtual/wmi/676AA15E-6A47-4D9F-A2CC-1E6D18D14026
/devices/virtual/wmi/67C3371D-95A3-4C37-BB61-DD47B491DAAB
/devices/virtual/wmi/6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3
/devices/virtual/wmi/79772EC5-04B1-4BFD-843C-61E7F77B6CC9
/devices/virtual/wmi/83B9D139-CE71-45DB-A7A6-2628D3A65F4C
/devices/virtual/wmi/95764E09-FB56-4E83-B31A-37761F60994A
/devices/virtual/wmi/AAE04F7B-B3C5-4865-95D6-9FAC7FF3E92B
/devices/virtual/wmi/CC1A61AC-4256-41A3-B9E0-05A445ADE2F5
/devices/virtual/wmi/CFF94C79-6C77-4AF7-AC56-7DD0CE01C997
/devices/virtual/wmi/D9F41781-F633-4400-9355-601770BEC510
/devices/virtual/wmi/E78C4453-0227-4861-9EDE-F5600B4A3D39
/devices/virtual/wmi/FAAA1397-1188-448F-8516-9A07987DD38A
>> int.13: device names
>> int.14: soft raid
----- soft raid devices -----
----- soft raid devices end -----
>> int.15: geo
>> int.16: parent
  prop read: rdCR.lZF+r4EgHp4 (failed)
  old prop read: rdCR.lZF+r4EgHp4 (failed)
  prop read: rdCR.n_7QNeEnh23 (failed)
  old prop read: rdCR.n_7QNeEnh23 (failed)
  prop read: rdCR.EMpH5pjcahD (failed)
  old prop read: rdCR.EMpH5pjcahD (failed)
  prop read: rdCR.f5u1ucRm+H9 (failed)
  old prop read: rdCR.f5u1ucRm+H9 (failed)
  prop read: rdCR.8uRK7LxiIA2 (failed)
  old prop read: rdCR.8uRK7LxiIA2 (failed)
  prop read: rdCR.AJKleuxpiP0 (failed)
  old prop read: rdCR.AJKleuxpiP0 (failed)
  prop read: rdCR.9N+EecqykME (failed)
  old prop read: rdCR.9N+EecqykME (failed)
  prop read: rdCR.DziBbWO85o5 (failed)
  old prop read: rdCR.DziBbWO85o5 (failed)
  prop read: rdCR.CxwsZFjVASF (failed)
  old prop read: rdCR.CxwsZFjVASF (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_9601 (failed)
  prop read: qLht.5RW18bBylgC (failed)
  old prop read: qLht.5RW18bBylgC (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1025_9602 (failed)
  prop read: vSkL.jMfLnDT44h2 (failed)
  old prop read: vSkL.jMfLnDT44h2 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_9604 (failed)
  prop read: 8otl.iW67dPZH9JA (failed)
  old prop read: 8otl.iW67dPZH9JA (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_9605 (failed)
  prop read: CvwD.Dx2t5_g_ghA (failed)
  old prop read: CvwD.Dx2t5_g_ghA (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4391 (failed)
  prop read: 7EWs.if8JqcnDegB (failed)
  old prop read: 7EWs.if8JqcnDegB (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4397 (failed)
  prop read: CLZK.ff0GzENFi58 (failed)
  old prop read: CLZK.ff0GzENFi58 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4396 (failed)
  prop read: x_X+.OFtbdEnToHF (failed)
  old prop read: x_X+.OFtbdEnToHF (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4397_0 (failed)
  prop read: HSco.ff0GzENFi58 (failed)
  old prop read: HSco.ff0GzENFi58 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4396_0 (failed)
  prop read: 06bT.OFtbdEnToHF (failed)
  old prop read: 06bT.OFtbdEnToHF (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4385 (failed)
  prop read: MZfG.61xdmI3HgdC (failed)
  old prop read: MZfG.61xdmI3HgdC (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_439c (failed)
  prop read: Eu86.xOnCsNwp1C1 (failed)
  old prop read: Eu86.xOnCsNwp1C1 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4383 (failed)
  prop read: 5Dex.z+jEBaEo2L1 (failed)
  old prop read: 5Dex.z+jEBaEo2L1 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_439d (failed)
  prop read: yX7n.NKV7BKRkD14 (failed)
  old prop read: yX7n.NKV7BKRkD14 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4384 (failed)
  prop read: qscc.UsCA9N2eQqB (failed)
  old prop read: qscc.UsCA9N2eQqB (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4397_1 (failed)
  prop read: WnlC.ff0GzENFi58 (failed)
  old prop read: WnlC.ff0GzENFi58 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_4396_1 (failed)
  prop read: FRkt.OFtbdEnToHF (failed)
  old prop read: FRkt.OFtbdEnToHF (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_1200 (failed)
  prop read: fiDB.SGHF3QZh3Y9 (failed)
  old prop read: fiDB.SGHF3QZh3Y9 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_1201 (failed)
  prop read: W1j0.zgD+X_gObw9 (failed)
  old prop read: W1j0.zgD+X_gObw9 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_1202 (failed)
  prop read: OMCs.U5Al0Zo57JA (failed)
  old prop read: OMCs.U5Al0Zo57JA (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_1203 (failed)
  prop read: Fhhh.+V6VV7woehA (failed)
  old prop read: Fhhh.+V6VV7woehA (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1022_1204 (failed)
  prop read: 60BX.Ww2F_h1WA4B (failed)
  old prop read: 60BX.Ww2F_h1WA4B (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_9712 (failed)
  prop read: ul7N.yuUtrh4H_c7 (failed)
  old prop read: ul7N.yuUtrh4H_c7 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1002_970f (failed)
  prop read: l4dC.zmXgC58ay08 (failed)
  old prop read: l4dC.zmXgC58ay08 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_1969_1073 (failed)
  prop read: rBUF.viA1w8EcZf8 (failed)
  old prop read: rBUF.viA1w8EcZf8 (failed)
  prop read: /org/freedesktop/Hal/devices/pci_14e4_4357 (failed)
  prop read: vTuk.zZ4EkAcheC3 (failed)
  old prop read: vTuk.zZ4EkAcheC3 (failed)
  prop read: /org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727 (failed)
  prop read: 3OOL.xMZeHc3BOe0 (failed)
  old prop read: 3OOL.xMZeHc3BOe0 (failed)
  prop read: /org/freedesktop/Hal/devices/volume_uuid_85c51aea_99ce_4a1a_9c1a_5af285a7f145 (failed)
  prop read: bdUI.SE1wIdpsiiC (failed)
  old prop read: bdUI.SE1wIdpsiiC (failed)
  prop read: /org/freedesktop/Hal/devices/volume_part2_size_1024 (failed)
  prop read: 2pkM.SE1wIdpsiiC (failed)
  old prop read: 2pkM.SE1wIdpsiiC (failed)
  prop read: /org/freedesktop/Hal/devices/volume_uuid_6138fe8c_9476_4396_aa5f_a88c0dc55e29 (failed)
  prop read: QLVZ.SE1wIdpsiiC (failed)
  old prop read: QLVZ.SE1wIdpsiiC (failed)
  prop read: /org/freedesktop/Hal/devices/storage_serial_Generic__Multi_Card_20090516388200000_0_0 (failed)
  prop read: wkjR.lW+IYSj3qA1 (failed)
  old prop read: wkjR.lW+IYSj3qA1 (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2_if0 (failed)
  prop read: k4bc.YdoZZg0c8i6 (failed)
  old prop read: k4bc.YdoZZg0c8i6 (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2_if0 (failed)
  prop read: pBe4.3f5c44ENLJ9 (failed)
  old prop read: pBe4.3f5c44ENLJ9 (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2_if0 (failed)
  prop read: uIhY.cj_idGsgx81 (failed)
  old prop read: uIhY.cj_idGsgx81 (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0_if0 (failed)
  prop read: zPk0.7qWCOCfUJwE (failed)
  old prop read: zPk0.7qWCOCfUJwE (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0_if0 (failed)
  prop read: 2XnU.erpEvbsFWX1 (failed)
  old prop read: 2XnU.erpEvbsFWX1 (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0_if0 (failed)
  prop read: 7eqy.BwiLSoUZ6N9 (failed)
  old prop read: 7eqy.BwiLSoUZ6N9 (failed)
  prop read: /org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0_logicaldev_input (failed)
  prop read: +rmv.sWuUzJ4g1a5 (failed)
  old prop read: +rmv.sWuUzJ4g1a5 (failed)
  prop read: /org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port_logicaldev_input (failed)
  prop read: c3zD.+49ps10DtUF (failed)
  old prop read: c3zD.+49ps10DtUF (failed)
  prop read: /org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port_logicaldev_input (failed)
  prop read: AH6Q.U5GX9Ignjc0 (failed)
  old prop read: AH6Q.U5GX9Ignjc0 (failed)
  prop read: rdCR.j8NaKXDZtZ6 (failed)
  old prop read: rdCR.j8NaKXDZtZ6 (failed)
  prop read: wkFv.j8NaKXDZtZ6 (failed)
  old prop read: wkFv.j8NaKXDZtZ6 (failed)
  prop read: ZsBS.GQNx7L4uPNA (failed)
  old prop read: ZsBS.GQNx7L4uPNA (failed)
  prop read: usDW.ndpeucax6V1 (failed)
  old prop read: usDW.ndpeucax6V1 (failed)
  prop read: sG1U.ndpeucax6V1 (failed)
  old prop read: sG1U.ndpeucax6V1 (failed)
----- /proc/modules -----
  lp 10201 0 - Live 0xffffffffa005d000
  parport_pc 30086 0 - Live 0xffffffffa03b2000
  joydev 11395 0 - Live 0xffffffffa03ad000
  st 40056 0 - Live 0xffffffffa03a1000
  snd_seq_dummy 1806 0 - Live 0xffffffffa0008000
  usbhid 42062 0 - Live 0xffffffffa0380000
  hid 84710 1 usbhid, Live 0xffffffffa0369000
  atl1c 34955 0 - Live 0xffffffffa0429000
  binfmt_misc 7984 1 - Live 0xffffffffa009b000
  vboxnetadp 5395 0 - Live 0xffffffffa008b000
  vboxnetflt 19131 0 - Live 0xffffffffa00dc000
  vboxdrv 1818472 2 vboxnetadp,vboxnetflt, Live 0xffffffffa05ac000
  arc4 1497 0 - Live 0xffffffffa005a000
  ppdev 6804 0 - Live 0xffffffffa0061000
  snd_hda_codec_atihdmi 3079 1 - Live 0xffffffffa0015000
  snd_hda_codec_realtek 299844 1 - Live 0xffffffffa04ab000
  snd_hda_intel 26019 2 - Live 0xffffffffa0041000
  snd_hda_codec 100919 3 snd_hda_codec_atihdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa0490000
  snd_hwdep 6660 1 snd_hda_codec, Live 0xffffffffa0056000
  snd_pcm 89104 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0411000
  snd_seq_midi 5932 0 - Live 0xffffffffa0004000
  uvcvideo 62379 0 - Live 0xffffffffa03ff000
  videodev 49359 1 uvcvideo, Live 0xffffffffa03f0000
  v4l1_compat 15519 2 uvcvideo,videodev, Live 0xffffffffa03ea000
  v4l2_compat_ioctl32 12614 1 videodev, Live 0xffffffffa03e4000
  snd_rawmidi 22207 1 snd_seq_midi, Live 0xffffffffa03dc000
  fglrx 2523725 85 - Live 0xffffffffa00fe000 (P)
  snd_seq_midi_event 7291 1 snd_seq_midi, Live 0xffffffffa0068000
  snd_seq 57512 3 snd_seq_dummy,snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa03c4000
  acer_wmi 15969 0 - Live 0xffffffffa0073000
  snd_timer 23850 2 snd_pcm,snd_seq, Live 0xffffffffa00bc000
  snd_seq_device 6912 4 snd_seq_dummy,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa0020000
  led_class 3393 1 acer_wmi, Live 0xffffffffa0012000
  snd 64181 13 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xffffffffa00e4000
  psmouse 62080 0 - Live 0xffffffffa00ca000
  edac_core 46822 0 - Live 0xffffffffa00ae000
  soundcore 1240 1 snd, Live 0xffffffffa00c4000
  serio_raw 4910 0 - Live 0xffffffffa00a7000
  k10temp 3535 0 - Live 0xffffffffa0090000
  snd_page_alloc 8588 2 snd_hda_intel,snd_pcm, Live 0xffffffffa009e000
  edac_mce_amd 9387 0 - Live 0xffffffffa0096000
  shpchp 34910 0 - Live 0xffffffffa0080000
  i2c_piix4 10047 0 - Live 0xffffffffa0078000
  video 22176 0 - Live 0xffffffffa006b000
  output 2527 1 video, Live 0xffffffffa0065000
  parport 37032 3 lp,parport_pc,ppdev, Live 0xffffffffa004a000
  usb_storage 50372 0 - Live 0xffffffffa0032000
  ahci 22210 2 - Live 0xffffffffa0025000
  libahci 26052 1 ahci, Live 0xffffffffa0017000
  pata_atiixp 4405 0 - Live 0xffffffffa0000000
----- /proc/modules end -----
  used irqs: 0,1,8,9,12,14,15,16,17,18,19,40,41,42,43
=========== end debug info ============
01: None 00.0: 10105 BIOS
  [Created at bios.190]
  Unique ID: rdCR.lZF+r4EgHp4
  Hardware Class: bios
  BIOS Keyboard LED Status:
    Scroll Lock: off
    Num Lock: off
    Caps Lock: off
  Base Memory: 631 kB
  PnP BIOS: @@@0000
  MP spec rev 1.4 info:
    OEM id: "AMD"
    Product id: "POOH"
    2 CPUs (0 disabled)
  BIOS32 Service Directory Entry: 0xfd770
  SMBIOS Version: 2.6
  BIOS Info: #0
    Vendor: "Phoenix Technologies LTD"
    Version: "V1.11"
    Date: "05/14/2010"
    Start Address: 0xe2650
    ROM Size: 2048 kB
    Features: 0x0533000000007dcbda80
      PCI supported
      PnP supported
      BIOS flashable
      BIOS shadowing allowed
      ESCD supported
      CD boot supported
      Selectable boot supported
      BIOS ROM socketed
      EDD spec supported
      360kB Floppy supported
      1.2MB Floppy supported
      720kB Floppy supported
      Print Screen supported
      8042 Keyboard Services supported
      Serial Services supported
      Printer Services supported
      CGA/Mono Video supported
      ACPI supported
      USB Legacy supported
      LS-120 boot supported
      ATAPI ZIP boot supported
      BIOS Boot Spec supported
  System Info: #1
    Manufacturer: "Acer"
    Product: "Aspire 1551"
    Version: "V1.11"
    Serial: "LXSBB02075028006C22000"
    UUID: undefined, but settable
    Wake-up: 0x06 (Power Switch)
  Board Info: #2
    Manufacturer: "Acer"
    Product: "Aspire 1551"
    Version: "V1.11"
    Serial: "LXSBB02075028006C22000"
    Asset Tag: "No Asset Tag"
    Type: 0x0a (Motherboard)
    Features: 0x09
      Hosting Board
      Replaceable
    Location: "Not Applicable"
    Chassis: #3
    Contained Objects: #0
  Chassis Info: #3
    Manufacturer: "Acer"
    Version: "V1.11"
    Serial: "LXSBB02075028006C22000"
    Asset Tag: "No Asset Tag"
    Type: 0x0a (Notebook)
    Bootup State: 0x03 (Safe)
    Power Supply State: 0x03 (Safe)
    Thermal State: 0x03 (Safe)
    Security Status: 0x03 (None)
    OEM Info: 0x00001234
  Processor Info: #4
    Socket: "Socket ASB2"
    Socket Type: 0x06 (None)
    Socket Status: Populated
    Type: 0x03 (CPU)
    Family: 0x3a (Other)
    Manufacturer: "AMD"
    Version: "New Processor Technology"
    Processor ID: 0x178bfbff00100f63
    Status: 0x01 (Enabled)
    Voltage: 1.0 V
    External Clock: 200 MHz
    Max. Speed: 1300 MHz
    Current Speed: 1300 MHz
    L1 Cache: #5
    L2 Cache: #6
  Cache Info: #5
    Designation: "L1 Cache"
    Level: L1
    State: Enabled
    Mode: 0x01 (Write Back)
    Location: 0x00 (Internal, Not Socketed)
    ECC: 0x06 (Multi-bit)
    Type: 0x05 (Unified)
    Associativity: 0x04 (2-way Set-Associative)
    Max. Size: 256 kB
    Current Size: 256 kB
    Speed: 1 ns
    Supported SRAM Types: 0x0010 (Pipeline Burst)
    Current SRAM Type: 0x0010 (Pipeline Burst)
  Cache Info: #6
    Designation: "L2 Cache"
    Level: L2
    State: Enabled
    Mode: 0x01 (Write Back)
    Location: 0x00 (Internal, Not Socketed)
    ECC: 0x06 (Multi-bit)
    Type: 0x05 (Unified)
    Associativity: 0x08 (16-way Set-Associative)
    Max. Size: 2048 kB
    Current Size: 2048 kB
    Speed: 1 ns
    Supported SRAM Types: 0x0010 (Pipeline Burst)
    Current SRAM Type: 0x0010 (Pipeline Burst)
  System Slot: #7
    Designation: "MINI PCI1"
    Type: 0x06 (PCI)
    Bus Width: 0x05 (32 bit)
    Status: 0x03 (Available)
    Length: 0x01 (Other)
    Slot ID: 1
    Characteristics: 0x0106 (5.0 V, 3.3 V, PME#)
  System Slot: #8
    Designation: "MINI PCI2"
    Type: 0x06 (PCI)
    Bus Width: 0x05 (32 bit)
    Status: 0x03 (Available)
    Length: 0x01 (Other)
    Slot ID: 2
    Characteristics: 0x0106 (5.0 V, 3.3 V, PME#)
  On Board Devices: #9
    Video: "AMD RS880M" (disabled)
  On Board Devices: #10
    Sound: "ESS 1869" (disabled)
  OEM Strings: #11
  System Config Options (Jumpers & Switches) #12:
    J13 1-2 Normal Operation, 2-3 Clear CMOS
  Physical Memory Array: #13
    Use: 0x03 (System memory)
    Location: 0x03 (Motherboard)
    Slots: 4
    Max. Size: 32 GB
    ECC: 0x05 (Single-bit)
  Memory Device: #14
    Location: "S1"
    Bank: "DIMM1"
    Memory Array: #13
    Form Factor: 0x09 (DIMM)
    Type: 0x15 (Other)
    Type Detail: 0x0080 (Synchronous)
    Data Width: 0 bits
    Size: No Memory Installed
  Memory Device: #15
    Location: "S2"
    Bank: "DIMM2"
    Manufacturer: "80CE"
    Serial: "65FD5BC7"
    Asset Tag: "1021"
    Part Number: "M471B5673FH0-CH9"
    Memory Array: #13
    Form Factor: 0x09 (DIMM)
    Type: 0x18 (Other)
    Type Detail: 0x0080 (Synchronous)
    Data Width: 64 bits
    Size: 2 GB
    Speed: 667 MHz
  Memory Array Mapping: #16
    Memory Array: #13
    Partition Width: 2
    Start Address: 0x00000000
    End Address: 0x80000000
  Memory Device Mapping: #17
    Memory Device: #14
    Array Mapping: #16
    Row: 2
    Interleave Pos: 1
    Interleaved Depth: 6
    Start Address: 0x00000000
    End Address: 0x00000400
  Memory Device Mapping: #18
    Memory Device: #15
    Array Mapping: #16
    Row: 2
    Interleave Pos: 1
    Interleaved Depth: 6
    Start Address: 0x00000000
    End Address: 0x80000000
  Type 32 Record: #19
    Data 00: 20 14 13 00 00 00 00 00 00 00 0c 01 02 03 04 05
    Data 10: 06 07 08 09
  Type 170 Record: #20
    Data 00: aa 46 14 00 01 00 00 00 7f 00 0f 00 06 00 04 02
    Data 10: 01 00 41 02 01 00 42 02 02 00 43 02 04 00 44 02
    Data 20: 08 00 45 02 10 00 46 02 20 00 47 02 40 00 61 02
    Data 30: 01 00 62 02 02 00 63 02 04 00 64 02 08 00 82 02
    Data 40: 02 00 83 02 04 00
  Type 171 Record: #21
    Data 00: ab 18 15 00 01 02 10 12 97 02 69 19 73 10 05 02
    Data 10: 10 83 43 07 e4 14 57 43
  Type 172 Record: #22
    Data 00: ac 06 16 00 01 00
  Type 200 Record: #23
    Data 00: c8 07 17 00 01 02 03
    String 1: "17C0"
    String 3: "0001"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

02: None 00.0: 10107 System
  [Created at sys.63]
  Unique ID: rdCR.n_7QNeEnh23
  Hardware Class: system
  Model: "System"
  Formfactor: "laptop"
  Driver Info #0:
    Driver Status: thermal,fan are not active
    Driver Activation Cmd: "modprobe thermal; modprobe fan"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

03: None 00.0: 10104 FPU
  [Created at misc.192]
  Unique ID: rdCR.EMpH5pjcahD
  Hardware Class: unknown
  Model: "FPU"
  I/O Ports: 0xf0-0xff (rw)
  Config Status: cfg=new, avail=yes, need=no, active=unknown

04: None 00.0: 0801 DMA controller (8237)
  [Created at misc.206]
  Unique ID: rdCR.f5u1ucRm+H9
  Hardware Class: unknown
  Model: "DMA controller"
  I/O Ports: 0x00-0xcf7 (rw)
  I/O Ports: 0xc0-0xdf (rw)
  I/O Ports: 0x80-0x8f (rw)
  DMA: 4
  Config Status: cfg=new, avail=yes, need=no, active=unknown

05: None 00.0: 0800 PIC (8259)
  [Created at misc.219]
  Unique ID: rdCR.8uRK7LxiIA2
  Hardware Class: unknown
  Model: "PIC"
  I/O Ports: 0x20-0x21 (rw)
  I/O Ports: 0xa0-0xa1 (rw)
  Config Status: cfg=new, avail=yes, need=no, active=unknown

06: None 00.0: 0802 Timer (8254)
  [Created at misc.230]
  Unique ID: rdCR.AJKleuxpiP0
  Hardware Class: unknown
  Model: "Timer"
  IRQ: 0 (9960376 events)
  Config Status: cfg=new, avail=yes, need=no, active=unknown

07: None 00.0: 0900 Keyboard controller
  [Created at misc.251]
  Unique ID: rdCR.9N+EecqykME
  Hardware Class: unknown
  Model: "Keyboard controller"
  I/O Port: 0x60 (rw)
  I/O Port: 0x64 (rw)
  Config Status: cfg=new, avail=yes, need=no, active=unknown

08: None 00.0: 10400 PS/2 Controller
  [Created at misc.304]
  Unique ID: rdCR.DziBbWO85o5
  Hardware Class: unknown
  Model: "PS/2 Controller"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

11: None 00.0: 10102 Main Memory
  [Created at memory.61]
  Unique ID: rdCR.CxwsZFjVASF
  Hardware Class: memory
  Model: "Main Memory"
  Memory Range: 0x00000000-0x6d987fff (rw)
  Memory Size: 1 GB + 768 MB
  Config Status: cfg=new, avail=yes, need=no, active=unknown

12: PCI 00.0: 0600 Host bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_9601
  Unique ID: qLht.5RW18bBylgC
  SysFS ID: /devices/pci0000:00/0000:00:00.0
  SysFS BusID: 0000:00:00.0
  Hardware Class: bridge
  Model: "AMD RS780 Host Bridge Alternate"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x9601 "RS780 Host Bridge Alternate"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Module Alias: "pci:v00001022d00009601sv00001025sd00000429bc06sc00i00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

13: PCI 01.0: 0604 PCI bridge (Normal decode)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1025_9602
  Unique ID: vSkL.jMfLnDT44h2
  SysFS ID: /devices/pci0000:00/0000:00:01.0
  SysFS BusID: 0000:00:01.0
  Hardware Class: bridge
  Model: "Acer Incorporated [ALI] PCI bridge"
  Vendor: pci 0x1025 "Acer Incorporated [ALI]"
  Device: pci 0x9602 
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Module Alias: "pci:v00001025d00009602sv00001025sd00000429bc06sc04i00"
  Driver Info #0:
    Driver Status: shpchp is active
    Driver Activation Cmd: "modprobe shpchp"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

14: PCI 04.0: 0604 PCI bridge (Normal decode)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_9604
  Unique ID: 8otl.iW67dPZH9JA
  SysFS ID: /devices/pci0000:00/0000:00:04.0
  SysFS BusID: 0000:00:04.0
  Hardware Class: bridge
  Model: "AMD RS780 PCI to PCI bridge (PCIE port 0)"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x9604 "RS780 PCI to PCI bridge (PCIE port 0)"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "pcieport"
  IRQ: 40 (no events)
  Module Alias: "pci:v00001022d00009604sv00001025sd00000429bc06sc04i00"
  Driver Info #0:
    Driver Status: shpchp is active
    Driver Activation Cmd: "modprobe shpchp"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

15: PCI 05.0: 0604 PCI bridge (Normal decode)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_9605
  Unique ID: CvwD.Dx2t5_g_ghA
  SysFS ID: /devices/pci0000:00/0000:00:05.0
  SysFS BusID: 0000:00:05.0
  Hardware Class: bridge
  Model: "AMD RS780 PCI to PCI bridge (PCIE port 1)"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x9605 "RS780 PCI to PCI bridge (PCIE port 1)"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "pcieport"
  IRQ: 41 (no events)
  Module Alias: "pci:v00001022d00009605sv00001025sd00000429bc06sc04i00"
  Driver Info #0:
    Driver Status: shpchp is active
    Driver Activation Cmd: "modprobe shpchp"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

16: PCI 11.0: 0106 SATA controller (AHCI 1.0)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4391
  Unique ID: 7EWs.if8JqcnDegB
  SysFS ID: /devices/pci0000:00/0000:00:11.0
  SysFS BusID: 0000:00:11.0
  Hardware Class: storage
  Model: "ATI SB700/SB800 SATA Controller [AHCI mode]"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4391 "SB700/SB800 SATA Controller [AHCI mode]"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ahci"
  Driver Modules: "ahci"
  I/O Ports: 0x8440-0x8447 (rw)
  I/O Ports: 0x8430-0x8433 (rw)
  I/O Ports: 0x8420-0x8427 (rw)
  I/O Ports: 0x8410-0x8413 (rw)
  I/O Ports: 0x8400-0x840f (rw)
  Memory Range: 0xd0607c00-0xd0607fff (rw,non-prefetchable)
  IRQ: 42 (883080 events)
  Module Alias: "pci:v00001002d00004391sv00001025sd00000429bc01sc06i01"
  Driver Info #0:
    Driver Status: ahci is active
    Driver Activation Cmd: "modprobe ahci"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

17: PCI 12.0: 0c03 USB Controller (OHCI)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4397
  Unique ID: CLZK.ff0GzENFi58
  SysFS ID: /devices/pci0000:00/0000:00:12.0
  SysFS BusID: 0000:00:12.0
  Hardware Class: usb controller
  Model: "ATI SB700/SB800 USB OHCI0 Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4397 "SB700/SB800 USB OHCI0 Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ohci_hcd"
  Memory Range: 0xd0404000-0xd0404fff (rw,non-prefetchable)
  IRQ: 18 (44258 events)
  Module Alias: "pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10"
  Driver Info #0:
    Driver Status: ohci-hcd is not active
    Driver Activation Cmd: "modprobe ohci-hcd"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

18: PCI 12.2: 0c03 USB Controller (EHCI)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4396
  Unique ID: x_X+.OFtbdEnToHF
  SysFS ID: /devices/pci0000:00/0000:00:12.2
  SysFS BusID: 0000:00:12.2
  Hardware Class: usb controller
  Model: "ATI SB700/SB800 USB EHCI Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4396 "SB700/SB800 USB EHCI Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ehci_hcd"
  Driver Modules: "ehci_hcd"
  Memory Range: 0xd0607000-0xd06070ff (rw,non-prefetchable)
  IRQ: 17 (1169775 events)
  Module Alias: "pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20"
  Driver Info #0:
    Driver Status: ehci-hcd is not active
    Driver Activation Cmd: "modprobe ehci-hcd"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

19: PCI 13.0: 0c03 USB Controller (OHCI)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4397_0
  Unique ID: HSco.ff0GzENFi58
  SysFS ID: /devices/pci0000:00/0000:00:13.0
  SysFS BusID: 0000:00:13.0
  Hardware Class: usb controller
  Model: "ATI SB700/SB800 USB OHCI0 Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4397 "SB700/SB800 USB OHCI0 Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ohci_hcd"
  Memory Range: 0xd0405000-0xd0405fff (rw,non-prefetchable)
  IRQ: 18 (44258 events)
  Module Alias: "pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10"
  Driver Info #0:
    Driver Status: ohci-hcd is not active
    Driver Activation Cmd: "modprobe ohci-hcd"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

20: PCI 13.2: 0c03 USB Controller (EHCI)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4396_0
  Unique ID: 06bT.OFtbdEnToHF
  SysFS ID: /devices/pci0000:00/0000:00:13.2
  SysFS BusID: 0000:00:13.2
  Hardware Class: usb controller
  Model: "ATI SB700/SB800 USB EHCI Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4396 "SB700/SB800 USB EHCI Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ehci_hcd"
  Driver Modules: "ehci_hcd"
  Memory Range: 0xd0607400-0xd06074ff (rw,non-prefetchable)
  IRQ: 17 (1169775 events)
  Module Alias: "pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20"
  Driver Info #0:
    Driver Status: ehci-hcd is not active
    Driver Activation Cmd: "modprobe ehci-hcd"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

21: PCI 14.0: 0c05 SMBus
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4385
  Unique ID: MZfG.61xdmI3HgdC
  SysFS ID: /devices/pci0000:00/0000:00:14.0
  SysFS BusID: 0000:00:14.0
  Hardware Class: unknown
  Model: "ATI SBx00 SMBus Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4385 "SBx00 SMBus Controller"
  Revision: 0x41
  Module Alias: "pci:v00001002d00004385sv00000000sd00000000bc0Csc05i00"
  Driver Info #0:
    Driver Status: i2c_piix4 is active
    Driver Activation Cmd: "modprobe i2c_piix4"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

22: PCI 14.1: 0101 IDE interface
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_439c
  Unique ID: Eu86.xOnCsNwp1C1
  SysFS ID: /devices/pci0000:00/0000:00:14.1
  SysFS BusID: 0000:00:14.1
  Hardware Class: storage
  Model: "ATI SB700/SB800 IDE Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x439c "SB700/SB800 IDE Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Revision: 0x40
  Driver: "pata_atiixp"
  Driver Modules: "pata_atiixp"
  I/O Ports: 0x1f0-0x1f7 (rw)
  I/O Port: 0x3f6 (rw)
  I/O Ports: 0x170-0x177 (rw)
  I/O Port: 0x376 (rw)
  I/O Ports: 0x8450-0x845f (rw)
  IRQ: 17 (1169775 events)
  Module Alias: "pci:v00001002d0000439Csv00001025sd00000429bc01sc01i8a"
  Driver Info #0:
    Driver Status: pata_atiixp is active
    Driver Activation Cmd: "modprobe pata_atiixp"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

23: PCI 14.2: 0403 Audio device
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4383
  Unique ID: 5Dex.z+jEBaEo2L1
  SysFS ID: /devices/pci0000:00/0000:00:14.2
  SysFS BusID: 0000:00:14.2
  Hardware Class: sound
  Model: "ATI SBx00 Azalia (Intel HDA)"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4383 "SBx00 Azalia (Intel HDA)"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Revision: 0x40
  Driver: "HDA Intel"
  Driver Modules: "snd_hda_intel"
  Memory Range: 0xd0400000-0xd0403fff (rw,non-prefetchable)
  IRQ: 16 (14810 events)
  Module Alias: "pci:v00001002d00004383sv00001025sd00000429bc04sc03i00"
  Driver Info #0:
    Driver Status: snd_hda_intel is active
    Driver Activation Cmd: "modprobe snd_hda_intel"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

24: PCI 14.3: 0601 ISA bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_439d
  Unique ID: yX7n.NKV7BKRkD14
  SysFS ID: /devices/pci0000:00/0000:00:14.3
  SysFS BusID: 0000:00:14.3
  Hardware Class: bridge
  Model: "ATI SB700/SB800 LPC host controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x439d "SB700/SB800 LPC host controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Revision: 0x40
  Module Alias: "pci:v00001002d0000439Dsv00001025sd00000429bc06sc01i00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

25: PCI 14.4: 0604 PCI bridge (Subtractive decode)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4384
  Unique ID: qscc.UsCA9N2eQqB
  SysFS ID: /devices/pci0000:00/0000:00:14.4
  SysFS BusID: 0000:00:14.4
  Hardware Class: bridge
  Model: "ATI SBx00 PCI to PCI Bridge"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4384 "SBx00 PCI to PCI Bridge"
  Revision: 0x40
  Module Alias: "pci:v00001002d00004384sv00000000sd00000000bc06sc04i01"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

26: PCI 16.0: 0c03 USB Controller (OHCI)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4397_1
  Unique ID: WnlC.ff0GzENFi58
  SysFS ID: /devices/pci0000:00/0000:00:16.0
  SysFS BusID: 0000:00:16.0
  Hardware Class: usb controller
  Model: "ATI SB700/SB800 USB OHCI0 Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4397 "SB700/SB800 USB OHCI0 Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ohci_hcd"
  Memory Range: 0xd0406000-0xd0406fff (rw,non-prefetchable)
  IRQ: 18 (44258 events)
  Module Alias: "pci:v00001002d00004397sv00001025sd00000429bc0Csc03i10"
  Driver Info #0:
    Driver Status: ohci-hcd is not active
    Driver Activation Cmd: "modprobe ohci-hcd"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

27: PCI 16.2: 0c03 USB Controller (EHCI)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_4396_1
  Unique ID: FRkt.OFtbdEnToHF
  SysFS ID: /devices/pci0000:00/0000:00:16.2
  SysFS BusID: 0000:00:16.2
  Hardware Class: usb controller
  Model: "ATI SB700/SB800 USB EHCI Controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x4396 "SB700/SB800 USB EHCI Controller"
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "ehci_hcd"
  Driver Modules: "ehci_hcd"
  Memory Range: 0xd0607800-0xd06078ff (rw,non-prefetchable)
  IRQ: 17 (1169775 events)
  Module Alias: "pci:v00001002d00004396sv00001025sd00000429bc0Csc03i20"
  Driver Info #0:
    Driver Status: ehci-hcd is not active
    Driver Activation Cmd: "modprobe ehci-hcd"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

28: PCI 18.0: 0600 Host bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_1200
  Unique ID: fiDB.SGHF3QZh3Y9
  SysFS ID: /devices/pci0000:00/0000:00:18.0
  SysFS BusID: 0000:00:18.0
  Hardware Class: bridge
  Model: "AMD Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x1200 "Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration"
  Module Alias: "pci:v00001022d00001200sv00000000sd00000000bc06sc00i00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

29: PCI 18.1: 0600 Host bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_1201
  Unique ID: W1j0.zgD+X_gObw9
  SysFS ID: /devices/pci0000:00/0000:00:18.1
  SysFS BusID: 0000:00:18.1
  Hardware Class: bridge
  Model: "AMD Family 10h [Opteron, Athlon64, Sempron] Address Map"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x1201 "Family 10h [Opteron, Athlon64, Sempron] Address Map"
  Module Alias: "pci:v00001022d00001201sv00000000sd00000000bc06sc00i00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

30: PCI 18.2: 0600 Host bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_1202
  Unique ID: OMCs.U5Al0Zo57JA
  SysFS ID: /devices/pci0000:00/0000:00:18.2
  SysFS BusID: 0000:00:18.2
  Hardware Class: bridge
  Model: "AMD Family 10h [Opteron, Athlon64, Sempron] DRAM Controller"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x1202 "Family 10h [Opteron, Athlon64, Sempron] DRAM Controller"
  Module Alias: "pci:v00001022d00001202sv00000000sd00000000bc06sc00i00"
  Driver Info #0:
    Driver Status: amd64_edac_mod is not active
    Driver Activation Cmd: "modprobe amd64_edac_mod"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

31: PCI 18.3: 0600 Host bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_1203
  Unique ID: Fhhh.+V6VV7woehA
  SysFS ID: /devices/pci0000:00/0000:00:18.3
  SysFS BusID: 0000:00:18.3
  Hardware Class: bridge
  Model: "AMD Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x1203 "Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control"
  Driver: "k10temp"
  Driver Modules: "k10temp"
  Module Alias: "pci:v00001022d00001203sv00000000sd00000000bc06sc00i00"
  Driver Info #0:
    Driver Status: k10temp is active
    Driver Activation Cmd: "modprobe k10temp"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

32: PCI 18.4: 0600 Host bridge
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1022_1204
  Unique ID: 60BX.Ww2F_h1WA4B
  SysFS ID: /devices/pci0000:00/0000:00:18.4
  SysFS BusID: 0000:00:18.4
  Hardware Class: bridge
  Model: "AMD Family 10h [Opteron, Athlon64, Sempron] Link Control"
  Vendor: pci 0x1022 "AMD"
  Device: pci 0x1204 "Family 10h [Opteron, Athlon64, Sempron] Link Control"
  Module Alias: "pci:v00001022d00001204sv00000000sd00000000bc06sc00i00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown

33: PCI 105.0: 0300 VGA compatible controller (VGA)
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_9712
  Unique ID: ul7N.yuUtrh4H_c7
  Parent ID: vSkL.jMfLnDT44h2
  SysFS ID: /devices/pci0000:00/0000:00:01.0/0000:01:05.0
  SysFS BusID: 0000:01:05.0
  Hardware Class: graphics card
  Model: "ATI VGA compatible controller"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x9712 
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "fglrx_pci"
  Driver Modules: "fglrx"
  Memory Range: 0xc0000000-0xcfffffff (ro,non-prefetchable)
  I/O Ports: 0x9000-0x9fff (rw)
  Memory Range: 0xd0100000-0xd010ffff (rw,non-prefetchable)
  Memory Range: 0xd0000000-0xd00fffff (rw,non-prefetchable)
  IRQ: 18 (44258 events)
  I/O Ports: 0x3c0-0x3df (rw)
  Module Alias: "pci:v00001002d00009712sv00001025sd00000429bc03sc00i00"
  Driver Info #0:
    Driver Status: radeon is not active
    Driver Activation Cmd: "modprobe radeon"
  Driver Info #1:
    Driver Status: fglrx is active
    Driver Activation Cmd: "modprobe fglrx"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #13 (PCI bridge)

34: PCI 105.1: 0403 Audio device
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1002_970f
  Unique ID: l4dC.zmXgC58ay08
  Parent ID: vSkL.jMfLnDT44h2
  SysFS ID: /devices/pci0000:00/0000:00:01.0/0000:01:05.1
  SysFS BusID: 0000:01:05.1
  Hardware Class: sound
  Model: "ATI Audio device"
  Vendor: pci 0x1002 "ATI Technologies Inc"
  Device: pci 0x970f 
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x0429 
  Driver: "HDA Intel"
  Driver Modules: "snd_hda_intel"
  Memory Range: 0xd0110000-0xd0113fff (rw,non-prefetchable)
  IRQ: 19 (50 events)
  Module Alias: "pci:v00001002d0000970Fsv00001025sd00000429bc04sc03i00"
  Driver Info #0:
    Driver Status: snd_hda_intel is active
    Driver Activation Cmd: "modprobe snd_hda_intel"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #13 (PCI bridge)

35: PCI 300.0: 0200 Ethernet controller
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_1969_1073
  Unique ID: rBUF.viA1w8EcZf8
  Parent ID: 8otl.iW67dPZH9JA
  SysFS ID: /devices/pci0000:00/0000:00:04.0/0000:03:00.0
  SysFS BusID: 0000:03:00.0
  Hardware Class: network
  Model: "Attansic Ethernet controller"
  Vendor: pci 0x1969 "Attansic Technology Corp."
  Device: pci 0x1073 
  SubVendor: pci 0x1025 "Acer Incorporated [ALI]"
  SubDevice: pci 0x040d 
  Revision: 0xc0
  Driver: "atl1c"
  Driver Modules: "atl1c"
  Device File: eth0
  Memory Range: 0xd0200000-0xd023ffff (rw,non-prefetchable)
  I/O Ports: 0xa000-0xafff (rw)
  IRQ: 43 (3940104 events)
  HW Address: 20:6a:8a:0b:39:bf
  Link detected: yes
  Module Alias: "pci:v00001969d00001073sv00001025sd0000040Dbc02sc00i00"
  Driver Info #0:
    Driver Status: atl1c is active
    Driver Activation Cmd: "modprobe atl1c"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #14 (PCI bridge)

36: PCI 600.0: 0280 Network controller
  [Created at pci.318]
  UDI: /org/freedesktop/Hal/devices/pci_14e4_4357
  Unique ID: vTuk.zZ4EkAcheC3
  Parent ID: CvwD.Dx2t5_g_ghA
  SysFS ID: /devices/pci0000:00/0000:00:05.0/0000:06:00.0
  SysFS BusID: 0000:06:00.0
  Hardware Class: network
  Model: "Broadcom Network controller"
  Vendor: pci 0x14e4 "Broadcom"
  Device: pci 0x4357 
  SubVendor: pci 0x105b "Foxconn International, Inc."
  SubDevice: pci 0xe021 
  Revision: 0x01
  Memory Range: 0xd0300000-0xd0303fff (rw,non-prefetchable)
  IRQ: 17 (1169775 events)
  Module Alias: "pci:v000014E4d00004357sv0000105Bsd0000E021bc02sc80i00"
  Driver Info #0:
    Driver Status: brcm80211 is not active
    Driver Activation Cmd: "modprobe brcm80211"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #15 (PCI bridge)

37: IDE 200.0: 10600 Disk
  [Created at block.243]
  UDI: /org/freedesktop/Hal/devices/storage_serial_WDC_WD2500BEVT_22A23T0_WD_WXJ1A50D8727
  Unique ID: 3OOL.xMZeHc3BOe0
  Parent ID: 7EWs.if8JqcnDegB
  SysFS ID: /class/block/sda
  SysFS BusID: 2:0:0:0
  SysFS Device Link: /devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0
  Hardware Class: disk
  Model: "WDC WD2500BEVT-2"
  Vendor: "WDC"
  Device: "WD2500BEVT-2"
  Revision: "01.0"
  Serial ID: "WD-WXJ1A50D8727"
  Driver: "ahci", "sd"
  Driver Modules: "ahci"
  Device File: /dev/sda
  Device Files: /dev/sda, /dev/block/8:0, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0, /dev/disk/by-id/wwn-0x50014ee2af462d20
  Device Number: block 8:0-8:15
  Geometry (Logical): CHS 30401/255/63
  Size: 488397168 sectors a 512 bytes
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #16 (SATA controller)

38: None 00.0: 11300 Partition
  [Created at block.412]
  UDI: /org/freedesktop/Hal/devices/volume_uuid_85c51aea_99ce_4a1a_9c1a_5af285a7f145
  Unique ID: bdUI.SE1wIdpsiiC
  Parent ID: 3OOL.xMZeHc3BOe0
  SysFS ID: /class/block/sda/sda1
  Hardware Class: partition
  Model: "Partition"
  Device File: /dev/sda1
  Device Files: /dev/sda1, /dev/block/8:1, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part1, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part1, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part1, /dev/disk/by-uuid/85c51aea-99ce-4a1a-9c1a-5af285a7f145, /dev/disk/by-id/wwn-0x50014ee2af462d20-part1, /dev/root
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #37 (Disk)

39: None 00.0: 11300 Partition
  [Created at block.412]
  UDI: /org/freedesktop/Hal/devices/volume_part2_size_1024
  Unique ID: 2pkM.SE1wIdpsiiC
  Parent ID: 3OOL.xMZeHc3BOe0
  SysFS ID: /class/block/sda/sda2
  Hardware Class: partition
  Model: "Partition"
  Device File: /dev/sda2
  Device Files: /dev/sda2, /dev/block/8:2, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part2, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part2, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2, /dev/disk/by-id/wwn-0x50014ee2af462d20-part2
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #37 (Disk)

40: None 00.0: 11300 Partition
  [Created at block.412]
  UDI: /org/freedesktop/Hal/devices/volume_uuid_6138fe8c_9476_4396_aa5f_a88c0dc55e29
  Unique ID: QLVZ.SE1wIdpsiiC
  Parent ID: 3OOL.xMZeHc3BOe0
  SysFS ID: /class/block/sda/sda5
  Hardware Class: partition
  Model: "Partition"
  Device File: /dev/sda5
  Device Files: /dev/sda5, /dev/block/8:5, /dev/disk/by-id/ata-WDC_WD2500BEVT-22A23T0_WD-WXJ1A50D8727-part5, /dev/disk/by-id/scsi-SATA_WDC_WD2500BEVT-_WD-WXJ1A50D8727-part5, /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part5, /dev/disk/by-uuid/6138fe8c-9476-4396-aa5f-a88c0dc55e29, /dev/disk/by-id/wwn-0x50014ee2af462d20-part5
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #37 (Disk)

41: SCSI 300.0: 10600 Disk
  [Created at block.254]
  UDI: /org/freedesktop/Hal/devices/storage_serial_Generic__Multi_Card_20090516388200000_0_0
  Unique ID: wkjR.lW+IYSj3qA1
  Parent ID: x_X+.OFtbdEnToHF
  SysFS ID: /class/block/sdb
  SysFS BusID: 3:0:0:0
  SysFS Device Link: /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/host3/target3:0:0/3:0:0:0
  Hardware Class: disk
  Model: "Generic Multi-Card"
  Vendor: usb 0x0bda "Generic-"
  Device: usb 0x0138 "Multi-Card"
  Revision: "1.00"
  Serial ID: "20090516388200000"
  Driver: "usb-storage", "sd"
  Driver Modules: "usb_storage"
  Device File: /dev/sdb (/dev/sg1)
  Device Files: /dev/sdb, /dev/block/8:16, /dev/disk/by-id/usb-Generic-_Multi-Card_20090516388200000-0:0, /dev/disk/by-path/pci-0000:00:12.2-usb-0:5:1.0-scsi-0:0:0:0
  Device Number: block 8:16-8:31 (char 21:1)
  Features: Hotpluggable
  Geometry (Logical): CHS 1024/0/62
  Speed: 480 Mbps
  Module Alias: "usb:v0BDAp0138d3882dc00dsc00dp00ic08isc06ip50"
  Driver Info #0:
    Driver Status: usb_storage is active
    Driver Activation Cmd: "modprobe usb_storage"
  Drive status: no medium
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #18 (USB Controller)

42: USB 00.0: 10a00 Hub
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_12_2_if0
  Unique ID: k4bc.YdoZZg0c8i6
  Parent ID: x_X+.OFtbdEnToHF
  SysFS ID: /devices/pci0000:00/0000:00:12.2/usb1/1-0:1.0
  SysFS BusID: 1-0:1.0
  Hardware Class: hub
  Model: "Linux 2.6.35-24-generic ehci_hcd EHCI Host Controller"
  Hotplug: USB
  Vendor: usb 0x1d6b "Linux 2.6.35-24-generic ehci_hcd"
  Device: usb 0x0002 "EHCI Host Controller"
  Revision: "2.06"
  Serial ID: "0000:00:12.2"
  Driver: "hub"
  Driver Modules: "usbcore"
  Speed: 480 Mbps
  Module Alias: "usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00"
  Driver Info #0:
    Driver Status: option is not active
    Driver Activation Cmd: "modprobe option"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #18 (USB Controller)

43: USB 00.0: 10a00 Hub
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_13_2_if0
  Unique ID: pBe4.3f5c44ENLJ9
  Parent ID: 06bT.OFtbdEnToHF
  SysFS ID: /devices/pci0000:00/0000:00:13.2/usb2/2-0:1.0
  SysFS BusID: 2-0:1.0
  Hardware Class: hub
  Model: "Linux 2.6.35-24-generic ehci_hcd EHCI Host Controller"
  Hotplug: USB
  Vendor: usb 0x1d6b "Linux 2.6.35-24-generic ehci_hcd"
  Device: usb 0x0002 "EHCI Host Controller"
  Revision: "2.06"
  Serial ID: "0000:00:13.2"
  Driver: "hub"
  Driver Modules: "usbcore"
  Speed: 480 Mbps
  Module Alias: "usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00"
  Driver Info #0:
    Driver Status: option is not active
    Driver Activation Cmd: "modprobe option"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #20 (USB Controller)

44: USB 00.0: 10a00 Hub
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_16_2_if0
  Unique ID: uIhY.cj_idGsgx81
  Parent ID: FRkt.OFtbdEnToHF
  SysFS ID: /devices/pci0000:00/0000:00:16.2/usb3/3-0:1.0
  SysFS BusID: 3-0:1.0
  Hardware Class: hub
  Model: "Linux 2.6.35-24-generic ehci_hcd EHCI Host Controller"
  Hotplug: USB
  Vendor: usb 0x1d6b "Linux 2.6.35-24-generic ehci_hcd"
  Device: usb 0x0002 "EHCI Host Controller"
  Revision: "2.06"
  Serial ID: "0000:00:16.2"
  Driver: "hub"
  Driver Modules: "usbcore"
  Speed: 480 Mbps
  Module Alias: "usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00"
  Driver Info #0:
    Driver Status: option is not active
    Driver Activation Cmd: "modprobe option"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #27 (USB Controller)

45: USB 00.0: 10a00 Hub
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_12_0_if0
  Unique ID: zPk0.7qWCOCfUJwE
  Parent ID: CLZK.ff0GzENFi58
  SysFS ID: /devices/pci0000:00/0000:00:12.0/usb4/4-0:1.0
  SysFS BusID: 4-0:1.0
  Hardware Class: hub
  Model: "Linux 2.6.35-24-generic ohci_hcd OHCI Host Controller"
  Hotplug: USB
  Vendor: usb 0x1d6b "Linux 2.6.35-24-generic ohci_hcd"
  Device: usb 0x0001 "OHCI Host Controller"
  Revision: "2.06"
  Serial ID: "0000:00:12.0"
  Driver: "hub"
  Driver Modules: "usbcore"
  Speed: 12 Mbps
  Module Alias: "usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #17 (USB Controller)

46: USB 00.0: 10a00 Hub
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_13_0_if0
  Unique ID: 2XnU.erpEvbsFWX1
  Parent ID: HSco.ff0GzENFi58
  SysFS ID: /devices/pci0000:00/0000:00:13.0/usb5/5-0:1.0
  SysFS BusID: 5-0:1.0
  Hardware Class: hub
  Model: "Linux 2.6.35-24-generic ohci_hcd OHCI Host Controller"
  Hotplug: USB
  Vendor: usb 0x1d6b "Linux 2.6.35-24-generic ohci_hcd"
  Device: usb 0x0001 "OHCI Host Controller"
  Revision: "2.06"
  Serial ID: "0000:00:13.0"
  Driver: "hub"
  Driver Modules: "usbcore"
  Speed: 12 Mbps
  Module Alias: "usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #19 (USB Controller)

47: USB 00.0: 10a00 Hub
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_16_0_if0
  Unique ID: 7eqy.BwiLSoUZ6N9
  Parent ID: WnlC.ff0GzENFi58
  SysFS ID: /devices/pci0000:00/0000:00:16.0/usb6/6-0:1.0
  SysFS BusID: 6-0:1.0
  Hardware Class: hub
  Model: "Linux 2.6.35-24-generic ohci_hcd OHCI Host Controller"
  Hotplug: USB
  Vendor: usb 0x1d6b "Linux 2.6.35-24-generic ohci_hcd"
  Device: usb 0x0001 "OHCI Host Controller"
  Revision: "2.06"
  Serial ID: "0000:00:16.0"
  Driver: "hub"
  Driver Modules: "usbcore"
  Speed: 12 Mbps
  Module Alias: "usb:v1D6Bp0001d0206dc09dsc00dp00ic09isc00ip00"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #26 (USB Controller)

49: USB 00.0: 0000 Unclassified device
  [Created at usb.122]
  UDI: /org/freedesktop/Hal/devices/usb_device_64e_a219_HF1315_S32B_OV01_VA_R02_01_05_if0_logicaldev_input
  Unique ID: +rmv.sWuUzJ4g1a5
  Parent ID: pBe4.3f5c44ENLJ9
  SysFS ID: /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0
  SysFS BusID: 2-5:1.0
  Hardware Class: unknown
  Model: "Suyin 1.3M WebCam"
  Hotplug: USB
  Vendor: usb 0x064e "Suyin Corp."
  Device: usb 0xa219 "1.3M WebCam"
  Revision: "2.15"
  Serial ID: "HF1315-S32B-OV01-VA-R02.01.05"
  Driver: "uvcvideo"
  Driver Modules: "uvcvideo"
  Device File: /dev/input/event6
  Device Files: /dev/input/event6, /dev/char/13:70, /dev/input/by-id/usb-Suyin_1.3M_WebCam_HF1315-S32B-OV01-VA-R02.01.05-event-if00, /dev/input/by-path/pci-0000:00:13.2-usb-0:5:1.0-event
  Device Number: char 13:70
  Speed: 480 Mbps
  Module Alias: "usb:v064EpA219d0215dcEFdsc02dp01ic0Eisc01ip00"
  Driver Info #0:
    Driver Status: uvcvideo is active
    Driver Activation Cmd: "modprobe uvcvideo"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #43 (Hub)

51: PS/2 00.0: 10800 Keyboard
  [Created at input.161]
  UDI: /org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port_logicaldev_input
  Unique ID: c3zD.+49ps10DtUF
  Hardware Class: keyboard
  Model: "AT Translated Set 2 keyboard"
  Vendor: 0x0001 
  Device: 0x0001 "AT Translated Set 2 keyboard"
  Compatible to: int 0x0211 0x0001
  Device File: /dev/input/event4
  Device Files: /dev/input/event4, /dev/char/13:68, /dev/input/by-path/platform-i8042-serio-0-event-kbd
  Device Number: char 13:68
  Driver Info #0:
    XkbRules: xfree86
    XkbModel: pc104
  Config Status: cfg=new, avail=yes, need=no, active=unknown

52: PS/2 00.0: 10500 PS/2 Mouse
  [Created at input.183]
  UDI: /org/freedesktop/Hal/devices/platform_i8042_i8042_AUX_port_logicaldev_input
  Unique ID: AH6Q.U5GX9Ignjc0
  Hardware Class: mouse
  Model: "PS/2 Generic Mouse"
  Vendor: 0x0002 
  Device: 0x0001 "PS/2 Generic Mouse"
  Compatible to: int 0x0210 0x0003
  Device File: /dev/input/mice (/dev/input/mouse0)
  Device Files: /dev/input/mice, /dev/input/mouse0, /dev/input/event7, /dev/char/13:71, /dev/input/by-path/platform-i8042-serio-1-event-mouse, /dev/char/13:32, /dev/input/by-path/platform-i8042-serio-1-mouse, /dev/char/13:63
  Device Number: char 13:63 (char 13:32)
  Driver Info #0:
    Buttons: 3
    Wheels: 0
    XFree86 Protocol: explorerps/2
    GPM Protocol: exps2
  Config Status: cfg=new, avail=yes, need=no, active=unknown

53: None 00.0: 10103 CPU
  [Created at cpu.304]
  Unique ID: rdCR.j8NaKXDZtZ6
  Hardware Class: cpu
  Arch: X86-64
  Vendor: "AuthenticAMD"
  Model: 16.6.3 "AMD Athlon(tm) II Neo K325 Dual-Core Processor"
  Features: fpu,vme,de,pse,tsc,msr,pae,mce,cx8,apic,sep,mtrr,pge,mca,cmov,pat,pse36,clflush,mmx,fxsr,sse,sse2,ht,syscall,nx,mmxext,fxsr_opt,pdpe1gb,rdtscp,lm,3dnowext,3dnow,constant_tsc,rep_good,nonstop_tsc,extd_apicid,pni,monitor,cx16,popcnt,lahf_lm,cmp_legacy,svm,e
  Clock: 800 MHz
  BogoMips: 2593.53
  Cache: 1024 kb
  Units/Processor: 2
  Config Status: cfg=new, avail=yes, need=no, active=unknown

54: None 01.0: 10103 CPU
  [Created at cpu.304]
  Unique ID: wkFv.j8NaKXDZtZ6
  Hardware Class: cpu
  Arch: X86-64
  Vendor: "AuthenticAMD"
  Model: 16.6.3 "AMD Athlon(tm) II Neo K325 Dual-Core Processor"
  Features: fpu,vme,de,pse,tsc,msr,pae,mce,cx8,apic,sep,mtrr,pge,mca,cmov,pat,pse36,clflush,mmx,fxsr,sse,sse2,ht,syscall,nx,mmxext,fxsr_opt,pdpe1gb,rdtscp,lm,3dnowext,3dnow,constant_tsc,rep_good,nonstop_tsc,extd_apicid,pni,monitor,cx16,popcnt,lahf_lm,cmp_legacy,svm,e
  Clock: 1100 MHz
  BogoMips: 2593.50
  Cache: 1024 kb
  Units/Processor: 2
  Config Status: cfg=new, avail=yes, need=no, active=unknown

55: None 00.0: 10700 Loopback
  [Created at net.124]
  Unique ID: ZsBS.GQNx7L4uPNA
  SysFS ID: /class/net/lo
  Hardware Class: network interface
  Model: "Loopback network interface"
  Device File: lo
  Link detected: yes
  Config Status: cfg=new, avail=yes, need=no, active=unknown

56: None 00.0: 10701 Ethernet
  [Created at net.124]
  Unique ID: usDW.ndpeucax6V1
  Parent ID: rBUF.viA1w8EcZf8
  SysFS ID: /class/net/eth0
  SysFS Device Link: /devices/pci0000:00/0000:00:04.0/0000:03:00.0
  Hardware Class: network interface
  Model: "Ethernet network interface"
  Driver: "atl1c"
  Driver Modules: "atl1c"
  Device File: eth0
  HW Address: 20:6a:8a:0b:39:bf
  Link detected: yes
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #35 (Ethernet controller)

57: None 00.0: 10701 Ethernet
  [Created at net.124]
  Unique ID: sG1U.ndpeucax6V1
  SysFS ID: /class/net/vboxnet0
  Hardware Class: network interface
  Model: "Ethernet network interface"
  Device File: vboxnet0
  HW Address: 0a:00:27:00:00:00
  Config Status: cfg=new, avail=yes, need=no, active=unknown

--------------020904000209070006050309
Content-Type: text/x-log;
 name="kern.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kern.log"

Jan  9 14:03:15 Lulzer kernel: [51262.742593] CE: hpet increased min_delta_ns to 7500 nsec
Jan  9 14:54:37 Lulzer kernel: [54345.059126] Compat-wireless backport release: compat-wireless-2011-01-06
Jan  9 14:54:37 Lulzer kernel: [54345.059133] Backport based on linux-next.git next-20110107
Jan  9 14:54:37 Lulzer kernel: [54345.086689] cfg80211: Calling CRDA to update world regulatory domain
Jan  9 14:54:37 Lulzer kernel: [54345.121293] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 14:54:37 Lulzer kernel: [54345.121309] brcm80211 0000:06:00.0: setting latency timer to 64
Jan  9 14:54:38 Lulzer kernel: [54345.627262] Found chip type AI (0x13a1a8d9)
Jan  9 14:54:38 Lulzer kernel: [54345.639582] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021 macaddr: c4:46:19:6c:a9:c0
Jan  9 14:54:38 Lulzer kernel: [54345.639880] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639888] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639895] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639902] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639907] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639914] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639920] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639927] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639932] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639939] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639945] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639952] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639957] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639964] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639970] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639977] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.639982] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.639989] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.640020] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.640027] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.640032] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.640039] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.640045] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.640052] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.640057] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.640064] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.640070] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.640077] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (600 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.641970] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Jan  9 14:54:38 Lulzer kernel: [54345.643617] wl_set_hint: Sending country code US to MAC80211
Jan  9 14:54:38 Lulzer kernel: [54345.643626] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (Compiled at 14:48:55 on Jan  9 2011)
Jan  9 14:54:38 Lulzer kernel: [54345.643650] cfg80211: Pending regulatory request, waiting for it to be processed...
Jan  9 14:54:38 Lulzer kernel: [54345.674665] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674676] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674682] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674690] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674695] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674702] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674707] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674714] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674719] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674725] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674731] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674737] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674742] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674749] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674754] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674760] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674765] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674772] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674777] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674783] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674789] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674795] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674801] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674807] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674812] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674819] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674824] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54345.674830] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674837] cfg80211: World regulatory domain updated:
Jan  9 14:54:38 Lulzer kernel: [54345.674841] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 14:54:38 Lulzer kernel: [54345.674848] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674854] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674860] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674866] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674872] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54345.674895] cfg80211: Calling CRDA for country: US
Jan  9 14:54:38 Lulzer kernel: [54346.061577] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061586] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061593] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061600] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061606] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061612] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061617] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061624] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061629] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061635] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061640] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061647] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061652] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061658] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061664] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061670] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061675] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061681] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061687] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061693] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061698] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 14:54:38 Lulzer kernel: [54346.061704] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061709] cfg80211: Disabling freq 2467 MHz
Jan  9 14:54:38 Lulzer kernel: [54346.061713] cfg80211: Disabling freq 2472 MHz
Jan  9 14:54:38 Lulzer kernel: [54346.061717] cfg80211: Disabling freq 2484 MHz
Jan  9 14:54:38 Lulzer kernel: [54346.061723] cfg80211: Regulatory domain changed to country: US
Jan  9 14:54:38 Lulzer kernel: [54346.061727] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 14:54:38 Lulzer kernel: [54346.061734] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061740] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061746] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061753] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061759] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 14:54:38 Lulzer kernel: [54346.061765] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan  9 15:01:50 Lulzer kernel: [54777.828004] lo: Disabled Privacy Extensions
Jan  9 15:11:18 Lulzer kernel: [55346.221534] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Down
Jan  9 15:11:22 Lulzer kernel: [55349.666190] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
Jan  9 15:11:55 Lulzer kernel: [55383.077421] lo: Disabled Privacy Extensions
Jan  9 15:21:58 Lulzer kernel: [55985.942913] brcm80211 0000:06:00.0: PCI INT A disabled
Jan  9 15:22:23 Lulzer kernel: [56011.247387] Compat-wireless backport release: compat-wireless-2011-01-06
Jan  9 15:22:23 Lulzer kernel: [56011.247392] Backport based on linux-next.git next-20110107
Jan  9 15:22:23 Lulzer kernel: [56011.270931] cfg80211: Calling CRDA to update world regulatory domain
Jan  9 15:22:23 Lulzer kernel: [56011.315836] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 15:22:23 Lulzer kernel: [56011.315852] brcm80211 0000:06:00.0: setting latency timer to 64
Jan  9 15:22:23 Lulzer kernel: [56011.478013] cfg80211: World regulatory domain updated:
Jan  9 15:22:23 Lulzer kernel: [56011.478022] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 15:22:23 Lulzer kernel: [56011.478030] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.478038] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.478044] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.478050] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.478056] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.544348] Found chip type AI (0x13a1a8d9)
Jan  9 15:22:23 Lulzer kernel: [56011.555671] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021 macaddr: c4:46:19:6c:a9:c0
Jan  9 15:22:23 Lulzer kernel: [56011.555944] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.555953] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.555960] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.555968] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.555974] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.555981] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.555987] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.555995] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556001] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556008] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556014] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556021] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556027] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556035] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556041] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556048] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556054] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556061] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556067] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556075] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556081] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556088] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556094] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556102] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556108] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556115] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556121] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.556129] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.556566] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Jan  9 15:22:23 Lulzer kernel: [56011.558269] wl_set_hint: Sending country code US to MAC80211
Jan  9 15:22:23 Lulzer kernel: [56011.558280] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (Compiled at 15:18:31 on Jan  9 2011)
Jan  9 15:22:23 Lulzer kernel: [56011.558315] cfg80211: Calling CRDA for country: US
Jan  9 15:22:23 Lulzer kernel: [56011.569824] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569833] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569838] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569842] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569846] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569850] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569853] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569857] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569860] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569864] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569868] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569872] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569875] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569879] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569882] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569886] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569889] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569893] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569897] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569900] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569904] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 15:22:23 Lulzer kernel: [56011.569908] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569911] cfg80211: Disabling freq 2467 MHz
Jan  9 15:22:23 Lulzer kernel: [56011.569913] cfg80211: Disabling freq 2472 MHz
Jan  9 15:22:23 Lulzer kernel: [56011.569916] cfg80211: Disabling freq 2484 MHz
Jan  9 15:22:23 Lulzer kernel: [56011.569920] cfg80211: Regulatory domain changed to country: US
Jan  9 15:22:23 Lulzer kernel: [56011.569922] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 15:22:23 Lulzer kernel: [56011.569926] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569930] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569934] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569938] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569942] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 15:22:23 Lulzer kernel: [56011.569946] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan  9 15:29:27 Lulzer kernel: [56435.290530] brcm80211 0000:06:00.0: PCI INT A disabled
Jan  9 15:31:51 Lulzer kernel: [56578.819540] lp: driver loaded but no devices found
Jan  9 15:31:51 Lulzer kernel: [56579.388439] st: Version 20081215, fixed bufsize 32768, s/g segs 256
Jan  9 15:32:10 Lulzer kernel: [56598.400742] lp: driver loaded but no devices found
Jan  9 15:33:10 Lulzer kernel: [56658.383420] lib80211: common routines for IEEE802.11 drivers
Jan  9 15:33:10 Lulzer kernel: [56658.383428] lib80211_crypt: registered algorithm 'NULL'
Jan  9 15:33:10 Lulzer kernel: [56658.506269] wl: disagrees about version of symbol lib80211_get_crypto_ops
Jan  9 15:33:10 Lulzer kernel: [56658.506283] wl: Unknown symbol lib80211_get_crypto_ops (err -22)
Jan  9 16:26:11 Lulzer kernel: [59838.809614] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Down
Jan  9 16:26:11 Lulzer kernel: [59839.455288] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
Jan  9 16:33:24 Lulzer kernel: imklog 4.2.0, log source = /proc/kmsg started.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Initializing cgroup subsys cpu
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Linux version 2.6.35-24-generic (buildd@yellow) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #42-Ubuntu SMP Thu Dec 2 02:41:37 UTC 2010 (Ubuntu 2.6.35-24.42-generic 2.6.35.8)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=85c51aea-99ce-4a1a-9c1a-5af285a7f145 ro quiet splash
Jan  9 16:33:24 Lulzer kernel: [    0.000000] BIOS-provided physical RAM map:
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000006fe90000 (usable)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 000000006fe90000 - 000000006fead000 (ACPI data)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 000000006fead000 - 000000006feaf000 (ACPI NVS)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 000000006feaf000 - 000000006feff000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 000000006ff00000 - 0000000080000000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] NX (Execute Disable) protection: active
Jan  9 16:33:24 Lulzer kernel: [    0.000000] DMI present.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] No AGP bridge found
Jan  9 16:33:24 Lulzer kernel: [    0.000000] last_pfn = 0x6fe90 max_arch_pfn = 0x400000000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] MTRR default type: uncachable
Jan  9 16:33:24 Lulzer kernel: [    0.000000] MTRR fixed ranges enabled:
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   00000-9FFFF write-back
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   A0000-BFFFF uncachable
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   C0000-CEFFF write-protect
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   CF000-DFFFF uncachable
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   E0000-FFFFF write-protect
Jan  9 16:33:24 Lulzer kernel: [    0.000000] MTRR variable ranges enabled:
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   0 base 000000000000 mask FFFFC0000000 write-back
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   1 base 000040000000 mask FFFFE0000000 write-back
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   2 base 000060000000 mask FFFFF0000000 write-back
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   3 disabled
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   4 disabled
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   5 disabled
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   6 disabled
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   7 disabled
Jan  9 16:33:24 Lulzer kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Scanning 0 areas for low memory corruption
Jan  9 16:33:24 Lulzer kernel: [    0.000000] modified physical RAM map:
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 0000000000010000 - 000000000009dc00 (usable)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 00000000000d0000 - 0000000000100000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 0000000000100000 - 000000006fe90000 (usable)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 000000006fe90000 - 000000006fead000 (ACPI data)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 000000006fead000 - 000000006feaf000 (ACPI NVS)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 000000006feaf000 - 000000006feff000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 000000006ff00000 - 0000000080000000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] initial memory mapped : 0 - 20000000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] found SMP MP-table at [ffff8800000f8080] f8080
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Using GB pages for direct mapping
Jan  9 16:33:24 Lulzer kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000006fe90000
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  0000000000 - 0040000000 page 1G
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  0040000000 - 006fe00000 page 2M
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  006fe00000 - 006fe90000 page 4k
Jan  9 16:33:24 Lulzer kernel: [    0.000000] kernel direct mapping tables up to 6fe90000 @ 16000-19000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] RAMDISK: 37572000 - 37ff0000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: RSDP 00000000000f8000 00024 (v02 PTLTD )
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: XSDT 000000006fe9c61f 0007C (v01 ACRSYS ACRPRDCT 06040000 INNA 00000000)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: FACP 000000006feac0b5 000F4 (v03 AMD    GUAM     06040000 AMD  000F4240)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: DSDT 000000006fe9c69b 0FA1A (v01    ATI    SB800 06040000 MSFT 03000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: FACS 000000006feaefc0 00040
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: SLIC 000000006feac21d 00176 (v01 ACRSYS ACRPRDCT 06040000 ANNI 00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: EINJ 000000006feac393 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: HEST 000000006feac543 002E4 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: BERT 000000006feac827 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: SSDT 000000006feac857 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: ERST 000000006feac938 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: SSDT 000000006feacba8 00386 (v01 AMD    POWERNOW 06040000 AMD  00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: APIC 000000006feacf2e 0005E (v01 PTLTD  ? APIC   06040000  LTP 00000000)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: MCFG 000000006feacf8c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: HPET 000000006feacfc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Scanning NUMA topology in Northbridge 24
Jan  9 16:33:24 Lulzer kernel: [    0.000000] No NUMA configuration found
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Faking a node at 0000000000000000-000000006fe90000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Initmem setup node 0 0000000000000000-000000006fe90000
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   NODE_DATA [0000000001d18240 - 0000000001d1d23f]
Jan  9 16:33:24 Lulzer kernel: [    0.000000]  [ffffea0000000000-ffffea00019fffff] PMD -> [ffff880002600000-ffff880003ffffff] on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Zone PFN ranges:
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   Normal   empty
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Movable zone start PFN for each node
Jan  9 16:33:24 Lulzer kernel: [    0.000000] early_node_map[2] active PFN ranges
Jan  9 16:33:24 Lulzer kernel: [    0.000000]     0: 0x00000010 -> 0x0000009d
Jan  9 16:33:24 Lulzer kernel: [    0.000000]     0: 0x00000100 -> 0x0006fe90
Jan  9 16:33:24 Lulzer kernel: [    0.000000] On node 0 totalpages: 458269
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA zone: 0 pages reserved
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA zone: 3925 pages, LIFO batch:0
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA32 zone: 6211 pages used for memmap
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   DMA32 zone: 448077 pages, LIFO batch:31
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x8008
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jan  9 16:33:24 Lulzer kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jan  9 16:33:24 Lulzer kernel: [    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Jan  9 16:33:24 Lulzer kernel: [    0.000000] nr_irqs_gsi: 40
Jan  9 16:33:24 Lulzer kernel: [    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
Jan  9 16:33:24 Lulzer kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Jan  9 16:33:24 Lulzer kernel: [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
Jan  9 16:33:24 Lulzer kernel: [    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 r8192 d23168 u1048576
Jan  9 16:33:24 Lulzer kernel: [    0.000000] pcpu-alloc: s91520 r8192 d23168 u1048576 alloc=1*2097152
Jan  9 16:33:24 Lulzer kernel: [    0.000000] pcpu-alloc: [0] 0 1 
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 452002
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Policy zone: DMA32
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=85c51aea-99ce-4a1a-9c1a-5af285a7f145 ro quiet splash
Jan  9 16:33:24 Lulzer kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Checking aperture...
Jan  9 16:33:24 Lulzer kernel: [    0.000000] No AGP bridge found
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Node 0: aperture @ fe06000000 size 32 MB
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Aperture beyond 4GB. Ignoring.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Subtract (48 early reservations)
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #2 [0037572000 - 0037ff0000]         RAMDISK
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #3 [0001d18000 - 0001d18230]             BRK
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #4 [00000f8090 - 0000100000]   BIOS reserved
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #5 [00000f8080 - 00000f8090]    MP-table mpf
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #6 [000009dc00 - 000009e071]   BIOS reserved
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #7 [000009e1d5 - 00000f8080]   BIOS reserved
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #8 [000009e071 - 000009e1d5]    MP-table mpc
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #12 [0001d18240 - 0001d1d240]       NODE_DATA
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #13 [0001d1d240 - 0001d1e240]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #14 [0001d17140 - 0001d17290]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #15 [000251f000 - 0002520000]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #16 [0002520000 - 0002521000]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #17 [0002600000 - 0004000000]        MEMMAP 0
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #18 [0001d172c0 - 0001d17440]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #19 [0001d1e240 - 0001d2a240]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #20 [0001d2b000 - 0001d2c000]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #21 [0001d17440 - 0001d17481]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #22 [0001d174c0 - 0001d17503]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #23 [0001d17540 - 0001d177e0]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #24 [0001d17800 - 0001d17868]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #25 [0001d17880 - 0001d178e8]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #26 [0001d17900 - 0001d17968]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #27 [0001d17980 - 0001d179e8]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #28 [0001d17a00 - 0001d17a68]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #29 [0001d17a80 - 0001d17ae8]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #30 [0001d17b00 - 0001d17b68]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #31 [0001d17b80 - 0001d17be8]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #32 [0001d17c00 - 0001d17c68]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #33 [0001d17c80 - 0001d17ce8]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #34 [0001d17d00 - 0001d17d68]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #35 [0001d17d80 - 0001d17da0]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #36 [0001d17dc0 - 0001d17e2a]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #37 [0001d17e40 - 0001d17eaa]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #38 [0001e00000 - 0001e1e000]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #39 [0001f00000 - 0001f1e000]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #40 [0001d17ec0 - 0001d17ec8]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #41 [0001d17f00 - 0001d17f08]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #42 [0001d17f40 - 0001d17f48]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #43 [0001d17f80 - 0001d17f90]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #44 [0001d2a240 - 0001d2a380]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #45 [0001d2a380 - 0001d2a3e0]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #46 [0001d2a400 - 0001d2a460]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000]   #47 [0001d2c000 - 0001d34000]         BOOTMEM
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Memory: 1781908k/1833536k available (5711k kernel code, 460k absent, 51168k reserved, 5379k data, 908k init)
Jan  9 16:33:24 Lulzer kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Hierarchical RCU implementation.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] 	RCU-based detection of stalled CPUs is disabled.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] 	Verbose stalled-CPUs detection is disabled.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] NR_IRQS:4352 nr_irqs:512
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Extended CMOS year: 2000
Jan  9 16:33:24 Lulzer kernel: [    0.000000] spurious 8259A interrupt: IRQ7.
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Console: colour VGA+ 80x25
Jan  9 16:33:24 Lulzer kernel: [    0.000000] console [tty0] enabled
Jan  9 16:33:24 Lulzer kernel: [    0.000000] allocated 18350080 bytes of page_cgroup
Jan  9 16:33:24 Lulzer kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Jan  9 16:33:24 Lulzer kernel: [    0.000000] hpet clockevent registered
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Fast TSC calibration using PIT
Jan  9 16:33:24 Lulzer kernel: [    0.000000] Detected 1296.802 MHz processor.
Jan  9 16:33:24 Lulzer kernel: [    0.020012] Calibrating delay loop (skipped), value calculated using timer frequency.. 2593.60 BogoMIPS (lpj=12968010)
Jan  9 16:33:24 Lulzer kernel: [    0.020019] pid_max: default: 32768 minimum: 301
Jan  9 16:33:24 Lulzer kernel: [    0.020054] Security Framework initialized
Jan  9 16:33:24 Lulzer kernel: [    0.020080] AppArmor: AppArmor initialized
Jan  9 16:33:24 Lulzer kernel: [    0.020082] Yama: becoming mindful.
Jan  9 16:33:24 Lulzer kernel: [    0.020500] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.030465] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.031075] Mount-cache hash table entries: 256
Jan  9 16:33:24 Lulzer kernel: [    0.031255] Initializing cgroup subsys ns
Jan  9 16:33:24 Lulzer kernel: [    0.031261] Initializing cgroup subsys cpuacct
Jan  9 16:33:24 Lulzer kernel: [    0.031267] Initializing cgroup subsys memory
Jan  9 16:33:24 Lulzer kernel: [    0.031279] Initializing cgroup subsys devices
Jan  9 16:33:24 Lulzer kernel: [    0.031283] Initializing cgroup subsys freezer
Jan  9 16:33:24 Lulzer kernel: [    0.031286] Initializing cgroup subsys net_cls
Jan  9 16:33:24 Lulzer kernel: [    0.031323] tseg: 006ff00000
Jan  9 16:33:24 Lulzer kernel: [    0.031326] CPU: Physical Processor ID: 0
Jan  9 16:33:24 Lulzer kernel: [    0.031329] CPU: Processor Core ID: 0
Jan  9 16:33:24 Lulzer kernel: [    0.031332] mce: CPU supports 6 MCE banks
Jan  9 16:33:24 Lulzer kernel: [    0.031347] using C1E aware idle routine
Jan  9 16:33:24 Lulzer kernel: [    0.031350] Performance Events: AMD PMU driver.
Jan  9 16:33:24 Lulzer kernel: [    0.031358] ... version:                0
Jan  9 16:33:24 Lulzer kernel: [    0.031361] ... bit width:              48
Jan  9 16:33:24 Lulzer kernel: [    0.031363] ... generic registers:      4
Jan  9 16:33:24 Lulzer kernel: [    0.031366] ... value mask:             0000ffffffffffff
Jan  9 16:33:24 Lulzer kernel: [    0.031369] ... max period:             00007fffffffffff
Jan  9 16:33:24 Lulzer kernel: [    0.031372] ... fixed-purpose events:   0
Jan  9 16:33:24 Lulzer kernel: [    0.031374] ... event mask:             000000000000000f
Jan  9 16:33:24 Lulzer kernel: [    0.034022] ACPI: Core revision 20100428
Jan  9 16:33:24 Lulzer kernel: [    0.060011] ftrace: converting mcount calls to 0f 1f 44 00 00
Jan  9 16:33:24 Lulzer kernel: [    0.060019] ftrace: allocating 22678 entries in 89 pages
Jan  9 16:33:24 Lulzer kernel: [    0.070121] Setting APIC routing to flat
Jan  9 16:33:24 Lulzer kernel: [    0.070482] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan  9 16:33:24 Lulzer kernel: [    0.175643] CPU0: AMD Athlon(tm) II Neo K325 Dual-Core Processor stepping 03
Jan  9 16:33:24 Lulzer kernel: [    0.180000] Booting Node   0, Processors  #1 Ok.
Jan  9 16:33:24 Lulzer kernel: [    0.340013] Brought up 2 CPUs
Jan  9 16:33:24 Lulzer kernel: [    0.340017] Total of 2 processors activated (5187.09 BogoMIPS).
Jan  9 16:33:24 Lulzer kernel: [    0.340029] System has AMD C1E enabled
Jan  9 16:33:24 Lulzer kernel: [    0.340053] Switch to broadcast mode on CPU1
Jan  9 16:33:24 Lulzer kernel: [    0.340371] Switch to broadcast mode on CPU0
Jan  9 16:33:24 Lulzer kernel: [    0.340371] devtmpfs: initialized
Jan  9 16:33:24 Lulzer kernel: [    0.341332] regulator: core version 0.5
Jan  9 16:33:24 Lulzer kernel: [    0.341402] Time: 16:32:57  Date: 01/09/11
Jan  9 16:33:24 Lulzer kernel: [    0.341460] NET: Registered protocol family 16
Jan  9 16:33:24 Lulzer kernel: [    0.341521] Trying to unpack rootfs image as initramfs...
Jan  9 16:33:24 Lulzer kernel: [    0.341650] node 0 link 0: io port [1000, ffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341656] TOM: 0000000080000000 aka 2048M
Jan  9 16:33:24 Lulzer kernel: [    0.341659] Fam 10h mmconf [e0000000, efffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341663] node 0 link 0: mmio [a0000, bffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341667] node 0 link 0: mmio [80000000, bfffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341672] node 0 link 0: mmio [c0000000, d01fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341676] node 0 link 0: mmio [d0200000, dfffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341679] node 0 link 0: mmio [e0000000, efffffff] ==> none
Jan  9 16:33:24 Lulzer kernel: [    0.341684] node 0 link 0: mmio [f0000000, ff7fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341688] bus: [00, 1f] on node 0 link 0
Jan  9 16:33:24 Lulzer kernel: [    0.341692] bus: 00 index 0 [io  0x0000-0xffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341696] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341699] bus: 00 index 2 [mem 0x80000000-0xdfffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341702] bus: 00 index 3 [mem 0xf0000000-0xfcffffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.341715] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Jan  9 16:33:24 Lulzer kernel: [    0.341719] ACPI: bus type pci registered
Jan  9 16:33:24 Lulzer kernel: [    0.341842] PCI: MMCONFIG for domain 0000 [bus 00-06] at [mem 0xe0000000-0xe06fffff] (base 0xe0000000)
Jan  9 16:33:24 Lulzer kernel: [    0.341847] PCI: not using MMCONFIG
Jan  9 16:33:24 Lulzer kernel: [    0.341849] PCI: Using configuration type 1 for base access
Jan  9 16:33:24 Lulzer kernel: [    0.341852] PCI: Using configuration type 1 for extended access
Jan  9 16:33:24 Lulzer kernel: [    0.341887] mtrr: your CPUs had inconsistent variable MTRR settings
Jan  9 16:33:24 Lulzer kernel: [    0.341889] mtrr: probably your BIOS does not setup all CPUs.
Jan  9 16:33:24 Lulzer kernel: [    0.341891] mtrr: corrected configuration.
Jan  9 16:33:24 Lulzer kernel: [    0.350216] bio: create slab <bio-0> at 0
Jan  9 16:33:24 Lulzer kernel: [    0.352766] ACPI: EC: Look up EC in DSDT
Jan  9 16:33:24 Lulzer kernel: [    0.353150] \_SB_:_OSC evaluation returned wrong type
Jan  9 16:33:24 Lulzer kernel: [    0.353153] _OSC request data:1 7 
Jan  9 16:33:24 Lulzer kernel: [    0.360000] ACPI: BIOS _OSI(Linux) query ignored
Jan  9 16:33:24 Lulzer kernel: [    0.360000] ACPI: OEMN 000000006feadd60 00024 (v01 AMD    NAHP     00000001 MSFT 03000001)
Jan  9 16:33:24 Lulzer kernel: [    0.360000] ACPI: Dynamic OEM Table Load:
Jan  9 16:33:24 Lulzer kernel: [    0.360000] ACPI: OEMN (null) 00024 (v01 AMD    NAHP     00000001 MSFT 03000001)
Jan  9 16:33:24 Lulzer kernel: [    0.380299] ACPI: Interpreter enabled
Jan  9 16:33:24 Lulzer kernel: [    0.380299] ACPI: (supports S0 S3 S4 S5)
Jan  9 16:33:24 Lulzer kernel: [    0.380299] ACPI: Using IOAPIC for interrupt routing
Jan  9 16:33:24 Lulzer kernel: [    0.380835] PCI: MMCONFIG for domain 0000 [bus 00-06] at [mem 0xe0000000-0xe06fffff] (base 0xe0000000)
Jan  9 16:33:24 Lulzer kernel: [    0.381753] [Firmware Bug]: PCI: MMCONFIG at [mem 0xe0000000-0xe06fffff] not reserved in ACPI motherboard resources
Jan  9 16:33:24 Lulzer kernel: [    0.381757] PCI: not using MMCONFIG
Jan  9 16:33:24 Lulzer kernel: [    0.400666] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
Jan  9 16:33:24 Lulzer kernel: [    0.401160] ACPI: No dock devices found.
Jan  9 16:33:24 Lulzer kernel: [    0.401165] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan  9 16:33:24 Lulzer kernel: [    0.403603] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Jan  9 16:33:24 Lulzer kernel: [    0.407604] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
Jan  9 16:33:24 Lulzer kernel: [    0.407610] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d1fff]
Jan  9 16:33:24 Lulzer kernel: [    0.407614] pci_root PNP0A08:00: host bridge window [mem 0x000d2000-0x000d3fff]
Jan  9 16:33:24 Lulzer kernel: [    0.407618] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d5fff]
Jan  9 16:33:24 Lulzer kernel: [    0.407622] pci_root PNP0A08:00: host bridge window [mem 0x000d6000-0x000d7fff]
Jan  9 16:33:24 Lulzer kernel: [    0.407626] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000d9fff]
Jan  9 16:33:24 Lulzer kernel: [    0.407629] pci_root PNP0A08:00: host bridge window [mem 0x000da000-0x000dbfff]
Jan  9 16:33:24 Lulzer kernel: [    0.407633] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000ddfff]
Jan  9 16:33:24 Lulzer kernel: [    0.407637] pci_root PNP0A08:00: host bridge window [mem 0x000de000-0x000dffff]
Jan  9 16:33:24 Lulzer kernel: [    0.407642] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.407645] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xffffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.407650] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
Jan  9 16:33:24 Lulzer kernel: [    0.407654] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
Jan  9 16:33:24 Lulzer kernel: [    0.407879] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
Jan  9 16:33:24 Lulzer kernel: [    0.407884] pci 0000:00:04.0: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.407945] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
Jan  9 16:33:24 Lulzer kernel: [    0.407949] pci 0000:00:05.0: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.408019] pci 0000:00:11.0: reg 10: [io  0x8440-0x8447]
Jan  9 16:33:24 Lulzer kernel: [    0.408028] pci 0000:00:11.0: reg 14: [io  0x8430-0x8433]
Jan  9 16:33:24 Lulzer kernel: [    0.408037] pci 0000:00:11.0: reg 18: [io  0x8420-0x8427]
Jan  9 16:33:24 Lulzer kernel: [    0.408045] pci 0000:00:11.0: reg 1c: [io  0x8410-0x8413]
Jan  9 16:33:24 Lulzer kernel: [    0.408054] pci 0000:00:11.0: reg 20: [io  0x8400-0x840f]
Jan  9 16:33:24 Lulzer kernel: [    0.408062] pci 0000:00:11.0: reg 24: [mem 0xd0607c00-0xd0607fff]
Jan  9 16:33:24 Lulzer kernel: [    0.408134] pci 0000:00:12.0: reg 10: [mem 0xd0404000-0xd0404fff]
Jan  9 16:33:24 Lulzer kernel: [    0.408210] pci 0000:00:12.2: reg 10: [mem 0xd0607000-0xd06070ff]
Jan  9 16:33:24 Lulzer kernel: [    0.408268] pci 0000:00:12.2: supports D1 D2
Jan  9 16:33:24 Lulzer kernel: [    0.408271] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Jan  9 16:33:24 Lulzer kernel: [    0.408277] pci 0000:00:12.2: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.408313] pci 0000:00:13.0: reg 10: [mem 0xd0405000-0xd0405fff]
Jan  9 16:33:24 Lulzer kernel: [    0.408388] pci 0000:00:13.2: reg 10: [mem 0xd0607400-0xd06074ff]
Jan  9 16:33:24 Lulzer kernel: [    0.408446] pci 0000:00:13.2: supports D1 D2
Jan  9 16:33:24 Lulzer kernel: [    0.408449] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Jan  9 16:33:24 Lulzer kernel: [    0.408455] pci 0000:00:13.2: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.408547] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Jan  9 16:33:24 Lulzer kernel: [    0.408556] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Jan  9 16:33:24 Lulzer kernel: [    0.408564] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Jan  9 16:33:24 Lulzer kernel: [    0.408573] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Jan  9 16:33:24 Lulzer kernel: [    0.408581] pci 0000:00:14.1: reg 20: [io  0x8450-0x845f]
Jan  9 16:33:24 Lulzer kernel: [    0.408636] pci 0000:00:14.2: reg 10: [mem 0xd0400000-0xd0403fff 64bit]
Jan  9 16:33:24 Lulzer kernel: [    0.408685] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
Jan  9 16:33:24 Lulzer kernel: [    0.408691] pci 0000:00:14.2: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.408816] pci 0000:00:16.0: reg 10: [mem 0xd0406000-0xd0406fff]
Jan  9 16:33:24 Lulzer kernel: [    0.408891] pci 0000:00:16.2: reg 10: [mem 0xd0607800-0xd06078ff]
Jan  9 16:33:24 Lulzer kernel: [    0.408949] pci 0000:00:16.2: supports D1 D2
Jan  9 16:33:24 Lulzer kernel: [    0.408952] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
Jan  9 16:33:24 Lulzer kernel: [    0.408958] pci 0000:00:16.2: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.409139] pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
Jan  9 16:33:24 Lulzer kernel: [    0.409145] pci 0000:01:05.0: reg 14: [io  0x9000-0x90ff]
Jan  9 16:33:24 Lulzer kernel: [    0.409151] pci 0000:01:05.0: reg 18: [mem 0xd0100000-0xd010ffff]
Jan  9 16:33:24 Lulzer kernel: [    0.409162] pci 0000:01:05.0: reg 24: [mem 0xd0000000-0xd00fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.409180] pci 0000:01:05.0: supports D1 D2
Jan  9 16:33:24 Lulzer kernel: [    0.409204] pci 0000:01:05.1: reg 10: [mem 0xd0110000-0xd0113fff]
Jan  9 16:33:24 Lulzer kernel: [    0.409234] pci 0000:01:05.1: supports D1 D2
Jan  9 16:33:24 Lulzer kernel: [    0.409316] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jan  9 16:33:24 Lulzer kernel: [    0.409322] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
Jan  9 16:33:24 Lulzer kernel: [    0.409327] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd01fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.409334] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:03:00.0: reg 10: [mem 0xd0200000-0xd023ffff 64bit]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:03:00.0: reg 18: [io  0xa000-0xa07f]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:03:00.0: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:04.0: PCI bridge to [bus 03-03]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:04.0:   bridge window [io  0xa000-0xafff]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:04.0:   bridge window [mem 0xd0200000-0xd02fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:06:00.0: reg 10: [mem 0xd0300000-0xd0303fff 64bit]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:06:00.0: supports D1 D2
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:06:00.0: PME# disabled
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:05.0: PCI bridge to [bus 06-06]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:05.0:   bridge window [mem 0xd0300000-0xd03fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4: PCI bridge to [bus 07-07] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Jan  9 16:33:24 Lulzer kernel: [    0.409551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
Jan  9 16:33:24 Lulzer kernel: [    0.409551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
Jan  9 16:33:24 Lulzer kernel: [    0.410172] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.410530] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.410904] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.411306] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.411649] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.411925] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.412202] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.412449] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
Jan  9 16:33:24 Lulzer kernel: [    0.412653] HEST: HEST table parsing is initialized.
Jan  9 16:33:24 Lulzer kernel: [    0.412770] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
Jan  9 16:33:24 Lulzer kernel: [    0.412775] vgaarb: loaded
Jan  9 16:33:24 Lulzer kernel: [    0.412965] SCSI subsystem initialized
Jan  9 16:33:24 Lulzer kernel: [    0.420000] libata version 3.00 loaded.
Jan  9 16:33:24 Lulzer kernel: [    0.420000] usbcore: registered new interface driver usbfs
Jan  9 16:33:24 Lulzer kernel: [    0.420000] usbcore: registered new interface driver hub
Jan  9 16:33:24 Lulzer kernel: [    0.420000] usbcore: registered new device driver usb
Jan  9 16:33:24 Lulzer kernel: [    0.420000] ACPI: WMI: Mapper loaded
Jan  9 16:33:24 Lulzer kernel: [    0.420000] PCI: Using ACPI for IRQ routing
Jan  9 16:33:24 Lulzer kernel: [    0.420000] PCI: pci_cache_line_size set to 64 bytes
Jan  9 16:33:24 Lulzer kernel: [    0.420000] reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
Jan  9 16:33:24 Lulzer kernel: [    0.420000] reserve RAM buffer: 000000006fe90000 - 000000006fffffff 
Jan  9 16:33:24 Lulzer kernel: [    0.420000] NetLabel: Initializing
Jan  9 16:33:24 Lulzer kernel: [    0.420000] NetLabel:  domain hash size = 128
Jan  9 16:33:24 Lulzer kernel: [    0.420000] NetLabel:  protocols = UNLABELED CIPSOv4
Jan  9 16:33:24 Lulzer kernel: [    0.420000] NetLabel:  unlabeled traffic allowed by default
Jan  9 16:33:24 Lulzer kernel: [    0.420000] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jan  9 16:33:24 Lulzer kernel: [    0.420000] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
Jan  9 16:33:24 Lulzer kernel: [    0.420000] Switching to clocksource tsc
Jan  9 16:33:24 Lulzer kernel: [    0.431774] AppArmor: AppArmor Filesystem Enabled
Jan  9 16:33:24 Lulzer kernel: [    0.431799] pnp: PnP ACPI init
Jan  9 16:33:24 Lulzer kernel: [    0.431827] ACPI: bus type pnp registered
Jan  9 16:33:24 Lulzer kernel: [    0.437289] pnp: PnP ACPI: found 10 devices
Jan  9 16:33:24 Lulzer kernel: [    0.437292] ACPI: ACPI bus type pnp unregistered
Jan  9 16:33:24 Lulzer kernel: [    0.437308] system 00:01: [io  0x0f50-0x0f51] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437313] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437318] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437328] system 00:06: [io  0x0220-0x022f] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437332] system 00:06: [io  0x040b] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437336] system 00:06: [io  0x04d0-0x04d1] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437340] system 00:06: [io  0x04d6] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437344] system 00:06: [io  0x0530-0x0537] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437348] system 00:06: [io  0x0c00-0x0c01] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437351] system 00:06: [io  0x0c14] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437355] system 00:06: [io  0x0c50-0x0c52] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437359] system 00:06: [io  0x0c6c] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437362] system 00:06: [io  0x0c6f] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437366] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437369] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437373] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437377] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437381] system 00:06: [io  0x0cd8-0x0cdf] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437385] system 00:06: [io  0x8000-0x805f] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437389] system 00:06: [io  0x8100-0x81ff window] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437394] system 00:06: [io  0x8200-0x82ff window] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437397] system 00:06: [io  0x0f40-0x0f47] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437401] system 00:06: [io  0x087f] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437406] system 00:06: [mem 0xff800000-0xff800fff] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437414] system 00:07: [mem 0x000e0000-0x000fffff] could not be reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437418] system 00:07: [mem 0xffe00000-0xffffffff] could not be reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437422] system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437427] system 00:07: [mem 0xfed00000-0xfed003ff] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437431] system 00:07: [mem 0xfed61000-0xfed613ff] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.437435] system 00:07: [mem 0xfed80000-0xfed80fff] has been reserved
Jan  9 16:33:24 Lulzer kernel: [    0.444209] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jan  9 16:33:24 Lulzer kernel: [    0.444214] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444220] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd01fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444225] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
Jan  9 16:33:24 Lulzer kernel: [    0.444231] pci 0000:00:04.0: PCI bridge to [bus 03-03]
Jan  9 16:33:24 Lulzer kernel: [    0.444235] pci 0000:00:04.0:   bridge window [io  0xa000-0xafff]
Jan  9 16:33:24 Lulzer kernel: [    0.444241] pci 0000:00:04.0:   bridge window [mem 0xd0200000-0xd02fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444245] pci 0000:00:04.0:   bridge window [mem pref disabled]
Jan  9 16:33:24 Lulzer kernel: [    0.444251] pci 0000:00:05.0: PCI bridge to [bus 06-06]
Jan  9 16:33:24 Lulzer kernel: [    0.444253] pci 0000:00:05.0:   bridge window [io  disabled]
Jan  9 16:33:24 Lulzer kernel: [    0.444258] pci 0000:00:05.0:   bridge window [mem 0xd0300000-0xd03fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444262] pci 0000:00:05.0:   bridge window [mem pref disabled]
Jan  9 16:33:24 Lulzer kernel: [    0.444268] pci 0000:00:14.4: PCI bridge to [bus 07-07]
Jan  9 16:33:24 Lulzer kernel: [    0.444271] pci 0000:00:14.4:   bridge window [io  disabled]
Jan  9 16:33:24 Lulzer kernel: [    0.444278] pci 0000:00:14.4:   bridge window [mem disabled]
Jan  9 16:33:24 Lulzer kernel: [    0.444283] pci 0000:00:14.4:   bridge window [mem pref disabled]
Jan  9 16:33:24 Lulzer kernel: [    0.444304]   alloc irq_desc for 16 on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.444307]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.444315] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan  9 16:33:24 Lulzer kernel: [    0.444320] pci 0000:00:04.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [    0.444328]   alloc irq_desc for 17 on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.444330]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.444336] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:33:24 Lulzer kernel: [    0.444341] pci 0000:00:05.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [    0.444351] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444355] pci_bus 0000:00: resource 5 [mem 0x000d0000-0x000d1fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444359] pci_bus 0000:00: resource 6 [mem 0x000d2000-0x000d3fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444363] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d5fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444366] pci_bus 0000:00: resource 8 [mem 0x000d6000-0x000d7fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444370] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000d9fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444374] pci_bus 0000:00: resource 10 [mem 0x000da000-0x000dbfff]
Jan  9 16:33:24 Lulzer kernel: [    0.444378] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000ddfff]
Jan  9 16:33:24 Lulzer kernel: [    0.444381] pci_bus 0000:00: resource 12 [mem 0x000de000-0x000dffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444385] pci_bus 0000:00: resource 13 [mem 0x80000000-0xdfffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444389] pci_bus 0000:00: resource 14 [mem 0xf0000000-0xffffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444393] pci_bus 0000:00: resource 15 [io  0x0000-0x0cf7]
Jan  9 16:33:24 Lulzer kernel: [    0.444396] pci_bus 0000:00: resource 16 [io  0x0d00-0xffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444400] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444404] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd01fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444408] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
Jan  9 16:33:24 Lulzer kernel: [    0.444412] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
Jan  9 16:33:24 Lulzer kernel: [    0.444416] pci_bus 0000:03: resource 1 [mem 0xd0200000-0xd02fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444420] pci_bus 0000:06: resource 1 [mem 0xd0300000-0xd03fffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444424] pci_bus 0000:07: resource 4 [mem 0x000a0000-0x000bffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444428] pci_bus 0000:07: resource 5 [mem 0x000d0000-0x000d1fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444431] pci_bus 0000:07: resource 6 [mem 0x000d2000-0x000d3fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444435] pci_bus 0000:07: resource 7 [mem 0x000d4000-0x000d5fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444439] pci_bus 0000:07: resource 8 [mem 0x000d6000-0x000d7fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444443] pci_bus 0000:07: resource 9 [mem 0x000d8000-0x000d9fff]
Jan  9 16:33:24 Lulzer kernel: [    0.444446] pci_bus 0000:07: resource 10 [mem 0x000da000-0x000dbfff]
Jan  9 16:33:24 Lulzer kernel: [    0.444450] pci_bus 0000:07: resource 11 [mem 0x000dc000-0x000ddfff]
Jan  9 16:33:24 Lulzer kernel: [    0.444453] pci_bus 0000:07: resource 12 [mem 0x000de000-0x000dffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444457] pci_bus 0000:07: resource 13 [mem 0x80000000-0xdfffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444461] pci_bus 0000:07: resource 14 [mem 0xf0000000-0xffffffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444465] pci_bus 0000:07: resource 15 [io  0x0000-0x0cf7]
Jan  9 16:33:24 Lulzer kernel: [    0.444468] pci_bus 0000:07: resource 16 [io  0x0d00-0xffff]
Jan  9 16:33:24 Lulzer kernel: [    0.444520] NET: Registered protocol family 2
Jan  9 16:33:24 Lulzer kernel: [    0.444692] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.445820] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.448452] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.449099] TCP: Hash tables configured (established 262144 bind 65536)
Jan  9 16:33:24 Lulzer kernel: [    0.449103] TCP reno registered
Jan  9 16:33:24 Lulzer kernel: [    0.449122] UDP hash table entries: 1024 (order: 3, 32768 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.449155] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.449297] NET: Registered protocol family 1
Jan  9 16:33:24 Lulzer kernel: [    0.449320] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
Jan  9 16:33:24 Lulzer kernel: [    0.533727] pci 0000:01:05.0: Boot video device
Jan  9 16:33:24 Lulzer kernel: [    0.533783] PCI: CLS 32 bytes, default 64
Jan  9 16:33:24 Lulzer kernel: [    0.575047] Scanning for low memory corruption every 60 seconds
Jan  9 16:33:24 Lulzer kernel: [    0.575232] audit: initializing netlink socket (disabled)
Jan  9 16:33:24 Lulzer kernel: [    0.575254] type=2000 audit(1294590776.570:1): initialized
Jan  9 16:33:24 Lulzer kernel: [    0.596178] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jan  9 16:33:24 Lulzer kernel: [    0.598303] VFS: Disk quotas dquot_6.5.2
Jan  9 16:33:24 Lulzer kernel: [    0.598383] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jan  9 16:33:24 Lulzer kernel: [    0.599237] fuse init (API version 7.14)
Jan  9 16:33:24 Lulzer kernel: [    0.599354] msgmni has been set to 3480
Jan  9 16:33:24 Lulzer kernel: [    0.600328] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Jan  9 16:33:24 Lulzer kernel: [    0.600332] io scheduler noop registered
Jan  9 16:33:24 Lulzer kernel: [    0.600335] io scheduler deadline registered
Jan  9 16:33:24 Lulzer kernel: [    0.600394] io scheduler cfq registered (default)
Jan  9 16:33:24 Lulzer kernel: [    0.600605] pcieport 0000:00:04.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [    0.600645]   alloc irq_desc for 40 on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.600648]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.600661] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
Jan  9 16:33:24 Lulzer kernel: [    0.600774] pcieport 0000:00:05.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [    0.600805]   alloc irq_desc for 41 on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.600808]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.600815] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
Jan  9 16:33:24 Lulzer kernel: [    0.600922] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan  9 16:33:24 Lulzer kernel: [    0.600950] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Jan  9 16:33:24 Lulzer kernel: [    0.602679] ACPI: AC Adapter [ADP1] (off-line)
Jan  9 16:33:24 Lulzer kernel: [    0.602774] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Jan  9 16:33:24 Lulzer kernel: [    0.602782] ACPI: Power Button [PWRB]
Jan  9 16:33:24 Lulzer kernel: [    0.602870] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
Jan  9 16:33:24 Lulzer kernel: [    0.604666] ACPI: Lid Switch [LID0]
Jan  9 16:33:24 Lulzer kernel: [    0.604770] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
Jan  9 16:33:24 Lulzer kernel: [    0.604778] ACPI: Sleep Button [SLPB]
Jan  9 16:33:24 Lulzer kernel: [    0.604830] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Jan  9 16:33:24 Lulzer kernel: [    0.604835] ACPI: Power Button [PWRF]
Jan  9 16:33:24 Lulzer kernel: [    0.605239] ACPI: acpi_idle registered with cpuidle
Jan  9 16:33:24 Lulzer kernel: [    0.605273] ACPI: processor limited to max C-state 1
Jan  9 16:33:24 Lulzer kernel: [    0.634714] thermal LNXTHERM:01: registered as thermal_zone0
Jan  9 16:33:24 Lulzer kernel: [    0.634729] ACPI: Thermal Zone [TZS0] (48 C)
Jan  9 16:33:24 Lulzer kernel: [    0.644808] thermal LNXTHERM:02: registered as thermal_zone1
Jan  9 16:33:24 Lulzer kernel: [    0.644824] ACPI: Thermal Zone [TZS1] (48 C)
Jan  9 16:33:24 Lulzer kernel: [    0.645089] [Firmware Bug]: ERST: ERST table is invalid
Jan  9 16:33:24 Lulzer kernel: [    0.645280] Linux agpgart interface v0.103
Jan  9 16:33:24 Lulzer kernel: [    0.645286] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Jan  9 16:33:24 Lulzer kernel: [    0.647052] brd: module loaded
Jan  9 16:33:24 Lulzer kernel: [    0.647717] loop: module loaded
Jan  9 16:33:24 Lulzer kernel: [    0.648095] pata_acpi 0000:00:14.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:33:24 Lulzer kernel: [    0.648572] Fixed MDIO Bus: probed
Jan  9 16:33:24 Lulzer kernel: [    0.648616] PPP generic driver version 2.4.2
Jan  9 16:33:24 Lulzer kernel: [    0.648658] tun: Universal TUN/TAP device driver, 1.6
Jan  9 16:33:24 Lulzer kernel: [    0.648660] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Jan  9 16:33:24 Lulzer kernel: [    0.648767] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan  9 16:33:24 Lulzer kernel: [    0.648883] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:33:24 Lulzer kernel: [    0.648911] ehci_hcd 0000:00:12.2: EHCI Host Controller
Jan  9 16:33:24 Lulzer kernel: [    0.648957] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Jan  9 16:33:24 Lulzer kernel: [    0.649033] ehci_hcd 0000:00:12.2: debug port 1
Jan  9 16:33:24 Lulzer kernel: [    0.649065] ehci_hcd 0000:00:12.2: irq 17, io mem 0xd0607000
Jan  9 16:33:24 Lulzer kernel: [    0.663567] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Jan  9 16:33:24 Lulzer kernel: [    0.663781] hub 1-0:1.0: USB hub found
Jan  9 16:33:24 Lulzer kernel: [    0.663788] hub 1-0:1.0: 5 ports detected
Jan  9 16:33:24 Lulzer kernel: [    0.664085] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:33:24 Lulzer kernel: [    0.664113] ehci_hcd 0000:00:13.2: EHCI Host Controller
Jan  9 16:33:24 Lulzer kernel: [    0.664166] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Jan  9 16:33:24 Lulzer kernel: [    0.664239] ehci_hcd 0000:00:13.2: debug port 1
Jan  9 16:33:24 Lulzer kernel: [    0.664257] ehci_hcd 0000:00:13.2: irq 17, io mem 0xd0607400
Jan  9 16:33:24 Lulzer kernel: [    0.683672] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Jan  9 16:33:24 Lulzer kernel: [    0.683879] hub 2-0:1.0: USB hub found
Jan  9 16:33:24 Lulzer kernel: [    0.683885] hub 2-0:1.0: 5 ports detected
Jan  9 16:33:24 Lulzer kernel: [    0.684195] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:33:24 Lulzer kernel: [    0.684224] ehci_hcd 0000:00:16.2: EHCI Host Controller
Jan  9 16:33:24 Lulzer kernel: [    0.684279] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
Jan  9 16:33:24 Lulzer kernel: [    0.684356] ehci_hcd 0000:00:16.2: debug port 1
Jan  9 16:33:24 Lulzer kernel: [    0.684376] ehci_hcd 0000:00:16.2: irq 17, io mem 0xd0607800
Jan  9 16:33:24 Lulzer kernel: [    0.703690] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
Jan  9 16:33:24 Lulzer kernel: [    0.703889] hub 3-0:1.0: USB hub found
Jan  9 16:33:24 Lulzer kernel: [    0.703896] hub 3-0:1.0: 4 ports detected
Jan  9 16:33:24 Lulzer kernel: [    0.704052] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jan  9 16:33:24 Lulzer kernel: [    0.704196]   alloc irq_desc for 18 on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.704199]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    0.704209] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan  9 16:33:24 Lulzer kernel: [    0.704238] ohci_hcd 0000:00:12.0: OHCI Host Controller
Jan  9 16:33:24 Lulzer kernel: [    0.704295] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
Jan  9 16:33:24 Lulzer kernel: [    0.704367] ohci_hcd 0000:00:12.0: irq 18, io mem 0xd0404000
Jan  9 16:33:24 Lulzer kernel: [    0.740092] Freeing initrd memory: 10744k freed
Jan  9 16:33:24 Lulzer kernel: [    0.767869] hub 4-0:1.0: USB hub found
Jan  9 16:33:24 Lulzer kernel: [    0.767915] hub 4-0:1.0: 5 ports detected
Jan  9 16:33:24 Lulzer kernel: [    0.768119] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan  9 16:33:24 Lulzer kernel: [    0.768142] ohci_hcd 0000:00:13.0: OHCI Host Controller
Jan  9 16:33:24 Lulzer kernel: [    0.768195] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Jan  9 16:33:24 Lulzer kernel: [    0.768258] ohci_hcd 0000:00:13.0: irq 18, io mem 0xd0405000
Jan  9 16:33:24 Lulzer kernel: [    0.827842] hub 5-0:1.0: USB hub found
Jan  9 16:33:24 Lulzer kernel: [    0.827887] hub 5-0:1.0: 5 ports detected
Jan  9 16:33:24 Lulzer kernel: [    0.828089] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan  9 16:33:24 Lulzer kernel: [    0.828114] ohci_hcd 0000:00:16.0: OHCI Host Controller
Jan  9 16:33:24 Lulzer kernel: [    0.828168] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 6
Jan  9 16:33:24 Lulzer kernel: [    0.828234] ohci_hcd 0000:00:16.0: irq 18, io mem 0xd0406000
Jan  9 16:33:24 Lulzer kernel: [    0.865148] ACPI: Battery Slot [BAT0] (battery present)
Jan  9 16:33:24 Lulzer kernel: [    0.887851] hub 6-0:1.0: USB hub found
Jan  9 16:33:24 Lulzer kernel: [    0.887927] hub 6-0:1.0: 4 ports detected
Jan  9 16:33:24 Lulzer kernel: [    0.888078] uhci_hcd: USB Universal Host Controller Interface driver
Jan  9 16:33:24 Lulzer kernel: [    0.888262] PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Jan  9 16:33:24 Lulzer kernel: [    0.902751] serio: i8042 KBD port at 0x60,0x64 irq 1
Jan  9 16:33:24 Lulzer kernel: [    0.902769] serio: i8042 AUX port at 0x60,0x64 irq 12
Jan  9 16:33:24 Lulzer kernel: [    0.902916] mice: PS/2 mouse device common for all mice
Jan  9 16:33:24 Lulzer kernel: [    0.903181] rtc_cmos 00:04: RTC can wake from S4
Jan  9 16:33:24 Lulzer kernel: [    0.903232] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
Jan  9 16:33:24 Lulzer kernel: [    0.903282] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Jan  9 16:33:24 Lulzer kernel: [    0.903419] device-mapper: uevent: version 1.0.3
Jan  9 16:33:24 Lulzer kernel: [    0.903535] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
Jan  9 16:33:24 Lulzer kernel: [    0.903688] device-mapper: multipath: version 1.1.1 loaded
Jan  9 16:33:24 Lulzer kernel: [    0.903695] device-mapper: multipath round-robin: version 1.0.0 loaded
Jan  9 16:33:24 Lulzer kernel: [    0.904170] cpuidle: using governor ladder
Jan  9 16:33:24 Lulzer kernel: [    0.904174] cpuidle: using governor menu
Jan  9 16:33:24 Lulzer kernel: [    0.904562] TCP cubic registered
Jan  9 16:33:24 Lulzer kernel: [    0.904746] NET: Registered protocol family 10
Jan  9 16:33:24 Lulzer kernel: [    0.905247] lo: Disabled Privacy Extensions
Jan  9 16:33:24 Lulzer kernel: [    0.905536] NET: Registered protocol family 17
Jan  9 16:33:24 Lulzer kernel: [    0.905586] powernow-k8: Found 1 AMD Athlon(tm) II Neo K325 Dual-Core Processor (2 cpu cores) (version 2.20.00)
Jan  9 16:33:24 Lulzer kernel: [    0.905646] powernow-k8:    0 : pstate 0 (1300 MHz)
Jan  9 16:33:24 Lulzer kernel: [    0.905649] powernow-k8:    1 : pstate 1 (1100 MHz)
Jan  9 16:33:24 Lulzer kernel: [    0.905651] powernow-k8:    2 : pstate 2 (800 MHz)
Jan  9 16:33:24 Lulzer kernel: [    0.906011] PM: Resume from disk failed.
Jan  9 16:33:24 Lulzer kernel: [    0.906032] registered taskstats version 1
Jan  9 16:33:24 Lulzer kernel: [    0.906526]   Magic number: 11:817:539
Jan  9 16:33:24 Lulzer kernel: [    0.906684] rtc_cmos 00:04: setting system clock to 2011-01-09 16:32:58 UTC (1294590778)
Jan  9 16:33:24 Lulzer kernel: [    0.906688] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jan  9 16:33:24 Lulzer kernel: [    0.906691] EDD information not available.
Jan  9 16:33:24 Lulzer kernel: [    0.906790] Freeing unused kernel memory: 908k freed
Jan  9 16:33:24 Lulzer kernel: [    0.907221] Write protecting the kernel read-only data: 10240k
Jan  9 16:33:24 Lulzer kernel: [    0.907476] Freeing unused kernel memory: 412k freed
Jan  9 16:33:24 Lulzer kernel: [    0.907893] Freeing unused kernel memory: 1644k freed
Jan  9 16:33:24 Lulzer kernel: [    0.927520] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Jan  9 16:33:24 Lulzer kernel: [    0.938710] udev[111]: starting version 163
Jan  9 16:33:24 Lulzer kernel: [    1.003585] usb 1-5: new high speed USB device using ehci_hcd and address 2
Jan  9 16:33:24 Lulzer kernel: [    1.066530] atl1c 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan  9 16:33:24 Lulzer kernel: [    1.066585] atl1c 0000:03:00.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [    1.135886] scsi0 : pata_atiixp
Jan  9 16:33:24 Lulzer kernel: [    1.158877] scsi1 : pata_atiixp
Jan  9 16:33:24 Lulzer kernel: [    1.158972] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8450 irq 14
Jan  9 16:33:24 Lulzer kernel: [    1.158976] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8458 irq 15
Jan  9 16:33:24 Lulzer kernel: [    1.163907] ahci 0000:00:11.0: version 3.0
Jan  9 16:33:24 Lulzer kernel: [    1.163929]   alloc irq_desc for 19 on node 0
Jan  9 16:33:24 Lulzer kernel: [    1.163933]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    1.163945] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jan  9 16:33:24 Lulzer kernel: [    1.164003]   alloc irq_desc for 42 on node 0
Jan  9 16:33:24 Lulzer kernel: [    1.164006]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [    1.164019] ahci 0000:00:11.0: irq 42 for MSI/MSI-X
Jan  9 16:33:24 Lulzer kernel: [    1.164086] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
Jan  9 16:33:24 Lulzer kernel: [    1.164092] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
Jan  9 16:33:24 Lulzer kernel: [    1.164309] scsi2 : ahci
Jan  9 16:33:24 Lulzer kernel: [    1.164463] ata3: SATA max UDMA/133 abar m1024@0xd0607c00 port 0xd0607d00 irq 42
Jan  9 16:33:24 Lulzer kernel: [    1.190883] Initializing USB Mass Storage driver...
Jan  9 16:33:24 Lulzer kernel: [    1.191050] scsi3 : usb-storage 1-5:1.0
Jan  9 16:33:24 Lulzer kernel: [    1.191166] usbcore: registered new interface driver usb-storage
Jan  9 16:33:24 Lulzer kernel: [    1.191169] USB Mass Storage support registered.
Jan  9 16:33:24 Lulzer kernel: [    1.220998] atl1c 0000:03:00.0: version 1.0.0.2-NAPI
Jan  9 16:33:24 Lulzer kernel: [    1.302608] usb 2-5: new high speed USB device using ehci_hcd and address 2
Jan  9 16:33:24 Lulzer kernel: [    1.700123] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan  9 16:33:24 Lulzer kernel: [    1.701360] ata3.00: ATA-8: WDC WD2500BEVT-22A23T0, 01.01A01, max UDMA/133
Jan  9 16:33:24 Lulzer kernel: [    1.701366] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jan  9 16:33:24 Lulzer kernel: [    1.702826] ata3.00: configured for UDMA/133
Jan  9 16:33:24 Lulzer kernel: [    1.720388] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500BEVT-2 01.0 PQ: 0 ANSI: 5
Jan  9 16:33:24 Lulzer kernel: [    1.720648] sd 2:0:0:0: Attached scsi generic sg0 type 0
Jan  9 16:33:24 Lulzer kernel: [    1.720713] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
Jan  9 16:33:24 Lulzer kernel: [    1.720833] sd 2:0:0:0: [sda] Write Protect is off
Jan  9 16:33:24 Lulzer kernel: [    1.720838] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan  9 16:33:24 Lulzer kernel: [    1.720886] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan  9 16:33:24 Lulzer kernel: [    1.721697]  sda: sda1 sda2 < sda5 >
Jan  9 16:33:24 Lulzer kernel: [    1.787928] sd 2:0:0:0: [sda] Attached SCSI disk
Jan  9 16:33:24 Lulzer kernel: [    2.077273] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
Jan  9 16:33:24 Lulzer kernel: [    2.077281] EXT4-fs (sda1): write access will be enabled during recovery
Jan  9 16:33:24 Lulzer kernel: [    2.195627] scsi 3:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
Jan  9 16:33:24 Lulzer kernel: [    2.196556] sd 3:0:0:0: Attached scsi generic sg1 type 0
Jan  9 16:33:24 Lulzer kernel: [    2.202704] sd 3:0:0:0: [sdb] Attached SCSI removable disk
Jan  9 16:33:24 Lulzer kernel: [    8.694544] EXT4-fs (sda1): orphan cleanup on readonly fs
Jan  9 16:33:24 Lulzer kernel: [    8.694557] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083363
Jan  9 16:33:24 Lulzer kernel: [    8.694601] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083360
Jan  9 16:33:24 Lulzer kernel: [    8.694656] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083359
Jan  9 16:33:24 Lulzer kernel: [    8.694677] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1314612
Jan  9 16:33:24 Lulzer kernel: [    8.694697] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083356
Jan  9 16:33:24 Lulzer kernel: [    8.694769] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083355
Jan  9 16:33:24 Lulzer kernel: [    8.694794] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083298
Jan  9 16:33:24 Lulzer kernel: [    8.694813] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083297
Jan  9 16:33:24 Lulzer kernel: [    8.694832] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083293
Jan  9 16:33:24 Lulzer kernel: [    8.694874] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083292
Jan  9 16:33:24 Lulzer kernel: [    8.694892] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083179
Jan  9 16:33:24 Lulzer kernel: [    9.246545] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 8660255
Jan  9 16:33:24 Lulzer kernel: [    9.527207] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2623141
Jan  9 16:33:24 Lulzer kernel: [    9.569127] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2626475
Jan  9 16:33:24 Lulzer kernel: [    9.612937] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2623251
Jan  9 16:33:24 Lulzer kernel: [    9.628145] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2623245
Jan  9 16:33:24 Lulzer kernel: [    9.630576] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2623705
Jan  9 16:33:24 Lulzer kernel: [    9.635730] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2623699
Jan  9 16:33:24 Lulzer kernel: [    9.635762] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 2623249
Jan  9 16:33:24 Lulzer kernel: [    9.683748] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1314392
Jan  9 16:33:24 Lulzer kernel: [    9.683859] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1314391
Jan  9 16:33:24 Lulzer kernel: [    9.683881] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083156
Jan  9 16:33:24 Lulzer kernel: [    9.683894] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083155
Jan  9 16:33:24 Lulzer kernel: [    9.708525] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083058
Jan  9 16:33:24 Lulzer kernel: [    9.708567] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083052
Jan  9 16:33:24 Lulzer kernel: [    9.708600] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083011
Jan  9 16:33:24 Lulzer kernel: [    9.708620] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7083004
Jan  9 16:33:24 Lulzer kernel: [    9.708655] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1314324
Jan  9 16:33:24 Lulzer kernel: [    9.739005] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1314289
Jan  9 16:33:24 Lulzer kernel: [    9.763419] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7867458
Jan  9 16:33:24 Lulzer kernel: [    9.763538] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 8660104
Jan  9 16:33:24 Lulzer kernel: [    9.763798] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7081596
Jan  9 16:33:24 Lulzer kernel: [    9.763819] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7081593
Jan  9 16:33:24 Lulzer kernel: [    9.763838] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7081592
Jan  9 16:33:24 Lulzer kernel: [    9.763849] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7081590
Jan  9 16:33:24 Lulzer kernel: [    9.763867] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 7081588
Jan  9 16:33:24 Lulzer kernel: [    9.763887] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1311678
Jan  9 16:33:24 Lulzer kernel: [    9.785908] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1311282
Jan  9 16:33:24 Lulzer kernel: [    9.785971] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1311281
Jan  9 16:33:24 Lulzer kernel: [    9.785990] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1311271
Jan  9 16:33:24 Lulzer kernel: [    9.795868] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1310933
Jan  9 16:33:24 Lulzer kernel: [    9.795943] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1313754
Jan  9 16:33:24 Lulzer kernel: [    9.796011] EXT4-fs (sda1): 42 orphan inodes deleted
Jan  9 16:33:24 Lulzer kernel: [    9.796016] EXT4-fs (sda1): recovery complete
Jan  9 16:33:24 Lulzer kernel: [   10.938720] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Jan  9 16:33:24 Lulzer kernel: [   25.935539] Adding 5258236k swap on /dev/sda5.  Priority:-1 extents:1 across:5258236k 
Jan  9 16:33:24 Lulzer kernel: [   25.975378] udev[454]: starting version 163
Jan  9 16:33:24 Lulzer kernel: [   26.201649] lp: driver loaded but no devices found
Jan  9 16:33:24 Lulzer kernel: [   26.280264] ACPI: resource piix4_smbus [io  0x8040-0x8047] conflicts with ACPI region SMB0 [mem 0x00008040-0x0000804f pref]
Jan  9 16:33:24 Lulzer kernel: [   26.280270] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jan  9 16:33:24 Lulzer kernel: [   26.308605] EDAC MC: Ver: 2.1.0 Dec  2 2010
Jan  9 16:33:24 Lulzer kernel: [   26.331425] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jan  9 16:33:24 Lulzer kernel: [   26.341238] EDAC amd64_edac:  Ver: 3.3.0 Dec  2 2010
Jan  9 16:33:24 Lulzer kernel: [   26.378210] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
Jan  9 16:33:24 Lulzer kernel: [   26.378222] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
Jan  9 16:33:24 Lulzer kernel: [   26.378225]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
Jan  9 16:33:24 Lulzer kernel: [   26.378227]  (Note that use of the override may cause unknown side effects.)
Jan  9 16:33:24 Lulzer kernel: [   26.378254] amd64_edac: probe of 0000:00:18.2 failed with error -22
Jan  9 16:33:24 Lulzer kernel: [   26.378570] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
Jan  9 16:33:24 Lulzer kernel: [   26.403862] acpi device:40: registered as cooling_device2
Jan  9 16:33:24 Lulzer kernel: [   26.404458] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3e/LNXVIDEO:02/input/input5
Jan  9 16:33:24 Lulzer kernel: [   26.404534] ACPI: Video Device [VGA2] (multi-head: yes  rom: no  post: no)
Jan  9 16:33:24 Lulzer kernel: [   26.454893] Compat-wireless backport release: compat-wireless-2011-01-06
Jan  9 16:33:24 Lulzer kernel: [   26.454898] Backport based on linux-next.git next-20110107
Jan  9 16:33:24 Lulzer kernel: [   26.479395] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
Jan  9 16:33:24 Lulzer kernel: [   26.479402] Disabling lock debugging due to kernel taint
Jan  9 16:33:24 Lulzer kernel: [   26.495836] type=1400 audit(1294608804.078:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=810 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.496286] type=1400 audit(1294608804.078:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=810 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.496537] type=1400 audit(1294608804.078:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=810 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.500006] type=1400 audit(1294608804.088:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=835 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.500458] type=1400 audit(1294608804.088:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=835 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.500712] type=1400 audit(1294608804.088:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=835 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.510234] acer-wmi: Acer Laptop ACPI-WMI Extras
Jan  9 16:33:24 Lulzer kernel: [   26.511281] acer-wmi: Brightness must be controlled by generic video driver
Jan  9 16:33:24 Lulzer kernel: [   26.520756] type=1400 audit(1294608804.108:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=839 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.532218] type=1400 audit(1294608804.118:9): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=840 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.582619] cfg80211: Calling CRDA to update world regulatory domain
Jan  9 16:33:24 Lulzer kernel: [   26.624723] cfg80211: World regulatory domain updated:
Jan  9 16:33:24 Lulzer kernel: [   26.624728] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 16:33:24 Lulzer kernel: [   26.624733] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.624738] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.624742] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.624746] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.624749] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.679139] [fglrx] Maximum main memory to use for locked dma buffers: 1638 MBytes.
Jan  9 16:33:24 Lulzer kernel: [   26.679214] [fglrx]   vendor: 1002 device: 9712 count: 1
Jan  9 16:33:24 Lulzer kernel: [   26.679859] [fglrx] ioport: bar 1, base 0x9000, size: 0x100
Jan  9 16:33:24 Lulzer kernel: [   26.679881] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan  9 16:33:24 Lulzer kernel: [   26.679887] pci 0000:01:05.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [   26.689691] [fglrx] Kernel PAT support is enabled
Jan  9 16:33:24 Lulzer kernel: [   26.689722] [fglrx] module loaded - fglrx 8.78.30 [Sep 20 2010] with 1 minors
Jan  9 16:33:24 Lulzer kernel: [   26.707277] Linux video capture interface: v2.00
Jan  9 16:33:24 Lulzer kernel: [   26.714918] uvcvideo: Found UVC 1.00 device 1.3M WebCam (064e:a219)
Jan  9 16:33:24 Lulzer kernel: [   26.726565] input: 1.3M WebCam as /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input6
Jan  9 16:33:24 Lulzer kernel: [   26.726647] usbcore: registered new interface driver uvcvideo
Jan  9 16:33:24 Lulzer kernel: [   26.726651] USB Video Class driver (v0.1.0)
Jan  9 16:33:24 Lulzer kernel: [   26.801829] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:33:24 Lulzer kernel: [   26.801840] brcm80211 0000:06:00.0: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [   26.836853] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan  9 16:33:24 Lulzer kernel: [   26.865010] Found chip type AI (0x13a1a8d9)
Jan  9 16:33:24 Lulzer kernel: [   26.875696] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021 macaddr: c4:46:19:6c:a9:c0
Jan  9 16:33:24 Lulzer kernel: [   26.876565] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876570] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876574] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876578] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876582] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876586] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876589] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876593] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876596] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876600] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876604] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876608] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876611] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876615] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876618] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876622] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876626] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876630] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876633] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876637] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876640] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876644] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876648] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876652] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876655] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876659] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.876663] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.876667] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.890483] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Jan  9 16:33:24 Lulzer kernel: [   26.891340] wl_set_hint: Sending country code US to MAC80211
Jan  9 16:33:24 Lulzer kernel: [   26.891348] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (Compiled at 15:18:31 on Jan  9 2011)
Jan  9 16:33:24 Lulzer kernel: [   26.891380] cfg80211: Calling CRDA for country: US
Jan  9 16:33:24 Lulzer kernel: [   26.904028] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904035] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904039] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904044] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904047] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904051] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904055] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904058] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904062] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904066] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904069] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904073] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904076] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904080] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904084] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904088] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904091] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904095] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904098] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904102] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904105] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:33:24 Lulzer kernel: [   26.904109] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904112] cfg80211: Disabling freq 2467 MHz
Jan  9 16:33:24 Lulzer kernel: [   26.904115] cfg80211: Disabling freq 2472 MHz
Jan  9 16:33:24 Lulzer kernel: [   26.904117] cfg80211: Disabling freq 2484 MHz
Jan  9 16:33:24 Lulzer kernel: [   26.904121] cfg80211: Regulatory domain changed to country: US
Jan  9 16:33:24 Lulzer kernel: [   26.904124] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 16:33:24 Lulzer kernel: [   26.904128] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904132] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904136] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904140] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904144] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.904147] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan  9 16:33:24 Lulzer kernel: [   26.946488] type=1400 audit(1294608804.528:10): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=1110 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.946943] type=1400 audit(1294608804.528:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1110 comm="apparmor_parser"
Jan  9 16:33:24 Lulzer kernel: [   26.951533] hda_codec: ALC271X: BIOS auto-probing.
Jan  9 16:33:24 Lulzer kernel: [   26.951880] hda_codec: connection list not available for 0x24
Jan  9 16:33:24 Lulzer kernel: [   26.962338] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jan  9 16:33:24 Lulzer kernel: [   26.962435] HDA Intel 0000:01:05.1: setting latency timer to 64
Jan  9 16:33:24 Lulzer kernel: [   27.046110]   alloc irq_desc for 43 on node 0
Jan  9 16:33:24 Lulzer kernel: [   27.046115]   alloc kstat_irqs on node 0
Jan  9 16:33:24 Lulzer kernel: [   27.046134] atl1c 0000:03:00.0: irq 43 for MSI/MSI-X
Jan  9 16:33:24 Lulzer kernel: [   27.046716] ADDRCONF(NETDEV_UP): eth0: link is not ready
Jan  9 16:33:24 Lulzer kernel: [   27.159353] ppdev: user-space parallel port driver
Jan  9 16:33:24 Lulzer kernel: [   27.363216] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input7
Jan  9 16:33:25 Lulzer kernel: [   27.488172] ieee80211 phy0: device now idle
Jan  9 16:33:25 Lulzer kernel: [   27.489901] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jan  9 16:33:25 Lulzer kernel: [   27.510137] [fglrx] ATIF platform detected with notification ID: 0x81
Jan  9 16:33:25 Lulzer kernel: [   27.658856] vboxdrv: Found 2 processor cores.
Jan  9 16:33:25 Lulzer kernel: [   27.659793] VBoxDrv: dbg - g_abExecMemory=ffffffffa05c95e0
Jan  9 16:33:25 Lulzer kernel: [   27.659841] vboxdrv: fAsync=0 offMin=0x40b offMax=0xe9b
Jan  9 16:33:25 Lulzer kernel: [   27.660847] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
Jan  9 16:33:25 Lulzer kernel: [   27.660852] vboxdrv: Successfully loaded version 4.0.0 (interface 0x00160000).
Jan  9 16:33:25 Lulzer kernel: [   27.670290] [fglrx] GART Table is not in FRAME_BUFFER range 
Jan  9 16:33:25 Lulzer kernel: [   27.670512] [fglrx] Could not enable MSI; System prevented initialization
Jan  9 16:33:25 Lulzer kernel: [   27.671425] [fglrx] Firegl kernel thread PID: 1354
Jan  9 16:33:25 Lulzer kernel: [   27.671908] [fglrx] IRQ 18 Enabled
Jan  9 16:33:25 Lulzer kernel: [   27.713729] ieee80211 phy0: device no longer idle - scanning
Jan  9 16:33:25 Lulzer kernel: [   27.910680] [fglrx] Gart USWC size:548 M.
Jan  9 16:33:25 Lulzer kernel: [   27.910686] [fglrx] Gart cacheable size:215 M.
Jan  9 16:33:25 Lulzer kernel: [   27.910693] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
Jan  9 16:33:25 Lulzer kernel: [   27.910698] [fglrx] Reserved FB block: Unshared offset:14ffb000, size:5000 
Jan  9 16:33:25 Lulzer kernel: [   28.201772] ieee80211 phy0: device now idle
Jan  9 16:33:27 Lulzer kernel: [   29.455179] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
Jan  9 16:33:29 Lulzer kernel: [   31.477161] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
Jan  9 16:33:29 Lulzer kernel: [   31.496676] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
Jan  9 16:35:35 Lulzer kernel: [  157.932788] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jan  9 16:35:41 Lulzer kernel: [  163.987618] ieee80211 phy0: device no longer idle - scanning
Jan  9 16:35:42 Lulzer kernel: [  164.782059] ieee80211 phy0: device now idle
Jan  9 16:35:54 Lulzer kernel: [  177.215888] ieee80211 phy0: device no longer idle - scanning
Jan  9 16:35:55 Lulzer kernel: [  178.002035] ieee80211 phy0: device now idle
Jan  9 16:42:03 Lulzer kernel: [  546.250248] brcm80211 0000:06:00.0: PCI INT A disabled
Jan  9 16:42:30 Lulzer kernel: [  572.439045] Compat-wireless backport release: compat-wireless-2011-01-06
Jan  9 16:42:30 Lulzer kernel: [  572.439052] Backport based on linux-next.git next-20110107
Jan  9 16:42:30 Lulzer kernel: [  572.465233] cfg80211: Calling CRDA to update world regulatory domain
Jan  9 16:42:30 Lulzer kernel: [  572.478124] cfg80211: World regulatory domain updated:
Jan  9 16:42:30 Lulzer kernel: [  572.478129] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 16:42:30 Lulzer kernel: [  572.478135] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.478139] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.478143] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.478147] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.478151] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.501499] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:42:30 Lulzer kernel: [  572.501511] brcm80211 0000:06:00.0: setting latency timer to 64
Jan  9 16:42:30 Lulzer kernel: [  572.508965] Found chip type AI (0x13a1a8d9)
Jan  9 16:42:30 Lulzer kernel: [  572.519912] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021 macaddr: c4:46:19:6c:a9:c0
Jan  9 16:42:30 Lulzer kernel: [  572.520270] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520275] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520279] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520283] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520286] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520290] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520294] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520300] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520306] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520312] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520318] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520325] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520331] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520337] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520343] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520350] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520356] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520363] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520369] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520376] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520382] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520388] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520395] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520402] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520407] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520414] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520420] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.520427] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.520785] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Jan  9 16:42:30 Lulzer kernel: [  572.524533] wl_set_hint: Sending country code US to MAC80211
Jan  9 16:42:30 Lulzer kernel: [  572.524542] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (Compiled at 15:18:31 on Jan  9 2011)
Jan  9 16:42:30 Lulzer kernel: [  572.524566] cfg80211: Calling CRDA for country: US
Jan  9 16:42:30 Lulzer kernel: [  572.530110] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530117] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530122] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530126] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530130] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530134] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530137] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530141] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530144] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530148] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530152] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530156] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530159] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530163] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530166] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530170] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530174] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530177] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530181] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530185] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530188] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:42:30 Lulzer kernel: [  572.530192] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530195] cfg80211: Disabling freq 2467 MHz
Jan  9 16:42:30 Lulzer kernel: [  572.530198] cfg80211: Disabling freq 2472 MHz
Jan  9 16:42:30 Lulzer kernel: [  572.530200] cfg80211: Disabling freq 2484 MHz
Jan  9 16:42:30 Lulzer kernel: [  572.530204] cfg80211: Regulatory domain changed to country: US
Jan  9 16:42:30 Lulzer kernel: [  572.530207] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 16:42:30 Lulzer kernel: [  572.530211] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530215] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530219] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530223] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530226] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:42:30 Lulzer kernel: [  572.530230] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan  9 16:46:05 Lulzer kernel: [  787.694321] brcm80211 0000:06:00.0: PCI INT A disabled
Jan  9 16:46:21 Lulzer kernel: [  803.511601] Compat-wireless backport release: compat-wireless-2011-01-06
Jan  9 16:46:21 Lulzer kernel: [  803.511609] Backport based on linux-next.git next-20110107
Jan  9 16:46:21 Lulzer kernel: [  803.538010] cfg80211: Calling CRDA to update world regulatory domain
Jan  9 16:46:21 Lulzer kernel: [  803.555082] cfg80211: World regulatory domain updated:
Jan  9 16:46:21 Lulzer kernel: [  803.555089] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 16:46:21 Lulzer kernel: [  803.555098] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.555105] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.555112] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.555118] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.555124] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.573816] brcm80211 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan  9 16:46:21 Lulzer kernel: [  803.573832] brcm80211 0000:06:00.0: setting latency timer to 64
Jan  9 16:46:21 Lulzer kernel: [  803.581328] Found chip type AI (0x13a1a8d9)
Jan  9 16:46:21 Lulzer kernel: [  803.593340] wlc_bmac_attach:: deviceid 0x4357 nbands 1 board 0xe021 macaddr: c4:46:19:6c:a9:c0
Jan  9 16:46:21 Lulzer kernel: [  803.593827] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593833] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593837] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593841] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593844] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593848] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593852] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593856] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593859] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593863] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593866] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593871] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593874] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593878] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593881] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593885] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593889] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593893] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593896] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593900] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593903] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593907] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593911] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593915] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593918] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593922] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.593926] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.593930] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.594401] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Jan  9 16:46:21 Lulzer kernel: [  803.596729] wl_set_hint: Sending country code US to MAC80211
Jan  9 16:46:21 Lulzer kernel: [  803.596738] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (Compiled at 15:18:31 on Jan  9 2011)
Jan  9 16:46:21 Lulzer kernel: [  803.596763] cfg80211: Calling CRDA for country: US
Jan  9 16:46:21 Lulzer kernel: [  803.615888] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615895] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615899] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615903] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615907] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615911] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615914] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615918] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615921] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615925] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615929] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615933] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615936] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615940] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615943] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615947] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615950] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615954] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615958] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615962] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615965] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Jan  9 16:46:21 Lulzer kernel: [  803.615969] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615972] cfg80211: Disabling freq 2467 MHz
Jan  9 16:46:21 Lulzer kernel: [  803.615974] cfg80211: Disabling freq 2472 MHz
Jan  9 16:46:21 Lulzer kernel: [  803.615977] cfg80211: Disabling freq 2484 MHz
Jan  9 16:46:21 Lulzer kernel: [  803.615981] cfg80211: Regulatory domain changed to country: US
Jan  9 16:46:21 Lulzer kernel: [  803.615984] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  9 16:46:21 Lulzer kernel: [  803.615988] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615992] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615996] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.615999] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.616003] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  9 16:46:21 Lulzer kernel: [  803.616007] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

--------------020904000209070006050309
Content-Type: text/x-log;
 name="scan.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scan.log"

wlan0     Scan completed :
          Cell 01 - Address: 30:46:9A:17:52:4A
                    Channel:2
                    Frequency:2.417 GHz (Channel 2)
                    Quality=22/70  Signal level=-88 dBm  
                    Encryption key:on
                    ESSID:"andilley"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00000029d2fb8d80
                    Extra: Last beacon: 13870ms ago
                    IE: Unknown: 0008616E64696C6C6579
                    IE: Unknown: 010882848B960C121824
                    IE: Unknown: 030102
                    IE: Unknown: 050402030002
                    IE: Unknown: 0706555320010B1B
                    IE: Unknown: 2A0100
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 32043048606C
                    IE: Unknown: DD180050F2020101820003A4000027A4000042435E0062322F00
                    IE: Unknown: DD1E00904C334E111BFF00000000000000000000000000000000000000000000
                    IE: Unknown: 2D1A4E111BFF00000000000000000000000000000000000000000000
                    IE: Unknown: DD1A00904C34020D0800000000000000000000000000000000000000
                    IE: Unknown: 3D16020D0800000000000000000000000000000000000000
                    IE: Unknown: DD0900037F01010000FF7F
                    IE: Unknown: DD0A00037F04010002004000
                    IE: Unknown: DD0E0050F204104A0001101044000102
          Cell 02 - Address: 00:15:9A:74:71:0D
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=19/70  Signal level=-91 dBm  
                    Encryption key:on
                    ESSID:"Motorola902"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=000004bd9975218a
                    Extra: Last beacon: 710ms ago
                    IE: Unknown: 000B4D6F746F726F6C61393032
                    IE: Unknown: 010482848B96
                    IE: Unknown: 030101
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0104
                    IE: Unknown: 2F0104
                    IE: Unknown: 32080C1218243048606C
                    IE: Unknown: DD050010180101
          Cell 03 - Address: 00:23:69:56:27:B1
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=32/70  Signal level=-78 dBm  
                    Encryption key:on
                    ESSID:"Mythic"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=00000113b0c6fbe4
                    Extra: Last beacon: 270ms ago
                    IE: Unknown: 00064D7974686963
                    IE: Unknown: 010882848B962430486C
                    IE: Unknown: 030106
                    IE: Unknown: 2A0100
                    IE: Unknown: 2F0100
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 32040C121860
                    IE: Unknown: DD090010180201F0000000
                    IE: Unknown: DD180050F2020101800003A4000027A4000042435E0062322F00
          Cell 04 - Address: 00:1D:7E:DE:28:A8
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=21/70  Signal level=-89 dBm  
                    Encryption key:on
                    ESSID:"linksys"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=0000012081f0d183
                    Extra: Last beacon: 13630ms ago
                    IE: Unknown: 00076C696E6B737973
                    IE: Unknown: 010882848B962430486C
                    IE: Unknown: 030106
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0104
                    IE: Unknown: 2F0104
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 32040C121860
                    IE: Unknown: DD090010180200F4000000
          Cell 05 - Address: 00:16:B6:38:E9:04
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=19/70  Signal level=-91 dBm  
                    Encryption key:on
                    ESSID:"Adorno"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=000004bd999dc183
                    Extra: Last beacon: 13590ms ago
                    IE: Unknown: 000641646F726E6F
                    IE: Unknown: 010882848B96A4B0C8EC
                    IE: Unknown: 030106
                    IE: Unknown: 2A0104
                    IE: Unknown: 2F0104
                    IE: Unknown: 32048C9298E0
                    IE: Unknown: DD09001018020015000000
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
          Cell 06 - Address: 00:26:F2:BC:BE:FA
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=19/70  Signal level=-91 dBm  
                    Encryption key:on
                    ESSID:"9 brown"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=000003031cb00183
                    Extra: Last beacon: 13330ms ago
                    IE: Unknown: 0007392062726F776E
                    IE: Unknown: 010882848B9624B0486C
                    IE: Unknown: 03010B
                    IE: Unknown: 050402030000
                    IE: Unknown: 2A0100
                    IE: Unknown: 2F0100
                    IE: Unknown: 32048C129860
                    IE: Unknown: DD090010180201F0000000
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD180050F2020101800003A4000027A4000042435E0062322F00
          Cell 07 - Address: 00:26:F2:28:3E:F4
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=24/70  Signal level=-86 dBm  
                    Encryption key:on
                    ESSID:"53 Labratory"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=000003f9c25fe183
                    Extra: Last beacon: 100ms ago
                    IE: Unknown: 000C3533204C61627261746F7279
                    IE: Unknown: 010882848B962430486C
                    IE: Unknown: 03010B
                    IE: Unknown: 050401030000
                    IE: Unknown: 2A0104
                    IE: Unknown: 2F0104
                    IE: Unknown: 32040C121860
                    IE: Unknown: DD090010180201F0000000
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD180050F2020101800003A4000027A4000042435E0062322F00
          Cell 08 - Address: 94:44:52:70:A5:6A
                    Channel:2
                    Frequency:2.417 GHz (Channel 2)
                    Quality=21/70  Signal level=-89 dBm  
                    Encryption key:on
                    ESSID:"Belkin.456A"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=0000006d0a902183
                    Extra: Last beacon: 630ms ago
                    IE: Unknown: 000B42656C6B696E2E34353641
                    IE: Unknown: 010882840B162430486C
                    IE: Unknown: 030102
                    IE: Unknown: 050402030000
                    IE: Unknown: 2A0100
                    IE: Unknown: 2F0100
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 32040C121860
                    IE: Unknown: 2D1A7E181BFFFF000001000000000000000000000000000000000000
                    IE: Unknown: 3D16020D0000000000000000000000000000000000000000
                    IE: Unknown: DD0E0050F204104A0001101044000102
                    IE: Unknown: DD090010180200F0050000
                    IE: WPA Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD180050F2020101800003A4000027A4000042435E0062322F00
                    IE: Unknown: DD1E00904C337E181BFFFF000001000000000000000000000000000000000000
                    IE: Unknown: DD1A00904C34020D0000000000000000000000000000000000000000
          Cell 09 - Address: C0:3F:0E:C8:4B:A8
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=22/70  Signal level=-88 dBm  
                    Encryption key:off
                    ESSID:"dd-wrt"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=000001daaadfd183
                    Extra: Last beacon: 400ms ago
          Cell 10 - Address: 02:63:E4:B2:0E:9E
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=19/70  Signal level=-91 dBm  
                    Encryption key:off
                    ESSID:"print server 5953E3"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s


--------------020904000209070006050309--

