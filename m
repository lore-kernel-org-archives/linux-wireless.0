Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34011 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdAFTUc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 14:20:32 -0500
Received: by mail-lf0-f68.google.com with SMTP id q89so660103lfi.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 11:20:31 -0800 (PST)
Date: Fri, 6 Jan 2017 20:20:27 +0100
From: =?utf-8?B?TWljaGHFgiBLxJlwaWXFhA==?= <kernel@kempniu.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?0JzQuNGF0LDQuNC7INCa0YDQuNC90LrQuNC9?=
        <krinkin.m.u@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] rfkill: Add rfkill-any LED trigger
Message-ID: <20170106192027.GA756@kmp-mobile.hq.kempniu.pl> (sfid-20170106_202037_128607_AED24D4A)
References: <20170106060747.6162-1-kernel@kempniu.pl>
 <1483705333.4089.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1483705333.4089.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, 2017-01-06 at 07:07 +0100, Michał Kępień wrote:
> > Add a new "global" (i.e. not per-rfkill device) LED trigger, rfkill-
> > any,
> > which may be useful on laptops with a single "radio LED" and multiple
> > radio transmitters.  The trigger is meant to turn a LED on whenever
> > there is at least one radio transmitter active and turn it off
> > otherwise.
> > 
> > Signed-off-by: Michał Kępień <kernel@kempniu.pl>
> > ---
> > Changes from v3:
> > 
> >   - Revert introducing a new bitfield and instead defer LED event
> > firing
> >     to a work queue to prevent conditional locking and ensure the
> >     trigger can really be used from any context.  This also voids the
> >     need to take rfkill_global_mutex before calling
> > rfkill_set_block()
> >     in rfkill_resume().
> 
> Looks better, but
> 
> > +static struct work_struct rfkill_any_work;
> 
> At least on module exit you need to cancel this work.

It is cancelled in rfkill_any_led_trigger_unregister().  It seemed
fitting to do it this way as rfkill_any_work is initialized in
rfkill_any_led_trigger_register().  And if CONFIG_RFKILL_LEDS=n,
rfkill_any_work is neither initialized nor scheduled, so we should be
good as well.  Am I missing something?

-- 
Best regards,
Michał Kępień
