Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26985 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbZARP3Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 10:29:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 07:29:16 -0800
Date: Sun, 18 Jan 2009 07:28:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
Message-ID: <20090118152844.GR29609@tesla> (sfid-20090118_162925_499235_CEE9DA18)
References: <1232064746-17134-5-git-send-email-lrodriguez@atheros.com> <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232064746-17134-9-git-send-email-lrodriguez@atheros.com> <1232097921.3854.28.camel@johannes> <20090116163100.GE29609@tesla> <1232138062.3745.6.camel@johannes> <20090116210655.GK29609@tesla> <1232268449.3877.8.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232268449.3877.8.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 12:47:29AM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 13:06 -0800, Luis R. Rodriguez wrote:
> 
> > Well in ath9k we want this, and orig_* stuff is used only for custom
> > regulatory domains. How would we install information on orig_* from
> > a regulatory_hint() on drivers if we have drivres which may or may not
> > want to save that information on orig_* parameters?
> 
> Not sure.

The answer was above, but lets see.

> > > We just need to have the driver set
> > > orig_flags rather than cfg80211, no?
> > 
> > Oh you mean in the reg_notifier() on REGDOM_SET_BY_DRIVER? Sure, that works
> > as well, if so desired.
> 
> Well, I wasn't intending for anything to _ever_ touch orig_flags at
> all... 

Just so you know the approach I started taking for v3 of this series
was to apply save the orig_* parameters if REGDOM_SET_BY_DRIVER and
the request->wiphy == wiphy. This works OK except if you have "US"
as your regulatory domain and you have OLD_REG set cfg80211 will have
already have called for a new regulatory domain update for "US" so
this is -EALREADY. Some changes are then required to inform drivers
through the reg_notifier() of this. This is where I was at now.

> I think you're hampered by not being able to simply request a
> regdomain from crda outside the normal "apply regdomain" flow, 

Well I have a few approaches already which have worked but I like to 
think we're looking for the most simple solution so its easier to
support this for other drivers as well.

> maybe we
> should think about that instead? Then ath9k could just request a
> regdomain from crda before it even registers its wiphy?

Are you suggesting we consider new API for drivers which want the
behaviour we want? That works for me too, but then again I'd be applying
the save orig_* stuff perhaps at the end of this new, say,
regulatory_hint_strict().

  Luis
