Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35386 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbcFYUPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 16:15:22 -0400
Received: by mail-io0-f196.google.com with SMTP id u25so19803813iou.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 13:15:21 -0700 (PDT)
MIME-Version: 1.0
From: Cruz Fernandez <cruz.fernandez@gmail.com>
Date: Sat, 25 Jun 2016 17:15:19 -0300
Message-ID: <CACWN4cB+Tj93PkTVkZ89M=gAB_7zdDoprTDDodfpfAdsezH_zw@mail.gmail.com> (sfid-20160625_221528_814471_73EE5FFF)
Subject: PROBLEM: Broadcom Corporation BCM43602 - wrong icon after first resume
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
	hante.meuleman@broadcom.com, brett.rudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1.] Broadcom Corporation BCM43602 - wrong icon after resume
[2.] After suspending and resuming the cabled icon is shown instead of
wifi. The WiFi still works.

On startup it shows some strange errors on dmesg:
Bluetooth: hci0: BCM20703A1
Bluetooth: hci0: BCM (001.001.005) build 0000
IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
brcmf_add_if: ERROR: netdev:wlp2s0 already exists
brcmf_add_if: ignore IF event
IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
brcmf_add_if: ERROR: netdev:wlp2s0 already exists
brcmf_add_if: ignore IF event
IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready

After another resume, the problem is fixed

Some people think the network manager is detecting the wifi adapter as
"PCI ethernet". (from similar non-working errors)
[3.]
[4.] cat /proc/version
Linux version 4.7.0-040700rc4-generic (kernel@gloin) (gcc version
5.4.0 20160609 (Ubuntu 5.4.0-4ubuntu1) ) #201606201235 SMP Mon Jun 20
16:38:03 UTC 2016
[5.]
[6.]
[7.] lsb_release -rd
Description: Ubuntu 16.04 LTS
Release: 16.04
[7.1] /usr/src/linux-headers-4.7.0-040700rc4/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux cruz-XPS-15-9550 4.7.0-040700rc4-generic #201606201235 SMP Mon
Jun 20 16:38:03 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

GNU C 5.3.1
GNU Make 4.1
Binutils 2.26
Util-linux 2.27.1
Mount 2.27.1
Module-init-tools 22
E2fsprogs 1.42.13
Pcmciautils 018
PPP 2.4.7
Linux C Library 2.23
Dynamic linker (ldd) 2.23
Linux C++ Library 6.0.21
Procps 3.3.10
Net-tools 1.60
Kbd 1.15.5
Console-tools 1.15.5
Sh-utils 8.25
Udev 229
Wireless-tools 30
Modules Loaded ablk_helper ac acpi_als acpi_pad acpi_thermal_rel
aesni_intel aes_x86_64 agpgart ahci autofs4 battery bbswitch
binfmt_misc bluetooth bnep brcmfmac brcmutil btbcm btintel btqca btrtl
btusb button cfg80211 coretemp crc16 crc32c_intel crc32_pclmul
crct10dif_pclmul cryptd dcdbas dell_laptop dell_led dell_smbios
dell_smo8800 dell_wmi drm drm_kms_helper efi_pstore efivarfs efivars
ext4 fan fat fb_sys_fops fjes fuse gf128mul ghash_clmulni_intel
glue_helper hci_uart hid hid_multitouch i2c_algo_bit
i2c_designware_core i2c_designware_platform i2c_hid i915 idma64
industrialio input_leds int3400_thermal int3402_thermal
int3403_thermal int340x_thermal_zone intel_gtt intel_hid intel_lpss
intel_lpss_acpi intel_lpss_pci intel_powerclamp intel_soc_dts_iosf
irqbypass jbd2 joydev kfifo_buf kvm kvm_intel led_class libahci libata
lp lrw mac_hid mbcache media mei mei_me memstick msr mxm_wmi
nls_iso8859_1 nvme nvme_core nvram parport parport_pc pci_stub
pinctrl_intel pinctrl_sunrisepoint ppdev processor_thermal_device
psmouse rfcomm rtsx_pci rtsx_pci_ms rtsx_pci_sdmmc scsi_mod serio_raw
shpchp snd snd_hda_codec snd_hda_codec_generic snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_core snd_hda_intel snd_hwdep snd_pcm
snd_rawmidi snd_seq snd_seq_device snd_seq_midi snd_seq_midi_event
snd_timer soundcore sparse_keymap syscopyarea sysfillrect sysimgblt
thermal usb_common usbcore usbhid uvcvideo vboxdrv vboxnetadp
vboxnetflt vboxpci vfat video videobuf2_core videobuf2_memops
videobuf2_v4l2 videobuf2_vmalloc videodev virt_dma wmi
x86_pkg_temp_thermal xhci_hcd xhci_pci

