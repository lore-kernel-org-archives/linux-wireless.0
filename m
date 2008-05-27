Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:57558 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYE0G2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 02:28:50 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2522599waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2008 23:28:50 -0700 (PDT)
Message-ID: <1ba2fa240805262328n2443c3bfr8e3fbf8ea88e1fd8@mail.gmail.com> (sfid-20080527_082855_279876_3762D547)
Date: Tue, 27 May 2008 09:28:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: Barteq <barteqpl@gmail.com>
Subject: Re: oops while trying to associate with TKIP-PSK network
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <op.ubsd290bi79708@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <op.ubsd290bi79708@thinkpad>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 3:24 AM, Barteq <barteqpl@gmail.com> wrote:
> Hello developers!
>
> I've got ubuntu backported kernel with iwl4965 driver version 1.2.26ks.
> Short after computer is being on it tries to associate with my home WPA-PSK
> network. After some tries it OOPS and forces me to reboot computer.
> Maybe it is fixed in the newest version, but I'm unable to build it due to
> compile errors (under 2.6.25-1-generic).
>
> Trace below:
>
> May 27 01:51:48 thinkpad kernel: [  208.540680] wlan0: authenticate with AP
> 00:13:10:4a:c6:88
> May 27 01:51:48 thinkpad kernel: [  208.542393] wlan0: RX authentication
> from 00:13:10:4a:c6:88 (alg=0 transaction=2 status=0)
> May 27 01:51:48 thinkpad kernel: [  208.542393] wlan0: authenticated
> May 27 01:51:48 thinkpad kernel: [  208.542393] wlan0: associate with AP
> 00:13:10:4a:c6:88
> May 27 01:51:48 thinkpad kernel: [  208.542393] BUG: unable to handle kernel
> NULL pointer dereference at 00000090
> May 27 01:51:48 thinkpad kernel: [  208.542393] IP: [<f8c2740c>]
> :mac80211:ieee80211_associate+0x24c/0x640
> May 27 01:51:48 thinkpad kernel: [  208.542393] *pde = 00000000
> May 27 01:51:48 thinkpad kernel: [  208.542393] Oops: 0000 [#1] SMP
> May 27 01:51:48 thinkpad kernel: [  208.542393] Modules linked in: af_packet
> ipv6 binfmt_misc container sbs sbshc acpi_cpufreq cpufreq_powersav
> e cpufreq_stats cpufreq_userspace cpufreq_ondemand cpufreq_conservative
> freq_table iptable_filter ip_tables x_tables ext3 jbd mbcache hdaps inp
> ut_polldev uinput loop joydev arc4 ecb snd_hda_intel snd_pcsp pcmcia iwl4965
> snd_pcm_oss snd_mixer_oss snd_seq_oss psmouse iwlcore snd_pcm rfki
> ll snd_seq_midi serio_raw iTCO_wdt iTCO_vendor_support yenta_socket
> rsrc_nonstatic mac80211 ac video snd_rawmidi pcmcia_core battery cfg80211 b
> ay output nvidia(P) snd_seq_midi_event snd_seq agpgart i2c_core snd_timer
> snd_seq_device snd soundcore button snd_page_alloc e1000e shpchp pci_
> hotplug thinkpad_acpi led_class nvram evdev reiserfs sha256_generic aes_i586
> aes_generic cbc sr_mod cdrom piix ide_pci_generic ide_core sg sd_m
> od ata_piix ata_generic ohci1394 ieee1394 pata_acpi ahci libata scsi_mod
> dock ehci_hcd uhci_hcd usbcore dm_crypt crypto_blkcipher dm_mirror dm_log
> dm_snapshot dm_mod ther
> May 27 01:51:48 thinkpad kernel: al processor fan fbcon tileblit font
> bitblit softcursor fuse
> May 27 01:51:48 thinkpad kernel: [  208.542393]
> May 27 01:51:48 thinkpad kernel: [  208.542393] Pid: 4534, comm: iwl4965
> Tainted: P          (2.6.25-1-generic #1)
> May 27 01:51:48 thinkpad kernel: [  208.542393] EIP: 0060:[<f8c2740c>]
> EFLAGS: 00010246 CPU: 0
> May 27 01:51:48 thinkpad kernel: [  208.542393] EIP is at
> ieee80211_associate+0x24c/0x640 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393] EAX: 00000000 EBX: f5c3c810
> ECX: 00000000 EDX: f5c3c82c
> May 27 01:51:48 thinkpad kernel: [  208.542393] ESI: f7e42e84 EDI: f5c3c82e
> EBP: 00000421 ESP: f7923d4c
> May 27 01:51:48 thinkpad kernel: [  208.542393]  DS: 007b ES: 007b FS: 00d8
> GS: 0000 SS: 0068
> May 27 01:51:48 thinkpad kernel: [  208.542393] Process iwl4965 (pid: 4534,
> ti=f7922000 task=f7a51360 task.ti=f7922000)
> May 27 01:51:48 thinkpad kernel: [  208.542393] Stack: f7e42e84 00000000
> f7923d88 f7e42e38 f7e42800 f5c01240 33323435 205d3339
> May 27 01:51:48 thinkpad kernel: [  208.542393]        00000000 f7923ed7
> f5c3c82c f7c294c4 00000000 00000000 f7e42d00 313a3030
> May 27 01:51:48 thinkpad kernel: [  208.542393]        30313a33 3a61343a
> 383a3663 f8c20038 f5e3c044 00000002 00000000 f7e42d00
> May 27 01:51:48 thinkpad kernel: [  208.542393] Call Trace:
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<f8c20038>]
> ieee80211_ioctl_siwauth+0x18/0x80 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<f8c286c3>]
> ieee80211_sta_rx_queued_mgmt+0xd13/0x10f0 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<f8c3042d>]
> __ieee80211_tx+0x7d/0x170 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393]
>  [dev_hard_start_xmit+0x21d/0x2b0] dev_hard_start_xmit+0x21d/0x2b0
> May 27 01:51:48 thinkpad kernel: [  208.542393]
>  [iwl4965:_spin_lock_bh+0x8/0x60] _spin_lock_bh+0x8/0x20
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<f8c236ea>]
> ieee80211_rx_bss_get+0xaa/0xc0 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<f8c29810>]
> ieee80211_sta_work+0x80/0x740 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [update_curr+0x41/0x70]
> update_curr+0x41/0x70
> May 27 01:51:48 thinkpad kernel: [  208.542393]
>  [__dequeue_entity+0x50/0xc0] __dequeue_entity+0x50/0xc0
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [hrtick_set+0x69/0x130]
> hrtick_set+0x69/0x130
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [jbd:schedule+0x26b/0x6c0]
> schedule+0x26b/0x670
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<f8c29790>]
> ieee80211_sta_work+0x0/0x740 [mac80211]
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [run_workqueue+0xb8/0x150]
> run_workqueue+0xb8/0x150
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [worker_thread+0x0/0xe0]
> worker_thread+0x0/0xe0
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [worker_thread+0x80/0xe0]
> worker_thread+0x80/0xe0
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [<c013a760>]
> autoremove_wake_function+0x0/0x40
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [worker_thread+0x0/0xe0]
> worker_thread+0x0/0xe0
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [kthread+0x42/0x70]
> kthread+0x42/0x70
> May 27 01:51:48 thinkpad kernel: [  208.542393]  [kthread+0x0/0x70]
> kthread+0x0/0x70
> May 27 01:51:48 thinkpad kernel: [  208.542393]
>  [kernel_thread_helper+0x7/0x10] kernel_thread_helper+0x7/0x10
> May 27 01:51:48 thinkpad kernel: [  208.542393]  =======================
> May 27 01:51:48 thinkpad kernel: [  208.542393] Code: 00 8b 7c 24 0c 8b 54
> 24 28 8b 47 70 88 42 01 8b 47 70 89 d7 83 c7 02 89 c1 c1 e9 02 f3 a5 89 c1
> 83 e1 03 74 02 f3 a4 8b 4c 24 30 <8b> 89 90 00 00 00 85 c9 89 4c 24 38 0f 84
> 92 03 00 00 8b 7c 24
> May 27 01:51:48 thinkpad kernel: [  208.542393] EIP: [<f8c2740c>]
> ieee80211_associate+0x24c/0x640 [mac80211] SS:ESP 0068:f7923d4c
> May 27 01:51:48 thinkpad kernel: [  208.542403] ---[ end trace
> f77f607b02413c6c ]---
>

This one shell fix it up.
http://marc.info/?l=linux-wireless&m=121120929012836&w=2

Tomas
