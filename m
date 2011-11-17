Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KQL2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 06:28:17 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EBC2516.4080807@candelatech.com>
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13) <1320783128.24797.48.camel@jlt3.sipsolutions.net>
	 <4EB99812.3000507@candelatech.com>
	 <1320786130.24797.78.camel@jlt3.sipsolutions.net>
	 <4EBC2516.4080807@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 12:28:13 +0100
Message-ID: <1321529293.3997.28.camel@jlt3.sipsolutions.net> (sfid-20111117_122820_168101_9EF4A53A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben, sorry for the delay, I was too busy thinking about other stuff.

On Thu, 2011-11-10 at 11:25 -0800, Ben Greear wrote:

> But, I don't think it is going to work..or at least if it can, I
> don't see a good way to do it.
> 
> I'm stuck in the ieee80211_ht_cap_ie_to_sta_ht_cap method.  With
> my original patch, I apply overrides here, at the bottom of the
> method.  If we're associated (or started associating)
> and user asked for over-rides, we'll apply requested overrides, else
> nothing will change because the over-rides mask is not set.
> 
> But, if I have to use pre-computed values here then I need to
> be certain they are set properly.  If association has been
> requested, then that is fine.  But, what about the
> sta_apply_parameters() method?  Can we guarantee that association has
> been requested when this method is called?  I think we cannot,
> and if not, then I cannot use pre-computed sdata->used_ht_caps.
> I could attempt to set a flag when used_ht_caps
> has been calculated, and add a check for that, but that is yet another piece
> of computed state that could be stale if we make a mistake somewhere.

We can't, but can't we like assign sdata->ht_caps = sband->ht_caps? Or
maybe even calculate restricted HT caps for both 2.4 and 5 GHz?
Basically what I was thinking is this:

struct sub_if_data {
	...
	struct ieee80211_sta_ht_cap ht_cap[num_bands];
	...
};

We'd use *that* everywhere, and when associating we calculate
sdata->ht_cap[band] = apply_overrides(sbands[band]->ht_cap);

and when disassociating we simply
	memcpy(sdata->ht_cap[band], sbands[band]->ht_cap, ...);

or so? Then we can always use sdata->ht_cap[bands] instead of
sband->ht_caps everywhere, and overrides are implicit.

Was this what you attempted?

johannes

