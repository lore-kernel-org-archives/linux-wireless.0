Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54876 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdB0VBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 16:01:07 -0500
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
 <1487918197.2540.1.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <18699231-6ea2-5209-a384-d8f2c2adcdb9@candelatech.com> (sfid-20170227_220146_257870_6CCDAC0A)
Date: Mon, 27 Feb 2017 13:00:13 -0800
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
>
>
> Also the indentation in the documentation didn't match the convention
> used there.

Looks like there are two conventions used (see HWSIM_CMD_TX_INFO_FRAME,
and HWSIM_CMD_NEW_RADIO).  I guess you want it indented like the NEW_RADIO
command?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
