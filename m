Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20588 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbZAPVHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:07:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 13:07:24 -0800
Date: Fri, 16 Jan 2009 13:06:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
Message-ID: <20090116210655.GK29609@tesla> (sfid-20090116_220729_241466_FDBA49F1)
References: <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232064746-17134-5-git-send-email-lrodriguez@atheros.com> <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232064746-17134-9-git-send-email-lrodriguez@atheros.com> <1232097921.3854.28.camel@johannes> <20090116163100.GE29609@tesla> <1232138062.3745.6.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232138062.3745.6.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 12:34:22PM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 08:31 -0800, Luis R. Rodriguez wrote:
> > On Fri, Jan 16, 2009 at 01:25:21AM -0800, Johannes Berg wrote:
> > > On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > > > When a driver issues a regulatory_hint() lets save the received
> > > > values as original channel settings. This allows users to change
> > > > regulatory domains multiple times while always respecting the driver's
> > > > own regulatory setings.
> > > 
> > > This definitely isn't the right way to do things here. This means that
> > > my card that's programmed to US can never do channel 13 here, something
> > > which on b43 we definitely want to allow.
> > 
> > Ah -- are you sure you want to allow for that? 
> 
> Yes.
> 
> > It seems I was misunderstanding a bit
> > how things would be done for 11d in ath9k and the fact is that we *don't* allow
> > for channels beyond what the programmed regulatory domain allows. This is because
> > calibration stuff has only been tested/ensured/certified/call-it-what you want
> > for the channels in that regulatory domain SKU. 
> 
> Yes, I know why you want this, but I think you should do it slightly
> differently.
> 
> > Are you certain that b43 can operate
> > well on channels not in their regulatory domain SKU? If so then how about a wiphy flag
> > to let drivers pick this.
> 
> I don't see a need for a flag. 

Well in ath9k we want this, and orig_* stuff is used only for custom
regulatory domains. How would we install information on orig_* from
a regulatory_hint() on drivers if we have drivres which may or may not
want to save that information on orig_* parameters?

> We just need to have the driver set
> orig_flags rather than cfg80211, no?

Oh you mean in the reg_notifier() on REGDOM_SET_BY_DRIVER? Sure, that works
as well, if so desired.

  Luis
