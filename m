Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50097 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1KDQ1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:27:30 -0400
Message-ID: <4EB4126E.1020802@candelatech.com> (sfid-20111104_172734_236559_0184BD8C)
Date: Fri, 04 Nov 2011 09:27:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>  <1320299722-30113-3-git-send-email-greearb@candelatech.com>  (sfid-20111103_065549_863747_7FFD5818) <1320310045.3950.23.camel@jlt3.sipsolutions.net>  <4EB2CBCC.6080709@candelatech.com>  <1320417690.3969.88.camel@jlt3.sipsolutions.net>  <4EB41014.6000002@candelatech.com> <1320423893.3969.104.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320423893.3969.104.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 09:24 AM, Johannes Berg wrote:
> On Fri, 2011-11-04 at 09:17 -0700, Ben Greear wrote:
>
>>>>> The AMPDU density should only allow increasing.
>>>>>
>>>>> I think a lot of this validation should live in cfg80211 so if another
>>>>> driver wants to implement it, this kind of thing is already covered.
>>>>
>>>> The ath9k driver supports 0, and then every value that corresponds to 1us or higher.
>>>> If you set it to 1/2us, for instance, it just quietly rounds up to 1us.  It defaults
>>>> to 8, so it appears valid to decrease or increase this value.
>>>
>>> What quietly rounds up?
>>>
>>> If it defaults to 8 then I'm sure there's a reason for it, such as the
>>> crypto engine not being fast enough and needing 8us buffer between
>>> frames. As such, I really don't think decreasing it is valid.
>>
>> See this code in ath9k, top of main.c.  It appears to support more
>> than the default of 8.  I tested it out, and it appears to work
>> when set to lower values.  I am disabling hw-crypt since I need
>> multiple VIFS, but not sure that matters or not.
>>
>> static u8 parse_mpdudensity(u8 mpdudensity)
>
> Well, this is used for TX. You're advertising the value for RX.
> Advertising a smaller value may work for you -- but only if the AP uses
> something larger anyway. It's free to do this. The code you quoted
> implements this -- it looks at what the min spacing is the peer wants,
> and then uses something bigger.
>
> So I still stand by what I said earlier -- you should not allow
> advertising a smaller value than the hardware wanted to use initially.
> If the AP doesn't use that smaller value, all is well, but if it
> actually uses a smaller value then the hardware might fall over.

Ok, I'll add that restriction.  When this all settles, maybe I
can get some info from the ath9k folks about what their hardware
can actually support.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

