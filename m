Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36896 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0IWAWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 20:22:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 17:22:34 -0700
Date: Wed, 22 Sep 2010 17:22:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "jiajia.zheng@intel.com" <jiajia.zheng@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH] wifi-test: add simple roam test script
Message-ID: <20100923002240.GA4484@tux>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 05:17:17PM -0700, Luis R. Rodriguez wrote:
> This adds a simple roam test script. It uses the supplicant
> wpa_cli utility to interact with your existing session.
> You can either use Network Manager and connect to an ESS
> or use wpa_supplicant manually and connect to an ESS, in
> both cases you need to hand pick an ESS by SSID and support
> the control interface of the supplicant. The script will just
> force a roam onto all the APs on the ESS in round robin,
> sleeping 2 seconds between each roam. If you are not testing
> signal drops you can use this to move around APs without
> walking around a building.
> 
> Cc: Paul Stewart <pstew@google.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> The wifi-test.git tree is down right now.. so if you want to test
> this you can download the script from:
> 
> http://bombadil.infradead.org/~mcgrof/test-roam
> 
> for now. This script let me find a bug, I'll post the oops
> shortly.

After roaming for a good while, this is what I got, not sure
yet what caused the NULL pointer dereference... Am I the only
one able to reproduce this?

[ 3276.590182] ieee80211 phy10: device now idle
[ 3276.596354] cfg80211: All devices are disconnected, going to restore regulatory settings
[ 3276.596365] cfg80211: Restoring regulatory settings
[ 3276.596375] cfg80211: Calling CRDA to update world regulatory domain
[ 3276.604100] cfg80211: World regulatory domain updated:
[ 3276.604115]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 3276.604126]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 3276.604135]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 3276.604144]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 3276.604153]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 3276.604161]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 3276.640583] ieee80211 phy10: device no longer idle - working
[ 3276.658666] wlan37: authenticate with 00:01:03:a0:b0:c0 (try 1)
[ 3276.659632] wlan37: authenticated
[ 3276.659670] wlan37: associate with 00:01:03:a0:b0:c0 (try 1)
[ 3276.661981] wlan37: RX AssocResp from 00:01:03:a0:b0:c0 (capab=0x411 status=0 aid=16)
[ 3276.661986] wlan37: associated
[ 3276.661994] ieee80211 phy10: Allocated STA 00:01:03:a0:b0:c0
[ 3276.662050] ieee80211 phy10: Inserted STA 00:01:03:a0:b0:c0
[ 3276.730081] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
[ 3276.730148] IP: [<0000000000000003>] 0x3
[ 3276.730179] PGD 2fee1067 PUD 2fec6067 PMD 0 
[ 3276.730212] Oops: 0010 [#1] SMP 
[ 3276.730239] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[ 3276.730264] CPU 1 
[ 3276.730276] Modules linked in: ath9k netconsole configfs rfcomm sco binfmt_misc ppdev stp bnep l2cap snd_hda_codec_analog joydev nouveau mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi pcmcia snd_seq_midi ath9k_common ttm ath9k_hw snd_rawmidi snd_seq_midi_event snd_seq drm_kms_helper snd_timer drm snd_seq_device ath btusb snd yenta_socket bluetooth tpm_tis pcmcia_rsrc cfg80211 tpm i2c_algo_bit psmouse pcmcia_core nvram tpm_bios soundcore serio_raw snd_page_alloc intel_agp video output lp parport ahci ohci1394 e1000e ieee1394 libahci [last unloaded: netconsole]
[ 3276.730761] 
[ 3276.730775] Pid: 9, comm: ksoftirqd/1 Not tainted 2.6.36-rc5-wl+ #253 6460DWU/6460DWU
[ 3276.730796] RIP: 0010:[<0000000000000003>]  [<0000000000000003>] 0x3
[ 3276.730826] RSP: 0018:ffff880001f03ea0  EFLAGS: 00010246
[ 3276.730844] RAX: ffff880001f03ef8 RBX: ffff88003d688000 RCX: 0000000000000000
[ 3276.730869] RDX: ffff880001f12188 RSI: dead000000200200 RDI: 0000001d00008020
[ 3276.730889] RBP: ffff880001f03f38 R08: ffff88002f731290 R09: 0000000000000000
[ 3276.730909] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002f731250
[ 3276.730930] R13: ffff880001f03ef8 R14: 0000000000000100 R15: ffff88003d68dfd8
[ 3276.730952] FS:  0000000000000000(0000) GS:ffff880001f00000(0000) knlGS:0000000000000000
[ 3276.730974] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3276.730992] CR2: 0000000000000003 CR3: 000000003ccbc000 CR4: 00000000000006e0
[ 3276.731012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3276.731035] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3276.731056] Process ksoftirqd/1 (pid: 9, threadinfo ffff88003d68c000, task ffff88003d67c470)
[ 3276.731078] Stack:
[ 3276.731093]  ffffffff8106f7da ffff88003d699fd8 ffff880001f03ed0 ffff88003d689c20
[ 3276.731128] <0> ffff88003d689820 ffff88003d689420 ffff88003d68dfd8 ffff88003d68dfd8
[ 3276.731175] <0> 0000001d00008020 0000000000000003 ffff88003d689020 ffff880001f12188
[ 3276.731226] Call Trace:
[ 3276.731239]  <IRQ> 
[ 3276.731263]  [<ffffffff8106f7da>] ? run_timer_softirq+0x17a/0x370
[ 3276.731289]  [<ffffffff81066d09>] __do_softirq+0xb9/0x1f0
[ 3276.731310]  [<ffffffff8100bf5c>] ? call_softirq+0x1c/0x30
[ 3276.731336]  [<ffffffff8100bf5c>] call_softirq+0x1c/0x30
[ 3276.731353]  <EOI> 
[ 3276.731370]  [<ffffffff8100da15>] ? do_softirq+0x65/0xa0
[ 3276.731391]  [<ffffffff81066848>] run_ksoftirqd+0x88/0x140
[ 3276.731412]  [<ffffffff810667c0>] ? run_ksoftirqd+0x0/0x140
[ 3276.731434]  [<ffffffff81080976>] kthread+0x96/0xa0
[ 3276.731453]  [<ffffffff8100be64>] kernel_thread_helper+0x4/0x10
[ 3276.731475]  [<ffffffff810808e0>] ? kthread+0x0/0xa0
[ 3276.731499]  [<ffffffff8100be60>] ? kernel_thread_helper+0x0/0x10
[ 3276.731517] Code:  Bad RIP value.
[ 3276.731545] RIP  [<0000000000000003>] 0x3
[ 3276.731569]  RSP <ffff880001f03ea0>
[ 3276.731586] CR2: 0000000000000003
[ 3276.738990] ---[ end trace f56840a1aec08143 ]---
[ 3276.739014] Kernel panic - not syncing: Fatal exception in interrupt
[ 3276.739036] Pid: 9, comm: ksoftirqd/1 Tainted: G      D     2.6.36-rc5-wl+ #253
[ 3276.739058] Call Trace:
[ 3276.739070]  <IRQ>  [<ffffffff8155fd3f>] panic+0x91/0x1a1
[ 3276.739104]  [<ffffffff81060fd5>] ? kmsg_dump+0x145/0x160
[ 3276.739127]  [<ffffffff8156445a>] oops_end+0xea/0xf0
[ 3276.739154]  [<ffffffff8103dbdb>] no_context+0xfb/0x260
[ 3276.739175]  [<ffffffff8108fa37>] ? tick_do_broadcast+0x77/0x90
[ 3276.739199]  [<ffffffff8103de65>] __bad_area_nosemaphore+0x125/0x1e0
[ 3276.739222]  [<ffffffff8103df33>] bad_area_nosemaphore+0x13/0x20
[ 3276.739243]  [<ffffffff81566d8f>] do_page_fault+0x28f/0x350
[ 3276.739266]  [<ffffffff81562dbe>] ? _raw_spin_lock+0xe/0x20
[ 3276.739288]  [<ffffffff81563715>] page_fault+0x25/0x30
[ 3276.739313]  [<ffffffff8106f7da>] ? run_timer_softirq+0x17a/0x370
[ 3276.739336]  [<ffffffff81066d09>] __do_softirq+0xb9/0x1f0
[ 3276.739355]  [<ffffffff8100bf5c>] ? call_softirq+0x1c/0x30
[ 3276.739378]  [<ffffffff8100bf5c>] call_softirq+0x1c/0x30
[ 3276.739395]  <EOI>  [<ffffffff8100da15>] ? do_softirq+0x65/0xa0
[ 3276.740540]  [<ffffffff81066848>] run_ksoftirqd+0x88/0x140
[ 3276.741551]  [<ffffffff810667c0>] ? run_ksoftirqd+0x0/0x140
[ 3276.742551]  [<ffffffff81080976>] kthread+0x96/0xa0
[ 3276.743594]  [<ffffffff8100be64>] kernel_thread_helper+0x4/0x10
[ 3276.744586]  [<ffffffff810808e0>] ? kthread+0x0/0xa0
[ 3276.745578]  [<ffffffff8100be60>] ? kernel_thread_helper+0x0/0x10
[ 3276.746559] panic occurred, switching back to text console
[ 3276.747448] BUG: scheduling while atomic: ksoftirqd/1/9/0x10000100
[ 3276.748321] Modules linked in: ath9k netconsole configfs rfcomm sco binfmt_misc ppdev stp bnep l2cap snd_hda_codec_analog joydev nouveau mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi pcmcia snd_seq_midi ath9k_common ttm ath9k_hw snd_rawmidi snd_seq_midi_event snd_seq drm_kms_helper snd_timer drm snd_seq_device ath btusb snd yenta_socket bluetooth tpm_tis pcmcia_rsrc cfg80211 tpm i2c_algo_bit psmouse pcmcia_core nvram tpm_bios soundcore serio_raw snd_page_alloc intel_agp video output lp parport ahci ohci1394 e1000e ieee1394 libahci [last unloaded: netconsole]
[ 3276.750523] Pid: 9, comm: ksoftirqd/1 Tainted: G      D     2.6.36-rc5-wl+ #253
[ 3276.750523] Call Trace:
[ 3276.750523]  <IRQ>  [<ffffffff8104f686>] __schedule_bug+0x66/0x70
[ 3276.750523]  [<ffffffff815607c4>] schedule+0x6d4/0xa00
[ 3276.750523]  [<ffffffff810588ea>] __cond_resched+0x2a/0x40
[ 3276.750523]  [<ffffffff81560c40>] _cond_resched+0x30/0x40
[ 3276.750523]  [<ffffffff81142709>] __kmalloc+0xd9/0x1c0
[ 3276.750523]  [<ffffffffa0243ca3>] ? T.746+0x13/0x20 [drm_kms_helper]
[ 3276.750523]  [<ffffffffa0243ca3>] T.746+0x13/0x20 [drm_kms_helper]
[ 3276.750523]  [<ffffffffa0243da2>] drm_crtc_helper_set_config+0xf2/0x960 [drm_kms_helper]
[ 3276.750523]  [<ffffffffa02410f9>] drm_fb_helper_force_kernel_mode+0x79/0xb0 [drm_kms_helper]
[ 3276.750523]  [<ffffffffa024118c>] drm_fb_helper_panic+0x1c/0x30 [drm_kms_helper]
[ 3276.750523]  [<ffffffff81566ea6>] notifier_call_chain+0x56/0x80
[ 3276.750523]  [<ffffffff81566f0a>] atomic_notifier_call_chain+0x1a/0x20
[ 3276.750523]  [<ffffffff8155fd6b>] panic+0xbd/0x1a1
[ 3276.750523]  [<ffffffff81060fd5>] ? kmsg_dump+0x145/0x160
[ 3276.750523]  [<ffffffff8156445a>] oops_end+0xea/0xf0
[ 3276.750523]  [<ffffffff8103dbdb>] no_context+0xfb/0x260
[ 3276.750523]  [<ffffffff8108fa37>] ? tick_do_broadcast+0x77/0x90
[ 3276.750523]  [<ffffffff8103de65>] __bad_area_nosemaphore+0x125/0x1e0
[ 3276.750523]  [<ffffffff8103df33>] bad_area_nosemaphore+0x13/0x20
[ 3276.750523]  [<ffffffff81566d8f>] do_page_fault+0x28f/0x350
[ 3276.750523]  [<ffffffff81562dbe>] ? _raw_spin_lock+0xe/0x20
[ 3276.750523]  [<ffffffff81563715>] page_fault+0x25/0x30
[ 3276.750523]  [<ffffffff8106f7da>] ? run_timer_softirq+0x17a/0x370
[ 3276.750523]  [<ffffffff81066d09>] __do_softirq+0xb9/0x1f0
[ 3276.750523]  [<ffffffff8100bf5c>] ? call_softirq+0x1c/0x30
[ 3276.750523]  [<ffffffff8100bf5c>] call_softirq+0x1c/0x30
[ 3276.750523]  <EOI>  [<ffffffff8100da15>] ? do_softirq+0x65/0xa0
[ 3276.750523]  [<ffffffff81066848>] run_ksoftirqd+0x88/0x140
[ 3276.750523]  [<ffffffff810667c0>] ? run_ksoftirqd+0x0/0x140
[ 3276.750523]  [<ffffffff81080976>] kthread+0x96/0xa0
[ 3276.750523]  [<ffffffff8100be64>] kernel_thread_helper+0x4/0x10
[ 3276.750523]  [<ffffffff810808e0>] ? kthread+0x0/0xa0
[ 3276.750523]  [<ffffffff8100be60>] ? kernel_thread_helper+0x0/0x10
