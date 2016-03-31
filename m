Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33706 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbcCaSvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 14:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
Date: Thu, 31 Mar 2016 20:51:48 +0200
Message-ID: <CACna6ryFb=CiifKWX+VOZx=-FA3Fitsr+D4RNmcmHGT6hUiQhA@mail.gmail.com> (sfid-20160331_205152_965028_8A8E9028)
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 March 2016 at 20:20, Lukas Wunner <lukas@wunner.de> wrote:
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
> Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Acked-by: Rafał Miłecki <zajec5@gmail.com>

For bcma part (I'm totally OK with moving BCMA_CORE_SIZE).
