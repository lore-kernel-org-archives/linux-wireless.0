Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0FIX1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 19:27:48 -0400
Subject: Re: [PATCHv4] mac80211: Fix circular locking dependency in ARP
 filter handling
From: reinette chatre <reinette.chatre@intel.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276080206-29562-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1276080206-29562-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 16:27:47 -0700
Message-ID: <1276126067.1835.15473.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juuso,

On Wed, 2010-06-09 at 03:43 -0700, Juuso Oikarinen wrote:
> There is a circular locking dependency when configuring the
> hardware ARP filters on association, occurring when flushing the mac80211
> workqueue.

I am currently running with latest wireless-testing (HEAD
5e3283c821c3a7750b1f7bd982b10ebdbab0e155) with your patch "mac80211: Add
netif state checking to ieee80211_ifa_changed" also applied.

This hunk below does not seem to match with what is currently in
wireless-testing.

> @@ -2116,19 +2129,9 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
>                         cfg80211_send_assoc_timeout(wk->sdata->dev,
>                                                     wk->filter_ta);
>                         return WORK_DONE_DESTROY;
> -#ifdef CONFIG_INET
> -               } else {
> -                       mutex_unlock(&wk->sdata->u.mgd.mtx);
> -
> -                       /*
> -                        * configure ARP filter IP addresses to the driver,
> -                        * intentionally outside the mgd mutex.
> -                        */
> -                       rtnl_lock();
> -                       ieee80211_set_arp_filter(wk->sdata);
> -                       rtnl_unlock();
> -#endif
>                 }
> +
> +               mutex_unlock(&wk->sdata->u.mgd.mtx);
>         }
> 
>         cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
> --

I made some modifications to get the patch to apply to wireless-testing,
not sure what should be done here since the difference seems
significant.

Even so, I tested your new patch and for some reason the BUG returned
(even though I am now running with "mac80211: Add netif state checking
to ieee80211_ifa_changed"

Here is what I get:

[  390.153170] ------------[ cut here ]------------
[  390.156016] kernel BUG at /home/wifi/iwlwifi-2.6/net/mac80211/main.c:437!
[  390.156016] invalid opcode: 0000 [#1] SMP
[  390.156016] last sysfs file: /sys/devices/virtual/misc/rfkill/dev
[  390.156016] CPU 0
[  390.156016] Modules linked in: iwl3945(+) iwlcore mac80211 cfg80211 rfkill binfmt_misc sbs
 sbshc ipv6 evdev psmouse serio_raw pcspkr pegasus mii battery container processor video ac b
utton output intel_agp ext3 jbd mbcache sg sd_mod sr_mod cdrom ahci libahci libata ehci_hcd u
hci_hcd scsi_mod usbcore thermal fan thermal_sys
[  390.156016]
[  390.156016] Pid: 5171, comm: modprobe Not tainted 2.6.35-rc2-wl-64031-g07c6e79 #211 To be
filled by O.E.M./Montevina platform
[  390.156016] RIP: 0010:[<ffffffffa026faf2>]  [<ffffffffa026faf2>] ieee80211_alloc_hw+0x502/
0x520 [mac80211]
[  390.156016] RSP: 0018:ffff880025a9fc78  EFLAGS: 00010246
[  390.156016] RAX: ffff8800241319c0 RBX: ffff8800241302e0 RCX: 0000000000000001
[  390.156016] RDX: ffffffffa02647a0 RSI: ffffffffa02647a8 RDI: ffffffffa0264a34
[  390.156016] RBP: ffff880025a9fc98 R08: 0000000000000008 R09: ffffffff8154a5f8
[  390.156016] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800241305a0
[  390.156016] R13: ffffffffa032dfc0 R14: ffff88003b6b6000 R15: ffff880025fa2180
[  390.156016] FS:  00007f634f2cd6f0(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
[  390.156016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  390.156016] CR2: 00007fffc7cf9040 CR3: 000000002552a000 CR4: 00000000000006f0
[  390.156016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  390.156016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  390.156016] Process modprobe (pid: 5171, threadinfo ffff880025a9e000, task ffff880002442df
0)
[  390.156016] Stack:
[  390.156016]  ffffffffa032e460 ffffffffa032e460 ffff88003b6b6000 ffff88003b6b6000
[  390.156016] <0> ffff880025a9fcb8 ffffffffa02d553e ffffffffa032e460 ffff88003b6b6088
[  390.156016] <0> ffff880025a9fd38 ffffffffa03131a7 0000000000000246 ffffffffa032df48
[  390.156016] Call Trace:
[  390.156016]  [<ffffffffa02d553e>] iwl_alloc_all+0x1e/0x50 [iwlcore]
[  390.156016]  [<ffffffffa03131a7>] iwl3945_pci_probe+0x27/0x1640 [iwl3945]
[  390.156016]  [<ffffffff81348a56>] ? _raw_spin_unlock+0x26/0x30
[  390.156016]  [<ffffffff811d4ca0>] ? pci_match_device+0x20/0xd0
[  390.156016]  [<ffffffff811d4b52>] local_pci_probe+0x12/0x20
[  390.156016]  [<ffffffff811d5c60>] pci_device_probe+0x80/0xa0
[  390.156016]  [<ffffffff8124fe7b>] ? driver_sysfs_add+0x6b/0x90
[  390.156016]  [<ffffffff8124ffb5>] driver_probe_device+0x95/0x1d0
[  390.156016]  [<ffffffff8125018b>] __driver_attach+0x9b/0xb0
[  390.156016]  [<ffffffff812500f0>] ? __driver_attach+0x0/0xb0
[  390.156016]  [<ffffffff8124f65b>] bus_for_each_dev+0x6b/0xa0
[  390.156016]  [<ffffffff8124fe0c>] driver_attach+0x1c/0x20
[  390.156016]  [<ffffffff8124edb5>] bus_add_driver+0x1b5/0x300
[  390.156016]  [<ffffffffa0091000>] ? iwl3945_init+0x0/0x80 [iwl3945]
[  390.156016]  [<ffffffff8125049c>] driver_register+0x7c/0x170
[  390.156016]  [<ffffffffa0091000>] ? iwl3945_init+0x0/0x80 [iwl3945]
[  390.156016]  [<ffffffff811d5f1a>] __pci_register_driver+0x6a/0xf0
[  390.156016]  [<ffffffffa0091000>] ? iwl3945_init+0x0/0x80 [iwl3945]
[  390.156016]  [<ffffffffa009104a>] iwl3945_init+0x4a/0x80 [iwl3945]
[  390.156016]  [<ffffffff810001d8>] do_one_initcall+0x38/0x190
[  390.156016]  [<ffffffff8107ffbe>] sys_init_module+0xbe/0x220
[  390.156016]  [<ffffffff81002c6b>] system_call_fastpath+0x16/0x1b
[  390.156016] Code: c7 c6 52 fa 2a a0 49 89 84 24 a0 03 00 00 49 89 84 24 a8 03 00 00 e8 2e
64 f5 e0 4c 89 e0 5b 41 5c 41 5d 41 5e c9 c3 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb f
e 0f 0b eb fe 0f 0b eb fe 0f
[  390.156016] RIP  [<ffffffffa026faf2>] ieee80211_alloc_hw+0x502/0x520 [mac80211]
[  390.156016]  RSP <ffff880025a9fc78>
[  390.515754] ---[ end trace ac1678fc227a51d2 ]---

Reinette


