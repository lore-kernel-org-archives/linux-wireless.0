Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0DVIuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 04:50:18 -0400
Subject: Re: mac80211 and asymmetric 802.11n TX/RX
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6D966E94-4FD1-4675-B39B-296B4D82D2AB@cs.washington.edu>
References: <48BAD814-F653-4CE3-85E0-A9D82EC31D53@cs.washington.edu>
	 <1271751747.8954.3.camel@jlt3.sipsolutions.net>
	 <6D966E94-4FD1-4675-B39B-296B4D82D2AB@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 10:50:10 +0200
Message-ID: <1271926210.3605.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan,

> > I'm not sure. Reading 7.3.2.56.4 seems to imply that, but I'm not sure
> > about the "Rx Highest Supported Data Rate" field. Seems like maybe you
> > could set the "RX MCS bitmask" to more than is supported, limit it by
> > the highest supported data rate, and then use the bitmask for TX?
> 
> First, did you mean 7.3.2.57.4? (I'm using IEEE P802.11n/D7.0, but I
> assume the section numbers haven't changed). For me that section
> represents the "Supported MCS Set field".

I guess they did change then :)

> (An aside: I don't actually *have* 7.3.2.56. I'm using IEEE
> 802.11-2007 [has up to 7.3.2.35] and IEEE P802.11n/D7.0 [has 7.3.2.57
> and beyond] --- In which document are the missing sections?)

I am looking at 802.11n final.

> Can you point me at which text in the section you think implies this
> requirement?

It has a lot of tables .. not easily copied.

> In any case, maybe this discussion is silly: I don't know of any
> devices with this strange configuration. Typically clients assume
> downlink-heavy and might support a 1x2 connection but 2x1, i.e.
> designed for uplink, seems unlikely.

And APs would typically be symmetric, countering Gabor's argument :)

But I don't really understand the standard text here, we'll have to find
somebody more familiar with 11n details.

> >> A second question: my understanding is that if I am a 2x2 node and I
> >> associate to a 3x3 AP, the same code will mask out the fact that the
> >> AP can receive 3 streams since I can't transmit 3 streams. Is there a
> >> way to access this info from the driver if I want it?
> > 
> > Unfortunately not, at this point. We could keep track of it, what would
> > you need it for?
> 
> Okay, that's what I figured; I can hack around it locally. I'm working
> on an alternative rate selection algorithm that at one point tries to
> take into account how much receive diversity the other endpoint has.
> The intuition is that how well (e.g.) 2-stream rates work is going to
> depend not just on the channel, but also on how many excess antennas
> the receiver has. I would benefit from knowing whether they have 2 or
> 3 antennas even if I can only send them at most 2 streams.

Ah. That makes some sense. So far nothing has needed it, but it _could_
also be useful for debugging, so I wouldn't necessarily mind tracking it
in mac80211.

johannes

