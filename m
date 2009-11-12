Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59365 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbZKLW06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:26:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 14:27:04 -0800
Date: Thu, 12 Nov 2009 14:27:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Aeolus Yang <Aeolus.Yang@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [ath9k-devel] Oops on ath_txq_schedule() hit a BUG_ON()
Message-ID: <20091112222700.GB17000@tux>
References: <43e72e890911101606j46e1edfn64e331f3463d4da5@mail.gmail.com> <19194.14583.795686.199320@gargle.gargle.HOWL> <20091111204420.GA18071@bombadil.infradead.org> <20091111224542.GA9584@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091111224542.GA9584@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 02:45:42PM -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 11, 2009 at 03:44:20PM -0500, Luis R. Rodriguez wrote:
> > On Wed, Nov 11, 2009 at 09:39:27AM +0530, Sujith wrote:
> > > Luis R. Rodriguez wrote:
> > > > I managed to get an oops the 2.6.32-rc wireless bits on ath9k by using
> > > > linux-backports-modules package on Ubuntu 9.10 which is on 2.6.31. I'm
> > > > pretty sure this is a real oops which can be reproduced on 2.6.32-rc6
> > > > but I was unable to boot the same laptop on 2.6.32-rc6 [1] due to an
> > > > early oops on what seems to be i915.
> > > >
> > > > The EIP is at ath_txq_schedule() but the oops happens due to a
> > > > BUG_ON() (used to be ASSERT()) on this piece of code:
> > >
> > > I have seen this once, and I have a backtrace.
> >
> > I got a full trace now, on Linus' tip.
> >
> > Please excuse the double prints, I haven't figured out how to
> > cure that with netconsole yet [1]
> >
> > [1] http://www.spinics.net/lists/netdev/msg111823.html
> 
> 
> Even better, now I got a full log even from when I connect
> to the AP with full debug enabled (0xffffff). This amounted
> to getting 222 MB of of data, compressed with bzip -9 it
> came to only 18 MB, I've pasted the last 1k lines below but
> if you want the full log you can grab it here:
> 
> http://bombadil.infradead.org/~mcgrof/logs/2.6.32-rc6/ath9k-ar9285-2.6.32-rc6-2009-11-11.txt.bz2
> 
> Note that both outputs still have the dummy double prints due to some
> sort of issue I'm having with netconsoel (or the switch or something..)

And I now have a wireless-testing trace, unfortunately with debug enabled
I was unable to reproduce for a few minutes -- someone else had to borrow
the same device so didn't get a chance to leave it running for a long
period of time.

Again this is with wireless-testing on master-2009-11-11 (same double
netconsole print stuff present):

