Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33889 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbcI0WVR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 18:21:17 -0400
Received: by mail-pf0-f175.google.com with SMTP id l25so10069388pfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 15:21:17 -0700 (PDT)
Subject: Re: rfkill guidance
To: Johannes Berg <johannes@sipsolutions.net>
References: <324c35c6-49ca-174c-db07-674532f3e628@broadcom.com>
 <1474961105.5141.5.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Jonathan Richardson <jonathan.richardson@broadcom.com>
Message-ID: <0a8cff88-73aa-8311-7afe-98612161421f@broadcom.com> (sfid-20160928_002122_184964_A6E5B02C)
Date: Tue, 27 Sep 2016 15:21:14 -0700
MIME-Version: 1.0
In-Reply-To: <1474961105.5141.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+linux-wireless

On 16-09-27 12:25 AM, Johannes Berg wrote:
> Hi,
> 
> You should probably Cc the linux-wireless list, at least :)
> 
> But anyway.
> 
>> The driver enables/disables one or more regulators controlling a
>> bluetooth radio using the rfkill_ops set_block function. It's
>> different in that there is no bluetooth driver in the kernel - it's
>> controlled with some firmware that gets uploaded to a chip. The only
>> kernel usage is to power on/off the regulator(s).
> 
> Interesting, don't you have to talk to the BT somehow? So the BT can't
> ever be used from the kernel?

Not from the kernel, a user space app interacts with the BT chip and
kernel. More below.

> 
> Is rfkill really even the right concept here then? I mean, from the
> kernel's POV it doesn't even really have to know there's BT behind
> that, if there's no relation to BT in the kernel? Then again, the
> *user* might need to know?

> Would you be able to explain the overall system function of this a bit
> more?

Sure, I'll tell you what I can. A user space app handles interaction
between the kernel and BT radio. When the app is started, it enables the
regulator (via the rfkill driver and userspace sysfs interface) to power
up the BT chip. The app sends the firmware via a uart to the chip. The
chip loads the firmware then goes into a lower power mode. When the app
needs to talk to the chip it toggles a gpio (device wake) before sending
messages. If the kernel is in a low power mode and the BT chip receives
a message that requires handling by the app, then a host wake gpio is
driven to wake up the host (kernel).

In addition to the regulator(s) controlled by the rfkill driver I didn't
mention the two gpio's previously. The existing rfkill driver does
nothing with them. It just exports the global gpio # to sysfs which the
app can read to control via the gpio sysfs interface. These could be
hard coded in a startup script or something, they aren't that important
but it does handle the conversion to the global gpio# from 1 of 3 gpio
controllers on a Cygnus SOC. I'm not sure how to handle that, since the
gpio's vary across board variants.

I'm not sure rfkill is the right concept either but the app does use the
rfkill sysfs interface to control the regulators which in turn powers a
BT radio. The driver could not use the rfkill interface and provide its
own but would essentially be doing the same thing as rfkill-regulator.c.

> 
>> The driver is basically a wrapper around controlling regulators.
>> There's already rfkill-regulator.c but it has no DT support and only
>> controls 1 regulator. I was considering modifying it until I saw this
>> thread where Mark objected and it looks like the submitter abandoned
>> the patchset (http://www.serverphorums.com/read.php?12,870025).
> 
> I don't think that's a "killer" thread for this feature really. Yes,
> people have (quite possibly legitimate) concerns about that, but we
> should discuss that.
> 
>> I couldn't see any way to enable/disable regulators from sysfs so it
>> looks like the regulator kernel API needs to be used from some
>> driver.
> 
> Indeed, looks like Documentation/ABI/testing/sysfs-class-regulator is
> all read-only.

There's a regulator driver named userspace-consumer.c that allows
enable/disable from userspace, but it doesn't support DT either.

> 
>> Do you think adding DT support and multiple regulators to the
>> existing driver is the best way to add support for this? Our driver
>> basically duplicates this and I don't think can be upstreamed the way
>> it is.
> 
> Hard to say, really. Like I said, I'm not really _quite_ sure rfkill is
> even the right concept, since you're essentially toggling some
> hardware, but then again it *does* end up being a BT device.

Looking forward to more feedback. I see the options as either rfkill or
some regulator controller that allows enabling/disabling via sysfs.

> 
> It also looks like nobody is actually using rfkill-regulator anywhere
> (in the upstream kernel), so we could just port that entirely to DT,
> which would be nice.
> 
> johannes
> 

Thanks,
Jon
