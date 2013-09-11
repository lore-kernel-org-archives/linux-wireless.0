Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub0-omc2-s33.dub0.hotmail.com ([157.55.1.172]:23589 "EHLO
	dub0-omc2-s33.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab3IKHAF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 03:00:05 -0400
Message-ID: <DUB122-W36FEB8099A8B6081E03DDBF7390@phx.gbl> (sfid-20130911_090013_662825_80A339CA)
From: "Toufilk ..." <toufik2@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iwlwifi crash with "Microcode SW error detected"
Date: Wed, 11 Sep 2013 06:53:50 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1]iwlwifi crash with "Microcode SW error detected"
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1221202

[2]
I have an intel 7260 wifi card (it is a dual band). I have had a 
**lot** of trouble connecting to my router (also dual band). I don't 
know how I did but I eventually managed to connect to the 2.4GHz AP but it is not 
very stable. However, I've never managed to connect to the 5.5GHz AP 
while it is listed as available. By looking at dmesg, the driver is 
crashing:

...

[   74.358662] wlan0: authenticate with a6:b1:e9:ae:61:a2

[   74.359848] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)

[   74.360756] wlan0: authenticated

[   74.364053] wlan0: associate with a6:b1:e9:ae:61:a2 (try 1/3)

[   74.373879] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.

...
Then the wifi is dead and I have to reboot.
[3]iwlwifi, intel 7260
[4]$ cat /proc/versionLinux version 3.11.0-031100-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201309021735 SMP Mon Sep 2 21:36:21 UTC 2013

[5]$ lsb_release -rd 
Description:    Ubuntu Saucy Salamander (development branch)
Release:    13.10
[6]$ sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux aurakey 3.11.0-031100-generic #201309021735 SMP Mon Sep 2 21:36:21 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130828
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         pci_stub vboxpci vboxnetadp vboxnetflt vboxdrv snd_hda_codec_hdmi snd_hda_codec_realtek joydev x86_pkg_temp_thermal coretemp kvm_intel arc4 kvm crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd hid_generic uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev pn544_mei mei_phy pn544 hci nfc usbhid hid parport_pc ppdev bnep rfcomm bluetooth iwlmvm snd_seq_midi snd_seq_midi_event mac80211 snd_rawmidi microcode snd_hda_intel snd_seq psmouse snd_hda_codec serio_raw snd_hwdep snd_pcm mac_hid snd_seq_device iwlwifi snd_page_alloc sony_laptop i915 snd_timer snd cfg80211 video lpc_ich drm_kms_helper drm intel_smartconnect soundcore mei_me i2c_algo_bit mei lp parport nls_iso8859_1 ahci libahci
[7]$ cat /proc/cpuinfo 
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz
stepping    : 1
microcode    : 0xa
cpu MHz        : 800.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
bogomips    : 4789.13
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz
stepping    : 1
microcode    : 0xa
cpu MHz        : 800.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
bogomips    : 4789.13
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz
stepping    : 1
microcode    : 0xa
cpu MHz        : 800.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
bogomips    : 4789.13
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 69
model name    : Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz
stepping    : 1
microcode    : 0xa
cpu MHz        : 800.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
bogomips    : 4789.13
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

[8]$ cat /proc/modules 
pci_stub 12622 1 - Live 0x0000000000000000
vboxpci 23194 0 - Live 0x0000000000000000 (OF)
vboxnetadp 25670 0 - Live 0x0000000000000000 (OF)
vboxnetflt 27613 0 - Live 0x0000000000000000 (OF)
vboxdrv 320455 3 vboxpci,vboxnetadp,vboxnetflt, Live 0x0000000000000000 (OF)
snd_hda_codec_hdmi 41688 1 - Live 0x0000000000000000
snd_hda_codec_realtek 56305 1 - Live 0x0000000000000000
joydev 17613 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 14269 0 - Live 0x0000000000000000
coretemp 17728 0 - Live 0x0000000000000000
kvm_intel 143875 0 - Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
kvm 447883 1 kvm_intel, Live 0x0000000000000000
crc32_pclmul 13160 0 - Live 0x0000000000000000
ghash_clmulni_intel 13259 0 - Live 0x0000000000000000
aesni_intel 55720 3 - Live 0x0000000000000000
aes_x86_64 17131 1 aesni_intel, Live 0x0000000000000000
lrw 13294 1 aesni_intel, Live 0x0000000000000000
gf128mul 14951 1 lrw, Live 0x0000000000000000
glue_helper 14095 1 aesni_intel, Live 0x0000000000000000
ablk_helper 13597 1 aesni_intel, Live 0x0000000000000000
cryptd 20501 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
uvcvideo 82247 0 - Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
videobuf2_core 40785 1 uvcvideo, Live 0x0000000000000000
videodev 138443 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
pn544_mei 12787 0 - Live 0x0000000000000000
mei_phy 13929 1 pn544_mei, Live 0x0000000000000000
pn544 17949 1 pn544_mei, Live 0x0000000000000000
hci 44774 2 mei_phy,pn544, Live 0x0000000000000000
nfc 95174 2 pn544,hci, Live 0x0000000000000000
usbhid 53329 0 - Live 0x0000000000000000
hid 105557 2 hid_generic,usbhid, Live 0x0000000000000000
parport_pc 32866 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
bnep 23966 2 - Live 0x0000000000000000
rfcomm 74589 0 - Live 0x0000000000000000
bluetooth 391564 10 bnep,rfcomm, Live 0x0000000000000000
iwlmvm 167457 0 - Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
mac80211 619101 1 iwlmvm, Live 0x0000000000000000
snd_rawmidi 30416 1 snd_seq_midi, Live 0x0000000000000000
microcode 23650 0 - Live 0x0000000000000000
snd_hda_intel 53038 5 - Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
psmouse 104064 0 - Live 0x0000000000000000
snd_hda_codec 194727 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0x0000000000000000
serio_raw 13413 0 - Live 0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 107140 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
iwlwifi 171131 1 iwlmvm, Live 0x0000000000000000
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
sony_laptop 54991 0 - Live 0x0000000000000000
i915 682856 5 - Live 0x0000000000000000
snd_timer 29989 2 snd_seq,snd_pcm, Live 0x0000000000000000
snd 69657 21 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_seq_midi,snd_rawmidi,snd_hda_intel,snd_seq,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_device,snd_timer, Live 0x0000000000000000
cfg80211 494624 3 iwlmvm,mac80211,iwlwifi, Live 0x0000000000000000
video 19574 1 i915, Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
drm_kms_helper 53178 1 i915, Live 0x0000000000000000
drm 298236 4 i915,drm_kms_helper, Live 0x0000000000000000
intel_smartconnect 12690 0 - Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
mei_me 18539 0 - Live 0x0000000000000000
i2c_algo_bit 13564 1 i915, Live 0x0000000000000000
mei 78448 3 pn544_mei,mei_phy,mei_me, Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42466 3 parport_pc,ppdev,lp, Live 0x0000000000000000
nls_iso8859_1 12713 1 - Live 0x0000000000000000
ahci 30063 3 - Live 0x0000000000000000
libahci 32088 1 ahci, Live 0x0000000000000000

