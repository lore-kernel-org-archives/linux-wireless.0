Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54038 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbcI1Gtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 02:49:55 -0400
Message-ID: <1475045391.4139.26.camel@sipsolutions.net> (sfid-20160928_085006_469703_D5C48A2E)
Subject: Re: rfkill guidance
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        Mark Rutland <mark.rutland@arm.com>
Date: Wed, 28 Sep 2016 08:49:51 +0200
In-Reply-To: <1475044682.4139.18.camel@sipsolutions.net> (sfid-20160928_083815_252455_876B9E2B)
References: <324c35c6-49ca-174c-db07-674532f3e628@broadcom.com>
         <1474961105.5141.5.camel@sipsolutions.net>
         <0a8cff88-73aa-8311-7afe-98612161421f@broadcom.com>
         (sfid-20160928_002127_321746_FD82CF46) <1475044682.4139.18.camel@sipsolutions.net>
         (sfid-20160928_083815_252455_876B9E2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Today we already have all the platform rfkill instances (like the
> various ACPI ones) that don't live off a device that they control,
> but instead control the platform's radio functionality. And in some
> cases, that actually has very similar behaviour to what was proposed
> in the previous patch, and what you're looking for, in that it
> sometimes kills power to BT or WiFi chips when soft-disabled (or
> kicks them off the bus in some other way).

Actually, let me retract that a bit. Obviously they *do* control a
device or radio, but we don't actually know which one. And that can
actually become a problem, since we don't even know how they work etc.

So IOW, even with the ACPI stuff, there's no real "platform rfkill"
concept - it's always killing a specific radio.

There used to be some rfkill that was just reflecting the button state,
but I think we got rid of that in favour of reflecting button state
through hid/input, if it doesn't also control a radio.

So, actually, the more I think about it the more I agree with Mark's
objection. It doesn't really make sense to have a concept of an rfkill
and not know what radio it controls.

In your particular case, Jon, it's complicated by the fact that you
don't want to bind a kernel driver with the rfkill, not sure where
you'd get a device to tie the rfkill to then.

johannes
