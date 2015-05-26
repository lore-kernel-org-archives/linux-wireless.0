Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33111 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbEZM3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 08:29:23 -0400
Received: by oiww2 with SMTP id w2so76256922oiw.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 05:28:08 -0700 (PDT)
MIME-Version: 1.0
From: "Christopher M. Penalver" <christopher.m.penalver@gmail.com>
Date: Tue, 26 May 2015 06:56:12 -0500
Message-ID: <CAF4BKcBtVS9fzc66EFu2bWyisj3mYvW2epWdenoAJbzb-M4oPw@mail.gmail.com> (sfid-20150526_143027_792733_68F02AFF)
Subject: 10ec:8176 rtl8192ce 200-3200+ms latency on 802.11n 2.4GHz network
 with no load
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1.] One line summary of the problem:
10ec:8176 rtl8192ce 200-3200+ms latency on 802.11n 2.4GHz network with no load

[2.] Full description of the problem/report:
With an Asus PCE-N10 PCI-E Adapter Wireless N card (10ec:8176
rtl8192ce) I have 200-3200+ms latency on a 802.11n 2.4GHz network
pinging just the gateway 192.168.1.1, with no network load on either
the router or the WiFi chipset. The computer is ~4 feet away from a
Verizon Jetpack MiFi 5510L connected to a power source, with no
obstructions between them. Other clients (same version of latest
upstream kernel+Ubuntu with different chipset, Windows) don't have
this problem.

[3.] Keywords (i.e., modules, networking, kernel): N/A

[4.] Kernel version (from /proc/version):
cat /proc/version
Linux version 4.1.0-040100rc5-generic (kernel@gloin) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201505250235 SMP Mon May 25
02:37:02 UTC 2015

[5.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt) N/A

[6.] A small shell script or example program which triggers the
problem (if possible) N/A

[7.] Environment
lsb_release -rd
Description:    Ubuntu 15.04
Release:    15.04

[7.1.] Software (add the output of the ver_linux script here)
/usr/src/linux-headers-4.1.0-040100rc5/scripts$ sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux pc 4.1.0-040100rc5-generic #201505250235 SMP Mon May 25 02:37:02
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

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
Modules Loaded         rtl8192ce ctr ccm usblp amdkfd amd_iommu_v2
intel_rapl ath9k arc4 snd_hda_codec_realtek iosf_mbi
snd_hda_codec_generic radeon x86_pkg_temp_thermal ath9k_common
intel_powerclamp ath9k_hw coretemp rtl_pci snd_hda_intel
rtl8192c_common kvm_intel i915 snd_hda_controller ath rtlwifi
snd_hda_codec kvm mac80211 snd_hda_core snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event crct10dif_pclmul crc32_pclmul snd_rawmidi cfg80211
ttm video snd_seq ghash_clmulni_intel drm_kms_helper aesni_intel
snd_seq_device snd_timer hp_wmi drm aes_x86_64 sparse_keymap lrw snd
gf128mul glue_helper soundcore ablk_helper i2c_algo_bit cryptd
serio_raw mei_me mei shpchp lpc_ich wmi 8250_fintek tpm_infineon
mac_hid parport_pc ppdev lp parport autofs4 raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor uas
usb_storage raid6_pq ahci psmouse r8169 raid1 libahci mii raid0
multipath linear

