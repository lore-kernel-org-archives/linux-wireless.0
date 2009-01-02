Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:59778 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZABP7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 10:59:18 -0500
Received: by bwz14 with SMTP id 14so20183300bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 07:59:15 -0800 (PST)
To: der.claudio@aon.at
Cc: linux-wireless@vger.kernel.org
Subject: Re: status of at76-usb driver
References: <11844363.2869.1230645164289.JavaMail.root@WARSBL214.highway.telekom.at>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 02 Jan 2009 17:53:08 +0200
In-Reply-To: <11844363.2869.1230645164289.JavaMail.root@WARSBL214.highway.telekom.at> (Claudio's message of "Tue\, 30 Dec 2008 14\:52\:44 +0100 \(CET\)")
Message-ID: <87fxk1902j.fsf@litku.valot.fi> (sfid-20090102_165931_736617_779370DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Claudio <der.claudio@aon.at> writes:

> my at76 hardware: Netgear MA101 rev.B
>
> experiences:
> - works with Ubuntu 7.10 with stand-alone at76-usb-0.17 package
> - AFAIR didn't work with Ubuntu 7.10 out-of-the-box
> - didn't work with Ubuntu 8.10 (even didn't when I tried to install the
>   old stand-alone version)
>
> By "does not work" I mean it initializes correctly and sometimes(!)
> displays our network, but won't establish a connection.
>
> I am curious hearing about your experience.

I tried twice with latest Ubuntu 8.10 (updated yesterday) and kernel
oopsed both time for me:

[  406.516067] usb 2-2: new full speed USB device using uhci_hcd and address 2
[  406.678113] usb 2-2: configuration #1 chosen from 1 choice
[  407.294144] at76_usb: Atmel at76c50x USB Wireless LAN Driver 0.14beta1 loading
[  407.297435] firmware: requesting atmel_at76c503-rfmd.bin
[  407.379144] usbcore: registered new interface driver at76_usb
[  409.544088] at76_usb: wlan0 disconnecting
[  409.546070] at76_usb: at76_usb disconnected
[  409.660069] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[  409.804597] usb 2-2: device firmware changed
[  409.806621] usb 2-2: USB disconnect, address 2
[  409.809482] firmware: requesting atmel_at76c503-rfmd.bin
[  409.817171] at76_usb: wlan0 disconnecting
[  409.819601] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  409.819617] IP: [<c037da0b>] __up+0xb/0x40
[  409.819635] *pde = 00000000 
[  409.819645] Oops: 0000 [#1] SMP 
[  409.819654] Modules linked in: at76_usb af_packet radeon drm bridge rfcomm stp bnep sco l2cap bluetooth thinkpad_acpi rfkill led_class nvram ppdev ipv6 speedstep_ich speedstep_lib cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_ondemand freq_table cpufreq_userspace sbs container sbshc wmi pci_slot iptable_filter ip_tables x_tables lp pcmcia evdev battery ac psmouse serio_raw video output snd_intel8x0 snd_ac97_codec ac97_bus parport_pc snd_pcm_oss snd_mixer_oss parport snd_pcm irda crc_ccitt snd_seq_dummy pcspkr yenta_socket rsrc_nonstatic pcmcia_core snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device button snd iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc intel_agp agpgart shpchp pci_hotplug ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg pata_acpi ata_piix ata_generic libata uhci_hcd e100 mii scsi_mod usbcore dock thermal processor fan fbcon tileblit font bitblit softcursor fuse
[  409.819837] 
[  409.819843] Pid: 6, comm: events/0 Not tainted (2.6.27-9-generic #1)
[  409.819850] EIP: 0060:[<c037da0b>] EFLAGS: 00010046 CPU: 0
[  409.819859] EIP is at __up+0xb/0x40
[  409.819865] EAX: 00000000 EBX: ddc7b528 ECX: 00000000 EDX: 00000000
[  409.819871] ESI: 00000246 EDI: e0d367b0 EBP: df065ec8 ESP: df065ec8
[  409.819877]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  409.819885] Process events/0 (pid: 6, ti=df064000 task=df053ed0 task.ti=df064000)
[  409.819891] Stack: df065ed8 c014c102 ddc7b690 ddc7b480 df065f6c e0d36a24 df065f08 df053ed0 
[  409.819910]        c046e340 df065f14 c0102df6 df05420c c1489980 df065f1c ddc7b480 ddc7b53c 
[  409.819928]        ddc7b528 ddc7b538 c0513d00 df053ed0 c046e340 df065fa4 c037ca49 df065f90 
[  409.819947] Call Trace:
[  409.819953]  [<c014c102>] ? up+0x42/0x50
[  409.819968]  [<e0d36a24>] ? kevent+0x274/0x1710 [at76_usb]
[  409.819990]  [<c0102df6>] ? __switch_to+0xa6/0x160
[  409.820002]  [<c037ca49>] ? schedule+0x429/0x790
[  409.820016]  [<c0143814>] ? queue_delayed_work_on+0xb4/0xe0
[  409.820030]  [<c0192350>] ? vmstat_update+0x0/0x30
[  409.820038]  [<e0d367b0>] ? kevent+0x0/0x1710 [at76_usb]
[  409.820038]  [<c0143645>] ? run_workqueue+0x95/0x160
[  409.820038]  [<c0147576>] ? finish_wait+0x16/0x70
[  409.820038]  [<c01438e8>] ? worker_thread+0x88/0xf0
[  409.820038]  [<c01474b0>] ? autoremove_wake_function+0x0/0x50
[  409.820038]  [<c0143860>] ? worker_thread+0x0/0xf0
[  409.820038]  [<c0147141>] ? kthread+0x41/0x80
[  409.820038]  [<c0147100>] ? kthread+0x0/0x80
[  409.820038]  [<c0105297>] ? kernel_thread_helper+0x7/0x10
[  409.820038]  =======================
[  409.820038] Code: 55 89 e5 53 e8 b7 78 d8 ff 89 c3 e8 80 f4 ff ff 89 d8 90 ff 00 79 05 e8 b4 0a 00 00 5b 5d c3 00 55 89 e5 e8 98 78 d8 ff 8b 40 08 <8b> 08 8b 50 04 89 51 04 89 0a c7 40 04 00 02 20 00 c7 00 00 01 
[  409.820038] EIP: [<c037da0b>] __up+0xb/0x40 SS:ESP 0068:df065ec8
[  409.820038] ---[ end trace 6ce3c49c2e0a5efe ]---

-- 
Kalle Valo
