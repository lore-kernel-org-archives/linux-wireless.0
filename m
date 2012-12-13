Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47733 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2LMSra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:47:30 -0500
Message-ID: <50CA22BC.7090008@candelatech.com> (sfid-20121213_194733_553208_3AA517AD)
Date: Thu, 13 Dec 2012 10:47:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Add a new work-queue for destructing stations?
References: <50CA1470.4030107@candelatech.com>     (sfid-20121213_184629_945929_240FAE82) <1355421541.9463.8.camel@jlt4.sipsolutions.net>    <50CA1C44.5030300@candelatech.com>   <1355423047.9463.9.camel@jlt4.sipsolutions.net>   <50CA1EB6.9030903@candelatech.com>  <1355423836.9463.14.camel@jlt4.sipsolutions.net>  <50CA20D4.90707@candelatech.com> <1355424117.9463.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355424117.9463.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 10:41 AM, Johannes Berg wrote:
> On Thu, 2012-12-13 at 10:39 -0800, Ben Greear wrote:
>
>>>> So, near where we currently call cancel_work_sync(&sdata->work), I
>>>> think we'd also need to cancel things like the sta->ampdu_mlme.work,
>>>> and probably others as well.
>>>>
>>>> Then, when we're sure there are no more references to sdata on the
>>>> main-work-queue, it would be safe to flush the destructor-workqueue
>>>> (which would have the fre_sta_work() on it).
>>>>
>>>> Maybe?
>>>
>>> Huh, ok, but I don't think you'll find much that doesn't reference an
>>> sdata?
>>
>> I think you are right...so just need to find all of those work items
>> and call cancel_work_sync() on them, just like we are currently cancelling
>> the sdata->work....
>
> Well the concern there is that we expose the workqueue to the driver,
> and it might even put sdata-referencing work items on it and expect them
> to be flushed out before stop_interface() is called?
>
> You'd be welcome to change the API so that isn't true, or things are
> different, or whatever, but it'd be a lot of careful auditing (and
> probably fixing) of drivers.

So, maybe a new driver api call to 'cancel_all_work_items(sdata)',
and if the driver does not implement this, then we stick with the
full flush_workqueue() in mac80211_do_stop().  But, if the driver
does implement it, and we add code there to flush any mac80211 related
work-items, then we could skip the flush_workqueue() call....

I'll go looking in ath9k to see how much it uses the work-queue...that
driver is my only real concern at the moment.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

