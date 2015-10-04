Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36780 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbJDXYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 19:24:43 -0400
Received: by oibi136 with SMTP id i136so7524634oib.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 16:24:42 -0700 (PDT)
MIME-Version: 1.0
From: "Christopher M. Penalver" <christopher.m.penalver@gmail.com>
Date: Sun, 4 Oct 2015 18:24:03 -0500
Message-ID: <CAF4BKcCGw=ypaCAKKOBdnuQD6bwiZx15_0O-PA--HVv1GLruuQ@mail.gmail.com> (sfid-20151005_012521_304883_6069AEB3)
Subject: 10ec:8176 rtl8192ce 200-3200+ms latency on 802.11n 2.4GHz network
 with no load
To: Larry.Finger@lwfinger.net, wlanfae@realtek.com,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1.] One line summary of the problem:
10ec:8176 rtl8192ce 200-3200+ms latency on 802.11n 2.4GHz network with no load

[2.] Full description of the problem/report:
This is a follow up to
http://marc.info/?l=linux-wireless&m=143264578518617&w=2 . With an
Asus PCE-N10 PCI-E Adapter Wireless N card (10ec:8176 rtl8192ce) I
have 200-3200+ms latency on a 802.11n 2.4GHz network pinging just the
gateway 192.168.1.1, with no network load on either the router or the
WiFi chipset. The computer is ~4 feet away from a Verizon Jetpack MiFi
5510L with latest firmware installed (L1.34.23 M1.34.20) connected to
a power source, with no obstructions between them. Other clients (same
version of latest upstream kernel+Ubuntu with different chipset,
Windows) don't have this problem.

For example, transferring data over WiFi to a Windows 8.1 share, I
obtain ~150-250Kbps transfer rate. However, my other PCs consistently
transfer to it at 1.5 Mbps.

I've tested both latest mainline (4.3-rc3) and wireless-testing branch
as per https://wireless.wiki.kernel.org/en/developers/documentation/git-guide
and it's the same old story.

As I haven't heard anything yet in regards to my original mail, I'll
be creating a bug report on the kernel.org bugzilla.

[3.] N/A

[4.] cat /proc/version
Linux version 4.3.0-rc3-wl-custom (moniker@pc) (gcc version 4.9.2
(Ubuntu 4.9.2-10ubuntu13) ) #1 SMP Sun Oct 4 14:24:45 CDT 2015

[5.] N/A

[6.] N/A

[7.] Environment
lsb_release -rd
Description:    Ubuntu 15.04
Release:    15.04

[7.1] sh /usr/src/linux-headers-4.3.0-040300rc3/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux pc 4.3.0-rc3-wl-custom #1 SMP Sun Oct 4 14:24:45 CDT 2015 x86_64
x86_64 x86_64 GNU/Linux

Gnu C                  4.9.2
Gnu make               4.0
binutils               2.25
util-linux             2.25.2
mount                  debug
module-init-tools      18
e2fsprogs              1.42.12
pcmciautils            018
PPP                    2.4.6
Linux C Library        2.21
Dynamic linker (ldd)   2.21
Procps                 3.3.9
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.23
wireless-tools         30
Modules Loaded         drbg ansi_cprng ctr ccm usblp ath9k amdkfd
ath9k_common amd_iommu_v2 ath9k_hw arc4 radeon rtl8192ce i915
snd_hda_codec_realtek intel_rapl snd_hda_codec_generic rtl_pci
iosf_mbi rtl8192c_common snd_hda_intel rtlwifi ath snd_hda_codec
mac80211 x86_pkg_temp_thermal snd_hda_core joydev input_leds
intel_powerclamp snd_hwdep snd_pcm coretemp snd_seq_midi
snd_seq_midi_event video kvm_intel snd_rawmidi ttm drm_kms_helper
snd_seq cfg80211 kvm snd_seq_device drm snd_timer hp_wmi sparse_keymap
snd crct10dif_pclmul i2c_algo_bit crc32_pclmul soundcore fb_sys_fops
syscopyarea ghash_clmulni_intel sysfillrect aesni_intel sysimgblt
aes_x86_64 lrw serio_raw gf128mul glue_helper mei_me ablk_helper
shpchp mei cryptd 8250_fintek wmi lpc_ich mac_hid tpm_infineon
parport_pc ppdev lp parport autofs4 raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor hid_generic usbhid hid
uas usb_storage raid6_pq ahci raid1 r8169 psmouse libahci mii raid0
multipath linear fjes

[7.2] cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 1898.421
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 0
cpu cores    : 4
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 822.375
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 1
cpu cores    : 4
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 899.937
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 2
cpu cores    : 4
apicid        : 4
initial apicid    : 4
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 799.929
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 3
cpu cores    : 4
apicid        : 6
initial apicid    : 6
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 4
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 900.070
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 0
cpu cores    : 4
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 5
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 944.164
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 1
cpu cores    : 4
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 6
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 1897.226
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 2
cpu cores    : 4
apicid        : 5
initial apicid    : 5
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 7
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 1099.953
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 3
cpu cores    : 4
apicid        : 7
initial apicid    : 7
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow
vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2
erms invpcid rtm xsaveopt
bugs        :
bogomips    : 6784.39
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

[7.3] cat /proc/modules
drbg 32768 1 - Live 0x0000000000000000
ansi_cprng 16384 0 - Live 0x0000000000000000
ctr 16384 3 - Live 0x0000000000000000
ccm 20480 3 - Live 0x0000000000000000
usblp 20480 0 - Live 0x0000000000000000
ath9k 143360 0 - Live 0x0000000000000000
amdkfd 122880 1 - Live 0x0000000000000000
ath9k_common 36864 1 ath9k, Live 0x0000000000000000
amd_iommu_v2 20480 1 amdkfd, Live 0x0000000000000000
ath9k_hw 471040 2 ath9k,ath9k_common, Live 0x0000000000000000
arc4 16384 4 - Live 0x0000000000000000
radeon 1511424 1 - Live 0x0000000000000000
rtl8192ce 57344 0 - Live 0x0000000000000000
i915 1138688 2 - Live 0x0000000000000000
snd_hda_codec_realtek 81920 1 - Live 0x0000000000000000
intel_rapl 20480 0 - Live 0x0000000000000000
snd_hda_codec_generic 73728 1 snd_hda_codec_realtek, Live 0x0000000000000000
rtl_pci 28672 1 rtl8192ce, Live 0x0000000000000000
iosf_mbi 16384 1 intel_rapl, Live 0x0000000000000000
rtl8192c_common 49152 1 rtl8192ce, Live 0x0000000000000000
snd_hda_intel 36864 5 - Live 0x0000000000000000
rtlwifi 77824 3 rtl8192ce,rtl_pci,rtl8192c_common, Live 0x0000000000000000
ath 32768 3 ath9k,ath9k_common,ath9k_hw, Live 0x0000000000000000
snd_hda_codec 135168 3
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel, Live
0x0000000000000000
mac80211 724992 4 ath9k,rtl8192ce,rtl_pci,rtlwifi, Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
snd_hda_core 65536 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,
Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 102400 4 snd_hda_intel,snd_hda_codec,snd_hda_core, Live
0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
video 36864 1 i915, Live 0x0000000000000000
kvm_intel 163840 0 - Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
ttm 94208 1 radeon, Live 0x0000000000000000
drm_kms_helper 131072 2 radeon,i915, Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
cfg80211 544768 5 ath9k,ath9k_common,rtlwifi,ath,mac80211, Live
0x0000000000000000
kvm 512000 1 kvm_intel, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
drm 352256 7 radeon,i915,ttm,drm_kms_helper, Live 0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
hp_wmi 16384 0 - Live 0x0000000000000000
sparse_keymap 16384 1 hp_wmi, Live 0x0000000000000000
snd 86016 19 snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
i2c_algo_bit 16384 2 radeon,i915, Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
aesni_intel 167936 6 - Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
gf128mul 16384 1 lrw, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
mei_me 28672 0 - Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
shpchp 36864 0 - Live 0x0000000000000000
mei 102400 1 mei_me, Live 0x0000000000000000
cryptd 20480 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0x0000000000000000
8250_fintek 16384 0 - Live 0x0000000000000000
wmi 20480 1 hp_wmi, Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
tpm_infineon 20480 0 - Live 0x0000000000000000
parport_pc 36864 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 49152 3 parport_pc,ppdev,lp, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
raid10 45056 0 - Live 0x0000000000000000
raid456 94208 0 - Live 0x0000000000000000
async_raid6_recov 20480 1 raid456, Live 0x0000000000000000
async_memcpy 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_pq 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_xor 16384 3 raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
async_tx 16384 5
raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live
0x0000000000000000
xor 24576 1 async_xor, Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 49152 2 - Live 0x0000000000000000
hid 118784 2 hid_generic,usbhid, Live 0x0000000000000000
uas 24576 0 - Live 0x0000000000000000
usb_storage 69632 2 uas, Live 0x0000000000000000
raid6_pq 102400 3 raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
ahci 36864 4 - Live 0x0000000000000000
raid1 36864 1 - Live 0x0000000000000000
r8169 81920 0 - Live 0x0000000000000000
psmouse 126976 0 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
raid0 20480 0 - Live 0x0000000000000000
multipath 16384 0 - Live 0x0000000000000000
linear 16384 0 - Live 0x0000000000000000
fjes 28672 0 - Live 0x0000000000000000

