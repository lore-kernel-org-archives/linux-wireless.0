Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1AZWIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 17:08:39 -0500
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <AANLkTikno8Aa3wKy1js62D3FLOZJUxPyuwYsQd+g8JBM@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-3-git-send-email-arik@wizery.com>
	 <1296077594.3635.40.camel@jlt3.sipsolutions.net>
	 <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
	 <1296078857.3635.41.camel@jlt3.sipsolutions.net>
	 <AANLkTikno8Aa3wKy1js62D3FLOZJUxPyuwYsQd+g8JBM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 23:08:39 +0100
Message-ID: <1296079719.3635.47.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 00:02 +0200, Arik Nemtsov wrote:

> >> 2. The STA transmits something
> >> 3. The AP FW deauths the STA
> >> 4. hostapd adds the station, causing mac80211 to call add_sta(), which
> >> causes the FW to add the sta
> >>
> >> Then we have an endless loop of sta add/remove..
> >
> > I'd wondered about that race condition before -- maybe hostapd should
> > add the station before sending the assoc complete. The race also exists
> > in practice with just mac80211, except it only leads to a dropped frame.
> 
> Well it can still get dropped here. This just prevents the FW from
> de-authenticating the STA.

No I mean the incoming frame would be dropped:

 - sta sends assoc
 - hostapd sends response
 - when assoc response ACK is received, hostapd sets state to assoc
 - incoming frame
 - hostapd adds STA to mac80211

then in this case mac80211 will pass the incoming frame up to hostapd,
and not to the network stack, but hostapd knows that it's a good frame
and won't kick out the station

The only difference is that with your firmware the kicking out is done
by the firmware, not hostapd, so it actually gets kicked out rather than
the frame being dropped.

So ... the race exists even without the firmware, it just has less
severe consequences.

If we add the station before the response frame's ACK is received, we
still have the race, and we need to delete if we don't get the ACK. If
we add the station before we send the assoc response we get rid of this
race, but also have to delete if we don't get the ACK. I guess that case
is actually nicer in some way since we would have allowed the station to
connect, so if spurious data frames go up because we don't get an ACK
from the station that's no big deal?

johannes

