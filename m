Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:41280 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752647AbdFPMEr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 08:04:47 -0400
Message-ID: <1497614684.10546.9.camel@perches.com> (sfid-20170616_140450_615428_DECB47D9)
Subject: Re: [RFC] networking: add and use skb_put_u8()
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 16 Jun 2017 05:04:44 -0700
In-Reply-To: <1497608566.2622.7.camel@sipsolutions.net>
References: <20170616090300.13805-1-johannes@sipsolutions.net>
         <b7ba5145-b4f0-0f86-e93d-ad8700483ff2@broadcom.com>
         (sfid-20170616_121658_816680_06914E8C) <1497608566.2622.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-16 at 12:22 +0200, Johannes Berg wrote:
> On Fri, 2017-06-16 at 12:16 +0200, Arend van Spriel wrote:
> > 
> > >      @@
> > >      expression SKB, C, S;
> > >      typedef u8;
> > >      identifier fn = {skb_put};
> > >      fresh identifier fn2 = fn ## "_u8";
> > >      @@
> > >      - *(u8 *)fn(SKB, S) = C;
> > >      + fn2(SKB, C);
> > > 
> > > Note that due to the "C", the spatch isn't perfect, it should
> > > have checked that C is 1, but there's also places that use a
> > 
> > Don't you mean "S" here?
> 
> Indeed, I mean S, will fix.

Perhaps

	skb_put_data(skb, &c, sizeof(c))

as that avoids api expansion.

Optimizing the indirections and the size in a macro front-end
in skb_put_data may be better as it's would be completely
consistent for all use styles.
