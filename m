Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:55387 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZEaWse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 18:48:34 -0400
Received: by fxm12 with SMTP id 12so5460071fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 15:48:34 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Bob Copeland <me@bobcopeland.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905311524m6bab2648qb778dd9952da8537@mail.gmail.com>
References: <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
	 <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
	 <1242742647.23110.10.camel@ibm172> <1242951611.5206.9.camel@maxim-laptop>
	 <43e72e890905211736i3dfaf7d5q78d511eac0fbca1e@mail.gmail.com>
	 <1242986902.5544.8.camel@maxim-laptop>
	 <20090531062217.GB23972@bombadil.infradead.org>
	 <1243774031.5741.5.camel@maxim-laptop>
	 <1243803253.5417.12.camel@maxim-laptop>
	 <43e72e890905311524m6bab2648qb778dd9952da8537@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 01:48:30 +0300
Message-Id: <1243810110.5298.5.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-31 at 15:24 -0700, Luis R. Rodriguez wrote:
> On Sun, May 31, 2009 at 1:54 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Sun, 2009-05-31 at 15:47 +0300, Maxim Levitsky wrote:
> >> On Sun, 2009-05-31 at 02:22 -0400, Luis R. Rodriguez wrote:
> >> > On Fri, May 22, 2009 at 01:08:22PM +0300, Maxim Levitsky wrote:
> >> > > I am talking about
> >> > >
> >> > > BUG_ON(!country_ie_regdomain);
> >> > > in net/wireless/reg.c
> >> >
> >> > Please try this patch and leave a window open with this running:
> >> >
> >> > iw event
> >> >
> >> > Please be sure to grab iw from git, not sure if the reg events
> >> > have all gone into an official release yet. What I'm looking for
> >> > is whether or not a previous 11d setting was already processed
> >> > or if the !country_ie_regdomain condition happens from the first
> >> > 11d processing.
> >> >
> >> >   Luis
> >> >
> >> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> >> > index f87ac1d..1b60dfc 100644
> >> > --- a/net/wireless/reg.c
> >> > +++ b/net/wireless/reg.c
> >> > @@ -2171,7 +2171,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
> >> >      * the country IE rd with what CRDA believes that country should have
> >> >      */
> >> >
> >> > -   BUG_ON(!country_ie_regdomain);
> >> > +   if (WARN_ON(!country_ie_regdomain)) {
> >> > +           kfree(rd);
> >> > +           rd = NULL;
> >> > +           return -EINVAL;
> >> > +   }
> >> >     BUG_ON(rd == country_ie_regdomain);
> >> >
> >> >     /*
> >> > @@ -2268,6 +2272,8 @@ int regulatory_init(void)
> >> >     if (IS_ERR(reg_pdev))
> >> >             return PTR_ERR(reg_pdev);
> >> >
> >> > +   country_ie_regdomain = NULL;
> >> > +
> >> >     spin_lock_init(&reg_requests_lock);
> >> >     spin_lock_init(&reg_pending_beacons_lock);
> >> >
> >>
> >>
> >> I'll test this today.
> >> I have iw from git.
> >>
> >> Best regards,
> >>       Maxim Levitsky
> >>
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > Here it is:
> >
> >
> >> wlan0 (phy #0): assoc 00:1b:9e:d8:77:02 -> 00:1b:77:f1:7c:29 status: 0: Successful
> >> wlan0 (phy #0): disassoc 00:1b:77:f1:7c:29 -> 00:1b:9e:d8:77:02 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
> >> wlan0 (phy #0): scan finished
> >> wlan0 (phy #0): auth 00:23:4d:3c:80:27 -> 00:1b:77:f1:7c:29 status: 0: Successful
> >> wlan0 (phy #0): assoc 00:23:4d:3c:80:27 -> 00:1b:77:f1:7c:29 status: 0: Successful
> >> phy #0: regulatory domain change: intersection used due to a request made by a country IE on phy0
> >>
> > dmesg attached (I use nvidia drivers)
> 
> I see only one userspace request *attempt* sent for the country IE in
> your log ("Calling CRDA" bits). So my assumption that we were only
> "trying" to send to userspace one request for the given country IE as
> far as cfg80211 is concerned is accurate however it does not seem
> accurate that the kernel won't send two requests or that userspace
> will not respond twice.
> 
> > On top of that there are few more very bold bugs in ath5k AP mode:
> 
> Your best bet is to report these separately.
I did report some, I will report the reset, this is just a remainder,
cause today I had really bad time with ath5k. I was trying to compile
kernel on aspire one using distcc.

Thanks a lot for fixing the crda bug. I guess there is no need to test
it, I already had that test removed, and everything did work fine.



Best regards,
	Maxim Levitsky

