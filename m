Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47588 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbdDKH3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 03:29:21 -0400
Message-ID: <1491895758.31620.4.camel@sipsolutions.net> (sfid-20170411_092937_586168_A24DBB05)
Subject: Re: [PATCH net-next v4 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Date: Tue, 11 Apr 2017 09:29:18 +0200
In-Reply-To: <20170411071900.GC1976@nanopsycho> (sfid-20170411_091902_806901_2B2253F7)
References: <20170411065700.2623-1-johannes@sipsolutions.net>
         <20170411065700.2623-2-johannes@sipsolutions.net>
         <20170411071900.GC1976@nanopsycho> (sfid-20170411_091902_806901_2B2253F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-04-11 at 09:19 +0200, Jiri Pirko wrote:
> 
> > +	NUM_NLMSGERR_ATTRS,
> 
> According to the rest of the uapi, this should be rather named:
> 	__NLMSGERR_ATTR_MAX

nl80211 uses NUM_ so I guess that's a matter of convention, but I can
change that I guess.

> > 		if (err || (nlh->nlmsg_flags & NLM_F_ACK))
> > -			netlink_ack(skb, nlh, err);
> > +			netlink_ack(skb, nlh, err, NULL);
> 
> Wouldn't it make sense to leave netlink_ack as is and add
> netlink_ack_ext for those who need to pass non-null?

I thought about it, but didn't really see much point. The churn isn't
super big (a dozen callers or so), and I thought it makes sense to
point out to the users that there's something here.

johannes