[7.4] cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
    00f0-00f0 : PNP0C04:00
  03c0-03df : vesafb
  03f8-03ff : serial
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0420-042f : ACPI GPE0_BLK
  0430-0433 : iTCO_wdt.0.auto
  0450-0450 : ACPI PM2_CNT_BLK
  0460-047f : iTCO_wdt.0.auto
  04d0-04d1 : pnp 00:07
  0a10-0a1f : pnp 00:04
  0a20-0a3f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1810-1815 : ACPI CPU throttle
  1854-1857 : pnp 00:03
  2000-2fff : PCI Bus 0000:02
  c000-cfff : PCI Bus 0000:05
    c000-c0ff : 0000:05:00.0
      c000-c0ff : rtl_pci
  d000-dfff : PCI Bus 0000:03
    d000-d0ff : 0000:03:00.0
      d000-d0ff : r8169
  e000-efff : PCI Bus 0000:01
    e000-e0ff : 0000:01:00.0
  f000-f03f : 0000:00:02.0
  f040-f05f : 0000:00:1f.3
  f060-f07f : 0000:00:1f.2
    f060-f07f : ahci
  f080-f083 : 0000:00:1f.2
    f080-f083 : ahci
  f090-f097 : 0000:00:1f.2
    f090-f097 : ahci
  f0a0-f0a3 : 0000:00:1f.2
    f0a0-f0a3 : ahci
  f0b0-f0b7 : 0000:00:1f.2
    f0b0-f0b7 : ahci

cat /proc/iomem
00000000-00000fff : reserved
00001000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cebff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000e0000-000e3fff : PCI Bus 0000:00
  000e4000-000e7fff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-ba727fff : System RAM
  01000000-017b7e39 : Kernel code
  017b7e3a-01d4cdbf : Kernel data
  01ec4000-0200afff : Kernel bss
ba728000-ba72efff : ACPI Non-volatile Storage
ba72f000-bab6cfff : System RAM
bab6d000-baee2fff : reserved
baee3000-cb768fff : System RAM
cb769000-cb95efff : reserved
cb95f000-cb97cfff : ACPI Tables
cb97d000-cba58fff : ACPI Non-volatile Storage
cba59000-cbffefff : reserved
cbfff000-cbffffff : System RAM
cd000000-cf1fffff : reserved
  cd200000-cf1fffff : Graphics Stolen Memory
cf200000-feafffff : PCI Bus 0000:00
  cf200000-cf3fffff : PCI Bus 0000:02
  cf400000-cf5fffff : PCI Bus 0000:02
  d0000000-dfffffff : 0000:00:02.0
  e0000000-efffffff : PCI Bus 0000:01
    e0000000-efffffff : 0000:01:00.0
  f0000000-f00fffff : PCI Bus 0000:03
    f0000000-f0003fff : 0000:03:00.0
      f0000000-f0003fff : r8169
  f7400000-f77fffff : 0000:00:02.0
  f7800000-f78fffff : PCI Bus 0000:05
    f7800000-f7803fff : 0000:05:00.0
      f7800000-f7803fff : rtl_pci
  f7900000-f79fffff : PCI Bus 0000:04
    f7900000-f790ffff : 0000:04:00.0
      f7900000-f790ffff : ath9k
  f7a00000-f7afffff : PCI Bus 0000:03
    f7a00000-f7a00fff : 0000:03:00.0
      f7a00000-f7a00fff : r8169
  f7b00000-f7bfffff : PCI Bus 0000:01
    f7b00000-f7b1ffff : 0000:01:00.0
    f7b20000-f7b3ffff : 0000:01:00.0
  f7c00000-f7c0ffff : 0000:00:14.0
    f7c00000-f7c0ffff : xhci-hcd
  f7c10000-f7c13fff : 0000:00:1b.0
    f7c10000-f7c13fff : ICH HD audio
  f7c15000-f7c150ff : 0000:00:1f.3
  f7c16000-f7c167ff : 0000:00:1f.2
    f7c16000-f7c167ff : ahci
  f7c17000-f7c173ff : 0000:00:1d.0
    f7c17000-f7c173ff : ehci_hcd
  f7c18000-f7c183ff : 0000:00:1a.0
    f7c18000-f7c183ff : ehci_hcd
  f7c1a000-f7c1a00f : 0000:00:16.0
    f7c1a000-f7c1a00f : mei_me
  f7fdf000-f7fdffff : pnp 00:09
  f7fe0000-f7feffff : pnp 00:09
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:09
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
  fed00000-fed003ff : HPET 0
    fed00000-fed003ff : PNP0103:00
fed10000-fed17fff : pnp 00:09
fed18000-fed18fff : pnp 00:09
fed19000-fed19fff : pnp 00:09
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:09
    fed1f410-fed1f414 : iTCO_wdt.0.auto
fed20000-fed3ffff : pnp 00:09
fed40000-fed44fff : pnp 00:00
  fed40000-fed44fff : pnp 00:0a
fed45000-fed8ffff : pnp 00:09
fed90000-fed90fff : dmar0
fed91000-fed91fff : dmar1
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
  ff000000-ffffffff : INT0800:00
    ff000000-ffffffff : pnp 00:09
100000000-42fdfffff : System RAM
42fe00000-42fffffff : RAM buffer

