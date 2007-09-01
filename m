Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:55548 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbXIAJVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:21:04 -0400
Message-ID: <46D92EFC.2060007@warmcat.com>
Date: Sat, 01 Sep 2007 10:21:00 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: radiotap injection bugs & extending it
References: <1188609135.7585.105.camel@johannes.berg>	 <46D92A1C.4050308@warmcat.com> <1188637615.7585.118.camel@johannes.berg>
In-Reply-To: <1188637615.7585.118.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Sat, 2007-09-01 at 10:00 +0100, Andy Green wrote:
> 
>> Yes it's wrong, hdr is also dereferenced once more while the radiotap
>> header is still in place.  I made a little patch I will send in a
>> moment, if you already did it then ignore the patch.
> 
> No, sent the mail just before going to sleep :) I'll review your patch
> and adopt it. Guess I get to rebase my ~70ish patches to after it
> then ;)

Hopefully it's just fuzz...

>>> Also, after doing more work on mac80211 I now again have hostapd running
>>> via monitor interfaces. However, there's a bit of a problem there.
>> You are definitely on fire at the moment Johannes.
> 
> Heh, yeah, got a bit of time on my hands right now.

Opposite for me, having to do paying work at the moment.

> Yeah, I can do that. Not sure about PS mode though. I suppose your use
> case won't suffer if I simply do it unconditionally since you're always
> sending multicast frames anyhow.

Well because our frames aren't targeted at any real MAC I'm not sure the
AP will buffer them for devices in PS or not.  Maybe the client having
an interface up in hardware promisc should be a sign for it to not go
into PS mode anyway?

For sure things will be much better and more consistent if we can inject
down unassociated interfaces reliably, so this is a nice move.

>>> This is basically it, except for short preamble setting. That is a bit
>>> of a problem, however, because it's not a tristate in radiotap and we
>>> want a tristate (long/short/automatic). Ideas on this item?
>> No idea about it here.
> 
> I could propose adding a new radiotap TX flag, I suppose...

I don't know enough about it to have a proper idea, sorry.

-Andy
