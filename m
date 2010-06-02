Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33915 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0FBVmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 17:42:37 -0400
Received: by vws11 with SMTP id 11so3105435vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 14:42:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006021129.43621.rossi.f@inwind.it>
References: <201006021129.43621.rossi.f@inwind.it>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Jun 2010 14:42:14 -0700
Message-ID: <AANLkTik0A8qhlIi1pjvo0DKXhxjBEYEwOCn6iIsLXFJi@mail.gmail.com>
Subject: Re: WARNING: at drivers/base/core.c:130 device_release+0x82/0x90()
To: Fabio Rossi <rossi.f@inwind.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 2, 2010 at 2:29 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
> Compiling the kernel without ACPI (CONFIG_ACPI=n) gives the following warning:
>
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: World regulatory domain updated:
>    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> ath5k 0000:08:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> ath5k 0000:08:01.0: registered as 'phy0'
> ath5k phy0: request_irq failed
> ------------[ cut here ]------------

Since traces are printed reversed you will have to read my logic from
bottom to top:

Seems we need to implement the dev_release() op for the class of our devices.

> WARNING: at drivers/base/core.c:130 device_release+0x82/0x90()
> Hardware name: System Product Name
> Device 'phy0' does not have a release() function, it is broken and must be
> fixed.
> Modules linked in: ath5k(+) mac80211 ath cfg80211 vmnet vsock vmci vmmon
> gspca_zc3xx gspca_main [last unloaded: cfg80211]
> Pid: 8607, comm: modprobe Tainted: G        W   2.6.35-rc1-wl #50
> Call Trace:
>  [<ffffffff8103917a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81039251>] warn_slowpath_fmt+0x41/0x50
>  [<ffffffff8138c4a2>] device_release+0x82/0x90
>  [<ffffffff81225fc7>] kobject_release+0x47/0x90
>  [<ffffffff81225f80>] ? kobject_release+0x0/0x90
>  [<ffffffff81227187>] kref_put+0x37/0x70
>  [<ffffffff81225e87>] kobject_put+0x27/0x60
>  [<ffffffff8138be22>] put_device+0x12/0x20

Here is cfg80211's cleanup.

>  [<ffffffffa00eb790>] wiphy_free+0x10/0x20 [cfg80211]

And something on probe failed, which triggered it to bail out and free
the struct.

>  [<ffffffffa011102d>] ieee80211_free_hw+0xd/0x10 [mac80211]

OK so the device was probed.

>  [<ffffffffa016f891>] ath5k_pci_probe+0x16da/0x1710 [ath5k]
>  [<ffffffff811089da>] ? __sysfs_add_one+0x2a/0xe0
>  [<ffffffff81108b07>] ? sysfs_add_one+0x27/0xd0
>  [<ffffffff8123e322>] local_pci_probe+0x12/0x20
>  [<ffffffff8123e5d0>] pci_device_probe+0x80/0xb0
>  [<ffffffff8138f98a>] ? driver_sysfs_add+0x5a/0x90
>  [<ffffffff8138facd>] driver_probe_device+0x8d/0x1a0
>  [<ffffffff8138fc73>] __driver_attach+0x93/0xa0
>  [<ffffffff8138fbe0>] ? __driver_attach+0x0/0xa0
>  [<ffffffff8138f1e8>] bus_for_each_dev+0x68/0x90
>  [<ffffffff8138f929>] driver_attach+0x19/0x20
>  [<ffffffff8138e9a8>] bus_add_driver+0xb8/0x260
>  [<ffffffff8138ff68>] driver_register+0x78/0x140
>  [<ffffffff8123e841>] __pci_register_driver+0x51/0xd0
>  [<ffffffff811f2996>] ? debugfs_create_dir+0x16/0x20
>  [<ffffffffa0180000>] ? init_ath5k_pci+0x0/0x43 [ath5k]
>  [<ffffffffa0180028>] init_ath5k_pci+0x28/0x43 [ath5k]
>  [<ffffffff810001d7>] do_one_initcall+0x37/0x190
>  [<ffffffff81066fc6>] sys_init_module+0xd6/0x250
>  [<ffffffff810023ab>] system_call_fastpath+0x16/0x1b
> ---[ end trace a6ef611dbd725746 ]---
> ath5k 0000:08:01.0: PCI INT A disabled
> ath5k: probe of 0000:08:01.0 failed with error -22
>
> It is not possible to use the wireless network.
>
> Fabio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
