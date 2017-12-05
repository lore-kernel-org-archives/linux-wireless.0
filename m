Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53052 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdLEQe0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:34:26 -0500
Message-ID: <1512491661.26976.19.camel@sipsolutions.net> (sfid-20171205_173438_593931_3BE74C28)
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        dsahern@gmail.com
Date: Tue, 05 Dec 2017 17:34:21 +0100
In-Reply-To: <20171205.113145.172521292247335321.davem@davemloft.net>
References: <20171202202332.10205-1-johannes@sipsolutions.net>
         <20171205.113145.172521292247335321.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-05 at 11:31 -0500, David Miller wrote:
> 
> > We could try to fix up the big endian problem here, but we
> > don't know *how* userspace misbehaved - if using nla_put_u32
> > then we could, but we also found a debug tool (which we'll
> > ignore for the purposes of this regression) that was putting
> > the padding into the length.

> We're stuck with this thing forever... I'd like to consider other
> options.
> 
> I've seen this problem at least one time before, therefore I
> suggest when we see a U8 attribute with a U32's length:
> 
> 1) We access it as a u32, this takes care of all endianness
>    issues.

Possible, but as I said above, I've seen at least one tool (a debug
only script) now that will actually emit a U8 followed by 3 bytes of
padding to make it netlink-aligned, but set the length to 4. That would
be broken by making this change.

I'm not saying this is bad - but there are different levels of
compatibility and I'd probably go for "bug compatibility" here rather
than "fix-it-up compatibility".

Your call, ultimately - I've already fixed the tool I had found :-)

> 2) We emit a warning so that the app gets fixes.

For sure.

johannes
