Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63220 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbcGQVFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2016 17:05:37 -0400
Date: Sun, 17 Jul 2016 23:05:19 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: miaoqing@codeaurora.org
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH] ath9k: fix GPIO mask for AR9462 and AR9565
Message-ID: <20160717230519.46e3a661@mir> (sfid-20160717_230542_160510_9A1C099F)
In-Reply-To: <1464932817-30988-1-git-send-email-miaoqing@codeaurora.org>
References: <1464932817-30988-1-git-send-email-miaoqing@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2016-06-03, miaoqing@codeaurora.org wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> The incorrect GPIO mask cause kernel warning, when AR9462 access GPIO11.
> Also fix the mask for AR9565.
[...]

I think I'm seeing a very similar issue on AR5008/ AR5416+AR2133 and 
4.7-rc7 (mainline v4.7-rc7-92-g47ef4ad, to be exact).

[    4.958874] ath9k 0000:02:02.0: enabling device (0000 -> 0002)
[...]
[    5.401086] ------------[ cut here ]------------
[    5.401093] WARNING: CPU: 1 PID: 1159 at /build/linux-aptosid-4.7~rc7/drivers/net/wireless/ath/ath9k/hw.c:2776 ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]
[    5.401116] Modules linked in: iTCO_wdt gpio_ich iTCO_vendor_support evdev intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp ir_lirc_codec lirc_dev kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul rtl2832_sdr videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev ghash_clmulni_intel fc0013 rtl2832 i2c_mux regmap_i2c sha256_ssse3 sha256_generic drbg ansi_cprng rc_medion_x10_digitainer dvb_usb_rtl28xxu dvb_usb_v2 dvb_usb_dw2102(+) dvb_usb aesni_intel dvb_core aes_x86_64 lrw ati_remote media gf128mul glue_helper ablk_helper cryptd intel_cstate intel_rapl_perf snd_hda_codec_hdmi(+) i915 snd_hda_codec_realtek snd_hda_codec_generic pcspkr serio_raw i2c_i801 ath9k(+) ath9k_common video ath9k_hw i2c_algo_bit drm_kms_helper ath snd_hda_intel drm snd_hda_codec mac80211 snd_hda_core
[    5.401135]  snd_hwdep snd_pcm cfg80211 i2c_core intel_gtt rfkill snd_timer syscopyarea lpc_ich sysfillrect snd sg sysimgblt mfd_core mei_me soundcore fb_sys_fops mei nuvoton_cir floppy(+) rc_core button w83627ehf hwmon_vid parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 mbcache hid_generic usbhid hid dm_mod sd_mod sr_mod cdrom ohci_pci crc32c_intel psmouse r8169 ahci libahci libata scsi_mod xhci_pci xhci_hcd ohci_hcd e100 mii ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core fjes
[    5.401137] CPU: 1 PID: 1159 Comm: systemd-udevd Not tainted 4.7.0-rc7-aptosid-amd64 #1 aptosid 4.7~rc7-1~git92.slh.3
[    5.401138] Hardware name:                  /DH67CL, BIOS BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[    5.401140]  0000000000000286 00000000f912d633 ffffffff81290fd3 0000000000000000
[    5.401141]  0000000000000000 ffffffff81063fd4 ffff88040c6dc018 0000000000000000
[    5.401143]  0000000000000002 0000000000000000 0000000000000100 ffff88040c6dc018
[    5.401143] Call Trace:
[    5.401148]  [<ffffffff81290fd3>] ? dump_stack+0x5c/0x79
[    5.401150]  [<ffffffff81063fd4>] ? __warn+0xb4/0xd0
[    5.401153]  [<ffffffffa0668fb8>] ? ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]
[    5.401156]  [<ffffffffa0669653>] ? ath9k_hw_fill_cap_info+0x163/0x830 [ath9k_hw]
[    5.401159]  [<ffffffffa066a384>] ? ath9k_hw_init+0x664/0xb10 [ath9k_hw]
[    5.401167]  [<ffffffffa06fa7df>] ? ath9k_init_device+0x4df/0xe00 [ath9k]
[    5.401170]  [<ffffffff810b1e51>] ? request_threaded_irq+0xf1/0x1a0
[    5.401176]  [<ffffffffa070a259>] ? ath_pci_probe+0x1c9/0x370 [ath9k]
[    5.401178]  [<ffffffff812dad6a>] ? local_pci_probe+0x3a/0x90
[    5.401179]  [<ffffffff812dbccf>] ? pci_match_device+0xcf/0xf0
[    5.401180]  [<ffffffff812dc08b>] ? pci_device_probe+0xfb/0x140
[    5.401183]  [<ffffffff813b7dcd>] ? driver_probe_device+0x1ed/0x2b0
[    5.401184]  [<ffffffff813b7f1f>] ? __driver_attach+0x8f/0xa0
[    5.401185]  [<ffffffff813b7e90>] ? driver_probe_device+0x2b0/0x2b0
[    5.401186]  [<ffffffff813b5e12>] ? bus_for_each_dev+0x62/0xb0
[    5.401188]  [<ffffffff813b71ca>] ? bus_add_driver+0x19a/0x210
[    5.401189]  [<ffffffffa0718000>] ? 0xffffffffa0718000
[    5.401190]  [<ffffffff813b85b2>] ? driver_register+0x52/0xc0
[    5.401195]  [<ffffffffa0718005>] ? ath9k_init+0x5/0x34 [ath9k]
[    5.401197]  [<ffffffff81002147>] ? do_one_initcall+0x47/0x180
[    5.401199]  [<ffffffff8111b0a8>] ? do_init_module+0x51/0x1b9
[    5.401201]  [<ffffffff810d6e37>] ? load_module+0x1f77/0x23a0
[    5.401202]  [<ffffffff810d4330>] ? __symbol_put+0x80/0x80
[    5.401205]  [<ffffffff812277ac>] ? security_capable+0x3c/0x50
[    5.401207]  [<ffffffff810d7462>] ? SYSC_finit_module+0xc2/0xd0
[    5.401210]  [<ffffffff8153cd72>] ? entry_SYSCALL_64_fastpath+0x1a/0xa4
[    5.401211] ---[ end trace ac762697fb0d9f1d ]---
[    5.401211] ------------[ cut here ]------------
[    5.401214] WARNING: CPU: 1 PID: 1159 at /build/linux-aptosid-4.7~rc7/drivers/net/wireless/ath/ath9k/hw.c:2796 ath9k_hw_gpio_get+0xb4/0x1a0 [ath9k_hw]
[    5.401234] Modules linked in: iTCO_wdt gpio_ich iTCO_vendor_support evdev intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp ir_lirc_codec lirc_dev kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul rtl2832_sdr videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev ghash_clmulni_intel fc0013 rtl2832 i2c_mux regmap_i2c sha256_ssse3 sha256_generic drbg ansi_cprng rc_medion_x10_digitainer dvb_usb_rtl28xxu dvb_usb_v2 dvb_usb_dw2102(+) dvb_usb aesni_intel dvb_core aes_x86_64 lrw ati_remote media gf128mul glue_helper ablk_helper cryptd intel_cstate intel_rapl_perf snd_hda_codec_hdmi(+) i915 snd_hda_codec_realtek snd_hda_codec_generic pcspkr serio_raw i2c_i801 ath9k(+) ath9k_common video ath9k_hw i2c_algo_bit drm_kms_helper ath snd_hda_intel drm snd_hda_codec mac80211 snd_hda_core
[    5.401254]  snd_hwdep snd_pcm cfg80211 i2c_core intel_gtt rfkill snd_timer syscopyarea lpc_ich sysfillrect snd sg sysimgblt mfd_core mei_me soundcore fb_sys_fops mei nuvoton_cir floppy(+) rc_core button w83627ehf hwmon_vid parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 mbcache hid_generic usbhid hid dm_mod sd_mod sr_mod cdrom ohci_pci crc32c_intel psmouse r8169 ahci libahci libata scsi_mod xhci_pci xhci_hcd ohci_hcd e100 mii ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core fjes
[    5.401255] CPU: 1 PID: 1159 Comm: systemd-udevd Tainted: G        W       4.7.0-rc7-aptosid-amd64 #1 aptosid 4.7~rc7-1~git92.slh.3
[    5.401256] Hardware name:                  /DH67CL, BIOS BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[    5.401257]  0000000000000286 00000000f912d633 ffffffff81290fd3 0000000000000000
[    5.401258]  0000000000000000 ffffffff81063fd4 ffff88040c6dc018 0000000000000000
[    5.401260]  0000000000000002 0000000000000000 0000000000000100 ffff88040c6dc018
[    5.401260] Call Trace:
[    5.401262]  [<ffffffff81290fd3>] ? dump_stack+0x5c/0x79
[    5.401263]  [<ffffffff81063fd4>] ? __warn+0xb4/0xd0
[    5.401266]  [<ffffffffa0668f24>] ? ath9k_hw_gpio_get+0xb4/0x1a0 [ath9k_hw]
[    5.401268]  [<ffffffffa0669653>] ? ath9k_hw_fill_cap_info+0x163/0x830 [ath9k_hw]
[    5.401271]  [<ffffffffa066a384>] ? ath9k_hw_init+0x664/0xb10 [ath9k_hw]
[    5.401275]  [<ffffffffa06fa7df>] ? ath9k_init_device+0x4df/0xe00 [ath9k]
[    5.401277]  [<ffffffff810b1e51>] ? request_threaded_irq+0xf1/0x1a0
[    5.401282]  [<ffffffffa070a259>] ? ath_pci_probe+0x1c9/0x370 [ath9k]
[    5.401283]  [<ffffffff812dad6a>] ? local_pci_probe+0x3a/0x90
[    5.401284]  [<ffffffff812dbccf>] ? pci_match_device+0xcf/0xf0
[    5.401285]  [<ffffffff812dc08b>] ? pci_device_probe+0xfb/0x140
[    5.401287]  [<ffffffff813b7dcd>] ? driver_probe_device+0x1ed/0x2b0
[    5.401288]  [<ffffffff813b7f1f>] ? __driver_attach+0x8f/0xa0
[    5.401289]  [<ffffffff813b7e90>] ? driver_probe_device+0x2b0/0x2b0
[    5.401290]  [<ffffffff813b5e12>] ? bus_for_each_dev+0x62/0xb0
[    5.401291]  [<ffffffff813b71ca>] ? bus_add_driver+0x19a/0x210
[    5.401292]  [<ffffffffa0718000>] ? 0xffffffffa0718000
[    5.401293]  [<ffffffff813b85b2>] ? driver_register+0x52/0xc0
[    5.401297]  [<ffffffffa0718005>] ? ath9k_init+0x5/0x34 [ath9k]
[    5.401298]  [<ffffffff81002147>] ? do_one_initcall+0x47/0x180
[    5.401300]  [<ffffffff8111b0a8>] ? do_init_module+0x51/0x1b9
[    5.401301]  [<ffffffff810d6e37>] ? load_module+0x1f77/0x23a0
[    5.401303]  [<ffffffff810d4330>] ? __symbol_put+0x80/0x80
[    5.401304]  [<ffffffff812277ac>] ? security_capable+0x3c/0x50
[    5.401306]  [<ffffffff810d7462>] ? SYSC_finit_module+0xc2/0xd0
[    5.401307]  [<ffffffff8153cd72>] ? entry_SYSCALL_64_fastpath+0x1a/0xa4
[    5.401308] ---[ end trace ac762697fb0d9f1e ]---
[    5.403236] ath: EEPROM regdomain: 0x809c
[    5.403236] ath: EEPROM indicates we should expect a country code
[    5.403237] ath: doing EEPROM country->regdmn map search
[    5.403237] ath: country maps to regdmn code: 0x52
[    5.403238] ath: Country alpha2 being used: CN
[    5.403238] ath: Regpair used: 0x52
[...]
[    5.411361] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    5.411655] ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81 mem=0xffffc90002aa0000, irq=18
[    5.414043] ath9k 0000:02:02.0 wlp2s2: renamed from wlan0

