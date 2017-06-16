Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59470 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752126AbdFPKWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 06:22:48 -0400
Message-ID: <1497608566.2622.7.camel@sipsolutions.net> (sfid-20170616_122252_327383_1FECF9F5)
Subject: Re: [RFC] networking: add and use skb_put_u8()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 16 Jun 2017 12:22:46 +0200
In-Reply-To: <b7ba5145-b4f0-0f86-e93d-ad8700483ff2@broadcom.com> (sfid-20170616_121658_816680_06914E8C)
References: <20170616090300.13805-1-johannes@sipsolutions.net>
         <b7ba5145-b4f0-0f86-e93d-ad8700483ff2@broadcom.com>
         (sfid-20170616_121658_816680_06914E8C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-16 at 12:16 +0200, Arend van Spriel wrote:
> 
> >      @@
> >      expression SKB, C, S;
> >      typedef u8;
> >      identifier fn = {skb_put};
> >      fresh identifier fn2 = fn ## "_u8";
> >      @@
> >      - *(u8 *)fn(SKB, S) = C;
> >      + fn2(SKB, C);
> > 
> > Note that due to the "C", the spatch isn't perfect, it should
> > have checked that C is 1, but there's also places that use a
> 
> Don't you mean "S" here?

Indeed, I mean S, will fix.

johannes
