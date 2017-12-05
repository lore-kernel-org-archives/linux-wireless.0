Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:37716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdLERkl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 12:40:41 -0500
Date: Tue, 05 Dec 2017 12:40:38 -0500 (EST)
Message-Id: <20171205.124038.2265447675450126665.davem@davemloft.net> (sfid-20171205_184049_255040_3BACDDA6)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        dsahern@gmail.com
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1512495010.26976.24.camel@sipsolutions.net>
References: <1512491661.26976.19.camel@sipsolutions.net>
        <20171205.114106.1013322969674769159.davem@davemloft.net>
        <1512495010.26976.24.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 05 Dec 2017 18:30:10 +0100

> On Tue, 2017-12-05 at 11:41 -0500, David Miller wrote:
>> 
>> There is no reasonable interpretation for what that application is
>> doing, so I think we can safely call that case as buggy.
>> 
>> We are only trying to handle the situation where a U8 attribute
>> is presented as a bonafide U32 or a correct U8.
>> 
>> Does this make sense?
> 
> Well the application is buggy, but we don't really know in what way?
> Perhaps somebody even did the equivalent of
>     nla_put_u32(ATTR, cpu_to_le32(x))
> when they noticed it was broken on BE, and end up with a similar case
> as I had above.
> 
> I don't think there's a good solution to this, applications must be
> fixed anyhow. I'm just saying that I'd save the extra code and stay
> compatible with applications as written today, even if they're now
> broken on BE - and rely on the warning to fix it. Trying to fix it up
> seems to have the potential to just break something else.

You might be right.

Ok let's just go with the warning + existing behavior for now.
