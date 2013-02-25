Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46794 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3BYQz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:55:56 -0500
Message-ID: <512B9799.6000708@candelatech.com> (sfid-20130225_175559_797742_8BD87F90)
Date: Mon, 25 Feb 2013 08:55:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com> <20130225102020.GA1735@redhat.com>
In-Reply-To: <20130225102020.GA1735@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2013 02:20 AM, Stanislaw Gruszka wrote:
> On Tue, Feb 19, 2013 at 06:11:07PM -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The monitor_work and beacon_connection_loss_work items were
>> not being canceled on disassociation (and not on deletion
>> either).  This leads to work-items trying to run after memory
>> has been deleted.
>>
>> I could not find a cleaner way to do this because the
>> cancel_work_sync for these items must be done outside
>> of the ifmgd->mtx.
>>
>> In addition, re-order the quiesce code so that timers are
>> always stopped before work-items are flushed.  This was
>> not the problem I saw, but I think it may still be more
>> correct.
>
> I think this patch is quite complicated and simpler solution
> can be used. We stop timers on disassociate, and since

I think my second patch was closer to what you have...

> +	/*
> +	 * We canceled timers during disassoc, but works still can be pending.
> +	 * Even if we they do not perform action when unassociated, we should
> +	 * assure we stop them, before freeing resources.
> +	 */

The comment is a bit misleading....as I saw in my testing, it could actually
crash the system because the entire station could be deleted by the time
the work-item tries to complete.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

