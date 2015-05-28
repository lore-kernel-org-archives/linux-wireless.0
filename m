Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34935 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbE1HlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 03:41:01 -0400
Received: by wicmx19 with SMTP id mx19so136406360wic.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 00:40:59 -0700 (PDT)
Received: from [192.168.2.100] ([185.63.202.55])
        by mx.google.com with ESMTPSA id fh6sm7171451wic.5.2015.05.28.00.38.40
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 28 May 2015 00:38:42 -0700 (PDT)
Date: Thu, 28 May 2015 07:40:39 +0002
From: =?iso-8859-2?b?UGF3ZbM=?= Kowalik <pl.kowalik.pawel@gmail.com>
Subject: rtl8723be drops connection until reboot
To: linux-wireless@vger.kernel.org
Message-Id: <1432798719.2307.2@smtp.gmail.com> (sfid-20150528_094106_525848_4ABA427F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One line summary of the problem: Realtek RTL8723BE drops connection 
until reboot

Full description of the problem/report:
 
Description from bug reported by me on Launchpad: 
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1451233)

I have a Lenovo B5400 laptop with RTL8723BE wireless module. The 
internet connection is constantly getting lost after a random duration 
(usually after 20-30 minutes). The NetworkManager applet does not 
recognize it (still looks like i have a connection), but when I try do 
disconnect and connect again, there is only one useful information I 
can find in dmesg:
"wlan0: deauthenticating from [ap mac address] by local choice (Reason: 
3=DEAUTH_LEAVING)"
Reinserting the driver (modprobe -r rtl8723be and modprobe rtl8723be) 
used to be my only workaround, but it does not work anymore and now I 
have to reboot.

The following workaround improves performance, but I am still 
encountering some minor performance issues while playing online games 
(random lag spikes):
sudo nano /etc/modprobe.d/rtl8723be.conf
options rtl8723be ips=0 fwlps=0

