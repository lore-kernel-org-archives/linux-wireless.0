Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42031 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0CRFWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 01:22:54 -0400
Subject: Re: [RFC PATCHv3 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268842663.5989.15.camel@jlt3.sipsolutions.net>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842663.5989.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 07:19:55 +0200
Message-ID: <1268889595.10120.660.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 17:17 +0100, ext Johannes Berg wrote:
> On Wed, 2010-03-17 at 15:01 +0200, Juuso Oikarinen wrote:
> 
> > +/**
> > + * enum nl80211_cqm_state - current state in relation to set threshold
> > + * @NL80211_CQM_STATE_ABOVE: the level is above the configured threshold
> > + * @NL80211_CQM_STATE_BELOW: the level is below the configured threshold
> > + */
> > +enum nl80211_cqm_state {
> > +	NL80211_CQM_STATE_ABOVE,
> > +	NL80211_CQM_STATE_BELOW,
> > +};
> 
> Thoughts about removing this and just exporting the actual (smoothed?)
> RSSI instead in the event? Or do you simply not get that from the hw?

On the wl1271 we actually do get the value that triggered the event, but
on the wl1251, for instance, we do not get it. On the wl1271 we get to
decide the above/below on the host based on the reading, but the wl1251
will just tell the host that now the RSSI went below, and now it just
went above.

Our thinking is that the above/below information is sufficient to make a
decisions about roaming. Adding the literal value will give trouble with
HW not supporting it.

If you feel the actual value of the RSSI would be important, we could
add it as an optional field to the notifcation in addition to the
above/below.

-Juuso

> johannes
> 


