Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1ATJyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:54:45 -0500
Subject: Re: [RFC 1/4] mac80211: support for IEEE80211N in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110120T103741-140@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
	 <1295447708.4685.5.camel@jlt3.sipsolutions.net>
	 <loom.20110120T093834-982@post.gmane.org>
	 <1295515469.3693.17.camel@jlt3.sipsolutions.net>
	 <loom.20110120T103741-140@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 10:54:43 +0100
Message-ID: <1295517283.3693.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 09:48 +0000, Alexander Simon wrote:

> > Well, then maybe I just discussed this with him -- there's similar code
> > building the HT IEs for stations, that code should be shared.

> So you mean my patch 2/4? It could work but you would have to change util.c of
> course. I was pretty sure you wouldn't have accepted that.

Of course I'd accept that :-) Reducing duplicated code is good, and I
can deal with patches touching many files. Though it'd be nice to do the
necessary refactoring first.

A nice touch, btw, would be if you included a diffstat. Maybe you should
look at using quilt or git to submit patches which help you automate a
lot of things.


> Ok, separating cfg from mac. No big deal. I'll have to look how to advertise
> something...

Look at WIPHY_FLAG_IBSS_RSN in net/wireless and net/mac80211 -- that's
how things can be advertised. Also, for this one of course you have
NL80211_ATTR_SUPPORT_IBSS_RSN.

> But i would appreciate if you could comment on the design of the patch itself.
> Basically i just took Benoits approach and made it running. A separate option
> for setting channel_type isn't necessary. You could also tell by iw whether to
> use HT or not. Or no option at all, a module option ibss_ht etc. Or even setting
> full options as hostapd does via iw.

I'm sorry, I don't understand what you mean by "a separate option"? With
the approach that you've posted patches for you need to tell iw whether
you want HT or not, right?

johannes

