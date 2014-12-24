Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:59728 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaLXJKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 04:10:10 -0500
Received: by mail-oi0-f52.google.com with SMTP id h136so16943759oig.11
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2014 01:10:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMUBipdVDgxeTDEY=q2QP1=OyF67tvU-S1riy_CMSawj01xhgA@mail.gmail.com>
References: <CAMUBipdVDgxeTDEY=q2QP1=OyF67tvU-S1riy_CMSawj01xhgA@mail.gmail.com>
Date: Wed, 24 Dec 2014 03:10:09 -0600
Message-ID: <CAMUBipfDmww-Jv5p9ZUumfv6oto+gc9JEuez7Ee4XoEv0mGbqw@mail.gmail.com> (sfid-20141224_101020_445190_7C516753)
Subject: Re: rtl8723au system lock ups, possible code regression
From: Jesus Legaspy <jesus.legaspy@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

plain text
cc linux-wireless@vger.kernel.org

On Wed, Dec 24, 2014 at 2:56 AM, Jesus Legaspy <jesus.legaspy@gmail.com> wrote:
>
> Hi Jes,
>
> I hope you're having a great Christmas celebration!
> I've been having this issue for a while now, and decided to submit this bug report as many others have similar problems. Hopefully this helps fix the bug!
>
> rtl8723au driver: wifi connection drops and system lock ups, possible code regression
>
> I'm using Ubuntu 14.10 with Linux version 3.16.0-28-generic on Lenovo Yoga 13 using the built in rtl8723au driver from the kernel. At random times my internet doesn't work. I disactivate the internet and reactivate it to get it working again. It is usually at this time where most of the system hangs and freezes occur. The computer hangs and freezes occur at random times as well. I've used many wifi connections and types and they all cause the bug. The driver from lwfinger works flawlessly. Maybe there was some code regression? I've attached several log files.
>
> related links:
> https://github.com/lwfinger/rtl8723au
> https://github.com/torvalds/linux/tree/master/drivers/staging/rtl8723au
>
> people with similar problem:
> https://github.com/lwfinger/rtl8723au/issues/53
> https://github.com/lwfinger/rtl8723au/issues/52
> https://github.com/lwfinger/rtl8723au/issues/48
> https://github.com/lwfinger/rtl8723au/issues/42
> https://github.com/lwfinger/rtl8723au/issues/38
>
> Best Regards,
> Jesus Legaspy
>
>
> [3.] Keywords (i.e., modules, networking, kernel):
>
> Ubuntu 14.10
> Linux version 3.16.0-28-generic
> rtl8723au
> networking
> wifi
> kernel
>
> [4.] Kernel version (from /proc/version):
>
> Linux version 3.16.0-28-generic (buildd@komainu) (gcc version 4.9.1 (Ubuntu 4.9.1-16ubuntu6) ) #38-Ubuntu SMP Fri Dec 12 17:37:40 UTC 2014
>
>
> [5.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
>
> See atatched files.
>
> [7.2.] Processor information (from /proc/cpuinfo):
>
> processor : 0
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz
> stepping : 9
> microcode : 0x17
> cpu MHz : 1166.558
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 0
> initial apicid : 0
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips : 3392.22
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> processor : 1
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz
> stepping : 9
> microcode : 0x17
> cpu MHz : 1296.714
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 1
> initial apicid : 1
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips : 3392.22
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> processor : 2
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz
> stepping : 9
> microcode : 0x17
> cpu MHz : 1188.207
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 1
> cpu cores : 2
> apicid : 2
> initial apicid : 2
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips : 3392.22
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> processor : 3
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz
> stepping : 9
> microcode : 0x17
> cpu MHz : 957.246
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 1
> cpu cores : 2
> apicid : 3
> initial apicid : 3
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips : 3392.22
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> [7.3.] Module information (from /proc/modules):
>
> nfnetlink_queue 18234 0 - Live 0x0000000000000000
> nfnetlink_log 17894 0 - Live 0x0000000000000000
> nfnetlink 14606 2 nfnetlink_queue,nfnetlink_log, Live 0x0000000000000000
> hid_sensor_incl_3d 13267 0 - Live 0x0000000000000000
> hid_sensor_accel_3d 13280 0 - Live 0x0000000000000000
> hid_sensor_rotation 13387 0 - Live 0x0000000000000000
> hid_sensor_magn_3d 13267 0 - Live 0x0000000000000000
> hid_sensor_gyro_3d 13267 0 - Live 0x0000000000000000
> hid_sensor_trigger 13134 10 hid_sensor_incl_3d,hid_sensor_accel_3d,hid_sensor_rotation,hid_sensor_magn_3d,hid_sensor_gyro_3d, Live 0x0000000000000000
> industrialio_triggered_buffer 12882 5 hid_sensor_incl_3d,hid_sensor_accel_3d,hid_sensor_rotation,hid_sensor_magn_3d,hid_sensor_gyro_3d, Live 0x0000000000000000
> kfifo_buf 13432 1 industrialio_triggered_buffer, Live 0x0000000000000000
> industrialio 54850 8 hid_sensor_incl_3d,hid_sensor_accel_3d,hid_sensor_rotation,hid_sensor_magn_3d,hid_sensor_gyro_3d,hid_sensor_trigger,industrialio_triggered_buffer,kfifo_buf, Live 0x0000000000000000
> hid_sensor_iio_common 14309 5 hid_sensor_incl_3d,hid_sensor_accel_3d,hid_sensor_rotation,hid_sensor_magn_3d,hid_sensor_gyro_3d, Live 0x0000000000000000
> rtsx_usb_ms 18651 0 - Live 0x0000000000000000
> memstick 16966 1 rtsx_usb_ms, Live 0x0000000000000000
> rfcomm 69509 0 - Live 0x0000000000000000
> bnep 19543 2 - Live 0x0000000000000000
> bluetooth 446190 10 rfcomm,bnep, Live 0x0000000000000000
> 6lowpan_iphc 18702 1 bluetooth, Live 0x0000000000000000
> uvcvideo 81065 0 - Live 0x0000000000000000
> snd_hda_codec_hdmi 47547 1 - Live 0x0000000000000000
> snd_hda_codec_conexant 22962 1 - Live 0x0000000000000000
> snd_hda_codec_generic 68914 1 snd_hda_codec_conexant, Live 0x0000000000000000
> hid_sensor_hub 19877 7 hid_sensor_incl_3d,hid_sensor_accel_3d,hid_sensor_rotation,hid_sensor_magn_3d,hid_sensor_gyro_3d,hid_sensor_trigger,hid_sensor_iio_common, Live 0x0000000000000000
> videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
> videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
> videobuf2_core 59104 1 uvcvideo, Live 0x0000000000000000
> v4l2_common 15682 1 videobuf2_core, Live 0x0000000000000000
> videodev 149725 3 uvcvideo,videobuf2_core,v4l2_common, Live 0x0000000000000000
> media 21963 2 uvcvideo,videodev, Live 0x0000000000000000
> hid_multitouch 17419 0 - Live 0x0000000000000000
> snd_hda_intel 30379 3 - Live 0x0000000000000000
> snd_hda_controller 35152 1 snd_hda_intel, Live 0x0000000000000000
> snd_hda_codec 139675 5 snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, Live 0x0000000000000000
> snd_hwdep 17698 1 snd_hda_codec, Live 0x0000000000000000
> snd_pcm 104102 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec, Live 0x0000000000000000
> snd_seq_midi 13564 0 - Live 0x0000000000000000
> snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
> intel_rapl 18783 0 - Live 0x0000000000000000
> x86_pkg_temp_thermal 14205 0 - Live 0x0000000000000000
> intel_powerclamp 18786 0 - Live 0x0000000000000000
> coretemp 13441 0 - Live 0x0000000000000000
> usbhid 52574 0 - Live 0x0000000000000000
> kvm_intel 143592 0 - Live 0x0000000000000000
> kvm 459835 1 kvm_intel, Live 0x0000000000000000
> crct10dif_pclmul 14307 0 - Live 0x0000000000000000
> crc32_pclmul 13133 0 - Live 0x0000000000000000
> ghash_clmulni_intel 13230 0 - Live 0x0000000000000000
> aesni_intel 152552 0 - Live 0x0000000000000000
> aes_x86_64 17131 1 aesni_intel, Live 0x0000000000000000
> hid 110426 3 hid_sensor_hub,hid_multitouch,usbhid, Live 0x0000000000000000
> lrw 13287 1 aesni_intel, Live 0x0000000000000000
> gf128mul 14951 1 lrw, Live 0x0000000000000000
> glue_helper 13944 1 aesni_intel, Live 0x0000000000000000
> ablk_helper 13597 1 aesni_intel, Live 0x0000000000000000
> cryptd 20360 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 0x0000000000000000
> r8723au 598271 0 - Live 0x0000000000000000 (C)
> binfmt_misc 17468 1 - Live 0x0000000000000000
> cfg80211 510218 1 r8723au, Live 0x0000000000000000
> snd_rawmidi 30876 1 snd_seq_midi, Live 0x0000000000000000
> snd_seq 67224 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
> snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
> snd_timer 29513 2 snd_pcm,snd_seq, Live 0x0000000000000000
> i915 917658 3 - Live 0x0000000000000000
> joydev 17344 0 - Live 0x0000000000000000
> serio_raw 13434 0 - Live 0x0000000000000000
> snd 87611 17 snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, Live 0x0000000000000000
> drm_kms_helper 61627 1 i915, Live 0x0000000000000000
> drm 310919 5 i915,drm_kms_helper, Live 0x0000000000000000
> lpc_ich 21093 0 - Live 0x0000000000000000
> soundcore 15052 2 snd_hda_codec,snd, Live 0x0000000000000000
> mei_me 19742 0 - Live 0x0000000000000000
> mei 87931 1 mei_me, Live 0x0000000000000000
> i2c_algo_bit 13406 1 i915, Live 0x0000000000000000
> ideapad_laptop 18278 0 - Live 0x0000000000000000
> sparse_keymap 13948 1 ideapad_laptop, Live 0x0000000000000000
> wmi 19193 0 - Live 0x0000000000000000
> video 20128 1 i915, Live 0x0000000000000000
> mac_hid 13227 0 - Live 0x0000000000000000
> parport_pc 32741 0 - Live 0x0000000000000000
> ppdev 17671 0 - Live 0x0000000000000000
> lp 17759 0 - Live 0x0000000000000000
> parport 42299 3 parport_pc,ppdev,lp, Live 0x0000000000000000
> rtsx_usb_sdmmc 27787 0 - Live 0x0000000000000000
> rtsx_usb 20933 2 rtsx_usb_ms,rtsx_usb_sdmmc, Live 0x0000000000000000
> psmouse 106548 0 - Live 0x0000000000000000
> ahci 34062 2 - Live 0x0000000000000000
> libahci 32424 1 ahci, Live 0x0000000000000000
>
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
>
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>   0020-0021 : pic1
>   0040-0043 : timer0
>   0050-0053 : timer1
>   0060-0060 : keyboard
>   0062-0062 : PNP0C09:00
>     0062-0062 : EC data
>   0064-0064 : keyboard
>   0066-0066 : PNP0C09:00
>     0066-0066 : EC cmd
>   0070-0077 : rtc0
>   0080-008f : dma page reg
>   00a0-00a1 : pic2
>   00c0-00df : dma2
>   00f0-00ff : fpu
>     00f0-00f0 : PNP0C04:00
>   03c0-03df : vga+
>   0400-0403 : ACPI PM1a_EVT_BLK
>   0404-0405 : ACPI PM1a_CNT_BLK
>   0408-040b : ACPI PM_TMR
>   0410-0415 : ACPI CPU throttle
>   0420-042f : ACPI GPE0_BLK
>   0430-0433 : iTCO_wdt
>   0450-0450 : ACPI PM2_CNT_BLK
>   0454-0457 : pnp 00:02
>   0458-047f : pnp 00:00
>     0460-047f : iTCO_wdt
>   0500-057f : pnp 00:00
>   0680-069f : pnp 00:00
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>   1100-110f : pnp 00:00
>   164e-164f : pnp 00:00
>   2000-203f : 0000:00:02.0
>   2040-205f : 0000:00:1f.3
>   2060-207f : 0000:00:1f.2
>     2060-207f : ahci
>   2080-2087 : 0000:00:1f.2
>     2080-2087 : ahci
>   2088-208f : 0000:00:1f.2
>     2088-208f : ahci
>   2090-2093 : 0000:00:1f.2
>     2090-2093 : ahci
>   2094-2097 : 0000:00:1f.2
>     2094-2097 : ahci
>   ffff-ffff : pnp 00:00
>     ffff-ffff : pnp 00:00
>
> 00000000-00000fff : reserved
> 00001000-0009d3ff : System RAM
> 0009d400-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000cefff : Video ROM
> 000e0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-1fffffff : System RAM
>   01000000-0178f215 : Kernel code
>   0178f216-01d2c2bf : Kernel data
>   01e8a000-01fd0fff : Kernel bss
> 20000000-201fffff : reserved
>   20000000-201fffff : pnp 00:06
> 20200000-40003fff : System RAM
> 40004000-40004fff : reserved
>   40004000-40004fff : pnp 00:06
> 40005000-c4daffff : System RAM
> c4db0000-c61affff : reserved
> c61b0000-caabefff : System RAM
> caabf000-caebefff : reserved
> caebf000-cafbefff : ACPI Non-volatile Storage
> cafbf000-caffefff : ACPI Tables
> cafff000-caffffff : System RAM
> cb000000-cf9fffff : reserved
>   cba00000-cf9fffff : Graphics Stolen Memory
> cfa00000-feafffff : PCI Bus 0000:00
>   cfa00000-cfa00fff : pnp 00:05
>   cfa08000-cfa0ffff : 0000:00:04.0
>   d0000000-dfffffff : 0000:00:02.0
>   e0000000-e03fffff : 0000:00:02.0
>   e0400000-e040ffff : 0000:00:14.0
>     e0400000-e040ffff : xhci_hcd
>   e0418000-e041bfff : 0000:00:1b.0
>     e0418000-e041bfff : ICH HD audio
>   e041c000-e041c00f : 0000:00:16.0
>     e041c000-e041c00f : mei_me
>   e041d000-e041d0ff : 0000:00:1f.3
>   e041e000-e041efff : 0000:00:1f.6
>   e041f000-e041f7ff : 0000:00:1f.2
>     e041f000-e041f7ff : ahci
>   e0420000-e04203ff : 0000:00:1d.0
>     e0420000-e04203ff : ehci_hcd
>   e0421000-e04213ff : 0000:00:1a.0
>     e0421000-e04213ff : ehci_hcd
>   f0000000-f3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
>     f0000000-f3ffffff : reserved
>       f0000000-f3ffffff : pnp 00:05
> feb00000-feb03fff : reserved
> fec00000-fec00fff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fed00000-fed003ff : HPET 0
>   fed00000-fed003ff : PNP0103:00
> fed10000-fed19fff : reserved
>   fed10000-fed17fff : pnp 00:05
>   fed18000-fed18fff : pnp 00:05
>   fed19000-fed19fff : pnp 00:05
> fed1c000-fed1ffff : reserved
>   fed1c000-fed1ffff : pnp 00:05
>     fed1f410-fed1f414 : iTCO_wdt
> fed20000-fed3ffff : pnp 00:05
> fed90000-fed90fff : dmar0
> fed91000-fed91fff : dmar1
> fed98000-fed9ffff : reserved
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> ff000000-ffffffff : INT0800:00
>   ffcc0000-ffffffff : reserved
> 100000000-12f5fffff : System RAM
> 12f600000-12fffffff : RAM buffer
>
> [7.5.] PCI information ('lspci -vvv' as root)
>
> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
> Kernel driver in use: ivb_uncore
>
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
> Subsystem: Lenovo Device 3977
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 45
> Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=4M]
> Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
> Region 4: I/O ports at 2000 [size=64]
> Expansion ROM at <unassigned> [disabled]
> Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: fee00018  Data: 0000
> Capabilities: [d0] Power Management version 2
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [a4] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: i915
>
> 00:04.0 Signal processing controller: Intel Corporation 3rd Gen Core Processor Thermal Subsystem (rev 09)
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 7
> Region 0: Memory at cfa08000 (64-bit, non-prefetchable) [size=32K]
> Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [d0] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 42
> Region 0: Memory at e0400000 (64-bit, non-prefetchable) [size=64K]
> Capabilities: [70] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
> Address: 00000000fee002d8  Data: 0000
> Kernel driver in use: xhci_hcd
>
> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 44
> Region 0: Memory at e041c000 (64-bit, non-prefetchable) [size=16]
> Capabilities: [50] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee00338  Data: 0000
> Kernel driver in use: mei_me
>
> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at e0421000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
>
> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 46
> Region 0: Memory at e0418000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee00378  Data: 0000
> Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0
> ExtTag- RBE-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=22
> Status: NegoPending- InProgress-
> Capabilities: [130 v1] Root Complex Link
> Desc: PortNumber=0f ComponentID=00 EltType=Config
> Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
> Addr: 00000000fed1c000
> Kernel driver in use: snd_hda_intel
>
> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 23
> Region 0: Memory at e0420000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
>
> 00:1f.0 ISA bridge: Intel Corporation QS77 Express Chipset LPC Controller (rev 04)
> Subsystem: Lenovo Device 3977
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
> Kernel driver in use: lpc_ich
>
> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
> Subsystem: Lenovo Device 3977
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin B routed to IRQ 43
> Region 0: I/O ports at 2088 [size=8]
> Region 1: I/O ports at 2094 [size=4]
> Region 2: I/O ports at 2080 [size=8]
> Region 3: I/O ports at 2090 [size=4]
> Region 4: I/O ports at 2060 [size=32]
> Region 5: Memory at e041f000 (32-bit, non-prefetchable) [size=2K]
> Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: fee00318  Data: 0000
> Capabilities: [70] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> Capabilities: [b0] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ahci
>
> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
> Subsystem: Lenovo Device 3977
> Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Interrupt: pin C routed to IRQ 10
> Region 0: Memory at e041d000 (64-bit, non-prefetchable) [size=256]
> Region 4: I/O ports at 2040 [size=32]
>
> 00:1f.6 Signal processing controller: Intel Corporation 7 Series/C210 Series Chipset Family Thermal Management Controller (rev 04)
> Subsystem: Lenovo Device 3977
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 11
> Region 0: Memory at e041e000 (64-bit, non-prefetchable) [size=4K]
> Capabilities: [50] Power Management version 3
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>
> [7.6.] SCSI information (from /proc/scsi/scsi)
>
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: SAMSUNG MZMPC128 Rev: 3L1Q
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>
