Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53840 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750700AbcI1GiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 02:38:06 -0400
Message-ID: <1475044682.4139.18.camel@sipsolutions.net> (sfid-20160928_083815_252455_876B9E2B)
Subject: Re: rfkill guidance
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        Mark Rutland <mark.rutland@arm.com>
Date: Wed, 28 Sep 2016 08:38:02 +0200
In-Reply-To: <0a8cff88-73aa-8311-7afe-98612161421f@broadcom.com> (sfid-20160928_002127_321746_FD82CF46)
References: <324c35c6-49ca-174c-db07-674532f3e628@broadcom.com>
         <1474961105.5141.5.camel@sipsolutions.net>
         <0a8cff88-73aa-8311-7afe-98612161421f@broadcom.com>
         (sfid-20160928_002127_321746_FD82CF46)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Mark, Marek, DT folks - the root of the discussion here is the old
rfkill-regulator device-tree support. I'm discussing some details of
the system here first, but below we get to the DT discussion.

The old thread is here:
http://thread.gmane.org/gmane.linux.kernel/1643236

> Sure, I'll tell you what I can. A user space app handles interaction
> between the kernel and BT radio. When the app is started, it enables
> the regulator (via the rfkill driver and userspace sysfs interface) 

You should probably consider /dev/rfkill over the sysfs interface :)

> to power up the BT chip. The app sends the firmware via a uart to the
> chip. The chip loads the firmware then goes into a lower power mode.
> When the app needs to talk to the chip it toggles a gpio (device
> wake) before sending messages. If the kernel is in a low power mode
> and the BT chip receives a message that requires handling by the app,
> then a host wake gpio is driven to wake up the host (kernel).

So the reason then for having it all done in userspace is that there's
a UART to communicate with it? Or is the reason that you just don't
want the kernel abstraction? There *are* UART BT drivers in the kernel,
as far as I can tell, what's the difference? Or is it that there's just
a completely different protocol, vs. the HCI protocol used normally?

At this point I'm just curious though, doesn't seem all that important
to the discussion :)

Although having a DT binding for a kernel driver for the device that
includes the regulator might change the discussion somewhat?

> In addition to the regulator(s) controlled by the rfkill driver I
> didn't mention the two gpio's previously. The existing rfkill driver
> does nothing with them. It just exports the global gpio # to sysfs
> which the app can read to control via the gpio sysfs interface. These
> could be hard coded in a startup script or something, they aren't
> that important but it does handle the conversion to the global gpio#
> from 1 of 3 gpio controllers on a Cygnus SOC. I'm not sure how to
> handle that, since the gpio's vary across board variants.

Could also just be exposed in the DT, I guess? Userspace can read the
DT, no? Not sure that actually gives you all the dynamic information
though that might be needed if there's any kind of mapping going on.

> > Indeed, looks like Documentation/ABI/testing/sysfs-class-regulator
> > is all read-only.
> 
> There's a regulator driver named userspace-consumer.c that allows
> enable/disable from userspace, but it doesn't support DT either.

Adding DT support there might make some sense, perhaps? Although that's
not really a useful DT binding at all since it won't provide any hints
as to how you'd use that, so ... maybe not so much.

As I read it, the main concern about or objection to the rfkill-
regulator DT binding was that it's not tied to a device, when it seems
that rfkill instances really should be living off a device that they
control. That's true for many, but not all devices.

Today we already have all the platform rfkill instances (like the
various ACPI ones) that don't live off a device that they control, but
instead control the platform's radio functionality. And in some cases,
that actually has very similar behaviour to what was proposed in the
previous patch, and what you're looking for, in that it sometimes kills
power to BT or WiFi chips when soft-disabled (or kicks them off the bus
in some other way). Particularly for the ones that call some random
ACPI function to deal with things, that can happen.

rfkill-regulator, with its platform driver today, more or less mirrors
that. You could even use that with a very simple (few lines of code)
platform module that just binds the regulators to rfkill-regulator, I
think.

Making this more flexible and configurable with DT would make sense to
me, less for the usage of rfkill-for-a-device (which could *also* be
done, but isn't what you need or what was discussed before), but more
for the usage of rfkill-for-the-platform.

Mark and DT folks - can you clarify your objections to the old patch?
Am I reading things correctly, and if so, what do you think about the
platform rfkill?

johannes
