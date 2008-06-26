Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28661 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYFZC2z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 22:28:55 -0400
Subject: Re: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
From: Pavel Roskin <proski@gnu.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240806251526k773e8e2bj2c198defd0d8ef@mail.gmail.com>
References: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
	 <1214409527.5881.21.camel@dv> <1214410337.21847.33.camel@johannes.berg>
	 <1ba2fa240806251526k773e8e2bj2c198defd0d8ef@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 22:28:53 -0400
Message-Id: <1214447333.18897.13.camel@dv> (sfid-20080626_042900_287696_900BD47B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 01:26 +0300, Tomas Winkler wrote:
> On Wed, Jun 25, 2008 at 7:12 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-06-25 at 11:58 -0400, Pavel Roskin wrote:
> >
> >> > +                   unsigned long mid_range = (-1) / 2 + 1;
> >>
> >> What is that?  I guess that's where Riemann's zeta function has its
> >> non-trivial roots :-)
> 
> >
> > The Pavel hypothesis: "The Riemann hypothesis is correct when calculated
> > in 32-bit integers" is obviously wrong ;)
> >
> Welcome to the Desert of the Real

Welcome to C.  mid_range is 1, as you can easily check.

> >> > +                   time_diff = jiffies - bss->last_update > mid_range ?
> >> > +                           jiffies - bss->last_update :
> >> > +                           bss->last_update - jiffies;
> >>
> >> That's pretty hairy.  Do we really lack a function to calculate time
> >> difference?
> 
> This is simplest as you can get under assumption that times are not
> apart more then 1/2 of UL.
>  It would be overkill to translate it to timeval or anything we have
> diff function for.

Why would jiffies ever lag behind bss->last_update?  When would
(bss->last_update - jiffies) make sense?  If it makes sense, how about
indicating it somehow?  It would be a value that decreases over time.  

> > Actually, come to think of it, isn't just doing the difference as in teh
> > original patch correct in 32-bit unsigned integers? It'll wrap around a
> > bit but that's ok, no?
> 
> It would make a very recent beacon to be like half an hour old on
> wraps, wouldn't it?

No.  Why would it?  Can you give an example?  If you are not increasing
precision, wraparounds should make no difference.

-- 
Regards,
Pavel Roskin
