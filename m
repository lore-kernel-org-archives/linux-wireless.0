Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32904 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbdFPM0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 08:26:19 -0400
Message-ID: <1497615975.2622.11.camel@sipsolutions.net> (sfid-20170616_142622_405434_DEC22668)
Subject: Re: [RFC] networking: add and use skb_put_u8()
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 16 Jun 2017 14:26:15 +0200
In-Reply-To: <1497614684.10546.9.camel@perches.com>
References: <20170616090300.13805-1-johannes@sipsolutions.net>
         <b7ba5145-b4f0-0f86-e93d-ad8700483ff2@broadcom.com>
         (sfid-20170616_121658_816680_06914E8C) <1497608566.2622.7.camel@sipsolutions.net>
         <1497614684.10546.9.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-16 at 05:04 -0700, Joe Perches wrote:
> 
> Perhaps
> 
> 	skb_put_data(skb, &c, sizeof(c))
> 
> as that avoids api expansion.

Doing this means putting c on the stack first in many places so a
pointer can be taken, which isn't nice.

> Optimizing the indirections and the size in a macro front-end
> in skb_put_data may be better as it's would be completely
> consistent for all use styles.

Well, you'd still have to worry about aligned/unaligned for anything
bigger than 1 byte, so ...

My bikeshedding on this is over, I'll send out all these (now 6)
patches again once I have a build result from the 0-day bot, and unless
Dave wants to have specific changes I've already spent enough time.

johannes