[   28.462254] console [netcon0] enabled
[   28.462273] netconsole: network logging started
[   28.462254] console [netcon0] enabled
[   28.462273] netconsole: network logging started
[   32.989747] CPU0 attaching NULL sched-domain.
[   32.989779] CPU1 attaching NULL sched-domain.
[   32.989747] CPU0 attaching NULL sched-domain.
[   32.989779] CPU1 attaching NULL sched-domain.
[   33.001377] CPU0 attaching sched-domain:
[   33.001395]  domain 0: span 0-1 level SIBLING
[   33.001406]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   33.001457]   domain 1: span 0-1 level MC
[   33.001471]    groups: 0-1 (cpu_power = 1178)
[   33.001501] CPU1 attaching sched-domain:
[   33.001514]  domain 0: span 0-1 level SIBLING
[   33.001538]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   33.001566]   domain 1: span 0-1 level MC
[   33.001587]    groups: 0-1 (cpu_power = 1178)
[   33.001377] CPU0 attaching sched-domain:
[   33.001395]  domain 0: span 0-1 level SIBLING
[   33.001406]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   33.001457]   domain 1: span 0-1 level MC
[   33.001471]    groups: 0-1 (cpu_power = 1178)
[   33.001501] CPU1 attaching sched-domain:
[   33.001514]  domain 0: span 0-1 level SIBLING
[   33.001538]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   33.001566]   domain 1: span 0-1 level MC
[   33.001587]    groups: (cpu_power = 1178)
[   44.978768] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 1)
[   44.978871] wlan0: deauthenticating from 00:22:6b:56:fd:e8 by local choice (reason=3)
[   44.978768] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 1)
[   44.978871] wlan0: deauthenticating from 00:22:6b:56:fd:e8 by local choice (reason=3)
[   45.013049] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 1)
[   45.013049] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 1)
[   45.213089] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 2)
[   45.213089] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 2)
[   45.220195] wlan0: direct probe responded
[   45.220217] wlan0: authenticate with AP 00:22:6b:56:fd:e8 (try 1)
[   45.220195] wlan0: direct probe responded
[   45.220217] wlan0: authenticate with AP 00:22:6b:56:fd:e8 (try 1)
[   45.226064] wlan0: authenticated
[   45.226127] wlan0: associate with AP 00:22:6b:56:fd:e8 (try 1)
[   45.226064] wlan0: authenticated
[   45.226127] wlan0: associate with AP 00:22:6b:56:fd:e8 (try 1)
[   45.237985] wlan0: RX AssocResp from 00:22:6b:56:fd:e8 (capab=0x401 status=0 aid=1)
[   45.238005] wlan0: associated
[   45.237985] wlan0: RX AssocResp from 00:22:6b:56:fd:e8 (capab=0x401 status=0 aid=1)
[   45.238005] wlan0: associated
[   45.247118] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   45.247118] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   55.724138] wlan0: no IPv6 routers present
[   55.724138] wlan0: no IPv6 routers present
[  266.644232] CE: hpet increasing min_delta_ns to 15000 nsec
[  266.644232] CE: hpet increasing min_delta_ns to 15000 nsec
[  281.250512] ------------[ cut here ]------------
[  281.250512] ------------[ cut here ]------------
[  281.254404] kernel BUG at drivers/net/wireless/ath/ath9k/xmit.c:181!
[  281.254404] invalid opcode: 0000 [#1] SMP [  281.254404] kernel BUG at drivers/net/wireless/ath/ath9k/xmit.c:181!
[  281.254404] invalid opcode: 0000 [#1] SMP 

[  281.254404] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/PNP0C0A:00/power_supply/BAT1/energy_full
[  281.254404] Modules linked in: netconsole binfmt_misc ppdev[  281.254404] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/PNP0C0A:00/power_supply/BAT1/energy_full
 snd_hda_codec_realtek[  281.254404] Modules linked in: snd_hda_intel netconsole snd_hda_codec snd_hwdep binfmt_misc snd_pcm_oss ppdev snd_mixer_oss snd_pcm snd_hda_codec_realtek snd_seq_dummy snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event bridge snd_seq_oss arc4 snd_seq snd_seq_midi ath9k snd_timer snd_rawmidi ath9k_common stp snd_seq_midi_event iptable_filter bridge snd_seq_device mac80211 arc4 bnep ath9k_hw snd_seq joydev ath9k snd_timer ath9k_common stp iptable_filter snd_seq_device mac80211 bnep ath9k_hw joydev ip_tables btusb ath snd dell_laptop lp x_tables ip_tables psmouse cfg80211 btusb soundcore serio_raw ath dcdbas parport snd dell_laptop lp led_class snd_page_alloc x_tables usbhid fbcon psmouse tileblit font cfg80211 bitblit soundcore softcursor serio_raw dcdbas parport led_class snd_page_alloc usbhid fbcon tileblit font bitblit softcursor i915 drm_kms_helper usb_storage drm i2c_algo_bit intel_agp i915 r8169 mii video drm_kms_helper output agpgart usb_storage drm i2c_algo_bit intel_agp r8169 mii video output agpgart

[  281.254404] 
[  281.254404] 
[  281.254404] Pid: 0, comm: swapper Not tainted (2.6.32-rc6-wl #4) Inspiron 1012
[  281.254404] Pid: 0, comm: swapper Not tainted (2.6.32-rc6-wl #4) Inspiron 1012
[  281.254404] EIP: 0060:[<f8839852>] EFLAGS: 00010286 CPU: 1
[  281.254404] EIP: 0060:[<f8839852>] EFLAGS: 00010286 CPU: 1
[  281.254404] EIP is at ath_txq_schedule+0x5f2/0x600 [ath9k]
[  281.254404] EIP is at ath_txq_schedule+0x5f2/0x600 [ath9k]
[  281.254404] EAX: 00000005 EBX: f66b6b70 ECX: 00000049 EDX: 0000004d
[  281.254404] EAX: 00000005 EBX: f66b6b70 ECX: 00000049 EDX: 0000004d
[  281.254404] ESI: f5dfc1e0 EDI: 00000000 EBP: f707ddd4 ESP: f707dd3c
[  281.254404] ESI: f5dfc1e0 EDI: 00000000 EBP: f707ddd4 ESP: f707dd3c
[  281.254404]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  281.254404]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  281.254404] Process swapper (pid: 0, ti=f707c000 task=f705e580 task.ti=f707c000)
[  281.254404] Process swapper (pid: 0, ti=f707c000 task=f705e580 task.ti=f707c000)
[  281.254404] Stack:
[  281.254404]  08000001 00000000 f707ddc0 f7072bbc[  281.254404] Stack:
 f5dfe570 f5dfe568[  281.254404]  08000001 00000000 f5dfe560 00000000 f707ddc0 f7072bbc f5dfe570 f5dfe568 00000000 f5dfe560
[  281.254404] <0> f7072b94 0000001a 00000000 f7072b94
 00000000 000066a8[  281.254404] <0> f5dfc1e8 f7072b94 0000001a f5dfc304 00000000 f7072b94 00000000 000066a8 f5dfc1e8 f5dfc304
[  281.254404] <0> f7072ba4 0100001f 00000000 f66b6b70
 00000010 000066a8[  281.254404] <0> f66b6b70 f7072ba4 000086c0 0100001f 00000000 f66b6b70 00000010 000066a8 f66b6b70 000086c0

[  281.254404] Call Trace:
[  281.254404] Call Trace:
[  281.254404]  [<f8839b57>] ? ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[  281.254404]  [<f8839b57>] ? ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[  281.254404]  [<f8834c37>] ? ath9k_tasklet+0xd7/0x120 [ath9k]
[  281.254404]  [<f8834c37>] ? ath9k_tasklet+0xd7/0x120 [ath9k]
[  281.254404]  [<c014ae52>] ? tasklet_action+0xa2/0xb0
[  281.254404]  [<c014ae52>] ? tasklet_action+0xa2/0xb0
[  281.254404]  [<c014c390>] ? __do_softirq+0x90/0x1a0
[  281.254404]  [<c014c390>] ? __do_softirq+0x90/0x1a0
[  281.254404]  [<c0120786>] ? ack_apic_level+0x66/0x170
[  281.254404]  [<c0120786>] ? ack_apic_level+0x66/0x170
[  281.254404]  [<c01659ae>] ? sched_clock_tick+0x5e/0xa0
[  281.254404]  [<c01659ae>] ? sched_clock_tick+0x5e/0xa0
[  281.254404]  [<c014c4dd>] ? do_softirq+0x3d/0x40
[  281.254404]  [<c014c4dd>] ? do_softirq+0x3d/0x40
[  281.254404]  [<c014c61d>] ? irq_exit+0x5d/0x70
[  281.254404]  [<c014c61d>] ? irq_exit+0x5d/0x70
[  281.254404]  [<c0104b40>] ? do_IRQ+0x50/0xc0
[  281.254404]  [<c0104b40>] ? do_IRQ+0x50/0xc0
[  281.254404]  [<c01656a4>] ? sched_clock_local+0xa4/0x180
[  281.254404]  [<c01656a4>] ? sched_clock_local+0xa4/0x180
[  281.254404]  [<c0103830>] ? common_interrupt+0x30/0x40
[  281.254404]  [<c0103830>] ? common_interrupt+0x30/0x40
[  281.254404]  [<c016007b>] ? remove_wait_queue+0x3b/0x50
[  281.254404]  [<c016007b>] ? remove_wait_queue+0x3b/0x50
[  281.254404]  [<c037559b>] ? acpi_idle_enter_bm+0x255/0x286
[  281.254404]  [<c037559b>] ? acpi_idle_enter_bm+0x255/0x286
[  281.254404]  [<c04755de>] ? cpuidle_idle_call+0x6e/0xf0
[  281.254404]  [<c04755de>] ? cpuidle_idle_call+0x6e/0xf0
[  281.254404]  [<c0101efc>] ? cpu_idle+0x8c/0xd0
[  281.254404]  [<c0101efc>] ? cpu_idle+0x8c/0xd0
[  281.254404]  [<c05613e7>] ? start_secondary+0x19e/0x1a4
[  281.254404] Code: 08 8b 53 2c 89 4b 2c [  281.254404]  [<c05613e7>] ? start_secondary+0x19e/0x1a4
8b 9d 74 [  281.254404] Code: ff ff 08 ff 89 50 8b 0c 53 89 2c 58 08 89 89 0a e9 4b f1 fc ff 2c ff 8d b4 8b 26 00 00 9d 00 00 bf 74 01 00 00 ff 00 e9 26 ff fc ff ff ff <0f> 0b 89 eb fe 8d 76 50 0c 89 58 08 89 0a e9 f1 fc ff ff 8d b4 26 00 00 00 00 bf 01 00 00 00 e9 26 fc ff ff <0f> 0b eb fe 8d 76 00 8d bc 27 00 00 00 00 55 89 00 e5 57 56 8d bc 53 83 27 00 00 00 00 55 89 e5 57 56 53 83 
[  281.254404] EIP: [<f8839852>] 
ath_txq_schedule+0x5f2/0x600 [ath9k][  281.254404] EIP: [<f8839852>] ath_txq_schedule+0x5f2/0x600 [ath9k] SS:ESP 0068:f707dd3c
 SS:ESP 0068:f707dd3c
[  281.527846] ---[ end trace aa92ebe253e5014f ]---
[  281.527846] ---[ end trace aa92ebe253e5014f ]---
[  281.538450] Kernel panic - not syncing: Fatal exception in interrupt
[  281.538450] Kernel panic - not syncing: Fatal exception in interrupt
[  281.545741] Pid: 0, comm: swapper Tainted: G      D    2.6.32-rc6-wl #4
[  281.545741] Pid: 0, comm: swapper Tainted: G      D    2.6.32-rc6-wl #4
[  281.552350] Call Trace:
[  281.552350] Call Trace:
[  281.558819]  [<c0563ebf>] ? printk+0x18/0x21
[  281.558819]  [<c0563ebf>] ? printk+0x18/0x21
[  281.565343]  [<c0563dfc>] panic+0x43/0xee
[  281.565343]  [<c0563dfc>] panic+0x43/0xee
[  281.571847]  [<c0567655>] oops_end+0xc5/0xd0
[  281.571847]  [<c0567655>] oops_end+0xc5/0xd0
[  281.578254]  [<c01064bf>] die+0x4f/0x70
[  281.578254]  [<c01064bf>] die+0x4f/0x70
[  281.584555]  [<c0566d96>] do_trap+0x96/0xc0
[  281.584555]  [<c0566d96>] do_trap+0x96/0xc0
[  281.590801]  [<c01045e0>] ? do_invalid_op+0x0/0xa0
[  281.590801]  [<c01045e0>] ? do_invalid_op+0x0/0xa0
[  281.597056]  [<c0104666>] do_invalid_op+0x86/0xa0
[  281.597056]  [<c0104666>] do_invalid_op+0x86/0xa0
[  281.603377]  [<f8839852>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[  281.603377]  [<f8839852>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[  281.607525]  [<c04926d8>] ? __kfree_skb+0x38/0x90
[  281.607525]  [<c04926d8>] ? __kfree_skb+0x38/0x90
[  281.611773]  [<c04926d8>] ? __kfree_skb+0x38/0x90
[  281.611773]  [<c04926d8>] ? __kfree_skb+0x38/0x90
[  281.615511]  [<c049274c>] ? consume_skb+0x1c/0x40
[  281.615511]  [<c049274c>] ? consume_skb+0x1c/0x40
[  281.621367]  [<f871084f>] ? ieee80211_tx_status+0x41f/0x450 [mac80211]
[  281.621367]  [<f871084f>] ? ieee80211_tx_status+0x41f/0x450 [mac80211]
[  281.627114]  [<c01346fd>] ? __enqueue_entity+0x9d/0xc0
[  281.627114]  [<c01346fd>] ? __enqueue_entity+0x9d/0xc0
[  281.633259]  [<c0126d18>] ? default_spin_lock_flags+0x8/0x10
[  281.633259]  [<c0126d18>] ? default_spin_lock_flags+0x8/0x10
[  281.638919]  [<c056678a>] ? _spin_lock_irqsave+0x2a/0x40
[  281.638919]  [<c056678a>] ? _spin_lock_irqsave+0x2a/0x40
[  281.645014]  [<c0566b13>] error_code+0x73/0x80
[  281.645014]  [<c0566b13>] error_code+0x73/0x80
[  281.650852]  [<f8839852>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[  281.650852]  [<f8839852>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[  281.656532]  [<f8839b57>] ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[  281.656532]  [<f8839b57>] ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[  281.662653]  [<f8834c37>] ath9k_tasklet+0xd7/0x120 [ath9k]
[  281.662653]  [<f8834c37>] ath9k_tasklet+0xd7/0x120 [ath9k]
[  281.668234]  [<c014ae52>] tasklet_action+0xa2/0xb0
[  281.668234]  [<c014ae52>] tasklet_action+0xa2/0xb0
[  281.675076]  [<c014c390>] __do_softirq+0x90/0x1a0
[  281.675076]  [<c014c390>] __do_softirq+0x90/0x1a0
[  281.680479]  [<c0120786>] ? ack_apic_level+0x66/0x170
[  281.680479]  [<c0120786>] ? ack_apic_level+0x66/0x170
[  281.687134]  [<c01659ae>] ? sched_clock_tick+0x5e/0xa0
[  281.687134]  [<c01659ae>] ? sched_clock_tick+0x5e/0xa0
[  281.692496]  [<c014c4dd>] do_softirq+0x3d/0x40
[  281.692496]  [<c014c4dd>] do_softirq+0x3d/0x40
[  281.699037]  [<c014c61d>] irq_exit+0x5d/0x70
[  281.699037]  [<c014c61d>] irq_exit+0x5d/0x70
[  281.704246]  [<c0104b40>] do_IRQ+0x50/0xc0
[  281.704246]  [<c0104b40>] do_IRQ+0x50/0xc0
[  281.710591]  [<c01656a4>] ? sched_clock_local+0xa4/0x180
[  281.710591]  [<c01656a4>] ? sched_clock_local+0xa4/0x180
[  281.715825]  [<c0103830>] common_interrupt+0x30/0x40
[  281.715825]  [<c0103830>] common_interrupt+0x30/0x40
[  281.722438]  [<c016007b>] ? remove_wait_queue+0x3b/0x50
[  281.722438]  [<c016007b>] ? remove_wait_queue+0x3b/0x50
[  281.727719]  [<c037559b>] ? acpi_idle_enter_bm+0x255/0x286
[  281.727719]  [<c037559b>] ? acpi_idle_enter_bm+0x255/0x286
[  281.734422]  [<c04755de>] cpuidle_idle_call+0x6e/0xf0
[  281.734422]  [<c04755de>] cpuidle_idle_call+0x6e/0xf0
[  281.739737]  [<c0101efc>] cpu_idle+0x8c/0xd0
[  281.739737]  [<c0101efc>] cpu_idle+0x8c/0xd0
[  281.746322]  [<c05613e7>] start_secondary+0x19e/0x1a4
[  281.746322]  [<c05613e7>] start_secondary+0x19e/0x1a4
[  281.751710] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
[  281.751710] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
[  281.755668] BUG: scheduling while atomic: swapper/0/0x10000200
[  281.755668] Modules linked in:[  281.755668] BUG: scheduling while atomic: swapper/0/0x10000200
 netconsole[  281.755668] Modules linked in: binfmt_misc ppdev snd_hda_codec_realtek netconsole snd_hda_intel snd_hda_codec binfmt_misc snd_hwdep ppdev snd_pcm_oss snd_mixer_oss snd_hda_codec_realtek snd_pcm snd_hda_intel snd_seq_dummy snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event bridge snd_seq_oss arc4 snd_seq snd_seq_midi ath9k snd_timer snd_rawmidi ath9k_common stp snd_seq_midi_event iptable_filter bridge snd_seq_device mac80211 arc4 bnep ath9k_hw snd_seq joydev ath9k snd_timer ath9k_common stp iptable_filter snd_seq_device mac80211 bnep ath9k_hw joydev ip_tables btusb ath snd dell_laptop lp x_tables ip_tables psmouse cfg80211 btusb soundcore serio_raw ath dcdbas parport snd led_class dell_laptop snd_page_alloc usbhid lp fbcon tileblit x_tables psmouse font bitblit cfg80211 softcursor soundcore serio_raw dcdbas parport led_class snd_page_alloc usbhid fbcon tileblit font bitblit softcursor i915 drm_kms_helper usb_storage drm i2c_algo_bit intel_agp i915 r8169 mii drm_kms_helper video output usb_storage agpgart drm i2c_algo_bit intel_agp r8169 mii video output agpgart

[  281.755668] 
[  281.755668] 
[  281.755668] Pid: 0, comm: swapper Tainted: G      D    (2.6.32-rc6-wl #4) Inspiron 1012
[  281.755668] Pid: 0, comm: swapper Tainted: G      D    (2.6.32-rc6-wl #4) Inspiron 1012
[  281.755668] EIP: 0060:[<c037559b>] EFLAGS: 00000286 CPU: 1
[  281.755668] EIP: 0060:[<c037559b>] EFLAGS: 00000286 CPU: 1
[  281.755668] EIP is at acpi_idle_enter_bm+0x255/0x286
[  281.755668] EIP is at acpi_idle_enter_bm+0x255/0x286
[  281.755668] EAX: c07f5dec EBX: 0000033a ECX: 00000041 EDX: 0220e000
[  281.755668] EAX: c07f5dec EBX: 0000033a ECX: 00000041 EDX: 0220e000
[  281.755668] ESI: 00000000 EDI: f70224c0 EBP: f707df64 ESP: f707df3c
[  281.755668] ESI: 00000000 EDI: f70224c0 EBP: f707df64 ESP: f707df3c
[  281.755668]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  281.755668]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  281.755668] CR0: 8005003b CR2: b760d820 CR3: 00800000 CR4: 000006d0
[  281.755668] CR0: 8005003b CR2: b760d820 CR3: 00800000 CR4: 000006d0
[  281.755668] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  281.755668] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  281.755668] DR6: ffff0ff0 DR7: 00000400
[  281.755668] DR6: ffff0ff0 DR7: 00000400
[  281.755668] Call Trace:
[  281.755668] Call Trace:
[  281.755668]  [<c04755de>] cpuidle_idle_call+0x6e/0xf0
[  281.755668]  [<c04755de>] cpuidle_idle_call+0x6e/0xf0
[  281.755668]  [<c0101efc>] cpu_idle+0x8c/0xd0
[  281.755668]  [<c0101efc>] cpu_idle+0x8c/0xd0
[  281.755668]  [<c05613e7>] start_secondary+0x19e/0x1a4
[  281.755668]  [<c05613e7>] start_secondary+0x19e/0x1a4
[  281.755668] [drm] Big FIFO is enabled
[  281.755668] [drm] Big FIFO is enabled
