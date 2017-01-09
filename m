Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0069.outbound.protection.outlook.com ([104.47.42.69]:33664
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967072AbdAIOkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 09:40:00 -0500
Subject: Re: [PATCH] cfg80211: size various nl80211 messages correctly
To: Johannes Berg <johannes@sipsolutions.net>
References: <20170109101042.23919-1-johannes@sipsolutions.net>
 <ec9fb205-91ca-9591-0b0b-92672d093395@broadcom.com>
 <1483965571.17582.35.camel@sipsolutions.net>
 <d6a54188-8538-87e4-d0db-95ed11102501@quantenna.com>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        <linux-wireless@vger.kernel.org>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <d8204af4-0ef1-6f18-6fee-276fc215bea4@quantenna.com> (sfid-20170109_154146_040838_6F31CFD0)
Date: Mon, 9 Jan 2017 17:39:14 +0300
MIME-Version: 1.0
In-Reply-To: <d6a54188-8538-87e4-d0db-95ed11102501@quantenna.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2017 05:28 PM, IgorMitsyanko wrote:
> On 01/09/2017 03:39 PM, Johannes Berg wrote:
>>>> -    msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>>>> +    msg = nlmsg_new(100 + ie_len, GFP_KERNEL);
>>>
>>> Don't you want the '100' to be a define?
>>
>> I didn't want to glorify it too much - some places may need more or
>> less over time. There's no significance to this number.
>>
>> johannes
>>
>
> Looking at what NLMSG_DEFAULT_SIZE is, wouldn't it be more descriptive
> to replace 100 with something like:
>
> #define NLMSG_OVERHEAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
> NLMSG_HDRLEN)
>

Now I see, it's not for msg overhead, but for other fixed-width netlink 
attributes like WIPHY, IFINDEX etc
