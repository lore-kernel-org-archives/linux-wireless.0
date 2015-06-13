Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34398 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbbFMPL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 11:11:57 -0400
Received: by obbsn1 with SMTP id sn1so39355586obb.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 08:11:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 13 Jun 2015 17:11:56 +0200
Message-ID: <CAOG=UibYbTg4vCUi77DMau9w3Bs2-fKPArzCAMUzesDhMawCDQ@mail.gmail.com> (sfid-20150613_171203_835913_B9DE9BA0)
Subject: 10ec:b723 Realtek RTL8723BE wireless card drops connection
From: Arnaud LE CAM <arnaudlecam@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1] One line summary of the problem:
10ec:b723 Realtek RTL8723BE wireless card drops connection in Linux
kernel 3.19.0-18

[2.] Full description of the problem/report:
wireless connection drops randomly and reconnects every 600 sec :
- in mode 802.11n, with the folowing options passed to rtl8723be.ko : fwlps=1.
- in mode 802.11g, with the folowing options passed to rtl8723be.ko :
fwlps=1 and ips=1.

[3.] Keywords (i.e., modules, networking, kernel):

[4.] Kernel version (from /proc/version):
Linux version 4.1.0-040100rc7-generic (kernel@gomeisa) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201506080035 SMP Mon Jun 8
04:36:20 UTC 2015

[5.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt)

[6.] A small shell script or example program which triggers the
problem (if possible)

[7.] Environment
Description: Ubuntu 15.04
Release: 15.04

[7.1.] Software (add the output of the ver_linux script here)
Linux Shoop-Portable-HP 4.1.0-040100rc7-generic #201506080035 SMP Mon
Jun 8 04:36:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
Gnu C 4.9.2
Gnu make 4.0
binutils 2.25
util-linux 2.25.2
mount debug
module-init-tools 18
e2fsprogs 1.42.12
pcmciautils 018
PPP 2.4.6
Linux C Library 2.21
Dynamic linker (ldd) 2.21
Procps 3.3.9
Net-tools 1.60
Kbd 1.15.5
Sh-utils 8.23
wireless-tools 30
Modules Loaded rfcomm ctr ccm bnep nls_iso8859_1 snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic uvcvideo arc4 rtl8723be
videobuf2_vmalloc videobuf2_memops videobuf2_core intel_rapl
v4l2_common videodev btcoexist media hp_wmi rtl8723_common rtl_pci
intel_powerclamp sparse_keymap rtlwifi i915 coretemp mac80211
snd_intel_sst_acpi snd_hda_intel snd_hda_controller snd_intel_sst_core
snd_soc_sst_mfld_platform snd_hda_codec kvm snd_soc_core snd_hda_core
snd_compress snd_hwdep cfg80211 btusb btbcm drm_kms_helper
snd_seq_midi crct10dif_pclmul snd_pcm_dmaengine snd_seq_midi_event
crc32_pclmul drm btintel bluetooth snd_pcm snd_rawmidi
ghash_clmulni_intel snd_seq snd_seq_device snd_soc_sst_acpi snd_timer
i2c_algo_bit cryptd joydev serio_raw hp_accel rtsx_pci_ms lis3lv02d
memstick 8250_fintek input_polldev mei_txe wmi snd soundcore mei
dw_dmac dw_dmac_core i2c_hid video iosf_mbi intel_smartconnect
i2c_designware_platform lpc_ich shpchp i2c_designware_core mac_hid
spi_pxa2xx_platform hp_wireless rfkill_gpio 8250_dw pwm_lpss_platform
pwm_lpss parport_pc ppdev lp parport autofs4 hid_generic usbhid hid
rtsx_pci_sdmmc psmouse r8169 ahci rtsx_pci mii libahci sdhci_acpi
sdhci

