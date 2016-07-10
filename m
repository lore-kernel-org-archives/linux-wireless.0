Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betelgeuse.uberspace.de ([185.26.156.37]:47293 "EHLO
	betelgeuse.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcGJJFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 05:05:50 -0400
To: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
From: Niklas Sombert <niklas@ytvwld.de>
Subject: Problem: iwlwifi: Microcode SW error detected. Restarting 0x2000000
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Message-ID: <57820E4A.3010102@ytvwld.de> (sfid-20160710_110602_470416_AD882F3F)
Date: Sun, 10 Jul 2016 10:58:50 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NluE3EJEkk6mKRgHFIP22bHcj3teQrn7U"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NluE3EJEkk6mKRgHFIP22bHcj3teQrn7U
Content-Type: multipart/mixed; boundary="FCOKXQJ7nUQpms6A6rHtGkpxvVjTb0N2d"
From: Niklas Sombert <niklas@ytvwld.de>
To: Eran Harary <eran.harary@intel.com>,
 Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Message-ID: <57820E4A.3010102@ytvwld.de>
Subject: Problem: iwlwifi: Microcode SW error detected. Restarting 0x2000000

--FCOKXQJ7nUQpms6A6rHtGkpxvVjTb0N2d
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

With a current kernel my wifi won't work after suspending and resuming
my laptop (a ThinkPadd 11e).
This has worked in 4.0.0 and below, so this is a regression.
The commit that introduced this issue is
8d193ca26cc28019e760b77830295a0c349d90dc.

How to reproduce:
 1. Boot.
 2. Make sure that you are connected to wifi.
 3. Suspend.
 4. Wait a bit of time.
 5. Resume.
 6. See that the wifi is no longer functional.

Here are a few pieces of output that I was told to include in the report:=


$ cat /proc/version
Linux version 4.7.0-040700rc6-generic (kernel@gloin) (gcc version 5.4.0
20160609 (Ubuntu 5.4.0-6ubuntu1) ) #201607040332 SMP Mon Jul 4 07:34:26
UTC 2016
$ lsb_release -rd
Description:    Ubuntu 16.04 LTS
Release:        16.04
$ /usr/src/linux-headers-4.7.0-040700rc6/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux panzersperre 4.7.0-040700rc6-generic #201607040332 SMP Mon Jul 4
07:34:26 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

GNU C                   5.3.1
GNU Make                4.1
Binutils                2.26
Util-linux              2.27.1
Mount                   2.27.1
Module-init-tools       22
E2fsprogs               1.42.13
Pcmciautils             018
PPP                     2.4.7
Linux C Library         2.23
Dynamic linker (ldd)    2.23
Linux C++ Library       6.0.21
Procps                  3.3.10
Net-tools               1.60
Kbd                     1.15.5
Console-tools           1.15.5
Sh-utils                8.25
Udev                    229
Wireless-tools          30
Modules Loaded          ablk_helper ac acpi_pad aesni_intel aes_x86_64
ahci ansi_cprng arc4 autofs4 battery binfmt_misc bluetooth bnep bridge
btbcm btintel btrfs btrtl btusb button ccm cfg80211 coretemp crc16
crc32c_intel crc32_pclmul crct10dif_pclmul cryptd ctr drbg drm
drm_kms_helper dw_dmac dw_dmac_core efi_pstore efivarfs efivars ehci_hcd
ehci_pci elan_i2c evdev fat fjes fuse gf128mul ghash_clmulni_intel
glue_helper hid hmac i2c_algo_bit i2c_designware_core
i2c_designware_platform i2c_hid i915 intel_cstate intel_pch_thermal
intel_powerclamp intel_rapl iptable_filter iptable_mangle iptable_nat
ip_tables ipt_MASQUERADE irqbypass iwlmvm iwlwifi joydev kvm kvm_intel
libahci libata llc lp lpc_ich lrw lz4_compress mac80211 media mei mei_me
mfd_core mii mmc_core nf_conntrack nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nls_cp437 nls_utf8 nvram
parport parport_pc ppdev psmouse r8169 raid6_pq rfcomm rfkill scsi_mod
sdhci sdhci_acpi sd_mod serio_raw sg shpchp snd snd_compress
snd_hda_codec snd_hda_codec_generic snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_core snd_hda_intel snd_hwdep snd_pcm
snd_rawmidi snd_seq snd_seq_device snd_seq_midi snd_seq_midi_event
snd_soc_core snd_soc_rl6347a snd_soc_rt286 snd_soc_rt298 snd_soc_ssm4567
snd_soc_sst_acpi snd_soc_sst_match snd_timer soc_button_array soundcore
stp thermal thinkpad_acpi tpm tpm_tis usb_common usbcore uvcvideo vfat
video videobuf2_core videobuf2_memops videobuf2_v4l2 videobuf2_vmalloc
videodev wmi x86_pkg_temp_thermal xhci_hcd xhci_pci xor x_tables
xt_CHECKSUM xt_tcpudp zram zsmalloc
$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Core(TM) M-5Y10c CPU @ 0.80GHz
stepping        : 4
microcode       : 0x19
cpu MHz         : 800.048
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1
sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority ept
vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx
smap xsaveopt dtherm ida arat pln pts
bugs            :
bogomips        : 1995.42
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Core(TM) M-5Y10c CPU @ 0.80GHz
stepping        : 4
microcode       : 0x19
cpu MHz         : 799.987
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1
sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority ept
vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx
smap xsaveopt dtherm ida arat pln pts
bugs            :
bogomips        : 1997.08
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Core(TM) M-5Y10c CPU @ 0.80GHz
stepping        : 4
microcode       : 0x19
cpu MHz         : 800.170
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1
sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority ept
vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx
smap xsaveopt dtherm ida arat pln pts
bugs            :
bogomips        : 1996.66
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 61
model name      : Intel(R) Core(TM) M-5Y10c CPU @ 0.80GHz
stepping        : 4
microcode       : 0x19
cpu MHz         : 799.926
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1
sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority ept
vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx
smap xsaveopt dtherm ida arat pln pts
bugs            :
bogomips        : 1996.66
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

$ cat /proc/modules
rfcomm 69632 14 - Live 0x0000000000000000
xt_CHECKSUM 16384 1 - Live 0x0000000000000000
iptable_mangle 16384 1 - Live 0x0000000000000000
ipt_MASQUERADE 16384 1 - Live 0x0000000000000000
nf_nat_masquerade_ipv4 16384 1 ipt_MASQUERADE, Live 0x0000000000000000
iptable_nat 16384 1 - Live 0x0000000000000000
nf_conntrack_ipv4 20480 1 - Live 0x0000000000000000
nf_defrag_ipv4 16384 1 nf_conntrack_ipv4, Live 0x0000000000000000
nf_nat_ipv4 16384 1 iptable_nat, Live 0x0000000000000000
nf_nat 24576 2 nf_nat_masquerade_ipv4,nf_nat_ipv4, Live 0x000000000000000=
0
nf_conntrack 114688 4
nf_nat_masquerade_ipv4,nf_conntrack_ipv4,nf_nat_ipv4,nf_nat, Live
0x0000000000000000
xt_tcpudp 16384 5 - Live 0x0000000000000000
bridge 126976 0 - Live 0x0000000000000000
stp 16384 1 bridge, Live 0x0000000000000000
llc 16384 2 bridge,stp, Live 0x0000000000000000
iptable_filter 16384 1 - Live 0x0000000000000000
ip_tables 24576 3 iptable_mangle,iptable_nat,iptable_filter, Live
0x0000000000000000
x_tables 36864 6
xt_CHECKSUM,iptable_mangle,ipt_MASQUERADE,xt_tcpudp,iptable_filter,ip_tab=
les,
Live 0x0000000000000000
ctr 16384 1 - Live 0x0000000000000000
ccm 20480 1 - Live 0x0000000000000000
fuse 98304 3 - Live 0x0000000000000000
bnep 20480 2 - Live 0x0000000000000000
zram 28672 4 - Live 0x0000000000000000
zsmalloc 20480 1 zram, Live 0x0000000000000000
lz4_compress 16384 1 zram, Live 0x0000000000000000
binfmt_misc 20480 1 - Live 0x0000000000000000
nls_utf8 16384 1 - Live 0x0000000000000000
nls_cp437 20480 1 - Live 0x0000000000000000
vfat 20480 1 - Live 0x0000000000000000
fat 69632 1 vfat, Live 0x0000000000000000
arc4 16384 2 - Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
iwlmvm 233472 0 - Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
mac80211 634880 1 iwlmvm, Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
hmac 16384 1 - Live 0x0000000000000000
drbg 24576 1 - Live 0x0000000000000000
ansi_cprng 16384 0 - Live 0x0000000000000000
uvcvideo 90112 0 - Live 0x0000000000000000
aesni_intel 167936 2 - Live 0x0000000000000000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
gf128mul 16384 1 lrw, Live 0x0000000000000000
videobuf2_v4l2 24576 1 uvcvideo, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
videobuf2_core 36864 2 uvcvideo,videobuf2_v4l2, Live 0x0000000000000000
btusb 45056 0 - Live 0x0000000000000000
btrtl 16384 1 btusb, Live 0x0000000000000000
btbcm 16384 1 btusb, Live 0x0000000000000000
btintel 16384 1 btusb, Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
bluetooth 516096 41 rfcomm,bnep,btusb,btrtl,btbcm,btintel, Live
0x0000000000000000
videodev 167936 3 uvcvideo,videobuf2_v4l2,videobuf2_core, Live
0x0000000000000000
snd_hda_codec_generic 69632 1 snd_hda_codec_realtek, Live 0x0000000000000=
000
cryptd 20480 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0x0000000000000000
crc16 16384 1 bluetooth, Live 0x0000000000000000
media 32768 2 uvcvideo,videodev, Live 0x0000000000000000
snd_hda_codec_hdmi 45056 1 - Live 0x0000000000000000
iwlwifi 147456 1 iwlmvm, Live 0x0000000000000000
intel_cstate 16384 0 - Live 0x0000000000000000
intel_rapl 16384 0 - Live 0x0000000000000000
efi_pstore 16384 0 - Live 0x0000000000000000
snd_hda_intel 36864 5 - Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
snd_hda_codec 131072 4
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_in=
tel,
Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
cfg80211 569344 3 iwlmvm,mac80211,iwlwifi, Live 0x0000000000000000
efivars 20480 1 efi_pstore, Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
mei_me 32768 0 - Live 0x0000000000000000
snd_hda_core 81920 5
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_in=
tel,snd_hda_codec,
Live 0x0000000000000000
snd_soc_rt298 36864 0 - Live 0x0000000000000000
sg 32768 0 - Live 0x0000000000000000
mfd_core 16384 1 lpc_ich, Live 0x0000000000000000
intel_pch_thermal 16384 0 - Live 0x0000000000000000
shpchp 36864 0 - Live 0x0000000000000000
snd_soc_rt286 36864 0 - Live 0x0000000000000000
mei 94208 1 mei_me, Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
snd_soc_rl6347a 16384 2 snd_soc_rt298,snd_soc_rt286, Live 0x0000000000000=
000
snd_soc_ssm4567 16384 0 - Live 0x0000000000000000
battery 16384 0 - Live 0x0000000000000000
snd_soc_core 188416 3 snd_soc_rt298,snd_soc_rt286,snd_soc_ssm4567, Live
0x0000000000000000
snd_compress 20480 1 snd_soc_core, Live 0x0000000000000000
snd_pcm 106496 7
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda_core,snd_soc_rt298=
,snd_soc_rt286,snd_soc_core,
Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
thinkpad_acpi 86016 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
nvram 16384 1 thinkpad_acpi, Live 0x0000000000000000
rfkill 24576 9 bluetooth,cfg80211,thinkpad_acpi, Live 0x0000000000000000
snd_seq 65536 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
snd 81920 24
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_in=
tel,snd_hda_codec,snd_hwdep,snd_soc_core,snd_compress,snd_pcm,thinkpad_ac=
pi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
elan_i2c 36864 0 - Live 0x0000000000000000
snd_soc_sst_acpi 16384 0 - Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
snd_soc_sst_match 16384 1 snd_soc_sst_acpi, Live 0x0000000000000000
dw_dmac 16384 0 - Live 0x0000000000000000
i2c_designware_platform 16384 0 - Live 0x0000000000000000
dw_dmac_core 24576 1 dw_dmac, Live 0x0000000000000000
i2c_designware_core 20480 1 i2c_designware_platform, Live 0x0000000000000=
000
soc_button_array 16384 0 - Live 0x0000000000000000
ac 16384 0 - Live 0x0000000000000000
acpi_pad 24576 0 - Live 0x0000000000000000
evdev 24576 27 - Live 0x0000000000000000
tpm_tis 20480 0 - Live 0x0000000000000000
tpm 45056 1 tpm_tis, Live 0x0000000000000000
kvm_intel 188416 0 - Live 0x0000000000000000
kvm 565248 1 kvm_intel, Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
parport_pc 28672 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 45056 3 parport_pc,ppdev,lp, Live 0x0000000000000000
efivarfs 16384 1 - Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
btrfs 1019904 1 - Live 0x0000000000000000
xor 24576 1 btrfs, Live 0x0000000000000000
raid6_pq 102400 1 btrfs, Live 0x0000000000000000
sd_mod 45056 3 - Live 0x0000000000000000
i915 1277952 9 - Live 0x0000000000000000
ahci 36864 2 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
libata 241664 2 ahci,libahci, Live 0x0000000000000000
crc32c_intel 24576 1 - Live 0x0000000000000000
scsi_mod 225280 3 sg,sd_mod,libata, Live 0x0000000000000000
psmouse 126976 0 - Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
xhci_pci 16384 0 - Live 0x0000000000000000
drm_kms_helper 143360 1 i915, Live 0x0000000000000000
ehci_pci 16384 0 - Live 0x0000000000000000
ehci_hcd 77824 1 ehci_pci, Live 0x0000000000000000
xhci_hcd 172032 1 xhci_pci, Live 0x0000000000000000
drm 352256 10 i915,drm_kms_helper, Live 0x0000000000000000
r8169 81920 0 - Live 0x0000000000000000
usbcore 237568 6 uvcvideo,btusb,xhci_pci,ehci_pci,ehci_hcd,xhci_hcd,
Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
usb_common 16384 1 usbcore, Live 0x0000000000000000
thermal 20480 0 - Live 0x0000000000000000
wmi 16384 0 - Live 0x0000000000000000
sdhci_acpi 16384 0 - Live 0x0000000000000000
sdhci 40960 1 sdhci_acpi, Live 0x0000000000000000
mmc_core 131072 2 sdhci_acpi,sdhci, Live 0x0000000000000000
video 40960 2 thinkpad_acpi,i915, Live 0x0000000000000000
i2c_hid 20480 0 - Live 0x0000000000000000
hid 114688 1 i2c_hid, Live 0x0000000000000000
button 16384 1 i915, Live 0x0000000000000000
fjes 28672 0 - Live 0x0000000000000000
$ cat /proc/ioports
cat /proc/iomem0000-0000 : PCI Bus 0000:00
  0000-0000 : dma1
  0000-0000 : pic1
  0000-0000 : timer0
  0000-0000 : timer1
  0000-0000 : keyboard
  0000-0000 : PNP0C09:00
    0000-0000 : EC data
  0000-0000 : keyboard
  0000-0000 : PNP0C09:00
    0000-0000 : EC cmd
  0000-0000 : rtc0
  0000-0000 : dma page reg
  0000-0000 : pic2
  0000-0000 : dma2
  0000-0000 : fpu
  0000-0000 : pnp 00:00
0000-0000 : PCI conf1
0000-0000 : PCI Bus 0000:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
    0000-0000 : ACPI PM1a_EVT_BLK
    0000-0000 : ACPI PM1a_CNT_BLK
    0000-0000 : ACPI PM_TMR
    0000-0000 : ACPI CPU throttle
    0000-0000 : iTCO_wdt.0.auto
    0000-0000 : ACPI PM2_CNT_BLK
    0000-0000 : pnp 00:02
    0000-0000 : iTCO_wdt.0.auto
    0000-0000 : ACPI GPE0_BLK
  0000-0000 : PCI Bus 0000:05
    0000-0000 : 0000:05:00.0
      0000-0000 : r8169
  0000-0000 : 0000:00:02.0
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.3
  0000-0000 : pnp 00:00
    0000-0000 : pnp 00:00
      0000-0000 : pnp 00:00
$ sudo lspci -vvv
00:00.0 Host bridge: Intel Corporation Broadwell-U Host Bridge -OPI (rev =
09)
        Subsystem: Lenovo Broadwell-U Host Bridge -OPI
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>
        Kernel driver in use: bdw_uncore

00:02.0 VGA compatible controller: Intel Corporation Broadwell-U
Integrated Graphics (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Broadwell-U Integrated Graphics
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 47
        Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=3D1=
6M]
        Region 2: Memory at e0000000 (64-bit, prefetchable) [size=3D256M]=

        Region 4: I/O ports at 4000 [size=3D64]
        [virtual] Expansion ROM at 000c0000 [disabled] [size=3D128K]
        Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee00018  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915
        Kernel modules: i915

00:03.0 Audio device: Intel Corporation Broadwell-U Audio Controller
(rev 09)
        Subsystem: Lenovo Broadwell-U Audio Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 49
        Region 0: Memory at f1210000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee00338  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated
Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

00:14.0 USB controller: Intel Corporation Wildcat Point-LP USB xHCI
Controller (rev 03) (prog-if 30 [XHCI])
        Subsystem: Lenovo Wildcat Point-LP USB xHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 45
        Region 0: Memory at f1200000 (64-bit, non-prefetchable) [size=3D6=
4K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [80] MSI: Enable+ Count=3D1/8 Maskable- 64bit+
                Address: 00000000fee002b8  Data: 0000
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_pci

00:16.0 Communication controller: Intel Corporation Wildcat Point-LP MEI
Controller #1 (rev 03)
        Subsystem: Lenovo Wildcat Point-LP MEI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 48
        Region 0: Memory at f1219000 (64-bit, non-prefetchable) [size=3D3=
2]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00318  Data: 0000
        Kernel driver in use: mei_me
        Kernel modules: mei_me

00:1b.0 Audio device: Intel Corporation Wildcat Point-LP High Definition
Audio Controller (rev 03)
        Subsystem: Lenovo Wildcat Point-LP High Definition Audio Controll=
er
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at f1214000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00378  Data: 0000
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e3)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 255
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommC=
lk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+,
LTR+, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
LTR+, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Lenovo 82801 Mobile PCI Bridge
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [100 v0] #00
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=3D40us
PortTPowerOnTime=3D10us

00:1c.2 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express Root
Port #3 (rev e3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 42
        Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f1100000-f11fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+,
LTR+, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
LTR+, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee00218  Data: 0000
        Capabilities: [90] Subsystem: Lenovo Wildcat Point-LP PCI
Express Root Port
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [100 v0] #00
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=3D40us
PortTPowerOnTime=3D10us
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express Root
Port #4 (rev e3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 43
        Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D=
0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: f1000000-f10fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABC, TimeoutDis+,
LTR+, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
LTR+, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee00258  Data: 0000
        Capabilities: [90] Subsystem: Lenovo Wildcat Point-LP PCI
Express Root Port
        Capabilities: [a0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [100 v0] #00
        Capabilities: [200 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=3D40us
PortTPowerOnTime=3D10us
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation Wildcat Point-LP USB EHCI
Controller (rev 03) (prog-if 20 [EHCI])
        Subsystem: Lenovo Wildcat Point-LP USB EHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f121d000 (32-bit, non-prefetchable) [size=3D1=
K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

00:1f.0 ISA bridge: Intel Corporation Wildcat Point-LP LPC Controller
(rev 03)
        Subsystem: Lenovo Wildcat Point-LP LPC Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>
        Kernel driver in use: lpc_ich
        Kernel modules: lpc_ich

00:1f.2 SATA controller: Intel Corporation Wildcat Point-LP SATA
Controller [AHCI Mode] (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: Lenovo Wildcat Point-LP SATA Controller [AHCI Mode]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 46
        Region 0: I/O ports at 4088 [size=3D8]
        Region 1: I/O ports at 4094 [size=3D4]
        Region 2: I/O ports at 4080 [size=3D8]
        Region 3: I/O ports at 4090 [size=3D4]
        Region 4: I/O ports at 4060 [size=3D32]
        Region 5: Memory at f121c000 (32-bit, non-prefetchable) [size=3D2=
K]
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee002d8  Data: 0000
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
        Kernel driver in use: ahci
        Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation Wildcat Point-LP SMBus Controller (rev 0=
3)
        Subsystem: Lenovo Wildcat Point-LP SMBus Controller
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 255
        Region 0: Memory at f1218000 (64-bit, non-prefetchable) [size=3D2=
56]
        Region 4: I/O ports at efa0 [size=3D32]
        Kernel modules: i2c_i801

00:1f.6 Signal processing controller: Intel Corporation Wildcat Point-LP
Thermal Management Controller (rev 03)
        Subsystem: Lenovo Wildcat Point-LP Thermal Management Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f121b000 (64-bit, non-prefetchable) [size=3D4=
K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel driver in use: intel_pch_thermal
        Kernel modules: intel_pch_thermal

04:00.0 Network controller: Intel Corporation Wireless 7265 (rev 61)
        Subsystem: Intel Corporation Dual Band Wireless-AC 7265
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 51
        Region 0: Memory at f1100000 (64-bit, non-prefetchable) [size=3D8=
K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00398  Data: 0000
        Capabilities: [40] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
FLReset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L1, Exit
Latency L0s <4us, L1 <32us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR+,
OBFF Via WAKE#
                DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-,
LTR+, OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [140 v1] Device Serial Number 34-02-86-ff-ff-e3-13-=
9f
        Capabilities: [14c v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [154 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=3D30us
PortTPowerOnTime=3D60us
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 10)
        Subsystem: Lenovo RTL8111/8168/8411 PCI Express Gigabit Ethernet
Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 44
        Region 0: I/O ports at 3000 [size=3D256]
        Region 2: Memory at f1004000 (64-bit, non-prefetchable) [size=3D4=
K]
        Region 4: Memory at f1000000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee00278  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommC=
lk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+,
LTR+, OBFF Via message/WAKE#
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
LTR+, OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=3D4 Masked-
                Vector table: BAR=3D4 offset=3D00000000
                PBA: BAR=3D4 offset=3D00000800
        Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
                Not readable
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopT=
rans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D=
ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-=
00
        Capabilities: [170 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [178 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+
ASPM_L1.1+ L1_PM_Substates+
                          PortCommonModeRestoreTime=3D150us
PortTPowerOnTime=3D150us
        Kernel driver in use: r8169
        Kernel modules: r8169

$ LANG=3DC cat /proc/scsi/scsi
cat: /proc/scsi/scsi: No such file or directory
$ ls /proc
1     185   2494  31    6473  6727  6780  6832  6885  6938  6991  7043
7096  7149       cmdline
10    1850  25    3110  6474  6728  6781  6833  6886  6939  6992  7044
7097  7150       consoles
11    1852  26    3116  6475  6729  6782  6834  6887  6940  6993  7045
7098  7151       cpuinfo
115   1853  266   3119  6494  6730  6783  6835  6888  6941  6994  7046
7099  7152       crypto
116   1856  27    3182  6500  6731  6784  6836  6889  6942  6995  7047
7100  7153       devices
118   19    2721  3183  6504  6732  6785  6837  6890  6943  6996  7048
7101  7154       diskstats
119   1902  2722  3184  6680  6733  6786  6838  6891  6944  6997  7049
7102  7155       dma
12    1955  2723  3185  6682  6734  6787  6839  6892  6945  6998  7050
7103  7156       driver
121   1998  2727  3186  6683  6735  6788  6840  6893  6946  6999  7051
7104  7157       execdomains
122   2     2733  3187  6684  6736  6789  6841  6894  6947  7     7052
7105  7158       fb
123   20    2735  3188  6685  6737  6790  6842  6895  6948  7000  7053
7106  7159       filesystems
124   2028  2736  3189  6686  6738  6791  6843  6896  6949  7001  7054
7107  7160       fs
125   2032  2788  3191  6687  6739  6792  6844  6897  6950  7002  7055
7108  7161       interrupts
1276  2036  2790  3195  6688  6740  6793  6845  6898  6951  7003  7056
7109  7162       iomem
1289  2048  2791  32    6689  6741  6794  6846  6899  6952  7004  7057
7110  7163       ioports
13    2074  28    33    6690  6742  6795  6847  6900  6953  7005  7058
7111  7164       irq
131   2089  2861  3337  6691  6743  6796  6848  6901  6954  7006  7059
7112  7165       kallsyms
134   21    2864  3369  6692  6744  6797  6849  6902  6955  7007  7060
7113  7166       kcore
135   210   2865  3398  6693  6745  6798  6850  6903  6956  7008  7061
7114  7167       keys
136   2104  2907  34    6694  6746  6799  6851  6904  6957  7009  7062
7115  7168       key-users
137   2105  2912  3462  6695  6747  68    6852  6905  6958  7010  7063
7116  7169       kmsg
1389  211   2914  3466  6696  6748  6800  6853  6906  6959  7011  7064
7117  7170       kpagecgroup
1390  2115  2919  3483  6697  6749  6801  6854  6907  6960  7012  7065
7118  7171       kpagecount
1399  2116  2932  35    6698  6750  6802  6855  6908  6961  7013  7066
7119  7172       kpageflags
14    2119  2933  3543  6699  6751  6803  6856  6909  6962  7014  7067
7120  7173       loadavg
1441  212   2934  36    67    6752  6804  6857  6910  6963  7015  7068
7121  7174       locks
1444  2125  2936  38    6700  6753  6805  6858  6911  6964  7016  7069
7122  7175       meminfo
1472  213   2942  39    6701  6754  6806  6859  6912  6965  7017  7070
7123  7176       misc
1473  214   2952  40    6702  6755  6807  6860  6913  6966  7018  7071
7124  7177       modules
1475  215   2953  41    6703  6756  6808  6861  6914  6967  7019  7072
7125  7178       mounts
15    216   2959  42    6704  6757  6809  6862  6915  6968  7020  7073
7126  7179       mtrr
1547  2168  2966  43    6705  6758  6810  6863  6916  6969  7021  7074
7127  7180       net
1576  217   2970  47    6706  6759  6811  6864  6917  6970  7022  7075
7128  7181       pagetypeinfo
16    2179  2975  48    6707  6760  6812  6865  6918  6971  7023  7076
7129  7182       partitions
1657  218   2978  49    6708  6761  6813  6866  6919  6972  7024  7077
7130  7183       sched_debug
1769  219   2980  5     6709  6762  6814  6867  6920  6973  7025  7078
7131  7184       self
1770  22    2982  50    6710  6763  6815  6868  6921  6974  7026  7079
7132  7185       slabinfo
18    220   2988  5502  6711  6764  6816  6869  6922  6975  7027  7080
7133  7186       softirqs
1801  221   2991  5543  6712  6765  6817  6870  6923  6976  7028  7081
7134  7187       stat
1803  222   2997  5575  6713  6766  6818  6871  6924  6977  7029  7082
7135  7188       swaps
1805  223   3     5576  6714  6767  6819  6872  6925  6978  7030  7083
7136  7189       sys
1812  224   30    5577  6715  6768  6820  6873  6926  6979  7031  7084
7137  7190       sysrq-trigger
1814  225   3004  5601  6716  6769  6821  6874  6927  6980  7032  7085
7138  7191       sysvipc
1815  226   3007  5667  6717  6770  6822  6875  6928  6981  7033  7086
7139  7201       thread-self
1821  227   3012  5765  6718  6771  6823  6876  6929  6982  7034  7087
7140  7208       timer_list
1827  228   3013  6030  6719  6772  6824  6877  6930  6983  7035  7088
7141  73         timer_stats
1828  229   3052  6219  6720  6773  6825  6878  6931  6984  7036  7089
7142  8          tty
1832  230   3059  6275  6721  6774  6826  6879  6932  6985  7037  7090
7143  9          uptime
1835  231   3073  6423  6722  6775  6827  6880  6933  6986  7038  7091
7144  acpi       version
1836  2329  3075  6440  6723  6776  6828  6881  6934  6987  7039  7092
7145  asound     vmallocinfo
1839  2332  3077  6442  6724  6777  6829  6882  6935  6988  7040  7093
7146  buddyinfo  vmstat
1840  2355  3085  6455  6725  6778  6830  6883  6936  6989  7041  7094
7147  bus        zoneinfo
1845  24    3098  6456  6726  6779  6831  6884  6937  6990  7042  7095
7148  cgroups
$

This is the relevant part of dmesg (at least I believe so):
[ 2876.724157] perf: interrupt took too long (2508 > 2500), lowering
kernel.perf_event_max_sample_rate to 79500
[ 4397.630390] r8169 0000:05:00.0: invalid short VPD tag 00 at offset 1
[ 4445.670993] perf: interrupt took too long (3136 > 3135), lowering
kernel.perf_event_max_sample_rate to 63750
[ 4638.103113] wlan0: deauthenticating from 9c:c7:a6:ae:69:f9 by local
choice (Reason: 3=3DDEAUTH_LEAVING)
[ 4649.346263] PM: Syncing filesystems ... done.
[ 4649.393283] PM: Preparing system for sleep (mem)
[ 4649.400680] Freezing user space processes ... (elapsed 0.003 seconds)
done.
[ 4649.404232] Double checking all user space processes after OOM killer
disable... (elapsed 0.000 seconds)
[ 4649.404608] Freezing remaining freezable tasks ... (elapsed 0.005
seconds) done.
[ 4649.409794] PM: Suspending system (mem)
[ 4649.409863] Suspending console(s) (use no_console_suspend to debug)
[ 4649.410391] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 4649.410712] sd 0:0:0:0: [sda] Stopping disk
[ 4650.848611] PM: suspend of devices complete after 1438.510 msecs
[ 4650.870516] PM: late suspend of devices complete after 21.900 msecs
[ 4650.873511] r8169 0000:05:00.0: System wakeup enabled by ACPI
[ 4650.873699] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[ 4650.873895] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[ 4650.887064] PM: noirq suspend of devices complete after 16.542 msecs
[ 4650.888033] ACPI: Preparing to enter system sleep state S3
[ 4651.150817] ACPI : EC: EC stopped
[ 4651.150818] PM: Saving platform NVS memory
[ 4651.150840] Disabling non-boot CPUs ...
[ 4651.151385] Broke affinity for irq 43
[ 4651.151391] Broke affinity for irq 44
[ 4651.151409] Broke affinity for irq 51
[ 4651.153463] smpboot: CPU 1 is now offline
[ 4651.155310] Broke affinity for irq 43
[ 4651.155316] Broke affinity for irq 44
[ 4651.155325] Broke affinity for irq 46
[ 4651.155336] Broke affinity for irq 51
[ 4651.156387] smpboot: CPU 2 is now offline
[ 4651.157924] Broke affinity for irq 1
[ 4651.157929] Broke affinity for irq 8
[ 4651.157933] Broke affinity for irq 9
[ 4651.157938] Broke affinity for irq 12
[ 4651.157943] Broke affinity for irq 23
[ 4651.157948] Broke affinity for irq 42
[ 4651.157952] Broke affinity for irq 43
[ 4651.157956] Broke affinity for irq 44
[ 4651.157961] Broke affinity for irq 45
[ 4651.157965] Broke affinity for irq 46
[ 4651.157969] Broke affinity for irq 47
[ 4651.157974] Broke affinity for irq 51
[ 4651.159020] smpboot: CPU 3 is now offline
[ 4651.163966] ACPI: Low-level resume complete
[ 4651.164085] ACPI : EC: EC started
[ 4651.164086] PM: Restoring platform NVS memory
[ 4651.164537] Enabling non-boot CPUs ...
[ 4651.165458] x86: Booting SMP configuration:
[ 4651.165460] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4651.169620]  cache: parent cpu1 should not be sleeping
[ 4651.170050] CPU1 is up
[ 4651.171203] smpboot: Booting Node 0 Processor 2 APIC 0x2
[ 4651.174828]  cache: parent cpu2 should not be sleeping
[ 4651.175035] CPU2 is up
[ 4651.175435] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 4651.178530]  cache: parent cpu3 should not be sleeping
[ 4651.178867] CPU3 is up
[ 4651.183884] ACPI: Waking up from system sleep state S3
[ 4651.234904] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[ 4651.254517] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[ 4651.254601] PM: noirq resume of devices complete after 19.943 msecs
[ 4651.261024] PM: early resume of devices complete after 6.379 msecs
[ 4651.261616] r8169 0000:05:00.0: System wakeup disabled by ACPI
[ 4651.263079] rtc_cmos 00:01: System wakeup disabled by ACPI
[ 4651.263261] sd 0:0:0:0: [sda] Starting disk
[ 4651.272936] r8169 0000:05:00.0 eth0: link down
[ 4651.298388] xhci_hcd 0000:00:14.0: port 5 resume PLC timeout
[ 4651.522825] usb 2-5: reset high-speed USB device number 2 using xhci_h=
cd
[ 4651.574290] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 4651.576422] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4651.576445] ata1.00: supports DRM functions and may not be fully
accessible
[ 4651.576885] ata1.00: NCQ Send/Recv Log not supported
[ 4651.577281] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4651.577333] ata1.00: supports DRM functions and may not be fully
accessible
[ 4651.577758] ata1.00: NCQ Send/Recv Log not supported
[ 4651.577764] ata1.00: configured for UDMA/133
[ 4651.874992] usb 2-6: reset full-speed USB device number 3 using xhci_h=
cd
[ 4652.005371] PM: resume of devices complete after 744.358 msecs
[ 4652.005443] usb 2-6:1.0: rebind failed: -517
[ 4652.005447] usb 2-6:1.1: rebind failed: -517
[ 4652.005888] PM: Finishing wakeup.
[ 4652.005891] Restarting tasks ...
[ 4652.008783] pci_bus 0000:02: Allocating resources
[ 4652.008797] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to
[bus 02] add_size 1000
[ 4652.008802] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align
100000
[ 4652.008806] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff] to [bus 02] add_size 200000 add_align 100000
[ 4652.008813] pci_bus 0000:04: Allocating resources
[ 4652.009018] pcieport 0000:00:1c.2: bridge window [io  0x1000-0x0fff]
to [bus 04] add_size 1000
[ 4652.009022] pcieport 0000:00:1c.2: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000 add_align
100000
[ 4652.009029] pci_bus 0000:05: Allocating resources
[ 4652.009041] pcieport 0000:00:1c.3: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 05] add_size 200000 add_align
100000
[ 4652.009051] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x000fffff]
res_to_dev_res add_size 200000 min_align 100000
[ 4652.009054] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x002fffff]
res_to_dev_res add_size 200000 min_align 100000
[ 4652.009057] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[ 4652.009059] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x002fffff
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[ 4652.009062] pcieport 0000:00:1c.2: res[15]=3D[mem 0x00100000-0x000ffff=
f
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[ 4652.009065] pcieport 0000:00:1c.2: res[15]=3D[mem 0x00100000-0x002ffff=
f
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[ 4652.009067] pcieport 0000:00:1c.3: res[15]=3D[mem 0x00100000-0x000ffff=
f
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[ 4652.009071] pcieport 0000:00:1c.3: res[15]=3D[mem 0x00100000-0x002ffff=
f
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[ 4652.009074] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff]
res_to_dev_res add_size 1000 min_align 1000
[ 4652.009077] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x1fff]
res_to_dev_res add_size 1000 min_align 1000
[ 4652.009079] pcieport 0000:00:1c.2: res[13]=3D[io  0x1000-0x0fff]
res_to_dev_res add_size 1000 min_align 1000
[ 4652.009082] pcieport 0000:00:1c.2: res[13]=3D[io  0x1000-0x1fff]
res_to_dev_res add_size 1000 min_align 1000
[ 4652.009090] pci 0000:00:1c.0: BAR 14: assigned [mem
0xd0100000-0xd02fffff]
[ 4652.009100] pci 0000:00:1c.0: BAR 15: assigned [mem
0xd0300000-0xd04fffff 64bit pref]
[ 4652.009108] pcieport 0000:00:1c.2: BAR 15: assigned [mem
0xd0500000-0xd06fffff 64bit pref]
[ 4652.009116] pcieport 0000:00:1c.3: BAR 15: assigned [mem
0xd0700000-0xd08fffff 64bit pref]
[ 4652.009120] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[ 4652.009123] pcieport 0000:00:1c.2: BAR 13: assigned [io  0x5000-0x5fff=
]
[ 4652.009130] pci 0000:00:1c.0: PCI bridge to [bus 02]
[ 4652.009133] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[ 4652.009139] pci 0000:00:1c.0:   bridge window [mem 0xd0100000-0xd02fff=
ff]
[ 4652.009144] pci 0000:00:1c.0:   bridge window [mem
0xd0300000-0xd04fffff 64bit pref]
[ 4652.009485] pci_bus 0000:02: Allocating resources
[ 4652.009501] pci_bus 0000:04: Allocating resources
[ 4652.009662] pci_bus 0000:05: Allocating resources
[ 4652.009677] pci 0000:00:1c.0: PCI bridge to [bus 02]
[ 4652.009681] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[ 4652.009686] pci 0000:00:1c.0:   bridge window [mem 0xd0100000-0xd02fff=
ff]
[ 4652.009690] pci 0000:00:1c.0:   bridge window [mem
0xd0300000-0xd04fffff 64bit pref]
[ 4652.016344] done.
[ 4652.026605] Bluetooth: hci0: read Intel version: 370810011003110e00
[ 4652.026622] Bluetooth: hci0: Intel Bluetooth firmware file:
intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq
[ 4652.106569] psmouse serio1: synaptics: queried max coordinates: x
[..5676], y [..4732]
[ 4652.154455] psmouse serio1: synaptics: queried min coordinates: x
[1356..], y [1214..]
[ 4652.306668] Bluetooth: hci0: Intel Bluetooth firmware patch completed
and activated
[ 4653.584064] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 4653.586759] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[ 4653.587534] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[ 4653.811234] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[ 4653.811243] iwlwifi 0000:04:00.0: CSR values:
[ 4653.811247] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[ 4653.811365] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[ 4653.811425] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[ 4653.811484] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[ 4653.811643] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[ 4653.811701] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[ 4653.811757] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[ 4653.811812] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[ 4653.811868] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[ 4653.811923] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[ 4653.811978] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[ 4653.812033] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[ 4653.812088] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[ 4653.812154] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[ 4653.812302] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[ 4653.812352] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[ 4653.812403] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[ 4653.812454] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[ 4653.812506] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[ 4653.812557] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b7=
98a
[ 4653.812621] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[ 4653.812770] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[ 4653.812825] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
7f7
[ 4653.812880] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[ 4653.812935] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[ 4653.812939] iwlwifi 0000:04:00.0: FH register values:
[ 4653.813104] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0bc99d00
[ 4653.813169] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00bcd2b0
[ 4653.813234] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[ 4653.813299] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[ 4653.813365] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 4653.813430] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[ 4653.813495] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 4653.813560] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 4653.813625] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[ 4653.813790] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[ 4653.813794] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[ 4653.813798] iwlwifi 0000:04:00.0: Loaded firmware version: 16.242414.0=

