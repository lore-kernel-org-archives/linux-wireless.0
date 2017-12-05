Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdLEQlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:41:08 -0500
Date: Tue, 05 Dec 2017 11:41:06 -0500 (EST)
Message-Id: <20171205.114106.1013322969674769159.davem@davemloft.net> (sfid-20171205_174118_023680_1BA9EAB5)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        dsahern@gmail.com
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1512491661.26976.19.camel@sipsolutions.net>
References: <20171202202332.10205-1-johannes@sipsolutions.net>
        <20171205.113145.172521292247335321.davem@davemloft.net>
        <1512491661.26976.19.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 05 Dec 2017 17:34:21 +0100

> On Tue, 2017-12-05 at 11:31 -0500, David Miller wrote:
>> 
>> > We could try to fix up the big endian problem here, but we
>> > don't know *how* userspace misbehaved - if using nla_put_u32
>> > then we could, but we also found a debug tool (which we'll
>> > ignore for the purposes of this regression) that was putting
>> > the padding into the length.
> 
>> We're stuck with this thing forever... I'd like to consider other
>> options.
>> 
>> I've seen this problem at least one time before, therefore I
>> suggest when we see a U8 attribute with a U32's length:
>> 
>> 1) We access it as a u32, this takes care of all endianness
>>    issues.
> 
> Possible, but as I said above, I've seen at least one tool (a debug
> only script) now that will actually emit a U8 followed by 3 bytes of
> padding to make it netlink-aligned, but set the length to 4. That would
> be broken by making this change.

There is no reasonable interpretation for what that application is
doing, so I think we can safely call that case as buggy.

We are only trying to handle the situation where a U8 attribute
is presented as a bonafide U32 or a correct U8.

Does this make sense?
