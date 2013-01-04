Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:29168 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab3ADTyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 14:54:25 -0500
Received: from localhost ([127.0.0.1] helo=www.infidigm.net)
	by freiheit with esmtp (Exim 4.72)
	(envelope-from <drwho@infidigm.net>)
	id 1TrE5O-0007z9-7e
	for linux-wireless@vger.kernel.org; Fri, 04 Jan 2013 15:41:50 -0500
Message-ID: <684e90743a626be50768909b1b2f90d1.squirrel@www.infidigm.net> (sfid-20130104_205429_867215_B281A7DA)
Date: Fri, 4 Jan 2013 15:41:50 -0500
Subject: ath6kl ar6004 hw1.3 crashing after +2hrs
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using a USB AR9374 (AR6004 hw1.3), after about 2 hours of full out
bidirectional transfers (wired unit doing wget from ar6004, ar6004 doing
wget from wired unit at the same time) wgets stall.

Testing using Kalle Valo's kernel (git://github.com/kvalo/ath6kl.git)
pulled on Jan 2nd, 2013.  Kernel built using Ubuntu's "kernel from git"
instructions. (https://wiki.ubuntu.com/KernelTeam/GitKernelBuild) Used 
Ubuntu kernel config from 3.8.0-030800rc1-generic and turned on ath6kl
stuff.  SL410 Thinkpad.

AP = TP-LINK TL-WR1043ND - OpenWrt Backfire 10.03.1

iw wlan4 link =

Connected to b0:48:7a:a5:ab:12 (on wlan4)
	SSID: ******
	freq: 2412
	RX: 2757852591 bytes (23998416 packets)
	TX: 1177664774 bytes (16531721 packets)
	signal: -48 dBm
	tx bitrate: 81.0 MBit/s MCS 4 40Mhz

	bss flags:
	dtim period:	2
	beacon int:	100

some of the output of dmseg.  I have more if interested.

[50879.002475] WARNING: at drivers/net/wireless/ath/ath6kl/wmi.c:3295
ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]()
[50879.002480] Hardware name: 284222U
[50879.002485] Modules linked in: ath6kl_sdio(F) mmc_block(F) joydev(F)
arc4(F) ath6kl_usb(F) uvcvideo(F) ath6kl_core(F) rtl8192se(F) rtlwifi(F)
i915(F) snd_hda_codec_hdmi(F) videobuf2_core(F) mac80211(F) videodev(F)
snd_hda_codec_realtek(F) cfg80211(F) videobuf2_vmalloc(F)
drm_kms_helper(F) videobuf2_memops(F) coretemp(F) sdhci_pci(F)
snd_hda_intel(F) drm(F) snd_hda_codec(F) cdc_acm(F) r8169(F) cdc_ether(F)
cdc_wdm(F) jmb38x_ms(F) sdhci(F) usbnet(F) microcode(F) snd_hwdep(F)
psmouse(F) snd_pcm(F) memstick(F) i2c_algo_bit(F) lpc_ich(F) serio_raw(F)
snd_page_alloc(F) rfcomm(F) bnep(F) wmi(F) bluetooth(F) parport_pc(F)
ppdev(F) thinkpad_acpi(F) snd_seq_midi(F) snd_rawmidi(F)
snd_seq_midi_event(F) snd_seq(F) snd_timer(F) snd_seq_device(F) snd(F)
soundcore(F) nvram(F) video(F) mac_hid(F) lp(F) parport(F)
[50879.002630] Pid: 3122, comm: kworker/1:0 Tainted: GF       W   
3.7.0-rc7-custom-wl-ar6 #1
[50879.002635] Call Trace:
[50879.002652]  [<c104b0a2>] warn_slowpath_common+0x72/0xa0
[50879.002672]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50879.002691]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50879.002701]  [<c104b0f2>] warn_slowpath_null+0x22/0x30
[50879.002720]  [<f8b9fda6>] ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50879.002742]  [<f8b99479>] ath6kl_tgt_stats_event+0x2e9/0x490
[ath6kl_core]
[50879.002762]  [<f8ba20e2>] ath6kl_wmi_control_rx+0x15c2/0x2200
[ath6kl_core]
[50879.002773]  [<c14fe497>] ? netif_rx+0x97/0x180
[50879.002794]  [<f8b9bdf4>] ath6kl_rx+0x484/0xad0 [ath6kl_core]
[50879.002813]  [<f8b8c663>] do_recv_completion.isra.1+0x33/0x40
[ath6kl_core]
[50879.002830]  [<f8b8d586>] ath6kl_htc_pipe_rx_complete+0x356/0x4e0
[ath6kl_core]
[50879.002841]  [<c103d5a8>] ? default_spin_lock_flags+0x8/0x10
[50879.002853]  [<c15f198d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[50879.002872]  [<f8ba2e12>] ath6kl_core_rx_complete+0x12/0x20
[ath6kl_core]
[50879.002883]  [<f891e5f3>] ath6kl_usb_io_comp_work+0xa3/0xb0
[ath6kl_usb]
[50879.002896]  [<c1066ee0>] process_one_work+0x110/0x370
[50879.002906]  [<c15f90f3>] ? common_interrupt+0x33/0x38
[50879.002916]  [<f891e550>] ? ath6kl_usb_reset_resume+0x30/0x30
[ath6kl_usb]
[50879.002926]  [<c10678f9>] worker_thread+0x119/0x350
[50879.002935]  [<c10677e0>] ? manage_workers+0x250/0x250
[50879.002944]  [<c106bf64>] kthread+0x94/0xa0
[50879.002954]  [<c1070000>] ? debug_deactivate.part.15+0x30/0x40
[50879.002964]  [<c15f8af7>] ret_from_kernel_thread+0x1b/0x28
[50879.002972]  [<c106bed0>] ? flush_kthread_worker+0x90/0x90
[50879.002979] ---[ end trace 902534d2f7791bd7 ]---
[50885.002752] ------------[ cut here ]------------
[50885.002787] WARNING: at drivers/net/wireless/ath/ath6kl/wmi.c:3295
ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]()
[50885.002793] Hardware name: 284222U
[50885.002797] Modules linked in: ath6kl_sdio(F) mmc_block(F) joydev(F)
arc4(F) ath6kl_usb(F) uvcvideo(F) ath6kl_core(F) rtl8192se(F) rtlwifi(F)
i915(F) snd_hda_codec_hdmi(F) videobuf2_core(F) mac80211(F) videodev(F)
snd_hda_codec_realtek(F) cfg80211(F) videobuf2_vmalloc(F)
drm_kms_helper(F) videobuf2_memops(F) coretemp(F) sdhci_pci(F)
snd_hda_intel(F) drm(F) snd_hda_codec(F) cdc_acm(F) r8169(F) cdc_ether(F)
cdc_wdm(F) jmb38x_ms(F) sdhci(F) usbnet(F) microcode(F) snd_hwdep(F)
psmouse(F) snd_pcm(F) memstick(F) i2c_algo_bit(F) lpc_ich(F) serio_raw(F)
snd_page_alloc(F) rfcomm(F) bnep(F) wmi(F) bluetooth(F) parport_pc(F)
ppdev(F) thinkpad_acpi(F) snd_seq_midi(F) snd_rawmidi(F)
snd_seq_midi_event(F) snd_seq(F) snd_timer(F) snd_seq_device(F) snd(F)
soundcore(F) nvram(F) video(F) mac_hid(F) lp(F) parport(F)
[50885.003006] Pid: 3122, comm: kworker/1:0 Tainted: GF       W   
3.7.0-rc7-custom-wl-ar6 #1
[50885.003011] Call Trace:
[50885.003028]  [<c104b0a2>] warn_slowpath_common+0x72/0xa0
[50885.003049]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50885.003068]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50885.003078]  [<c104b0f2>] warn_slowpath_null+0x22/0x30
[50885.003097]  [<f8b9fda6>] ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50885.003119]  [<f8b99479>] ath6kl_tgt_stats_event+0x2e9/0x490
[ath6kl_core]
[50885.003138]  [<f8ba20e2>] ath6kl_wmi_control_rx+0x15c2/0x2200
[ath6kl_core]
[50885.003149]  [<c14fe497>] ? netif_rx+0x97/0x180
[50885.003170]  [<f8b9bdf4>] ath6kl_rx+0x484/0xad0 [ath6kl_core]
[50885.003181]  [<c1115fdc>] ? put_page+0x2c/0x40
[50885.003191]  [<c14f22cd>] ? __kfree_skb+0x3d/0x90
[50885.003209]  [<f8b8c663>] do_recv_completion.isra.1+0x33/0x40
[ath6kl_core]
[50885.003226]  [<f8b8d586>] ath6kl_htc_pipe_rx_complete+0x356/0x4e0
[ath6kl_core]
[50885.003243]  [<f8b8c6d2>] ? do_send_completion+0x62/0xc0 [ath6kl_core]
[50885.003255]  [<c103d5a8>] ? default_spin_lock_flags+0x8/0x10
[50885.003267]  [<c15f198d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[50885.003286]  [<f8ba2e12>] ath6kl_core_rx_complete+0x12/0x20
[ath6kl_core]
[50885.003297]  [<f891e5f3>] ath6kl_usb_io_comp_work+0xa3/0xb0
[ath6kl_usb]
[50885.003310]  [<c1066ee0>] process_one_work+0x110/0x370
[50885.003320]  [<c15f1f50>] ? apic_timer_interrupt+0x34/0x3c
[50885.003329]  [<f891e550>] ? ath6kl_usb_reset_resume+0x30/0x30
[ath6kl_usb]
[50885.003339]  [<c10678f9>] worker_thread+0x119/0x350
[50885.003348]  [<c10677e0>] ? manage_workers+0x250/0x250
[50885.003357]  [<c106bf64>] kthread+0x94/0xa0
[50885.003367]  [<c1070000>] ? debug_deactivate.part.15+0x30/0x40
[50885.003377]  [<c15f8af7>] ret_from_kernel_thread+0x1b/0x28
[50885.003385]  [<c106bed0>] ? flush_kthread_worker+0x90/0x90
[50885.003392] ---[ end trace 902534d2f7791bd8 ]---
[50903.002028] ------------[ cut here ]------------
[50903.002063] WARNING: at drivers/net/wireless/ath/ath6kl/wmi.c:3295
ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]()
[50903.002081] Hardware name: 284222U
[50903.002085] Modules linked in: ath6kl_sdio(F) mmc_block(F) joydev(F)
arc4(F) ath6kl_usb(F) uvcvideo(F) ath6kl_core(F) rtl8192se(F) rtlwifi(F)
i915(F) snd_hda_codec_hdmi(F) videobuf2_core(F) mac80211(F) videodev(F)
snd_hda_codec_realtek(F) cfg80211(F) videobuf2_vmalloc(F)
drm_kms_helper(F) videobuf2_memops(F) coretemp(F) sdhci_pci(F)
snd_hda_intel(F) drm(F) snd_hda_codec(F) cdc_acm(F) r8169(F) cdc_ether(F)
cdc_wdm(F) jmb38x_ms(F) sdhci(F) usbnet(F) microcode(F) snd_hwdep(F)
psmouse(F) snd_pcm(F) memstick(F) i2c_algo_bit(F) lpc_ich(F) serio_raw(F)
snd_page_alloc(F) rfcomm(F) bnep(F) wmi(F) bluetooth(F) parport_pc(F)
ppdev(F) thinkpad_acpi(F) snd_seq_midi(F) snd_rawmidi(F)
snd_seq_midi_event(F) snd_seq(F) snd_timer(F) snd_seq_device(F) snd(F)
soundcore(F) nvram(F) video(F) mac_hid(F) lp(F) parport(F)
[50903.002231] Pid: 3122, comm: kworker/1:0 Tainted: GF       W   
3.7.0-rc7-custom-wl-ar6 #1
[50903.002237] Call Trace:
[50903.002253]  [<c104b0a2>] warn_slowpath_common+0x72/0xa0
[50903.002274]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50903.002293]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50903.002315]  [<c104b0f2>] warn_slowpath_null+0x22/0x30
[50903.002335]  [<f8b9fda6>] ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50903.002357]  [<f8b99479>] ath6kl_tgt_stats_event+0x2e9/0x490
[ath6kl_core]
[50903.002378]  [<f8ba20e2>] ath6kl_wmi_control_rx+0x15c2/0x2200
[ath6kl_core]
[50903.002389]  [<c14fe497>] ? netif_rx+0x97/0x180
[50903.002410]  [<f8b9bdf4>] ath6kl_rx+0x484/0xad0 [ath6kl_core]
[50903.002429]  [<f8b8c663>] do_recv_completion.isra.1+0x33/0x40
[ath6kl_core]
[50903.002446]  [<f8b8d586>] ath6kl_htc_pipe_rx_complete+0x356/0x4e0
[ath6kl_core]
[50903.002463]  [<f8b8c6d2>] ? do_send_completion+0x62/0xc0 [ath6kl_core]
[50903.002475]  [<c103d5a8>] ? default_spin_lock_flags+0x8/0x10
[50903.002486]  [<c15f198d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[50903.002505]  [<f8ba2e12>] ath6kl_core_rx_complete+0x12/0x20
[ath6kl_core]
[50903.002516]  [<f891e5f3>] ath6kl_usb_io_comp_work+0xa3/0xb0
[ath6kl_usb]
[50903.002528]  [<c1066ee0>] process_one_work+0x110/0x370
[50903.002538]  [<c15f90f3>] ? common_interrupt+0x33/0x38
[50903.002548]  [<f891e550>] ? ath6kl_usb_reset_resume+0x30/0x30
[ath6kl_usb]
[50903.002558]  [<c10678f9>] worker_thread+0x119/0x350
[50903.002567]  [<c10677e0>] ? manage_workers+0x250/0x250
[50903.002576]  [<c106bf64>] kthread+0x94/0xa0
[50903.002585]  [<c1070000>] ? debug_deactivate.part.15+0x30/0x40
[50903.002595]  [<c15f8af7>] ret_from_kernel_thread+0x1b/0x28
[50903.002604]  [<c106bed0>] ? flush_kthread_worker+0x90/0x90
[50903.002610] ---[ end trace 902534d2f7791bd9 ]---
[50927.002483] ------------[ cut here ]------------
[50927.002518] WARNING: at drivers/net/wireless/ath/ath6kl/wmi.c:3295
ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]()
[50927.002523] Hardware name: 284222U
[50927.002527] Modules linked in: ath6kl_sdio(F) mmc_block(F) joydev(F)
arc4(F) ath6kl_usb(F) uvcvideo(F) ath6kl_core(F) rtl8192se(F) rtlwifi(F)
i915(F) snd_hda_codec_hdmi(F) videobuf2_core(F) mac80211(F) videodev(F)
snd_hda_codec_realtek(F) cfg80211(F) videobuf2_vmalloc(F)
drm_kms_helper(F) videobuf2_memops(F) coretemp(F) sdhci_pci(F)
snd_hda_intel(F) drm(F) snd_hda_codec(F) cdc_acm(F) r8169(F) cdc_ether(F)
cdc_wdm(F) jmb38x_ms(F) sdhci(F) usbnet(F) microcode(F) snd_hwdep(F)
psmouse(F) snd_pcm(F) memstick(F) i2c_algo_bit(F) lpc_ich(F) serio_raw(F)
snd_page_alloc(F) rfcomm(F) bnep(F) wmi(F) bluetooth(F) parport_pc(F)
ppdev(F) thinkpad_acpi(F) snd_seq_midi(F) snd_rawmidi(F)
snd_seq_midi_event(F) snd_seq(F) snd_timer(F) snd_seq_device(F) snd(F)
soundcore(F) nvram(F) video(F) mac_hid(F) lp(F) parport(F)
[50927.002685] Pid: 5483, comm: kworker/0:0 Tainted: GF       W   
3.7.0-rc7-custom-wl-ar6 #1
[50927.002690] Call Trace:
[50927.002706]  [<c104b0a2>] warn_slowpath_common+0x72/0xa0
[50927.002727]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50927.002746]  [<f8b9fda6>] ? ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50927.002756]  [<c104b0f2>] warn_slowpath_null+0x22/0x30
[50927.002775]  [<f8b9fda6>] ath6kl_wmi_get_rate+0x46/0x50 [ath6kl_core]
[50927.002798]  [<f8b99479>] ath6kl_tgt_stats_event+0x2e9/0x490
[ath6kl_core]
[50927.002818]  [<f8ba20e2>] ath6kl_wmi_control_rx+0x15c2/0x2200
[ath6kl_core]
[50927.002831]  [<c108414e>] ? find_busiest_group+0x2e/0x380
[50927.002841]  [<c14fe497>] ? netif_rx+0x97/0x180
[50927.002850]  [<c14f22cd>] ? __kfree_skb+0x3d/0x90
[50927.002871]  [<f8b9bdf4>] ath6kl_rx+0x484/0xad0 [ath6kl_core]
[50927.002890]  [<f8b8c663>] do_recv_completion.isra.1+0x33/0x40
[ath6kl_core]
[50927.002907]  [<f8b8d586>] ath6kl_htc_pipe_rx_complete+0x356/0x4e0
[ath6kl_core]
[50927.002918]  [<c103d5a8>] ? default_spin_lock_flags+0x8/0x10
[50927.002943]  [<c15f198d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[50927.002963]  [<f8ba2e12>] ath6kl_core_rx_complete+0x12/0x20
[ath6kl_core]
[50927.002973]  [<f891e5f3>] ath6kl_usb_io_comp_work+0xa3/0xb0
[ath6kl_usb]
[50927.002985]  [<c1066ee0>] process_one_work+0x110/0x370
[50927.002995]  [<c15f1f50>] ? apic_timer_interrupt+0x34/0x3c
[50927.003005]  [<f891e550>] ? ath6kl_usb_reset_resume+0x30/0x30
[ath6kl_usb]
[50927.003014]  [<c10678f9>] worker_thread+0x119/0x350
[50927.003023]  [<c10677e0>] ? manage_workers+0x250/0x250
[50927.003032]  [<c106bf64>] kthread+0x94/0xa0
[50927.003041]  [<c1070000>] ? debug_deactivate.part.15+0x30/0x40
[50927.003052]  [<c15f8af7>] ret_from_kernel_thread+0x1b/0x28
[50927.003060]  [<c106bed0>] ? flush_kthread_worker+0x90/0x90
[50927.003067] ---[ end trace 902534d2f7791bda ]---
[50933.002457] ------------[ cut here ]------------




