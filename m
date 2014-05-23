Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47435 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaEWIvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:51:21 -0400
Message-ID: <1400835067.4358.5.camel@jlt4.sipsolutions.net> (sfid-20140523_105125_878648_3373092A)
Subject: Re: [PATCH v6 1/6] mac80211: introduce switch_vif_chanctx op
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Fri, 23 May 2014 10:51:07 +0200
In-Reply-To: <CA+BoTQmVHFCMcx02RN2+J7zcGZbWyypDcNQgGiBSXxyuc_iDYQ@mail.gmail.com> (sfid-20140523_080905_770151_C5E19419)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-2-git-send-email-michal.kazior@tieto.com>
	 <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmVHFCMcx02RN2+J7zcGZbWyypDcNQgGiBSXxyuc_iDYQ@mail.gmail.com>
	 (sfid-20140523_080905_770151_C5E19419)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 08:09 +0200, Michal Kazior wrote:

> >> +#define IEEE80211_MAX_NUM_SWITCH_VIFS 8
> >
> > :-)
> >
> > That seems artificial though - why not dynamically allocate?
> 
> I tend to avoid dynamic allocations whenever I can. I can make it
> dynamic if you want.

I'm just thinking that Ben Greear will invariably complain about this
limit ;-)

> I think I've had the same problem when I was trying to make a
> single-call multi-vif csa tracing. Is using dynamic_array for this
> really doable? I haven't found any code in the kernel using
> __dynamic_array for anything but simple scalars and buffers.

You could either use multiple arrays, or I guess you could even pack a
struct into the array, no?

> >> +     if (WARN_ON(!use_chanctx && ops->switch_vif_chanctx))
> >> +             return NULL;
> >
> > I don't think this makes sense - we perfectly handle the case right now
> > by disconnecting (and not advertising switch to userspace, I guess? if
> > not we should)
> >
> > Requiring drivers to implement this just makes things more difficult,
> > and the channel switch isn't really mandatory spec-wise.
> 
> This is supposed to prevent non-chanctx drivers from accidentally
> implementing switch_vif_chanctx. It doesn't require chanctx drivers to
> implement switch_vif_chanctx.

Err, yeah, I misread the code - sorry.

> >> +             __field(u32, old_control_freq)
> >
> > I believe there's a macro for a chandef?
> 
> Yes there is, but it assumes you have a `control_freq`. Since there
> are old_ and new_ prefixes in my tracing I can't really use that
> define, can I? I'd have to modify the define (and all callsites) to
> take an argument with a prefix and concatenate symbols with ##.

Oh, you're right, somehow I thought we'd done something like that
already.

Probably not worth it then.

johannes