[7.2] cat /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5183.87
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 1
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5184.79
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 800.122
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 2
cpu cores : 4
apicid : 4
initial apicid : 4
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5184.84
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 3
cpu cores : 4
apicid : 6
initial apicid : 6
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5184.82
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 4
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 0
cpu cores : 4
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5185.16
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 5
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 1
cpu cores : 4
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5184.89
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 6
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 2
cpu cores : 4
apicid : 5
initial apicid : 5
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5184.86
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 7
vendor_id : GenuineIntel
cpu family : 6
model : 94
model name : Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
stepping : 3
microcode : 0x84
cpu MHz : 799.963
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 3
cpu cores : 4
apicid : 7
initial apicid : 7
fpu : yes
fpu_exception : yes
cpuid level : 22
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority
ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 dtherm ida arat
pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs :
bogomips : 5184.87
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

[7.3] cat /proc/modules
rfcomm 69632 2 - Live 0x0000000000000000
fuse 102400 3 - Live 0x0000000000000000
nvram 16384 0 - Live 0x0000000000000000
msr 16384 0 - Live 0x0000000000000000
pci_stub 16384 1 - Live 0x0000000000000000
vboxpci 24576 0 - Live 0x0000000000000000 (OE)
vboxnetadp 28672 0 - Live 0x0000000000000000 (OE)
vboxnetflt 28672 0 - Live 0x0000000000000000 (OE)
vboxdrv 487424 3 vboxpci,vboxnetadp,vboxnetflt, Live 0x0000000000000000 (OE)
bbswitch 16384 0 - Live 0x0000000000000000 (OE)
bnep 20480 2 - Live 0x0000000000000000
uvcvideo 90112 0 - Live 0x0000000000000000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
videobuf2_v4l2 24576 1 uvcvideo, Live 0x0000000000000000
videobuf2_core 40960 2 uvcvideo,videobuf2_v4l2, Live 0x0000000000000000
btusb 45056 0 - Live 0x0000000000000000
videodev 180224 3 uvcvideo,videobuf2_v4l2,videobuf2_core, Live
0x0000000000000000
btrtl 16384 1 btusb, Live 0x0000000000000000
media 40960 2 uvcvideo,videodev, Live 0x0000000000000000
hid_multitouch 20480 0 - Live 0x0000000000000000
binfmt_misc 20480 1 - Live 0x0000000000000000
nls_iso8859_1 16384 1 - Live 0x0000000000000000
vfat 20480 1 - Live 0x0000000000000000
fat 69632 1 vfat, Live 0x0000000000000000
snd_hda_codec_hdmi 45056 1 - Live 0x0000000000000000
dell_led 16384 1 - Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
snd_hda_codec_generic 73728 1 snd_hda_codec_realtek, Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
i2c_designware_platform 16384 0 - Live 0x0000000000000000
kvm_intel 192512 0 - Live 0x0000000000000000
i2c_designware_core 20480 1 i2c_designware_platform, Live 0x0000000000000000
kvm 581632 1 kvm_intel, Live 0x0000000000000000
dell_wmi 16384 0 - Live 0x0000000000000000
mxm_wmi 16384 0 - Live 0x0000000000000000
snd_hda_intel 36864 3 - Live 0x0000000000000000
snd_hda_codec 135168 4
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,
Live 0x0000000000000000
dell_laptop 20480 0 - Live 0x0000000000000000
snd_hda_core 86016 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,
Live 0x0000000000000000
dell_smbios 16384 3 dell_led,dell_wmi,dell_laptop, Live 0x0000000000000000
dcdbas 16384 1 dell_smbios, Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
snd_pcm 110592 4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda_core, Live
0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
aesni_intel 167936 0 - Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
brcmfmac 303104 0 - Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
gf128mul 16384 1 lrw, Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
led_class 16384 3 dell_led,dell_laptop,input_leds, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
brcmutil 16384 1 brcmfmac, Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
cryptd 20480 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
efi_pstore 16384 0 - Live 0x0000000000000000
cfg80211 581632 1 brcmfmac, Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
snd 81920 17 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
efivars 20480 1 efi_pstore, Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
rtsx_pci_ms 20480 0 - Live 0x0000000000000000
memstick 20480 1 rtsx_pci_ms, Live 0x0000000000000000
hci_uart 86016 0 - Live 0x0000000000000000
idma64 20480 0 - Live 0x0000000000000000
btbcm 16384 2 btusb,hci_uart, Live 0x0000000000000000
mei_me 32768 0 - Live 0x0000000000000000
btqca 16384 1 hci_uart, Live 0x0000000000000000
virt_dma 16384 1 idma64, Live 0x0000000000000000
mei 102400 1 mei_me, Live 0x0000000000000000
btintel 16384 2 btusb,hci_uart, Live 0x0000000000000000
processor_thermal_device 16384 0 - Live 0x0000000000000000
intel_lpss_pci 16384 0 - Live 0x0000000000000000
shpchp 36864 0 - Live 0x0000000000000000
intel_soc_dts_iosf 16384 1 processor_thermal_device, Live 0x0000000000000000
bluetooth 524288 33
rfcomm,bnep,btusb,btrtl,hci_uart,btbcm,btqca,btintel, Live
0x0000000000000000
int3403_thermal 16384 0 - Live 0x0000000000000000
dell_smo8800 16384 0 - Live 0x0000000000000000
wmi 16384 3 dell_led,dell_wmi,mxm_wmi, Live 0x0000000000000000
intel_lpss_acpi 16384 0 - Live 0x0000000000000000
intel_lpss 16384 2 intel_lpss_pci,intel_lpss_acpi, Live 0x0000000000000000
int3400_thermal 16384 0 - Live 0x0000000000000000
int3402_thermal 16384 0 - Live 0x0000000000000000
acpi_thermal_rel 16384 1 int3400_thermal, Live 0x0000000000000000
intel_hid 16384 0 - Live 0x0000000000000000
int340x_thermal_zone 16384 3
processor_thermal_device,int3403_thermal,int3402_thermal, Live
0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
sparse_keymap 16384 2 dell_wmi,intel_hid, Live 0x0000000000000000
ac 16384 0 - Live 0x0000000000000000
acpi_pad 180224 0 - Live 0x0000000000000000
acpi_als 16384 0 - Live 0x0000000000000000
battery 20480 0 - Live 0x0000000000000000
kfifo_buf 16384 1 acpi_als, Live 0x0000000000000000
industrialio 65536 2 acpi_als,kfifo_buf, Live 0x0000000000000000
parport_pc 32768 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 49152 3 parport_pc,ppdev,lp, Live 0x0000000000000000
efivarfs 16384 1 - Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
ext4 602112 1 - Live 0x0000000000000000
crc16 16384 2 bluetooth,ext4, Live 0x0000000000000000
jbd2 110592 1 ext4, Live 0x0000000000000000
mbcache 16384 2 ext4, Live 0x0000000000000000
usbhid 49152 0 - Live 0x0000000000000000
rtsx_pci_sdmmc 24576 0 - Live 0x0000000000000000
i915 1306624 6 - Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
crc32c_intel 24576 0 - Live 0x0000000000000000
drm_kms_helper 155648 1 i915, Live 0x0000000000000000
ahci 36864 0 - Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
psmouse 131072 0 - Live 0x0000000000000000
xhci_pci 16384 0 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
xhci_hcd 176128 1 xhci_pci, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
libata 245760 2 ahci,libahci, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
drm 368640 7 i915,drm_kms_helper, Live 0x0000000000000000
usbcore 245760 6 uvcvideo,btusb,brcmfmac,usbhid,xhci_pci,xhci_hcd,
Live 0x0000000000000000
scsi_mod 233472 1 libata, Live 0x0000000000000000
nvme 28672 3 - Live 0x0000000000000000
rtsx_pci 53248 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0x0000000000000000
nvme_core 53248 5 nvme, Live 0x0000000000000000
intel_gtt 20480 1 i915, Live 0x0000000000000000
usb_common 16384 1 usbcore, Live 0x0000000000000000
agpgart 45056 2 drm,intel_gtt, Live 0x0000000000000000
fan 16384 0 - Live 0x0000000000000000
thermal 20480 0 - Live 0x0000000000000000
i2c_hid 20480 0 - Live 0x0000000000000000
hid 122880 3 hid_multitouch,usbhid,i2c_hid, Live 0x0000000000000000
pinctrl_sunrisepoint 28672 0 - Live 0x0000000000000000
video 40960 3 dell_wmi,dell_laptop,i915, Live 0x0000000000000000
pinctrl_intel 20480 1 pinctrl_sunrisepoint, Live 0x0000000000000000
button 16384 1 i915, Live 0x0000000000000000
fjes 28672 0 - Live 0x0000000000000000

