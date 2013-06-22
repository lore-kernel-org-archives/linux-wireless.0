Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44073 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3FVPYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 11:24:31 -0400
Message-ID: <51C5C1AB.9050303@candelatech.com> (sfid-20130622_172438_049623_211DD306)
Date: Sat, 22 Jun 2013 08:24:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] wireless:  Add memory usage debugging.
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com> <87fvwa1qoh.fsf@purkki.adurom.net>
In-Reply-To: <87fvwa1qoh.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2013 01:43 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The bss objects are reference counted, and the ies
>> are also tricky to keep track of.  Add option to
>> track allocation and freeing of the ies and bss objects,
>> and add debugfs files to show the current objects.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> [...]
>
>> +config CFG80211_MEM_DEBUGGING
>> +	bool "cfg80211 memory debugging logic"
>> +	default n
>> +	depends on CFG80211_DEBUGFS
>> +	---help---
>> +	  Enable this if you want to debug memory handling for bss and ies
>> +	  objects.  New debugfs files: ieee80211/all_ies and all_bss will
>> +	  be created to display these objects.  This has a moderate CPU cost
>> +	  and uses a bit more memory than normal, but otherwise is not very
>> +	  expensive.
>> +
>> +	  If unsure, say N.
>
> IMHO having a new Kconfig option is overkill. Can we use something more
> generic, like CFG80211_DEVELOPER_WARNINGS, for this?

That would be fine with me.  It does cause some extra list walkings and
memory usage, so I wasn't sure it should go in by default.

Unless we are actually leaking things, the lists should remain relatively
short, and probably not walked all *that* often, so maybe it would be OK....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

