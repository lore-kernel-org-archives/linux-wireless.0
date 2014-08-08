Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53566 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaHHPmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 11:42:07 -0400
Message-ID: <53E4EFCB.5090501@candelatech.com> (sfid-20140808_174211_937886_9BC40373)
Date: Fri, 08 Aug 2014 08:42:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com> <87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2014 02:06 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>> I'm working on a patch to report the stats seen in debugfs/...ath10k/fw_stats
>> as ethtool stats, somewhat similar to how ath9k does it.
>>
>> I notice that my user-space tool is reporting huge numbers because
>> the stats are reset to zero when firmware restarts, and so my tool
>> thinks the stats wrapped.
>>
>> I can fix my tool easily enough, but I first wanted to see if
>> anyone had strong feelings about keeping the stats from resetting
>> to zero by storing history and calculating diffs in the driver.
>>
>> I think my preference is to punt this to user-space, but if
>> someone feels otherwise, please let me know sooner than later.
> 
> I also prefer to have this in user space, but how does user space know
> when the stats have been zeroed?

Poll often enough that it cannot increment more than 2 billion (or other large number)
between polls, and then if polled value is less than previous (and difference is > 2 billion),
we know we had a reset and not a wrap.

User-space stats will not be perfect in the case of firmware resets, or resets
after the 'large number', but nothing is going to make it perfect, and in
practice, this seems good enough.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

