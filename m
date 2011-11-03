Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52767 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1KCRST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 13:18:19 -0400
Message-ID: <4EB2CCD7.3010907@candelatech.com> (sfid-20111103_181822_429484_F41F0D8D)
Date: Thu, 03 Nov 2011 10:18:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mac80211: Support forcing station to disable HT
 (802.11n).
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>  (sfid-20111103_065534_192366_EF6ABFB6) <1320309465.3950.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320309465.3950.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 01:37 AM, Johannes Berg wrote:
> On Wed, 2011-11-02 at 22:55 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This allows a user to configure a wifi station interface
>> to disable the HT features, even if the AP and NIC supports it.
>
> I like this version much better. Some nitpicks:
>
>
>> +#define ASSOC_REQ_DISABLE_HT	(1<<0) /* Disable HT (802.11n) */
>
> You could use an enum to use kernel-doc notation here.

Sure, will do.


>> @@ -1053,6 +1056,7 @@ struct cfg80211_assoc_request {
>>   	size_t ie_len;
>>   	struct cfg80211_crypto_settings crypto;
>>   	bool use_mfp;
>> +	u32 flags;
>
> Seems like it might be good for use_mfp to become a flag? Anyway,
> internal APIs are easy to change.

Yes, but I've been beat over the head enough to know not to mix
this kind of cleanup into my patches :)

Will do a follow-on patch after I get my changes in.

>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>
> I'd rather split this up into cfg80211/mac80211. In fact, maybe
> splitting it into one cfg80211 and one mac80211 patch, instead of three
> different patches that span both might be worthwhile?

I really don't care either way.  Just let me know how you want it
and I'll split it up thus.  Just please do not change your mind later,
splitting patches is nothing but work :P

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

