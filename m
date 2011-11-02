Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1KBRuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 13:50:04 -0400
Subject: Re: [wireless-next PATCH 3/5] wifi: Allow overriding some HT
 information.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB176F9.7090304@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071147_787476_DBCC8CCF) <1319789573.3914.15.camel@jlt3.sipsolutions.net>
	 <4EAAD95E.1030001@candelatech.com>
	 (sfid-20111028_183341_942256_664FE0B1) <1320221630.3950.22.camel@jlt3.sipsolutions.net>
	 <4EB176F9.7090304@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 18:49:58 +0100
Message-ID: <1320256198.7846.2.camel@jlt3.sipsolutions.net> (sfid-20111102_185008_683088_929A95E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 09:59 -0700, Ben Greear wrote:

> > No. Neither of these can ever be increased so it's not that simple. And
> > making it smaller is always possible since it's just advertising.
> > Presumably you do understand the reasons for this advertising/these
> > restrictions?
> 
> It seems that a driver might default to a mid-range value for the MPDU values
> because it is somehow 'better' for whatever reason, and yet it might still
> support larger values if the user desires, perhaps because in specific
> scenarios larger values are better.  Ath9k does set to the max value,
> so if we do a per-driver capabilities flag as I did in v2 then we
> are safe.

Then the proper way to do that would be to not have a flag, but a max it
can be set to. However, I see no reason it should default to a mid-range
value?! iwlwifi for example needs to allocate enough space but ... I
don't get it. What's wrong with simply not allowing to increase, only
decrease?

> >>          /* add attributes here, update the policy in nl80211.c */
> 
> I copied some of that code from nl80211_set_station, which appears to
> also forget to check the length for the NL80211_ATTR_HT_CAPABILITY
> object.  Is there some reason why it doesn't need to check, or does
> that code need fixing as well?

NL80211_ATTR_HT_CAPABILITY in particular *has* a policy entry.

> Well, it's more obvious now.  Do you also need to check the length when
> doing code like this code from nl80211_set_station:
> 
> 	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
> 		params.listen_interval =
> 		    nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
> 
> In other words, is it safe to assume you have 16 bits, or could a broken
> user-space pass in a single byte and screw this up?

There's the policy that validates it.


>  From 20.1.1 of the 802.11n spec:
> 
> "An HT non-AP STA shall support all equal modulation (EQM) rates for one spatial stream (MCSs 0 through
> 7) using 20 MHz channel width. An HT AP shall support all EQM rates for one and two spatial streams
> (MCSs 0 through 15) using 20 MHz channel width."
> 
> That is why I wrote that code as I did, but perhaps I misunderstand that section of
> the docs.

No, that makes some sense, I wasn't aware of that restriction.

johannes

