Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2DIS7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 14:59:42 -0400
Message-ID: <1333997979.3432.14.camel@jlt3.sipsolutions.net> (sfid-20120409_205945_731711_A0F00BB2)
Subject: Re: [RFC] nl80211/mac80211: support full station state in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Date: Mon, 09 Apr 2012 20:59:39 +0200
In-Reply-To: <CAB3XZEe1kJ7bB08nm5p8nwJRfrE9Ew+THZN_Q=1KOf1=3QQULA@mail.gmail.com> (sfid-20120408_144939_975323_AEF7B0A3)
References: <1333735303.5577.8.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe1kJ7bB08nm5p8nwJRfrE9Ew+THZN_Q=1KOf1=3QQULA@mail.gmail.com>
	 (sfid-20120408_144939_975323_AEF7B0A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-08 at 15:49 +0300, Eliad Peller wrote:

> > Completely untested so far, just wanted to see what
> > everybody thinks. I'll need to work on the hostapd
> > patch as well, but I think TI had something there to
> > fix a race which I need to look into.
> >
> The patch looks good -- i agree it's better to add the station as soon
> as possible.
> 
> in our internal hostap tree, we use the following patches:
> https://github.com/TI-OpenLink/hostap/commit/44e8fd28f9b2fc8da9c6f58a2731b4ffa65bc396
> (https://github.com/TI-OpenLink/hostap/commit/bf21f3fe7541cd17b7b92aaf6bf06a00e9ec28bb)
> 
> These patches handle the race in which the EAPOL Start from the client
> comes before the association response tx result, causing the EAPOL to
> get dropped.

Ok, cool, thanks for the patches -- I couldn't quite remember what the
race was :)

> The first patch simply adds the station before sending the association
> response. I guess that with the suggested patch we'll just have to set
> the ASSOC state (before sending assoc response) instead of adding the
> station (which will be done before sending auth response, i guess).

Yes, my plan was adding the station before sending the auth response,
which gives better behaviour in case the driver already rejects the
station at that point, and move it to auth for the auth frame ack maybe
or when the assoc frame comes in, etc. Obviously, the driver might also
reject the later state changes, so hostapd still has to deal with errors
at all steps along the way. That might be some added complexity, but I
think it's still going to be worth it.

johannes

