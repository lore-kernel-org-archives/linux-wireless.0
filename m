Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35018 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933007AbdDZSSU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 14:18:20 -0400
Received: by mail-qt0-f170.google.com with SMTP id y33so7790764qta.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 11:18:20 -0700 (PDT)
Subject: Re: [PATCH V3 4/9] cfg80211: add request id to
 cfg80211_sched_scan_*() api
To: Johannes Berg <johannes@sipsolutions.net>
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
 <1492776308-15120-5-git-send-email-arend.vanspriel@broadcom.com>
 <1493190994.2464.3.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ca0b7756-7c48-9415-75b1-0ca8b321bac8@broadcom.com> (sfid-20170426_201824_755163_8FEE8E54)
Date: Wed, 26 Apr 2017 20:18:16 +0200
MIME-Version: 1.0
In-Reply-To: <1493190994.2464.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-4-2017 9:16, Johannes Berg wrote:
> On Fri, 2017-04-21 at 13:05 +0100, Arend van Spriel wrote:
>> Have proper request id filled in the SCHED_SCAN_RESULTS and
>> SCHED_SCAN_STOPPED notifications toward user-space by having the
>> driver provide it through the api.
>>
>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.co
>> m>
>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> 
> All your reviewers aren't paying attention ;-)
> 
>> @@ -1722,6 +1723,7 @@ struct cfg80211_sched_scan_request {
>>  	struct cfg80211_bss_select_adjust rssi_adjust;
>>  
>>  	/* internal */
>> +	struct work_struct results_wk;
>>  	struct wiphy *wiphy;
>>  	struct net_device *dev;
>>  	unsigned long scan_start;
> 
> Superficially, this is fine - but you need to think hard about the
> semantics of when you cancel this work.
> 
>> +++ b/net/wireless/scan.c
>> @@ -369,15 +369,13 @@ void __cfg80211_sched_scan_results(struct
>> work_struct *wk)
>>  	struct cfg80211_registered_device *rdev;
>>  	struct cfg80211_sched_scan_request *request;
>>  
>> -	rdev = container_of(wk, struct cfg80211_registered_device,
>> -			    sched_scan_results_wk);
>> +	request = container_of(wk, struct
>> cfg80211_sched_scan_request, results_wk);
>> +	rdev = wiphy_to_rdev(request->wiphy);
>>  
>>  	rtnl_lock();
>>  
>> -	request = cfg80211_find_sched_scan_req(rdev, 0);
>> -
>>  	/* we don't have sched_scan_req anymore if the scan is
>> stopping */
> 
> That comment is kinda wrong now, afaict? Also you return 
> 
>> -	if (!IS_ERR(request)) {
>> +	if (request) {
> 
> This seems wrong - you do return an ERR_PTR() from find. Not that
> there's all that much point in doing so vs. returning NULL, might be
> worth cleaning it up.

Indeed. Not sure if it was me being sloppy/confused or due to rebasing
the patches. Anyway, I will fix this.

>> -void cfg80211_sched_scan_results(struct wiphy *wiphy)
>> +void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid)
>>  {
>> -	struct cfg80211_registered_device *rdev =
>> wiphy_to_rdev(wiphy);
>>  	struct cfg80211_sched_scan_request *request;
>>  
>> -	trace_cfg80211_sched_scan_results(wiphy);
>> +	trace_cfg80211_sched_scan_results(wiphy, reqid);
>>  	/* ignore if we're not scanning */
>>  
>>  	rtnl_lock();
>> -	request = cfg80211_find_sched_scan_req(rdev, 0);
>> +	request = cfg80211_find_sched_scan_req(wiphy_to_rdev(wiphy),
>> reqid);
>>  	rtnl_unlock();
>>  
>>  	if (!IS_ERR(request))
>> -		queue_work(cfg80211_wq,
>> -			   &wiphy_to_rdev(wiphy)-
>>> sched_scan_results_wk);
>> +		queue_work(cfg80211_wq, &request->results_wk);
>> +	else
>> +		wiphy_err(wiphy, "reqid %llu not found\n", reqid);
>>  }
> 
> This seems problematic - you use the request pointer outside the
> locking now. I'd move that rtnl_unlock() to afterwards. The message
> could also mention sched scan, that might be useful. Although I suspect
> that may happen due to races (e.g. netlink socket close vs. firmware
> stop) so maybe it's not all that useful.

When adding the worker in the request I was thinking about what might
happen between the queue_work and the work actually being scheduled.

> Most importantly though, you don't protect against queuing the work
> here, and then deleting the request. In the old case the comment that I
> pointed out above will save us, but in this new case it can't (the
> comment is now wrong), and that's a problem.
> 
> I looked briefly at this and I suspect it will be very hard to fix that
> with a per-request work struct. It might be better to have a per-work
> status flag that you set here, then you schedule the global work, and
> that global work will send all the appropriate result messages after
> clearing the status bit again, similar to what I did with the netlink
> destroy now.

I guess it is in you repo as I did not see anything related on the
mailing list. So regarding this rework, do you want me to send the
series again or just this patch?

Regards,
Arend
