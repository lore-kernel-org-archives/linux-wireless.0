Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34225 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbcCaXNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 19:13:51 -0400
Date: Fri, 1 Apr 2016 00:13:46 +0100
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160331231346.GA7469@localhost> (sfid-20160401_011354_173393_F53D9369)
References: <E1akxli-00030z-BC@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1akxli-00030z-BC@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2016 at 07:41:30PM +0200, Lukas Wunner wrote:
> Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> on boot until they are reset, causing spurious interrupts if the IRQ is
> shared. Apparently the EFI bootloader enables the device and does not
> disable it before passing control to the OS. The bootloader contains a
> driver for the wireless card which allows it to phone home to Cupertino.
> This is used for Internet Recovery (download and install OS X images)
> and probably also for Back to My Mac (remote access, RFC 6281) and to
> discover stolen hardware.
> 
> The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
> is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
> reader, HDA card on discrete GPU). As soon as an interrupt handler is
> installed for one of these devices, the ensuing storm of spurious IRQs
> causes the kernel to disable the IRQ and switch to polling. This lasts
> until the b43 driver loads and resets the device.
> 
> Loading the b43 driver first is not always an option, in particular with
> the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
> installed early on because it is built in, unlike b43 which is usually
> a module.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632

Should also fix https://bugzilla.kernel.org/show_bug.cgi?id=111781 ?
Given that this is a serious bug that can corrupt filesystems it would
be good to see the fix in stable too.