[7.4] cat /proc/ioports
cat /proc/iomem
0000-0000 : PCI Bus 0000:00
  0000-0000 : dma1
  0000-0000 : pic1
  0000-0000 : timer0
  0000-0000 : timer1
  0000-0000 : keyboard
  0000-0000 : keyboard
  0000-0000 : rtc0
  0000-0000 : dma page reg
  0000-0000 : pic2
  0000-0000 : dma2
  0000-0000 : fpu
    0000-0000 : PNP0C04:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:01
  0000-0000 : PNP0C09:00
    0000-0000 : EC data
  0000-0000 : PNP0C09:00
    0000-0000 : EC cmd
0000-0000 : PCI conf1
0000-0000 : PCI Bus 0000:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
    0000-0000 : ACPI PM1a_EVT_BLK
    0000-0000 : ACPI PM1a_CNT_BLK
    0000-0000 : ACPI PM_TMR
    0000-0000 : ACPI PM2_CNT_BLK
    0000-0000 : pnp 00:03
    0000-0000 : ACPI GPE0_BLK
  0000-0000 : PCI Bus 0000:06
  0000-0000 : PCI Bus 0000:04
    0000-0000 : 0000:04:00.0
  0000-0000 : PCI Bus 0000:03
  0000-0000 : PCI Bus 0000:01
    0000-0000 : 0000:01:00.0
  0000-0000 : 0000:00:02.0
  0000-0000 : 0000:00:1f.4
  0000-0000 : 0000:00:17.0
    0000-0000 : ahci
  0000-0000 : 0000:00:17.0
    0000-0000 : ahci
  0000-0000 : 0000:00:17.0
    0000-0000 : ahci
  0000-0000 : pnp 00:08
  0000-0000 : pnp 00:00
    0000-0000 : pnp 00:00
      0000-0000 : pnp 00:00
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : System ROM
00000000-00000000 : System RAM
  00000000-00000000 : Kernel code
  00000000-00000000 : Kernel data
  00000000-00000000 : Kernel bss
