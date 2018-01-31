Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44165 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753276AbeAaV6F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:58:05 -0500
Received: by mail-pg0-f67.google.com with SMTP id m20so11176470pgc.11
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 13:58:05 -0800 (PST)
Subject: Re: [PATCH 5/6] nl80211: Implement TX of control port frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180131213329.25322-1-denkenz@gmail.com>
 <20180131213329.25322-6-denkenz@gmail.com>
 <1517435621.2189.67.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <e8e2aeba-edd3-30f6-3960-0578ae127336@gmail.com> (sfid-20180131_225809_769854_0AD6C4F0)
Date: Wed, 31 Jan 2018 15:58:03 -0600
MIME-Version: 1.0
In-Reply-To: <1517435621.2189.67.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 01/31/2018 03:53 PM, Johannes Berg wrote:
> 
>> +static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +	struct net_device *dev = info->user_ptr[1];
>> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
>> +	const u8 *buf;
>> +	size_t len;
>> +	u8 *dest;
>> +	u16 proto;
>> +	bool noencrypt;
>> +	int err;
>> +
>> +	if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> +				     NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (!rdev->ops->tx_control_port)
>> +		return -EOPNOTSUPP;
> 
> I wonder if maybe we should accept this command only from the socket
> owner? Is there a use case for something else?

Yes I thought about adding such a check as I think it wouldn't make 
sense to accept control port frames from any other application besides 
the socket owner.  However the socket owner stuff was a bit 
controversial, so I left it out.

I would support adding this check...

> 
> Actually, then again, that's awkward because doing events and commands
> on the same socket doesn't mix all _that_ well. Perhaps we just need to
> fix that problem in libnl or something and be done with it ...
> 
There are no issues on our side..

Regards,
-Denis