[10]$ cat /proc/ioports 
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  04d0-04d1 : pnp 00:06
  0680-069f : pnp 00:03
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  164e-164f : pnp 00:03
  1800-1803 : ACPI PM1a_EVT_BLK
  1804-1805 : ACPI PM1a_CNT_BLK
  1808-180b : ACPI PM_TMR
  1810-1815 : ACPI CPU throttle
  1830-1833 : iTCO_wdt
  1850-1850 : ACPI PM2_CNT_BLK
  1854-1857 : pnp 00:05
  1860-187f : iTCO_wdt
  1880-189f : ACPI GPE0_BLK
  1c00-1cfe : pnp 00:03
  1d00-1dfe : pnp 00:03
  1e00-1efe : pnp 00:03
  1f00-1ffe : pnp 00:03
  2008-200b : pnp 00:03
  3000-3fff : PCI Bus 0000:01
  e000-efff : PCI Bus 0000:02
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
  ffff-ffff : pnp 00:03
    ffff-ffff : pnp 00:03

[11]$ cat /proc/iomem
00000000-00000fff : reserved
00001000-00057fff : System RAM
00058000-00058fff : reserved
00059000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c3fff : PCI Bus 0000:00
000c4000-000c7fff : PCI Bus 0000:00
000c8000-000cbfff : PCI Bus 0000:00
000cc000-000cffff : PCI Bus 0000:00
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-ca4bcfff : System RAM
  02000000-0273a293 : Kernel code
  0273a294-02d0e93f : Kernel data
  02e70000-02fe2fff : Kernel bss
ca4bd000-ca4c3fff : ACPI Non-volatile Storage
ca4c4000-ca8e5fff : System RAM
ca8e6000-cac36fff : reserved
cac37000-da898fff : System RAM
da899000-dab40fff : reserved
dab41000-dab55fff : ACPI Tables
dab56000-dbaaafff : ACPI Non-volatile Storage
dbaab000-dbffefff : reserved
dbfff000-dbffffff : System RAM
dd000000-df1fffff : reserved
df200000-feafffff : PCI Bus 0000:00
  df200000-df3fffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:00:02.0
  f0000000-f09fffff : PCI Bus 0000:02
  f7000000-f73fffff : 0000:00:02.0
  f7400000-f7dfffff : PCI Bus 0000:02
  f7e00000-f7efffff : PCI Bus 0000:01
    f7e00000-f7e01fff : 0000:01:00.0
      f7e00000-f7e01fff : iwlwifi
  f7f00000-f7f0ffff : 0000:00:14.0
    f7f00000-f7f0ffff : xhci_hcd
  f7f10000-f7f13fff : 0000:00:1b.0
    f7f10000-f7f13fff : ICH HD audio
  f7f14000-f7f17fff : 0000:00:03.0
    f7f14000-f7f17fff : ICH HD audio
  f7f19000-f7f190ff : 0000:00:1f.3
  f7f1a000-f7f1a7ff : 0000:00:1f.2
    f7f1a000-f7f1a7ff : ahci
  f7f1b000-f7f1b3ff : 0000:00:1d.0
    f7f1b000-f7f1b3ff : ehci_hcd
  f7f1d000-f7f1d01f : 0000:00:16.0
    f7f1d000-f7f1d01f : mei_me
  f7fef000-f7feffff : pnp 00:09
  f7ff0000-f7ff0fff : pnp 00:09
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:09
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
  fed00000-fed003ff : HPET 0
fed10000-fed17fff : pnp 00:09
fed18000-fed18fff : pnp 00:09
fed19000-fed19fff : pnp 00:09
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:09
    fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:09
fed45000-fed8ffff : pnp 00:09
fed90000-fed93fff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
  ff000000-ffffffff : pnp 00:09
100000000-21fdfffff : System RAM
21fe00000-21fffffff : RAM buffer


[12]
$ sudo lspci -vvv 
00:00.0 Host bridge: Intel Corporation Haswell-ULT DRAM Controller (rev 09)
    Subsystem: Sony Corporation Device 90b6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort+>SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
    Subsystem: Sony Corporation Device 90b6
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 60
    Region 0: Memory at f7000000 (64-bit, non-prefetchable) [size=4M]
    Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at f000 [size=64]
    Expansion ROM at <unassigned> [disabled]
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41c1
    Capabilities: [d0] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: i915

00:03.0 Audio device: Intel Corporation Device 0a0c (rev 09)
    Subsystem: Sony Corporation Device 90b6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 61
    Region 0: Memory at f7f14000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41d1
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- RBE- FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
    Kernel driver in use: snd_hda_intel

00:14.0 USB controller: Intel Corporation Lynx Point-LP USB xHCI HC (rev 04) (prog-if 30 [XHCI])
    Subsystem: Sony Corporation Device 90b6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 56
    Region 0: Memory at f7f00000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [70] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
        Address: 00000000fee0500c  Data: 4181
    Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation Lynx Point-LP HECI #0 (rev 04)
    Subsystem: Sony Corporation Device 90b6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 58
    Region 0: Memory at f7f1d000 (64-bit, non-prefetchable) [size=32]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41a1
    Kernel driver in use: mei_me