[7.2.] Processor information (from /proc/cpuinfo):
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 55
model name : Intel(R) Pentium(R) CPU N3540 @ 2.16GHz
stepping : 8
microcode : 0x829
cpu MHz : 2665.541
cache size : 1024 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt tsc_deadline_timer
rdrand lahf_lm 3dnowprefetch ida arat epb dtherm tpr_shadow vnmi
flexpriority ept vpid tsc_adjust smep erms
bugs :
bogomips : 4326.40
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 55
model name : Intel(R) Pentium(R) CPU N3540 @ 2.16GHz
stepping : 8
microcode : 0x829
cpu MHz : 2665.541
cache size : 1024 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt tsc_deadline_timer
rdrand lahf_lm 3dnowprefetch ida arat epb dtherm tpr_shadow vnmi
flexpriority ept vpid tsc_adjust smep erms
bugs :
bogomips : 4326.40
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 55
model name : Intel(R) Pentium(R) CPU N3540 @ 2.16GHz
stepping : 8
microcode : 0x829
cpu MHz : 2665.541
cache size : 1024 KB
physical id : 0
siblings : 4
core id : 2
cpu cores : 4
apicid : 4
initial apicid : 4
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt tsc_deadline_timer
rdrand lahf_lm 3dnowprefetch ida arat epb dtherm tpr_shadow vnmi
flexpriority ept vpid tsc_adjust smep erms
bugs :
bogomips : 4326.40
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 55
model name : Intel(R) Pentium(R) CPU N3540 @ 2.16GHz
stepping : 8
microcode : 0x829
cpu MHz : 2665.541
cache size : 1024 KB
physical id : 0
siblings : 4
core id : 3
cpu cores : 4
apicid : 6
initial apicid : 6
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt tsc_deadline_timer
rdrand lahf_lm 3dnowprefetch ida arat epb dtherm tpr_shadow vnmi
flexpriority ept vpid tsc_adjust smep erms
bugs :
bogomips : 4326.40
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
rfcomm 77824 4 - Live 0x0000000000000000
ctr 16384 3 - Live 0x0000000000000000
ccm 20480 3 - Live 0x0000000000000000
bnep 24576 2 - Live 0x0000000000000000
nls_iso8859_1 16384 1 - Live 0x0000000000000000
snd_hda_codec_hdmi 53248 1 - Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
snd_hda_codec_generic 77824 1 snd_hda_codec_realtek, Live 0x0000000000000000
uvcvideo 94208 0 - Live 0x0000000000000000
arc4 16384 2 - Live 0x0000000000000000
rtl8723be 98304 0 - Live 0x0000000000000000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
videobuf2_core 53248 1 uvcvideo, Live 0x0000000000000000
intel_rapl 20480 0 - Live 0x0000000000000000
v4l2_common 16384 1 videobuf2_core, Live 0x0000000000000000
videodev 172032 3 uvcvideo,videobuf2_core,v4l2_common, Live 0x0000000000000000
btcoexist 53248 1 rtl8723be, Live 0x0000000000000000
media 24576 2 uvcvideo,videodev, Live 0x0000000000000000
hp_wmi 16384 0 - Live 0x0000000000000000
rtl8723_common 24576 1 rtl8723be, Live 0x0000000000000000
rtl_pci 32768 1 rtl8723be, Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
sparse_keymap 16384 1 hp_wmi, Live 0x0000000000000000
rtlwifi 77824 2 rtl8723be,rtl_pci, Live 0x0000000000000000
i915 1146880 4 - Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
mac80211 786432 3 rtl8723be,rtl_pci,rtlwifi, Live 0x0000000000000000
snd_intel_sst_acpi 16384 0 - Live 0x0000000000000000
snd_hda_intel 32768 4 - Live 0x0000000000000000
snd_hda_controller 36864 1 snd_hda_intel, Live 0x0000000000000000
snd_intel_sst_core 77824 1 snd_intel_sst_acpi, Live 0x0000000000000000
snd_soc_sst_mfld_platform 77824 1 snd_intel_sst_core, Live 0x0000000000000000
snd_hda_codec 122880 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0x0000000000000000
kvm 507904 0 - Live 0x0000000000000000
snd_soc_core 204800 1 snd_soc_sst_mfld_platform, Live 0x0000000000000000
snd_hda_core 36864 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_controller,snd_hda_codec,
Live 0x0000000000000000
snd_compress 20480 1 snd_soc_core, Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
cfg80211 589824 2 rtlwifi,mac80211, Live 0x0000000000000000
btusb 49152 0 - Live 0x0000000000000000
btbcm 16384 1 btusb, Live 0x0000000000000000
drm_kms_helper 126976 1 i915, Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
snd_pcm_dmaengine 16384 1 snd_soc_core, Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
drm 352256 5 i915,drm_kms_helper, Live 0x0000000000000000
btintel 16384 1 btusb, Live 0x0000000000000000
bluetooth 540672 14 rfcomm,bnep,btusb,btbcm,btintel, Live 0x0000000000000000
snd_pcm 110592 7
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_soc_sst_mfld_platform,snd_hda_codec,snd_soc_core,snd_pcm_dmaengine,
Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
snd_soc_sst_acpi 16384 0 - Live 0x0000000000000000
snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
cryptd 24576 1 ghash_clmulni_intel, Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
hp_accel 28672 0 - Live 0x0000000000000000
rtsx_pci_ms 20480 0 - Live 0x0000000000000000
lis3lv02d 20480 1 hp_accel, Live 0x0000000000000000
memstick 20480 1 rtsx_pci_ms, Live 0x0000000000000000
8250_fintek 16384 0 - Live 0x0000000000000000
input_polldev 16384 1 lis3lv02d, Live 0x0000000000000000
mei_txe 20480 0 - Live 0x0000000000000000
wmi 20480 1 hp_wmi, Live 0x0000000000000000
snd 86016 22 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_soc_sst_mfld_platform,snd_hda_codec,snd_soc_core,snd_compress,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
mei 94208 1 mei_txe, Live 0x0000000000000000
dw_dmac 16384 0 - Live 0x0000000000000000
dw_dmac_core 32768 1 dw_dmac, Live 0x0000000000000000
i2c_hid 20480 0 - Live 0x0000000000000000
video 28672 1 i915, Live 0x0000000000000000
iosf_mbi 16384 1 intel_rapl, Live 0x0000000000000000
intel_smartconnect 16384 0 - Live 0x0000000000000000
i2c_designware_platform 16384 0 - Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
shpchp 40960 0 - Live 0x0000000000000000
i2c_designware_core 16384 1 i2c_designware_platform, Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
spi_pxa2xx_platform 24576 0 - Live 0x0000000000000000
hp_wireless 16384 0 - Live 0x0000000000000000
rfkill_gpio 16384 0 - Live 0x0000000000000000
8250_dw 16384 0 - Live 0x0000000000000000
pwm_lpss_platform 16384 0 - Live 0x0000000000000000
pwm_lpss 16384 1 pwm_lpss_platform, Live 0x0000000000000000
parport_pc 36864 0 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 45056 3 parport_pc,ppdev,lp, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 53248 0 - Live 0x0000000000000000
hid 122880 4 i2c_hid,hid_generic,usbhid, Live 0x0000000000000000
rtsx_pci_sdmmc 24576 0 - Live 0x0000000000000000
psmouse 135168 0 - Live 0x0000000000000000
r8169 90112 0 - Live 0x0000000000000000
ahci 36864 9 - Live 0x0000000000000000
rtsx_pci 53248 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
sdhci_acpi 16384 0 - Live 0x0000000000000000
sdhci 45056 1 sdhci_acpi, Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
/proc/ioports :
0000-006f : PCI Bus 0000:00
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
0070-0077 : PCI Bus 0000:00
0070-0077 : rtc0
0078-0cf7 : PCI Bus 0000:00
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03f8-03ff : serial
0400-0403 : ACPI PM1a_EVT_BLK
0404-0405 : ACPI PM1a_CNT_BLK
0408-040b : ACPI PM_TMR
0420-042f : ACPI GPE0_BLK
0430-0433 : iTCO_wdt
0450-0450 : ACPI PM2_CNT_BLK
0460-047f : iTCO_wdt
0500-05fe : pnp 00:01
0600-061f : pnp 00:01
0680-069f : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
1000-1fff : PCI Bus 0000:04
1000-10ff : 0000:04:00.0
1000-10ff : r8169
2000-2fff : PCI Bus 0000:02
2000-20ff : 0000:02:00.0
2000-20ff : rtl_pci
3000-301f : 0000:00:1f.3
3020-303f : 0000:00:13.0
3020-303f : ahci
3040-3047 : 0000:00:13.0
3040-3047 : ahci
3048-304f : 0000:00:13.0
3048-304f : ahci
3050-3057 : 0000:00:02.0
3058-305b : 0000:00:13.0
3058-305b : ahci
305c-305f : 0000:00:13.0
305c-305f : ahci
4000-4fff : PCI Bus 0000:01
5000-5fff : PCI Bus 0000:03
fd60-fd66 : PNP0C09:00

