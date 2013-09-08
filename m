Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47979 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3IHLxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 07:53:22 -0400
Received: by mail-ve0-f179.google.com with SMTP id c14so2783252vea.10
        for <linux-wireless@vger.kernel.org>; Sun, 08 Sep 2013 04:53:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 8 Sep 2013 07:53:21 -0400
Message-ID: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> (sfid-20130908_135329_386206_974AB02D)
Subject: RTL8192CU continually reconnecting
From: Timothy Rundle <tgrundlesr@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My TL-WN821N with a RTL8192CU chipsets fails to stay connected. It
appears to be disconnecting every 5-10 seconds. Since the issue
happens with the mainline kernel, the downstream maintainer ask me to
post here. Here is a section of my kernel log:

Sep  6 22:37:34 james kernel: [  247.725230] wlan1: Connection to AP
00:0f:b3:a4:6c:5f lost
Sep  6 22:37:34 james kernel: [  247.764266] cfg80211: Calling CRDA to
update world regulatory domain
Sep  6 22:37:34 james kernel: [  247.770264] cfg80211: World
regulatory domain updated:
Sep  6 22:37:34 james kernel: [  247.770269] cfg80211:   (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  6 22:37:34 james kernel: [  247.770272] cfg80211:   (2402000 KHz
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  6 22:37:34 james kernel: [  247.770275] cfg80211:   (2457000 KHz
- 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  6 22:37:34 james kernel: [  247.770277] cfg80211:   (2474000 KHz
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  6 22:37:34 james kernel: [  247.770279] cfg80211:   (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  6 22:37:34 james kernel: [  247.770281] cfg80211:   (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  6 22:37:34 james kernel: [  247.861375] wlan1: authenticate with
00:0f:b3:a4:6c:5f
Sep  6 22:37:34 james kernel: [  247.862182] wlan1: send auth to
00:0f:b3:a4:6c:5f (try 1/3)
Sep  6 22:37:35 james kernel: [  247.964206] wlan1: send auth to
00:0f:b3:a4:6c:5f (try 2/3)
Sep  6 22:37:35 james kernel: [  248.068278] wlan1: send auth to
00:0f:b3:a4:6c:5f (try 3/3)
Sep  6 22:37:35 james kernel: [  248.172349] wlan1: authentication
with 00:0f:b3:a4:6c:5f timed out
Sep  6 22:37:41 james kernel: [  254.020841] wlan1: authenticate with
00:0f:b3:a4:6c:5f
Sep  6 22:37:41 james kernel: [  254.022301] wlan1: send auth to
00:0f:b3:a4:6c:5f (try 1/3)
Sep  6 22:37:41 james kernel: [  254.024112] wlan1: authenticated
Sep  6 22:37:41 james kernel: [  254.024415] rtl8192cu 1-4:1.0 wlan1:
disabling HT/VHT due to WEP/TKIP use
Sep  6 22:37:41 james kernel: [  254.024426] rtl8192cu 1-4:1.0 wlan1:
disabling HT as WMM/QoS is not supported by the AP
Sep  6 22:37:41 james kernel: [  254.024433] rtl8192cu 1-4:1.0 wlan1:
disabling VHT as WMM/QoS is not supported by the AP
Sep  6 22:37:41 james kernel: [  254.028075] wlan1: associate with
00:0f:b3:a4:6c:5f (try 1/3)
Sep  6 22:37:41 james kernel: [  254.036872] wlan1: RX AssocResp from
00:0f:b3:a4:6c:5f (capab=0x471 status=0 aid=4)
Sep  6 22:37:41 james kernel: [  254.036943] wlan1: associated
Sep  6 22:37:48 james kernel: [  261.758279] wlan1: Connection to AP
00:0f:b3:a4:6c:5f lost


My configuration information is listed below. Additional logs and
configuration can be found at the downstream bug report [A]. The issue
appears to be similar to one already reported on the mailing list [B].

[A] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220007
[B] http://www.spinics.net/lists/linux-wireless/msg111529.html


Keywords: networking, wireless, usb, RTL8192CU, realtek, TL-WN821N

timothy@james:~$ cat /proc/version
Linux version 3.11.0-999-generic (apw@gomeisa) (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201309060427 SMP Fri Sep 6 08:28:59
UTC 2013

No Kernel oops

N/A

timothy@james:~$ lsb_release -rd
Description: Ubuntu Saucy Salamander (development branch)
Release: 13.10

timothy@james:/usr/src/linux-headers-3.11.0-999-generic/scripts$ sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux james 3.11.0-999-generic #201309060427 SMP Fri Sep 6 08:28:59
UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130828
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         nls_utf8 isofs autofs4 parport_pc ppdev lp
parport rfcomm bnep bluetooth nfsd auth_rpcgss nfs_acl nfs lockd
sunrpc fscache arc4 rtl8192cu rtl_usb rtlwifi rtl8192c_common mac80211
cfg80211 hid_generic uvcvideo usbhid videobuf2_vmalloc usb_storage
videobuf2_memops hid videobuf2_core snd_usb_audio videodev
snd_usbmidi_lib radeon snd_hda_codec_hdmi snd_hda_codec_via
snd_hda_intel kvm snd_hda_codec snd_hwdep snd_pcm snd_page_alloc
snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device
snd_timer ttm drm_kms_helper psmouse microcode snd drm sp5100_tco
edac_core serio_raw edac_mce_amd soundcore i2c_algo_bit i2c_piix4
k10temp asus_atk0110 mac_hid ohci_pci pata_acpi ahci r8169 pata_atiixp
libahci mii

timothy@james:~$ cat /proc/cpuinfo
processor : 0
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6029.94
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 1
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 4
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6029.94
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 2
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 2
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6029.94
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 3
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 3
cpu cores : 4
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6029.94
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

timothy@james:~$ cat /proc/modules
nls_utf8 12557 1 - Live 0x0000000000000000
isofs 40272 1 - Live 0x0000000000000000
autofs4 39166 1 - Live 0x0000000000000000
parport_pc 32866 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 parport_pc,ppdev,lp, Live 0x0000000000000000
rfcomm 74658 0 - Live 0x0000000000000000
bnep 23966 2 - Live 0x0000000000000000
bluetooth 391597 10 rfcomm,bnep, Live 0x0000000000000000
nfsd 283232 2 - Live 0x0000000000000000
auth_rpcgss 59255 1 nfsd, Live 0x0000000000000000
nfs_acl 12883 1 nfsd, Live 0x0000000000000000
nfs 183238 0 - Live 0x0000000000000000
lockd 94791 2 nfsd,nfs, Live 0x0000000000000000
sunrpc 273894 6 nfsd,auth_rpcgss,nfs_acl,nfs,lockd, Live 0x0000000000000000
fscache 54777 1 nfs, Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
rtl8192cu 72806 0 - Live 0x0000000000000000
rtl_usb 18713 1 rtl8192cu, Live 0x0000000000000000
rtlwifi 64035 2 rtl8192cu,rtl_usb, Live 0x0000000000000000
rtl8192c_common 53827 1 rtl8192cu, Live 0x0000000000000000
mac80211 634607 3 rtl8192cu,rtl_usb,rtlwifi, Live 0x0000000000000000
cfg80211 504229 2 rtlwifi,mac80211, Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
uvcvideo 82247 0 - Live 0x0000000000000000
usbhid 53378 0 - Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
usb_storage 66714 0 - Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
hid 105676 2 hid_generic,usbhid, Live 0x0000000000000000
videobuf2_core 40903 1 uvcvideo, Live 0x0000000000000000
snd_usb_audio 155972 1 - Live 0x0000000000000000
videodev 139144 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
snd_usbmidi_lib 29576 1 snd_usb_audio, Live 0x0000000000000000
radeon 1518839 6 - Live 0x0000000000000000
snd_hda_codec_hdmi 41736 1 - Live 0x0000000000000000
snd_hda_codec_via 32006 1 - Live 0x0000000000000000
snd_hda_intel 57183 7 - Live 0x0000000000000000
kvm 457632 0 - Live 0x0000000000000000
snd_hda_codec 194881 3
snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_intel, Live
0x0000000000000000
snd_hwdep 13613 2 snd_usb_audio,snd_hda_codec, Live 0x0000000000000000
snd_pcm 107140 5
snd_usb_audio,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0x0000000000000000
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30465 2 snd_usbmidi_lib,snd_seq_midi, Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
snd_timer 30038 2 snd_pcm,snd_seq, Live 0x0000000000000000
ttm 84599 1 radeon, Live 0x0000000000000000
drm_kms_helper 53165 1 radeon, Live 0x0000000000000000
psmouse 104113 0 - Live 0x0000000000000000
microcode 23650 0 - Live 0x0000000000000000
snd 73802 28 snd_usb_audio,snd_usbmidi_lib,snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
drm 303157 8 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
sp5100_tco 14114 0 - Live 0x0000000000000000
edac_core 62914 0 - Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
edac_mce_amd 22792 0 - Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
i2c_algo_bit 13564 1 radeon, Live 0x0000000000000000
i2c_piix4 22299 0 - Live 0x0000000000000000
k10temp 13173 0 - Live 0x0000000000000000
asus_atk0110 19210 0 - Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
ohci_pci 13561 0 - Live 0x0000000000000000
pata_acpi 13038 0 - Live 0x0000000000000000
ahci 30063 3 - Live 0x0000000000000000
r8169 73111 0 - Live 0x0000000000000000
pata_atiixp 13242 1 - Live 0x0000000000000000
libahci 32088 1 ahci, Live 0x0000000000000000
mii 13981 1 r8169, Live 0x0000000000000000

timothy@james:~$ cat /proc/ioports
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
  0230-023f : pnp 00:08
  0290-029f : pnp 00:08
  0300-030f : pnp 00:08
  0376-0376 : 0000:00:14.1
    0376-0376 : pata_atiixp
  03c0-03df : vga+
  03f6-03f6 : 0000:00:14.1
    03f6-03f6 : pata_atiixp
  040b-040b : pnp 00:07
  04d0-04d1 : pnp 00:07
  04d6-04d6 : pnp 00:07
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
  08ff-08ff : ACPI PM2_CNT_BLK
  0900-090f : pnp 00:07
  0910-091f : pnp 00:07
  0a30-0a3f : pnp 00:08
  0b00-0b3f : pnp 00:07
    0b00-0b07 : piix4_smbus
    0b20-0b2f : pnp 00:07
      0b20-0b27 : piix4_smbus
  0c00-0c01 : pnp 00:07
  0c14-0c14 : pnp 00:07
  0c50-0c51 : pnp 00:07
  0c52-0c52 : pnp 00:07
  0c6c-0c6c : pnp 00:07
  0c6f-0c6f : pnp 00:07
  0cd0-0cd1 : pnp 00:07
  0cd2-0cd3 : pnp 00:07
  0cd4-0cd5 : pnp 00:07
  0cd6-0cd7 : pnp 00:07
  0cd8-0cdf : pnp 00:07
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  8000-800f : 0000:00:11.0
    8000-800f : ahci
  9000-9003 : 0000:00:11.0
    9000-9003 : ahci
  a000-a007 : 0000:00:11.0
    a000-a007 : ahci
  b000-b003 : 0000:00:11.0
    b000-b003 : ahci
  c000-c007 : 0000:00:11.0
    c000-c007 : ahci
  d000-dfff : PCI Bus 0000:01
    d000-d0ff : 0000:01:00.0
  e000-efff : PCI Bus 0000:02
    e800-e8ff : 0000:02:00.0
      e800-e8ff : r8169
  fe00-fefe : pnp 00:07
  ff00-ff0f : 0000:00:14.1
    ff00-ff0f : pata_atiixp

timothy@james:~$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cf3ff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cff7ffff : System RAM
  01000000-01753583 : Kernel code
  01753584-01d1807f : Kernel data
  01e70000-01fe2fff : Kernel bss
  c4000000-c7ffffff : GART
cff80000-cff8dfff : ACPI Tables
cff8e000-cffcffff : ACPI Non-volatile Storage
cffd0000-cfffffff : reserved
d0000000-dfffffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:09
f0000000-fed44fff : PCI Bus 0000:00
  faf00000-faffffff : PCI Bus 0000:02
    faff0000-faffffff : 0000:02:00.0
      faff0000-faffffff : r8169
  fbdf4000-fbdf7fff : 0000:00:14.2
    fbdf4000-fbdf7fff : ICH HD audio
  fbdf9000-fbdf9fff : 0000:00:14.5
    fbdf9000-fbdf9fff : ohci_hcd
  fbdfa800-fbdfa8ff : 0000:00:13.2
    fbdfa800-fbdfa8ff : ehci_hcd
  fbdfb000-fbdfbfff : 0000:00:13.1
    fbdfb000-fbdfbfff : ohci_hcd
  fbdfc000-fbdfcfff : 0000:00:13.0
    fbdfc000-fbdfcfff : ohci_hcd
  fbdfd000-fbdfdfff : 0000:00:12.1
    fbdfd000-fbdfdfff : ohci_hcd
  fbdfe000-fbdfefff : 0000:00:12.0
    fbdfe000-fbdfefff : ohci_hcd
  fbdff000-fbdff0ff : 0000:00:12.2
    fbdff000-fbdff0ff : ehci_hcd
  fbdff800-fbdffbff : 0000:00:11.0
    fbdff800-fbdffbff : ahci
  fbe00000-fbefffff : PCI Bus 0000:01
    fbec0000-fbedffff : 0000:01:00.0
    fbeec000-fbeeffff : 0000:01:00.1
      fbeec000-fbeeffff : ICH HD audio
    fbef0000-fbefffff : 0000:01:00.0
  fbf00000-fbffffff : PCI Bus 0000:02
    fbfc0000-fbfdffff : 0000:02:00.0
    fbfff000-fbffffff : 0000:02:00.0
      fbfff000-fbffffff : r8169
  fec00000-fec003ff : IOAPIC 0
  fec10000-fec1001f : pnp 00:07
  fed00000-fed003ff : HPET 2
  fed40000-fed44fff : pnp 00:07
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:06
ff700000-ffffffff : reserved
  ffb80000-ffbfffff : pnp 00:07
100000000-12fffffff : System RAM

sudo lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS780 Host Bridge
Subsystem: ASUSTeK Computer Inc. Device 82ee
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [c4] HyperTransport: Slave or Primary Interface
Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn+ LSEn- ExtCTL- 64b-
Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-
Revision ID: 3.00
Link Frequency 0: [b]
Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
Link Frequency 1: 200MHz
Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
Prefetchable memory behind bridge Upper: 00-00
Bus Number: 00
Capabilities: [54] HyperTransport: UnitID Clumping
Capabilities: [40] HyperTransport: Retry Mode
Capabilities: [9c] HyperTransport: #1a
Capabilities: [f8] HyperTransport: #1c

00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780 PCI to
PCI bridge (ext gfx port 0) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: fbe00000-fbefffff
Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 4181
Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 82ee
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [110 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: pcieport

00:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780 PCI to
PCI bridge (PCIE port 2) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fbf00000-fbffffff
Prefetchable memory behind bridge: 00000000faf00000-00000000faffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #6, PowerLimit 25.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 4191
Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 82ee
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [110 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode] (prog-if 01 [AHCI 1.0])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 22
Region 0: I/O ports at c000 [size=8]
Region 1: I/O ports at b000 [size=4]
Region 2: I/O ports at a000 [size=8]
Region 3: I/O ports at 9000 [size=4]
Region 4: I/O ports at 8000 [size=16]
Region 5: Memory at fbdff800 (32-bit, non-prefetchable) [size=1K]
Capabilities: [60] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [70] SATA HBA v1.0 InCfgSpace
Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fbdfe000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0
USB OHCI1 Controller (prog-if 10 [OHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fbdfd000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fbdff000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fbdfc000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0
USB OHCI1 Controller (prog-if 10 [OHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fbdfb000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 19
Region 0: Memory at fbdfa800 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 3a)
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
Kernel driver in use: piix4_smbus

00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 IDE Controller (prog-if 8a [Master SecP PriP])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Interrupt: pin A routed to IRQ 16
Region 0: I/O ports at 01f0 [size=8]
Region 1: I/O ports at 03f4 [size=1]
Region 2: I/O ports at 0170 [size=8]
Region 3: I/O ports at 0374 [size=1]
Region 4: I/O ports at ff00 [size=16]
Capabilities: [70] MSI: Enable- Count=1/2 Maskable- 64bit-
Address: 00000000  Data: 0000
Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA)
Subsystem: ASUSTeK Computer Inc. Device 82ea
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fbdf4000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI
to PCI Bridge (prog-if 01 [Subtractive decode])
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Region 0: Memory at fbdf9000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor HyperTransport Configuration
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [80] HyperTransport: Host or Secondary Interface
Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn+ LSEn+ ExtCTL- 64b-
Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Revision ID: 3.00
Link Frequency: [b]
Link Error: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Address Map
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor DRAM Controller
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Miscellaneous Control
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [f0] Secure device <?>
Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Link Control
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] RV710 [Radeon HD 4350/4550] (prog-if 00 [VGA controller])
Subsystem: Micro-Star International Co., Ltd. R4350 MD512H (MS-V161)
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 44
Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at fbef0000 (64-bit, non-prefetchable) [size=64K]
Region 4: I/O ports at d000 [size=256]
Expansion ROM at fbec0000 [disabled] [size=128K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41d1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: radeon

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] RV710/730
HDMI Audio [Radeon HD 4000 series]
Subsystem: Micro-Star International Co., Ltd. Device aa38
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 43
Region 0: Memory at fbeec000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41c1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
Subsystem: ASUSTeK Computer Inc. M3A78-EH Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 42
Region 0: I/O ports at e800 [size=256]
Region 2: Memory at fbfff000 (64-bit, non-prefetchable) [size=4K]
Region 4: Memory at faff0000 (64-bit, prefetchable) [size=64K]
Expansion ROM at fbfc0000 [disabled] [size=128K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41a1
Capabilities: [70] Express (v1) Endpoint, MSI 01
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 4096 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
Vector table: BAR=4 offset=00000000
PBA: BAR=4 offset=00000800
Capabilities: [d0] Vital Product Data
Unknown small resource type 05, will not decode more.
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 00-00-00-00-ec-10-68-81
Kernel driver in use: r8169

timothy@james:~$ cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GH22NS50  Rev: TN02
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 05.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: USB SD Reader    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: USB CF Reader    Rev: 1.01
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic  Model: USB xD/SM Reader Rev: 1.02
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic  Model: USB MS Reader    Rev: 1.03
  Type:   Direct-Access                    ANSI  SCSI revision: 00

[7.7] timothy@james:~$ ls /proc
1     1668  1993  2284 28    397  681 acpi       meminfo
10    167   1994  2288 2833  40   693 asound       misc
1065  168   1995  2293 2890  403  695 buddyinfo      modules
11    17    2  2298 29    41   7 bus       mounts
1162  1795  20  23 2904  42   709 cgroups        mtrr
1171  1797  2019  2300 294   43   716 cmdline        net
1195  18    2023  2305 299   432  72 consoles       pagetypeinfo
12    1864  2058  2306 3     433  721 cpuinfo        partitions
1202  1866  2076  2312 30    436  738 crypto       sched_debug
1207  1888  2078  2321 3002  44   754 devices        schedstat
1213  1892  21  2352 3005  45   785 diskstats      scsi
1233  19    2102  2387 3007  46   786 dma       self
1237  1904  2110  2388 3018  466  788 driver       slabinfo
1250  1911  2115  24 31    47   791 execdomains    softirqs
13    1912  2118  2445 3195  48   8 fb       stat
1301  1917  22  2451 3199  49   810 filesystems    swaps
1316  1918  2217  2468 32    493  859 fs       sys
1330  1922  2219  2477 3217  5    866 interrupts     sysrq-trigger
1379  1926  2220  2487 3223  50   868 iomem       sysvipc
14    1930  2221  25 3252  51   892 ioports        timer_list
143   1946  2229  2506 3289  52   893 irq       timer_stats
145   1948  2231  2511 3298  53   896 kallsyms       tty
147   1949  2232  2535 33    54   9 kcore       uptime
149   1957  2239  2543 34    545  91 key-users      version
15    1977  2240  2544 35    55   914 kmsg       vmallocinfo
150   1979  2241  26 361   56   92 kpagecount     vmstat
151   1981  2255  2682 368   57   922 kpageflags     zoneinfo
152   1985  2259  27 37    6    946 latency_stats
153   1987  2261  2709 38    629  964 loadavg
154   1990  2265  2762 39    630  969 locks
16    1992  228   2775 391   68   970 mdstat

sudo lsusb -vvv

Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ohci_hcd
  iProduct                2 OHCI PCI host controller
  iSerial                 1 0000:00:14.5
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        2 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 002 Device 002: ID 18e3:9102 Fitipower Integrated Technology Inc
Multi Card Reader
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x18e3 Fitipower Integrated Technology Inc
  idProduct          0x9102 Multi Card Reader
  bcdDevice            1.00
  iManufacturer           1 Generic
  iProduct                2 Mass Storage Device
  iSerial                 3 18E3312D81B
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:13.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ohci_hcd
  iProduct                2 OHCI PCI host controller
  iSerial                 1 0000:00:13.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        2 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ohci_hcd
  iProduct                2 OHCI PCI host controller
  iSerial                 1 0000:00:13.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        2 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 001 Device 005: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU
802.11n WLAN Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x8178 RTL8192CU 802.11n WLAN Adapter
  bcdDevice            2.00
  iManufacturer           1 802.11n
  iProduct                2 USB WLAN
  iSerial                 3 00e04c000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 001 Device 002: ID 046d:0808 Logitech, Inc. Webcam C600
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0808 Webcam C600
  bcdDevice            0.09
  iManufacturer           0
  iProduct                0
  iSerial                 2 78AA4F60
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         2561
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0
      iInterface              0
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength          217
        dwClockFrequency       48.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x0004080e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
          PanTilt (Absolute)
          Privacy
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier      16384
        bControlSize            2
        bmControls     0x0000175b
          Brightness
          Contrast
          Saturation
          Sharpness
          White Balance Temperature
          Backlight Compensation
          Gain
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0
        bmVideoStandards     0x1b
          None
          NTSC - 525/60
          SECAM - 625/50
          NTSC - 625/50
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d221e}
        bNumControl            10
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0xff
        bmControls( 1)       0x03
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                13
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d221f}
        bNumControl             7
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0x6f
        bmControls( 1)       0x01
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 8
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d2251}
        bNumControl             3
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            3
        bmControls( 0)       0x19
        bmControls( 1)       0x00
        bmControls( 2)       0x00
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                10
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d2252}
        bNumControl            24
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            3
        bmControls( 0)       0xff
        bmControls( 1)       0xff
        bmControls( 2)       0xff
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                14
        guidExtensionCode         {b7935ba4-15c7-0245-90f4-532a3b311365}
        bNumControl             4
        bNrPins                 1
        baSourceID( 0)          1
        bControlSize            3
        bmControls( 0)       0x0f
        bmControls( 1)       0x00
        bmControls( 2)       0x00
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                12
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d2250}
        bNumControl            17
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            3
        bmControls( 0)       0xfe
        bmControls( 1)       0x7f
        bmControls( 2)       0x70
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             5
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               4
        iTerminal               0
      ** UNRECOGNIZED:  20 41 01 0b 82 06 61 63 70 50 ab 49 b8 cc b3
85 5e 8d 22 55 01 01 04 03 01 00 00 00 00 00 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               8
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      VideoStreaming Interface Descriptor:
        bLength                            16
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         3
        wTotalLength                     1852
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       5
        bStillCaptureMethod                 2
        bTriggerSupport                     1
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
        bmaControls( 1)                    27
        bmaControls( 2)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors               18
        guidFormat
{59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  2027520
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 18432000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           400
        dwMinBitRate                 20480000
        dwMaxBitRate                122880000
        dwMaxVideoFrameBufferSize      512000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         8
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            768
        wHeight                           480
        dwMinBitRate                 29491200
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      737280
        dwDefaultFrameInterval         400000
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         9
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           456
        dwMinBitRate                 29184000
        dwMaxBitRate                145920000
        dwMaxVideoFrameBufferSize      729600
        dwDefaultFrameInterval         400000
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        10
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           504
        dwMinBitRate                 32256000
        dwMaxBitRate                161280000
        dwMaxVideoFrameBufferSize      806400
        dwDefaultFrameInterval         400000
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        11
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           600
        dwMinBitRate                 38400000
        dwMaxBitRate                192000000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         400000
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        12
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            864
        wHeight                           480
        dwMinBitRate                 33177600
        dwMaxBitRate                165888000
        dwMaxVideoFrameBufferSize      829440
        dwDefaultFrameInterval         400000
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        13
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            960
        wHeight                           720
        dwMinBitRate                 55296000
        dwMaxBitRate                165888000
        dwMaxVideoFrameBufferSize     1382400
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  3
        dwFrameInterval( 0)            666666
        dwFrameInterval( 1)           1000000
        dwFrameInterval( 2)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        14
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                 73728000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1333333
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        15
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           800
        dwMinBitRate                 81920000
        dwMaxBitRate                163840000
        dwMaxVideoFrameBufferSize     2048000
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1333333
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        16
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                           904
        dwMinBitRate                115712000
        dwMaxBitRate                115712000
        dwMaxVideoFrameBufferSize     2892800
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        17
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                          1000
        dwMinBitRate                128000000
        dwMaxBitRate                128000000
        dwMaxVideoFrameBufferSize     3200000
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        18
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                          1200
        dwMinBitRate                153600000
        dwMaxBitRate                153600000
        dwMaxVideoFrameBufferSize     3840000
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            79
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns              18
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        160
        wHeight( 1)                       120
        wWidth( 2)                        176
        wHeight( 2)                       144
        wWidth( 3)                        320
        wHeight( 3)                       240
        wWidth( 4)                        352
        wHeight( 4)                       288
        wWidth( 5)                        640
        wHeight( 5)                       360
        wWidth( 6)                        640
        wHeight( 6)                       400
        wWidth( 7)                        768
        wHeight( 7)                       480
        wWidth( 8)                        800
        wHeight( 8)                       456
        wWidth( 9)                        800
        wHeight( 9)                       504
        wWidth(10)                        800
        wHeight(10)                       600
        wWidth(11)                        864
        wHeight(11)                       480
        wWidth(12)                        960
        wHeight(12)                       720
        wWidth(13)                       1280
        wHeight(13)                       720
        wWidth(14)                       1280
        wHeight(14)                       800
        wWidth(15)                       1600
        wHeight(15)                       904
        wWidth(16)                       1600
        wHeight(16)                      1000
        wWidth(17)                       1600
        wHeight(17)                      1200
        bNumCompressionPatterns            18
        bCompression( 0)                    5
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        2
        bNumFrameDescriptors               18
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  2027520
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 18432000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           400
        dwMinBitRate                 20480000
        dwMaxBitRate                122880000
        dwMaxVideoFrameBufferSize      512000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         8
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            768
        wHeight                           480
        dwMinBitRate                 29491200
        dwMaxBitRate                176947200
        dwMaxVideoFrameBufferSize      737280
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         9
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           456
        dwMinBitRate                 29184000
        dwMaxBitRate                175104000
        dwMaxVideoFrameBufferSize      729600
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        10
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           504
        dwMinBitRate                 32256000
        dwMaxBitRate                193536000
        dwMaxVideoFrameBufferSize      806400
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        11
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           600
        dwMinBitRate                 38400000
        dwMaxBitRate                230400000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        12
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            864
        wHeight                           480
        dwMinBitRate                 33177600
        dwMaxBitRate                199065600
        dwMaxVideoFrameBufferSize      829440
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        13
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            960
        wHeight                           720
        dwMinBitRate                 55296000
        dwMaxBitRate                331776000
        dwMaxVideoFrameBufferSize     1382400
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        14
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                 73728000
        dwMaxBitRate                442368000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        15
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           800
        dwMinBitRate                 81920000
        dwMaxBitRate                409600000
        dwMaxVideoFrameBufferSize     2048000
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        16
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                           904
        dwMinBitRate                115712000
        dwMaxBitRate                231424000
        dwMaxVideoFrameBufferSize     2892800
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1000000
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        17
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                          1000
        dwMinBitRate                128000000
        dwMaxBitRate                256000000
        dwMaxVideoFrameBufferSize     3200000
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1000000
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        18
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                          1200
        dwMinBitRate                153600000
        dwMaxBitRate                307200000
        dwMaxVideoFrameBufferSize     3840000
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1000000
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            83
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns              18
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        160
        wHeight( 1)                       120
        wWidth( 2)                        176
        wHeight( 2)                       144
        wWidth( 3)                        320
        wHeight( 3)                       240
        wWidth( 4)                        352
        wHeight( 4)                       288
        wWidth( 5)                        640
        wHeight( 5)                       360
        wWidth( 6)                        640
        wHeight( 6)                       400
        wWidth( 7)                        768
        wHeight( 7)                       480
        wWidth( 8)                        800
        wHeight( 8)                       456
        wWidth( 9)                        800
        wHeight( 9)                       504
        wWidth(10)                        800
        wHeight(10)                       600
        wWidth(11)                        864
        wHeight(11)                       480
        wWidth(12)                        960
        wHeight(12)                       720
        wWidth(13)                       1280
        wHeight(13)                       720
        wWidth(14)                       1280
        wHeight(14)                       800
        wWidth(15)                       1600
        wHeight(15)                       904
        wWidth(16)                       1600
        wHeight(16)                      1000
        wWidth(17)                       1600
        wHeight(17)                      1200
        bNumCompressionPatterns            18
        bCompression( 0)                    5
        bCompression( 1)                   10
        bCompression( 2)                   15
        bCompression( 3)                   20
        bCompression( 4)                   25
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0180  1x 384 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0280  1x 640 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0320  1x 800 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       6
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x03b0  1x 944 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       7
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0a80  2x 640 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       8
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b20  2x 800 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       9
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0be0  2x 992 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      10
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1380  3x 896 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      11
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13fc  3x 1020 bytes
        bInterval               1
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       2 Streaming
      bFunctionProtocol       0
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0
      iInterface              0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           38
        bInCollection           1
        baInterfaceNr( 0)       3
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Microphone
        bAssocTerminal          0
        bNrChannels             1
        wChannelConfig     0x0000
        iChannelNames           0
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          1
        bSourceID               5
        iTerminal               0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 5
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute Control
          Volume Control
        bmaControls( 1)      0x00
        iFeature                0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        16000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0044  1x 68 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        24000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0064  1x 100 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        32000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0084  1x 132 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:12.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0503 highspeed power enable connect
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ohci_hcd
  iProduct                2 OHCI PCI host controller
  iSerial                 1 0000:00:12.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        2 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 003 Device 003: ID 046d:c040 Logitech, Inc. Corded Tilt-Wheel Mouse
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc040 Corded Tilt-Wheel Mouse
  bcdDevice           24.30
  iManufacturer           1 Logitech
  iProduct                2 USB-PS/2 Optical Mouse
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      59
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0005  1x 5 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 002: ID 046d:c313 Logitech, Inc. Internet 350 Keyboard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc313 Internet 350 Keyboard
  bcdDevice            1.01
  iManufacturer           1 LITEON Technology
  iProduct                2 USB Multimedia Keyboard
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               70mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              24
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      44
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.11
  iManufacturer           3 Linux 3.11.0-999-generic ohci_hcd
  iProduct                2 OHCI PCI host controller
  iSerial                 1 0000:00:12.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        2 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0303 lowspeed power enable connect
   Port 3: 0000.0303 lowspeed power enable connect
Device Status:     0x0001
  Self Powered
