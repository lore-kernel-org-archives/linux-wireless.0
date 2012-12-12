Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43347 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2LLWMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:12:00 -0500
Message-ID: <50C9012C.9000108@candelatech.com> (sfid-20121212_231212_699524_624A411B)
Date: Wed, 12 Dec 2012 14:11:56 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/6] mac80211: Check for NULL in get-ethtool-stats logic.
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>  <1355349295-30960-3-git-send-email-greearb@candelatech.com>  (sfid-20121212_225626_327122_3F8FF5FB) <1355349772.9708.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355349772.9708.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2012 02:02 PM, Johannes Berg wrote:
> On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> In an earlier version of this code, testing found that sometimes
>> either sta wasn't found or sta->sdata was NULL.  This caused
>> crashes of course.  So, add checks with WARN_ON_ONCE to
>> catch these.
>
> I don't know what you tested, but there's absolutely no way that
> sta->sdata is NULL... *Especially* not after sta_info_get_bss(), I mean,
> look at that function. But once it's on the list it can't be NULL, so
> I'm not going to apply this patch.
>
> In the future, I'd appreciate if you could avoid avoid sending patches
> for drivers and mac80211 etc. in one series, it gets confusing with who
> applies what etc.

Ok, it was quite a while ago..maybe I was hitting other upstream bugs or
bugs of my own.

For what it's worth, I haven't noticed my WARN_ON hitting.

I'll drop this patch from my tree.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

