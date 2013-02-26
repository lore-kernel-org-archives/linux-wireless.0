Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47031 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab3BZQvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 11:51:36 -0500
Message-ID: <512CE816.6090000@candelatech.com> (sfid-20130226_175139_774935_A1CF211B)
Date: Tue, 26 Feb 2013 08:51:34 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com> <20130225102020.GA1735@redhat.com> <512B9799.6000708@candelatech.com> <20130226155537.GA1486@redhat.com>
In-Reply-To: <20130226155537.GA1486@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2013 07:55 AM, Stanislaw Gruszka wrote:
> On Mon, Feb 25, 2013 at 08:55:53AM -0800, Ben Greear wrote:
>> On 02/25/2013 02:20 AM, Stanislaw Gruszka wrote:
>>> On Tue, Feb 19, 2013 at 06:11:07PM -0800, greearb@candelatech.com wrote:
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> The monitor_work and beacon_connection_loss_work items were
>>>> not being canceled on disassociation (and not on deletion
>>>> either).  This leads to work-items trying to run after memory
>>>> has been deleted.
>>>>
>>>> I could not find a cleaner way to do this because the
>>>> cancel_work_sync for these items must be done outside
>>>> of the ifmgd->mtx.
>>>>
>>>> In addition, re-order the quiesce code so that timers are
>>>> always stopped before work-items are flushed.  This was
>>>> not the problem I saw, but I think it may still be more
>>>> correct.
>>>
>>> I think this patch is quite complicated and simpler solution
>>> can be used. We stop timers on disassociate, and since
>>
>> I think my second patch was closer to what you have...
>
> Yes, I see, I missed your second patch.
>
>>> +	/*
>>> +	 * We canceled timers during disassoc, but works still can be pending.
>>> +	 * Even if we they do not perform action when unassociated, we should
>>> +	 * assure we stop them, before freeing resources.
>>> +	 */
>>
>> The comment is a bit misleading....as I saw in my testing, it could actually
>> crash the system because the entire station could be deleted by the time
>> the work-item tries to complete.
>
> Not sure if I understand. If I did not missed something, all works callbacks
> check ifmgd->associated pointer and quit instantly if it is null. So as long
> we do not free sdata, is fine to have them pending after disassociate.

Right, but in the old code, there is nothing to keep you from
freeing sdata with work still pending.  Thus the crash I saw.


> However we should use ifmgd->mtx to protect ifmgd->associated and
> ifmgd->bssid in ieee80211_beacon_connection_loss_work()

Maybe so...I haven't looked at that code in any detail.

Thanks,
Ben

>
> Stanislaw
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