/proc/iomem :
00000000-00000fff : reserved
00001000-0006efff : System RAM
0006f000-0006ffff : ACPI Non-volatile Storage
00070000-00085fff : System RAM
00086000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
000e0000-000fffff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
02000000-02811edc : Kernel code
02811edd-02f34eff : Kernel data
030a6000-031e8fff : Kernel bss
20000000-200fffff : reserved
20100000-78325fff : System RAM
78326000-78525fff : reserved
78526000-79025fff : reserved
79026000-79325fff : ACPI Non-volatile Storage
79326000-79365fff : ACPI Tables
79366000-79ffffff : System RAM
7a000000-7affffff : RAM buffer
7b000000-7effffff : reserved
7b000000-7effffff : Graphics Stolen Memory
80000000-90affffe : PCI Bus 0000:00
80000000-8fffffff : 0000:00:02.0
90000000-903fffff : 0000:00:02.0
90400000-904fffff : PCI Bus 0000:04
90400000-90403fff : 0000:04:00.0
90400000-90403fff : r8169
90500000-905fffff : PCI Bus 0000:04
90500000-90500fff : 0000:04:00.0
90500000-90500fff : r8169
90600000-906fffff : PCI Bus 0000:03
90600000-90600fff : 0000:03:00.0
90600000-90600fff : rtsx_pci
90700000-907fffff : PCI Bus 0000:02
90700000-90703fff : 0000:02:00.0
90700000-90703fff : rtl_pci
90800000-908fffff : 0000:00:1a.0
90800000-908fffff : mei_txe
90900000-909fffff : 0000:00:1a.0
90900000-909fffff : mei_txe
90a00000-90a0ffff : 0000:00:14.0
90a00000-90a0ffff : xhci-hcd
90a10000-90a13fff : 0000:00:1b.0
90a10000-90a13fff : ICH HD audio
90a18000-90a1801f : 0000:00:1f.3
90a1e000-90a1e7ff : 0000:00:13.0
90a1e000-90a1e7ff : ahci
90b00000-90b03fff : INTL9C60:01
90b00000-90b03fff : INTL9C60:01
e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
e00000d0-e00000db : INT33BD:00
e00f8000-e00f8fff : reserved
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed00000-fed003ff : PNP0103:00
fed01000-fed01fff : reserved
fed01000-fed01fff : pnp 00:05
fed03000-fed03fff : pnp 00:05
fed03008-fed0300c : iTCO_wdt
fed04000-fed04fff : pnp 00:05
fed08000-fed08fff : pnp 00:05
fed0c000-fed0cfff : INT33FC:00
fed0c000-fed0cfff : INT33FC:00
fed0d000-fed0dfff : INT33FC:01
fed0d000-fed0dfff : INT33FC:01
fed0e000-fed0efff : INT33FC:02
fed0e000-fed0efff : INT33FC:02
fed1c000-fed1cfff : pnp 00:05
fed40000-fed44fff : pnp 00:01
fee00000-feefffff : pnp 00:05
fee00000-fee00fff : Local APIC
fef00000-feffffff : pnp 00:05
ff000000-ffffffff : INT0800:00
ffb80000-ffffffff : reserved
100000000-17fffffff : System RAM

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation Atom Processor Z36xxx/Z37xxx
Series SoC Transaction Register (rev 0e)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Kernel driver in use: iosf_mbi_pci