02:02.0 Network controller [0280]: Qualcomm Atheros AR5416 Wireless Network Adapter [AR5008 802.11(a)bgn] [168c:0023] (rev 01)
        Subsystem: Qualcomm Atheros AR5416 Wireless Network Adapter [AR5008 802.11(a)bgn] [168c:3071]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe100000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] #80 [0000]
        Kernel driver in use: ath9k
        Kernel modules: ath9k

Bisecting leads me to:

$ git bisect log 
git bisect start 'drivers/net/wireless/ath/'
# good: [2dcd0af568b0cf583645c8a317dd12e344b1c72a] Linux 4.6
git bisect good 2dcd0af568b0cf583645c8a317dd12e344b1c72a
# bad: [47ef4ad2684d380dd6d596140fb79395115c3950] Merge tag 'for-linus-20160715' of git://git.infradead.org/linux-mtd
git bisect bad 47ef4ad2684d380dd6d596140fb79395115c3950
# bad: [b131129d96575479e2447d134cb1797cf430b3a4] ath10k: fix calibration init sequence of qca99x0
git bisect bad b131129d96575479e2447d134cb1797cf430b3a4
# good: [27ae9cd258a84ce7259afbee38dbe7841e723a68] ath9k: enable manual peak cal for all ar9300 chips
git bisect good 27ae9cd258a84ce7259afbee38dbe7841e723a68
# bad: [9d71d47eed20f34620e54e29bcc90f959d5873b8] ath10k: fix tx hang
git bisect bad 9d71d47eed20f34620e54e29bcc90f959d5873b8
# bad: [c8770bcf5cefa8cbfae21c07c4fe3428f5a9d42a] ath9k: Allow platform override BTCoex pin
git bisect bad c8770bcf5cefa8cbfae21c07c4fe3428f5a9d42a
# good: [c8c91b02a8ddb802259b712245ee97f9c3067a7f] ath9k_htc: fix up indents with spaces
git bisect good c8c91b02a8ddb802259b712245ee97f9c3067a7f
# bad: [b2d70d4944c1789bc64376ad97a811f37e230c87] ath9k: make GPIO API to support both of WMAC and SOC
git bisect bad b2d70d4944c1789bc64376ad97a811f37e230c87

