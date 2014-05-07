Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaEGLuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:50:17 -0400
Message-ID: <1399463403.10517.24.camel@jlt4.sipsolutions.net> (sfid-20140507_135022_450001_6BBDB3E5)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 13:50:03 +0200
In-Reply-To: <CA+BoTQ=uNCVZcacg32nTp2i7gu2RcZQbbe4nw5_sCBANHHTY0A@mail.gmail.com> (sfid-20140507_134302_986939_8FBBE0E6)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	 <1399387345.4218.44.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	 <1399449912.5038.7.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
	 <1399453631.10517.10.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmygnk161oi=AUwfFM4U-r8TxuJVcHPMbsOG+QCzB03hQ@mail.gmail.com>
	 <1399461426.10517.16.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=uNCVZcacg32nTp2i7gu2RcZQbbe4nw5_sCBANHHTY0A@mail.gmail.com>
	 (sfid-20140507_134302_986939_8FBBE0E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 13:43 +0200, Michal Kazior wrote:

> We can't really guarantee how long we'll need to stop beaconing for.
> 
> Assume: AP+STA. Start AP CSA bcn_int=100ms, cs_count=5. While CSA
> progresses STA receives cs_count=100 (with bcn_int=100ms).
> 
> This is all theory and in practice you won't get cs_count that big and
> the lag greater shouldn't be greater than 5 or 6 beacon intervals. Is
> that an "extended" period of time? I don't know. Should we even worry
> about this? I don't think so.

I'm not sure why we'd even allow this to start with though. We should be
able to sync it to 1 beacon interval, it seems? Particularly if we start
the switches together.

> > Multi-BSS I totally see, but if you're trying to do that with different
> > beacon intervals you're probably in a world of pain already - not sure
> > we should support that to start with...
> 
> You still can have different TBTTs across your AP vifs. ath10k does
> this, although it should be possible to force it to beacon in bursts.

True, but then you'd still technically have a single point where the
switch can happen, without missing a beat (beacon)

> > AP/GO-follows-STA I can also see, due to regulatory and concurrent
> > BSS/P2P usage.
> >
> > As for those other cases, are they really relevant?
> 
> I think I lost track of the point of the discussion at some point :-)
> Weren't we discussing csa_active?

:)

johannes