00:02.0 VGA compatible controller: Intel Corporation Atom Processor
Z36xxx/Z37xxx Series Graphics & Display (rev 0e) (prog-if 00 [VGA
controller])
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 92
Region 0: Memory at 90000000 (32-bit, non-prefetchable) [size=4M]
Region 2: Memory at 80000000 (32-bit, prefetchable) [size=256M]
Region 4: I/O ports at 3050 [size=8]
Expansion ROM at <unassigned> [disabled]
Capabilities: [d0] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c Data: 4162
Capabilities: [b0] Vendor Specific Information: Len=07 <?>
Kernel driver in use: i915

00:13.0 SATA controller: Intel Corporation Device 0f23 (rev 0e)
(prog-if 01 [AHCI 1.0])
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 89
Region 0: I/O ports at 3048 [size=8]
Region 1: I/O ports at 305c [size=4]
Region 2: I/O ports at 3040 [size=8]
Region 3: I/O ports at 3058 [size=4]
Region 4: I/O ports at 3020 [size=32]
Region 5: Memory at 90a1e000 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0c00c Data: 41d1
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
Kernel driver in use: ahci

00:14.0 USB controller: Intel Corporation Atom Processor Z36xxx/Z37xxx
Series USB xHCI (rev 0e) (prog-if 30 [XHCI])
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 87
Region 0: Memory at 90a00000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [70] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
Address: 00000000fee0c00c Data: 41b1
Kernel driver in use: xhci_hcd

