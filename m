Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54425 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab2GFQbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 12:31:20 -0400
Received: by pbbrp8 with SMTP id rp8so14847214pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 09:31:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341591350.16893.13.camel@jlt3.sipsolutions.net>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
 <1341394944.4482.9.camel@jlt3.sipsolutions.net> <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net> <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
 <1341556785.4462.0.camel@jlt3.sipsolutions.net> <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
 <1341583919.16893.3.camel@jlt3.sipsolutions.net> <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com>
 <1341589880.16893.11.camel@jlt3.sipsolutions.net> <CAB=NE6XaRZa4HKg25gd5zkWn=LrjcAXq4NMPVcFWn+PdtVwRdw@mail.gmail.com>
 <1341591350.16893.13.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 6 Jul 2012 09:31:00 -0700
Message-ID: <CAB=NE6UDfeN6oj83o4rO6EUJeLnrop82WQswu1O2z=gSbVrcAw@mail.gmail.com> (sfid-20120706_183124_228292_8F0D068B)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 6, 2012 at 9:15 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-06 at 09:07 -0700, Luis R. Rodriguez wrote:
>
>> > What I really wanted to know though is this: If the core code is
>> > enabled, what effect does receiving a "blessed" hint have on devices
>> > that don't set the flag? If there's no effect vs. an "unblessed" hint,
>> > then I think we don't need another option?
>>
>> Ah, OK so yes, as it is right now if the core accepts the hint but
>> devices do not listen to it we do have an effect right now which I
>> alluded to in my cover letter: country IE hints won't be listened to
>> after a base station hint gets accepted. Whether or not we want to
>> process country IE hints *after* a cell base station hint gets
>> accepted is debatable -- I decided that its easier to implement to
>> ignore country IE hints after a cell base station hint and I also
>> decided cell base station hints are likely something you'd prefer to
>> review over country IE hints. We can certainly change this and I'm
>> open to it.
>>
>> So yes, as it is right now if you enable onus but your device does not
>> support he feature you may detect a regression: country IE hints would
>> not be processed if you did receive a base station hint that the core
>> processed.
>
> It seems this might be a problem, in the case that I mentioned before:
> you do take all the necessary steps to enable this, but then somebody
> plugs in a USB device (say this is a tablet-like device?)

Agreed however see below.

> It seems it would be better to make the base station/country IE hint
> also depend on the feature flag?

Agreed, at first I figured this'd be complex to figure out dynamically
but it does not have to be: upon wiphy registration we could detect if
a device has the feature enabled and peg core_base_hint_enabled++ or
whatever and then allow them through. Upon deregistration we'd
core_base_hint_enabled-- and only enable the feature if its > 0.

Seems doable.

  Luis
