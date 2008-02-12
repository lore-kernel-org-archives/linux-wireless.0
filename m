Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:59972 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYBLTyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 14:54:25 -0500
Date: Tue, 12 Feb 2008 20:52:52 +0100
From: maximilian attems <max@stro.at>
To: Andreas Richter <ar@oszine.de>, 464523@bugs.debian.org
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: Bug#464523: linux-image-2.6.24-1-amd64: b43 needs patches for kernel 2.6.24
Message-ID: <20080212195252.GC22054@baikonur.stro.at> (sfid-20080212_195430_717859_89FAEAAA)
References: <20080211220621.GC5198@stro.at> <200802122038.06426.ar@oszine.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200802122038.06426.ar@oszine.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 12, 2008 at 08:37:59PM +0100, Andreas Richter wrote:
> Am Montag, 11. Februar 2008 23:06:21 schrieb maximilian attems:
> b43 doesn't work here with 2.6.24.1 either :(

ok so please install kerneloops,  let it report upstream,
quick edit in /etc/kerneloops.conf and reboot into faulty kernel.
so upstream will be notified on your oops.
 
> When i boot my own kernel (2.6.24) with patches the modprobe ssb (on startup 
> or on console) loads the b43 module also.
> When i try an modprobe ssb i became the following output:
> 
> ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:30:00.0 to 64
> ssb: SPROM revision 3 detected.
> ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
> b43-phy2: Broadcom 4311 WLAN found
> phy2: Selected rate control algorithm 'simple'
> input: b43-phy2 as /class/input/input14
> Registered led device: b43-phy2:tx
> Registered led device: b43-phy2:rx
> Registered led device: b43-phy2:radio
> 
> After that the wlan works ok.
> 
> But on the 2.6.24.1 kernel i became the following output on modprobe ssb:
> 
> ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:30:00.0 to 64
> WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
> Pid: 3847, comm: modprobe Tainted: P        2.6.24-1-amd64 #1
> 
> Call Trace:
>  [<ffffffff880527cd>] :ssb:ssb_tmslow_reject_bitmask+0x4a/0x53
>  [<ffffffff8805303d>] :ssb:ssb_device_is_enabled+0xf/0x3b
>  [<ffffffff880551ba>] :ssb:ssb_pcicore_init+0x19/0x4a
>  [<ffffffff88052544>] :ssb:ssb_attach_queued_buses+0x9a/0x294
>  [<ffffffff88053ce0>] :ssb:ssb_pci_get_invariants+0x0/0x2b7
>  [<ffffffff88052b53>] :ssb:ssb_bus_register+0x13d/0x1ac
>  [<ffffffff88052c72>] :ssb:ssb_bus_pcibus_register+0x2a/0x4b
>  [<ffffffff880545a1>] :ssb:ssb_pcihost_probe+0x6f/0x9e
>  [<ffffffff8031d400>] pci_device_probe+0xd1/0x138
>  [<ffffffff80379dda>] driver_probe_device+0xf7/0x174
>  [<ffffffff80379ef9>] __driver_attach+0x0/0x92
>  [<ffffffff80379f53>] __driver_attach+0x5a/0x92
>  [<ffffffff803791c6>] bus_for_each_dev+0x43/0x6e
>  [<ffffffff80379546>] bus_add_driver+0x77/0x1be
>  [<ffffffff8031d5d9>] __pci_register_driver+0x58/0x8a
>  [<ffffffff88031045>] :ssb:ssb_modinit+0x45/0x5d
>  [<ffffffff80256ae8>] sys_init_module+0x16e3/0x1821
>  [<ffffffff8020be2e>] system_call+0x7e/0x83
> 
> ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
> 
> 
> That looks different. 
> It seems that ssb doesn't detect the Broadcom device.

i don't like the tainted flag, why does that come?
 
> > thanks
> 
> No worries. 
> Hope my input helps to fix the problem.

adding b43 MAINTAINERS on cc to let them know.
