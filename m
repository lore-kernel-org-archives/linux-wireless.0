Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21412 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0CVGAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 02:00:22 -0400
Subject: Re: [RFC PATCHv5 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1269103686.4652.3.camel@jlt3.sipsolutions.net>
References: <1268985801-25225-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268985801-25225-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1269103686.4652.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 07:57:14 +0200
Message-ID: <1269237434.10120.734.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-20 at 17:48 +0100, ext Johannes Berg wrote:
> On Fri, 2010-03-19 at 10:03 +0200, Juuso Oikarinen wrote:
> 
> > + * @NL80211_CMD_SET_CQM: Connection quality monitor configuration and
> > + *      notification. This command is used both as a command (to configure
> > + *      a trigger level) and as an event (to indicate the configured level was
> > + *      reached.) Setting zero threshold disables the feature.
> 
> I've been thinking about this for a while, and I think I finally decided
> that I'd prefer another command number for the event. SET doesn't seem
> to match the event very well at all.

I'll change this. The reason I have it this way now is just that I
noticed that sharing the ID's is a common way to do it in existing code.

> > +/**
> > + * enum nl80211_cqm_rssi_threshold_event - RSSI threshold event
> > + * @NL80211_CQM_RSSI_THRESHOLD_EVENT_NONE - No RSSI threshold event occurred
> 
> What is none intended for? If it's for any of the other possible future
> enhancements, I'd think in that case we just leave out the attribute?

Yes, thinking back, this was a bad idea. I'll take it out ;)

> > +static struct nla_policy
> > +nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
> > +	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
> > +	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U8 },
> 
> Now I'm confused. Not that I think we'll ever need a hysteresis value
> larger than that, but isn't that a little inconsistent?

As per your preference, I'll change this. I personally don't seem to get
over my old habit of always feeling the urge to save some bits ;)

Thanks for your comments.

-Juuso

> johannes
> 