00000000-00000000 : ACPI Tables
00000000-00000000 : System RAM
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : ACPI Tables
00000000-00000000 : System RAM
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : reserved
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : RAM buffer
00000000-00000000 : reserved
  00000000-00000000 : Graphics Stolen Memory
00000000-00000000 : PCI Bus 0000:00
  00000000-00000000 : 0000:00:02.0
  00000000-00000000 : PCI Bus 0000:06
  00000000-00000000 : PCI Bus 0000:01
    00000000-00000000 : 0000:01:00.0
    00000000-00000000 : 0000:01:00.0
  00000000-00000000 : PCI Bus 0000:03
  00000000-00000000 : PCI Bus 0000:06
  00000000-00000000 : 0000:00:02.0
  00000000-00000000 : PCI Bus 0000:01
    00000000-00000000 : 0000:01:00.0
    00000000-00000000 : 0000:01:00.0
  00000000-00000000 : 0000:00:1f.3
    00000000-00000000 : ICH HD audio
  00000000-00000000 : 0000:00:14.0
    00000000-00000000 : xhci-hcd
  00000000-00000000 : 0000:00:04.0
  00000000-00000000 : 0000:00:1f.3
    00000000-00000000 : ICH HD audio
  00000000-00000000 : 0000:00:1f.2
  00000000-00000000 : 0000:00:17.0
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:1f.4
  00000000-00000000 : 0000:00:17.0
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:17.0
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:16.0
    00000000-00000000 : mei_me
  00000000-00000000 : 0000:00:15.1
    00000000-00000000 : lpss_dev
      00000000-00000000 : lpss_dev
    00000000-00000000 : lpss_priv
    00000000-00000000 : idma64.1
      00000000-00000000 : idma64.1
  00000000-00000000 : 0000:00:15.0
    00000000-00000000 : lpss_dev
      00000000-00000000 : lpss_dev
    00000000-00000000 : lpss_priv
    00000000-00000000 : idma64.0
      00000000-00000000 : idma64.0
  00000000-00000000 : 0000:00:14.2
  00000000-00000000 : PCI Bus 0000:02
    00000000-00000000 : 0000:02:00.0
    00000000-00000000 : 0000:02:00.0
  00000000-00000000 : PCI Bus 0000:03
    00000000-00000000 : 0000:03:00.0
      00000000-00000000 : rtsx_pci
  00000000-00000000 : PCI Bus 0000:04
    00000000-00000000 : 0000:04:00.0
      00000000-00000000 : nvme
  00000000-00000000 : pnp 00:06
