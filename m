Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60453 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829AbaGCVog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 17:44:36 -0400
Received: by mail-pd0-f182.google.com with SMTP id y13so861022pdi.13
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 14:44:35 -0700 (PDT)
Date: Thu, 3 Jul 2014 14:44:31 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory
 settings
Message-ID: <20140703214431.GR1390@garbanzo.do-not-panic.com> (sfid-20140703_234441_206166_6D0106B2)
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-2-git-send-email-arik@wizery.com>
 <CAB=NE6Wburfgomm81BL-MPsqZSSCSMNyim29OWw3Twj8q2AOUQ@mail.gmail.com>
 <CA+XVXff1SLHvP3PABdV1U2xw8CQW660xJR1QMUkW0QaaEpThYQ@mail.gmail.com>
 <20140630220316.GL1390@garbanzo.do-not-panic.com>
 <CA+XVXfcteEgTJ-QQ9q4KuqbPoygKCpccjwR2EdqX-aSHScRo4g@mail.gmail.com>
 <20140702022351.GQ1390@garbanzo.do-not-panic.com>
 <CA+XVXfepwWA_GqU=XpF1DW95xgQjabCkbRnUtq97c+9Nn+teWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfepwWA_GqU=XpF1DW95xgQjabCkbRnUtq97c+9Nn+teWQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 03, 2014 at 01:04:23PM +0300, Arik Nemtsov wrote:
> On Wed, Jul 2, 2014 at 5:23 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Tue, Jul 01, 2014 at 04:07:03PM +0300, Arik Nemtsov wrote:
> >> On Tue, Jul 1, 2014 at 1:03 AM, Luis R. Rodriguez
> >> <mcgrof@do-not-panic.com> wrote:
> >> >> This feature is also primarily designed for systems which are not
> >> >> extensible, so you can't really add another device.
> >> >> I guess we'll have to solve this when the need arises.
> >> >
> >> > The patch in question does not address denying wiphy registration
> >> > if two drivers have get_regd() implemented, that's essentially what
> >> > this *should* be trying to do but:
> >> >
> >> > 1) Its not documented above
> >> > 2) The limitation of the patch in no way is part of matching the
> >> >    requirement you mention. That is, the requirement to have Intel's
> >> >    driver as "dictator" has nothing to do with allowing or not
> >> >    multiple similar drivers that can help with compliance by providing
> >> >    their own regulatory dynamically.
> >> > 3) You are putting the requirement of implmenting support for
> >> >    multiple drivers with get_regd() on the next user of get_regd()
> >> >    which wants to integrate support for an intel card with theirs,
> >> >    that's unfair and far sighted for an implementation.
> >> >
> >> > The requirement you have has nothing to do with the limitation
> >> > you have so this patch is unacceptable. I also provided recommendations
> >> > on how you can lift this limitation, so it shouldn't be hard.
> >>
> >> I already prevent the registration of a second "get_regd" callback. I
> >> just re-read your previous email and I'm not sure what's the
> >> recommendation here. The 2-card scenario where one of the cards
> >> doesn't use "get_regd" should be fine - it will just use the
> >> regulatory settings from the "get_regd" one. Only the
> >> 2-cards-using-"get_regd" scenario is not supported, and AFAICT it
> >> doesn't exist in practice, and also requires complicated treatment
> >> (perhaps the two "dictators" differ in their definition of the
> >> regdomains?)
> >
> > The recommendation is to add support for more than one driver
> > that has the get_regd() callback, if your driver does not want
> > to allow others to register more than 1 driver on a system with
> > the reg_regd() callback add a flag and then the blame will be
> > put on you to justify this. Then customers who buy your products
> > won't use your devices in undesired combinations and I expect
> > tons of bug reports might end up being filed if another vendor
> > ends up going down the get_regd() path.
> 
> Not sure I'm getting you. You're suggesting a new regulatory flag that
> ensures a single get_regd registration, and fails others?

Yeah a wiphy flag that would inform regulatory code that this is the
interpretation a vendor has.

> So that even if someone extends get_regd() to multiple devices, we'll
> always remain the single one?

Right, if the flag can be used to update a refcount, if the refcount
for this flag is > 0 then that means at least one driver is present
already that uses get_regd() and it would disallow more any other
wiphys to register if it also had get_regd(). That would let you do
what you want -- but it means you still have to add the code to support
the cases that do not have this restriction to let vendors who don't
have such nutty requirements to exist and so that they can sell their
products with other vendors and integration with partners on systems
that would need multiple vendors with drivers that have get_regd().

> I'm ok with this.

Ok.

  Luis
