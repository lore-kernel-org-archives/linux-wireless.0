Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:38982 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYAYWey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:34:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1321986wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2008 14:34:53 -0800 (PST)
Message-ID: <1ba2fa240801251434m54db8df6o95490bad4fca4214@mail.gmail.com> (sfid-20080125_223458_462164_F6ACB554)
Date: Sat, 26 Jan 2008 00:34:53 +0200
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Linux 2.6.24-rc7
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Inaky Perez-Gonzalez" <inaky@linux.intel.com>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080125214626.GG14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <200801251941.25310.mb@bu3sch.de>
	 <200801251311.45392.inaky@linux.intel.com>
	 <200801252221.07558.mb@bu3sch.de>
	 <20080125214626.GG14687@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 25, 2008 11:46 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Jan 25, 2008 at 10:21:07PM +0100, Michael Buesch wrote:
> > On Friday 25 January 2008 22:11:44 Inaky Perez-Gonzalez wrote:
> > > On Friday 25 January 2008, Michael Buesch wrote:
> > > > On Friday 25 January 2008 19:34:46 Linus Torvalds wrote:
> > > > > My attitude is: CPU's that do unaligned accesses right are the *good*
> > > > > CPU's. We should encourage them, and put the onus of being crap on the
> > > > > ones that are crap, rather than penalizing the ones that aren't.
> > > >
> > > > I absolutely agree. But as this can get fixed with _no_ performance loss
> > > > at all inside of the firmware (and who if not intel can change stuff
> > > > in their firmware?), I think this warning is in fact valid.
> > >
> > > Well, you forgot the point that maybe it is not that simple to get such
> > > a seemingly simple change into the firmware for a long list of reasons.
> >
> > The reasons being?
>
> Firmware certification is expensive.
>
> Plus it is a bit unfair to ask for firmware changes just because the
> vendor is actually engaged with us.  If this were Broadcom or Zydas
> firmware we would have little recourse other than to accept it or
> fix it in the driver or stack.
>
> John
> --
> John W. Linville
> linville@tuxdriver.com
>

Sorry for getting late into this conversation till now I was enjoying
my weekend :)

We are definitely not ignoring this issue. We are discussing this at
Intel and this for sure will be fixed in next generation HW.  For now
we are trying to find some remedy to this problem. The big problem we
have that 11n handling is HW assisted and it's really hard to do
something about it in the FW level for 11n cards. This is not
something that we fix over night if at all. The truth is these cards
never dreamed to be run on other CPUs then Intel so the morning  is
hard :)

I would suggest to go for conditional copying on platforms that cannot
handle unaligned for these platforms  we have to probably disable 11n
though.
Tomas


> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
