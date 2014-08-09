Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21415 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIG1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 02:27:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com>
	<87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
	<53E4EFCB.5090501@candelatech.com>
Date: Sat, 9 Aug 2014 09:27:31 +0300
In-Reply-To: <53E4EFCB.5090501@candelatech.com> (Ben Greear's message of "Fri,
	8 Aug 2014 08:42:03 -0700")
Message-ID: <87zjfeuqi4.fsf@kamboji.qca.qualcomm.com> (sfid-20140809_082744_056399_00409FCE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 08/08/2014 02:06 AM, Kalle Valo wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>> 
>>> I'm working on a patch to report the stats seen in debugfs/...ath10k/fw_stats
>>> as ethtool stats, somewhat similar to how ath9k does it.
>>>
>>> I notice that my user-space tool is reporting huge numbers because
>>> the stats are reset to zero when firmware restarts, and so my tool
>>> thinks the stats wrapped.
>>>
>>> I can fix my tool easily enough, but I first wanted to see if
>>> anyone had strong feelings about keeping the stats from resetting
>>> to zero by storing history and calculating diffs in the driver.
>>>
>>> I think my preference is to punt this to user-space, but if
>>> someone feels otherwise, please let me know sooner than later.
>> 
>> I also prefer to have this in user space, but how does user space know
>> when the stats have been zeroed?
>
> Poll often enough that it cannot increment more than 2 billion (or
> other large number) between polls, and then if polled value is less
> than previous (and difference is > 2 billion), we know we had a reset
> and not a wrap.

That's not very reliable as "less than previous" assumption is not
always true.

> User-space stats will not be perfect in the case of firmware resets, or resets
> after the 'large number', but nothing is going to make it perfect, and in
> practice, this seems good enough.

Yeah, and we can always fix this later if there's a sudden need to get
reliable numbers.

-- 
Kalle Valo
