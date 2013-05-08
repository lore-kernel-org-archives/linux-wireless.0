Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:37188 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3EHIos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 04:44:48 -0400
Message-ID: <518A1076.6010006@windriver.com> (sfid-20130508_104459_856910_ED6E8313)
Date: Wed, 8 May 2013 16:44:38 +0800
From: wyang1 <Wei.Yang@windriver.com>
Reply-To: <Wei.Yang@windriver.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <wei.wyang@windriver.com>
Subject: Re: [PATCH] mac80211: refine ieee80211_rx() context requirement
References: <1368001892-18068-1-git-send-email-Wei.Yang@windriver.com> <1368002161.8279.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1368002161.8279.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2013 04:36 PM, Johannes Berg wrote:
> On Wed, 2013-05-08 at 16:31 +0800, Wei.Yang@windriver.com wrote:
>> From: Wei Yang <Wei.Yang@windriver.com>
>>
>> In case of RT kernel, the return value of softirq_count() always
>> equal to 0, we need to use in_serving_softirq to decide whether
>> the current context is in softirq context.
>> -	WARN_ON_ONCE(softirq_count() == 0);
>> +	WARN_ON_ONCE(!in_serving_softirq());
> As I understand the code, I don't believe this change to be correct. The
> function can happily run with softirqs disabled (e.g.
> local_bh_disable()), for example by being called via ieee80211_rx_ni().
> As I understand in_serving_softirq(), it checks that it's actually
> inside handling a softirq, no?

Yes, I am not an expert on wireless, so I am not sure whether 
ieee80211_rx will be called with softirqs disabled.
Just as you said, if it can run with softirqs diabled, the fix is not 
correct. sorry for it.

Thanks
Wei
>
> johannes
>
>
>

