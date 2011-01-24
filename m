Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1AXLq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:46:59 -0500
Subject: Re: [RFC][PATCH] cfg80211: report monitor interface channel via
 wext when possible
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@gmail.com>,
	Richard Farina <sidhayn@gmail.com>
In-Reply-To: <20110123094101.GB25136@home.lan>
References: <1295655098-17534-1-git-send-email-fercerpav@gmail.com>
	 <1295773599.3639.4.camel@jlt3.sipsolutions.net>
	 <20110123094101.GB25136@home.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:47:50 +0100
Message-ID: <1295869670.3639.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 12:41 +0300, Paul Fertser wrote:
> On Sun, Jan 23, 2011 at 10:06:39AM +0100, Johannes Berg wrote:
> > On Sat, 2011-01-22 at 03:11 +0300, Paul Fertser wrote:
> > > This makes it possible to retrieve the channel for the monitor interface
> > > in cases when it can be determined unambigously. Tested with ath5k.
> > 
> > NAK.
> > 
> > http://article.gmane.org/gmane.linux.kernel.wireless.general/61860
> 
> If i understood your correctly, "somehow query oper_channel" means one
> needs to extend cfg80211 API a little and add necessary code to
> mac80211. And the result would be higher-level API depending on
> mac80211 implementation details (which are going to be soon changed
> anyway after introduction of the real multi-channel feature).

Not necessarily -- that's exactly why you'd want such a callback: in the
case that mac80211 does get a multi-channel feature (and the feature is
currently in use) this callback would either return both/all channels
(which probably isn't very useful) or NULL to indicate that it doesn't
have a single fixed channel. In that case, the monitor interface would
still report an unknown channel -- which is really what's happening
anyway since other interfaces will be hopping around.

> What i propose should work with any cfg80211 driver where
> set_channel() is properly implemented for monitor interfaces, and
> mac80211 is certainly one of them. When in the first place one
> requests set_channel() for a monitor that's not compatible with the
> current configuration, it'll return an error, and so wdev->channel
> would not be set at all. If it succeeded and then someone later wants
> to verify the monitor channel, set_channel() is still the best
> opportunity because it is this function that has all the checks to
> verify the channel is still valid.
> 
> To sum up, i see no drawbacks in using set_channel() for that, it
> doesn't add any implicit requirements, doesn't change semantics,
> non-intrusive, doesn't break anything and works correctly every time.

Yes, in some ways this makes sense, but I'm not convinced that
semantically we really want it. It really relies on returning an error
when the given channel cannot be assigned, which I guess we could, but
it just feels wrong. I can't really give a good reason for it other than
that.

However, also consider this case: If you have a monitor and IBSS
interface, the IBSS might -- rather infrequently -- hop channels. In
this case, it might make sense to still return the channel when the
monitor is queried, but you wouldn't be able to set it?

Also, say you did this:
 - add monitor, set to channel 5
 - add IBSS, create network on channel 1
 - observe packets on monitor iface received on channel 1
 - remove IBSS interface
 - query monitor channel -- now suddenly with your approach
   the channel is reset to 5, when it was quite obviously 1
   in the time between

I think that'd be kinda confusing too.

johannes

