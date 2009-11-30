Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59545 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZK3Pzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 10:55:51 -0500
Received: by fxm5 with SMTP id 5so3837022fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 07:55:56 -0800 (PST)
Subject: Re: Panic in iwl3945 driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259280022.3991.12.camel@maxim-laptop>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 17:55:51 +0200
Message-ID: <1259596551.4090.0.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-27 at 02:00 +0200, Maxim Levitsky wrote: 
> On Wed, 2009-11-25 at 18:49 +0200, Maxim Levitsky wrote: 
> > Just captured a panic in iwl3945 driver.
> > Will investigate.
> > 
> > <1>[ 7290.414172] IP: [<ffffffffa0dd53a1>] iwl3945_rx_reply_tx+0xc1/0x450 [iwl3945]
> > <4>[ 7290.414205] PGD 0 
> > <1>[ 7290.414214] Thread overran stack, or stack corrupted
> > <0>[ 7290.414229] Oops: 0002 [#1] PREEMPT SMP 
> > <0>[ 7290.414246] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
> > <4>[ 7290.414265] CPU 0 
> > <4>[ 7290.414274] Modules linked in: af_packet nfsd usb_storage usb_libusual cpufreq_powersave exportfs cpufreq_conservative iwl3945 nfs cpufreq_userspace snd_hda_codec_realtek acpi_cpufreq uvcvideo lockd iwlcore snd_hda_intel joydev coretemp nfs_acl videodev snd_hda_codec mac80211 v4l1_compat snd_hwdep sbp2 v4l2_compat_ioctl32 uhci_hcd psmouse auth_rpcgss ohci1394 cfg80211 ehci_hcd video ieee1394 snd_pcm serio_raw battery ac nvidia(P) usbcore output sunrpc evdev lirc_ene0100 snd_page_alloc rfkill tg3 libphy fuse lzo lzo_decompress lzo_compress
> > <6>[ 7290.414486] Pid: 0, comm: swapper Tainted: P           2.6.32-rc8-wl #213 Aspire 5720     
> > <6>[ 7290.414507] RIP: 0010:[<ffffffffa0dd53a1>]  [<ffffffffa0dd53a1>] iwl3945_rx_reply_tx+0xc1/0x450 [iwl3945]
> > <6>[ 7290.414541] RSP: 0018:ffff880002203d60  EFLAGS: 00010246
> > <6>[ 7290.414557] RAX: 000000000000004f RBX: ffff880064c11600 RCX: 0000000000000013
> > <6>[ 7290.414576] RDX: ffffffffa0ddcf20 RSI: ffff8800512b7008 RDI: 0000000000000038
> > <6>[ 7290.414596] RBP: ffff880002203dd0 R08: 0000000000000000 R09: 0000000000000100
> > <6>[ 7290.414616] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000000000a0
> > <6>[ 7290.414635] R13: 0000000000000002 R14: 0000000000000013 R15: 0000000000020201
> > <6>[ 7290.414655] FS:  0000000000000000(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
> > <6>[ 7290.414677] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > <6>[ 7290.414693] CR2: 0000000000000041 CR3: 0000000001001000 CR4: 00000000000006f0
> > <6>[ 7290.414712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > <6>[ 7290.414732] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > <4>[ 7290.414752] Process swapper (pid: 0, threadinfo ffffffff81524000, task ffffffff81528b60)
> > <0>[ 7290.414772] Stack:
> > <4>[ 7290.414780]  ffff880002203da0 0000000000000046 0000000000000000 0000000000000046
> > <4>[ 7290.414804] <0> 0000000000000282 0000000000000282 0000000000000282 ffff880064c12010
> > <4>[ 7290.414830] <0> ffff880002203db0 ffff880064c11600 ffff880064c12e50 ffff8800512b7000
> > <0>[ 7290.414858] Call Trace:
> > <0>[ 7290.414867]  <IRQ> 
> > <4>[ 7290.414884]  [<ffffffffa0dc8c47>] iwl3945_irq_tasklet+0x657/0x1740 [iwl3945]
> > <4>[ 7290.414910]  [<ffffffff8138fc60>] ? _spin_unlock+0x30/0x60
> > <4>[ 7290.414931]  [<ffffffff81049a21>] tasklet_action+0x101/0x110
> > <4>[ 7290.414950]  [<ffffffff8104a3d0>] __do_softirq+0xc0/0x160
> > <4>[ 7290.414968]  [<ffffffff8100d01c>] call_softirq+0x1c/0x30
> > <4>[ 7290.414986]  [<ffffffff8100eff5>] do_softirq+0x75/0xb0
> > <4>[ 7290.415003]  [<ffffffff81049ee5>] irq_exit+0x95/0xa0
> > <4>[ 7290.415020]  [<ffffffff8100e547>] do_IRQ+0x77/0xf0
> > <4>[ 7290.415038]  [<ffffffff8100c7d3>] ret_from_intr+0x0/0xf
> > <0>[ 7290.415052]  <EOI> 
> > <4>[ 7290.415067]  [<ffffffff81234efa>] ? acpi_idle_enter_bm+0x270/0x2a5
> > <4>[ 7290.415087]  [<ffffffff81234f04>] ? acpi_idle_enter_bm+0x27a/0x2a5
> > <4>[ 7290.415107]  [<ffffffff81234efa>] ? acpi_idle_enter_bm+0x270/0x2a5
> > <4>[ 7290.415130]  [<ffffffff812c11f3>] ? cpuidle_idle_call+0x93/0xf0
> > <4>[ 7290.415149]  [<ffffffff8100b0d7>] ? cpu_idle+0xa7/0x110
> > <4>[ 7290.415168]  [<ffffffff8137b3d5>] ? rest_init+0x75/0x80
> > <4>[ 7290.415187]  [<ffffffff8158cd0a>] ? start_kernel+0x3a7/0x3b3
> > <4>[ 7290.415206]  [<ffffffff8158c315>] ? x86_64_start_reservations+0x125/0x129
> > <4>[ 7290.415227]  [<ffffffff8158c3fd>] ? x86_64_start_kernel+0xe4/0xeb
> > <0>[ 7290.415243] Code: 00 41 39 ce 0f 8d e8 01 00 00 48 8b 47 40 48 63 d2 48 69 d2 98 00 00 00 4c 8b 04 02 48 c7 c2 20 cf dd a0 49 8d 78 38 49 8d 40 4f <c6> 47 09 00 c6 47 0c 00 c6 47 0f 00 c6 47 12 00 c6 47 15 00 49 
> > <1>[ 7290.415382] RIP  [<ffffffffa0dd53a1>] iwl3945_rx_reply_tx+0xc1/0x450 [iwl3945]
> > <4>[ 7290.415410]  RSP <ffff880002203d60>
> > <0>[ 7290.415421] CR2: 0000000000000041
> > <4>[ 7290.415436] ---[ end trace ec46807277caa515 ]---
> > <0>[ 7290.415450] Kernel panic - not syncing: Fatal exception in interrupt
> > <4>[ 7290.415468] Pid: 0, comm: swapper Tainted: P      D    2.6.32-rc8-wl #213
> > <4>[ 7290.415486] Call Trace:
> > <4>[ 7290.415495]  <IRQ>  [<ffffffff8138c040>] panic+0x7d/0x13a
> > <4>[ 7290.415519]  [<ffffffff8101071a>] oops_end+0xda/0xe0
> > <4>[ 7290.415538]  [<ffffffff8102e1ea>] no_context+0xea/0x250
> > <4>[ 7290.415557]  [<ffffffff81038991>] ? select_task_rq_fair+0x511/0x780
> > <4>[ 7290.415578]  [<ffffffff8102e475>] __bad_area_nosemaphore+0x125/0x1e0
> > <4>[ 7290.415597]  [<ffffffff81038d0c>] ? __enqueue_entity+0x7c/0x80
> > <4>[ 7290.415616]  [<ffffffff81039201>] ? enqueue_task_fair+0x111/0x150
> > <4>[ 7290.415636]  [<ffffffff8102e53e>] bad_area_nosemaphore+0xe/0x10
> > <4>[ 7290.415656]  [<ffffffff8102e8fa>] do_page_fault+0x26a/0x320
> > <4>[ 7290.415674]  [<ffffffff813905df>] page_fault+0x1f/0x30
> > <4>[ 7290.415697]  [<ffffffffa0dd53a1>] ? iwl3945_rx_reply_tx+0xc1/0x450 [iwl3945]
> > <4>[ 7290.415723]  [<ffffffffa0dc8c47>] iwl3945_irq_tasklet+0x657/0x1740 [iwl3945]
> > <4>[ 7290.415746]  [<ffffffff8138fc60>] ? _spin_unlock+0x30/0x60
> > <4>[ 7290.415764]  [<ffffffff81049a21>] tasklet_action+0x101/0x110
> > <4>[ 7290.415783]  [<ffffffff8104a3d0>] __do_softirq+0xc0/0x160
> > <4>[ 7290.415801]  [<ffffffff8100d01c>] call_softirq+0x1c/0x30
> > <4>[ 7290.415818]  [<ffffffff8100eff5>] do_softirq+0x75/0xb0
> > <4>[ 7290.415835]  [<ffffffff81049ee5>] irq_exit+0x95/0xa0
> > <4>[ 7290.415852]  [<ffffffff8100e547>] do_IRQ+0x77/0xf0
> > <4>[ 7290.415869]  [<ffffffff8100c7d3>] ret_from_intr+0x0/0xf
> > <4>[ 7290.415883]  <EOI>  [<ffffffff81234efa>] ? acpi_idle_enter_bm+0x270/0x2a5
> > <4>[ 7290.415911]  [<ffffffff81234f04>] ? acpi_idle_enter_bm+0x27a/0x2a5
> > <4>[ 7290.415931]  [<ffffffff81234efa>] ? acpi_idle_enter_bm+0x270/0x2a5
> > <4>[ 7290.415952]  [<ffffffff812c11f3>] ? cpuidle_idle_call+0x93/0xf0
> > <4>[ 7290.415971]  [<ffffffff8100b0d7>] ? cpu_idle+0xa7/0x110
> > <4>[ 7290.415989]  [<ffffffff8137b3d5>] ? rest_init+0x75/0x80
> > <4>[ 7290.416007]  [<ffffffff8158cd0a>] ? start_kernel+0x3a7/0x3b3
> > <4>[ 7290.416026]  [<ffffffff8158c315>] ? x86_64_start_reservations+0x125/0x129
> > <4>[ 7290.416047]  [<ffffffff8158c3fd>] ? x86_64_start_kernel+0xe4/0xeb
> 
> 
> This is some very unpleasant problem.
> The thing is that this happens very rarely, and while you use X.
> I had recently few such embarrassing kernel panics (I never had any
> random and rare kernel panics) and I strongly suspect them to be of same
> origin.
> 
> This one is first I captured, due to some code that I wrote recently
> that saves printk buffer in predefined location in system ram that isn't
> cleared on reboot in my notebook.
> 
> I had put some NULL checks in iwl3945_rx_reply_tx, none did trigger yet,
> nor I had another kernel panic.
> 
> Best regards,
> Maxim Levitsky
> 
> 

Happened again:


<7>[39142.650078] No probe response from AP 00:1b:9e:d8:77:02 after 500ms, try 2
<1>[39329.299446] BUG: unable to handle kernel NULL pointer dereference at 0000000000000041
<1>[39329.299478] IP: [<ffffffffa0c7e416>] iwl3945_rx_reply_tx+0x136/0x460 [iwl3945]
<4>[39329.299513] PGD 49be6067 PUD 48f6b067 PMD 0 
<0>[39329.299533] Oops: 0002 [#1] PREEMPT SMP 
<0>[39329.299551] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
<4>[39329.299571] CPU 0 
<4>[39329.299581] Modules linked in: tg3 libphy lirc_ene0100 usbhid af_packet vmnet vmblock vsock vmci vmmon nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative uvcvideo cpufreq_userspace snd_hda_codec_realtek acpi_cpufreq videodev iwl3945 joydev coretemp snd_hda_intel v4l1_compat iwlcore snd_hda_codec v4l2_compat_ioctl32 sbp2 uhci_hcd snd_hwdep psmouse ohci1394 mac80211 video ehci_hcd snd_pcm serio_raw ieee1394 nvidia(P) evdev output usbcore cfg80211 snd_page_alloc ac battery rfkill fuse lzo lzo_decompress lzo_compress [last unloaded: libphy]
<6>[39329.299809] Pid: 323, comm: firefox Tainted: P           2.6.32-rc8-wl #216 Aspire 5720     
<6>[39329.299833] RIP: 0010:[<ffffffffa0c7e416>]  [<ffffffffa0c7e416>] iwl3945_rx_reply_tx+0x136/0x460 [iwl3945]
<6>[39329.299868] RSP: 0000:ffff880002203d60  EFLAGS: 00010246
<6>[39329.299884] RAX: 000000000000004f RBX: ffff880065351600 RCX: 0000000000000057
<6>[39329.299905] RDX: ffffffffa0c85f40 RSI: ffff88002fd90008 RDI: 0000000000000038
<6>[39329.299925] RBP: ffff880002203dd0 R08: 0000000000000000 R09: 0000000000000100
<6>[39329.299946] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000000000a0
<6>[39329.299966] R13: 0000000000000002 R14: 0000000000000057 R15: 0000000000020201
<6>[39329.299987] FS:  00007f89d8872710(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
<6>[39329.300010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<6>[39329.300027] CR2: 0000000000000041 CR3: 0000000047d6f000 CR4: 00000000000006f0
<6>[39329.300048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<6>[39329.300068] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[39329.300090] Process firefox (pid: 323, threadinfo ffff880047ce0000, task ffff88003bc35e20)
<0>[39329.300112] Stack:
<4>[39329.300119]  ffff880002203da0 0000000000000046 0000000000000000 0000000000000046
<4>[39329.300145] <0> 0000000000000282 0000000000000282 0000000000000282 ffff880065352010
<4>[39329.300172] <0> ffff880002203db0 ffff880065351600 ffff880065354110 ffff88002fd90000
<0>[39329.300201] Call Trace:
<0>[39329.300210]  <IRQ> 
<4>[39329.300228]  [<ffffffffa0c71c47>] iwl3945_irq_tasklet+0x657/0x1740 [iwl3945]
<4>[39329.300256]  [<ffffffff8138b880>] ? _spin_unlock+0x30/0x60
<4>[39329.300277]  [<ffffffff81049a21>] tasklet_action+0x101/0x110
<4>[39329.300297]  [<ffffffff8104a3d0>] __do_softirq+0xc0/0x160
<4>[39329.300317]  [<ffffffff8100d01c>] call_softirq+0x1c/0x30
<4>[39329.300336]  [<ffffffff8100eff5>] do_softirq+0x75/0xb0
<4>[39329.300353]  [<ffffffff81049ee5>] irq_exit+0x95/0xa0
<4>[39329.300370]  [<ffffffff8100e547>] do_IRQ+0x77/0xf0
<4>[39329.300389]  [<ffffffff8100c7d3>] ret_from_intr+0x0/0xf
<0>[39329.300405]  <EOI> 
<0>[39329.300413] Code: 00 00 00 00 00 41 39 d6 7c 89 48 8b 47 40 48 63 d2 48 69 d2 98 00 00 00 4c 8b 04 02 48 c7 c2 40 5f c8 a0 49 8d 78 38 49 8d 40 4f <c6> 47 09 00 c6 47 0c 00 c6 47 0f 00 c6 47 12 00 c6 47 15 00 49 
<1>[39329.300556] RIP  [<ffffffffa0c7e416>] iwl3945_rx_reply_tx+0x136/0x460 [iwl3945]
<4>[39329.300585]  RSP <ffff880002203d60>
<0>[39329.300597] CR2: 0000000000000041
<4>[39329.300643] ---[ end trace 7b44b083a7088d66 ]---
<0>[39329.300658] Kernel panic - not syncing: Fatal exception in interrupt
<4>[39329.300678] Pid: 323, comm: firefox Tainted: P      D    2.6.32-rc8-wl #216
<4>[39329.300697] Call Trace:
<4>[39329.300706]  <IRQ>  [<ffffffff81387c60>] panic+0x7d/0x13a
<4>[39329.300732]  [<ffffffff8101071a>] oops_end+0xda/0xe0
<4>[39329.300753]  [<ffffffff8102e1ea>] no_context+0xea/0x250
<4>[39329.300773]  [<ffffffff8102e475>] __bad_area_nosemaphore+0x125/0x1e0
<4>[39329.300795]  [<ffffffff8102e53e>] bad_area_nosemaphore+0xe/0x10
<4>[39329.300815]  [<ffffffff8102e8fa>] do_page_fault+0x26a/0x320
<4>[39329.300835]  [<ffffffff8138c1ff>] page_fault+0x1f/0x30
<4>[39329.300860]  [<ffffffffa0c7e416>] ? iwl3945_rx_reply_tx+0x136/0x460 [iwl3945]
<4>[39329.300888]  [<ffffffffa0c71c47>] iwl3945_irq_tasklet+0x657/0x1740 [iwl3945]
<4>[39329.300912]  [<ffffffff8138b880>] ? _spin_unlock+0x30/0x60
<4>[39329.300931]  [<ffffffff81049a21>] tasklet_action+0x101/0x110
<4>[39329.300950]  [<ffffffff8104a3d0>] __do_softirq+0xc0/0x160
<4>[39329.300969]  [<ffffffff8100d01c>] call_softirq+0x1c/0x30
<4>[39329.300987]  [<ffffffff8100eff5>] do_softirq+0x75/0xb0
<4>[39329.301005]  [<ffffffff81049ee5>] irq_exit+0x95/0xa0
<4>[39329.301022]  [<ffffffff8100e547>] do_IRQ+0x77/0xf0
<4>[39329.301040]  [<ffffffff8100c7d3>] ret_from_intr+0x0/0xf
<4>[39329.301055]  <EOI> 
<0>[39329.301089] Rebooting in 60 seconds..maxim@maxim-laptop:~$ 