[7.2.] Processor information (from /proc/cpuinfo):
cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping    : 3
microcode    : 0x1a
cpu MHz        : 1123.726
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
cpu MHz        : 837.382
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
cpu MHz        : 869.789
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
cpu MHz        : 802.851
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
cpu MHz        : 800.062
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
cpu MHz        : 929.953
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
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
cpu MHz        : 800.328
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
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx
f16c rdrand lahf_lm abm ida arat epb pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms
invpcid rtm xsaveopt
bugs        :
bogomips    : 6783.54
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
cat /proc/modules
rtl8192ce 57344 0 - Live 0x0000000000000000
ctr 16384 6 - Live 0x0000000000000000
ccm 20480 6 - Live 0x0000000000000000
usblp 24576 0 - Live 0x0000000000000000
amdkfd 90112 1 - Live 0x0000000000000000
amd_iommu_v2 20480 1 amdkfd, Live 0x0000000000000000
intel_rapl 20480 0 - Live 0x0000000000000000
ath9k 155648 0 - Live 0x0000000000000000
arc4 16384 4 - Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
iosf_mbi 16384 1 intel_rapl, Live 0x0000000000000000
snd_hda_codec_generic 77824 1 snd_hda_codec_realtek, Live 0x0000000000000000
radeon 1609728 1 - Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
ath9k_common 32768 1 ath9k, Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
ath9k_hw 491520 2 ath9k,ath9k_common, Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
rtl_pci 32768 1 rtl8192ce, Live 0x0000000000000000
snd_hda_intel 32768 3 - Live 0x0000000000000000
rtl8192c_common 61440 1 rtl8192ce, Live 0x0000000000000000
kvm_intel 159744 0 - Live 0x0000000000000000
i915 1146880 2 - Live 0x0000000000000000
snd_hda_controller 36864 1 snd_hda_intel, Live 0x0000000000000000
ath 32768 3 ath9k,ath9k_common,ath9k_hw, Live 0x0000000000000000
rtlwifi 77824 3 rtl8192ce,rtl_pci,rtl8192c_common, Live 0x0000000000000000
snd_hda_codec 122880 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0x0000000000000000
kvm 507904 1 kvm_intel, Live 0x0000000000000000
mac80211 786432 4 rtl8192ce,ath9k,rtl_pci,rtlwifi, Live 0x0000000000000000
snd_hda_core 36864 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_controller,snd_hda_codec,
Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 110592 3 snd_hda_intel,snd_hda_controller,snd_hda_codec, Live
0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
cfg80211 589824 5 ath9k,ath9k_common,ath,rtlwifi,mac80211, Live
0x0000000000000000
ttm 102400 1 radeon, Live 0x0000000000000000
video 28672 1 i915, Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
drm_kms_helper 126976 2 radeon,i915, Live 0x0000000000000000
aesni_intel 172032 12 - Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
hp_wmi 16384 0 - Live 0x0000000000000000
drm 352256 7 radeon,i915,ttm,drm_kms_helper, Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
sparse_keymap 16384 1 hp_wmi, Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
snd 86016 16 snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
gf128mul 16384 1 lrw, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
i2c_algo_bit 16384 2 radeon,i915, Live 0x0000000000000000
cryptd 24576 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
mei_me 24576 0 - Live 0x0000000000000000
mei 94208 1 mei_me, Live 0x0000000000000000
shpchp 40960 0 - Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
wmi 20480 1 hp_wmi, Live 0x0000000000000000
8250_fintek 16384 0 - Live 0x0000000000000000
tpm_infineon 20480 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
parport_pc 36864 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 45056 3 parport_pc,ppdev,lp, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
raid10 49152 0 - Live 0x0000000000000000
raid456 98304 0 - Live 0x0000000000000000
async_raid6_recov 20480 1 raid456, Live 0x0000000000000000
async_memcpy 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_pq 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_xor 16384 3 raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
async_tx 16384 5
raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live
0x0000000000000000
xor 24576 1 async_xor, Live 0x0000000000000000
uas 24576 0 - Live 0x0000000000000000
usb_storage 69632 2 uas, Live 0x0000000000000000
raid6_pq 106496 3 raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
ahci 36864 4 - Live 0x0000000000000000
psmouse 135168 0 - Live 0x0000000000000000
r8169 90112 0 - Live 0x0000000000000000
raid1 40960 1 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
raid0 20480 0 - Live 0x0000000000000000
multipath 16384 0 - Live 0x0000000000000000
linear 16384 0 - Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat /proc/ioports
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
  0430-0433 : iTCO_wdt
  0450-0450 : ACPI PM2_CNT_BLK
  0460-047f : iTCO_wdt
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
  01000000-01811adc : Kernel code
  01811add-01f34f7f : Kernel data
  020a6000-021e8fff : Kernel bss
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
    fed1f410-fed1f414 : iTCO_wdt
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

[7.5.] PCI information
00:00.0 Host bridge [0600]: Intel Corporation 4th Gen Core Processor
DRAM Controller [8086:0c00] (rev 06)
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: hsw_uncore

00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v3/4th Gen
Core Processor PCI Express x16 Controller [8086:0c01] (rev 06)
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 0000e000-0000efff
    Memory behind bridge: f7b00000-f7bfffff
    Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [88] Subsystem: Hewlett-Packard Company Device [103c:198e]
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee002f8  Data: 0000
    Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Exit
Latency L0s <256ns, L1 <8us
            ClockPM- Surprise- LLActRep- BwNot+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x16, TrErr- Train+ SlotClk+
