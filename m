Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40408 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbcLPFzC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 00:55:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 16 Dec 2016 11:23:52 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to
 support BTCOEX
In-Reply-To: <1481645351.20412.34.camel@sipsolutions.net>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
 <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
 <1480949353.31788.27.camel@sipsolutions.net>
 <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
 <1481645351.20412.34.camel@sipsolutions.net>
Message-ID: <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org> (sfid-20161216_065617_263612_A0092E8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the comments

On 2016-12-13 21:39, Johannes Berg wrote:
>> > >  /**
>> > > + * wiphy_btcoex_support_flags
>> > > + *	This enum has the driver supported frame types for
>> > > BTCOEX.
>> > > + * @WIPHY_WLAN_BE_PREFERRED - Supports Best Effort frame for
>> > > BTCOEX
>> > > + * @WIPHY_WLAN_BK_PREFERRED - supports Background frame for
>> > > BTCOEX
>> > > + * @WIPHY_WLAN_VI_PREFERRED - supports Video frame for BTCOEX
>> > > + * @WIPHY_WLAN_VO_PREFERRED - supports Voice frame for BTCOEX
>> > > + * @WIPHY_WLAN_BEACON_PREFERRED - supports Beacon frame for
>> > > BTCOEX
>> > > + * @WIPHY_WLAN_MGMT_PREFERRED - supports Management frames for
>> > > BTCOEX.
>> > > + */
>> >
>> > That's not making much sense to me?
>> >
>> 
>> is it fine to have as WIPHY_BTCOEX_BE_PREFERRED ?
> 
> It's not really clear to me what you intend to do this - if it's really
> support flags then you really should name those better.
> 
This is support flags and it used by the driver to intimate driver 
supported frame type
for the BTCOEX to cfg like "wiphy_wowlan_support_flags" implementation.
Please suggest if this is ok ? I will be thankful if you can suggest a 
better one if this is not ok
"WIPHY_BTCOEX_SUPPORTS_BE"

>> > > +/**
>> > > + * enum wiphy_btcoex_priority - BTCOEX priority level
>> > > + *	This enum defines priority level for BTCOEX
>> > > + * WIPHY_WLAN_PREFERRED_LOW - low priority frames over BT
>> > > traffic
>> > > + * WIPHY_WLAN_PREFERRED_HIGH - high priority frames over BT
>> > > traffic
>> > > + */
>> > > +
>> > > +enum wiphy_btcoex_priority {
>> > > +	WIPHY_WLAN_PREFERRED_LOW = false,
>> > > +	WIPHY_WLAN_PREFERRED_HIGH = true,
>> > > +};
>> >
>> > That false/true seems just strange.
>> >
>> 
>> I will just use as a enum without assigning false/true.
> 
> What do you even need this enum for though?
> 
Ok. I will directly assign true for the flag.

>> > > +enum nl80211_btcoex_priority {
>> > > +	__NL80211_WLAN_PREFERRED_INVALID,
>> > > +	NL80211_WLAN_BE_PREFERRED,
>> > > +	NL80211_WLAN_BK_PREFERRED,
>> > > +	NL80211_WLAN_VI_PREFERRED,
>> > > +	NL80211_WLAN_VO_PREFERRED,
>> > > +	NL80211_WLAN_BEACON_PREFERRED,
>> > > +	NL80211_WLAN_MGMT_PREFERRED,
>> > > +	__NL80211_WLAN_PREFERRED_LAST,
>> > > +	NL80211_WLAN_PREFERRED_MAX =
>> > > +			__NL80211_WLAN_PREFERRED_LAST - 1,
>> > > +};
>> >
>> > Wouldn't a bitmap be easier?
>> >
>> since this is to distinguish between different btcoex priorities and
>> we 
>> are not going to do any manipulations on these parameters.
>> It is just used as flag attribute.
> 
> But why the (parsing) complexity, when a single bitmap would do?
> 
Do you mean to say, sending a value from user space and parse that in 
the driver?
