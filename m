Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0F0IVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 04:21:05 -0400
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
In-Reply-To: <201006251801.06209.helmut.schaa@googlemail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com>
	 <1277394714.3870.8.camel@jlt3.sipsolutions.net>
	 <201006251801.06209.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 10:21:02 +0200
Message-ID: <1277626862.3684.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-25 at 18:01 +0200, Helmut Schaa wrote:
> Am Donnerstag 24 Juni 2010 schrieb Johannes Berg:
> >  b) You need to get a new beacon frame from mac80211 only when it
> >     changes. You can do this from set_tim(). HOWEVER: since you're not
> >     getting a new one from mac80211 all the time anyway, you NEED to
> >     have the driver or firmware overwrite the DTIM count, like b43's
> >     firmware for example will do.
> 
> And the broad- and multicast buffering also needs to be done in the driver
> (when the fw/hw cannot handle it) as mac80211 uses its own DTIM count for
> deciding when to "release" buffered frames to the driver.

Well, yes, but I don't get it. Are you trying to conjure a third way of
doing things? How would you like it to work?

I don't understand why you expect to have a correct DTIM count field
when you don't pull every beacon from mac80211. If you pull each beacon
it's all correct. If you don't, you need to take care of everything DTIM
related, there's simply no way to do it differently.

Does your device fill the DTIM count field or does it not? That's really
the only thing you need to know, no?

johannes

