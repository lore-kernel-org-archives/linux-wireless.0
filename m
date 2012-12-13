Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35539 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab2LMSaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:30:18 -0500
Message-ID: <50CA1EB6.9030903@candelatech.com> (sfid-20121213_193022_391865_9123F59F)
Date: Thu, 13 Dec 2012 10:30:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Add a new work-queue for destructing stations?
References: <50CA1470.4030107@candelatech.com>   (sfid-20121213_184629_945929_240FAE82) <1355421541.9463.8.camel@jlt4.sipsolutions.net>  <50CA1C44.5030300@candelatech.com> <1355423047.9463.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355423047.9463.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 10:24 AM, Johannes Berg wrote:
> On Thu, 2012-12-13 at 10:19 -0800, Ben Greear wrote:
>
>>> I don't think that's easy, but you're welcome to try. The
>>> free_sta_work() function references the sdata so it absolutely must run
>>> at this point.
>
>> So, cancel_work_sync(&sdata->work) would appear to remove
>> all pending sdata->work items from the work-queue.  As long as
>> there are no other different work items that reference
>> sdata (and maybe there are..I haven't looked at all of them),
>> then we should be safe to execute the free_sta_work()
>> on a different work-queue safely, I think....
>
> Sorry, I don't get it. free_sta_work() *itself* has to be executed
> before the sdata is destroyed. cancel_work_sync(&sdata->work) has
> nothing to do with free_sta_work.

My concern is this:

If I add a different work queue (called destructor-workqueue, perhaps)
for free_sta_work(), then it only helps
if I can not block on flushing the current 'big' work-queue.  But, if
there are items on the big work-queue that reference sdata, then
that could easily execute after free_sta_work(), and I'm guessing
that would be very bad.

So, near where we currently call cancel_work_sync(&sdata->work), I
think we'd also need to cancel things like the sta->ampdu_mlme.work,
and probably others as well.

Then, when we're sure there are no more references to sdata on the
main-work-queue, it would be safe to flush the destructor-workqueue
(which would have the fre_sta_work() on it).

Maybe?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

