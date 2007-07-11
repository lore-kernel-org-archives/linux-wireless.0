Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXGKVSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 17:18:24 -0400
Subject: Re: Setting channel when interface is down inconsistency
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1184107850.3738.20.camel@johannes.berg>
References: <9e4733910707090759v5cd20f2en1f6c4e6fc6279b3f@mail.gmail.com>
	 <1184005862.5671.2.camel@xo-13-A4-25.localdomain>
	 <1184107850.3738.20.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 17:18:15 -0400
Message-Id: <1184188695.28850.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-11 at 00:50 +0200, Johannes Berg wrote:
> On Mon, 2007-07-09 at 14:31 -0400, Dan Williams wrote:
> > On Mon, 2007-07-09 at 10:59 -0400, Jon Smirl wrote:
> > > bcm43xx and rx2x00 let me set the channel before the interface is up.
> > > zd1211 requires the interface to be up before setting the channel.
> > > 
> > > Is there a guideline for how this is supposed to work?
> > 
> > In the ideal case, the driver should allow you to set any _attribute_
> > when the device is down, but if you try to do an _action_ that requires
> > that the interface be up (for example, associating), it should return an
> > error of some kind.
> > 
> > So setting things like encryption key, channel, ssid, bssid, etc should
> > all work when the device is down, but actually issuing the 'iwconfig
> > wlan0 ssid "foobar"' can be expected to fail because in WEXT that is
> > supposed to trigger an association.
> > 
> > Splitting up this stuff and having an explicit association request in
> > nl80211/cfg80211 should make this a lot clearer.
> 
> In fact, the way it's planned now is that you can't even give it an
> ssid/bssid etc. without also triggering an association, but contrary to
> wext you do pass all parameters at once and when needed.
> 
> Hence, this will not actually solve the problem per se, we could make it
> a requirement either way to document it (though in fact it'd be simple
> to return -ENOTCONN for every configuration request when the device is
> down) but setting the channel for example isn't actually any different
> than with wext. Therefore, I think we still need a guideline. Do you
> think setting everything when the device is down makes sense? Then we'll

The more I think about it the more I think you're right; because with
WEXT there was really no ordering guarantee.  With the new stuff as long
as there's an ordering guarantee, I think it'll be fine.

But, of course, we need to make sure that we are consistent and that if
we really don't allow configuration when the device is down, that all
drivers return error when they are down.

Dan

> have to document that drivers must accept these requests and honour them
> when the device is turned on. Which is actually another thing we need to
> make absolutely sure, when the netdev is down the device should be
> turned off.
> 
> johannes

