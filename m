Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33880 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbdLESPg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 13:15:36 -0500
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
To: David Miller <davem@davemloft.net>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi
References: <1512491661.26976.19.camel@sipsolutions.net>
 <20171205.114106.1013322969674769159.davem@davemloft.net>
 <1512495010.26976.24.camel@sipsolutions.net>
 <20171205.124038.2265447675450126665.davem@davemloft.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <c9bbb3a1-4a94-fece-478f-7e347734ddd2@gmail.com> (sfid-20171205_191543_695490_780A6D9B)
Date: Tue, 5 Dec 2017 11:15:29 -0700
MIME-Version: 1.0
In-Reply-To: <20171205.124038.2265447675450126665.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/5/17 10:40 AM, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 05 Dec 2017 18:30:10 +0100
> 
>> On Tue, 2017-12-05 at 11:41 -0500, David Miller wrote:
>>>
>>> There is no reasonable interpretation for what that application is
>>> doing, so I think we can safely call that case as buggy.
>>>
>>> We are only trying to handle the situation where a U8 attribute
>>> is presented as a bonafide U32 or a correct U8.
>>>
>>> Does this make sense?
>>
>> Well the application is buggy, but we don't really know in what way?
>> Perhaps somebody even did the equivalent of
>>     nla_put_u32(ATTR, cpu_to_le32(x))
>> when they noticed it was broken on BE, and end up with a similar case
>> as I had above.
>>
>> I don't think there's a good solution to this, applications must be
>> fixed anyhow. I'm just saying that I'd save the extra code and stay
>> compatible with applications as written today, even if they're now
>> broken on BE - and rely on the warning to fix it. Trying to fix it up
>> seems to have the potential to just break something else.

+1

> 
> You might be right.
> 
> Ok let's just go with the warning + existing behavior for now.

Is the patch I sent as an attachment good or should I re-send
standalone? (don't see it in patchwork)
