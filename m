Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35023 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1KDQR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:17:28 -0400
Message-ID: <4EB41014.6000002@candelatech.com> (sfid-20111104_171731_453799_88D28C6D)
Date: Fri, 04 Nov 2011 09:17:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>  <1320299722-30113-3-git-send-email-greearb@candelatech.com>  (sfid-20111103_065549_863747_7FFD5818) <1320310045.3950.23.camel@jlt3.sipsolutions.net>  <4EB2CBCC.6080709@candelatech.com> <1320417690.3969.88.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320417690.3969.88.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 07:41 AM, Johannes Berg wrote:
> On Thu, 2011-11-03 at 10:13 -0700, Ben Greear wrote:
>
>>> Here's another argument for splitting the patches differently -- this
>>> ought to be part of the disable HT40 patch.
>>
>> One thing I could do is move patch 3 to be the first patch.  That gives this method
>> reason to exist, but I can leave out the disable-HT40 parts and (re)add that in
>> the disable-ht40 patch.
>
> I think the whole thing could just be one cfg80211 and one mac80211
> patch, wouldn't that make it simpler?

Ok, I will do that.

>>> The AMPDU density should only allow increasing.
>>>
>>> I think a lot of this validation should live in cfg80211 so if another
>>> driver wants to implement it, this kind of thing is already covered.
>>
>> The ath9k driver supports 0, and then every value that corresponds to 1us or higher.
>> If you set it to 1/2us, for instance, it just quietly rounds up to 1us.  It defaults
>> to 8, so it appears valid to decrease or increase this value.
>
> What quietly rounds up?
>
> If it defaults to 8 then I'm sure there's a reason for it, such as the
> crypto engine not being fast enough and needing 8us buffer between
> frames. As such, I really don't think decreasing it is valid.

See this code in ath9k, top of main.c.  It appears to support more
than the default of 8.  I tested it out, and it appears to work
when set to lower values.  I am disabling hw-crypt since I need
multiple VIFS, but not sure that matters or not.

static u8 parse_mpdudensity(u8 mpdudensity)
{
	/*
	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
	 *   0 for no restriction
	 *   1 for 1/4 us
	 *   2 for 1/2 us
	 *   3 for 1 us
	 *   4 for 2 us
	 *   5 for 4 us
	 *   6 for 8 us
	 *   7 for 16 us
	 */
	switch (mpdudensity) {
	case 0:
		return 0;
	case 1:
	case 2:
	case 3:
		/* Our lower layer calculations limit our precision to
		   1 microsecond */
		return 1;
	case 4:
		return 2;
	case 5:
		return 4;
	case 6:
		return 8;
	case 7:
		return 16;
	default:
		return 0;
	}
}


>> I was thinking that if ht-40 is disabled, then I should clear both the
>> IEEE80211_HT_CAP_SUP_WIDTH_20_40 and the IEEE80211_HT_CAP_SGI_40 from
>> the capabilities.  Perhaps there are other flags I should clear as well?
>
> I don't know?

Well, it can always be changed later if I missed something.  This code
should have no affect unless the users specifically enable the feature
anyway...and we'll be doing lots of testing on our systems at various
settings...

>>> I'm more and more coming to the conclusion that it would be clearer to
>>> make separate configuration items for the various things. Most
>>> capabilities you could only disable (greenfield, ...) except for maybe
>>> 40mhz-intol, so maybe that would be easier as a separate u16 attribute
>>> "disable these HT capabilities"?
>>
>> It seemed like more work for not much gain to me, but I don't mind splitting
>> it out into separate netlink configurables if you want.
>
> It just seems to me it would clarify the semantics. Not really sure I
> care all that much though.

If it's OK with you, I'll skip this for now.  If anyone ever cares,
it would be easy enough to add.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

