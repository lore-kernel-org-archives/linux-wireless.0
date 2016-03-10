Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33109 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbcCJR4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 12:56:39 -0500
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
 <1453807009.2759.23.camel@sipsolutions.net>
 <56A78E8F.1080505@candelatech.com> <1454576521.2564.6.camel@sipsolutions.net>
 <56B38FD1.40902@candelatech.com> <1455827536.2084.35.camel@sipsolutions.net>
 <56C62C4E.7020600@candelatech.com>
 <1455828330.2084.38.camel@sipsolutions.net>
 <56C630B7.7020604@candelatech.com>
 <1455830078.2084.47.camel@sipsolutions.net>
 <56C63D8B.9020900@candelatech.com>
 <1456225589.2041.24.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56E1B556.4080004@candelatech.com> (sfid-20160310_185642_747754_5969F208)
Date: Thu, 10 Mar 2016 09:56:38 -0800
MIME-Version: 1.0
In-Reply-To: <1456225589.2041.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2016 03:06 AM, Johannes Berg wrote:
> On Thu, 2016-02-18 at 13:54 -0800, Ben Greear wrote:
>
>>> Yeah, it does, at least if you assume that the capabilities can
>>> actually change. We assume they don't though, hostapd/wpa_s for
>>> example will never re-query them after startup.
>>
>> Restarting supplicant, even if it came to that, might be less
>> of an issue than having to re-create the vdev to have it grab
>> proper new settings from the wiphy...
>
>> Well, it would be easy enough to make a method that updated an
>> vdev/sdata->vht from wiphy, so could just call that as needed (ie,
>> when certain things set or are changed by wiphy).
>
> Yeah, I think we'll just have to deal with this when it comes along.
> This multi-antenna-sharing case (unfortunately I forgot who was talking
> about it) is the only thing that comes to mind where we really may have
> to deal with this.

I started looking at making these changes...and I have a few questions.

First, are you proposing that I make a copy of the entire  local->hw.wiphy->bands array
and store it locally in sdata?

And then, I would provide some API to modify the bands[i]->bitrates and other
variables to properly select the advertised features?

I am a bit concerned about making copies (and then changing) the driver's
bitrates array.  Likely it will work with ath10k, but it seems fragile
at best.

Or, did I mis-understand your suggestion with regards to what data structures
should be copied to sdata in mac80211 and then made modifiable?

With regard to my original patch, are there any other things that I could do to
make it more acceptable without making copies of the driver data?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