Kernel version: Linux version 4.1.0-040100rc5-generic (kernel@gloin) 
(gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201505250235 SMP 
Mon May 25 02:37:02 UTC 2015

Environment: 
Description:	Ubuntu 14.04.2 LTS
Release:	14.04

Software:
Linux pklap 4.1.0-040100rc5-generic #201505250235 SMP Mon May 25 
02:37:02 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C 4.8
Gnu make 3.81
binutils 2.24
util-linux 2.20.1
mount support
module-init-tools 15
e2fsprogs 1.42.9
pcmciautils 018
PPP 2.4.5
Linux C Library 2.19
Dynamic linker (ldd) 2.19
Procps 3.3.9
Net-tools 1.60
Kbd 1.15.5
Sh-utils 8.21
wireless-tools 30
Modules Loaded ctr ccm xt_addrtype xt_conntrack ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack 
bridge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio 
libcrc32c snd_hda_codec_hdmi hid_generic intel_rapl iosf_mbi 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel uvcvideo kvm 
usbhid arc4 videobuf2_vmalloc videobuf2_memops videobuf2_core 
crct10dif_pclmul hid v4l2_common crc32_pclmul videodev 
ghash_clmulni_intel media cryptd rtl8723be btcoexist rtl8723_common 
rtl_pci rtlwifi mac80211 i915 serio_raw snd_hda_codec_realtek 
snd_hda_codec_generic thinkpad_acpi cfg80211 btusb btbcm snd_seq_midi 
snd_seq_midi_event btintel nvram snd_hda_intel snd_hda_controller 
snd_rawmidi lpc_ich snd_hda_codec drm_kms_helper drm snd_hda_core 
snd_hwdep mei_me snd_pcm mei ie31200_edac i2c_algo_bit shpchp edac_core 
wmi joydev snd_seq snd_seq_device snd_timer snd soundcore video bnep 
rfcomm bluetooth parport_pc ppdev mac_hid lp parport r8169 ahci mii 
psmouse libahci

Processor information:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model	 : 60
model name	: Intel(R) Core(TM) i3-4000M CPU @ 2.40GHz
stepping	: 3
microcode	: 0x9
cpu MHz	 : 1496.625
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id	 : 0
cpu cores	: 2
apicid	 : 0
initial apicid	: 0
fpu	 : yes
fpu_exception	: yes
cpuid level	: 13
wp	 : yes
flags	 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm abm arat epb 
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust avx2 smep erms invpcid xsaveopt
bugs	 :
bogomips	: 4789.36
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model	 : 60
model name	: Intel(R) Core(TM) i3-4000M CPU @ 2.40GHz
stepping	: 3
microcode	: 0x9
cpu MHz	 : 2400.843
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id	 : 0
cpu cores	: 2
apicid	 : 1
initial apicid	: 1
fpu	 : yes
fpu_exception	: yes
cpuid level	: 13
wp	 : yes
flags	 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm abm arat epb 
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust avx2 smep erms invpcid xsaveopt
bugs	 :
bogomips	: 4789.36
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model	 : 60
model name	: Intel(R) Core(TM) i3-4000M CPU @ 2.40GHz
stepping	: 3
microcode	: 0x9
cpu MHz	 : 2379.750
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id	 : 1
cpu cores	: 2
apicid	 : 2
initial apicid	: 2
fpu	 : yes
fpu_exception	: yes
cpuid level	: 13
wp	 : yes
flags	 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm abm arat epb 
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust avx2 smep erms invpcid xsaveopt
bugs	 :
bogomips	: 4789.36
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model	 : 60
model name	: Intel(R) Core(TM) i3-4000M CPU @ 2.40GHz
stepping	: 3
microcode	: 0x9
cpu MHz	 : 1309.500
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id	 : 1
cpu cores	: 2
apicid	 : 3
initial apicid	: 3
fpu	 : yes
fpu_exception	: yes
cpuid level	: 13
wp	 : yes
flags	 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe 
popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm abm arat epb 
pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase 
tsc_adjust avx2 smep erms invpcid xsaveopt
bugs	 :
bogomips	: 4789.36
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

Module information:
ctr 16384 1 - Live 0x0000000000000000
ccm 20480 1 - Live 0x0000000000000000
xt_addrtype 16384 2 - Live 0x0000000000000000
xt_conntrack 16384 1 - Live 0x0000000000000000
ipt_MASQUERADE 16384 1 - Live 0x0000000000000000
nf_nat_masquerade_ipv4 16384 1 ipt_MASQUERADE, Live 0x0000000000000000
iptable_nat 16384 1 - Live 0x0000000000000000
nf_conntrack_ipv4 20480 2 - Live 0x0000000000000000
nf_defrag_ipv4 16384 1 nf_conntrack_ipv4, Live 0x0000000000000000
nf_nat_ipv4 16384 1 iptable_nat, Live 0x0000000000000000
iptable_filter 16384 1 - Live 0x0000000000000000
ip_tables 28672 2 iptable_nat,iptable_filter, Live 0x0000000000000000
x_tables 36864 5 
xt_addrtype,xt_conntrack,ipt_MASQUERADE,iptable_filter,ip_tables, Live 
0x0000000000000000
nf_nat 28672 2 nf_nat_masquerade_ipv4,nf_nat_ipv4, Live 
0x0000000000000000
nf_conntrack 106496 5 
xt_conntrack,nf_nat_masquerade_ipv4,nf_conntrack_ipv4,nf_nat_ipv4,nf_nat, 
Live 0x0000000000000000
bridge 114688 0 - Live 0x0000000000000000
stp 16384 1 bridge, Live 0x0000000000000000
llc 16384 2 bridge,stp, Live 0x0000000000000000
dm_thin_pool 65536 1 - Live 0x0000000000000000
dm_persistent_data 65536 1 dm_thin_pool, Live 0x0000000000000000
dm_bio_prison 16384 1 dm_thin_pool, Live 0x0000000000000000
dm_bufio 28672 1 dm_persistent_data, Live 0x0000000000000000
libcrc32c 16384 1 dm_persistent_data, Live 0x0000000000000000
snd_hda_codec_hdmi 53248 1 - Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
intel_rapl 20480 0 - Live 0x0000000000000000
iosf_mbi 16384 1 intel_rapl, Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
kvm_intel 159744 0 - Live 0x0000000000000000
uvcvideo 94208 0 - Live 0x0000000000000000
kvm 507904 1 kvm_intel, Live 0x0000000000000000
usbhid 53248 0 - Live 0x0000000000000000
arc4 16384 2 - Live 0x0000000000000000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
videobuf2_core 53248 1 uvcvideo, Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
hid 122880 2 hid_generic,usbhid, Live 0x0000000000000000
v4l2_common 16384 1 videobuf2_core, Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
videodev 172032 3 uvcvideo,videobuf2_core,v4l2_common, Live 
0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
media 24576 2 uvcvideo,videodev, Live 0x0000000000000000
cryptd 24576 1 ghash_clmulni_intel, Live 0x0000000000000000
rtl8723be 98304 0 - Live 0x0000000000000000
btcoexist 53248 1 rtl8723be, Live 0x0000000000000000
rtl8723_common 24576 1 rtl8723be, Live 0x0000000000000000
rtl_pci 32768 1 rtl8723be, Live 0x0000000000000000
rtlwifi 77824 2 rtl8723be,rtl_pci, Live 0x0000000000000000
mac80211 786432 3 rtl8723be,rtl_pci,rtlwifi, Live 0x0000000000000000
i915 1146880 5 - Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
snd_hda_codec_generic 77824 1 snd_hda_codec_realtek, Live 
0x0000000000000000
thinkpad_acpi 90112 1 - Live 0x0000000000000000
cfg80211 589824 2 rtlwifi,mac80211, Live 0x0000000000000000
btusb 49152 0 - Live 0x0000000000000000
btbcm 16384 1 btusb, Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
btintel 16384 1 btusb, Live 0x0000000000000000
nvram 16384 1 thinkpad_acpi, Live 0x0000000000000000
snd_hda_intel 32768 5 - Live 0x0000000000000000
snd_hda_controller 36864 1 snd_hda_intel, Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
snd_hda_codec 122880 5 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, 
Live 0x0000000000000000
drm_kms_helper 126976 1 i915, Live 0x0000000000000000
drm 352256 6 i915,drm_kms_helper, Live 0x0000000000000000
snd_hda_core 36864 5 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_controller,snd_hda_codec, 
Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
mei_me 24576 0 - Live 0x0000000000000000
snd_pcm 110592 4 
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec, Live 
0x0000000000000000
mei 94208 1 mei_me, Live 0x0000000000000000
ie31200_edac 16384 0 - Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
shpchp 40960 0 - Live 0x0000000000000000
edac_core 53248 1 ie31200_edac, Live 0x0000000000000000
wmi 20480 0 - Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
snd 86016 22 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,thinkpad_acpi,snd_hda_intel,snd_rawmidi,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer, 
Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
video 28672 1 i915, Live 0x0000000000000000
bnep 24576 2 - Live 0x0000000000000000
rfcomm 77824 0 - Live 0x0000000000000000
bluetooth 540672 14 btusb,btbcm,btintel,bnep,rfcomm, Live 
0x0000000000000000
parport_pc 36864 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 45056 3 parport_pc,ppdev,lp, Live 0x0000000000000000
r8169 90112 0 - Live 0x0000000000000000
ahci 36864 2 - Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
psmouse 135168 0 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000

Loaded driver and hardware information:
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : PNP0C09:00
    0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : PNP0C09:00
    0066-0066 : EC cmd
  0070-0071 : rtc_cmos
    0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vesafb
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1800-1803 : ACPI PM1a_EVT_BLK
  1804-1805 : ACPI PM1a_CNT_BLK
  1808-180b : ACPI PM_TMR
  1810-1815 : ACPI CPU throttle
  1820-182f : ACPI GPE0_BLK
  1830-1833 : iTCO_wdt
  1850-1850 : ACPI PM2_CNT_BLK
  1860-187f : iTCO_wdt
  3000-3fff : PCI Bus 0000:05
    3000-30ff : 0000:05:00.0
      3000-30ff : r8169
  4000-4fff : PCI Bus 0000:04
    4000-40ff : 0000:04:00.0
      4000-40ff : rtl_pci
  5000-503f : 0000:00:02.0
  5060-507f : 0000:00:1f.2
    5060-507f : ahci
  5080-5087 : 0000:00:1f.2
    5080-5087 : ahci
  5088-508f : 0000:00:1f.2
    5088-508f : ahci
  5090-5093 : 0000:00:1f.2
    5090-5093 : ahci
  5094-5097 : 0000:00:1f.2
    5094-5097 : ahci
  efa0-efbf : 0000:00:1f.3

00000000-00000fff : reserved
00001000-0009cfff : System RAM
0009d000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cebff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-d363afff : System RAM
  01000000-01811adc : Kernel code
  01811add-01f34f7f : Kernel data
  020a6000-021e8fff : Kernel bss
d363b000-dceeefff : reserved
dceef000-dcf9efff : ACPI Non-volatile Storage
dcf9f000-dcffefff : ACPI Tables
dcfff000-df9fffff : reserved
  dda00000-df9fffff : Graphics Stolen Memory
dfa00000-feafffff : PCI Bus 0000:00
  dfa10000-dfa1ffff : pnp 00:02
  e0000000-efffffff : 0000:00:02.0
  f0000000-f03fffff : 0000:00:02.0
  f0400000-f04fffff : PCI Bus 0000:05
    f0400000-f0403fff : 0000:05:00.0
      f0400000-f0403fff : r8169
    f0404000-f0404fff : 0000:05:00.0
      f0404000-f0404fff : r8169
  f0500000-f05fffff : PCI Bus 0000:04
    f0500000-f0503fff : 0000:04:00.0
      f0500000-f0503fff : rtl_pci
  f0600000-f060ffff : 0000:00:14.0
    f0600000-f060ffff : xhci-hcd
  f0610000-f0613fff : 0000:00:03.0
    f0610000-f0613fff : ICH HD audio
  f0614000-f0617fff : 0000:00:1b.0
    f0614000-f0617fff : ICH HD audio
  f0618000-f06180ff : 0000:00:1f.3
  f0619000-f061900f : 0000:00:16.0
    f0619000-f061900f : mei_me
  f061c000-f061c7ff : 0000:00:1f.2
    f061c000-f061c7ff : ahci
  f061d000-f061d3ff : 0000:00:1d.0
    f061d000-f061d3ff : ehci_hcd
  f061e000-f061e3ff : 0000:00:1a.0
    f061e000-f061e3ff : ehci_hcd
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:02
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed08000-fed08fff : reserved
fed10000-fed19fff : reserved
  fed10000-fed17fff : pnp 00:02
  fed18000-fed18fff : pnp 00:02
  fed19000-fed19fff : pnp 00:02
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
    fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:02
fed45000-fed8ffff : pnp 00:02
fed90000-fed93fff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffc00000-ffffffff : reserved
100000000-11f5fffff : System RAM
11f600000-11fffffff : RAM buffer

PCI information:
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v3/4th Gen Core 
Processor DRAM Controller (rev 06)
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
 Latency: 0
 Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation 4th Gen Core 
Processor Integrated Graphics Controller (rev 06) (prog-if 00 [VGA 
controller])
 Subsystem: Lenovo Device 5024
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 29
 Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
 Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
 Region 4: I/O ports at 5000 [size=64]
 Expansion ROM at <unassigned> [disabled]
 Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
  Address: fee0f00c Data: 4142
 Capabilities: [d0] Power Management version 2
  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [a4] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: i915

00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core 
Processor HD Audio Controller (rev 06)
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 30
 Region 0: Memory at f0610000 (64-bit, non-prefetchable) [size=16K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit-
  Address: fee0f00c Data: 4152
 Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 
00
  DevCap:	MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE-
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
 Kernel driver in use: snd_hda_intel

00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset 
Family USB xHCI (rev 04) (prog-if 30 [XHCI])
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 24
 Region 0: Memory at f0600000 (64-bit, non-prefetchable) [size=64K]
 Capabilities: [70] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
  Address: 00000000fee0f00c Data: 4191
 Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 8 Series/C220 
Series Chipset Family MEI Controller #1 (rev 04)
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 27
 Region 0: Memory at f0619000 (64-bit, non-prefetchable) [size=16]
 Capabilities: [50] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000fee0f00c Data: 41d1
 Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset 
Family USB EHCI #2 (rev 04) (prog-if 20 [EHCI])
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 16
 Region 0: Memory at f061e000 (32-bit, non-prefetchable) [size=1K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [58] Debug port: BAR=1 offset=00a0
 Capabilities: [98] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset 
High Definition Audio Controller (rev 04)
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 28
 Region 0: Memory at f0614000 (64-bit, non-prefetchable) [size=16K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000fee0f00c Data: 4122
 Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 
00
  DevCap:	MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE-
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 Capabilities: [100 v1] Virtual Channel
  Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
  Arb:	Fixed- WRR32- WRR64- WRR128-
  Ctrl:	ArbSelect=Fixed
  Status:	InProgress-
  VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
   Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
   Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
   Status:	NegoPending- InProgress-
  VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
   Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
   Ctrl:	Enable+ ID=2 ArbSelect=Fixed TC/VC=04
   Status:	NegoPending- InProgress-
 Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset 
Family PCI Express Root Port #1 (rev d4) (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
 I/O behind bridge: 0000f000-00000fff
 Memory behind bridge: fff00000-000fffff
 Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
  DevCap:	MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE+
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
  LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<1us, L1 <4us
   ClockPM- Surprise- LLActRep+ BwNot+
  LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
  RootCap: CRSVisible-
  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
  DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Via 
WAKE# ARIFwd-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF 
Disabled ARIFwd-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
  Address: 00000000 Data: 0000
 Capabilities: [90] Subsystem: Lenovo Device 5024
 Capabilities: [a0] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset 
Family PCI Express Root Port #3 (rev d4) (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
 I/O behind bridge: 00004000-00004fff
 Memory behind bridge: f0500000-f05fffff
 Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
  DevCap:	MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE+
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
  LnkCap:	Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<512ns, L1 <16us
   ClockPM- Surprise- LLActRep+ BwNot+
  LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt+ ABWMgmt-
  SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
   Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
  SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
   Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
  SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
   Changed: MRL- PresDet- LinkState+
  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
  RootCap: CRSVisible-
  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
  DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not 
Supported ARIFwd-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF 
Disabled ARIFwd-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
  Address: 00000000 Data: 0000
 Capabilities: [90] Subsystem: Lenovo Device 5024
 Capabilities: [a0] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset 
Family PCI Express Root Port #4 (rev d4) (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
 I/O behind bridge: 00003000-00003fff
 Memory behind bridge: f0400000-f04fffff
 Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
  DevCap:	MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE+
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
  LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<512ns, L1 <16us
   ClockPM- Surprise- LLActRep+ BwNot+
  LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt+ ABWMgmt-
  SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
   Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
  SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
   Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
  SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
   Changed: MRL- PresDet- LinkState+
  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
  RootCap: CRSVisible-
  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
  DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not 
Supported ARIFwd-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF 
Disabled ARIFwd-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
  Address: 00000000 Data: 0000
 Capabilities: [90] Subsystem: Lenovo Device 5024
 Capabilities: [a0] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset 
Family USB EHCI #1 (rev 04) (prog-if 20 [EHCI])
 Subsystem: Lenovo Device 5024
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 23
 Region 0: Memory at f061d000 (32-bit, non-prefetchable) [size=1K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [58] Debug port: BAR=1 offset=00a0
 Capabilities: [98] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM86 Express LPC Controller (rev 
04)
 Subsystem: Lenovo Device 5024
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Capabilities: [e0] Vendor Specific Information: Len=0c <?>
 Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset 
Family 6-port SATA Controller 1 [AHCI mode] (rev 04) (prog-if 01 [AHCI 
1.0])
 Subsystem: Lenovo Device 5024
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin B routed to IRQ 25
 Region 0: I/O ports at 5088 [size=8]
 Region 1: I/O ports at 5094 [size=4]
 Region 2: I/O ports at 5080 [size=8]
 Region 3: I/O ports at 5090 [size=4]
 Region 4: I/O ports at 5060 [size=32]
 Region 5: Memory at f061c000 (32-bit, non-prefetchable) [size=2K]
 Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
  Address: fee0c00c Data: 41b1
 Capabilities: [70] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
 Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family 
SMBus Controller (rev 04)
 Subsystem: Lenovo Device 5024
 Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Interrupt: pin C routed to IRQ 10
 Region 0: Memory at f0618000 (64-bit, non-prefetchable) [size=256]
 Region 4: I/O ports at efa0 [size=32]

04:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723BE 
PCIe Wireless Network Adapter
 Subsystem: Lenovo Device b728
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 18
 Region 0: I/O ports at 4000 [size=256]
 Region 2: Memory at f0500000 (64-bit, non-prefetchable) [size=16K]
 Capabilities: [40] Power Management version 3
  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
  Address: 0000000000000000 Data: 0000
 Capabilities: [70] Express (v2) Endpoint, MSI 00
  DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
   ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 512 bytes
  DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
  LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <512ns, L1 <64us
   ClockPM+ Surprise- LLActRep- BwNot-
  LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
  LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
  DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF 
Via message/WAKE#
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR+, OBFF 
Disabled
  LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [100 v2] Advanced Error Reporting
  UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
  UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
  UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
  CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
 Capabilities: [140 v1] Device Serial Number 00-23-b7-fe-ff-4c-e0-00
 Capabilities: [150 v1] Latency Tolerance Reporting
  Max snoop latency: 3145728ns
  Max no snoop latency: 3145728ns
 Capabilities: [158 v1] L1 PM Substates
  L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ 
L1_PM_Substates+
     PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
 Kernel driver in use: rtl8723be

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 10)
 Subsystem: Lenovo Device 5024
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 26
 Region 0: I/O ports at 3000 [size=256]
 Region 2: Memory at f0404000 (64-bit, non-prefetchable) [size=4K]
 Region 4: Memory at f0400000 (64-bit, non-prefetchable) [size=16K]
 Capabilities: [40] Power Management version 3
  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000fee0100c Data: 41c1
 Capabilities: [70] Express (v2) Endpoint, MSI 01
  DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 
<64us
   ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
  DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 4096 bytes
  DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
  LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s unlimited, L1 <64us
   ClockPM+ Surprise- LLActRep- BwNot-
  LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
  LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
  DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Via 
message/WAKE#
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF 
Disabled
  LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
  Vector table: BAR=4 offset=00000000
  PBA: BAR=4 offset=00000800
 Capabilities: [d0] Vital Product Data
  Unknown small resource type 00, will not decode more.
 Capabilities: [100 v2] Advanced Error Reporting
  UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
  UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
  UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
  CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
 Capabilities: [140 v1] Virtual Channel
  Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
  Arb:	Fixed- WRR32- WRR64- WRR128-
  Ctrl:	ArbSelect=Fixed
  Status:	InProgress-
  VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
   Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
   Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
   Status:	NegoPending- InProgress-
 Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
 Capabilities: [170 v1] Latency Tolerance Reporting
  Max snoop latency: 3145728ns
  Max no snoop latency: 3145728ns
 Capabilities: [178 v1] L1 PM Substates
  L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ 
L1_PM_Substates+
     PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
 Kernel driver in use: r8169

SCSI information:
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GU90N Rev: LC00
  Type: CD-ROM ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA Model: PLEXTOR PX-128M6 Rev: 1.03
  Type: Direct-Access ANSI SCSI revision: 05

