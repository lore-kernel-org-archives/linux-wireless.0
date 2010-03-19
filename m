Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59361 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0CSEq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 00:46:57 -0400
Subject: Re: [RFC PATCHv3 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268928659.4005.5.camel@jlt3.sipsolutions.net>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842663.5989.15.camel@jlt3.sipsolutions.net>
	 <1268889595.10120.660.camel@wimaxnb.nmp.nokia.com>
	 <1268928659.4005.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 06:43:47 +0200
Message-ID: <1268973827.10120.692.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 17:10 +0100, ext Johannes Berg wrote:
> On Thu, 2010-03-18 at 07:19 +0200, Juuso Oikarinen wrote:
> > On Wed, 2010-03-17 at 17:17 +0100, ext Johannes Berg wrote:
> > > On Wed, 2010-03-17 at 15:01 +0200, Juuso Oikarinen wrote:
> > > 
> > > > +/**
> > > > + * enum nl80211_cqm_state - current state in relation to set threshold
> > > > + * @NL80211_CQM_STATE_ABOVE: the level is above the configured threshold
> > > > + * @NL80211_CQM_STATE_BELOW: the level is below the configured threshold
> > > > + */
> > > > +enum nl80211_cqm_state {
> > > > +	NL80211_CQM_STATE_ABOVE,
> > > > +	NL80211_CQM_STATE_BELOW,
> > > > +};
> > > 
> > > Thoughts about removing this and just exporting the actual (smoothed?)
> > > RSSI instead in the event? Or do you simply not get that from the hw?
> > 
> > On the wl1271 we actually do get the value that triggered the event, but
> > on the wl1251, for instance, we do not get it. On the wl1271 we get to
> > decide the above/below on the host based on the reading, but the wl1251
> > will just tell the host that now the RSSI went below, and now it just
> > went above.
> > 
> > Our thinking is that the above/below information is sufficient to make a
> > decisions about roaming. Adding the literal value will give trouble with
> > HW not supporting it.
> 
> Ok, that's fair. I don't want to hurt wl1251 by doing this. But then
> maybe it could just retrieve the value from the last beacon?

Alas, we cannot. The wl1251/71 atleast have beacon filtering, so the
host is not receiving beacons at all, and hence, does not have a
up-to-date RSSI value. Actually, the host does not get a decent RSSI
from anywhere, unless there happens to be some non-beacon inbound data
at just that moment.

And also, because there is fluctuation, sending the RSSI value from a
theoretical last beacon may not reflect the true reason of the trigger.
Userspace might not get the right idea for the cause of the event.

> > If you feel the actual value of the RSSI would be important, we could
> > add it as an optional field to the notifcation in addition to the
> > above/below.
> 
> No ... I don't actually strongly feel that the actual value is all that
> relevant, although we'll only know when we implement roaming algorithms
> in userspace. Maybe it would be advantageous to keep this out of the
> tree for a while longer while you implement the userspace portion? But I
> don't know how much you've thought about how to use this so maybe you
> know it'll work :) And OTOH you kinda know it has to work since that's
> what you get from the hw...

The N900 has this same mechanism in it, and it's been used there
relatively successfully. So even in practice, this works.

> Anyhow, back to this patch again: For some reason I just don't like the
> above/below thing all that much. I think in part that's because on the
> one hand you say it can be extended, but on the other you call this
> nl80211_cqm_state.
> 
> How about we call it nl80211_cqm_rssi_threshold_event or something like
> that? Yeah it's a long and verbose name, but I think it's better than
> "state"? The states you have at least are not really tied to the RSSI
> stuff.

Yes, I can call it whatever feels good to you and others. The name in
itself, I believe, is not an issue!

> I could, for example, imagine also using this to let userspace know
> about beacon loss events when they become too frequent. It's possible
> that this happens while the RSSI is still high, due to interference,
> after all.

Yes, that is a good idea, for later :)

-Juuso



> johannes
> 


