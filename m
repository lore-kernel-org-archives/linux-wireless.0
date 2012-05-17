Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38732 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761033Ab2EQVoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 17:44:01 -0400
Message-ID: <4FB5711C.1050207@candelatech.com> (sfid-20120517_234405_562698_BB654388)
Date: Thu, 17 May 2012 14:43:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix memory leak/corruption of bss_list
References: <1337270768-22719-1-git-send-email-eliad@wizery.com> <1337284032.4687.1.camel@jlt3.sipsolutions.net> <CAB3XZEcWGYAsPpuxs7Fs3a5c8ufkJOeEpJ3FgWyWttos6dYdKQ@mail.gmail.com>
In-Reply-To: <CAB3XZEcWGYAsPpuxs7Fs3a5c8ufkJOeEpJ3FgWyWttos6dYdKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2012 02:34 PM, Eliad Peller wrote:
> On Thu, May 17, 2012 at 10:47 PM, Johannes Berg
> <johannes@sipsolutions.net>  wrote:
>> On Thu, 2012-05-17 at 19:06 +0300, Eliad Peller wrote:
>>> cfg80211_dev_free() calls cfg80211_put_bss() directly on all
>>> the remaining bss entries, skipping the proper bss entry
>>> cleanup that usually made by __cfg80211_unlink_bss(), and
>>> leaving the bss_list and the rb_tree with dangling pointers.
>>
>>>        list_for_each_entry_safe(scan, tmp,&rdev->bss_list, list)
>>> -             cfg80211_put_bss(&scan->pub);
>>> +             cfg80211_unlink_bss(&rdev->wiphy,&scan->pub);
>>>        kfree(rdev);
>>
>> I don't see why we care, we free rdev anyway.
>>
> yeah, you have a point here...
>
> we got a crash report for an older kernel with some custom patches,
> that indicated a possible write-after-free on the bss release. i was
> probably too rushed to blame this code.

Ahhh, as luck would have it..we saw a crash today (in a hacked 3.3.4) that could
be explained by a stale bss reference, so I was all excited by your patch,
thinking I didn't have to go looking for the bug :)

My crash was in an older version of the ethtool-stats logic,
so it could just be my bug, as well....

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