[7.5] sudo lspci -k
00:00.0 Host bridge: Intel Corporation 4th Gen Core Processor DRAM
Controller (rev 06)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: hsw_uncore
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v3/4th Gen Core
Processor PCI Express x16 Controller (rev 06)
    Kernel driver in use: pcieport
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200
v3/4th Gen Core Processor Integrated Graphics Controller (rev 06)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: i915
00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB xHCI (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: xhci_hcd
00:16.0 Communication controller: Intel Corporation 8 Series/C220
Series Chipset Family MEI Controller #1 (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: mei_me
00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #2 (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: ehci-pci
00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset
High Definition Audio Controller (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: snd_hda_intel
00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #1 (rev d4)
    Kernel driver in use: pcieport
00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #3 (rev d4)
    Kernel driver in use: pcieport
00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #4 (rev d4)
    Kernel driver in use: pcieport
00:1c.5 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #6 (rev d4)
    Kernel driver in use: pcieport
00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #1 (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: ehci-pci
00:1f.0 ISA bridge: Intel Corporation C220 Series Chipset Family H81
Express LPC Controller (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: lpc_ich
00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series
Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: ahci
00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family
SMBus Controller (rev 04)
    Subsystem: Hewlett-Packard Company Device 198e
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Cedar [Radeon HD 7350/8350 / R5 220]
    Subsystem: Hewlett-Packard Company Device 2127
    Kernel driver in use: radeon
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
    Subsystem: Hewlett-Packard Company Device 198e
    Kernel driver in use: r8169
04:00.0 Network controller: Qualcomm Atheros AR9287 Wireless Network
Adapter (PCI-Express) (rev 01)
    Subsystem: Foxconn International, Inc. Device e034
    Kernel driver in use: ath9k
05:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
802.11b/g/n WiFi Adapter (rev 01)
    Subsystem: ASUSTeK Computer Inc. Device 84b5
    Kernel driver in use: rtl8192ce

[7.5] cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SanDisk SDSSDP12 Rev: 0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST1000DM003-1CH1 Rev: HP34
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD10EADS-11M Rev: 0A80
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: BUFFALO  Model: HD-PCFU3         Rev: 0
  Type:   Direct-Access                    ANSI  SCSI revision: 06

[7.7] ls /proc
1
10
100
1003
101
1012
102
103
104
105
1051
106
1064
1067
11
110
1110
1112
1127
1150
1158
1170
1171
1175
12
1223
123
124
1274
1298
13
1373
1379
14
1448
1449
1453
1455
15
1526
1537
1549
1596
16
1600
1602
1605
1612
1615
1617
1618
1624
1626
1634
1635
1637
1640
1657
1674
1684
1686
1699
17
1702
1707
174
1748
1750
1753
1760
1769
1774
1789
1790
1795
1796
1798
18
1803
1804
1845
1847
1876
188
189
190
191
192
193
194
1940
195
196
197
1978
198
1983
1989
199
2
20
2001
2016
2018
2062
2064
21
210
211
212
213
215
216
22
224
2247
227
228
229
23
230
231
232
2344
2350
237
238
239
2391
2401
2402
2421
2427
2429
2451
246
2495
25
2511
26
264
265
27
2716
28
2871
29
2908
2910
2935
2936
2947
2952
2953
2955
2957
2958
2960
297
3
30
31
3119
3160
3165
3171
3179
3193
32
320
3212
322
3221
3235
33
3322
3338
335
3402
3416
3460
349
3492
35
3557
3558
3559
3574
36
37
3721
3779
38
40
409
41
414
419
42
422
43
433
45
454
46
47
48
49
5
50
51
52
53
538
54
546
55
56
57
58
59
628
63
636
64
65
666
678
679
680
681
682
7
705
706
726
8
80
81
82
83
84
85
86
87
88
9
90
91
92
926
929
93
930
931
933
934
936
939
94
948
949
95
96
964
97
979
98
981
989
99
acpi
asound
buddyinfo
bus
cgroups
cmdline
consoles
cpuinfo
crypto
devices
diskstats
dma
driver
execdomains
fb
filesystems
fs
interrupts
iomem
ioports
irq
kallsyms
kcore
keys
key-users
kmsg
kpagecgroup
kpagecount
kpageflags
loadavg
locks
mdstat
meminfo
misc
modules
mounts
mtrr
net
pagetypeinfo
partitions
sched_debug
schedstat
scsi
self
slabinfo
softirqs
stat
swaps
sys
sysrq-trigger
sysvipc
thread-self
timer_list
timer_stats
tty
uptime
version
vmallocinfo
vmstat
zoneinfo

[X.] Other notes, patches, fixes, workarounds:
Downstream report  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1445840

dmesg:
[CUT]
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] e820: update [mem 0xcd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcc000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4dc0-0x000f4dcf]
mapped at [ffff8800000f4dc0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0200c000, 0x0200cfff] PGTABLE
[    0.000000] BRK [0x0200d000, 0x0200dfff] PGTABLE
[    0.000000] BRK [0x0200e000, 0x0200efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x42fc00000-0x42fdfffff]
[    0.000000]  [mem 0x42fc00000-0x42fdfffff] page 2M
[    0.000000] BRK [0x0200f000, 0x0200ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x420000000-0x42fbfffff]
[    0.000000]  [mem 0x420000000-0x42fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41fffffff]
[    0.000000]  [mem 0x400000000-0x41fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xba727fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xba5fffff] page 2M
[    0.000000]  [mem 0xba600000-0xba727fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xba72f000-0xbab6cfff]
[    0.000000]  [mem 0xba72f000-0xba7fffff] page 4k
[    0.000000]  [mem 0xba800000-0xba9fffff] page 2M
[    0.000000]  [mem 0xbaa00000-0xbab6cfff] page 4k
[    0.000000] BRK [0x02010000, 0x02010fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbaee3000-0xcb768fff]
[    0.000000]  [mem 0xbaee3000-0xbaffffff] page 4k
[    0.000000]  [mem 0xbb000000-0xcb5fffff] page 2M
[    0.000000]  [mem 0xcb600000-0xcb768fff] page 4k
[    0.000000] BRK [0x02011000, 0x02011fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xcbfff000-0xcbffffff]
[    0.000000]  [mem 0xcbfff000-0xcbffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x3581a000-0x36c04fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F9810 000024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 0x00000000CB965088 000094 (v01 HPQOEM
SLIC-BPC 20141211 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CB971E48 00010C (v05 HPQOEM
SLIC-BPC 20141211 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000CB9651B0 00CC97 (v02 HPQOEM
SLIC-BPC 00000001 INTL 20091112)
[    0.000000] ACPI: FACS 0x00000000CBA57080 000040
[    0.000000] ACPI: APIC 0x00000000CB971F58 000092 (v03 HPQOEM
SLIC-BPC 20141211 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000CB971FF0 000044 (v01 HPQOEM
SLIC-BPC 20141211 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000CB972038 000539 (v01 PmRef
Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000CB972578 000AD8 (v01 PmRef  CpuPm
  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000CB973050 0001C7 (v01 PmRef
LakeTiny 00003000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000CB973218 00003C (v01 HPQOEM
SLIC-BPC 20141211 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CB973258 000038 (v01 HPQOEM
SLIC-BPC 20141211 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000CB973290 00036D (v01 SataRe
SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000CB973600 002881 (v01 SaSsdt SaSsdt
  00003000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000CB975E88 00668F (v01 COMPAQ WMI
  00000001 MSFT 03000001)
[    0.000000] ACPI: SLIC 0x00000000CB97C518 000176 (v01 HPQOEM
SLIC-BPC 00000001      00000000)
[    0.000000] ACPI: MSDM 0x00000000CB97C690 000055 (v03 HPQOEM
SLIC-BPC 20141211 HPQ  00010013)
[    0.000000] ACPI: DMAR 0x00000000CB97C6E8 0000B8 (v01 INTEL  HSW
  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000042fdfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x42fdf6000-0x42fdfafff]
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD ->
[ffff88041f400000-ffff88042f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000042fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000ba727fff]
[    0.000000]   node   0: [mem 0x00000000ba72f000-0x00000000bab6cfff]
[    0.000000]   node   0: [mem 0x00000000baee3000-0x00000000cb768fff]
[    0.000000]   node   0: [mem 0x00000000cbfff000-0x00000000cbffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000042fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000042fdfffff]
[    0.000000] On node 0 totalpages: 4174217
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12944 pages used for memmap
[    0.000000]   DMA32 zone: 828397 pages, LIFO batch:31
[    0.000000]   Normal zone: 52216 pages used for memmap
[    0.000000]   Normal zone: 3341824 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xcd200000-0xcf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xba728000-0xba72efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbab6d000-0xbaee2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcb769000-0xcb95efff]
[    0.000000] PM: Registered nosave memory: [mem 0xcb95f000-0xcb97cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcb97d000-0xcba58fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcba59000-0xcbffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xcc000000-0xccffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcd000000-0xcf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xcf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 34 pages/cpu @ffff88042fa00000 s98328
r8192 d32744 u262144
[    0.000000] pcpu-alloc: s98328 r8192 d32744 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 4108972
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-4.3.0-rc3-wl-custom
root=UUID=90dc0a59-cdd8-4e40-9f8f-8c4836a31560 ro quiet splash
nomdmonddf nomdmonisw vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16330356K/16696868K available (7903K kernel
code, 1331K rwdata, 3896K rodata, 1464K init, 1308K bss, 366512K
reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     Build-time adjustment of leaf fanout to 64.
[    0.000000]     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3392.198 MHz processor
[    0.000020] Calibrating delay loop (skipped), value calculated
using timer frequency.. 6784.39 BogoMIPS (lpj=13568792)
[    0.000022] pid_max: default: 32768 minimum: 301
[    0.000026] ACPI: Core revision 20150818
[    0.008271] ACPI: 7 ACPI AML tables successfully acquired and loaded
[    0.008284] Security Framework initialized
[    0.008285] Yama: becoming mindful.
[    0.008290] AppArmor: AppArmor initialized
[    0.008950] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.011109] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.012023] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.012034] Mountpoint-cache hash table entries: 32768 (order: 6,
262144 bytes)
[    0.012206] Initializing cgroup subsys io
[    0.012209] Initializing cgroup subsys memory
[    0.012213] Initializing cgroup subsys devices
[    0.012215] Initializing cgroup subsys freezer
[    0.012216] Initializing cgroup subsys net_cls
[    0.012218] Initializing cgroup subsys perf_event
[    0.012219] Initializing cgroup subsys net_prio
[    0.012220] Initializing cgroup subsys hugetlb
[    0.012222] Initializing cgroup subsys pids
[    0.012239] CPU: Physical Processor ID: 0
[    0.012239] CPU: Processor Core ID: 0
[    0.012242] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.012243] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.012978] mce: CPU supports 9 MCE banks
[    0.012989] CPU0: Thermal monitoring enabled (TM1)
[    0.012997] process: using mwait in idle threads
[    0.012999] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.013000] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.013246] Freeing SMP alternatives memory: 28K (ffffffff81ebc000
- ffffffff81ec3000)
[    0.014566] ftrace: allocating 31164 entries in 122 pages
[    0.023507] DMAR: Host address width 39
[    0.023508] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.023514] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap
c0000020660462 ecap f0101a
[    0.023515] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.023519] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap
d2008020660462 ecap f010da
[    0.023519] DMAR: RMRR base: 0x000000cb8f5000 end: 0x000000cb901fff
[    0.023520] DMAR: RMRR base: 0x000000cd000000 end: 0x000000cf1fffff
[    0.023522] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.023522] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.023523] DMAR-IR: Queued invalidation will be enabled to support
x2apic and Intr-remapping.
[    0.023748] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.023749] x2apic enabled
[    0.023753] Switched APIC routing to cluster x2apic.
[    0.024162] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.063866] TSC deadline timer enabled
[    0.063868] smpboot: CPU0: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
(family: 0x6, model: 0x3c, stepping: 0x3)
[    0.063886] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell
events, full-width counters, Intel PMU driver.
[    0.063899] ... version:                3
[    0.063900] ... bit width:              48
[    0.063900] ... generic registers:      4
[    0.063901] ... value mask:             0000ffffffffffff
[    0.063902] ... max period:             0000ffffffffffff
[    0.063902] ... fixed-purpose events:   3
[    0.063903] ... event mask:             000000070000000f
[    0.064406] x86: Booting SMP configuration:
[    0.064407] .... node  #0, CPUs:      #1
[    0.067600] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.067651]  #2 #3 #4 #5 #6 #7
[    0.086581] x86: Booted up 1 node, 8 CPUs
[    0.086584] smpboot: Total of 8 processors activated (54275.16 BogoMIPS)
[    0.093246] devtmpfs: initialized
[    0.095243] evm: security.selinux
[    0.095244] evm: security.SMACK64
[    0.095245] evm: security.SMACK64EXEC
[    0.095245] evm: security.SMACK64TRANSMUTE
[    0.095246] evm: security.SMACK64MMAP
[    0.095246] evm: security.ima
[    0.095247] evm: security.capability
[    0.095293] PM: Registering ACPI NVS region [mem
0xba728000-0xba72efff] (28672 bytes)
[    0.095294] PM: Registering ACPI NVS region [mem
0xcb97d000-0xcba58fff] (901120 bytes)
[    0.095356] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.095413] pinctrl core: initialized pinctrl subsystem
[    0.095493] RTC time: 22:03:20, date: 10/04/15
[    0.095570] NET: Registered protocol family 16
[    0.105138] cpuidle: using governor ladder
[    0.121154] cpuidle: using governor menu
[    0.121157] PCCT header not found.
[    0.121227] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.121228] ACPI: bus type PCI registered
[    0.121229] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.121281] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.121283] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.121288] pmd_set_huge: Cannot satisfy [mem
0xf8000000-0xf8200000] with a huge-page mapping due to MTRR override.
[    0.121341] PCI: Using configuration type 1 for base access
[    0.121617] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked
around, HT is on
[    0.133427] ACPI: Added _OSI(Module Device)
[    0.133429] ACPI: Added _OSI(Processor Device)
[    0.133429] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.133430] ACPI: Added _OSI(Processor Aggregator Device)
[    0.135907] ACPI: Executed 1 blocks of module-level executable AML code
[    0.137749] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.138248] ACPI: Dynamic OEM Table Load:
[    0.138253] ACPI: SSDT 0xFFFF88041CE54000 0003D3 (v01 PmRef
Cpu0Cst  00003001 INTL 20120711)
[    0.138677] ACPI: Dynamic OEM Table Load:
[    0.138681] ACPI: SSDT 0xFFFF88041CE5A000 0005AA (v01 PmRef  ApIst
  00003000 INTL 20120711)
