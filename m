Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38410 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdBAR5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 12:57:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 01 Feb 2017 23:27:18 +0530
From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 1/2] cfg80211: Add support to set tx power for a
 station associated
In-Reply-To: <2b68dc12-44bf-f510-339a-3d987a88e8b5@candelatech.com>
References: <1485888101-23454-1-git-send-email-arnagara@qti.qualcomm.com>
 <12efc3d8-2274-a6e8-6d74-c06bf89762fb@candelatech.com>
 <14f6b3acb8b26d0eb806148c0ee47fb0@codeaurora.org>
 <2b68dc12-44bf-f510-339a-3d987a88e8b5@candelatech.com>
Message-ID: <1f3a3dec67fbe4f580750eb06f9b628b@codeaurora.org> (sfid-20170201_185821_761211_A762F11C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-01 23:06, Ben Greear wrote:
> On 02/01/2017 09:27 AM, Ashok Raj Nagarajan wrote:
> 
>>>> +static int nl80211_parse_sta_txpower_setting(struct genl_info 
>>>> *info,
>>>> +                         struct station_parameters *params)
>>>> +{
>>>> +    struct cfg80211_registered_device *rdev = info->user_ptr[0];
>>>> +    enum nl80211_tx_power_setting type;
>>>> +    int idx;
>>>> +
>>>> +    if (!rdev->ops->set_tx_power ||
>>>> +        !wiphy_ext_feature_isset(&rdev->wiphy,
>>>> +                     NL80211_EXT_FEATURE_STA_TX_PWR))
>>>> +        return -EOPNOTSUPP;
>>> 
>>> Maybe always let a user set to default value even if the driver does 
>>> not
>>> support setting specific values?
>>> 
>> 
>> IMHO, having some default value in place of non-valid values may not 
>> be the right way.
> 
> If a user or user-space script wants to always be able to initialize
> things to default
> values, it would be nice if it did not have to pay specific attention
> to whether the
> NIC supports STA_TX_PWR feature or not.  Since a NIC that does not
> support this feature will always
> have sta TX power set to default by definition, that is why I think
> you should let
> the call succeed in that case.
> 

I think it would be better/easier to handle the error cases in the 
user-space scripts than at the driver here, no? NIC that doesn't support 
this feature will set the tx power to the station depending on the rate 
algorithm in place. So the same NIC and same station will have different 
txpower depending on the environment? On the other hand, how do we 
decide what constant (?) default value to be sent to userspace?

Thanks,
Ashok

> Thanks,
> Ben
