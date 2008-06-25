Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:55231 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFYUSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 16:18:32 -0400
Received: by rv-out-0506.google.com with SMTP id k40so8362916rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 13:18:32 -0700 (PDT)
Message-ID: <a32f33a40806251318n4f0bac2cs7ada6e23afe0cb6e@mail.gmail.com> (sfid-20080625_221836_249319_5A69EECD)
Date: Wed, 25 Jun 2008 22:18:32 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: Fix lock dependency errror
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1214422400.21847.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806252127.00971.IvDoorn@gmail.com>
	 <1214422400.21847.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
>> index 611d983..73dacbb 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00.h
>> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
>> @@ -821,6 +822,7 @@ struct rt2x00_dev {
>>       /*
>>        * Scheduled work.
>>        */
>> +     struct workqueue_struct *workqueue;
>
> Do you really need a whole workqueue (kernel thread) per device? I would
> think that using schedule_work / cancel_work_sync for this task and keep
> using the mac80211 wq would be sufficient?

True, but this is a quick patch to resolve the bug for sure. I am going to look
into the workqueue handling more closely to see what the impact on splitting
the different work structure over different workqueues is later. I *think* I at
one time made use the assumption that work structures on the same queue
don't run concurrently and I really need to look into that first to see if there
isn't some other locking problem that will appear when I split the work over
2 different queues.

At the moment I am also concerned about the link tuner who runs in the
workqueue and if there isn't any negative side effect regarding the early
flush_workqueue() in mac80211.

Ivo
