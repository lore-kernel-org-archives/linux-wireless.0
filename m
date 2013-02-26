Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34631 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3BZQzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 11:55:17 -0500
Message-ID: <512CE8F1.7050601@candelatech.com> (sfid-20130226_175528_191863_62BAE365)
Date: Tue, 26 Feb 2013 08:55:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211:  Fix crash due to un-canceled work-items.
References: <1361382069-31729-1-git-send-email-greearb@candelatech.com> <1361382069-31729-2-git-send-email-greearb@candelatech.com> <20130226160536.GC5256@redhat.com>
In-Reply-To: <20130226160536.GC5256@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2013 08:05 AM, Stanislaw Gruszka wrote:
> On Wed, Feb 20, 2013 at 09:41:09AM -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The monitor_work and beacon_connection_loss_work items were
>> not being canceled on disassociation (and not on deletion
>> either).  This leads to work-items trying to run after memory
>> has been deleted.
> [skip]
>>
>> +	/* Make sure some work items will not run after this.
>> +	 * Have to do this outside the ifmgd->mtx lock.
>> +	 */
>> +	cancel_work_sync(&ifmgd->monitor_work);
>> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
>
> Other works should be canceled as well. Ben, could you repost
> this patch with proper comment?

At least in 3.7 kernel, this seems to be all that is needed.

I don't have much time to work on this now...

Thanks,
Ben

>
> Stanislaw
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

