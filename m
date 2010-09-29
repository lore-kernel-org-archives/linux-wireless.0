Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44321 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab0I2SLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:11:36 -0400
Message-ID: <4CA38155.90306@candelatech.com>
Date: Wed, 29 Sep 2010 11:11:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211:  Don't go off-channel in work_work unless
 needed.
References: <1285783383-20822-1-git-send-email-greearb@candelatech.com>	 <1285783383-20822-2-git-send-email-greearb@candelatech.com> <1285783598.3756.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285783598.3756.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 11:06 AM, Johannes Berg wrote:
> On Wed, 2010-09-29 at 11:03 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> If the work to be done is on the current active channel, then
>> do not call the offchannel and return-to-channel logic.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>> :100644 100644 ae344d1... 1f2673d... M	net/mac80211/work.c
>>   net/mac80211/work.c |   28 ++++++++++++++++++++--------
>>   1 files changed, 20 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
>> index ae344d1..1f2673d 100644
>> --- a/net/mac80211/work.c
>> +++ b/net/mac80211/work.c
>> @@ -873,6 +873,7 @@ static void ieee80211_work_work(struct work_struct *work)
>>   	LIST_HEAD(free_work);
>>   	enum work_action rma;
>>   	bool remain_off_channel = false;
>> +	bool went_off_channel = false;
>
> Heh, this is not going to work ... the return may be done in a separate
> invocation of the function. Would have been nice to test this ;-)

What is a good way to test this?  I brought up several STA interfaces
and an AP and ran traffic..but I guess I need to do something different?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

