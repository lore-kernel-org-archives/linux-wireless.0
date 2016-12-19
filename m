Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51882 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbcLSILg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 03:11:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 19 Dec 2016 13:41:35 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to
 support BTCOEX
In-Reply-To: <1481881024.27953.14.camel@sipsolutions.net>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
 <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
 <1480949353.31788.27.camel@sipsolutions.net>
 <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
 <1481645351.20412.34.camel@sipsolutions.net>
 <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
 <1481881024.27953.14.camel@sipsolutions.net>
Message-ID: <ae82112880d55451342e7a6e5a47c33f@codeaurora.org> (sfid-20161219_091252_937848_9991609E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for your comments.

On 2016-12-16 15:07, Johannes Berg wrote:
>> > > is it fine to have as WIPHY_BTCOEX_BE_PREFERRED ?
>> >
>> > It's not really clear to me what you intend to do this - if it's
>> > really support flags then you really should name those better.
>> >
>> 
>> This is support flags and it used by the driver to intimate driver 
>> supported frame type for the BTCOEX to cfg like
>> "wiphy_wowlan_support_flags" implementation. Please suggest if this
>> is ok ? I will be thankful if you can suggest a  better one if this
>> is not ok "WIPHY_BTCOEX_SUPPORTS_BE"
> 
> Well, I see a few things here:
> 
> 1) does it even make sense to split it out per AC? wouldn't it be weird
> if you supported this only for VO and BK, and not the others, or
> something like that?
> 
It has support for BE, VI, management and beacon frames also.
Or do you meant to say like support only for VO and BK?

> 2) Wouldn't it make more sense to define this in nl80211 and just pass
> the bitmap through to userspace? That would save quite a bit of netlink
> mangling complexity.
> 
Please let me know if the below design/thought is fine to you.

iw phyX set btcoex_priority <[vi, vo, be, bk, mgmt, beacon]>

By this command user should give one or more than one frame types for 
this btcoex priority,
we will parse that in "iw" and send as a single bitmap(less than 0x64) 
to
the driver?

> 3) I think the naming is confusing - "WIPHY_BTCOEX_SUPPORTS_BE_PREF" or
> so might be more appropriate?
> 
If the above suggestion is fine, we may not need these flags.

>> Do you mean to say, sending a value from user space and parse that
>> in  the driver?
> 
> I was more thinking of the capability advertisement, but yeah, both
> ways seems reasonable.
> 
Okay.

Thanks,
Tamizh.
