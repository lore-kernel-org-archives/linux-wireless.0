Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35228 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdEVJ1U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 05:27:20 -0400
Received: by mail-pf0-f176.google.com with SMTP id n23so76790611pfb.2
        for <linux-wireless@vger.kernel.org>; Mon, 22 May 2017 02:27:20 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Add association id to station response
To: Johannes Berg <johannes@sipsolutions.net>,
        Kirill Obukhov <kirill.obukhov@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <CAP3TkT3VE6FWBXm0K4=-pWLrmsCk4a7wuqc24KdcgYNBRQRyoA@mail.gmail.com>
 <1495433875.2653.4.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <308d64da-0806-e80b-14c9-cfa6f65c4064@broadcom.com> (sfid-20170522_112835_019020_7659A5AE)
Date: Mon, 22 May 2017 11:27:01 +0200
MIME-Version: 1.0
In-Reply-To: <1495433875.2653.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2017 8:17 AM, Johannes Berg wrote:
> Hi Kirill,
> 
> First of all, please read
> 
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> 
> particularly
> 
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
> 
> is important
> 
> On Sun, 2017-05-21 at 11:45 +0300, Kirill Obukhov wrote:
>> There are unique association id attribute must be passed in station
>> add request.

This sentence is a bit quirky. It is sort of clear what is meant, but 
maybe rephrase:

When adding a station user-space using CMD_NEW_STATION user-space needs 
to provide a unique association ID. However, we have no way...

>> But we have no way to retrieve ids already in use. To solve issue
>> association id attribute added to station response.

It would also be nice to give an example when you want to add a new 
station (maybe it is just me being curious ;-) ).

Regards,
Arend

> 
> This sound fine.
> 
> However, it'd be good to mention that you're also adding it to
> mac80211, or preferably even split the patch into two, one to add the
> feature and one to make use of it in mac80211.
> 
> Once you do that, you'll quite likely also notice that with just the
> first of the patches, the thing is broken and always reports a 0 AID.
> 
>>          if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
>>              nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||
>> +           nla_put_u16(msg, NL80211_ATTR_STA_AID, sinfo->aid) ||
> 
> That's because you need to make this conditional on the right filled
> flag.
> 
> johannes
> 
