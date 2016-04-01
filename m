Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:45254 "EHLO
	mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbcDAWoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 18:44:55 -0400
Date: Sat, 2 Apr 2016 00:46:46 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160401224646.GA11281@wunner.de> (sfid-20160402_004502_782084_8139D553)
References: <E1akxli-00030z-BC@bombadil.infradead.org>
 <20160331231346.GA7469@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20160331231346.GA7469@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

On Fri, Apr 01, 2016 at 12:13:46AM +0100, Chris Bainbridge wrote:
> On Tue, Mar 29, 2016 at 07:41:30PM +0200, Lukas Wunner wrote:
> > Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> > on boot until they are reset, causing spurious interrupts if the IRQ is
> > shared. Apparently the EFI bootloader enables the device and does not
> > disable it before passing control to the OS. The bootloader contains a
> > driver for the wireless card which allows it to phone home to Cupertino.
> > This is used for Internet Recovery (download and install OS X images)
> > and probably also for Back to My Mac (remote access, RFC 6281) and to
> > discover stolen hardware.
> > 
> > The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
> > is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
> > reader, HDA card on discrete GPU). As soon as an interrupt handler is
> > installed for one of these devices, the ensuing storm of spurious IRQs
> > causes the kernel to disable the IRQ and switch to polling. This lasts
> > until the b43 driver loads and resets the device.
> > 
> > Loading the b43 driver first is not always an option, in particular with
> > the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
> > installed early on because it is built in, unlike b43 which is usually
> > a module.
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632
> 
> Should also fix https://bugzilla.kernel.org/show_bug.cgi?id=111781 ?
> Given that this is a serious bug that can corrupt filesystems it would
> be good to see the fix in stable too.

I cannot reproduce this particular issue on my MBP9,1 even though it
is architecturally very similar to your MBP10,2. I tested it with
"iommu=force intel_iommu=on", blacklisted b43 and stressed the machine
a bit with kernel compiles. No issues.

Have you tested my patch? As Michael Büsch has pointed out correctly,
it should mitigate that issue but will not solve it completely.
You write in the bugzilla entry that you've seen the issue as early
as 0.7 seconds into the boot. That's not a very precise method to
measure boot progress but on my machine the card is reset around 1.2
seconds, so likely too late. It's possible to execute the PCI quirk
slightly earlier (in the header fixup section rather than the late
fixup section) but that wouldn't make a significant difference.

If you use the method described in Matthew Garrett's blog post,
i.e. boot with "memmap=0xc0$0x1568a0", does the issue go away?
If so, we could probably add a quirk in arch/x86/kernel/e820.c
to mark that particular area reserved, or generally mark all
EFI boot services areas as reserved on Macs. This memory could
then be marked usable again once the card has been reset.

As to why the issue doesn't occur on my machine, my guess is that
the wireless card only writes packets to memory if it is associated
with a base station. Do you have an open WLAN around? Try moving
out of its reach and test if the issue goes away. Alternatively,
did you enter Wifi credentials in OS X? If so it has saved the
credentials to EFI variables. To verify if it has, use this on OS X:

/usr/sbin/nvram 36C28AB5-6566-4C50-9EBD-CBB920F83843:current-network
/usr/sbin/nvram 36C28AB5-6566-4C50-9EBD-CBB920F83843:preferred-networks
/usr/sbin/nvram 36C28AB5-6566-4C50-9EBD-CBB920F83843:preferred-count

On Linux, invoke "mount -t efivarfs none /sys/firmware/efi/efivars"
and delete the variables (use chattr -i first if you're on Linux 4.5+).
Test if the issue goes away.

I have neither an open WLAN nearby nor Wifi credentials in my EFI
variables, so the wireless card cannot associate with a base station
in the pre-OS phase and that's probably the reason why the issue doesn't
occur on my machine.

Best regards,

Lukas