00000000-00000000 : PCI MMCONFIG 0000 [bus 00-ff]
  00000000-00000000 : reserved
    00000000-00000000 : pnp 00:06
00000000-00000000 : PCI Bus 0000:00
  00000000-00000000 : pnp 00:07
  00000000-00000000 : pnp 00:09
  00000000-00000000 : pnp 00:07
  00000000-00000000 : pnp 00:09
  00000000-00000000 : pnp 00:09
  00000000-00000000 : pnp 00:07
  00000000-00000000 : reserved
  00000000-00000000 : pnp 00:07
  00000000-00000000 : pnp 00:07
  00000000-00000000 : pnp 00:07
00000000-00000000 : reserved
  00000000-00000000 : IOAPIC 0
00000000-00000000 : HPET 0
  00000000-00000000 : PNP0103:00
00000000-00000000 : pnp 00:06
00000000-00000000 : pnp 00:06
00000000-00000000 : pnp 00:06
00000000-00000000 : pnp 00:06
00000000-00000000 : TPM
00000000-00000000 : pnp 00:06
00000000-00000000 : dmar0
00000000-00000000 : dmar1
00000000-00000000 : Local APIC
  00000000-00000000 : reserved
00000000-00000000 : reserved
  00000000-00000000 : INT0800:00
    00000000-00000000 : pnp 00:06
00000000-00000000 : System RAM
00000000-00000000 : RAM buffer

[7.5] sudo lspci -vvv
00:00.0 Host bridge: Intel Corporation Sky Lake Host Bridge/DRAM
Registers (rev 07)
Subsystem: Dell Skylake Host Bridge/DRAM Registers
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=10 <?>

00:01.0 PCI bridge: Intel Corporation Sky Lake PCIe Controller (x16)
(rev 07) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 122
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: dc000000-dd0fffff
Prefetchable memory behind bridge: 00000000b0000000-00000000c1ffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [88] Subsystem: Dell Skylake PCIe Controller (x16)
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable+ Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<256ns, L1 <8us
ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled+ CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+, OBFF
Via WAKE# ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Via
WAKE# ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending+ InProgress-
Capabilities: [140 v1] Root Complex Link
Desc: PortNumber=02 ComponentID=01 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed19000
Capabilities: [d94 v1] #19
Kernel driver in use: pcieport
Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation Skylake
Integrated Graphics (rev 06) (prog-if 00 [VGA controller])
DeviceName:  Onboard IGD
Subsystem: Dell Skylake Integrated Graphics
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 127
Region 0: Memory at db000000 (64-bit, non-prefetchable) [size=16M]
Region 2: Memory at 70000000 (64-bit, prefetchable) [size=256M]
Region 4: I/O ports at f000 [size=64]
[virtual] Expansion ROM at 000c0000 [disabled] [size=128K]
Capabilities: [40] Vendor Specific Information: Len=0c <?>
Capabilities: [70] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
Capabilities: [ac] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00018  Data: 0000
Capabilities: [d0] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] #1b
Capabilities: [200 v1] Address Translation Service (ATS)
ATSCap: Invalidate Queue Depth: 00
ATSCtl: Enable-, Smallest Translation Unit: 00
Capabilities: [300 v1] #13
Kernel driver in use: i915
Kernel modules: i915

