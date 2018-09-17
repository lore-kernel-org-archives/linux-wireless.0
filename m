Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38201 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbeIRBq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 21:46:28 -0400
Date: Mon, 17 Sep 2018 17:17:29 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kubecek <mkubecek@suse.cz>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, jbenc@redhat.com
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
Message-ID: <20180917201729.GH4590@localhost.localdomain> (sfid-20180917_221740_984341_4978017D)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913193004.GF4590@localhost.localdomain>
 <20180913212742.GC3876@unicorn.suse.cz>
 <20180913215839.GI27095@localhost.localdomain>
 <1537177132.2957.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1537177132.2957.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2018 at 11:38:52AM +0200, Johannes Berg wrote:
> On Thu, 2018-09-13 at 18:58 -0300, Marcelo Ricardo Leitner wrote:
> 
> > Then I ask my first question again: why reject these? They are not
> > hurting anything, are they?  It's different from your example I think.
> > In there, the extra information which was ignored leads to a
> > different behavior.
> 
> So in one case I was thinking of, there are some fields that simply
> cannot be used for input, they're only used for output. But it may not
> always be obvious to somebody using the API. Thus, I think it makes
> sense to instruct the kernel to reject that, so that whoever gets
> confused has immediate feedback that their usage is wrong. If we ignore
> that, they may not realize their error immediately.
> 
> I think the ethtool case is similar: you can read and write some fields,
> and only read others - but if you try to write the read-only fields
> would you prefer to be told "sorry, this is not possible" vs. it being
> silently ignored? I'd definitely prefer the former.

See below.

> 
> > Maybe it would be better to have NLA_IGNORE instead? </idea>
> 
> I don't think so, it doesn't give any feedback to the application author
> that they're doing something wrong.

Yes, it would have to have some other ways to signal return values.

In some cases there may be other ways to tell the application that it
couldn't be handled at the time. For example, when changing several
ethtool offloadings at once, we could have a feedback for each of the
offloading that was request and it could include "ack, nack and
ignored" and let the application decide if that "ignored" should be an
error or not. It all boils down to what one is trying to do.

That said, I'm now liking this patch. Just too bad we cannot flag
current output-only fields as so, but in the long term I think this
patch will help us.

Thanks,
  Marcelo
