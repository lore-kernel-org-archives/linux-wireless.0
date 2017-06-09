Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:35211 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdFIVmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 17:42:05 -0400
Received: by mail-ot0-f170.google.com with SMTP id a2so45000749oth.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 14:42:05 -0700 (PDT)
Subject: LINKMODE & OPERSTATE thoughts
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
 <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
 <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
 <1496993334.2424.1.camel@sipsolutions.net>
 <08fb9e64-a01e-54ea-7627-a0664d350710@gmail.com>
 <1497038197.12088.4.camel@sipsolutions.net>
Cc: j@w1.fi
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <ad95b6e5-9220-3eca-bf93-8ba1d89bde3b@gmail.com> (sfid-20170609_234209_112071_67F4575C)
Date: Fri, 9 Jun 2017 16:42:03 -0500
MIME-Version: 1.0
In-Reply-To: <1497038197.12088.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Let me start a separate thread on this:

>> Also, while we're on this subject.  Should the kernel auto-manage
>> the LINKMODE and OPERSTATE flags?  It would seem that it already has
>> the information to do so, and having userspace manage this just
>> introduces another source of latency / possibility of race
>> conditions, etc.
>
> I'm not convinced that it does have that information in all cases, and
> I don't see how that causes race conditions or much latency, since for
> client mode userspace would probably just set that together with the
> NL80211_STA_FLAG_AUTHORIZED flag?

Well right there is a race condition.  You have 2 sockets and both 
conveying the same information?

If we can optimize away an extra kernel trap, isn't that worthwhile 
thing to do?

The most common case is issuing Dormant + UP after setting keys & 
issuing the set_station command.  Isn't setting STA_FLAG_AUTHORIZED and 
operstate to IF_OPER_UP in effect equivalent?

Oh, by the way, some drivers don't implement set_station for normal 
links (e.g. setting STA_FLAG_AUTHORIZED returns an error), should they?

The only other cases where we mess with setting linkmode I can think of are:

1. After connecting to an open network
2. After a fast transition

For 1, it would seem that the kernel can easily infer that the 
IF_OPER_UP flag should be tweaked.
For 2, this needs to be done after the new TK is installed.  Can we 
combine these steps somehow?

Regards,
-Denis
