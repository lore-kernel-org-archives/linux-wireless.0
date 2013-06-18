Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60452 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3FRPrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:47:52 -0400
Message-ID: <51C08119.3000407@candelatech.com> (sfid-20130618_174801_680944_DCA016E7)
Date: Tue, 18 Jun 2013 08:47:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Lots of confusion on bss refcounting.
References: <51BF5A53.8050100@candelatech.com>   (sfid-20130617_205007_448068_E9E81DD2) <1371495758.8168.3.camel@jlt4.sipsolutions.net>  <51BF5ED4.9010704@candelatech.com> <51BF8040.2000408@candelatech.com>  <51BFAA34.1020407@candelatech.com> <1371559771.8318.12.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371559771.8318.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2013 05:49 AM, Johannes Berg wrote:
> On Mon, 2013-06-17 at 17:30 -0700, Ben Greear wrote:
>> On 06/17/2013 02:31 PM, Ben Greear wrote:
>>> On 06/17/2013 12:09 PM, Ben Greear wrote:
>>>> On 06/17/2013 12:02 PM, Johannes Berg wrote:
>>>
>>>> The bss reference is passed back, and through luck or careful programming,
>>>> it *seems* that all paths related to calling ieee80211_rx_mgmt_assoc_resp
>>>> managed to consume the bss.
>>>>
>>>> I haven't figured out yet why this is not an erroneous put since I didn't
>>>> find the reference taken in the first place.
>>>>
>>>> I'm going to work on making some changes to the ref counting scheme
>>>> a bit.  I'd rather have the code perhaps take and put a few refs
>>>> it might otherwise skip to keep the ownership cleaner and make
>>>> the code easier to debug and understand...
>>>>
>>>> I'll post some for RFC when I make some progress.
>>>
>>> I think I found at least some of the leaks.
>>>
>>> In places like ieee80211_mgd_stop, we were calling ieee80211_destroy_assoc_data,
>>> but it was not putting the bss reference.
>>>
>>> I'll post some RFC patches in a minute or two...first is debugging
>>> logic, second attempts to fix bss ref counting.  This needs more
>>> testing before it is applied...we will continue testing it....
>>
>> It seems that the wdev objects (struct wireless_dev) can also
>> hold a reference to the bss.
>>
>> Do you happen to know what code is responsible for destructing
>> those objects?  I want to check to make sure it properly puts
>> its reference.
>
> You mean ->current_bss? That should be handled in all the callbacks in
> sme.c or so

Looks like much of the action happens on work-queues.  I'm wondering if
we managed to delete wdev objects before we have completely cleaned up
in some cases...

I was planning to add code to explicitly clean up current_bss if it
is not NULL in whatever code actually does the final cleanup for
wdev objects.

I didn't see an obvious cleanup method in sme.c, but will go look around
some more...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

