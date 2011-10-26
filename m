Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914Ab1JZRhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 13:37:50 -0400
Subject: Re: ipw2200 fails to load firmware when returning from suspend
From: Dan Williams <dcbw@redhat.com>
To: plaes@plaes.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2011 11:31:31 -0500
In-Reply-To: <1319621899.29639.7.camel@localhost.localdomain>
References: <1319621899.29639.7.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1319646693.8698.8.camel@dcbw.foobar.com> (sfid-20111026_193752_971351_D11C43D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-26 at 12:38 +0300, plaes@plaes.org wrote:
> Heya!
> 
> I've been running into following issue with recent kernels fairly often
> when waking up Dell Latitude D610 laptop from suspend:


	if (WARN_ON(usermodehelper_is_disabled())) {
		dev_err(device, "firmware: %s will not be loaded\n", name);
		retval = -EBUSY;
		goto out;
	}

The usermodehelper gets enabled by suspend_finish() in
kernel/power/suspend.c, so something is waking up the ipw driver from
userspace before the kernel has completed waking up.  Maybe make
whatever that thing is that pokes ipw wait a second?

Dan

> [snip]
> [347767.844024] pci 0000:00:1e.0: setting latency timer to 64
> [347767.844046] eth1: Coming out of suspend...
> [347767.844060] ipw2200 0000:03:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [347767.884092] ------------[ cut here ]------------
> [347767.884107] WARNING: at drivers/base/firmware_class.c:537 _request_firmware+0xb5/0x31b()
> [347767.884113] Hardware name: Latitude D610                   
> [347767.884117] Modules linked in: lib80211_crypt_ccmp ipw2200 tg3 libipw libphy lib80211
> [347767.884134] Pid: 17562, comm: kworker/0:0 Not tainted 3.1.0-rc8+ #50
> [347767.884139] Call Trace:
> [347767.884150]  [<c1027fce>] ? warn_slowpath_common+0x7c/0x8f
> [347767.884159]  [<c1287e1c>] ? _request_firmware+0xb5/0x31b
> [347767.884167]  [<c1287e1c>] ? _request_firmware+0xb5/0x31b
> [347767.884176]  [<c1027ffc>] ? warn_slowpath_null+0x1b/0x1f
> [347767.884184]  [<c1287e1c>] ? _request_firmware+0xb5/0x31b
> [347767.884194]  [<c12880f8>] ? request_firmware+0x17/0x1b
> [347767.884211]  [<f83900a8>] ? ipw_up+0xf9/0x133f [ipw2200]
> [347767.884222]  [<c101ee71>] ? set_next_entity+0xb4/0x122
> [347767.884230]  [<c1001a9b>] ? __switch_to+0x34/0x10f
> [347767.884239]  [<c101f6b7>] ? finish_task_switch.clone.124.clone.138+0x3e/0x76
> [347767.884247]  [<c101e963>] ? need_resched+0x11/0x1a
> [347767.884258]  [<c13f13b1>] ? __schedule+0x471/0x4e7
> [347767.884274]  [<f83914d3>] ? ipw_bg_up+0x1c/0x25 [ipw2200]
> [347767.884283]  [<c1037370>] ? process_one_work+0xfd/0x1af
> [347767.884298]  [<f83914b7>] ? ipw_net_init+0x32/0x32 [ipw2200]
> [347767.884307]  [<c1038437>] ? worker_thread+0xbd/0x134
> [347767.884316]  [<c103837a>] ? manage_workers.clone.30+0x19f/0x19f
> [347767.884324]  [<c103aaaf>] ? kthread+0x62/0x67
> [347767.884332]  [<c103aa4d>] ? flush_kthread_worker+0x7a/0x7a
> [347767.884341]  [<c13f3076>] ? kernel_thread_helper+0x6/0xd
> [347767.884347] ---[ end trace 4141d0bfaee985bf ]---
> [347767.884353] ipw2200 0000:03:03.0: firmware: ipw2200-bss.fw will not be loaded
> [347767.884360] ipw2200: ipw2200-bss.fw request_firmware failed: Reason -16
> [347767.884365] ipw2200: Unable to load firmware: -16
> ...
> [347769.850709] Restarting tasks ... done.
> [347770.870138] ipw2200: No space for Tx
> [347770.870143] ipw2200: Failed to send POWER_MODE: Reason -16
> [/snip]
> 
> After rmmod/insmod cycle card works fine again:
> 
> [snip]
> [347824.614542] ipw2200 0000:03:03.0: PCI INT A disabled
> [347832.294216] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
> [347832.294221] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [347832.294353] ipw2200 0000:03:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [347832.294382] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
> [347832.503972] cfg80211: failed to add phy80211 symlink to netdev!
> [347832.505049] ipw2200: Detected geography ZZD (13 802.11bg channels, 0 802.11a channels)
> [/snip]
> 
> [snip]
> 03:03.0 Network controller: Intel Corporation PRO/Wireless 2200BG [Calexico2] Network Connection (rev 05)
> 	Subsystem: Intel Corporation Dell Latitude D600
> 	Flags: bus master, medium devsel, latency 64, IRQ 17
> 	Memory at dfbff000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [dc] Power Management version 2
> 	Kernel driver in use: ipw2200
> 	Kernel modules: ipw2200
> [/snip]
> 
> 
> Any ideas where to look further?
> 
> Päikest,
> Priit Laes ;)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