[    0.139129] ACPI: Dynamic OEM Table Load:
[    0.139132] ACPI: SSDT 0xFFFF88041CE4D600 000119 (v01 PmRef  ApCst
  00003000 INTL 20120711)
[    0.140664] ACPI: Interpreter enabled
[    0.140670] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20150818/hwxface-580)
[    0.140674] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20150818/hwxface-580)
[    0.140687] ACPI: (supports S0 S3 S4 S5)
[    0.140688] ACPI: Using IOAPIC for interrupt routing
[    0.140706] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.146479] ACPI: Power Resource [FN00] (off)
[    0.146534] ACPI: Power Resource [FN01] (off)
[    0.147102] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.147105] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.461064] acpi PNP0A08:00: _OSC: platform does not support
[PCIeHotplug PME]
[    0.461145] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.461146] acpi PNP0A08:00: FADT indicates ASPM is unsupported,
using BIOS configuration
[    0.461388] PCI host bridge to bus 0000:00
[    0.461390] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.461391] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.461392] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.461393] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff window]
[    0.461394] pci_bus 0000:00: root bus resource [mem
0x000d0000-0x000d3fff window]
[    0.461395] pci_bus 0000:00: root bus resource [mem
0x000d4000-0x000d7fff window]
[    0.461396] pci_bus 0000:00: root bus resource [mem
0x000d8000-0x000dbfff window]
[    0.461397] pci_bus 0000:00: root bus resource [mem
0x000dc000-0x000dffff window]
[    0.461398] pci_bus 0000:00: root bus resource [mem
0x000e0000-0x000e3fff window]
[    0.461399] pci_bus 0000:00: root bus resource [mem
0x000e4000-0x000e7fff window]
[    0.461400] pci_bus 0000:00: root bus resource [mem
0xcf200000-0xfeafffff window]
[    0.461404] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.461462] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.461484] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.461538] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.461565] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    0.461575] pci 0000:00:02.0: reg 0x10: [mem 0xf7400000-0xf77fffff 64bit]
[    0.461579] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.461582] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.461647] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.461668] pci 0000:00:14.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff 64bit]
[    0.461709] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.461735] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.461761] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.461783] pci 0000:00:16.0: reg 0x10: [mem 0xf7c1a000-0xf7c1a00f 64bit]
[    0.461826] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.461882] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.461906] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c18000-0xf7c183ff]
[    0.461964] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.461999] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.462026] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.462047] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c10000-0xf7c13fff 64bit]
[    0.462093] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.462121] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.462146] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.462195] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.462242] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.462267] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.462317] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.462362] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.462386] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    0.462435] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.462481] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.462508] pci 0000:00:1c.5: [8086:8c1a] type 01 class 0x060400
[    0.462557] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.462603] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.462630] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.462654] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c17000-0xf7c173ff]
[    0.462713] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.462748] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.462775] pci 0000:00:1f.0: [8086:8c5c] type 00 class 0x060100
[    0.462903] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.462921] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.462927] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.462934] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.462940] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.462946] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.462952] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c16000-0xf7c167ff]
[    0.462972] pci 0000:00:1f.2: PME# supported from D3hot
[    0.463018] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.463032] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c15000-0xf7c150ff 64bit]
[    0.463049] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.463134] pci 0000:01:00.0: [1002:68fa] type 00 class 0x030000
[    0.463156] pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xefffffff
64bit pref]
[    0.463164] pci 0000:01:00.0: reg 0x18: [mem 0xf7b20000-0xf7b3ffff 64bit]
[    0.463169] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.463178] pci 0000:01:00.0: reg 0x30: [mem 0xf7b00000-0xf7b1ffff pref]
[    0.463198] pci 0000:01:00.0: supports D1 D2
[    0.463210] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.469075] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.469077] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.469078] pci 0000:00:01.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.469081] pci 0000:00:01.0:   bridge window [mem
0xe0000000-0xefffffff 64bit pref]
[    0.469128] acpiphp: Slot [1] registered
[    0.469133] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.469194] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.469231] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.469257] pci 0000:03:00.0: reg 0x18: [mem 0xf7a00000-0xf7a00fff 64bit]
[    0.469273] pci 0000:03:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff
64bit pref]
[    0.469330] pci 0000:03:00.0: supports D1 D2
[    0.469331] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.469359] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.477085] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.477088] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.477091] pci 0000:00:1c.2:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.477096] pci 0000:00:1c.2:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.477166] pci 0000:04:00.0: [168c:002e] type 00 class 0x028000
[    0.477229] pci 0000:04:00.0: reg 0x10: [mem 0xf7900000-0xf790ffff 64bit]
[    0.477385] pci 0000:04:00.0: supports D1
[    0.477385] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.477426] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.485099] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.485103] pci 0000:00:1c.3:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.485177] pci 0000:05:00.0: [10ec:8176] type 00 class 0x028000
[    0.485235] pci 0000:05:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.485281] pci 0000:05:00.0: reg 0x18: [mem 0xf7800000-0xf7803fff 64bit]
[    0.485410] pci 0000:05:00.0: supports D1 D2
[    0.485411] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.485450] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.493109] pci 0000:00:1c.5: PCI bridge to [bus 05]
[    0.493112] pci 0000:00:1c.5:   bridge window [io  0xc000-0xcfff]
[    0.493115] pci 0000:00:1c.5:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.493714] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.493746] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.493776] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.493806] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.493835] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    0.493865] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    0.493894] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.493924] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.494088] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.494150] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.494152] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.494155] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.494156] vgaarb: loaded
[    0.494157] vgaarb: bridge control possible 0000:01:00.0
[    0.494157] vgaarb: no bridge control possible 0000:00:02.0
[    0.494293] SCSI subsystem initialized
[    0.494315] libata version 3.00 loaded.
[    0.494330] ACPI: bus type USB registered
[    0.494339] usbcore: registered new interface driver usbfs
[    0.494344] usbcore: registered new interface driver hub
[    0.494357] usbcore: registered new device driver usb
[    0.494449] PCI: Using ACPI for IRQ routing
[    0.495610] PCI: pci_cache_line_size set to 64 bytes
[    0.495660] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.495661] e820: reserve RAM buffer [mem 0xba728000-0xbbffffff]
[    0.495662] e820: reserve RAM buffer [mem 0xbab6d000-0xbbffffff]
[    0.495663] e820: reserve RAM buffer [mem 0xcb769000-0xcbffffff]
[    0.495664] e820: reserve RAM buffer [mem 0x42fe00000-0x42fffffff]
[    0.495734] NetLabel: Initializing
[    0.495734] NetLabel:  domain hash size = 128
[    0.495735] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.495742] NetLabel:  unlabeled traffic allowed by default
[    0.495786] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.495789] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.497811] clocksource: Switched to clocksource hpet
[    0.501589] AppArmor: AppArmor Filesystem Enabled
[    0.501626] pnp: PnP ACPI init
[    0.501674] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.501676] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.501728] pnp 00:01: can't evaluate _CRS: 12311
[    0.501746] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.501760] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.501789] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.501791] system 00:03: Plug and Play ACPI device, IDs INT3f0d
PNP0c02 (active)
[    0.501881] system 00:04: [io  0x0a20-0x0a3f] has been reserved
[    0.501882] system 00:04: [io  0x0a10-0x0a1f] has been reserved
[    0.501884] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.501904] pnp 00:05: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    0.501931] pnp 00:06: Plug and Play ACPI device, IDs PNP0f03
PNP0f13 (active)
[    0.501960] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.501962] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.502067] pnp 00:08: [dma 0 disabled]
[    0.502115] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.502489] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.502491] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.502492] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.502494] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.502495] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.502496] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.502498] system 00:09: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.502499] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.502500] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.502501] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.502503] system 00:09: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    0.502504] system 00:09: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.502506] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.502692] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.502694] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.502696] pnp: PnP ACPI: found 11 devices
[    0.508347] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[    0.508361] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to
[bus 02] add_size 1000
[    0.508363] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
add_align 100000
[    0.508365] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff] to [bus 02] add_size 200000 add_align 100000
[    0.508382] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff]
res_to_dev_res add_size 200000 min_align 100000
[    0.508384] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x002fffff]
res_to_dev_res add_size 200000 min_align 100000
[    0.508385] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.508386] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.508387] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff]
res_to_dev_res add_size 1000 min_align 1000
[    0.508388] pci 0000:00:1c.0: res[13]=[io  0x1000-0x1fff]
res_to_dev_res add_size 1000 min_align 1000
[    0.508391] pci 0000:00:1c.0: BAR 14: assigned [mem 0xcf200000-0xcf3fffff]
[    0.508395] pci 0000:00:1c.0: BAR 15: assigned [mem
0xcf400000-0xcf5fffff 64bit pref]
[    0.508397] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.508398] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.508399] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.508402] pci 0000:00:01.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.508403] pci 0000:00:01.0:   bridge window [mem
0xe0000000-0xefffffff 64bit pref]
[    0.508406] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.508407] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.508411] pci 0000:00:1c.0:   bridge window [mem 0xcf200000-0xcf3fffff]
[    0.508414] pci 0000:00:1c.0:   bridge window [mem
0xcf400000-0xcf5fffff 64bit pref]
[    0.508419] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.508421] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.508425] pci 0000:00:1c.2:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.508428] pci 0000:00:1c.2:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.508432] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.508436] pci 0000:00:1c.3:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.508442] pci 0000:00:1c.5: PCI bridge to [bus 05]
[    0.508444] pci 0000:00:1c.5:   bridge window [io  0xc000-0xcfff]
[    0.508448] pci 0000:00:1c.5:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.508454] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.508455] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.508456] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.508457] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff window]
[    0.508458] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff window]
[    0.508459] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff window]
[    0.508460] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff window]
[    0.508461] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff window]
[    0.508462] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff window]
[    0.508463] pci_bus 0000:00: resource 13 [mem 0xcf200000-0xfeafffff window]
[    0.508464] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.508464] pci_bus 0000:01: resource 1 [mem 0xf7b00000-0xf7bfffff]
[    0.508465] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff
64bit pref]
[    0.508466] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.508467] pci_bus 0000:02: resource 1 [mem 0xcf200000-0xcf3fffff]
[    0.508468] pci_bus 0000:02: resource 2 [mem 0xcf400000-0xcf5fffff
64bit pref]
[    0.508469] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.508470] pci_bus 0000:03: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.508471] pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf00fffff
64bit pref]
[    0.508472] pci_bus 0000:04: resource 1 [mem 0xf7900000-0xf79fffff]
[    0.508473] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.508474] pci_bus 0000:05: resource 1 [mem 0xf7800000-0xf78fffff]
[    0.508494] NET: Registered protocol family 2
[    0.508619] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.508757] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.508858] TCP: Hash tables configured (established 131072 bind 65536)
[    0.508880] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.508915] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.508965] NET: Registered protocol family 1
[    0.508975] pci 0000:00:02.0: Video device with shadowed ROM
[    0.545881] PCI: CLS 64 bytes, default 64
[    0.545915] Trying to unpack rootfs image as initramfs...
[    0.762593] Freeing initrd memory: 20396K (ffff88003581a000 -
ffff880036c05000)
[    0.762622] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.762624] software IO TLB [mem 0xc7769000-0xcb769000] (64MB)
mapped at [ffff8800c7769000-ffff8800cb768fff]
[    0.762682] RAPL PMU detected, API unit is 2^-32 Joules, 4 fixed
counters 655360 ms ovfl timer
[    0.762683] hw unit of domain pp0-core 2^-14 Joules
[    0.762683] hw unit of domain package 2^-14 Joules
[    0.762684] hw unit of domain dram 2^-14 Joules
[    0.762684] hw unit of domain pp1-gpu 2^-14 Joules
[    0.762788] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762794] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762800] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762805] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762811] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762818] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762823] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762828] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x1a
[    0.762862] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.762887] Scanning for low memory corruption every 60 seconds
[    0.763114] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.763142] audit: initializing netlink subsys (disabled)
[    0.763153] audit: type=2000 audit(1443996200.448:1): initialized
[    0.763393] Initialise system trusted keyring
[    0.763445] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.763446] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.764387] zbud: loaded
[    0.764509] VFS: Disk quotas dquot_6.6.0
[    0.764529] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.764821] fuse init (API version 7.23)
[    0.764914] Key type big_key registered
[    0.765215] Key type asymmetric registered
[    0.765217] Asymmetric key parser 'x509' registered
[    0.765244] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 249)
[    0.765273] io scheduler noop registered
[    0.765275] io scheduler deadline registered (default)
[    0.765293] io scheduler cfq registered
[    0.765748] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.765753] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.765772] vesafb: mode is 1920x1080x32, linelength=7680, pages=0
[    0.765772] vesafb: scrolling: redraw
[    0.765773] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.765786] vesafb: framebuffer at 0xd0000000, mapped to
0xffffc90002000000, using 8128k, total 8128k
[    0.890871] Console: switching to colour frame buffer device 240x67
[    1.015403] fb0: VESA VGA frame buffer device
[    1.015415] intel_idle: MWAIT substates: 0x42120
[    1.015416] intel_idle: v0.4 model 0x3C
[    1.015417] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.015655] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.015658] ACPI: Power Button [PWRB]
[    1.015680] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.015682] ACPI: Power Button [PWRF]
[    1.016013] ACPI: Invalid active2 threshold
[    1.016098] thermal LNXTHERM:00: registered as thermal_zone0
[    1.016099] ACPI: Thermal Zone [TZ00] (28 C)
[    1.016212] thermal LNXTHERM:01: registered as thermal_zone1
[    1.016213] ACPI: Thermal Zone [TZ01] (30 C)
[    1.016239] GHES: HEST is not enabled!
[    1.016300] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.036675] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
is a 16550A
[    1.037706] Linux agpgart interface v0.103
[    1.039782] brd: module loaded
[    1.040628] loop: module loaded
[    1.040793] libphy: Fixed MDIO Bus: probed
[    1.040795] tun: Universal TUN/TAP device driver, 1.6
[    1.040795] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.040821] PPP generic driver version 2.4.2
[    1.040922] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.040926] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1
[    1.041001] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci
version 0x100 quirks 0x00009810
[    1.041007] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.041098] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.041099] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.041100] usb usb1: Product: xHCI Host Controller
[    1.041101] usb usb1: Manufacturer: Linux 4.3.0-rc3-wl-custom xhci-hcd
[    1.041101] usb usb1: SerialNumber: 0000:00:14.0
[    1.041168] hub 1-0:1.0: USB hub found
[    1.041178] hub 1-0:1.0: 10 ports detected
[    1.042334] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.042336] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 2
[    1.042356] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.042357] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.042358] usb usb2: Product: xHCI Host Controller
[    1.042359] usb usb2: Manufacturer: Linux 4.3.0-rc3-wl-custom xhci-hcd
[    1.042360] usb usb2: SerialNumber: 0000:00:14.0
[    1.042428] hub 2-0:1.0: USB hub found
[    1.042433] hub 2-0:1.0: 2 ports detected
[    1.042683] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.042686] ehci-pci: EHCI PCI platform driver
[    1.042741] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.042744] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    1.042752] ehci-pci 0000:00:1a.0: debug port 2
[    1.046660] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.046670] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c18000
[    1.062127] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.062161] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.062162] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.062163] usb usb3: Product: EHCI Host Controller
[    1.062164] usb usb3: Manufacturer: Linux 4.3.0-rc3-wl-custom ehci_hcd
[    1.062165] usb usb3: SerialNumber: 0000:00:1a.0
[    1.062335] hub 3-0:1.0: USB hub found
[    1.062339] hub 3-0:1.0: 2 ports detected
[    1.062520] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.062524] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 4
[    1.062533] ehci-pci 0000:00:1d.0: debug port 2
[    1.066442] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.066454] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c17000
[    1.078116] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.078157] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    1.078158] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.078159] usb usb4: Product: EHCI Host Controller
[    1.078160] usb usb4: Manufacturer: Linux 4.3.0-rc3-wl-custom ehci_hcd
[    1.078161] usb usb4: SerialNumber: 0000:00:1d.0
[    1.078337] hub 4-0:1.0: USB hub found
[    1.078341] hub 4-0:1.0: 2 ports detected
[    1.078440] ehci-platform: EHCI generic platform driver
[    1.078451] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.078455] ohci-pci: OHCI PCI platform driver
[    1.078464] ohci-platform: OHCI generic platform driver
[    1.078469] uhci_hcd: USB Universal Host Controller Interface driver
[    1.078510] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    1.081231] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.081235] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.081468] mousedev: PS/2 mouse device common for all mice
[    1.081717] rtc_cmos 00:02: RTC can wake from S4
[    1.081833] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.081857] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes
nvram, hpet irqs
[    1.081863] i2c /dev entries driver
[    1.081901] device-mapper: uevent: version 1.0.3
[    1.081945] device-mapper: ioctl: 4.33.0-ioctl (2015-8-18)
initialised: dm-devel@redhat.com
[    1.081958] Intel P-state driver initializing.
[    1.082175] ledtrig-cpu: registered to indicate activity on CPUs
[    1.083193] NET: Registered protocol family 10
[    1.083716] NET: Registered protocol family 17
[    1.083753] Key type dns_resolver registered
[    1.085005] registered taskstats version 1
[    1.085045] Loading compiled-in X.509 certificates
[    1.086409] Loaded X.509 cert 'Build time autogenerated kernel key:
7884c455f9a5542a44556ca091b48a967f049891'
[    1.086426] zswap: loaded using pool lzo/zbud
[    1.087672] Key type trusted registered
[    1.090586] Key type encrypted registered
[    1.090590] AppArmor: AppArmor sha1 policy hashing enabled
[    1.090592] ima: No TPM chip found, activating TPM-bypass!
[    1.090603] evm: HMAC attrs: 0x1
[    1.091099]   Magic number: 3:173:97
[    1.091205] rtc_cmos 00:02: setting system clock to 2015-10-04
22:03:21 UTC (1443996201)
[    1.091267] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.091268] EDD information not available.
[    1.091321] PM: Hibernation image not present or could not be loaded.
[    1.091569] Freeing unused kernel memory: 1464K (ffffffff81d4e000 -
ffffffff81ebc000)
[    1.091570] Write protecting the kernel read-only data: 12288k
[    1.091733] Freeing unused kernel memory: 276K (ffff8800017bb000 -
ffff880001800000)
[    1.091798] Freeing unused kernel memory: 200K (ffff880001bce000 -
ffff880001c00000)
[    1.098279] random: systemd-udevd urandom read with 3 bits of
entropy available
[    1.105114] FUJITSU Extended Socket Network Device Driver - version
1.0 - Copyright (c) 2015 FUJITSU LIMITED
[    1.107331] md: linear personality registered for level -1
[    1.109016] md: multipath personality registered for level -4
[    1.110624] md: raid0 personality registered for level 0
[    1.112858] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.112866] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    1.113051] md: raid1 personality registered for level 1
[    1.113121] ahci 0000:00:1f.2: version 3.0
[    1.113225] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6
Gbps 0x23 impl SATA mode
[    1.113227] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems
[    1.119199] r8169 0000:03:00.0 eth0: RTL8168g/8111g at
0xffffc900018c8000, 9c:b6:54:f5:c4:66, XID 0c000800 IRQ 29
[    1.119201] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    1.126612] scsi host0: ahci
[    1.126687] scsi host1: ahci
[    1.126748] scsi host2: ahci
[    1.126817] scsi host3: ahci
[    1.126879] scsi host4: ahci
[    1.126953] scsi host5: ahci
[    1.126981] ata1: SATA max UDMA/133 abar m2048@0xf7c16000 port
0xf7c16100 irq 28
[    1.126983] ata2: SATA max UDMA/133 abar m2048@0xf7c16000 port
0xf7c16180 irq 28
[    1.126984] ata3: DUMMY
[    1.126985] ata4: DUMMY
[    1.126985] ata5: DUMMY
[    1.126987] ata6: SATA max UDMA/133 abar m2048@0xf7c16000 port
0xf7c16380 irq 28
[    1.182144] raid6: sse2x1   gen() 11795 MB/s
[    1.250163] raid6: sse2x1   xor()  9568 MB/s
[    1.318194] raid6: sse2x2   gen() 15317 MB/s
[    1.354219] usb 1-1: new low-speed USB device number 2 using xhci_hcd
[    1.358275] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    1.374224] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    1.374723] usb 2-1: New USB device found, idVendor=0411, idProduct=0243
[    1.374725] usb 2-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[    1.374726] usb 2-1: Product: HD-PCFU3
[    1.374726] usb 2-1: Manufacturer: BUFFALO
[    1.374727] usb 2-1: SerialNumber: 03200000D779
[    1.377077] usb-storage 2-1:1.0: USB Mass Storage device detected
[    1.377213] scsi host6: usb-storage 2-1:1.0
[    1.377481] usbcore: registered new interface driver usb-storage
[    1.378315] usbcore: registered new interface driver uas
[    1.386200] raid6: sse2x2   xor() 10346 MB/s
[    1.390207] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    1.442270] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.442745] ata1.00: ATA-9: SanDisk SDSSDP128G, 3.2.0, max UDMA/133
[    1.442747] ata1.00: 246162672 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.444074] ata1.00: configured for UDMA/133
[    1.444353] scsi 0:0:0:0: Direct-Access     ATA      SanDisk
SDSSDP12 0    PQ: 0 ANSI: 5
[    1.444573] sd 0:0:0:0: [sda] 246162672 512-byte logical blocks:
(126 GB/117 GiB)
[    1.444609] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.444611] sd 0:0:0:0: [sda] Write Protect is off
[    1.444613] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.444631] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.445508]  sda: sda1 sda2 < sda5 >
[    1.445720] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.446257] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.446749] ata2.00: ATA-9: ST1000DM003-1CH162, HP34, max UDMA/100
[    1.446751] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.447239] ata2.00: configured for UDMA/100
[    1.447433] scsi 1:0:0:0: Direct-Access     ATA
ST1000DM003-1CH1 HP34 PQ: 0 ANSI: 5
[    1.447643] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    1.447645] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.447656] sd 1:0:0:0: [sdb] Write Protect is off
[    1.447658] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.447660] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.447663] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.450276] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.452017] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.452019] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.452021] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.454250] raid6: sse2x4   gen() 17516 MB/s
[    1.454349] ata6.00: ATA-8: WDC WD10EADS-11M2B2, 80.00A80, max UDMA/133
[    1.454350] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.456145] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.456147] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.456149] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.457886] ata6.00: configured for UDMA/133
[    1.458004] scsi 5:0:0:0: Direct-Access     ATA      WDC
WD10EADS-11M 0A80 PQ: 0 ANSI: 5
[    1.458114] sd 5:0:0:0: [sdc] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    1.458117] sd 5:0:0:0: [sdc] 4096-byte physical blocks
[    1.458127] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    1.458173] sd 5:0:0:0: [sdc] Write Protect is off
[    1.458175] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.458192] sd 5:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.464637]  sdb: sdb1
[    1.464715] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.474992]  sdc: sdc1
[    1.475448] sd 5:0:0:0: [sdc] Attached SCSI disk
[    1.506652] usb 3-1: New USB device found, idVendor=8087, idProduct=8008
[    1.506654] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.506806] hub 3-1:1.0: USB hub found
[    1.506900] hub 3-1:1.0: 4 ports detected
[    1.522270] raid6: sse2x4   xor() 12091 MB/s
[    1.522670] usb 4-1: New USB device found, idVendor=8087, idProduct=8000
[    1.522671] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.522959] hub 4-1:1.0: USB hub found
[    1.523045] hub 4-1:1.0: 6 ports detected
[    1.538236] md: bind<sdb1>
[    1.543133] usb 1-1: New USB device found, idVendor=03f0, idProduct=064a
[    1.543134] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.543135] usb 1-1: Product: HP USB Keyboard
[    1.543136] usb 1-1: Manufacturer: Primax
[    1.543253] usb 1-1: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    1.543255] usb 1-1: ep 0x82 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    1.545464] hidraw: raw HID events driver (C) Jiri Kosina
[    1.550179] usbcore: registered new interface driver usbhid
[    1.550181] usbhid: USB HID core driver
[    1.551109] input: Primax HP USB Keyboard as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/0003:03F0:064A.0001/input/input5
[    1.590312] raid6: avx2x1   gen() 23242 MB/s
[    1.600314] md: bind<sdc1>
[    1.601772] md/raid1:md0: active with 2 out of 2 mirrors
[    1.601871] created bitmap (8 pages) for device md0
[    1.602049] md0: bitmap initialized from disk: read 1 pages, set 0
of 14903 bits
[    1.606489] hid-generic 0003:03F0:064A.0001: input,hidraw0: USB HID
v1.10 Keyboard [Primax HP USB Keyboard] on usb-0000:00:14.0-1/input0
[    1.607290] input: Primax HP USB Keyboard as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.1/0003:03F0:064A.0002/input/input6
[    1.645695] md0: detected capacity change from 0 to 1000068874240
[    1.654488]  md0: p1
[    1.658340] raid6: avx2x2   gen() 26847 MB/s
[    1.666432] hid-generic 0003:03F0:064A.0002: input,hidraw1: USB HID
v1.10 Device [Primax HP USB Keyboard] on usb-0000:00:14.0-1/input1
[    1.710375] usb 1-2: new low-speed USB device number 3 using xhci_hcd
[    1.726355] raid6: avx2x4   gen() 31479 MB/s
[    1.726356] raid6: using algorithm avx2x4 gen() 31479 MB/s
[    1.726357] raid6: using avx2x2 recovery algorithm
[    1.727127] xor: automatically using best checksumming function:
[    1.762414] tsc: Refined TSC clocksource calibration: 3392.145 MHz
[    1.762425] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x30e55212bb0, max_idle_ns: 440795241820 ns
[    1.766390]    avx       : 38023.000 MB/sec
[    1.767156] async_tx: api initialized (async)
[    1.771318] md: raid6 personality registered for level 6
[    1.771319] md: raid5 personality registered for level 5
[    1.771320] md: raid4 personality registered for level 4
[    1.774682] md: raid10 personality registered for level 10
[    1.783959] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    1.841863] usb 1-2: New USB device found, idVendor=046d, idProduct=c077
[    1.841865] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.841867] usb 1-2: Product: USB Optical Mouse
[    1.841868] usb 1-2: Manufacturer: Logitech
[    1.841936] usb 1-2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    1.843649] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:046D:C077.0003/input/input7
[    1.843812] hid-generic 0003:046D:C077.0003: input,hidraw2: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:14.0-2/input0
[    1.950467] systemd[1]: Inserted module 'autofs4'
[    1.970959] systemd[1]: systemd 219 running in system mode. (+PAM
+AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP
+GCRYPT -GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[    1.971086] systemd[1]: Detected architecture x86-64.
[    1.971446] systemd[1]: Set hostname to <pc>.
[    2.010480] usb 1-3: new full-speed USB device number 4 using xhci_hcd
[    2.094045] systemd[1]: Set up automount Arbitrary Executable File
Formats File System Automount Point.
[    2.094053] systemd[1]: Starting Arbitrary Executable File Formats
File System Automount Point.
[    2.094076] systemd[1]: Created slice Root Slice.
[    2.094081] systemd[1]: Starting Root Slice.
[    2.094138] systemd[1]: Created slice System Slice.
[    2.094148] systemd[1]: Starting System Slice.
[    2.094202] systemd[1]: Created slice system-getty.slice.
[    2.094207] systemd[1]: Starting system-getty.slice.
[    2.094240] systemd[1]: Listening on Journal Socket.
[    2.094249] systemd[1]: Starting Journal Socket.
[    2.095823] systemd[1]: Starting Load Kernel Modules...
[    2.096159] systemd[1]: Started Read required files in advance.
[    2.096268] systemd[1]: Starting Read required files in advance...
[    2.097554] systemd[1]: Started Set Up Additional Binary Formats.
[    2.097849] systemd[1]: Starting Nameserver information manager...
[    2.098173] systemd[1]: Starting Uncomplicated firewall...
[    2.098547] systemd[1]: Starting Setup Virtual Console...
[    2.098597] systemd[1]: Listening on udev Kernel Socket.
[    2.098617] systemd[1]: Starting udev Kernel Socket.
[    2.098638] systemd[1]: Listening on Delayed Shutdown Socket.
[    2.098645] systemd[1]: Starting Delayed Shutdown Socket.
[    2.098666] systemd[1]: Listening on udev Control Socket.
[    2.098671] systemd[1]: Starting udev Control Socket.
[    2.098728] systemd[1]: Created slice User and Session Slice.
[    2.098734] systemd[1]: Starting User and Session Slice.
[    2.098746] systemd[1]: Reached target Slices.
[    2.098751] systemd[1]: Starting Slices.
[    2.099054] systemd[1]: Starting Increase datagram queue length...
[    2.099098] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[    2.099106] systemd[1]: Starting Forward Password Requests to Wall
Directory Watch.
[    2.099477] systemd[1]: Starting Create list of required static
device nodes for the current kernel...
[    2.099512] systemd[1]: Listening on Journal Socket (/dev/log).
[    2.099521] systemd[1]: Starting Journal Socket (/dev/log).
[    2.099867] systemd[1]: Starting udev Coldplug all Devices...
[    2.100221] systemd[1]: Mounting Huge Pages File System...
[    2.100283] systemd[1]: Listening on Journal Audit Socket.
[    2.100292] systemd[1]: Starting Journal Audit Socket.
[    2.100307] systemd[1]: Reached target Remote File Systems (Pre).
[    2.100314] systemd[1]: Starting Remote File Systems (Pre).
[    2.101821] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    2.101826] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    2.101846] systemd[1]: Listening on fsck to fsckd communication Socket.
[    2.101850] systemd[1]: Starting fsck to fsckd communication Socket.
[    2.102107] systemd[1]: Started Braille Device Support.
[    2.102137] systemd[1]: Starting Braille Device Support...
[    2.102387] systemd[1]: Mounting POSIX Message Queue File System...
[    2.102726] systemd[1]: Mounting Debug File System...
[    2.102743] systemd[1]: Reached target Encrypted Volumes.
[    2.102753] systemd[1]: Starting Encrypted Volumes.
[    2.106046] systemd[1]: Started Setup Virtual Console.
[    2.108025] systemd[1]: Started Create list of required static
device nodes for the current kernel.
[    2.108345] systemd[1]: Starting Create Static Device Nodes in /dev...
[    2.128047] systemd[1]: Started Uncomplicated firewall.
[    2.139654] usb 1-3: New USB device found, idVendor=051d, idProduct=0003
[    2.139656] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.139657] usb 1-3: Product: Smart-UPS 750 FW:COM 02.1 / UPS.05.D
[    2.139658] usb 1-3: Manufacturer: American Power Conversion
[    2.139659] usb 1-3: SerialNumber: AS1028130789
[    2.139730] usb 1-3: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    2.139732] usb 1-3: ep 0x1 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    2.140277] systemd[1]: Mounted POSIX Message Queue File System.
[    2.140297] systemd[1]: Mounted Huge Pages File System.
[    2.140309] systemd[1]: Mounted Debug File System.
[    2.140828] systemd[1]: Started Increase datagram queue length.
[    2.141278] systemd[1]: Listening on Syslog Socket.
[    2.141288] systemd[1]: Starting Syslog Socket.
[    2.141561] systemd[1]: Starting Journal Service...
[    2.142774] systemd[1]: Started Nameserver information manager.
[    2.144130] hid-generic 0003:051D:0003.0004: hiddev0,hidraw3: USB
HID v1.00 Device [American Power Conversion Smart-UPS 750 FW:COM 02.1
/ UPS.05.D] on usb-0000:00:14.0-3/input0
[    2.149191] systemd[1]: Started udev Coldplug all Devices.
[    2.149553] systemd[1]: Starting udev Wait for Complete Device
Initialization...
[    2.159428] lp: driver loaded but no devices found
[    2.170373] ppdev: user-space parallel port driver
[    2.191103] systemd[1]: Started Load Kernel Modules.
[    2.191429] systemd[1]: Mounting FUSE Control File System...
[    2.191474] systemd[1]: Mounted Configuration File System.
[    2.191768] systemd[1]: Starting Apply Kernel Variables...
[    2.192776] systemd[1]: Mounted FUSE Control File System.
[    2.208745] systemd[1]: Started Journal Service.
[    2.258625] usb 1-7: new full-speed USB device number 5 using xhci_hcd
[    2.370463] wmi: Mapper loaded
[    2.375021] scsi 6:0:0:0: Direct-Access     BUFFALO  HD-PCFU3
  0    PQ: 0 ANSI: 6
