Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34494 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1954495AbdDZIqr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:46:47 -0400
Received: by mail-wr0-f182.google.com with SMTP id l9so19284371wre.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 01:46:46 -0700 (PDT)
Subject: Re: [PATCH V3 1/9] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
 <1492776308-15120-2-git-send-email-arend.vanspriel@broadcom.com>
 <1493149747.15192.0.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3ce6aed5-7d00-3446-a39b-b5da4b788358@broadcom.com> (sfid-20170426_104653_570323_BD41AD7F)
Date: Wed, 26 Apr 2017 10:46:43 +0200
MIME-Version: 1.0
In-Reply-To: <1493149747.15192.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/25/2017 9:49 PM, Johannes Berg wrote:
> 
>>   		if (schedule_destroy_work) {
>> -			struct cfg80211_iface_destroy *destroy;
>> +			struct cfg80211_nlport_release *destroy;
>>   
>>   			destroy = kzalloc(sizeof(*destroy),
>> GFP_ATOMIC);
> 
> I was never really happy with this allocation and really want to get
> rid of it ...

Agree. I don't like the allocation overhead either for deferred 
processing in another context.

>> +		if (schedule_sched_stop_work) {
>> +			struct cfg80211_nlport_release *destroy;
>> +
>> +			destroy = kzalloc(sizeof(*destroy),
>> GFP_ATOMIC);
>> +			if (destroy) {
>> +				destroy->nlportid = notify->portid;
>> +				spin_lock(&rdev-
>>> sched_stop_list_lock);
>> +				list_add(&destroy->list, &rdev-
>>> sched_stop_list);
>> +				spin_unlock(&rdev-
>>> sched_stop_list_lock);
>> +				schedule_work(&rdev-
>>> sched_scan_stop_wk);
>> +			}
>> +		}
> 
> Can't we set some kind of flag in the struct
> cfg80211_sched_scan_request and iterate through them later again,
> checking which need to be destroyed?

Sure. In the worker we are already iterating so I guess we could. The 
number of internal fields in struct cfg80211_sched_scan_request with one 
of them being the list_head. Thinking about hiding those from the 
drivers. Is it worth it?

Regards,
Arend
