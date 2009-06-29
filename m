Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:3230 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758885AbZF2Pjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 11:39:51 -0400
Subject: Re: Repeater Bridge Mode with ar9170?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246278355.4585.3.camel@johannes.local>
References: <1245861185.13356.2.camel@jdl-desktop>
	 <1245881310.13356.10.camel@jdl-desktop>
	 <1246278355.4585.3.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 10:39:53 -0500
Message-Id: <1246289993.15012.10.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-29 at 14:25 +0200, Johannes Berg wrote:
> On Wed, 2009-06-24 at 17:08 -0500, Jon Loeliger wrote:
> 
> > OK, so, in the other (non-mac80211) drivers, there was a mode
> > called IW_MODE_REPEATER that implemented 4-address framing for
> > clients that provided the bridging ability.
> > 
> > That same functionality is currently not implemented in the
> > mac80211 code (ie, no NL80211_IFTYPE_REPEATER mode).
> 
> Actually, the IW_MODE_REPEATER was never quite clearly defined afaict
> and we made it WDS instead.

I think WDS is an "AP variant" whereas I'm looking for
a "client variant".

> > My perhaps mistaken understanding of what it would take to
> > make this work would be to create a new NL80211_IFTYPE_REPEATER
> > mode that was a hybrid between _STATION and _WDS modes.  In
> > particular, it would act like _STATION as far as association
> > and authentication are concerned, but would also have _WDS-like
> > 4-address frame handling.
> > 
> That seems acceptable, though I don't necessarily see a need for adding
> a new mode since you can very easily detect that you need to use 4addr
> frames, and then it is up to the AP whether to accept them or not.
> 
> As far as the AP is concerned, it would probably be violating 802.1X to
> accept such frames. Thus, it seems like some fairly obscure
> functionality you would only want to enable with a Kconfig option even
> on the client side?

I think I need to do this strictly from a client/station perspective.
The only AP in this picture would be the "upstream" AP to which my
client is associated.  We shouldn't be changing any code running on
those APs at all.

Which leads to me trying to figure out how the client is able to
know what the correct "MAC level NAT address" needs to be to
when it converts the 802.11 header to the 802.3 header.  Doesn't
the upstream AP have to have already sent you 4-address frames
for this to work?  Or will it respond with a 4-address frame if
it is sent a 4-address frame from the station?

> johannes

Thanks,
jdl


