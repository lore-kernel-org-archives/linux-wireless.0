Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57456 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2B1Ouh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:50:37 -0500
Received: by vcqp1 with SMTP id p1so2536470vcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 06:50:36 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 28 Feb 2012 20:20:36 +0530
Message-ID: <CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com> (sfid-20120228_155041_506242_5F07EBA3)
Subject: WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
 iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

got this following warning  for the following card, it was my inbuilt
card it was just associated with an AP, wireless-testing 3.3.0-rc4-wl

03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
[Shiloh] Network Connection
        Subsystem: Intel Corporation Device 1211
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 48
        Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
00: 86 80 37 42 06 01 10 00 00 00 80 02 10 00 00 00
10: 04 00 30 f4 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 11 12
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00

24] ------------[ cut here ]------------
[11056.342672] WARNING: at
drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
[11056.342681] Hardware name: 64756D6
[11056.342687] reclaim is false, SEQ_RX_FRAME unset: STATISTICS_NOTIFICATION
[11056.342693] Modules linked in: aes_i586 aes_generic rfcomm bridge
stp bnep ath9k(O) ath9k_common(O) ath9k_hw(O) ath3k ath btusb
bluetooth binfmt_misc ppde
v arc4 iwlwifi snd_hda_codec_conexant mac80211 i915 snd_hda_intel
snd_hda_codec fbcon tileblit snd_hwdep snd_pcm_oss font bitblit
snd_mixer_oss snd_pcm think
pad_acpi softcursor snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event drm_kms_helper joydev snd_seq drm cfg80211 pcmcia
snd_timer snd_seq
_device uvcvideo videobuf2_core i2c_algo_bit intel_agp psmouse
intel_gtt videodev snd video soundcore yenta_socket agpgart tpm_tis
tpm videobuf2_vmalloc lp v
ideobuf2_memops snd_page_alloc nvram pcmcia_rsrc pcmcia_core tpm_bios
serio_raw parport ahci libahci e1000e
[11056.342921] Pid: 0, comm: swapper/0 Tainted: G        W  O 3.3.0-rc4-wl #11
[11056.342928] Call Trace:
[11056.342947]  [<c0133b02>] warn_slowpath_common+0x72/0xa0
[11056.342986]  [<f851ca28>] ? iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]
[11056.343022]  [<f851ca28>] ? iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]
[11056.343034]  [<c0133bd3>] warn_slowpath_fmt+0x33/0x40
[11056.343071]  [<f851ca28>] iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]
[11056.343090]  [<c01913f1>] ? trace_hardirqs_on_caller+0xa1/0x180
[11056.343102]  [<c01914db>] ? trace_hardirqs_on+0xb/0x10
[11056.343113]  [<c01ca227>] ? __rcu_process_callbacks+0x47/0x3e0
[11056.343126]  [<c013bc2e>] tasklet_action+0xbe/0x180
[11056.343136]  [<c013b05f>] __do_softirq+0xaf/0x2e0
[11056.343148]  [<c013afb0>] ? perf_trace_irq_handler_entry+0x120/0x120
[11056.343156]  <IRQ>  [<c013ac55>] ? irq_exit+0xb5/0xd0
[11056.343176]  [<c06a2d5b>] ? do_IRQ+0x4b/0xc0
[11056.343188]  [<c016be95>] ? sched_clock_local+0xa5/0x180
[11056.343200]  [<c06a2c75>] ? common_interrupt+0x35/0x40
[11056.343211]  [<c019007b>] ? check_usage_forwards+0x6b/0xe0
[11056.343225]  [<c04342d9>] ? acpi_idle_enter_bm+0x247/0x282
[11056.343239]  [<c0561db9>] ? cpuidle_idle_call+0xa9/0x210
[11056.343250]  [<c0101fe9>] ? cpu_idle+0xa9/0x100
[11056.343261]  [<c067eecc>] ? rest_init+0xec/0x150
[11056.343271]  [<c067ee2d>] ? rest_init+0x4d/0x150
[11056.343285]  [<c0953851>] ? start_kernel+0x387/0x38d
[11056.343296]  [<c09532f6>] ? kernel_init+0x149/0x149
[11056.343308]  [<c0953075>] ? i386_start_kernel+0x75/0x79
[11056.343315] ---[ end trace 899cb4cab2cee742 ]---
[12661.000216] wlan0: detected beacon loss from AP - sending probe request
[12661.054472] wlan0: cancelling probereq poll due to a received beacon
[12745.168125] thinkpad_acpi: EC reports that Thermal Table has changed


-- 
thanks,
shafi
