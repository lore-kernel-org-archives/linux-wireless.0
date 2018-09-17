Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:40250 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbeIQPFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 11:05:40 -0400
Message-ID: <1537177132.2957.6.camel@sipsolutions.net> (sfid-20180917_113909_278047_511B0056)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jbenc@redhat.com
Date: Mon, 17 Sep 2018 11:38:52 +0200
In-Reply-To: <20180913215839.GI27095@localhost.localdomain> (sfid-20180913_235845_154589_B8195738)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913193004.GF4590@localhost.localdomain>
         <20180913212742.GC3876@unicorn.suse.cz>
         <20180913215839.GI27095@localhost.localdomain>
         (sfid-20180913_235845_154589_B8195738)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-13 at 18:58 -0300, Marcelo Ricardo Leitner wrote:

> > It would be easier and IMHO cleaner if I could simply list these "read
> > only attributes" with NLA_REJECT policy for "set" request.
> 
> Not that I'm against this. Point was fields that are considered output
> only today are probably being silently ignored, and we can't change
> them to be NLA_REJECT as it would break user applications. 

Indeed.

> Then we
> will have fields that are rejected, and those old that are not. In the
> long run, nearly all output fields would be marked as NLA_REJECT,
> okay.

Perhaps, yes, though I assume it would only really be true for new
families that bother to mark as such.

> Then I ask my first question again: why reject these? They are not
> hurting anything, are they?  It's different from your example I think.
> In there, the extra information which was ignored leads to a
> different behavior.

So in one case I was thinking of, there are some fields that simply
cannot be used for input, they're only used for output. But it may not
always be obvious to somebody using the API. Thus, I think it makes
sense to instruct the kernel to reject that, so that whoever gets
confused has immediate feedback that their usage is wrong. If we ignore
that, they may not realize their error immediately.

I think the ethtool case is similar: you can read and write some fields,
and only read others - but if you try to write the read-only fields
would you prefer to be told "sorry, this is not possible" vs. it being
silently ignored? I'd definitely prefer the former.

> Maybe it would be better to have NLA_IGNORE instead? </idea>

I don't think so, it doesn't give any feedback to the application author
that they're doing something wrong.

johannes