00:04.0 Signal processing controller: Intel Corporation Skylake
Processor Thermal Subsystem (rev 07)
Subsystem: Dell Skylake Processor Thermal Subsystem
Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 16
Region 0: Memory at dd120000 (64-bit, non-prefetchable) [size=32K]
Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [d0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [e0] Vendor Specific Information: Len=0c <?>
Kernel driver in use: proc_thermal
Kernel modules: processor_thermal_device

00:14.0 USB controller: Intel Corporation Sunrise Point-H USB 3.0 xHCI
Controller (rev 31) (prog-if 30 [XHCI])
Subsystem: Dell Sunrise Point-H USB 3.0 xHCI Controller
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 125
Region 0: Memory at dd110000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [70] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
Address: 00000000fee002b8  Data: 0000
Kernel driver in use: xhci_hcd
Kernel modules: xhci_pci

00:14.2 Signal processing controller: Intel Corporation Sunrise
Point-H Thermal subsystem (rev 31)
Subsystem: Dell Sunrise Point-H Thermal subsystem
Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin C routed to IRQ 255
Region 0: Memory at dd138000 (64-bit, non-prefetchable) [size=4K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000

00:15.0 Signal processing controller: Intel Corporation Sunrise
Point-H LPSS I2C Controller #0 (rev 31)
Subsystem: Dell Sunrise Point-H Serial IO I2C Controller
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Region 0: Memory at dd137000 (64-bit, non-prefetchable) [size=4K]
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] Vendor Specific Information: Len=14 <?>
Kernel driver in use: intel-lpss
Kernel modules: intel_lpss_pci

00:15.1 Signal processing controller: Intel Corporation Sunrise
Point-H LPSS I2C Controller #1 (rev 31)
Subsystem: Dell Sunrise Point-H Serial IO I2C Controller
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 17
Region 0: Memory at dd136000 (64-bit, non-prefetchable) [size=4K]
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] Vendor Specific Information: Len=14 <?>
Kernel driver in use: intel-lpss
Kernel modules: intel_lpss_pci