[ 4653.813802] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[ 4653.813806] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[ 4653.813809] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[ 4653.813812] iwlwifi 0000:04:00.0: 0x00040312 | branchlink2
[ 4653.813815] iwlwifi 0000:04:00.0: 0x00040BD8 | interruptlink1
[ 4653.813819] iwlwifi 0000:04:00.0: 0x000059B8 | interruptlink2
[ 4653.813822] iwlwifi 0000:04:00.0: 0x00000000 | data1
[ 4653.813825] iwlwifi 0000:04:00.0: 0x00000002 | data2
[ 4653.813828] iwlwifi 0000:04:00.0: 0x07030000 | data3
[ 4653.813832] iwlwifi 0000:04:00.0: 0x003CB2D2 | beacon time
[ 4653.813835] iwlwifi 0000:04:00.0: 0x00034D2C | tsf low
[ 4653.813838] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[ 4653.813841] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[ 4653.813844] iwlwifi 0000:04:00.0: 0x00034D2D | time gp2
[ 4653.813848] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[ 4653.813851] iwlwifi 0000:04:00.0: 0x00000010 | uCode version major
[ 4653.813854] iwlwifi 0000:04:00.0: 0x0003B2EE | uCode version minor
[ 4653.813858] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[ 4653.813861] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[ 4653.813864] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[ 4653.813867] iwlwifi 0000:04:00.0: 0x00023080 | isr0
[ 4653.813871] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[ 4653.813874] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[ 4653.813877] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[ 4653.813880] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[ 4653.813884] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[ 4653.813887] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[ 4653.813890] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[ 4653.813893] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[ 4653.813896] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[ 4653.813900] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[ 4653.813903] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[ 4653.813906] iwlwifi 0000:04:00.0: 0x17111915 | timestamp
[ 4653.813909] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[ 4653.813965] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[ 4653.832833] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 4653.844685] r8169 0000:05:00.0 eth0: link down
[ 4653.844776] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 4653.852978] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[ 4653.853537] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[ 4654.077820] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[ 4654.077830] iwlwifi 0000:04:00.0: CSR values:
[ 4654.077834] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[ 4654.077935] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[ 4654.077993] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[ 4654.078048] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[ 4654.078104] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[ 4654.078159] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[ 4654.078214] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[ 4654.078270] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[ 4654.078325] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[ 4654.078380] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[ 4654.078435] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[ 4654.078554] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[ 4654.078713] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[ 4654.078771] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[ 4654.078831] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[ 4654.078990] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[ 4654.079050] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[ 4654.079210] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[ 4654.079371] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[ 4654.079529] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b7=
98a
[ 4654.079688] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[ 4654.079847] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[ 4654.079907] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
777
[ 4654.079966] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[ 4654.080024] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[ 4654.080029] iwlwifi 0000:04:00.0: FH register values:
[ 4654.080193] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0bc99d00
[ 4654.080261] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00bcd2b0
[ 4654.080329] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[ 4654.080398] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[ 4654.080466] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 4654.080533] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[ 4654.080598] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 4654.080663] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 4654.080728] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[ 4654.080893] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[ 4654.080898] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[ 4654.080901] iwlwifi 0000:04:00.0: Loaded firmware version: 16.242414.0=