Reverting this, and the other patches depending on it, fixes the 
problem for me:

e024111f6946f45cf1559a8c6fd48d2d0f696d07 Revert "ath9k: fix GPIO mask for AR9462 and AR9565"
db2221901fbded787daed153281ed875de489692 Revert "ath9k: free GPIO resource for SOC GPIOs"
c7212b7136ba69efb9785df68b669381cb893920 Revert "ath9k: fix BTCoex configuration for SOC chips"
dfcf02cd2998e2240b2bc7b4f4412578b8070bdb Revert "ath9k: fix BTCoex access invalid registers for SOC chips"
668ae0a3e48ac6811f431915b466514bf167e2f4 Revert "ath9k: add bits definition of BTCoex MODE2/3 for SOC chips"
c8770bcf5cefa8cbfae21c07c4fe3428f5a9d42a Revert "ath9k: Allow platform override BTCoex pin"
79d4db1214a0c7b1818aaf64d0606b17ff1acea7 Revert "ath9k: cleanup led_pin initial"
b2d70d4944c1789bc64376ad97a811f37e230c87 Revert "ath9k: make GPIO API to support both of WMAC and SOC"
a01ab81b09c55025365c1de1345b941a18e05529 Revert "ath9k: define correct GPIO numbers and bits mask"

AR9285 (168c:002b) is fine either way.

Regards
	Stefan Lippers-Hollmann
