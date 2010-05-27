Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab0E0IMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 04:12:06 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201005270941.30654.br1@einfach.org>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
	 <1274883276.3658.15.camel@jlt3.sipsolutions.net>
	 <201005270941.30654.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:12:01 +0200
Message-ID: <1274947921.3669.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 09:41 +0900, Bruno Randolf wrote:

> > +	} else {
> > +		/*
> > +		 * If no rates were explicitly configured,
> > +		 * use the mandatory rate set for 11b or
> > +		 * 11a for maximum compatibility.
> > +		 */
> > +		struct ieee80211_supported_band *sband =
> > +			wiphy->bands[ibss.channel->band];
> > +		int j;
> > +		u32 flag = ibss.channel->band == IEEE80211_BAND_5GHZ ?
> > +				IEEE80211_RATE_MANDATORY_A :
> > +				IEEE80211_RATE_MANDATORY_B;
> > +
> > +		for (j = 0; j < sband->n_bitrates; j++) {
> > +			if (sband->bitrates[j].flags & flag)
> > +				ibss.basic_rates |= j;
> > +		}
> > +	}
> 
> couldn't we use ieee80211_mandatory_rates() here?

Yeah, but it would have to migrate to cfg80211.

johannes

