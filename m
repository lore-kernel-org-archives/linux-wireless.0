Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35344 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbcFCQq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:46:57 -0400
Subject: Re: [PATCH 2/2] ath10k: remove 10.1 firmware support
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
 <20160603153328.11947-2-rmanohar@qti.qualcomm.com>
 <5751A6D5.7080901@candelatech.com>
 <743182bcbd1efbdb576bcc51b0215300@codeaurora.org>
 <87shwuuuct.fsf@kamboji.qca.qualcomm.com> <5751AE44.8050607@candelatech.com>
 <87oa7iut9x.fsf@kamboji.qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5751B480.2060106@candelatech.com> (sfid-20160603_184700_390103_9DB5E8ED)
Date: Fri, 3 Jun 2016 09:46:56 -0700
MIME-Version: 1.0
In-Reply-To: <87oa7iut9x.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2016 09:33 AM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>>>> Is it possible to upgrade CT firmware to 10.2 WMI/HTT interfaces?
>>>
>>> That's a good idea. That shouldn't be too hard, right? I don't think HTT needs
>>> any changes, but for WMI few commands and ids need to be changed.
>>
>> I was thinking the 10.2 mgt-over-htt API would be trouble-some to make work on
>> 10.1 firmware.
>
> Yeah, that would be harder. But I don't see Rajkumar removing support
> for that (yet) or am I missing something?

What I mean is that to just make my 10.1 firmware act like 10.2 would require
my 10.1 to suddenly support 10.2's mgt-over-htt.  I think that will be difficult,
and there is plenty of risk that some subtle WMI change would cause hard-to-detect
bugs.

I have done an initial port of my 10.1 changes to 10.2, it is just that the
result is poor, and so I quit messing with 10.2 and re-focussed on 10.1
for the time being.

Another way to help with this problem in general is to quit adding so many
new firmware API.  It is a lot easier to make a new firmware backwards compat
than it is to make an old firmware forwards compat.  When you are designing your
WMI changes in new firmware, do it with care, and then you can reuse the vast bulk
of your driver.  I managed to add quite a few new features to my 10.1 in this
manner, and the driver patches (mostly keyed off of feature flags) are not that
invasive.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

