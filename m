Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:36014 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZBWAQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 19:16:41 -0500
Received: by gxk22 with SMTP id 22so4601989gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2009 16:16:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235159397.5860.81.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <1ba2fa240901280352o56ccbc07h50c7a4bfcd0ac9ab@mail.gmail.com>
	 <20090128121237.GB3197@sortiz.org>
	 <c4d76b3b0902192017n5ae6b23dg36e7aca54cbd703f@mail.gmail.com>
	 <1235159397.5860.81.camel@rc-desk>
Date: Sun, 22 Feb 2009 19:10:35 -0500
Message-ID: <c4d76b3b0902221610rc85a87j4b0eb0b902689dd9@mail.gmail.com> (sfid-20090223_011645_950885_B491115F)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 2:49 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Running with full debugging on all the time will not be practical - but
> there is a debug flag that will only be used when encountering a
> firmware error. This flag will cause a dump of event information that
> will help with debugging. Would it be possible to run your driver with
> debug=0x40000 all the time?

Unfortunately, debug=0x40000 results in an NULL pointer dereference in
iwl_dump_nic_error_log.  iwl_dump_nic_error_log+0x3a =>
iwl-core.c:1668.  Logs below.

Jason

[   31.033837] iwl3945 0000:03:00.0: Microcode SW error detected.
Restarting 0x82000008.
[   31.033887] BUG: unable to handle kernel NULL pointer dereference at (null)
[   31.033901] IP: [<(null)>] (null)
[   31.033912] PGD 0
[   31.033923] Oops: 0010 [#1] SMP
[   31.033992] last sysfs file:
/sys/devices/virtual/backlight/acpi_video0/brightness
[   31.033999] CPU 0
[   31.034008] Modules linked in: af_packet i915 drm i2c_algo_bit
i2c_core binfmt_misc ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_stats
cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table
pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss arc4 ecb snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq iwl3945 iwlcore snd_timer
thinkpad_acpi joydev snd_seq_device mac80211 pcmcia rfkill lib80211
led_class cfg80211 snd soundcore snd_page_alloc evdev pcspkr battery
iTCO_wdt iTCO_vendor_support yenta_socket rsrc_nonstatic psmouse nvram
serio_raw wmi video output ac pcmcia_core intel_agp shpchp pci_hotplug
button ext3 jbd mbcache sr_mod cdrom ata_piix sd_mod crc_t10dif sg
ata_generic ohci1394 ahci pata_acpi ieee1394 libata scsi_mod ehci_hcd
uhci_hcd usbcore thermal processor fan fuse
[   31.034351] Pid: 0, comm: swapper Not tainted 2.6.29-rc5-wl #49 7658CTO
[   31.034358] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
[   31.034368] RSP: 0018:ffffffff80797d28  EFLAGS: 00010097
[   31.034374] RAX: ffffffffa03366e0 RBX: ffff88013b3dd000 RCX: 000000000000001b
[   31.034380] RDX: ffff8800a789c000 RSI: 0000000000000046 RDI: 0000000000800994
[   31.034387] RBP: ffffffff80797d90 R08: 0000000002000000 R09: 00000000ffffffff
[   31.034393] R10: ffff88013b198180 R11: 0000000000000000 R12: ffff8801349a13a0
[   31.034399] R13: ffff8801349a13a0 R14: 0000000000800994 R15: ffffffff8078d220
[   31.034409] FS:  0000000000000000(0000) GS:ffffffff807a0040(0000)
knlGS:0000000000000000
[   31.034416] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   31.034422] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   31.034429] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   31.034435] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   31.034442] Process swapper (pid: 0, threadinfo ffffffff80714000,
task ffffffff8065c360)
[   31.034448] Stack:
[   31.034453]  ffffffffa02e052a ffffffff80791ac0 ffffffffa032f77c
ffff88013b3dd150
[   31.034468]  0000000082000008 000000000203a74d 0000000000000001
ffffffff8065c360
[   31.034490]  ffff88013b3dd000 0000000000000000 ffff8801349a13a0
ffff8801349b0758
[   31.034513] Call Trace:
[   31.034519]  <IRQ> <0> [<ffffffffa02e052a>] ?
iwl_dump_nic_error_log+0x3a/0x460 [iwlcore]
[   31.034564]  [<ffffffffa02e1ba5>] iwl_irq_handle_error+0xc5/0x630 [iwlcore]
[   31.034594]  [<ffffffff80260a89>] ? ktime_get_ts+0x59/0x60
[   31.034614]  [<ffffffffa031a9c4>] iwl3945_irq_tasklet+0xf94/0x1500 [iwl3945]
[   31.034639]  [<ffffffff802db4bf>] ? __slab_free+0x18f/0x350
[   31.034652]  [<ffffffff80260843>] ? hrtimer_get_next_event+0xd3/0xe0
[   31.034664]  [<ffffffff80265c29>] ? getnstimeofday+0x59/0xe0
[   31.034676]  [<ffffffff8024ba39>] tasklet_action+0x69/0xf0
[   31.034688]  [<ffffffff8024c304>] __do_softirq+0x94/0x160
[   31.034703]  [<ffffffff8020d7fc>] call_softirq+0x1c/0x30
[   31.034714]  [<ffffffff8020eb35>] do_softirq+0x45/0x90
[   31.034727]  [<ffffffff8024c065>] irq_exit+0x75/0xa0
[   31.034737]  [<ffffffff8020edb6>] do_IRQ+0x86/0x110
[   31.034747]  [<ffffffff8020d0d3>] ret_from_intr+0x0/0xa
[   31.034758]  <EOI> <0> [<ffffffffa001d564>] ?
acpi_idle_enter_bm+0x26a/0x2b1 [processor]
[   31.034788]  [<ffffffffa001d55a>] ? acpi_idle_enter_bm+0x260/0x2b1
[processor]
[   31.034809]  [<ffffffff8050ddff>] ? notifier_call_chain+0x3f/0x80
[   31.034822]  [<ffffffff80453b95>] ? cpuidle_idle_call+0xa5/0x100
[   31.034835]  [<ffffffff8020af42>] ? cpu_idle+0x62/0xc0
[   31.034848]  [<ffffffff804f6a91>] ? rest_init+0x61/0x70
[   31.034861] Code:  Bad RIP value.
[   31.034877] RIP  [<(null)>] (null)
[   31.034885]  RSP <ffffffff80797d28>
[   31.034890] CR2: 0000000000000000
[   31.034898] ---[ end trace e44c505d0aa011bb ]---
[   31.034907] Kernel panic - not syncing: Fatal exception in interrupt
[   31.034918] ------------[ cut here ]------------
