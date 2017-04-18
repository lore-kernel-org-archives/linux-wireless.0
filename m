Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34296 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdDRTO7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 15:14:59 -0400
Received: by mail-pg0-f50.google.com with SMTP id s64so868447pgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Apr 2017 12:14:59 -0700 (PDT)
Subject: Re: [PATCH V2 02/10] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
 <1492085196-4574-3-git-send-email-arend.vanspriel@broadcom.com>
 <1492505589.2472.2.camel@sipsolutions.net>
 <1492505735.2472.3.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ae245fa9-8415-5f23-f0c7-a4f95680bc3a@broadcom.com> (sfid-20170418_211502_996440_D64EAB73)
Date: Tue, 18 Apr 2017 21:14:51 +0200
MIME-Version: 1.0
In-Reply-To: <1492505735.2472.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 4/18/2017 10:55 AM, Johannes Berg wrote:
> On Tue, 2017-04-18 at 10:53 +0200, Johannes Berg wrote:
>> Hi Arend,
>>
>> Overall this looks good, and I've almost applied it - but I have a
>> question on this patch.
>>
>> You have this list:
>>
>>> +	struct list_head sched_scan_req_list;
>>>   	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
>>
>> but you kept this. In fact, it's even still *used*. I don't
>> understand
>> that part.
>>
>> Also, you used RCU primitives for the new list, but you never
>> actually
>> used them - except in one place (in nl80211_stop_sched_scan) where
>> it's
>> actually not needed at all and the _rcu should be removed (since it
>> holds the lock)
>>
>> What's up with that?
> 
> Actually, I think I see what's up - you simply forgot to remove the
> sched_scan_req member, and then didn't realize that it was still used
> in nl80211_netlink_notify(), and that's the place that *does* need the
> RCU stuff.

Yes. Sorry for screwing it up. Will rebase the series and fix it.

Regards,
Arend