00:1a.0 Encryption controller: Intel Corporation Atom Processor
Z36xxx/Z37xxx Series Trusted Execution Engine (rev 0e)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 91
Region 0: Memory at 90900000 (32-bit, non-prefetchable) [size=1M]
Region 1: Memory at 90800000 (32-bit, non-prefetchable) [size=1M]
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c Data: 4142
Kernel driver in use: mei_txe

00:1b.0 Audio device: Intel Corporation Atom Processor Z36xxx/Z37xxx
Series High Definition Audio Controller (rev 0e)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 93
Region 0: Memory at 90a10000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 4172
Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation Device 0f48 (rev 0e) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 00004000-00004fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000 Data: 0000
Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2213
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation Device 0f4a (rev 0e) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 00002000-00002fff
Memory behind bridge: 90700000-907fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000 Data: 0000
Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2213
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation Device 0f4c (rev 0e) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 00005000-00005fff
Memory behind bridge: 90600000-906fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000 Data: 0000
Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2213
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation Device 0f4e (rev 0e) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 00001000-00001fff
Memory behind bridge: 90500000-905fffff
Prefetchable memory behind bridge: 0000000090400000-00000000904fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000 Data: 0000
Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2213
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1f.0 ISA bridge: Intel Corporation Atom Processor Z36xxx/Z37xxx
Series Power Control Unit (rev 0e)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>
Kernel driver in use: lpc_ich

