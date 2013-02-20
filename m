Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40109 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935366Ab3BTOJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 09:09:35 -0500
Message-ID: <5124D90E.7070307@candelatech.com> (sfid-20130220_150939_696408_CF065AFE)
Date: Wed, 20 Feb 2013 06:09:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>  (sfid-20130220_031220_995074_BF5628B4) <1361354394.8629.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361354394.8629.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 01:59 AM, Johannes Berg wrote:
>
>> In addition, re-order the quiesce code so that timers are
>> always stopped before work-items are flushed.  This was
>> not the problem I saw, but I think it may still be more
>> correct.
>
> I'd prefer this to be a separate patch, and then might not apply that
> one for 3.9


>> @@ -2668,6 +2681,10 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
>>   			       false, frame_buf);
>>   	mutex_unlock(&ifmgd->mtx);
>>
>> +	/* Have to do this outside the ifmgd->mtx lock. */
>> +	cancel_work_sync(&ifmgd->monitor_work);
>> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
>
> OTOH, you do this many many times, and that doesn't seem necessary...
>
> If the work structs run when we disconnected, that's ok, they just
> musn't run after we destroy the interface, so I think it'd be much
> better to just put the two lines into ieee80211_mgd_stop() instead of
> all the other places.

Ok, that sounds promising to me.  For that matter, could we just call the sta_quiesce
method in mgd_stop?  It would be nice to have all of the final timer and work-queue cleanup
in a single place.

And, maybe add some checks in the work-callback methods to bail early if the station
isn't connected?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

