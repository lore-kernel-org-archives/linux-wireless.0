Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0G0Ih1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 04:37:27 -0400
Subject: Re: [WIP] mac80211: AMPDU rx reorder timeout timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201007270820.25347.chunkeey@googlemail.com>
References: <201007270820.25347.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 10:37:25 +0200
Message-ID: <1280219845.19098.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-27 at 08:20 +0200, Christian Lamparter wrote:
> This (rather _unfinished_ :-D ) patch adds a timer which
> if trigger schedules the automatic release of all expired
> A-MPDU frames. This implementation has the advantage that
> all queued-up MPDU will now arrive in the network core
> within a timely manner.
> 
> In my "experiments", the patch helped to ironed out the
> sudden throughput drops that have been _killing_ my
> average tcp performance ever since I can remember.

But why is your BA session so damaged to start with? This is not a
normal situtation!

> But there is a catch: The logs will quickly fill up with:
> "release an RX reorder frame due to timeout on earlier frames".
> and the package loss will goes through the roof...
> 
> Now, I can think of several reasons why this could happen:
> 	1. we don't wait long enough for the HT peer to
> 		finish their _retry_ procedure?
> 
> 	2. previously - when the stream simply _stopped_ - we had
> 		to wait until the tcp retry kick in again. So we had
> 		some "silent" periods and therefore less noise from
> 		the reordering code?
> 
> 	3. ->bugs<- but where are they?

I'm having a hard time understanding this patch, can you split out the
no-op code reorg parts or explain what it does?

johannes

