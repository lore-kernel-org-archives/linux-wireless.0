Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab1ATKVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 05:21:01 -0500
Subject: Re: [RFC 1/4] mac80211: support for IEEE80211N in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110120T110320-779@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
	 <1295447708.4685.5.camel@jlt3.sipsolutions.net>
	 <loom.20110120T093834-982@post.gmane.org>
	 <1295515469.3693.17.camel@jlt3.sipsolutions.net>
	 <loom.20110120T103741-140@post.gmane.org>
	 <1295517283.3693.31.camel@jlt3.sipsolutions.net>
	 <loom.20110120T110320-779@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 11:20:59 +0100
Message-ID: <1295518859.3693.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 10:15 +0000, Alexander Simon wrote:
> > Of course I'd accept that  Reducing duplicated code is good, and I
> > can deal with patches touching many files. Though it'd be nice to do the
> > necessary refactoring first.

> Ok give me some time and I'll have a look at util.c.

Thanks.

> > A nice touch, btw, would be if you included a diffstat. Maybe you should
> > look at using quilt or git to submit patches which help you automate a
> > lot of things.

> Actually I don't like git, but when this is getting something bigger,I'll agree
> to use it :)

I personally rarely use it for the kernel (even if I know how to very
well), mostly because rebasing is slow for me ... quilt helps a lot too.
If you intend to submit more patches than this series I suggest you
learn at least one of them, it'll make your life easier :-)

> > I'm sorry, I don't understand what you mean by "a separate option"? With
> > the approach that you've posted patches for you need to tell iw whether
> > you want HT or not, right?

> What i mean is, right now there's just one option - setting the HT channel.
> There could be less (the card automatically enables HT and uses it for a station
> that advertises HT), or even more (as in hostapd.confs HT section). Or there
> could be a module option to switch ht for ibss on or off. So, i'm asking about
> the "ideal" interface...

Hmm, I guess you have a point there -- restricting it to HT40- doesn't
make much sense since then you can't merge with another IBSS that is
using HT40+. I guess just enable/disable HT makes more sense?

johannes

