Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0CRQLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 12:11:04 -0400
Subject: Re: [RFC PATCHv3 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268889595.10120.660.camel@wimaxnb.nmp.nokia.com>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842663.5989.15.camel@jlt3.sipsolutions.net>
	 <1268889595.10120.660.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 09:10:59 -0700
Message-ID: <1268928659.4005.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 07:19 +0200, Juuso Oikarinen wrote:
> On Wed, 2010-03-17 at 17:17 +0100, ext Johannes Berg wrote:
> > On Wed, 2010-03-17 at 15:01 +0200, Juuso Oikarinen wrote:
> > 
> > > +/**
> > > + * enum nl80211_cqm_state - current state in relation to set threshold
> > > + * @NL80211_CQM_STATE_ABOVE: the level is above the configured threshold
> > > + * @NL80211_CQM_STATE_BELOW: the level is below the configured threshold
> > > + */
> > > +enum nl80211_cqm_state {
> > > +	NL80211_CQM_STATE_ABOVE,
> > > +	NL80211_CQM_STATE_BELOW,
> > > +};
> > 
> > Thoughts about removing this and just exporting the actual (smoothed?)
> > RSSI instead in the event? Or do you simply not get that from the hw?
> 
> On the wl1271 we actually do get the value that triggered the event, but
> on the wl1251, for instance, we do not get it. On the wl1271 we get to
> decide the above/below on the host based on the reading, but the wl1251
> will just tell the host that now the RSSI went below, and now it just
> went above.
> 
> Our thinking is that the above/below information is sufficient to make a
> decisions about roaming. Adding the literal value will give trouble with
> HW not supporting it.

Ok, that's fair. I don't want to hurt wl1251 by doing this. But then
maybe it could just retrieve the value from the last beacon?

> If you feel the actual value of the RSSI would be important, we could
> add it as an optional field to the notifcation in addition to the
> above/below.

No ... I don't actually strongly feel that the actual value is all that
relevant, although we'll only know when we implement roaming algorithms
in userspace. Maybe it would be advantageous to keep this out of the
tree for a while longer while you implement the userspace portion? But I
don't know how much you've thought about how to use this so maybe you
know it'll work :) And OTOH you kinda know it has to work since that's
what you get from the hw...

Anyhow, back to this patch again: For some reason I just don't like the
above/below thing all that much. I think in part that's because on the
one hand you say it can be extended, but on the other you call this
nl80211_cqm_state.

How about we call it nl80211_cqm_rssi_threshold_event or something like
that? Yeah it's a long and verbose name, but I think it's better than
"state"? The states you have at least are not really tied to the RSSI
stuff.

I could, for example, imagine also using this to let userspace know
about beacon loss events when they become too frequent. It's possible
that this happens while the RSSI is still high, due to interference,
after all.

johannes