[ 4654.080905] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[ 4654.080909] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[ 4654.080912] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[ 4654.080916] iwlwifi 0000:04:00.0: 0x00040312 | branchlink2
[ 4654.080919] iwlwifi 0000:04:00.0: 0x00040BD8 | interruptlink1
[ 4654.080922] iwlwifi 0000:04:00.0: 0x0000A87A | interruptlink2
[ 4654.080926] iwlwifi 0000:04:00.0: 0x00000000 | data1
[ 4654.080929] iwlwifi 0000:04:00.0: 0x00000002 | data2
[ 4654.080932] iwlwifi 0000:04:00.0: 0x07030000 | data3
[ 4654.080935] iwlwifi 0000:04:00.0: 0x003CB1F4 | beacon time
[ 4654.080938] iwlwifi 0000:04:00.0: 0x00034E0A | tsf low
[ 4654.080942] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[ 4654.080945] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[ 4654.080948] iwlwifi 0000:04:00.0: 0x00034E0B | time gp2
[ 4654.080951] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[ 4654.080955] iwlwifi 0000:04:00.0: 0x00000010 | uCode version major
[ 4654.080958] iwlwifi 0000:04:00.0: 0x0003B2EE | uCode version minor
[ 4654.080961] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[ 4654.080964] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[ 4654.080968] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[ 4654.080971] iwlwifi 0000:04:00.0: 0x00023080 | isr0
[ 4654.080974] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[ 4654.080977] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[ 4654.080980] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[ 4654.080984] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[ 4654.080987] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[ 4654.080990] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[ 4654.080994] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[ 4654.080997] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[ 4654.081000] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[ 4654.081003] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[ 4654.081006] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[ 4654.081010] iwlwifi 0000:04:00.0: 0x17111915 | timestamp
[ 4654.081013] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[ 4654.081037] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[ 4654.086786] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[ 4654.087348] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[ 4654.311307] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[ 4654.311316] iwlwifi 0000:04:00.0: CSR values:
[ 4654.311320] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[ 4654.311432] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[ 4654.311488] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[ 4654.311546] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[ 4654.311603] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[ 4654.311658] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[ 4654.311714] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[ 4654.311770] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[ 4654.311826] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[ 4654.311896] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[ 4654.312057] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[ 4654.312206] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[ 4654.312262] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[ 4654.312317] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[ 4654.312372] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[ 4654.312427] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[ 4654.312482] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[ 4654.312538] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[ 4654.312592] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[ 4654.312648] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X880b7=
98a
[ 4654.312703] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[ 4654.312758] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[ 4654.312813] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
f77
[ 4654.312868] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[ 4654.312923] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[ 4654.312926] iwlwifi 0000:04:00.0: FH register values:
[ 4654.312993] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0bc99d00
[ 4654.313217] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00bcd2b0
[ 4654.313281] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[ 4654.313347] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[ 4654.313412] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 4654.313477] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[ 4654.313543] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 4654.313607] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 4654.313672] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[ 4654.313840] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[ 4654.313845] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[ 4654.313850] iwlwifi 0000:04:00.0: Loaded firmware version: 16.242414.0=

