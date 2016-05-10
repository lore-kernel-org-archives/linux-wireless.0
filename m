Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35431 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbcEJRKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 13:10:13 -0400
Subject: Re: [PATCH] ath10k: Fix 10.4 extended peer stats update
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
References: <1462897645-16219-1-git-send-email-mohammed@qca.qualcomm.com>
 <57320DAF.2040508@candelatech.com>
 <20160510164049.GC21638@atheros-ThinkPad-T61>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <573215F3.3050109@candelatech.com> (sfid-20160510_191018_285718_E239924A)
Date: Tue, 10 May 2016 10:10:11 -0700
MIME-Version: 1.0
In-Reply-To: <20160510164049.GC21638@atheros-ThinkPad-T61>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2016 09:40 AM, Mohammed Shafi Shajakhan wrote:
> On Tue, May 10, 2016 at 09:34:55AM -0700, Ben Greear wrote:
>> On 05/10/2016 09:27 AM, Mohammed Shafi Shajakhan wrote:
>>> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>>>
>>> 10.4 'extended peer stats' will be not be appended with normal peer stats
>>> data and they shall be coming in separate chunks. Fix this by maintaining
>>> a separate linked list 'extender peer stats' for 10.4 and update
>>> rx_duration for per station statistics. Also parse through beacon filter
>>> (if enabled), to make sure we parse the extended peer stats properly.
>>> This issue was exposed when more than one client is connected and
>>> extended peer stats for 10.4 is enabled
>>
>> In general, maybe more of these stats should be kept in the driver instead
>> of the firmware?  The firmware is very tight on RAM already, and if
>> we can pass the needed info back to the host, it could gather arbitrary
>> amounts of stats as needed.
>>
>
> [shafi] agreed, probably thats why we are tracking u64 counters like rx_duration
> etc in host while the firmware variable will wrap aroud in sometime

If firmware could be modified to return more per-frame info, then the driver
could do virtually all of the stats gathering.  It would cost a bit of RAM
to hold that descriptor information, but over-all, the firmware might be a lot
simpler....

On the TX side, it would also allow intelligent host-based rate-ctrl.  Especially
considering the complexity of mu-mimo, it might be nice to get rate-ctrl into the
kernel where more people can work on it in a more flexible manner.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

