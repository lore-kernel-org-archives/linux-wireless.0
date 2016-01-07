Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44488 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbcAGOlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 09:41:07 -0500
Message-ID: <1452177663.3141.9.camel@sipsolutions.net> (sfid-20160107_154111_419110_5D0A2C45)
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>,
	Dan Williams <dcbw@redhat.com>
Date: Thu, 07 Jan 2016 15:41:03 +0100
In-Reply-To: <568E5F7F.4050604@broadcom.com>
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>
				 <1450959550-19655-2-git-send-email-arend@broadcom.com>
			 <1451985926.12357.16.camel@sipsolutions.net>
			 <568B91D6.6080404@broadcom.com>
		 <1452011509.12357.51.camel@sipsolutions.net>
		 <568CE980.5050005@broadcom.com>
	 <1452090998.2541.18.camel@sipsolutions.net> <568E5F7F.4050604@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-07 at 13:52 +0100, Arend van Spriel wrote:
> 
> Agree. However, one of the reasons I added the ext_feature is because
> people gave feedback they wanted it for testing purposes so they know
> what to expect from the driver. That same argument could used for the
> supported selection criteria. I have no strong opinion though.

Yeah, that's true - if we play the "advisory" card then we don't really
need to add it at all... Not sure what to do really. I'd love to
specify it very clearly if we need to at all.

Perhaps for features we can add NL80211_ATTR_BSS_SELECT to the wiphy
information, and within that add each of the supported
ATTR_BSS_SELECT_* as an NLA_FLAG? That way at least we don't need to
define all kinds of new flags in the API.

> > Right. So realistically, writing this a bit more verbosely, you
> > have
> > 
> > 1) rssi_preference, band_preference(band)
> > 2) rssi_adjust(band, delta), rssi_preference
> > 
> > and perhaps
> > 
> > 3) rssi_preference
> > 
> > as the default?
> 
> Good point.
> 
> > As for 1), you said it was "band, rssi" but it seems you really
> > meant
> > the other way around since before you said "band" was a tie-
> > breaker.
> 
> My bad. When using "band_preference()" the selected BSS is in specified 
> band even though the BSS in other band would be stronger. If there is no 
> proper BSS in the specified band the preference is obviously
> discarded.

So 1) really becomes just
 1) band_preference(band)

without any RSSI at all? Ah, I get it. You have to kind of reword that
in terms of the logic used:

 1) select_highest_rssi_in_band(band), select_highest_rssi()
 2) adjust_rssi_if_in_band(band, delta), select_highest_rssi()
 3) select_highest_rssi()

But if you look at that, then "select_highest_rssi_in_band(band)" is
really the same as "adjust_rssi_if_in_band(band, 1000)" since you can't
have real RSSI that high, which leaves us with just a single primitive
and perhaps a standard value for that "1000"?


> > Perhaps then, the API should just expose the two "primitives"
> >   * band_preference(band)
> >   * rssi_adjust(band, delta)?

I guess it makes even more sense as I just worded it.

> > And for use-case number #3:
> 
>    * rssi_preference(void)

Yeah although you'd assume that's the default anyway?

johannes
