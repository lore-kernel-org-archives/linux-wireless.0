Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40338 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752520AbdDHUNU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 16:13:20 -0400
Message-ID: <1491682394.2379.1.camel@sipsolutions.net> (sfid-20170408_221406_371082_1E4915BE)
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Date: Sat, 08 Apr 2017 22:13:14 +0200
In-Reply-To: <20170408184008.GB1900@nanopsycho> (sfid-20170408_204012_186615_65B86B3C)
References: <20170408174900.12820-1-johannes@sipsolutions.net>
         <20170408174900.12820-2-johannes@sipsolutions.net>
         <20170408183440.GA1900@nanopsycho>
         <1491676621.5800.24.camel@sipsolutions.net>
         <20170408184008.GB1900@nanopsycho> (sfid-20170408_204012_186615_65B86B3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-04-08 at 20:40 +0200, Jiri Pirko wrote:

> > I think I'll leave it like this - if anyone really wants to say
> > "attribute 0 is missing" then we can add a flag later... The UAPI
> > does
> > take this into account by not including the attribute at all if the
> > data is invalid, so 0 in the userspace API can be done
> 
> It a known issue, should be fixed right now. We are in no hurry. This
> waited +15 years to be done, no harm in couple more days.

It's not about any timing or anything - I simply think the likelihood
that this will be needed is zero, because almost no netlink family uses
attribute zero, those that do use it are older ones unlikely to be
updated to start with, and *then* needing to indicate that attribute 0
is missing? Not going to happen.

The extra code needed to handle this is therefore wasted.

> Also, could you please attach a patch to iproute2 for example which
> would make use of this. I just want to make sure it clicks.

No, I'm not going to do that. If you want it, please do it yourself.
I've done the testing on a slightly modified iw, but even there haven't
done any pretty-printing or parsing, just made sure the attributes show
up properly (by dumping them in hex).

johannes