00:16.0 Communication controller: Intel Corporation Sunrise Point-H
CSME HECI #1 (rev 31)
Subsystem: Dell Sunrise Point-H CSME HECI
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 124
Region 0: Memory at dd135000 (64-bit, non-prefetchable) [size=4K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00298  Data: 0000
Kernel driver in use: mei_me
Kernel modules: mei_me

00:17.0 SATA controller: Intel Corporation Sunrise Point-H SATA
Controller [AHCI mode] (rev 31) (prog-if 01 [AHCI 1.0])
Subsystem: Dell Sunrise Point-H SATA Controller [AHCI mode]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 126
Region 0: Memory at dd130000 (32-bit, non-prefetchable) [size=8K]
Region 1: Memory at dd134000 (32-bit, non-prefetchable) [size=256]
Region 2: I/O ports at f090 [size=8]
Region 3: I/O ports at f080 [size=4]
Region 4: I/O ports at f060 [size=32]
Region 5: Memory at dd133000 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee002d8  Data: 0000
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
Kernel driver in use: ahci
Kernel modules: ahci

00:1c.0 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root
Port #1 (rev f1) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: dd400000-dd8fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 256 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 8GT/s, Width x1, ASPM L1, Exit Latency L0s <1us, L1 <16us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Dell Sunrise Point-H PCI Express Root Port
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd-
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [220 v1] #19
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root
Port #2 (rev f1) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 17
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: dda00000-de3fffff
Prefetchable memory behind bridge: 00000000c2100000-00000000c2afffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #2, Speed 8GT/s, Width x1, ASPM L1, Exit Latency L0s <1us, L1 <16us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not
Supported ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Dell Sunrise Point-H PCI Express Root Port
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt+ RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd-
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [220 v1] #19
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1d.0 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root
Port #9 (rev f1) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: de400000-de4fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #9, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L0s <1us, L1 <16us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 8GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #12, PowerLimit 25.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not
Supported ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+,
EqualizationPhase1+
EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Dell Sunrise Point-H PCI Express Root Port
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd-
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [200 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
Capabilities: [220 v1] #19
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1d.4 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root
Port #13 (rev f1) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #13, Speed 8GT/s, Width x2, ASPM L0s L1, Exit Latency L0s
<1us, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train+ SlotClk+ DLActive-
BWMgmt- ABWMgmt-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Via
WAKE# ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Dell Sunrise Point-H PCI Express Root Port
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1d.6 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root
Port #15 (rev f1) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 18
Bus: primary=00, secondary=06, subordinate=3e, sec-latency=0
I/O behind bridge: 00002000-00002fff
Memory behind bridge: c4000000-da0fffff
Prefetchable memory behind bridge: 0000000080000000-00000000a1ffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #15, Speed 8GT/s, Width x2, ASPM L0s L1, Exit Latency L0s
unlimited, L1 <16us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train+ SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #18, PowerLimit 25.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not
Supported ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Dell Sunrise Point-H PCI Express Root Port
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt+ RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd-
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [200 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
Capabilities: [220 v1] #19
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1f.0 ISA bridge: Intel Corporation Sunrise Point-H LPC Controller (rev 31)
Subsystem: Dell Sunrise Point-H LPC Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:1f.2 Memory controller: Intel Corporation Sunrise Point-H PMC (rev 31)
Subsystem: Dell Sunrise Point-H PMC
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Region 0: Memory at dd12c000 (32-bit, non-prefetchable) [disabled] [size=16K]

00:1f.3 Audio device: Intel Corporation Sunrise Point-H HD Audio (rev
31) (prog-if 80)
Subsystem: Dell Sunrise Point-H HD Audio
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32
Interrupt: pin A routed to IRQ 128
Region 0: Memory at dd128000 (64-bit, non-prefetchable) [size=16K]
Region 4: Memory at dd100000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee002f8  Data: 0000
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

00:1f.4 SMBus: Intel Corporation Sunrise Point-H SMBus (rev 31)
Subsystem: Dell Sunrise Point-H SMBus
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 255
Region 0: Memory at dd132000 (64-bit, non-prefetchable) [size=256]
Region 4: I/O ports at f040 [size=32]
Kernel modules: i2c_i801

01:00.0 3D controller: NVIDIA Corporation GM107M [GeForce GTX 960M]
(rev ff) (prog-if ff)
!!! Unknown header type 7f
Kernel modules: nvidiafb, nouveau, nvidia_361

02:00.0 Network controller: Broadcom Corporation BCM43602 802.11ac
Wireless LAN SoC (rev 01)
Subsystem: Dell BCM43602 802.11ac Wireless LAN SoC
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 137
Region 0: Memory at dd800000 (64-bit, non-prefetchable) [size=32K]
Region 2: Memory at dd400000 (64-bit, non-prefetchable) [size=4M]
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
Capabilities: [58] MSI: Enable+ Count=1/16 Maskable- 64bit+
Address: 00000000fee00438  Data: 0000
Capabilities: [68] Vendor Specific Information: Len=44 <?>
Capabilities: [ac] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
MaxPayload 256 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <2us, L1 <32us
ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Via WAKE#
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover+ Timeout+ NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [13c v1] Device Serial Number 70-ad-32-ff-ff-f7-18-4f
Capabilities: [150 v1] Power Budgeting <?>
Capabilities: [160 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [1b0 v1] Latency Tolerance Reporting
Max snoop latency: 71680ns
Max no snoop latency: 71680ns
Capabilities: [220 v1] #15
Capabilities: [240 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=0us PortTPowerOnTime=50us
Kernel driver in use: brcmfmac
Kernel modules: brcmfmac

03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS525A PCI Express Card Reader (rev 01)
Subsystem: Dell RTS525A PCI Express Card Reader
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 123
Region 1: Memory at dda00000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00278  Data: 0000
Capabilities: [b0] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
unlimited, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF
Via message/WAKE#
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [148 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
Capabilities: [158 v1] Latency Tolerance Reporting
Max snoop latency: 3145728ns
Max no snoop latency: 3145728ns
Capabilities: [160 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=60us PortTPowerOnTime=60us
Kernel driver in use: rtsx_pci
Kernel modules: rtsx_pci

04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd
NVMe SSD Controller (rev 01) (prog-if 02 [NVM Express])
Subsystem: Samsung Electronics Co Ltd NVMe SSD Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Region 0: Memory at de400000 (64-bit, non-prefetchable) [size=16K]
Region 2: I/O ports at c000 [size=256]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [70] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L0s <4us, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 8GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+,
EqualizationPhase1+
EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
Capabilities: [b0] MSI-X: Enable+ Count=9 Masked-
Vector table: BAR=0 offset=00003000
PBA: BAR=0 offset=00002000
Capabilities: [100 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [148 v1] Device Serial Number 00-00-00-00-00-00-00-00
Capabilities: [158 v1] Power Budgeting <?>
Capabilities: [168 v1] #19
Capabilities: [188 v1] Latency Tolerance Reporting
Max snoop latency: 3145728ns
Max no snoop latency: 3145728ns
Capabilities: [190 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=10us PortTPowerOnTime=10us
Kernel driver in use: nvme
Kernel modules: nvme

[7.6] cat /proc/scsi/scsi
Attached devices:

[7.7] My computer is a Dell XPS 15 9550.
ls /proc
1     1363  162   1727  1836  1988  2106  2209  2652  3042  3512  389
 4454  58   740  902        diskstats    kpagecount    softirqs
10    1389  1627  1735  1839  1994  211   2246  27    3056  3590  3893
 4455  580  786  906        dma          kpageflags    stat
1012  14    163   1738  1842  1995  2118  2280  2704  3077  36    39
 446   59   792  91         driver       loadavg       swaps
1052  144   164   1740  1845  1996  212   2289  2739  31    3649  3938
 45    60   798  92         execdomains  locks         sys
1056  1445  165   1744  1846  1998  2123  2290  276   3102  3657  3939
 4557  606  8    987        fb           meminfo       sysrq-trigger
107   149   168   1749  1869  2     213   2291  2774  3110  3661  3955
 46    61   803  989        filesystems  misc          sysvipc
1076  1496  1680  1762  1871  20    2136  2361  2775  32    37    4
 48    62   815  996        fs           modules       thread-self
108   15    1684  1782  19    2005  214   2369  28    33    3792  40
 482   63   816  acpi       interrupts   mounts        timer_list
1094  152   1688  1784  1903  2027  2147  2378  2950  3304  3797  4128
 49    64   829  asound     iomem        mtrr          timer_stats
11    1522  169   1790  1918  2032  215   24    2969  3306  38    4187
 5     65   832  buddyinfo  ioports      net           tty
1104  1525  1693  1791  1926  2042  216   2475  2990  3312  3807  42
 50    66   836  bus        irq          pagetypeinfo  uptime
1112  1531  1703  1796  1945  2050  217   249   3     3336  3814  4276
 51    67   838  cgroups    kallsyms     partitions    version
12    155   1709  18    1949  2054  2175  25    30    3345  3827  4279
 52    68   842  cmdline    kcore        sched_debug   vmallocinfo
1277  158   171   1811  1975  2067  219   255   3004  3372  3828  4292
 54    7    865  consoles   keys         schedstat     vmstat
13    16    1710  1831  1978  2091  22    2582  3008  3391  3830  43
 55    72   89   cpuinfo    key-users    scsi          zoneinfo
1335  1607  1717  1832  1983  21    220   2588  3015  34    384   4307
 56    73   893  crypto     kmsg         self
1361  1615  172   1833  1984  210   2204  26    3017  348   3842  44
 57    74   9    devices    kpagecgroup  slabinfo

[X.]