00:1b.0 Audio device: Intel Corporation Lynx Point-LP HD Audio Controller (rev 04)
    Subsystem: Sony Corporation Device 90b6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 62
    Region 0: Memory at f7f10000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4122
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE- FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=2 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 3 (rev e4) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 00003000-00003fff
    Memory behind bridge: f7e00000-f7efffff
    Prefetchable memory behind bridge: 00000000df200000-00000000df3fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort->Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+ ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [90] Subsystem: Sony Corporation Device 90b6
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v0] #00
    Capabilities: [200 v1] #1e
    Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 4 (rev e4) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 0000e000-0000efff
    Memory behind bridge: f7400000-f7dfffff
    Prefetchable memory behind bridge: 00000000f0000000-00000000f09fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort->Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot+
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range ABC, TimeoutDis+ ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000
    Capabilities: [90] Subsystem: Sony Corporation Device 90b6
    Capabilities: [a0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v0] #00
    Capabilities: [200 v1] #1e
    Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation Lynx Point-LP USB EHCI #1 (rev 04) (prog-if 20 [EHCI])
    Subsystem: Sony Corporation Device 90b6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at f7f1b000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation Lynx Point-LP LPC Controller (rev 04)
    Subsystem: Sony Corporation Device 90b6
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation Lynx Point-LP SATA Controller 1 [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
    Subsystem: Sony Corporation Device 90b6
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 57
    Region 0: I/O ports at f0b0 [size=8]
    Region 1: I/O ports at f0a0 [size=4]
    Region 2: I/O ports at f090 [size=8]
    Region 3: I/O ports at f080 [size=4]
    Region 4: I/O ports at f060 [size=32]
    Region 5: Memory at f7f1a000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0500c  Data: 4191
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
    Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation Lynx Point-LP SMBus Controller (rev 04)
    Subsystem: Sony Corporation Device 90b6
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 255
    Region 0: Memory at f7f19000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at f040 [size=32]

01:00.0 Network controller: Intel Corporation Wireless 7260 (rev 6b)
    Subsystem: Intel Corporation Dual Band Wireless-N 7260
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort- <TAbort- <MAbort->SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 59
    Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: [c8] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0400c  Data: 41b1
    Capabilities: [40] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop+ FLReset-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range B, TimeoutDis+
        DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number 5c-51-4f-ff-ff-19-c5-d0
    Capabilities: [14c v1] Latency Tolerance Reporting
        Max snoop latency: 3145728ns
        Max no snoop latency: 3145728ns
    Capabilities: [154 v1] Vendor Specific Information: ID=cafe Rev=1 Len=014 <?>
    Kernel driver in use: iwlwifi

[13]$ cat /proc/scsi/scsi 
Attached devices:
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: TOSHIBA THNSNH25 Rev: HTSA
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[14]$ dmesg -c// Try to connect to AP on the 5.5GHz$ dmesg[   70.601635] wlan0: deauthenticating from a4:b1:e9:ae:61:99 by local choice (reason=3)
[   70.605284] cfg80211: Calling CRDA to update world regulatory domain
[   70.616324] cfg80211: World regulatory domain updated:
[   70.616335] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   70.616343] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   70.616349] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   70.616355] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   70.616360] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   70.616366] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   74.358662] wlan0: authenticate with a6:b1:e9:ae:61:a2
[   74.359848] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[   74.360756] wlan0: authenticated
[   74.364053] wlan0: associate with a6:b1:e9:ae:61:a2 (try 1/3)
[   74.373879] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[   74.373892] iwlwifi 0000:01:00.0: CSR values:
[   74.373899] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   74.373910] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[   74.373920] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X00000040
[   74.373930] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[   74.373939] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[   74.373949] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[   74.373959] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[   74.373968] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[   74.373978] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[   74.373988] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[   74.373998] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[   74.374008] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[   74.374018] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[   74.374028] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[   74.374037] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   74.374047] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   74.374056] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   74.374066] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   74.374076] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[   74.374086] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[   74.374096] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   74.374106] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[   74.374116] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   74.374125] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[   74.374133] iwlwifi 0000:01:00.0: FH register values:
[   74.374152] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[   74.374171] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[   74.374190] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000068
[   74.374209] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[   74.374227] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   74.374246] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[   74.374265] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   74.374284] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   74.374303] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   74.374420] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[   74.374429] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[   74.374438] iwlwifi 0000:01:00.0: 0x0000003C | NMI_INTERRUPT_DATA_ACTION_PT
[   74.374445] iwlwifi 0000:01:00.0: 0x059002A3 | uPc
[   74.374452] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[   74.374459] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[   74.374466] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[   74.374473] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[   74.374480] iwlwifi 0000:01:00.0: 0x00014D9A | data1
[   74.374486] iwlwifi 0000:01:00.0: 0x00000008 | data2
[   74.374493] iwlwifi 0000:01:00.0: 0x03030000 | data3
[   74.374500] iwlwifi 0000:01:00.0: 0x59009500 | beacon time
[   74.374507] iwlwifi 0000:01:00.0: 0x539A8E27 | tsf low
[   74.374514] iwlwifi 0000:01:00.0: 0x00000040 | tsf hi
[   74.374521] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[   74.374528] iwlwifi 0000:01:00.0: 0x0431E87A | time gp2
[   74.374534] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[   74.374541] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[   74.374548] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[   74.374555] iwlwifi 0000:01:00.0: 0x00489204 | board version
[   74.374562] iwlwifi 0000:01:00.0: 0x0018001C | hcmd
[   74.374569] iwlwifi 0000:01:00.0: 0x26F63800 | isr0
[   74.374575] iwlwifi 0000:01:00.0: 0x01018000 | isr1
[   74.374582] iwlwifi 0000:01:00.0: 0x0000000A | isr2
[   74.374589] iwlwifi 0000:01:00.0: 0x4041FC81 | isr3
[   74.374596] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[   74.374603] iwlwifi 0000:01:00.0: 0x10800112 | isr_pref
[   74.374609] iwlwifi 0000:01:00.0: 0x00014D9A | wait_event
[   74.374616] iwlwifi 0000:01:00.0: 0x000000D0 | l2p_control
[   74.374623] iwlwifi 0000:01:00.0: 0x00019C20 | l2p_duration
[   74.374630] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[   74.374637] iwlwifi 0000:01:00.0: 0x000000CF | l2p_addr_match
[   74.374644] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[   74.374651] iwlwifi 0000:01:00.0: 0xA3925B33 | timestamp
[   74.374658] iwlwifi 0000:01:00.0: 0x00346878 | flow_handler
[   74.374667] ieee80211 phy0: Hardware restart was requested
[   74.375052] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   74.375205] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   74.468027] wlan0: associate with a6:b1:e9:ae:61:a2 (try 2/3)
[   74.703035] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[   74.703094] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[   75.873905] wlan0: associate with a6:b1:e9:ae:61:a2 (try 3/3)
[   76.108920] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[   76.108946] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[   76.875166] wlan0: association with a6:b1:e9:ae:61:a2 timed out
[   76.879527] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 1
[   76.879535] ------------[ cut here ]------------
[   76.879578] WARNING: CPU: 2 PID: 143 at /build/buildd/linux-3.11.0/net/mac80211/sta_info.c:839 __sta_info_destroy+0x265/0x360 [mac80211]()
[   76.879581] Modules linked in: pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) parport_pc(F) ppdev(F) rfcomm bnep bluetooth snd_hda_codec_hdmi joydev(F) arc4(F) x86_pkg_temp_thermal coretemp kvm_intel(F) kvm(F) crc32_pclmul(F) ghash_clmulni_intel(F) aesni_intel(F) aes_x86_64(F) lrw(F) gf128mul(F) glue_helper(F) ablk_helper(F) cryptd(F) hid_generic uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev pn544_mei mei_phy pn544 hci nfc usbhid nls_iso8859_1(F) hid microcode(F) psmouse(F) serio_raw(F) mac_hid snd_seq_midi(F) snd_hda_codec_realtek snd_seq_midi_event(F) iwlmvm mac80211 snd_rawmidi(F) sony_laptop i915 snd_hda_intel snd_hda_codec iwlwifi intel_smartconnect snd_hwdep(F) video(F) drm_kms_helper snd_seq(F) drm snd_pcm(F) snd_seq_device(F) snd_page_alloc(F) snd_timer(F) i2c_algo_bit cfg80211 mei_me lpc_ich snd(F) mei lp(F) parport(F) soundcore(F) ahci(F) libahci(F)
[   76.879680] CPU: 2 PID: 143 Comm: kworker/u8:3 Tainted: GF          O 3.11.0-4-generic #9-Ubuntu
[   76.879683] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[   76.879708] Workqueue: phy0 ieee80211_iface_work [mac80211]
[   76.879712]  0000000000000009 ffff88021014bcb0 ffffffff816f0f71 0000000000000000
[   76.879718]  ffff88021014bce8 ffffffff81061cfd ffff880210920600 ffff880210ad2800
[   76.879724]  ffff880210ad2800 00000000fffffffb ffff8802112cb000 ffff88021014bcf8
[   76.879731] Call Trace:
[   76.879741]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[   76.879752]  [<ffffffff81061cfd>] warn_slowpath_common+0x7d/0xa0
[   76.879760]  [<ffffffff81061dda>] warn_slowpath_null+0x1a/0x20
[   76.879781]  [<ffffffffa02efb75>] __sta_info_destroy+0x265/0x360 [mac80211]
[   76.879803]  [<ffffffffa02efca8>] sta_info_destroy_addr+0x38/0x60 [mac80211]
[   76.879842]  [<ffffffffa0324898>] ieee80211_destroy_assoc_data+0x28/0x80 [mac80211]
[   76.879878]  [<ffffffffa032aaa6>] ieee80211_sta_work+0x396/0x510 [mac80211]
[   76.879908]  [<ffffffffa02fb3f9>] ieee80211_iface_work+0x2c9/0x360 [mac80211]
[   76.879917]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[   76.879923]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[   76.879930]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[   76.879938]  [<ffffffff81084710>] kthread+0xc0/0xd0
[   76.879947]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   76.879956]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[   76.879964]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   76.879968] ---[ end trace a053f3a264fb6dca ]---
[   80.601278] wlan0: authenticate with a6:b1:e9:ae:61:a2
[   80.602856] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[   80.603107] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[   80.603115] iwlwifi 0000:01:00.0: CSR values:
[   80.603119] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   80.603127] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[   80.603134] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[   80.603141] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[   80.603147] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[   80.603153] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[   80.603160] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[   80.603166] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[   80.603172] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[   80.603179] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[   80.603185] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[   80.603192] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[   80.603198] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[   80.603204] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[   80.603210] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   80.603217] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   80.603223] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   80.603229] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   80.603236] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[   80.603242] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[   80.603248] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   80.603254] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[   80.603261] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   80.603267] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[   80.603271] iwlwifi 0000:01:00.0: FH register values:
[   80.603286] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[   80.603301] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[   80.603316] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000040
[   80.603331] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[   80.603346] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   80.603361] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   80.603375] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   80.603390] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   80.603405] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   80.603518] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[   80.603522] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[   80.603528] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[   80.603531] iwlwifi 0000:01:00.0: 0x00000220 | uPc
[   80.603535] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[   80.603539] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[   80.603543] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[   80.603547] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[   80.603550] iwlwifi 0000:01:00.0: 0x00000001 | data1
[   80.603554] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[   80.603557] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[   80.603561] iwlwifi 0000:01:00.0: 0x00015DCB | beacon time
[   80.603565] iwlwifi 0000:01:00.0: 0x005EE4D8 | tsf low
[   80.603569] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[   80.603572] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[   80.603576] iwlwifi 0000:01:00.0: 0x005EE4D8 | time gp2
[   80.603580] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[   80.603583] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[   80.603587] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[   80.603590] iwlwifi 0000:01:00.0: 0x00489204 | board version
[   80.603594] iwlwifi 0000:01:00.0: 0x09310019 | hcmd
[   80.603598] iwlwifi 0000:01:00.0: 0x24022080 | isr0
[   80.603601] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[   80.603605] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[   80.603608] iwlwifi 0000:01:00.0: 0x004000C0 | isr3
[   80.603612] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[   80.603615] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[   80.603619] iwlwifi 0000:01:00.0: 0x00014D9A | wait_event
[   80.603623] iwlwifi 0000:01:00.0: 0x000000D4 | l2p_control
[   80.603627] iwlwifi 0000:01:00.0: 0x00018030 | l2p_duration
[   80.603630] iwlwifi 0000:01:00.0: 0x00000007 | l2p_mhvalid
[   80.603634] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[   80.603638] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[   80.603641] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[   80.603645] iwlwifi 0000:01:00.0: 0x00004050 | flow_handler
[   80.603651] ieee80211 phy0: Hardware restart was requested
[   80.603663] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[   80.603670] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[   80.603673] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[   80.603701] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[   80.603706]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[   80.603713]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[   80.603719]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[   80.603726] Call Trace:
[   80.603737]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[   80.603757]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[   80.603765]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[   80.603781]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[   80.603794]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[   80.603801]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[   80.603814]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[   80.603827]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[   80.603835]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[   80.603841]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[   80.603847]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[   80.603855]  [<ffffffff81084710>] kthread+0xc0/0xd0
[   80.603863]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   80.603871]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[   80.603879]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   80.603885] iwlwifi 0000:01:00.0: Failed to remove station. Id=1
[   80.603889] iwlwifi 0000:01:00.0: Couldn't remove sta 1 after it was drained
[   80.604296] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   80.604450] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   80.705039] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[   81.011905] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[   81.011971] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[   81.870539] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[   82.177591] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[   82.177659] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[   82.871002] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[   82.883364] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 2
[   86.647866] wlan0: authenticate with a6:b1:e9:ae:61:a2
[   86.649294] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[   86.649348] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[   86.649368] iwlwifi 0000:01:00.0: CSR values:
[   86.649380] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   86.649390] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[   86.649398] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[   86.649406] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[   86.649413] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[   86.649419] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[   86.649427] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[   86.649434] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[   86.649442] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[   86.649449] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[   86.649456] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[   86.649462] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[   86.649468] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[   86.649475] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[   86.649481] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   86.649487] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   86.649493] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   86.649500] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   86.649506] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[   86.649512] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[   86.649519] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   86.649525] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[   86.649531] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   86.649537] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[   86.649541] iwlwifi 0000:01:00.0: FH register values:
[   86.649557] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[   86.649572] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[   86.649587] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000040
[   86.649602] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[   86.649616] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   86.649631] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   86.649646] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   86.649661] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   86.649676] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   86.649790] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[   86.649795] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[   86.649800] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[   86.649804] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[   86.649807] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[   86.649811] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[   86.649815] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[   86.649819] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[   86.649822] iwlwifi 0000:01:00.0: 0x00000002 | data1
[   86.649826] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[   86.649829] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[   86.649833] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[   86.649837] iwlwifi 0000:01:00.0: 0x005C1563 | tsf low
[   86.649840] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[   86.649844] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[   86.649848] iwlwifi 0000:01:00.0: 0x005C1563 | time gp2
[   86.649851] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[   86.649855] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[   86.649858] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[   86.649862] iwlwifi 0000:01:00.0: 0x00489204 | board version
[   86.649866] iwlwifi 0000:01:00.0: 0x09310019 | hcmd
[   86.649869] iwlwifi 0000:01:00.0: 0x00022080 | isr0
[   86.649873] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[   86.649876] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[   86.649880] iwlwifi 0000:01:00.0: 0x0040F4C0 | isr3
[   86.649883] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[   86.649887] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[   86.649890] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[   86.649894] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[   86.649898] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[   86.649902] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[   86.649905] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[   86.649909] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[   86.649912] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[   86.649916] iwlwifi 0000:01:00.0: 0x00004050 | flow_handler
[   86.649922] ieee80211 phy0: Hardware restart was requested
[   86.649937] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[   86.649945] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[   86.649948] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[   86.649977] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[   86.649982]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[   86.649989]  ffff8802141fbd30 ffffffffa019f1ef ffff88021fa90e28 0000000000000000
[   86.649995]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[   86.650001] Call Trace:
[   86.650012]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[   86.650033]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[   86.650041]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[   86.650057]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[   86.650070]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[   86.650077]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[   86.650090]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[   86.650103]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[   86.650111]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[   86.650118]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[   86.650124]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[   86.650133]  [<ffffffff81084710>] kthread+0xc0/0xd0
[   86.650141]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   86.650151]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[   86.650159]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   86.650165] iwlwifi 0000:01:00.0: Failed to remove station. Id=2
[   86.650169] iwlwifi 0000:01:00.0: Couldn't remove sta 2 after it was drained
[   86.650190] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[   86.650577] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   86.650725] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   86.660236] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[   86.967220] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[   86.967264] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[   87.877618] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[   87.885642] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 1
[   91.669432] wlan0: authenticate with a6:b1:e9:ae:61:a2
[   91.670597] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[   91.670715] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[   91.670726] iwlwifi 0000:01:00.0: CSR values:
[   91.670732] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   91.670743] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[   91.670753] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[   91.670762] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[   91.670772] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[   91.670781] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[   91.670790] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[   91.670799] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[   91.670808] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[   91.670816] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[   91.670822] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[   91.670829] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[   91.670835] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[   91.670841] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[   91.670848] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   91.670854] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   91.670860] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   91.670866] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   91.670873] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[   91.670879] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[   91.670885] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   91.670891] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[   91.670898] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   91.670904] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   91.670908] iwlwifi 0000:01:00.0: FH register values:
[   91.670923] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[   91.670938] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[   91.670953] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000038
[   91.670967] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[   91.670982] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   91.670997] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   91.671012] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   91.671027] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   91.671041] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   91.671156] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[   91.671161] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[   91.671166] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[   91.671170] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[   91.671173] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[   91.671177] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[   91.671181] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[   91.671185] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[   91.671188] iwlwifi 0000:01:00.0: 0x00000001 | data1
[   91.671192] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[   91.671195] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[   91.671199] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[   91.671203] iwlwifi 0000:01:00.0: 0x004C7B9B | tsf low
[   91.671206] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[   91.671210] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[   91.671214] iwlwifi 0000:01:00.0: 0x004C7B9C | time gp2
[   91.671217] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[   91.671221] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[   91.671224] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[   91.671228] iwlwifi 0000:01:00.0: 0x00489204 | board version
[   91.671232] iwlwifi 0000:01:00.0: 0x09300019 | hcmd
[   91.671235] iwlwifi 0000:01:00.0: 0x00022081 | isr0
[   91.671239] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[   91.671242] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[   91.671246] iwlwifi 0000:01:00.0: 0x004098C0 | isr3
[   91.671249] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[   91.671253] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[   91.671257] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[   91.671261] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[   91.671264] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[   91.671268] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[   91.671272] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[   91.671275] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[   91.671279] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[   91.671283] iwlwifi 0000:01:00.0: 0x00003848 | flow_handler
[   91.671288] ieee80211 phy0: Hardware restart was requested
[   91.671302] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[   91.671309] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[   91.671312] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[   91.671341] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[   91.671346]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[   91.671354]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[   91.671360]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[   91.671366] Call Trace:
[   91.671378]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[   91.671398]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[   91.671406]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[   91.671422]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[   91.671435]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[   91.671443]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[   91.671456]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[   91.671469]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[   91.671477]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[   91.671483]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[   91.671489]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[   91.671499]  [<ffffffff81084710>] kthread+0xc0/0xd0
[   91.671507]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   91.671516]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[   91.671523]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[   91.671529] iwlwifi 0000:01:00.0: Failed to remove station. Id=1
[   91.671534] iwlwifi 0000:01:00.0: Couldn't remove sta 1 after it was drained
[   91.671584] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[   91.671997] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   91.672149] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   91.681457] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[   91.988415] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[   91.988489] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[   92.920148] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[   92.928303] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 2
[  103.150253] wlan0: authenticate with a6:b1:e9:ae:61:a2
[  103.151648] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[  103.151741] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  103.151764] iwlwifi 0000:01:00.0: CSR values:
[  103.151772] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  103.151781] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  103.151790] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  103.151797] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  103.151804] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  103.151812] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  103.151818] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  103.151824] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  103.151831] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  103.151837] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  103.151843] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  103.151850] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  103.151856] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  103.151863] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  103.151869] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  103.151875] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  103.151881] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  103.151888] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  103.151894] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  103.151900] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  103.151906] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  103.151913] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  103.151919] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  103.151925] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  103.151929] iwlwifi 0000:01:00.0: FH register values:
[  103.151945] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  103.151960] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  103.151975] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000048
[  103.151990] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  103.152004] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  103.152019] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  103.152034] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  103.152049] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  103.152064] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  103.152177] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  103.152182] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  103.152187] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  103.152191] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[  103.152194] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  103.152198] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  103.152202] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  103.152206] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  103.152209] iwlwifi 0000:01:00.0: 0x00000002 | data1
[  103.152213] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  103.152217] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  103.152220] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[  103.152224] iwlwifi 0000:01:00.0: 0x00AEF836 | tsf low
[  103.152228] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  103.152231] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  103.152235] iwlwifi 0000:01:00.0: 0x00AEF836 | time gp2
[  103.152238] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  103.152242] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  103.152246] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  103.152249] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  103.152253] iwlwifi 0000:01:00.0: 0x09320019 | hcmd
[  103.152257] iwlwifi 0000:01:00.0: 0x00022081 | isr0
[  103.152260] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  103.152264] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  103.152267] iwlwifi 0000:01:00.0: 0x0041A880 | isr3
[  103.152271] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  103.152274] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  103.152278] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[  103.152282] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[  103.152285] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[  103.152289] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[  103.152293] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[  103.152296] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  103.152300] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  103.152304] iwlwifi 0000:01:00.0: 0x00004858 | flow_handler
[  103.152310] ieee80211 phy0: Hardware restart was requested
[  103.152323] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  103.152331] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  103.152334] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  103.152362] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  103.152367]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  103.152374]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[  103.152380]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  103.152386] Call Trace:
[  103.152397]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  103.152418]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  103.152426]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  103.152441]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  103.152454]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  103.152461]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[  103.152474]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  103.152487]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  103.152495]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  103.152501]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  103.152507]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  103.152515]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  103.152523]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  103.152532]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  103.152539]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  103.152545] iwlwifi 0000:01:00.0: Failed to remove station. Id=2
[  103.152549] iwlwifi 0000:01:00.0: Couldn't remove sta 2 after it was drained
[  103.152572] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[  103.152954] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  103.153102] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  103.162755] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[  103.469739] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[  103.469785] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[  103.898483] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[  103.906701] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 1
[  107.656798] wlan0: authenticate with a6:b1:e9:ae:61:a2
[  107.657919] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[  107.658015] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  107.658027] iwlwifi 0000:01:00.0: CSR values:
[  107.658034] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  107.658045] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  107.658055] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  107.658065] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  107.658074] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  107.658083] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  107.658092] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  107.658100] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  107.658108] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  107.658117] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  107.658125] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  107.658134] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  107.658143] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  107.658152] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  107.658161] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  107.658169] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  107.658178] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  107.658186] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  107.658196] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  107.658205] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  107.658213] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  107.658222] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  107.658231] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  107.658240] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  107.658246] iwlwifi 0000:01:00.0: FH register values:
[  107.658265] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  107.658284] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  107.658302] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000038
[  107.658319] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  107.658334] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  107.658349] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  107.658364] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  107.658378] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  107.658393] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  107.658508] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  107.658512] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  107.658517] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  107.658521] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[  107.658525] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  107.658529] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  107.658532] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  107.658536] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  107.658540] iwlwifi 0000:01:00.0: 0x00000001 | data1
[  107.658543] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  107.658547] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  107.658551] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[  107.658554] iwlwifi 0000:01:00.0: 0x0044A0A4 | tsf low
[  107.658558] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  107.658562] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  107.658565] iwlwifi 0000:01:00.0: 0x0044A0A4 | time gp2
[  107.658569] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  107.658573] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  107.658576] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  107.658580] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  107.658584] iwlwifi 0000:01:00.0: 0x09300019 | hcmd
[  107.658587] iwlwifi 0000:01:00.0: 0x00022081 | isr0
[  107.658591] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  107.658594] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  107.658598] iwlwifi 0000:01:00.0: 0x004198C0 | isr3
[  107.658601] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  107.658605] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  107.658609] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[  107.658612] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[  107.658616] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[  107.658620] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[  107.658624] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[  107.658627] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  107.658631] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  107.658635] iwlwifi 0000:01:00.0: 0x00003848 | flow_handler
[  107.658640] ieee80211 phy0: Hardware restart was requested
[  107.658655] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  107.658661] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  107.658665] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  107.658693] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  107.658698]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  107.658705]  ffff8802141fbd30 ffffffffa019f1ef ffff88021fa90e28 0000000000000000
[  107.658711]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  107.658717] Call Trace:
[  107.658729]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  107.658750]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  107.658758]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  107.658774]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  107.658787]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  107.658794]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[  107.658807]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  107.658820]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  107.658828]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  107.658834]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  107.658840]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  107.658849]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  107.658857]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  107.658865]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  107.658872]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  107.658878] iwlwifi 0000:01:00.0: Failed to remove station. Id=1
[  107.658882] iwlwifi 0000:01:00.0: Couldn't remove sta 1 after it was drained
[  107.658931] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[  107.659316] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  107.659460] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  107.668895] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[  107.975817] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[  107.975853] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[  108.929123] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[  108.937322] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 2
[  112.679141] wlan0: authenticate with a6:b1:e9:ae:61:a2
[  112.680295] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[  112.680420] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  112.680432] iwlwifi 0000:01:00.0: CSR values:
[  112.680439] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  112.680450] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  112.680459] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  112.680469] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  112.680479] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  112.680487] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  112.680497] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  112.680505] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  112.680512] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  112.680519] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  112.680525] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  112.680531] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  112.680538] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  112.680544] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  112.680550] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  112.680557] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  112.680563] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  112.680569] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  112.680575] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  112.680582] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  112.680588] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  112.680594] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  112.680600] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  112.680606] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  112.680610] iwlwifi 0000:01:00.0: FH register values:
[  112.680626] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  112.680641] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  112.680656] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000038
[  112.680670] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  112.680685] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  112.680700] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  112.680715] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  112.680730] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  112.680745] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  112.680859] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  112.680863] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  112.680868] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  112.680872] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[  112.680876] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  112.680879] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  112.680883] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  112.680887] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  112.680890] iwlwifi 0000:01:00.0: 0x00000002 | data1
[  112.680894] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  112.680898] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  112.680901] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[  112.680905] iwlwifi 0000:01:00.0: 0x004C7EDF | tsf low
[  112.680909] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  112.680912] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  112.680916] iwlwifi 0000:01:00.0: 0x004C7EDF | time gp2
[  112.680919] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  112.680923] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  112.680927] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  112.680930] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  112.680934] iwlwifi 0000:01:00.0: 0x09300019 | hcmd
[  112.680937] iwlwifi 0000:01:00.0: 0x00022081 | isr0
[  112.680941] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  112.680944] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  112.680948] iwlwifi 0000:01:00.0: 0x0041C0C0 | isr3
[  112.680951] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  112.680955] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  112.680959] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[  112.680962] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[  112.680966] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[  112.680970] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[  112.680973] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[  112.680977] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  112.680981] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  112.680984] iwlwifi 0000:01:00.0: 0x00003848 | flow_handler
[  112.680990] ieee80211 phy0: Hardware restart was requested
[  112.681004] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  112.681011] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  112.681015] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  112.681043] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  112.681048]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  112.681055]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[  112.681061]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  112.681067] Call Trace:
[  112.681079]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  112.681099]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  112.681108]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  112.681123]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  112.681136]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  112.681144]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[  112.681157]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  112.681170]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  112.681178]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  112.681184]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  112.681190]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  112.681200]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  112.681208]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  112.681217]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  112.681224]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  112.681230] iwlwifi 0000:01:00.0: Failed to remove station. Id=2
[  112.681235] iwlwifi 0000:01:00.0: Couldn't remove sta 2 after it was drained
[  112.681283] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[  112.681656] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  112.681805] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  112.691745] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[  112.998664] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[  112.998726] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[  113.947664] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[  113.963849] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 1
[  117.700691] wlan0: authenticate with a6:b1:e9:ae:61:a2
[  117.702008] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[  117.702301] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  117.702311] iwlwifi 0000:01:00.0: CSR values:
[  117.702316] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  117.702323] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  117.702330] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  117.702337] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  117.702343] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  117.702349] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  117.702356] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  117.702362] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  117.702368] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  117.702375] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  117.702381] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  117.702387] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  117.702394] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  117.702400] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  117.702406] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  117.702413] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  117.702419] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  117.702425] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  117.702431] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  117.702438] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  117.702444] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  117.702450] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  117.702456] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  117.702463] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  117.702467] iwlwifi 0000:01:00.0: FH register values:
[  117.702482] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  117.702497] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  117.702512] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000040
[  117.702527] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  117.702541] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  117.702556] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  117.702571] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  117.702586] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  117.702601] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  117.702714] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  117.702718] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  117.702723] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  117.702727] iwlwifi 0000:01:00.0: 0x00000220 | uPc
[  117.702731] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  117.702735] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  117.702738] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  117.702742] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  117.702746] iwlwifi 0000:01:00.0: 0x00000001 | data1
[  117.702749] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  117.702753] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  117.702756] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[  117.702760] iwlwifi 0000:01:00.0: 0x004C7C0F | tsf low
[  117.702764] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  117.702767] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  117.702771] iwlwifi 0000:01:00.0: 0x004C7C10 | time gp2
[  117.702774] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  117.702778] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  117.702781] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  117.702785] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  117.702789] iwlwifi 0000:01:00.0: 0x09300019 | hcmd
[  117.702792] iwlwifi 0000:01:00.0: 0x24022080 | isr0
[  117.702796] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  117.702799] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  117.702803] iwlwifi 0000:01:00.0: 0x004000C0 | isr3
[  117.702806] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  117.702810] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  117.702813] iwlwifi 0000:01:00.0: 0x00014D9A | wait_event
[  117.702817] iwlwifi 0000:01:00.0: 0x000000D4 | l2p_control
[  117.702821] iwlwifi 0000:01:00.0: 0x00018030 | l2p_duration
[  117.702824] iwlwifi 0000:01:00.0: 0x00000007 | l2p_mhvalid
[  117.702828] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[  117.702831] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  117.702835] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  117.702839] iwlwifi 0000:01:00.0: 0x00004050 | flow_handler
[  117.702845] ieee80211 phy0: Hardware restart was requested
[  117.702856] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  117.702864] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  117.702867] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  117.702896] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  117.702901]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  117.702908]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[  117.702914]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  117.702920] Call Trace:
[  117.702932]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  117.702952]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  117.702961]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  117.702976]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  117.702989]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  117.702997]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[  117.703010]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  117.703023]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  117.703031]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  117.703037]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  117.703043]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  117.703052]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  117.703060]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  117.703069]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  117.703077]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  117.703082] iwlwifi 0000:01:00.0: Failed to remove station. Id=1
[  117.703086] iwlwifi 0000:01:00.0: Couldn't remove sta 1 after it was drained
[  117.703110] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[  117.703483] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  117.703632] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  117.805608] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[  118.112485] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[  118.112548] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[  118.918176] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[  118.934671] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 2
[  122.721771] wlan0: authenticate with a6:b1:e9:ae:61:a2
[  122.722904] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 1/3)
[  122.722944] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 2/3)
[  122.722996] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  122.723004] iwlwifi 0000:01:00.0: CSR values:
[  122.723008] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  122.723040] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  122.723052] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  122.723071] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  122.723085] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  122.723094] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  122.723102] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  122.723111] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  122.723120] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  122.723130] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  122.723140] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  122.723150] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  122.723159] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  122.723169] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  122.723188] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  122.723207] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  122.723216] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  122.723226] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  122.723236] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  122.723246] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  122.723255] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  122.723274] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  122.723287] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  122.723297] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[  122.723304] iwlwifi 0000:01:00.0: FH register values:
[  122.723323] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  122.723352] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  122.723370] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000040
[  122.723391] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  122.723410] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  122.723427] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  122.723445] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  122.723463] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  122.723481] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  122.723600] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  122.723608] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  122.723616] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  122.723623] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[  122.723629] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  122.723635] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  122.723642] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  122.723649] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  122.723655] iwlwifi 0000:01:00.0: 0x00000002 | data1
[  122.723662] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  122.723669] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  122.723675] iwlwifi 0000:01:00.0: 0x0002E34E | beacon time
[  122.723682] iwlwifi 0000:01:00.0: 0x004C78DF | tsf low
[  122.723689] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  122.723696] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  122.723702] iwlwifi 0000:01:00.0: 0x004C78DF | time gp2
[  122.723709] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  122.723715] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  122.723722] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  122.723729] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  122.723735] iwlwifi 0000:01:00.0: 0x09300019 | hcmd
[  122.723742] iwlwifi 0000:01:00.0: 0x00022081 | isr0
[  122.723748] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  122.723755] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  122.723761] iwlwifi 0000:01:00.0: 0x004110C0 | isr3
[  122.723768] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  122.723774] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  122.723781] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[  122.723788] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[  122.723795] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[  122.723802] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[  122.723808] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[  122.723815] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  122.723822] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  122.723828] iwlwifi 0000:01:00.0: 0x00004048 | flow_handler
[  122.723838] ieee80211 phy0: Hardware restart was requested
[  122.723860] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  122.723871] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  122.723876] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  122.723912] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  122.723919]  00000000000001f3 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  122.723931]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[  122.723941]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  122.723951] Call Trace:
[  122.723966]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  122.723996]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  122.724009]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  122.724031]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  122.724050]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  122.724060]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[  122.724080]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  122.724099]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  122.724111]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  122.724120]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  122.724130]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  122.724142]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  122.724154]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  122.724166]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  122.724177]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  122.724187] iwlwifi 0000:01:00.0: Failed to remove station. Id=2
[  122.724194] iwlwifi 0000:01:00.0: Couldn't remove sta 2 after it was drained
[  122.724569] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  122.724725] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  122.735053] wlan0: send auth to a6:b1:e9:ae:61:a2 (try 3/3)
[  123.041943] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[  123.041997] wlan0: Connection to AP a6:b1:e9:ae:61:a2 lost
[  123.960697] wlan0: authentication with a6:b1:e9:ae:61:a2 timed out
[  123.980979] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 1
[  127.743306] wlan0: authenticate with a6:b1:e9:ae:61:9a
[  127.744291] wlan0: send auth to a6:b1:e9:ae:61:9a (try 1/3)
[  127.744348] wlan0: send auth to a6:b1:e9:ae:61:9a (try 2/3)
[  127.744412] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  127.744424] iwlwifi 0000:01:00.0: CSR values:
[  127.744430] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  127.744441] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  127.744451] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  127.744461] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  127.744471] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  127.744480] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  127.744489] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  127.744499] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  127.744508] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  127.744518] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  127.744527] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  127.744537] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  127.744547] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  127.744556] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  127.744565] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  127.744575] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  127.744584] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  127.744593] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  127.744602] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  127.744611] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  127.744621] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  127.744630] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  127.744639] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  127.744648] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  127.744655] iwlwifi 0000:01:00.0: FH register values:
[  127.744674] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  127.744692] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  127.744710] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000040
[  127.744729] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  127.744747] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  127.744765] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  127.744783] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  127.744802] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  127.744819] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  127.744939] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  127.744947] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  127.744956] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  127.744962] iwlwifi 0000:01:00.0: 0x000002A0 | uPc
[  127.744968] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  127.744974] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  127.744981] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  127.744988] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  127.744994] iwlwifi 0000:01:00.0: 0x00000001 | data1
[  127.745001] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  127.745007] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  127.745013] iwlwifi 0000:01:00.0: 0x00000000 | beacon time
[  127.745020] iwlwifi 0000:01:00.0: 0x004C759D | tsf low
[  127.745026] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  127.745032] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  127.745039] iwlwifi 0000:01:00.0: 0x004C759D | time gp2
[  127.745046] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  127.745052] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  127.745058] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  127.745064] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  127.745071] iwlwifi 0000:01:00.0: 0x09300019 | hcmd
[  127.745078] iwlwifi 0000:01:00.0: 0x00022081 | isr0
[  127.745084] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  127.745091] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  127.745097] iwlwifi 0000:01:00.0: 0x004120C0 | isr3
[  127.745103] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  127.745109] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  127.745116] iwlwifi 0000:01:00.0: 0x000255D8 | wait_event
[  127.745122] iwlwifi 0000:01:00.0: 0x00000050 | l2p_control
[  127.745129] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[  127.745136] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[  127.745142] iwlwifi 0000:01:00.0: 0x00000081 | l2p_addr_match
[  127.745148] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  127.745155] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  127.745161] iwlwifi 0000:01:00.0: 0x00004050 | flow_handler
[  127.745170] ieee80211 phy0: Hardware restart was requested
[  127.745409] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  127.745421] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  127.745426] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  127.745461] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  127.745468]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  127.745479]  ffff8802141fbd30 ffffffffa019f1ef 0000000000000000 0000000000000000
[  127.745490]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  127.745500] Call Trace:
[  127.745515]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  127.745543]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  127.745554]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  127.745576]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  127.745620]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  127.745660]  [<ffffffff815fddf5>] ? netdev_run_todo+0x55/0x2d0
[  127.745696]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  127.745730]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  127.745755]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  127.745779]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  127.745800]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  127.745812]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  127.745823]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  127.745835]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  127.745847]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  127.745856] iwlwifi 0000:01:00.0: Failed to remove station. Id=1
[  127.745863] iwlwifi 0000:01:00.0: Couldn't remove sta 1 after it was drained
[  127.746234] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  127.746398] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  127.755843] wlan0: send auth to a6:b1:e9:ae:61:9a (try 3/3)
[  128.063010] iwlwifi 0000:01:00.0: No assocation and the time event is over already...
[  128.063078] wlan0: Connection to AP a6:b1:e9:ae:61:9a lost
[  128.967305] wlan0: authentication with a6:b1:e9:ae:61:9a timed out
[  128.979395] iwlwifi 0000:01:00.0: Couldn't drain frames for staid 2
[  129.800572] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  129.800583] iwlwifi 0000:01:00.0: CSR values:
[  129.800588] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  129.800596] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  129.800603] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X0000ff40
[  129.800610] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[  129.800616] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[  129.800622] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  129.800629] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[  129.800635] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[  129.800641] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
[  129.800648] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000144
[  129.800654] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[  129.800660] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[  129.800667] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  129.800673] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080044
[  129.800679] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  129.800685] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  129.800691] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  129.800697] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  129.800704] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000060
[  129.800710] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X882107b4
[  129.800716] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  129.800722] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  129.800729] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  129.800735] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  129.800739] iwlwifi 0000:01:00.0: FH register values:
[  129.800754] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X212e0800
[  129.800769] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0212e070
[  129.800783] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000030
[  129.800798] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  129.800812] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  129.800827] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  129.800841] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  129.800856] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  129.800870] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  129.800981] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[  129.800986] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[  129.800991] iwlwifi 0000:01:00.0: 0x00002B00 | ADVANCED_SYSASSERT          
[  129.800995] iwlwifi 0000:01:00.0: 0x000002F0 | uPc
[  129.800998] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[  129.801002] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
[  129.801006] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
[  129.801009] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
[  129.801013] iwlwifi 0000:01:00.0: 0x00000002 | data1
[  129.801017] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[  129.801020] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[  129.801024] iwlwifi 0000:01:00.0: 0x0020BD4D | beacon time
[  129.801028] iwlwifi 0000:01:00.0: 0x001F42B2 | tsf low
[  129.801031] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[  129.801035] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  129.801039] iwlwifi 0000:01:00.0: 0x001F42B2 | time gp2
[  129.801042] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[  129.801046] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
[  129.801049] iwlwifi 0000:01:00.0: 0x00000144 | hw version
[  129.801053] iwlwifi 0000:01:00.0: 0x00489204 | board version
[  129.801057] iwlwifi 0000:01:00.0: 0x092B0019 | hcmd
[  129.801060] iwlwifi 0000:01:00.0: 0x00022080 | isr0
[  129.801064] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[  129.801067] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[  129.801071] iwlwifi 0000:01:00.0: 0x0041C0C0 | isr3
[  129.801074] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  129.801078] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[  129.801081] iwlwifi 0000:01:00.0: 0x00020D06 | wait_event
[  129.801085] iwlwifi 0000:01:00.0: 0x00000000 | l2p_control
[  129.801089] iwlwifi 0000:01:00.0: 0x00000000 | l2p_duration
[  129.801092] iwlwifi 0000:01:00.0: 0x00000000 | l2p_mhvalid
[  129.801096] iwlwifi 0000:01:00.0: 0x00000000 | l2p_addr_match
[  129.801100] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
[  129.801104] iwlwifi 0000:01:00.0: 0x17061625 | timestamp
[  129.801107] iwlwifi 0000:01:00.0: 0x00003040 | flow_handler
[  129.801113] ieee80211 phy0: Hardware restart was requested
[  129.801125] iwlwifi 0000:01:00.0: FW error in SYNC CMD REMOVE_STA
[  129.801132] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  129.801135] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  129.801162] Workqueue: events iwl_mvm_sta_drained_wk [iwlmvm]
[  129.801167]  00000000000001f4 ffff8802141fbcc8 ffffffff816f0f71 ffff88021092c000
[  129.801174]  ffff8802141fbd30 ffffffffa019f1ef 0000000000014580 0000000000000000
[  129.801180]  ffff8802141f2ee0 ffffffff810854e0 ffff8802141fbcf8 ffff8802141fbcf8
[  129.801187] Call Trace:
[  129.801197]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  129.801217]  [<ffffffffa019f1ef>] iwl_trans_pcie_send_hcmd+0x53f/0x5d0 [iwlwifi]
[  129.801225]  [<ffffffff810854e0>] ? wake_up_atomic_t+0x30/0x30
[  129.801241]  [<ffffffffa03acfe2>] iwl_mvm_send_cmd+0x32/0xb0 [iwlmvm]
[  129.801253]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  129.801260]  [<ffffffff81098206>] ? arch_vtime_task_switch+0x96/0xa0
[  129.801273]  [<ffffffffa03b0477>] iwl_mvm_rm_sta_common+0x47/0xa0 [iwlmvm]
[  129.801286]  [<ffffffffa03b0db2>] iwl_mvm_sta_drained_wk+0xb2/0x150 [iwlmvm]
[  129.801294]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  129.801301]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  129.801307]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  129.801316]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  129.801324]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  129.801332]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  129.801339]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  129.801345] iwlwifi 0000:01:00.0: Failed to remove station. Id=2
[  129.801349] iwlwifi 0000:01:00.0: Couldn't remove sta 2 after it was drained
[  129.801406] iwlwifi 0000:01:00.0: Failed to remove MAC context: -5
[  129.802557] ------------[ cut here ]------------
[  129.802587] WARNING: CPU: 1 PID: 20 at /build/buildd/linux-3.11.0/drivers/net/wireless/iwlwifi/mvm/../iwl-trans.h:610 iwl_mvm_send_cmd+0x81/0xb0 [iwlmvm]()
[  129.802593] iwl_trans_send_cmd bad state = 0
[  129.802597] Modules linked in: pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) parport_pc(F) ppdev(F) rfcomm bnep bluetooth snd_hda_codec_hdmi joydev(F) arc4(F) x86_pkg_temp_thermal coretemp kvm_intel(F) kvm(F) crc32_pclmul(F) ghash_clmulni_intel(F) aesni_intel(F) aes_x86_64(F) lrw(F) gf128mul(F) glue_helper(F) ablk_helper(F) cryptd(F) hid_generic uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev pn544_mei mei_phy pn544 hci nfc usbhid nls_iso8859_1(F) hid microcode(F) psmouse(F) serio_raw(F) mac_hid snd_seq_midi(F) snd_hda_codec_realtek snd_seq_midi_event(F) iwlmvm mac80211 snd_rawmidi(F) sony_laptop i915 snd_hda_intel snd_hda_codec iwlwifi intel_smartconnect snd_hwdep(F) video(F) drm_kms_helper snd_seq(F) drm snd_pcm(F) snd_seq_device(F) snd_page_alloc(F) snd_timer(F) i2c_algo_bit cfg80211 mei_me lpc_ich snd(F) mei lp(F) parport(F) soundcore(F) ahci(F) libahci(F)
[  129.802755] CPU: 1 PID: 20 Comm: kworker/1:0 Tainted: GF       W  O 3.11.0-4-generic #9-Ubuntu
[  129.802761] Hardware name: Sony Corporation SVP1321C5E/VAIO, BIOS R0270V7 05/17/2013
[  129.802792] Workqueue: events ieee80211_restart_work [mac80211]
[  129.802797]  0000000000000009 ffff8802141fbbc8 ffffffff816f0f71 ffff8802141fbc10
[  129.802807]  ffff8802141fbc00 ffffffff81061cfd ffff88021092c000 ffff8802141fbc90
[  129.802816]  0000000000000000 ffff880210920600 0000000000000040 ffff8802141fbc60
[  129.802826] Call Trace:
[  129.802837]  [<ffffffff816f0f71>] dump_stack+0x45/0x56
[  129.802849]  [<ffffffff81061cfd>] warn_slowpath_common+0x7d/0xa0
[  129.802859]  [<ffffffff81061d6c>] warn_slowpath_fmt+0x4c/0x50
[  129.802883]  [<ffffffffa03ad031>] iwl_mvm_send_cmd+0x81/0xb0 [iwlmvm]
[  129.802901]  [<ffffffffa03ad0a1>] iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
[  129.802920]  [<ffffffffa03b00c3>] iwl_mvm_update_quotas+0x153/0x1b0 [iwlmvm]
[  129.802964]  [<ffffffffa0312163>] ? __ieee80211_wake_queue+0xe3/0x100 [mac80211]
[  129.802980]  [<ffffffffa03a7d0f>] iwl_mvm_mac_restart_complete+0x2f/0x60 [iwlmvm]
[  129.803021]  [<ffffffffa0313792>] ieee80211_reconfig+0x132/0x1400 [mac80211]
[  129.803049]  [<ffffffffa02ea1f7>] ieee80211_restart_work+0x87/0xa0 [mac80211]
[  129.803059]  [<ffffffff8107cfbc>] process_one_work+0x17c/0x430
[  129.803069]  [<ffffffff8107dc0c>] worker_thread+0x11c/0x3c0
[  129.803079]  [<ffffffff8107daf0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  129.803090]  [<ffffffff81084710>] kthread+0xc0/0xd0
[  129.803102]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  129.803114]  [<ffffffff81700d6c>] ret_from_fork+0x7c/0xb0
[  129.803126]  [<ffffffff81084650>] ? kthread_create_on_node+0x120/0x120
[  129.803133] ---[ end trace a053f3a264fb6dcb ]---
[  129.803143] iwlwifi 0000:01:00.0: Failed to send quota: -5
[  129.803151] iwlwifi 0000:01:00.0: Failed to update quotas after restart (-5)
[  129.804468] iwlwifi 0000:01:00.0: RF_KILL bit toggled to disable radio.

[15] 		 	   		  