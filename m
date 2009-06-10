Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58058 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbZFJNVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 09:21:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 06:21:38 -0700
Date: Wed, 10 Jun 2009 18:50:16 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
Message-ID: <20090610132015.GA10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net> <20090602111112.191915040@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090602111112.191915040@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 04:40:29PM +0530, Johannes Berg wrote:
> This ports the ath9k rfkill code to the new API offered by
> cfg80211 and thus removes a lot of useless stuff.
> 

I get the following lockdep warning few times when tried to scan
after rfkill on/off. One more issue is, when rfkill is enabled before
reboot, I could not bring up the interface when the rfkill is turned
off after reboot. Apart from this it looks good, fixes a panic which
used to happen during module unload.

757.714408] 
[  757.714410]
=======================================================
[  757.714414] [ INFO: possible circular locking dependency detected
]
[  757.714418] 2.6.30-rc8-wl #87
[  757.714420]
-------------------------------------------------------
[  757.714423] iwlist/3121 is trying to acquire lock:
[  757.714425]  (cfg80211_mutex){+.+.+.}, at: [<f8952c1d>]
cfg80211_get_dev_from_ifindex+0x1d/0x80 [cfg80211]
[  757.714439] 
[  757.714440] but task is already holding lock:
[  757.714443]  (rtnl_mutex){+.+.+.}, at: [<c0307824>]
rtnl_lock+0x14/0x20
[  757.714453] 
[  757.714453] which lock already depends on the new lock.
[  757.714454] 
[  757.714457] 
[  757.714457] the existing dependency chain (in reverse order) is:
[  757.714460] 
[  757.714461] -> #2 (rtnl_mutex){+.+.+.}:
[  757.714466]        [<c015e17e>] __lock_acquire+0xece/0x1780
[  757.714473]        [<c015eb10>] lock_acquire+0xe0/0x110
[  757.714477]        [<c03bac0e>] mutex_lock_nested+0x5e/0x360
[  757.714484]        [<c0307824>] rtnl_lock+0x14/0x20
[  757.714488]        [<fbfc99cd>] 0xfbfc99cd
[  757.714501]        [<f9d2d975>] rfkill_set_block+0x65/0xd0
[rfkill]
[  757.714509]        [<f9d2dcd4>] rfkill_epo+0x44/0xa0 [rfkill]
[  757.714515]        [<f9d2e7ed>] rfkill_op_handler+0x5d/0x1c0
[rfkill]
[  757.714522]        [<c01459b0>] worker_thread+0x1c0/0x2f0
[  757.714528]        [<c0149deb>] kthread+0x4b/0x80
[  757.714532]        [<c01045e3>] kernel_thread_helper+0x7/0x10
[  757.714538]        [<ffffffff>] 0xffffffff
[  757.714545] 
[  757.714545] -> #1 (rfkill_global_mutex){+.+.+.}:
[  757.714550]        [<c015e17e>] __lock_acquire+0xece/0x1780
[  757.714555]        [<c015eb10>] lock_acquire+0xe0/0x110
[  757.714559]        [<c03bac0e>] mutex_lock_nested+0x5e/0x360
[  757.714564]        [<f9d2e3c4>] rfkill_register+0x24/0x270
[rfkill]
[  757.714572]        [<f89526e1>] wiphy_register+0x181/0x230
[cfg80211]
[  757.714579]        [<f8a05376>] ieee80211_register_hw+0x136/0x4d0
[mac80211]
[  757.714593]        [<f8a6b02c>] ath_attach+0x74c/0xa20 [ath9k]
[  757.714605]        [<f8a7300c>] ath_pci_probe+0x12c/0x2e0 [ath9k]
[  757.714614]        [<c02650c3>] local_pci_probe+0x13/0x20
[  757.714620]        [<c0265f78>] pci_device_probe+0x68/0x90
[  757.714625]        [<c02ce131>] driver_probe_device+0x71/0x170
[  757.714631]        [<c02ce2b9>] __driver_attach+0x89/0xa0
[  757.714635]        [<c02cd9bb>] bus_for_each_dev+0x5b/0x80
[  757.714639]        [<c02cdfde>] driver_attach+0x1e/0x20
[  757.714644]        [<c02cd2f7>] bus_add_driver+0x237/0x2f0
[  757.714648]        [<c02ce59a>] driver_register+0x7a/0x150
[  757.714652]        [<c02663d3>] __pci_register_driver+0x53/0xc0
[  757.714657]        [<f8a731dc>] ath_pci_init+0x1c/0x20 [ath9k]
[  757.714666]        [<f88c0022>] 0xf88c0022
[  757.714678]        [<c010112b>] do_one_initcall+0x2b/0x1c0
[  757.714682]        [<c0167c2a>] sys_init_module+0x8a/0x1d0
[  757.714687]        [<c0103b08>] sysenter_do_call+0x12/0x3c
[  757.714691]        [<ffffffff>] 0xffffffff
[  757.714709] 
[  757.714710] -> #0 (cfg80211_mutex){+.+.+.}:
[  757.714715]        [<c015e2b3>] __lock_acquire+0x1003/0x1780
[  757.714720]        [<c015eb10>] lock_acquire+0xe0/0x110
[  757.714724]        [<c03bac0e>] mutex_lock_nested+0x5e/0x360
[  757.714729]        [<f8952c1d>]
cfg80211_get_dev_from_ifindex+0x1d/0x80 [cfg80211]
[  757.714737]        [<f8956053>] cfg80211_wext_siwscan+0x43/0x210
[cfg80211]
[  757.714746]        [<c03a32a1>] ioctl_standard_call+0x1a1/0x3a0
[  757.714751]        [<c03a2daf>] wext_handle_ioctl+0x14f/0x220
[  757.714756]        [<c02ff325>] dev_ioctl+0x485/0x560
[  757.714760]        [<c02ec105>] sock_ioctl+0xf5/0x270
[  757.714765]        [<c01d22dd>] vfs_ioctl+0x2d/0x90
[  757.714771]        [<c01d23ba>] do_vfs_ioctl+0x7a/0x590
[  757.714775]        [<c01d293b>] sys_ioctl+0x6b/0x70
[  757.714779]        [<c0103b08>] sysenter_do_call+0x12/0x3c
[  757.714784]        [<ffffffff>] 0xffffffff
[  757.714795] 
[  757.714796] other info that might help us debug this:
[  757.714797] 
[  757.714799] 1 lock held by iwlist/3121:
[  757.714802]  #0:  (rtnl_mutex){+.+.+.}, at: [<c0307824>]
rtnl_lock+0x14/0x20
[  757.714809] 
[  757.714810] stack backtrace:
[  757.714813] Pid: 3121, comm: iwlist Not tainted 2.6.30-rc8-wl #87
[  757.714816] Call Trace:
[  757.714820]  [<c03b8f7f>] ? printk+0x1d/0x26
[  757.714825]  [<c015cddc>] print_circular_bug_tail+0xbc/0xc0
[  757.714829]  [<c015cb1b>] ? print_circular_bug_entry+0x4b/0x50
[  757.714834]  [<c015e2b3>] __lock_acquire+0x1003/0x1780
[  757.714839]  [<c015d3fd>] ? __lock_acquire+0x14d/0x1780
[  757.714848]  [<f8952c1d>] ?
cfg80211_get_dev_from_ifindex+0x1d/0x80 [cfg80211]
[  757.714852]  [<c015eb10>] lock_acquire+0xe0/0x110
[  757.714859]  [<f8952c1d>] ?
cfg80211_get_dev_from_ifindex+0x1d/0x80 [cfg80211]
[  757.714867]  [<f8952c1d>] ?
cfg80211_get_dev_from_ifindex+0x1d/0x80 [cfg80211]
[  757.714871]  [<c03bac0e>] mutex_lock_nested+0x5e/0x360
[  757.714878]  [<f8952c1d>] ?
cfg80211_get_dev_from_ifindex+0x1d/0x80 [cfg80211]
[  757.714883]  [<c015c282>] ? mark_held_locks+0x62/0x80
[  757.714888]  [<c01bf89c>] ? __kmalloc+0x9c/0x250
[  757.714895]  [<f8952c1d>] cfg80211_get_dev_from_ifindex+0x1d/0x80
[cfg80211]
[  757.714903]  [<f8956053>] cfg80211_wext_siwscan+0x43/0x210
[cfg80211]
[  757.714907]  [<c03a326b>] ? ioctl_standard_call+0x16b/0x3a0
[  757.714912]  [<c03a326b>] ? ioctl_standard_call+0x16b/0x3a0
[  757.714916]  [<c03a32a1>] ioctl_standard_call+0x1a1/0x3a0
[  757.714920]  [<c0307824>] ? rtnl_lock+0x14/0x20
[  757.714926]  [<c02fa905>] ? __dev_get_by_name+0x85/0xb0
[  757.714930]  [<c03a2daf>] wext_handle_ioctl+0x14f/0x220
[  757.714938]  [<f8956010>] ? cfg80211_wext_siwscan+0x0/0x210
[cfg80211]
[  757.714942]  [<c02ff325>] dev_ioctl+0x485/0x560
[  757.714947]  [<c02ec010>] ? sock_ioctl+0x0/0x270
[  757.714951]  [<c02ec105>] sock_ioctl+0xf5/0x270
[  757.714955]  [<c02ec010>] ? sock_ioctl+0x0/0x270
[  757.714959]  [<c01d22dd>] vfs_ioctl+0x2d/0x90
[  757.714964]  [<c01d23ba>] do_vfs_ioctl+0x7a/0x590
[  757.714969]  [<c01abf26>] ? handle_mm_fault+0x126/0x740
[  757.714975]  [<c0120bce>] ? do_page_fault+0x17e/0x2c0
[  757.714980]  [<c02555fc>] ? trace_hardirqs_off_thunk+0xc/0x10
[  757.714984]  [<c02555ec>] ? trace_hardirqs_on_thunk+0xc/0x10
[  757.714989]  [<c014e8bb>] ? up_read+0x1b/0x30
[  757.714993]  [<c0103b41>] ? sysenter_exit+0xf/0x1a
[  757.714997]  [<c01d293b>] sys_ioctl+0x6b/0x70
[  757.715001]  [<c0103b08>] sysenter_do_call+0x12/0x3c
[  757.715011] phy0: device no longer idle - scanning
[  758.876667] wlan0: dropped data frame to not associated station
00:00:00:00:00:00
[  763.813869] phy0: device now idle


