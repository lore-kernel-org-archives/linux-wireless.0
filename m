Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38132 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbbBXKL5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:11:57 -0500
Message-ID: <1424772714.2192.16.camel@sipsolutions.net> (sfid-20150224_111201_937551_8C3B71CC)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 11:11:54 +0100
In-Reply-To: <54EB66CC.1030800@candelatech.com>
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>
	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>
	 <54EB66CC.1030800@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-23 at 09:43 -0800, Ben Greear wrote:

> > This seems a bit strange - don't we already tag packets with the
> > frequency? Why would you need the channel change separately? What does
> > that even mean? Depending on how you use this it could entirely break
> > off-channel operation, for example.
> 
> I was thinking about passive scans.  In that case, we would not always get a packet transmitted
> when the channel changes?

Ah, well, ok. However, hwsim doesn't actually really have a concept of
the 'current channel', for example in the offchannel code it just
temporarily listens on two channels ... so that's not very good for a
more realistic implementation :)

> I was thinking user-space would mimic a real radio that can only listen on
> one channel at once (can any real radios actually listen on two channels at once?)

No, real radios cannot do that (not really anyway - I guess if it was
VHT80 it's really already listening on 4 channels but ...)

> So, if we are off-channel, and pkt arrives for the 'main' channel, then
> a real radio should drop it, right?

Yes.

> Of course, if user-space does not care, then it can simply ignore the channel-change
> logic so I think this would be backwards compat with existing hwsim user-space apps.

Sure. But given the murky concept of channel change, and not going to PS
for off-channel in hwsim etc. I think this would need a bit more design
rather than just exposing the mac80211 channel change. Additionally,
with chanctx support that won't even be invoked for example.

johannes