DLActive- BWMgmt+ ABWMgmt+
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+,
OBFF Via WAKE# ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Via WAKE# ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
    Capabilities: [140 v1] Root Complex Link
        Desc:    PortNumber=02 ComponentID=01 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed19000
    Kernel driver in use: pcieport

00:02.0 VGA compatible controller [0300]: Intel Corporation Xeon
E3-1200 v3/4th Gen Core Processor Integrated Graphics Controller
[8086:0412] (rev 06) (prog-if 00 [VGA controller])
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 31
    Region 0: Memory at f7400000 (64-bit, non-prefetchable) [size=4M]
    Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at f000 [size=64]
    Expansion ROM at <unassigned> [disabled]
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee00018  Data: 0000
    Capabilities: [d0] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: i915

00:14.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series
Chipset Family USB xHCI [8086:8c31] (rev 04) (prog-if 30 [XHCI])
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 27
    Region 0: Memory at f7c00000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [70] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
        Address: 00000000fee00378  Data: 0000
    Kernel driver in use: xhci_hcd

00:16.0 Communication controller [0780]: Intel Corporation 8
Series/C220 Series Chipset Family MEI Controller #1 [8086:8c3a] (rev
04)
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 30
    Region 0: Memory at f7c1a000 (64-bit, non-prefetchable) [size=16]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee003f8  Data: 0000
    Kernel driver in use: mei_me

00:1a.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series
Chipset Family USB EHCI #2 [8086:8c2d] (rev 04) (prog-if 20 [EHCI])
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f7c18000 (32-bit, non-prefetchable) [size=1K]
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

00:1b.0 Audio device [0403]: Intel Corporation 8 Series/C220 Series
Chipset High Definition Audio Controller [8086:8c20] (rev 04)
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 32
    Region 0: Memory at f7c10000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee00438  Data: 0000
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=2 ArbSelect=Fixed TC/VC=04
            Status:    NegoPending- InProgress-
    Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series
Chipset Family PCI Express Root Port #1 [8086:8c10] (rev d4) (prog-if
00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 00002000-00002fff
    Memory behind bridge: cf200000-cf3fffff
    Prefetchable memory behind bridge: 00000000cf400000-00000000cf5fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+,
OBFF Via WAKE# ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:198e]
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport

00:1c.2 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series
Chipset Family PCI Express Root Port #3 [8086:8c14] (rev d4) (prog-if
00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 0000d000-0000dfff
    Memory behind bridge: f7a00000-f7afffff
    Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:198e]
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport

00:1c.3 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series
Chipset Family PCI Express Root Port #4 [8086:8c16] (rev d4) (prog-if
00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: f7900000-f79fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:198e]
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport

00:1c.5 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series
Chipset Family PCI Express Root Port #6 [8086:8c1a] (rev d4) (prog-if
00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
    I/O behind bridge: 0000c000-0000cfff
    Memory behind bridge: f7800000-f78fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:198e]
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport

00:1d.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series
Chipset Family USB EHCI #1 [8086:8c26] (rev 04) (prog-if 20 [EHCI])
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at f7c17000 (32-bit, non-prefetchable) [size=1K]
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

00:1f.0 ISA bridge [0601]: Intel Corporation C220 Series Chipset
Family H81 Express LPC Controller [8086:8c5c] (rev 04)
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: lpc_ich

00:1f.2 SATA controller [0106]: Intel Corporation 8 Series/C220 Series
Chipset Family 6-port SATA Controller 1 [AHCI mode] [8086:8c02] (rev
04) (prog-if 01 [AHCI 1.0])
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 28
    Region 0: I/O ports at f0b0 [size=8]
    Region 1: I/O ports at f0a0 [size=4]
    Region 2: I/O ports at f090 [size=8]
    Region 3: I/O ports at f080 [size=4]
    Region 4: I/O ports at f060 [size=32]
    Region 5: Memory at f7c16000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee003b8  Data: 0000
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
    Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 8 Series/C220 Series Chipset
Family SMBus Controller [8086:8c22] (rev 04)
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 3
    Region 0: Memory at f7c15000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at f040 [size=32]

