Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1KBINz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 04:13:55 -0400
Subject: Re: [wireless-next PATCH 3/5] wifi: Allow overriding some HT
 information.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EAAD95E.1030001@candelatech.com> (sfid-20111028_183341_942256_664FE0B1)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071147_787476_DBCC8CCF) <1319789573.3914.15.camel@jlt3.sipsolutions.net>
	 <4EAAD95E.1030001@candelatech.com> (sfid-20111028_183341_942256_664FE0B1)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 09:13:50 +0100
Message-ID: <1320221630.3950.22.camel@jlt3.sipsolutions.net> (sfid-20111102_091402_006832_3B013A7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 09:33 -0700, Ben Greear wrote:

> >> * Allow configuring the mcs (/n) rates available.
> >> * Allow configuration of MAX-A-MSDU
> >> * Allow configuration of A-MPDU factor&  density.
> >>
> >> Users can only remove existing rates.  The MSDU and MPDU
> >> values can be set to any value allowed by the 802.11n
> >> specification.
> >
> > That can't work -- the device might not support it.
> 
> The device would always support removing rates, right?

No. As I pointed out in another email, you need to think beyond
mac80211.

> As for the MSDU and MPDU stuff, I would need to add capabilities
> flags and then enable each driver as they are tested?

No. Neither of these can ever be increased so it's not that simple. And
making it smaller is always possible since it's just advertising.
Presumably you do understand the reasons for this advertising/these
restrictions?

> > I also don't really like the way you pass in some binary "mask" when
> > it's not really a binary masking operation.
> 
> I found the mask to work very well.  It's easy enough to
> deal with in user-space, and easily allows us to add override features
> (the additional bits to support the MPDU stuff once the
> HT rates logic was in is a very small bit of code).
> 
> Otherwise, I'll need to add new netlink commands for each new
> feature.  That is going to bloat hostapd as well as the
> kernel.

I'm not sure it'll bloat it, but I can live with the binary struct. It
seems a bit ugly to me but I think it's acceptable. However, you should
document more clearly what struct it is and how it is defined to work.
You're also relying on userspace to not do stupid things (otherwise your
code reads memory out of bounds), this would help:

>         /* add attributes here, update the policy in nl80211.c */

Anyway, I'm out of breath. I think this is simply bad implementation &
execution of your ideas. These are somewhat interesting features and I'm
willing to accommodate even some of the more esoteric features that most
people will never use, but I'm quite annoyed by how much of your patches
I end up doing myself through review.

Please focus more on the quality of your patches in "details" like
security, API issues, non-mac80211 drivers and even simply logic like
the A-MSDU thing I just pointed out. I'm spending a disproportionate
amount of time reviewing your patches over and over again with every
patchset and am no longer willing to do that.

Obviously we'll still have to discuss things like whether it should be a
connection or interface parameter -- but I shouldn't have to point out
trivial security issues -- you should be focusing more on these things
while writing the code, not after the fact where it's much harder. E.g.
never ever use nla_data() without validating nla_len() in some way, it
seems to me that should be completely obvious.


> >> @@ -114,6 +115,19 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
> >>   	if (ht_info_ie[1]<  sizeof(struct ieee80211_ht_info))
> >>   		return;
> >>
> >> +	memcpy(&ht_cap,&sband->ht_cap, sizeof(ht_cap));
> >> +	/*
> >> +	 * This is for an association attempt, and we must
> >> +	 * advert at least the first 8 rates, even if we
> >> +	 * will later force the rate control to a lower rate.
> >> +	 */
> >> +	ieee80211_apply_htcap_overrides(sdata,&ht_cap, 8);
> >
> > Yuck, why, why hard-code 8, etc.
> 
> I can make a define that involves MCS7.

I don't think I understand then why MCSs 0-7 must be supported?

johannes

