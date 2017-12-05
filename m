Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57576 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdLERaQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 12:30:16 -0500
Message-ID: <1512495010.26976.24.camel@sipsolutions.net> (sfid-20171205_183025_803172_B1478FD3)
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        dsahern@gmail.com
Date: Tue, 05 Dec 2017 18:30:10 +0100
In-Reply-To: <20171205.114106.1013322969674769159.davem@davemloft.net>
References: <20171202202332.10205-1-johannes@sipsolutions.net>
         <20171205.113145.172521292247335321.davem@davemloft.net>
         <1512491661.26976.19.camel@sipsolutions.net>
         <20171205.114106.1013322969674769159.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-05 at 11:41 -0500, David Miller wrote:
> 
> There is no reasonable interpretation for what that application is
> doing, so I think we can safely call that case as buggy.
> 
> We are only trying to handle the situation where a U8 attribute
> is presented as a bonafide U32 or a correct U8.
> 
> Does this make sense?

Well the application is buggy, but we don't really know in what way?
Perhaps somebody even did the equivalent of
    nla_put_u32(ATTR, cpu_to_le32(x))
when they noticed it was broken on BE, and end up with a similar case
as I had above.

I don't think there's a good solution to this, applications must be
fixed anyhow. I'm just saying that I'd save the extra code and stay
compatible with applications as written today, even if they're now
broken on BE - and rely on the warning to fix it. Trying to fix it up
seems to have the potential to just break something else.

johannes
