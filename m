Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54740 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdB0UzK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 15:55:10 -0500
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
 <1487918197.2540.1.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <03ca5a0f-0ab0-76a4-06f3-ead61ab73c94@candelatech.com> (sfid-20170227_215736_235016_4440811B)
Date: Mon, 27 Feb 2017 12:48:59 -0800
MIME-Version: 1.0
In-Reply-To: <1487918197.2540.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2017 10:36 PM, Johannes Berg wrote:
>
>
>> +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
>> +			       HWSIM_CMD_NOTIFY);
>
> I think you should use a more specific command name.
>
>> +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
>> +		    ETH_ALEN, data->addresses[1].addr))
>> +		goto nla_put_failure;
>
> and at least also add a more specific identifier like the radio ID.
>
>> +	if (data->channel)
>> +		center_freq = data->channel->center_freq;
>> +
>> +	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, center_freq))
>> +		goto nla_put_failure;
>
> and have the full channel definition

You want chandef.center_freq1,
	 chandef.center_freq2,
	 chandef.width?


Anything else?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