01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
[AMD/ATI] Cedar [Radeon HD 7350/8350 / R5 220] [1002:68fa] (prog-if 00
[VGA controller])
    Subsystem: Hewlett-Packard Company Device [103c:2127]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 33
    Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
    Region 2: Memory at f7b20000 (64-bit, non-prefetchable) [size=128K]
    Region 4: I/O ports at e000 [size=256]
    Expansion ROM at f7b00000 [disabled] [size=128K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit
Latency L0s <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee00458  Data: 0000
    Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
Len=010 <?>
    Capabilities: [150 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Kernel driver in use: radeon

03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168]
(rev 0c)
    Subsystem: Hewlett-Packard Company Device [103c:198e]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 29
    Region 0: I/O ports at d000 [size=256]
    Region 2: Memory at f7a00000 (64-bit, non-prefetchable) [size=4K]
    Region 4: Memory at f0000000 (64-bit, prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee003d8  Data: 0000
    Capabilities: [70] Express (v2) Endpoint, MSI 01
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 4096 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s unlimited, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+,
OBFF Via message/WAKE#
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Vector table: BAR=4 offset=00000000
        PBA: BAR=4 offset=00000800
    Capabilities: [d0] Vital Product Data
        Unknown small resource type 00, will not decode more.
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [140 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
    Capabilities: [170 v1] Latency Tolerance Reporting
        Max snoop latency: 71680ns
        Max no snoop latency: 71680ns
    Kernel driver in use: r8169

04:00.0 Network controller [0280]: Qualcomm Atheros AR9287 Wireless
Network Adapter (PCI-Express) [168c:002e] (rev 01)
    Subsystem: Foxconn International, Inc. Device [105b:e034]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at f7900000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr+ BadTLP- BadDLLP+ Rollover+ Timeout+ NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [140 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
    Capabilities: [170 v1] Power Budgeting <?>
    Kernel driver in use: ath9k

05:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
    Subsystem: ASUSTeK Computer Inc. Device [1043:84b5]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 17
    Region 0: I/O ports at c000 [size=256]
    Region 2: Memory at f7800000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <512ns, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [140 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [160 v1] Device Serial Number 01-91-81-fe-ff-4c-e0-00
    Kernel driver in use: rtl8192ce

[7.6.] SCSI information (from /proc/scsi/scsi)
cat /proc/scsi/scsi
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

[7.7.] Other information that might be relevant to the problem (please
look in /proc and include all information that you think to be
relevant):
ls /proc
1     199   2434  4171  629        crypto
10    2     2435  4176  63         devices
101   20    2456  419   630        diskstats
1015  209   2473  42    631        dma
1039  21    2498  4208  64         driver
1079  210   25    4219  65         execdomains
1088  211   2500  4224  66         fb
1095  2139  2513  4244  664        filesystems
11    2140  2517  4260  665        fs
1106  2145  2522  4274  67         interrupts
1128  2147  253   4284  68         iomem
1138  22    2532  4285  69         ioports
1142  222   2538  43    7          irq
1151  2221  254   4304  70         kallsyms
1152  2229  2558  4342  71         kcore
1198  223   2561  4348  72         keys
12    224   2564  4349  727        key-users
121   2241  2571  4394  73         kmsg
122   2273  2577  442   74         kpagecount
1247  2279  2579  45    75         kpageflags
1265  228   2583  4513  76         loadavg
13    2297  2599  4538  8          locks
1322  2305  26    46    80         mdstat
14    2306  2605  4619  81         meminfo
15    2311  2657  4659  82         misc
17    2316  27    47    9          modules
1765  2319  2710  48    910        mounts
1790  2320  28    49    922        mtrr
1792  2324  287   4933  925        net
18    2327  29    4935  929        pagetypeinfo
1817  2334  3     5     94         partitions
1818  2336  31    50    943        sched_debug
1819  2337  311   52    947        schedstat
1834  2339  32    53    95         scsi
1835  2367  33    5353  954        self
1837  2374  34    5356  956        slabinfo
1839  2383  343   5392  959        softirqs
1840  2399  3457  5393  96         stat
1842  24    35    54    962        swaps
187   2403  3564  5409  964        sys
188   2406  36    55    97         sysrq-trigger
189   2412  38    56    971        sysvipc
19    2413  39    565   973        thread-self
190   2416  40    57    995        timer_list
191   2421  400   572   acpi       timer_stats
192   2422  407   588   asound     tty
193   2425  41    59    buddyinfo  uptime
194   2429  411   60    bus        version
195   2430  4159  61    cgroups    vmallocinfo
196   2431  416   616   cmdline    vmstat
197   2432  4163  62    consoles   zoneinfo
198   2433  417   628   cpuinfo

[X.] Other notes, patches, fixes, workarounds:
Downstream report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1445840

Christopher M. Penalver
E-Mail: christopher.m.penalver@gmail.com