[ 4654.313854] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[ 4654.313858] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[ 4654.313862] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[ 4654.313865] iwlwifi 0000:04:00.0: 0x00040312 | branchlink2
[ 4654.313870] iwlwifi 0000:04:00.0: 0x00040BD8 | interruptlink1
[ 4654.313874] iwlwifi 0000:04:00.0: 0x000059B2 | interruptlink2
[ 4654.313878] iwlwifi 0000:04:00.0: 0x00000000 | data1
[ 4654.313882] iwlwifi 0000:04:00.0: 0x00000002 | data2
[ 4654.313886] iwlwifi 0000:04:00.0: 0x07030000 | data3
[ 4654.313890] iwlwifi 0000:04:00.0: 0x003CB269 | beacon time
[ 4654.313894] iwlwifi 0000:04:00.0: 0x00034D95 | tsf low
[ 4654.313898] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[ 4654.313902] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[ 4654.313906] iwlwifi 0000:04:00.0: 0x00034D96 | time gp2
[ 4654.313910] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[ 4654.313913] iwlwifi 0000:04:00.0: 0x00000010 | uCode version major
[ 4654.313915] iwlwifi 0000:04:00.0: 0x0003B2EE | uCode version minor
[ 4654.313918] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[ 4654.313920] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[ 4654.313923] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[ 4654.313925] iwlwifi 0000:04:00.0: 0x00023080 | isr0
[ 4654.313928] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[ 4654.313930] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[ 4654.313932] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[ 4654.313935] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[ 4654.313937] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[ 4654.313939] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[ 4654.313942] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[ 4654.313944] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[ 4654.313947] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[ 4654.313949] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[ 4654.313951] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[ 4654.313954] iwlwifi 0000:04:00.0: 0x17111915 | timestamp
[ 4654.313956] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[ 4654.313999] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5


This is the downstream bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1588637


--FCOKXQJ7nUQpms6A6rHtGkpxvVjTb0N2d--

--NluE3EJEkk6mKRgHFIP22bHcj3teQrn7U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXgg5UAAoJEIOFK7hVFsHHJhsIAJh9QrhxRKkhkptnJqsJv6Lj
e8uikZBZgOxl1iCStJo26++ehA0Wp0WItjlsGs/pQ0KD5ZEaOeji8Iz7GTPeQ1AH
enspb+LLJu+k77w/GIW5u2adP6JiFJVTVEEVTpk39KxCUNdC6Y2BX3LmLDocgeuG
/FhNow8aHIkhPC1/EciBvLjB6yldVp9szXY8LygMcomJTdDyBqrhbCqlF0RvLzlZ
rrJfHIjmSn0Th7WdvAryF5JCMZ10Rucigy9lR/Sd25Ct8BQMnGVIF1m66sU7JOoB
5a0NPM6Xkvw7iljR3phLSN3YodAgIqqtbKNP9VbTkr6zDFA8Wo/8dytQX0/jziU=
=bCmR
-----END PGP SIGNATURE-----

--NluE3EJEkk6mKRgHFIP22bHcj3teQrn7U--
