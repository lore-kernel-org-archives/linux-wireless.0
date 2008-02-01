Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:49775 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbYBAV2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 16:28:45 -0500
Received: by wa-out-1112.google.com with SMTP id v27so912892wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 13:28:44 -0800 (PST)
Message-ID: <43e72e890802011328l2b5d56eel1f301f7726b0a365@mail.gmail.com> (sfid-20080201_212851_849042_36069C52)
Date: Fri, 1 Feb 2008 16:28:44 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: bruno@thinktube.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	linville@tuxdriver.com, "Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <1201879259.4188.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
	 <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
	 <1201879259.4188.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/1 Johannes Berg <johannes@sipsolutions.net>:
>
> > > I guess you could add a helper function that allocates a channels array
> > > based on a frequency range.
> >
> > This is true but also it would be nice as it is the end points which
> > drivers may want
> > to access every now and then. I think its worth the few bytes.
>
> I'm not really worried about the space that needs, but I don't see why
> the wiphy would need that information.

Export capabilities to userspace would be the main reason. The bands
can be iterated but why do iteration when we can just set the upper
and lower limits?

> Couldn't you keep it in your
> driver's per-hw structure as it is?

Sure, we could. But it seems it would be nice to have this information
easily accessible to drivers and to userspace API.

> Would cfg80211 be required to keep
> them updated according to regulatory rules when the allowed channels
> change?

Nope, I'm just thinking in terms of "hw support capabilities".

> I'm much more worried about all the code that would result in :)

Yeah, I'm not thinking of it in terms of regulatory now. Just in terms
of reasonable capability value accessible to drivers and to userspace.

> But since you're not doing that right now anyway I'll just wait and see
> what you come up with ;)

Hey man, its tough when you have 2 laptops poop out on you in less
than 2 months... this is my excuse this month. Its a new months so I
get one.

  Luis
