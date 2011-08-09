Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44175 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1HIN1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 09:27:38 -0400
Message-ID: <4E4135C4.4020607@candelatech.com> (sfid-20110809_152742_240319_E81A1BA4)
Date: Tue, 09 Aug 2011 06:27:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>	 <1311607763-12603-3-git-send-email-eliad@wizery.com>	 <4E2DA564.5070305@candelatech.com> <1312892091.4109.27.camel@jlt3.sipsolutions.net>
In-Reply-To: <1312892091.4109.27.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2011 05:14 AM, Johannes Berg wrote:
> On Mon, 2011-07-25 at 10:18 -0700, Ben Greear wrote:
>> On 07/25/2011 08:29 AM, Eliad Peller wrote:
>>> The hw is currently not configured when going
>>> back on-channel.
>>
>> I am less sure about this patch.  With the existing code,
>> I think it should catch going from on channel to off
>> and do the hw config properly.
>>
>> With your change it will also reconfig the hardware, but it will
>> reconfig even if we were already on-channel (if, for instance,
>> local->tmp_channel is oper-channel), right?
>
> I think even if we're already on the same channel, we might still have
> the off-channel flag (IEEE80211_CONF_OFFCHANNEL) set? So the patch might
> still be needed to clear that?

Well, maybe so, but if we are not off-channel and still have the off-channel
flag set, that would seem to be another bug.

Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