00:1f.3 SMBus: Intel Corporation Device 0f12 (rev 0e)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin B routed to IRQ 255
Region 0: Memory at 90a18000 (32-bit, non-prefetchable) [size=32]
Region 4: I/O ports at 3000 [size=32]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723BE
PCIe Wireless Network Adapter
Subsystem: Hewlett-Packard Company Device 2231
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 17
Region 0: I/O ports at 2000 [size=256]
Region 2: Memory at 90700000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000 Data: 0000
Capabilities: [70] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <512ns, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF
Via message/WAKE#
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
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
CESta: RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Device Serial Number 00-23-b7-fe-ff-4c-e0-00
Capabilities: [150 v1] Latency Tolerance Reporting
Max snoop latency: 71680ns
Max no snoop latency: 71680ns
Capabilities: [158 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
Kernel driver in use: rtl8723be

03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS5229 PCI Express Card Reader (rev 01)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 88
Region 0: Memory at 90600000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 41c1
Capabilities: [70] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
Kernel driver in use: rtsx_pci

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 07)
Subsystem: Hewlett-Packard Company Device 2213
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping-SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 90
Region 0: I/O ports at 1000 [size=256]
Region 2: Memory at 90500000 (64-bit, non-prefetchable) [size=4K]
Region 4: Memory at 90400000 (64-bit, prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 41e1
Capabilities: [70] Express (v2) Endpoint, MSI 01
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Via
message/WAKE#
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
Vector table: BAR=4 offset=00000000
PBA: BAR=4 offset=00000800
Capabilities: [d0] Vital Product Data
No end tag found
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
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
Capabilities: [160 v1] Device Serial Number 01-00-00-00-36-4c-e0-00
Capabilities: [170 v1] Latency Tolerance Reporting
Max snoop latency: 71680ns
Max no snoop latency: 71680ns
Kernel driver in use: r8169

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
Vendor: ATA Model: HGST HTS541010A9 Rev: A710
Type: Direct-Access ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
Vendor: hp Model: DVDRW SU208GB Rev: HH00
Type: CD-ROM ANSI SCSI revision: 05

[7.7.] Other information that might be relevant to the problem (please
look in /proc and include all information that you think to be
relevant):
1 1765 1965 2210 333 45 7 9265 driver pagetypeinfo
10 1769 1966 2220 334 456 70 9284 execdomains partitions
1055 1771 1968 2224 339 47 7073 940 fb sched_debug
1082 18 1972 2229 34 48 71 95 filesystems schedstat
11 1833 1982 2248 35 49 721 9521 fs scsi
12 1834 1996 233 36 5 729 9525 interrupts self
1249 1868 1997 24 37 51 7380 9526 iomem slabinfo
1261 1875 2 2439 38 53 75 96 ioports softirqs
1293 1876 20 25 39 54 750 9730 irq stat
13 1887 2000 2532 40 55 775 9838 kallsyms swaps
1308 1898 2002 259 41 5647 784 9889 kcore sys
1311 19 2005 26 42 603 8 9916 keys sysrq-trigger
14 1901 2011 27 422 608 8020 9964 key-users sysvipc
15 1903 2013 28 423 609 8577 acpi kmsg thread-self
153 1906 2014 29 4241 611 861 asound kpagecount timer_list
154 1909 2030 297 426 612 870 buddyinfo kpageflags timer_stats
155 1914 2069 298 43 623 8719 bus loadavg tty
156 1917 2073 3 431 624 896 cgroups locks uptime
157 1918 209 300 432 628 9 cmdline mdstat version
159 1921 21 301 434 630 9048 consoles meminfo vmallocinfo
1662 1923 2138 302 438 669 9154 cpuinfo misc vmstat
17 1926 219 31 439 67 916 crypto modules zoneinfo
174 1933 22 32 44 689 922 devices mounts
175 1938 2205 33 441 69 9228 diskstats mtrr
1764 1963 2208 332 442 695 9232 dma net

[X.] Other notes, patches, fixes, workarounds:
Triaged by Christopher M. Penalver on
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1459367
