Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46333 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab2ENTbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 15:31:06 -0400
Received: by obbtb18 with SMTP id tb18so7819198obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 12:31:05 -0700 (PDT)
Message-ID: <4FB15D76.9000302@lwfinger.net> (sfid-20120514_213110_640776_E6741D88)
Date: Mon, 14 May 2012 14:31:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Warning from wireless-testing for ipw2100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A freshly pulled copy of wireless-testing 3.4-rc7 has the following warning that 
the 802.11 band has not been set when the ipw2100 driver is probed:

[   17.766431] ------------[ cut here ]------------
[   17.766467] WARNING: at net/wireless/core.c:562 wiphy_register+0x34c/0x3c0 
[cfg80211]()
[   17.766471] Hardware name: Latitude D600
[   17.766474] Modules linked in: ipw2100(+) libipw pcmcia cfg80211 ppdev 
parport_pc yenta_socket sr_mod pcmcia_rsrc parport iTCO_wdt cdrom sg rfkill pcmcia_
core lib80211 tg3 video button battery ac iTCO_vendor_support joydev shpchp 
pcspkr pciehp pci_hotplug autofs4 radeon ttm drm_kms_helper uhci_hcd ehci_hcd rtc
_cmos thermal drm hwmon i2c_algo_bit i2c_core processor usbcore usb_common 
ata_generic ata_piix ahci libahci libata
[   17.766525] Pid: 474, comm: modprobe Not tainted 3.4.0-rc7-wl+ #6
[   17.766528] Call Trace:
[   17.766541]  [<c066ad08>] ? printk+0x28/0x2a
[   17.766552]  [<c0230edd>] warn_slowpath_common+0x6d/0xa0
[   17.766563]  [<e0b253bc>] ? wiphy_register+0x34c/0x3c0 [cfg80211]
[   17.766573]  [<e0b253bc>] ? wiphy_register+0x34c/0x3c0 [cfg80211]
[   17.766578]  [<c0230f2d>] warn_slowpath_null+0x1d/0x20
[   17.766588]  [<e0b253bc>] wiphy_register+0x34c/0x3c0 [cfg80211]
[   17.766605]  [<e0b5b0d6>] ipw2100_wdev_init+0x196/0x1c0 [ipw2100]
[   17.766616]  [<e0b5d962>] ipw2100_pci_init_one+0x2b2/0x694 [ipw2100]
[   17.766632]  [<c047ce52>] local_pci_probe+0x42/0xb0
[   17.766637]  [<c047e2b0>] pci_device_probe+0x60/0x90
[   17.766645]  [<c0376de2>] ? sysfs_create_link+0x12/0x20
[   17.766654]  [<c050f1f6>] really_probe+0x56/0x2e0
[   17.766659]  [<c037636d>] ? create_dir+0x5d/0xa0
[   17.766667]  [<c0518c6b>] ? pm_runtime_barrier+0x3b/0xa0
[   17.766672]  [<c050f5e4>] driver_probe_device+0x44/0xa0
[   17.766677]  [<c047e227>] ? pci_match_device+0x97/0xa0
[   17.766681]  [<c050f6c9>] __driver_attach+0x89/0x90
[   17.766686]  [<c050f640>] ? driver_probe_device+0xa0/0xa0
[   17.766691]  [<c050da2a>] bus_for_each_dev+0x3a/0x70
[   17.766695]  [<c050ee6c>] driver_attach+0x1c/0x30
[   17.766699]  [<c050f640>] ? driver_probe_device+0xa0/0xa0
[   17.766704]  [<c050ea77>] bus_add_driver+0x187/0x280
[   17.766710]  [<c045b9cd>] ? kset_find_obj+0x2d/0x60
[   17.766715]  [<c047e2e0>] ? pci_device_probe+0x90/0x90
[   17.766719]  [<c047e2e0>] ? pci_device_probe+0x90/0x90
[   17.766724]  [<c050fb85>] driver_register+0x65/0x110
[   17.766729]  [<c047e09d>] __pci_register_driver+0x3d/0xa0
[   17.766738]  [<e09f705c>] ipw2100_init+0x5c/0x1000 [ipw2100]
[   17.766743]  [<c020110f>] do_one_initcall+0x2f/0x170
[   17.766749]  [<e09f7000>] ? 0xe09f6fff
[   17.766757]  [<c0287ce8>] sys_init_module+0xa8/0x210
[   17.766766]  [<c067a075>] syscall_call+0x7/0xb
[   17.766769] ---[ end trace 559898c6bb0d1c75 ]---
[   17.767093] ipw2100: probe of 0000:02:03.0 failed with error -5

I do not use the device and it doesn't make any difference to me, but there may 
be someone that needs it.

Larry
