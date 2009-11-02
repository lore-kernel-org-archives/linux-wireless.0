Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63369 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZKBJQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 04:16:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 01:16:17 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19182.41944.492519.390013@gargle.gargle.HOWL>
Date: Mon, 2 Nov 2009 14:48:16 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	<reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix IBSS merge
In-Reply-To: <1257151486.3555.161.camel@johannes.local>
References: <19182.33851.980271.360757@gargle.gargle.HOWL>
	<1257151486.3555.161.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-11-02 at 12:33 +0530, Sujith wrote:
> > Currently, in IBSS mode, a single creator would go into
> > a loop trying to merge/scan. This happens because the IBSS timer is
> > rearmed on finishing a scan and the subsequent
> > timer invocation requests another scan immediately.
> > 
> > This patch fixes this issue by checking if we have just completed
> > a scan run trying to merge with other IBSS networks.
> 
> Heh, how many people do we need to fix IBSS? :)
> 
> Looks sane to me.

Thanks.

And I encountered an oops when using iwlwifi (current wireless-testing).
Set the interface mode to Ad-hoc, bring up the interface and issue a join
command using iw - this causes the panic.

Trace:

[16265.474794] BUG: unable to handle kernel NULL pointer dereference at (null)
[16265.477752] IP: [<ffffffffa03faa96>] iwl_mac_hw_scan+0xf6/0x650 [iwlcore]
[16265.477752] PGD 0
[16265.477752] Oops: 0000 [#1] PREEMPT SMP
[16265.477752] last sysfs file: /sys/class/firmware/0000:05:00.0/loading
[16265.477752] CPU 1
[16265.477752] Modules linked in: iwlagn iwlcore mac80211 cfg80211 arc4 ecb i915 drm_kms_helper drm i2c_algo_bit pcmcia thinkpad_acpi rfkill led_class parport_]
[16265.477752] Pid: 3864, comm: phy0 Tainted: G        W  2.6.32-rc5-wl #60 7661GN4
[16265.477752] RIP: 0010:[<ffffffffa03faa96>]  [<ffffffffa03faa96>] iwl_mac_hw_scan+0xf6/0x650 [iwlcore]
[16265.477752] RSP: 0018:ffff880077f8bc20  EFLAGS: 00010002
[16265.477752] RAX: 0000000000000001 RBX: ffff880077e61660 RCX: 0000000000000000
[16265.477752] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000000013e4
[16265.477752] RBP: ffff880077f8bc60 R08: 0000000000000001 R09: ffffffff8142f0df
[16265.477752] R10: ffff88007b836090 R11: 0000000000000046 R12: ffff88007b8f3000
[16265.477752] R13: ffff880077e62098 R14: ffff880077e62008 R15: 0000000000000286
[16265.477752] FS:  0000000000000000(0000) GS:ffff880002100000(0000) knlGS:0000000000000000
[16265.477752] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[16265.477752] CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
[16265.477752] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16265.477752] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[16265.477752] Process phy0 (pid: 3864, threadinfo ffff880077f8a000, task ffff88007b835a00)
[16265.477752] Stack:
[16265.477752]  ffff880077f8bc50 ffffffff81046497 ffff880077e60520 ffff880077e60520
[16265.477752] <0> ffff880077e61250 ffff88007b8f3000 ffff880077e60520 0000000000000009
[16265.477752] <0> ffff880077f8bcb0 ffffffffa0380506 2222222222222222 2222222222222222
[16265.477752] Call Trace:
[16265.477752]  [<ffffffff81046497>] ? warn_slowpath_common+0x87/0xb0
[16265.477752]  [<ffffffffa0380506>] __ieee80211_start_scan+0xe6/0x3e0 [mac80211]
[16265.477752]  [<ffffffffa03808be>] ieee80211_request_internal_scan+0xbe/0xc0 [mac80211]
[16265.477752]  [<ffffffffa0385138>] ieee80211_ibss_work+0x708/0x800 [mac80211]
[16265.477752]  [<ffffffffa0384a30>] ? ieee80211_ibss_work+0x0/0x800 [mac80211]
[16265.477752]  [<ffffffff8105ef2e>] worker_thread+0x22e/0x420
[16265.477752]  [<ffffffff8105eedd>] ? worker_thread+0x1dd/0x420
[16265.477752]  [<ffffffff8132a3fd>] ? thread_return+0x585/0x8b8
[16265.477752]  [<ffffffff81063fb0>] ? autoremove_wake_function+0x0/0x40
[16265.477752]  [<ffffffff8105ed00>] ? worker_thread+0x0/0x420
[16265.477752]  [<ffffffff81063b9e>] kthread+0x8e/0xa0
[16265.477752]  [<ffffffff8100cf3a>] child_rip+0xa/0x20
[16265.477752]  [<ffffffff8100c8c0>] ? restore_args+0x0/0x30
[16265.477752]  [<ffffffff81063b10>] ? kthread+0x0/0xa0
[16265.477752]  [<ffffffff8100cf30>] ? child_rip+0x0/0x20
[16265.477752] Code: 09 00 00 00 00 00 00 41 8b 54 24 0c 85 d2 74 30 31 d2 31 c0 be 01 00 00 00 0f 1f 40 00 48 63 c8 49 89 f0 83 c0 01 49 8b 4c cc 38 <8b> 09 4
[16265.477752] RIP  [<ffffffffa03faa96>] iwl_mac_hw_scan+0xf6/0x650 [iwlcore]
[16265.477752]  RSP <ffff880077f8bc20>
[16265.477752] CR2: 0000000000000000
[16265.477752] ---[ end trace 1787d9867e43487e ]---