[    2.375825] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    2.375972] sd 6:0:0:0: [sdd] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    2.376172] sd 6:0:0:0: [sdd] Write Protect is off
[    2.376175] sd 6:0:0:0: [sdd] Mode Sense: 43 00 00 00
[    2.376368] sd 6:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.376891] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.380238]  sdd: sdd1
[    2.381006] sd 6:0:0:0: [sdd] Attached SCSI disk
[    2.388208] usb 1-7: New USB device found, idVendor=03f0, idProduct=4f11
[    2.388211] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.388212] usb 1-7: Product: Officejet 5600 series
[    2.388214] usb 1-7: Manufacturer: HP
[    2.388215] usb 1-7: SerialNumber: CN6ABD531H04B2
[    2.388298] usb 1-7: ep 0x82 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    2.388306] usb 1-7: ep 0x84 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    2.388312] usb 1-7: ep 0x88 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    2.400422] random: nonblocking pool is initialized
[    2.407748] AVX2 version of gcm_enc/dec engaged.
[    2.407750] AES CTR mode by8 optimization enabled
[    2.461365] [drm] Initialized drm 1.1.0 20060810
[    2.462827] input: HP WMI hotkeys as /devices/virtual/input/input8
[    2.528350] cfg80211: World regulatory domain updated:
[    2.528353] cfg80211:  DFS Master region: unset
[    2.528354] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.528356] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[    2.528358] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[    2.528359] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(N/A, 2000 mBm), (N/A)
[    2.528361] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[    2.528363] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[    2.528364] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz),
(N/A, 2000 mBm), (0 s)
[    2.528365] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[    2.528367] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)
[    2.581716] intel_rapl: Found RAPL domain package
[    2.581719] intel_rapl: Found RAPL domain core
[    2.581721] intel_rapl: Found RAPL domain uncore
[    2.581723] intel_rapl: Found RAPL domain dram
[    2.586536] snd_hda_codec_realtek hdaudioC0D0: autoconfig for
ALC221: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    2.586539] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=1
(0x17/0x0/0x0/0x0/0x0)
[    2.586541] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1
(0x21/0x0/0x0/0x0/0x0)
[    2.586542] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    2.586544] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    2.586546] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x1a
[    2.586547] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1b
[    2.592634] [drm] radeon kernel modesetting enabled.
[    2.593017] [drm] Memory usable by graphics device = 2048M
[    2.593020] checking generic (d0000000 7f0000) vs hw (d0000000 10000000)
[    2.593022] fb: switching to inteldrmfb from VESA VGA
[    2.593056] Console: switching to colour dummy device 80x25
[    2.593142] [drm] Replacing VGA console driver
[    2.594347] input: HDA Intel PCH Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    2.594413] input: HDA Intel PCH Line as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    2.594489] input: HDA Intel PCH Line Out as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    2.594542] input: HDA Intel PCH Front Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    2.600653] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.600655] [drm] Driver supports precise vblank timestamp query.
[    2.600731] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    2.600905] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[    2.601287] [drm:drm_calc_timestamping_constants [drm]] *ERROR*
crtc 21: Can't calculate constants, dotclock = 0!
[    2.605518] [drm:intel_opregion_init [i915]] *ERROR* No ACPI video bus found
[    2.605549] [drm] Initialized i915 1.6.0 20150731 for 0000:00:02.0 on minor 0
[    2.609051] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    2.609211] rtlwifi: rtlwifi: wireless switch is on
[    2.613923] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    2.613925] AMD IOMMUv2 functionality not available on this system
[    2.624755] CRAT table not found
[    2.624757] Finished initializing topology ret=0
[    2.624801] kfd kfd: Initialized module
[    2.624993] radeon 0000:01:00.0: enabling device (0100 -> 0103)
[    2.625091] [drm] initializing kernel modesetting (CEDAR
0x1002:0x68FA 0x103C:0x2127).
[    2.625100] [drm] register mmio base: 0xF7B20000
[    2.625100] [drm] register mmio size: 131072
[    2.629604] fbcon: inteldrmfb (fb0) is primary device
[    2.634252] Adding 16695292k swap on /dev/sda5.  Priority:-1
extents:1 across:16695292k SSFS
[    2.714640] Console: switching to colour frame buffer device 240x67
[    2.727534] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.739613] ath: phy1: ASPM enabled: 0x43
[    2.739615] ath: EEPROM regdomain: 0x65
[    2.739616] ath: EEPROM indicates we should expect a direct regpair map
[    2.739617] ath: Country alpha2 being used: 00
[    2.739617] ath: Regpair used: 0x65
[    2.741656] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[    2.741872] ieee80211 phy1: Atheros AR9287 Rev:2
mem=0xffffc90001c60000, irq=19
[    2.762048] ath9k 0000:04:00.0 wlan2: renamed from wlan1
[    2.834123] usb 1-7: ep 0x84 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    3.762270] ATOM BIOS: C09006
[    3.762380] [drm] GPU not posted. posting now...
[    3.762387] clocksource: Switched to clocksource tsc
[    3.764672] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
0x000000003FFFFFFF (1024M used)
[    3.764673] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 -
0x000000007FFFFFFF
[    3.764674] [drm] Detected VRAM RAM=1024M, BAR=256M
[    3.764675] [drm] RAM width 64bits DDR
[    3.764768] [TTM] Zone  kernel: Available graphics memory: 8176360 kiB
[    3.764770] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    3.764770] [TTM] Initializing pool allocator
[    3.764774] [TTM] Initializing DMA pool allocator
[    3.764787] [drm] radeon: 1024M of VRAM memory ready
[    3.764788] [drm] radeon: 1024M of GTT memory ready.
[    3.764795] [drm] Loading CEDAR Microcode
[    3.768103] [drm] Internal thermal controller with fan control
[    3.769960] [drm] radeon: dpm initialized
[    3.771073] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    3.771507] [drm] enabling PCIE gen 2 link speeds, disable with
radeon.pcie_gen2=0
[    3.773410] [drm] PCIE GART of 1024M enabled (table at 0x000000000025E000).
[    3.773495] radeon 0000:01:00.0: WB enabled
[    3.773497] radeon 0000:01:00.0: fence driver on ring 0 use gpu
addr 0x0000000040000c00 and cpu addr 0xffff880411497c00
[    3.773498] radeon 0000:01:00.0: fence driver on ring 3 use gpu
addr 0x0000000040000c0c and cpu addr 0xffff880411497c0c
[    3.774240] radeon 0000:01:00.0: fence driver on ring 5 use gpu
addr 0x000000000005c418 and cpu addr 0xffffc9000341c418
[    3.774241] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.774242] [drm] Driver supports precise vblank timestamp query.
[    3.774243] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[    3.774303] radeon 0000:01:00.0: radeon: using MSI.
[    3.774334] [drm] radeon: irq initialized.
[    3.790715] [drm] ring test on 0 succeeded in 1 usecs
[    3.790721] [drm] ring test on 3 succeeded in 3 usecs
[    3.847715] usb 1-7: ep 0x84 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    3.848654] usblp 1-7:1.1: usblp1: USB Bidirectional printer dev 5
if 1 alt 0 proto 2 vid 0x03F0 pid 0x4F11
[    3.848665] usbcore: registered new interface driver usblp
[    3.976995] [drm] ring test on 5 succeeded in 1 usecs
[    3.977001] [drm] UVD initialized successfully.
[    3.977154] [drm] ib test on ring 0 succeeded in 0 usecs
[    3.977178] [drm] ib test on ring 3 succeeded in 0 usecs
[    4.635686] [drm] ib test on ring 5 succeeded
[    4.636390] [drm] Radeon Display Connectors
[    4.636392] [drm] Connector 0:
[    4.636392] [drm]   DVI-I-1
[    4.636393] [drm]   HPD2
[    4.636394] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468
0x646c 0x646c
[    4.636395] [drm]   Encoders:
[    4.636396] [drm]     DFP1: INTERNAL_UNIPHY1
[    4.636396] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    4.636397] [drm] Connector 1:
[    4.636397] [drm]   DVI-I-2
[    4.636398] [drm]   HPD4
[    4.636398] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
0x645c 0x645c
[    4.636399] [drm]   Encoders:
[    4.636400] [drm]     DFP2: INTERNAL_UNIPHY
[    4.636400] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    4.683972] radeon 0000:01:00.0: No connectors reported connected with modes
[    4.683974] [drm] Cannot find any crtc or sizes - going 1024x768
[    4.685260] [drm] fb mappable at 0xE045F000
[    4.685261] [drm] vram apper at 0xE0000000
[    4.685261] [drm] size 3145728
[    4.685262] [drm] fb depth is 24
[    4.685262] [drm]    pitch is 4096
[    4.685368] radeon 0000:01:00.0: fb1: radeondrmfb frame buffer device
[    4.685439] [drm] Initialized radeon 2.43.0 20080528 for
0000:01:00.0 on minor 1
[    4.864424] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    4.871217] systemd-journald[320]: Received request to flush
runtime journal from PID 1
[    5.015776] EXT4-fs (md0p1): mounted filesystem with ordered data
mode. Opts: (null)
[    5.019265] ifquery[714]: segfault at 1 ip 00000000004031c8 sp
00007ffee4b84c90 error 4 in ifup[400000+d000]
[    5.042909] audit: type=1400 audit(1443996205.446:2):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/lightdm/lightdm-guest-session" pid=755
comm="apparmor_parser"
[    5.042912] audit: type=1400 audit(1443996205.446:3):
apparmor="STATUS" operation="profile_load" name="chromium" pid=755
comm="apparmor_parser"
[    5.043858] audit: type=1400 audit(1443996205.450:4):
apparmor="STATUS" operation="profile_load" name="/sbin/dhclient"
pid=755 comm="apparmor_parser"
[    5.043861] audit: type=1400 audit(1443996205.450:5):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=755
comm="apparmor_parser"
[    5.043872] audit: type=1400 audit(1443996205.450:6):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=755
comm="apparmor_parser"
[    5.043874] audit: type=1400 audit(1443996205.450:7):
apparmor="STATUS" operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=755
comm="apparmor_parser"
[    5.048372] audit: type=1400 audit(1443996205.454:8):
apparmor="STATUS" operation="profile_load" name="/usr/bin/evince"
pid=755 comm="apparmor_parser"
[    5.048375] audit: type=1400 audit(1443996205.454:9):
apparmor="STATUS" operation="profile_load" name="sanitized_helper"
pid=755 comm="apparmor_parser"
[    5.129320] cgroup: new mount options do not match the existing
superblock, will be ignored
[    5.302436] r8169 0000:03:00.0 eth0: link down
[    6.570533] wlan0: authenticate with 00:15:ff:4f:55:61
[    6.580806] wlan0: send auth to 00:15:ff:4f:55:61 (try 1/3)
[    6.582426] wlan0: authenticated
[    6.584392] wlan0: associate with 00:15:ff:4f:55:61 (try 1/3)
[    6.587997] wlan0: RX AssocResp from 00:15:ff:4f:55:61 (capab=0x431
status=0 aid=3)
[    6.588554] wlan0: associated
[    6.590248] ath: EEPROM regdomain: 0x8348
[    6.590250] ath: EEPROM indicates we should expect a country code
[    6.590252] ath: doing EEPROM country->regdmn map search
[    6.590253] ath: country maps to regdmn code: 0x3a
[    6.590254] ath: Country alpha2 being used: US
[    6.590266] ath: Regpair used: 0x3a
[    6.590267] ath: regdomain 0x8348 dynamically updated by country IE
[    6.590341] cfg80211: Regulatory domain changed to country: US
[    6.590342] cfg80211:  DFS Master region: FCC
[    6.590344] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[    6.590345] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 3000 mBm), (N/A)
[    6.590347] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 1700 mBm), (N/A)
[    6.590349] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2300 mBm), (0 s)
[    6.590350] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 3000 mBm), (N/A)
[    6.590352] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 4000 mBm), (N/A)

Christopher M. Penalver
E-Mail: christopher.m.penalver@gmail.com
