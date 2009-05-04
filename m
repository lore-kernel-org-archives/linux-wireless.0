Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:41175 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZEDSyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:54:10 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
Date: Mon, 4 May 2009 20:53:18 +0200
Cc: Richard Farina <sidhayn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1241452330.8683.49.camel@johannes.local> <49FF2FE8.8010004@gmail.com> <20090504181357.GA19022@tuxdriver.com>
In-Reply-To: <20090504181357.GA19022@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200905042053.19091.rossi.f@inwind.it>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 May 2009, John W. Linville wrote:

> On Mon, May 04, 2009 at 02:11:52PM -0400, Richard Farina wrote:
> > Johannes Berg wrote:
> >> Umm, if _you_ set channel 11 then you _will_ see channel 11. It's just
> >> that when it's scanning and happens to be on channel 132 instead of 11,
> >> while you previously set 11, you will _after_ this patch see 11, not
> >> 132.
> >
> > Yes, and at what point does it seem like a good idea to hide the channel
> > the wifi card is on?  If I set channel 11 and it is scanning instead of
> > locked on channel 11 then I should see the current channel the hardware
> > is on.  This seems like an aweful idea to me, granted, it may help a few
> > people that don't understand how scanning works, but hiding the truth is
> > never a good idea. NACK.
>
> I can see what you mean, but I think showing seemingly random
> fluctuations in channel assignments is at best distracting.  Don't you
> agree that most people are more interested in seeing the configuration
> state than the transient state of the hardware?

I want to report my experience. There was a bug in the ath5k driver with a 
hanging result during scanning mode. I was able to discover the problem 
thanks to the iwconfig output.

In alternative, is it possible to add a status flag so that iwconfig from user 
space can report scanning mode is operative?

Fabio
