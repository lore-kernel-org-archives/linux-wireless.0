Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdLEQvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:51:08 -0500
Date: Tue, 05 Dec 2017 11:51:04 -0500 (EST)
Message-Id: <20171205.115104.386744893504634236.davem@davemloft.net> (sfid-20171205_175125_659558_80356C31)
To: dsahern@gmail.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
From: David Miller <davem@davemloft.net>
In-Reply-To: <fe8e7ad5-9579-31ce-0d02-a6c8522ba366@gmail.com>
References: <20171205.113145.172521292247335321.davem@davemloft.net>
        <1512491661.26976.19.camel@sipsolutions.net>
        <fe8e7ad5-9579-31ce-0d02-a6c8522ba366@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Ahern <dsahern@gmail.com>
Date: Tue, 5 Dec 2017 09:41:21 -0700

> On 12/5/17 9:34 AM, Johannes Berg wrote:
>> On Tue, 2017-12-05 at 11:31 -0500, David Miller wrote:
>>>
>>>> We could try to fix up the big endian problem here, but we
>>>> don't know *how* userspace misbehaved - if using nla_put_u32
>>>> then we could, but we also found a debug tool (which we'll
>>>> ignore for the purposes of this regression) that was putting
>>>> the padding into the length.
>> 
>>> We're stuck with this thing forever... I'd like to consider other
>>> options.
>>>
>>> I've seen this problem at least one time before, therefore I
>>> suggest when we see a U8 attribute with a U32's length:
>>>
>>> 1) We access it as a u32, this takes care of all endianness
>>>    issues.
>> 
>> Possible, but as I said above, I've seen at least one tool (a debug
>> only script) now that will actually emit a U8 followed by 3 bytes of
>> padding to make it netlink-aligned, but set the length to 4. That would
>> be broken by making this change.
>> 
>> I'm not saying this is bad - but there are different levels of
>> compatibility and I'd probably go for "bug compatibility" here rather
>> than "fix-it-up compatibility".
>> 
>> Your call, ultimately - I've already fixed the tool I had found :-)
>> 
>>> 2) We emit a warning so that the app gets fixes.
>> 
> 
> The attached is my proposal. Basically, allow it the length mismatch but
> print a warning. This restores previous behavior and tells users of bad
> commands.

Where is the "access the U8 attribute as a U32 if length is 4" part
of my #1 above?

That's essential to handle this properly on all endianness.
