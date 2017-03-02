Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35310 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754066AbdCBOkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 09:40:12 -0500
Message-ID: <58B82B8F.2020603@candelatech.com> (sfid-20170302_154027_613466_9B9DB94E)
Date: Thu, 02 Mar 2017 06:26:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>  <1487918197.2540.1.camel@sipsolutions.net>      <03ca5a0f-0ab0-76a4-06f3-ead61ab73c94@candelatech.com> <1488443884.8390.4.camel@sipsolutions.net>
In-Reply-To: <1488443884.8390.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/2017 12:38 AM, Johannes Berg wrote:
> On Mon, 2017-02-27 at 12:48 -0800, Ben Greear wrote:
>> On 02/23/2017 10:36 PM, Johannes Berg wrote:
>>>
>>>
>>>> +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
>>>> +			       HWSIM_CMD_NOTIFY);
>>>
>>> I think you should use a more specific command name.
>>>
>>>> +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
>>>> +		    ETH_ALEN, data->addresses[1].addr))
>>>> +		goto nla_put_failure;
>>>
>>> and at least also add a more specific identifier like the radio ID.
>>>
>>>> +	if (data->channel)
>>>> +		center_freq = data->channel->center_freq;
>>>> +
>>>> +	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, center_freq))
>>>> +		goto nla_put_failure;
>>>
>>> and have the full channel definition
>>
>> You want chandef.center_freq1,
>> 	 chandef.center_freq2,
>> 	 chandef.width?
>>
>>
>> Anything else?
>
> The control channel center_freq is already there so that should be the
> full chandef. I guess center_freq2 should be conditional on being non-
> zero.

I posted a new patch series a day or two ago...please let me know
if that looks right to you.  I un-conditionally included freq2, but
I think that is cleaner code all around.  Still, I'll make it conditional
if that is important to you.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
