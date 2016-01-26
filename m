Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38945 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965117AbcAZLQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 06:16:51 -0500
Message-ID: <1453807009.2759.23.camel@sipsolutions.net> (sfid-20160126_121654_532371_2B7BE4B3)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Tue, 26 Jan 2016 12:16:49 +0100
In-Reply-To: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-10-20 at 10:24 -0700, greearb@candelatech.com wrote:

> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2130,6 +2130,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_REG_INDOOR,
>  
> +	NL80211_ATTR_TX_ADVERT_RATEMASK,

First of all, this is missing documentation. It's a FLAG as far as I
can tell, but if it's set should it affect only the advertised or both?

I also think you added this because I had commented that we might not
want to do it unconditionally, but is there really a good reason not to
do it unconditionally? I was probably more thinking out loud what would
happen with P2P, but there we already say "no cck" for scanning so it
shouldn't really have any effect.

But given that we have NL80211_ATTR_SCAN_SUPP_RATES, where does your
patch even have an effect, other than this not handling HT/VHT?

I'm a bit wary that we're introducing two ways of achieving a very
similar thing.

Also, adding these overrides all over the code seems very complex.
Perhaps we can achieve the goal of being able to pretend to have
limited hardware capabilities by actually restricting hardware
capabilities instead? That would also avoid having to play whack-a-mole 
with code paths using the device capabilities.

I'd imagine an API along the lines of doing some kind of higher-layer
re-register of the wiphy in mac80211 with limited capabilites. At that
point you'd allocate a copy of the original capabilities (as far as the
new restricted ones overwrite the data), and remove the device from the
system as far as higher layers like cfg80211 are concerned.

Would something like that work for you?

johannes
