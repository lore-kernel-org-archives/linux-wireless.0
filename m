Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56307 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZFJNdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 09:33:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 06:33:27 -0700
Date: Wed, 10 Jun 2009 19:02:04 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
Message-ID: <20090610133204.GB10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net> <20090602111112.191915040@sipsolutions.net> <20090610132015.GA10126@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090610132015.GA10126@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 06:50:16PM +0530, Vasanth Thiagarajan wrote:
> On Tue, Jun 02, 2009 at 04:40:29PM +0530, Johannes Berg wrote:
> > This ports the ath9k rfkill code to the new API offered by
> > cfg80211 and thus removes a lot of useless stuff.
> >
> 
> I get the following lockdep warning few times when tried to scan
> after rfkill on/off. One more issue is, when rfkill is enabled before
> reboot, I could not bring up the interface when the rfkill is turned
> off after reboot. Apart from this it looks good, fixes a panic which
> used to happen during module unload.
> 
> [  757.714466]        [<c015e17e>] __lock_acquire+0xece/0x1780
> [  757.714473]        [<c015eb10>] lock_acquire+0xe0/0x110
> [  757.714477]        [<c03bac0e>] mutex_lock_nested+0x5e/0x360
> [  757.714484]        [<c0307824>] rtnl_lock+0x14/0x20
> [  757.714488]        [<fbfc99cd>] 0xfbfc99cd
> [  757.714501]        [<f9d2d975>] rfkill_set_block+0x65/0xd0
> [rfkill]
> [  757.714509]        [<f9d2dcd4>] rfkill_epo+0x44/0xa0 [rfkill]
> [  757.714515]        [<f9d2e7ed>] rfkill_op_handler+0x5d/0x1c0
> [rfkill]
> [  757.714522]        [<c01459b0>] worker_thread+0x1c0/0x2f0
> [  757.714528]        [<c0149deb>] kthread+0x4b/0x80
> [  757.714532]        [<c01045e3>] kernel_thread_helper+0x7/0x10
> [  757.714538]        [<ffffffff>] 0xffffffff
> [  757.714545]
> [  757.714545] -> #1 (rfkill_global_mutex){+.+.+.}:
> [  757.714550]        [<c015e17e>] __lock_acquire+0xece/0x1780
> [  757.714555]        [<c015eb10>] lock_acquire+0xe0/0x110
> [  757.714559]        [<c03bac0e>] mutex_lock_nested+0x5e/0x360
> [  757.714564]        [<f9d2e3c4>] rfkill_register+0x24/0x270
> [rfkill]
> [  757.714572]        [<f89526e1>] wiphy_register+0x181/0x230
> [cfg80211]
> [  757.714579]        [<f8a05376>] ieee80211_register_hw+0x136/0x4d0
> [mac80211]
> [  757.714593]        [<f8a6b02c>] ath_attach+0x74c/0xa20 [ath9k]
> [  757.714605]        [<f8a7300c>] ath_pci_probe+0x12c/0x2e0 [ath9k]
> [  757.714614]        [<c02650c3>] local_pci_probe+0x13/0x20
> [  757.714620]        [<c0265f78>] pci_device_probe+0x68/0x90
> [  757.714625]        [<c02ce131>] driver_probe_device+0x71/0x170
> [  757.714631]        [<c02ce2b9>] __driver_attach+0x89/0xa0
> [  757.714635]        [<c02cd9bb>] bus_for_each_dev+0x5b/0x80
> [  757.714639]        [<c02cdfde>] driver_attach+0x1e/0x20
> [  757.714644]        [<c02cd2f7>] bus_add_driver+0x237/0x2f0
> [  757.714648]        [<c02ce59a>] driver_register+0x7a/0x150
> [  757.714652]        [<c02663d3>] __pci_register_driver+0x53/0xc0
> [  757.714657]        [<f8a731dc>] ath_pci_init+0x1c/0x20 [ath9k]
> [  757.714666]        [<f88c0022>] 0xf88c0022
> [  757.714678]        [<c010112b>] do_one_initcall+0x2b/0x1c0
> [  757.714682]        [<c0167c2a>] sys_init_module+0x8a/0x1d0
> [  757.714687]        [<c0103b08>] sysenter_do_call+0x12/0x3c
> [  757.714691]        [<ffffffff>] 0xffffffff
> [  757.714709]


I was doing load/unload along with rf on/off and scan.
