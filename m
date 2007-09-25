Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:49079 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbXIYQNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 12:13:25 -0400
Received: by an-out-0708.google.com with SMTP id d31so291469and
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 09:13:25 -0700 (PDT)
Message-ID: <43e72e890709250913x5c137ee3k8d68b4ad755cadfe@mail.gmail.com>
Date: Tue, 25 Sep 2007 12:13:24 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: API to regulatory control (1)
Cc: linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1190727624.18521.310.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
	 <1190624554.18521.261.camel@johannes.berg>
	 <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
	 <1190669783.18521.301.camel@johannes.berg>
	 <43e72e890709241518h1cc694d9of8f8a8d216a7906b@mail.gmail.com>
	 <1190727624.18521.310.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/25/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-24 at 18:18 -0400, Luis R. Rodriguez wrote:
>
> > I saw complaints on the z1211 move thread to upstream about large
> > patches and driver developers not being able to keep up as mac80211 is
> > a 'moving target'.
>
> It'll always be. Everything in Linux is a moving target. That's the pain
> associated with maintaining a driver out of tree. This change in
> particular isn't even hard to follow and I'd happily help change all the
> drivers that are in tree.

OK fine, lets just move forward but I'll take you up on the offer ;)

> > > I don't think I want to call into some cfg80211 call for this, a
> > > specific notifier seems more appropriate.
> >
> > Well what if cfg80211  generates a notification if a possible conflict
> > has been found? Is there a need to generate a notification on power
> > reg changes to the driver besides this?
>
> Well, that'd mean that cfg80211 would need to keep track of the current
> power level. I've intentionally made cfg80211 keep track of as few
> things as possible so that drivers are free to change things when
> necessary without having synchronisation problems. I would prefer if it
> stayed this way.

I wasn't thinking of that, but  instead, of the 'loop' cfg80211 would
do upon regulatory change, on all wiphys.

> Also, just providing the hook is much simpler and we can leave it up to
> drivers to implement this logic.

Hm, the drivers will still call a cfg80211 helper anyway to update its
channel flags/power limits, why not let cfg80211 just do it then in a
loop for all wiphys upon reg change? At the end of the loop for each
wiphy we can call a driver-specific ops->verify_reg().

  Luis
