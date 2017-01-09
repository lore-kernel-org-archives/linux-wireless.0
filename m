Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0064.outbound.protection.outlook.com ([104.47.38.64]:58969
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S940059AbdAIO2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 09:28:16 -0500
Subject: Re: [PATCH] cfg80211: size various nl80211 messages correctly
To: Johannes Berg <johannes@sipsolutions.net>
References: <20170109101042.23919-1-johannes@sipsolutions.net>
 <ec9fb205-91ca-9591-0b0b-92672d093395@broadcom.com>
 <1483965571.17582.35.camel@sipsolutions.net>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        <linux-wireless@vger.kernel.org>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <d6a54188-8538-87e4-d0db-95ed11102501@quantenna.com> (sfid-20170109_152911_776197_3BFCDAF1)
Date: Mon, 9 Jan 2017 17:28:08 +0300
MIME-Version: 1.0
In-Reply-To: <1483965571.17582.35.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2017 03:39 PM, Johannes Berg wrote:
>>> -	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>>> +	msg = nlmsg_new(100 + ie_len, GFP_KERNEL);
>>
>> Don't you want the '100' to be a define?
>
> I didn't want to glorify it too much - some places may need more or
> less over time. There's no significance to this number.
>
> johannes
>

Looking at what NLMSG_DEFAULT_SIZE is, wouldn't it be more descriptive 
to replace 100 with something like:

#define NLMSG_OVERHEAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + 
NLMSG_HDRLEN)
