Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38878 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752752AbdDJPaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 11:30:21 -0400
Message-ID: <1491838218.28432.5.camel@sipsolutions.net> (sfid-20170410_173034_194793_676C2D66)
Subject: Re: [PATCH v3 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: David Ahern <dsa@cumulusnetworks.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
Date: Mon, 10 Apr 2017 17:30:18 +0200
In-Reply-To: <fddba2c8-3b85-d5df-81c4-ef31c459e40c@cumulusnetworks.com> (sfid-20170410_172609_028607_E5C0AF14)
References: <20170408202434.12018-1-johannes@sipsolutions.net>
         <20170408202434.12018-2-johannes@sipsolutions.net>
         <fddba2c8-3b85-d5df-81c4-ef31c459e40c@cumulusnetworks.com>
         (sfid-20170410_172609_028607_E5C0AF14)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-10 at 09:26 -0600, David Ahern wrote:
> On 4/8/17 2:24 PM, Johannes Berg wrote:
> > @@ -2300,14 +2332,35 @@ void netlink_ack(struct sk_buff *in_skb,
> > struct nlmsghdr *nlh, int err)
> >  			  NLMSG_ERROR, payload, 0);
> >  	errmsg = nlmsg_data(rep);
> >  	errmsg->error = err;
> > -	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh-
> > >nlmsg_len : sizeof(*nlh));
> > +	memcpy(&errmsg->msg, nlh,
> > +	       !(nlk->flags & NETLINK_F_CAP_ACK) ? nlh->nlmsg_len
> > +						 : sizeof(*nlh));
> > +
> 
> generically this makes userspace parsing more problematic: the
> parsing layer may not know if the socket option has been set to
> precisely know the size of errmsg->msg and how much data needs to be
> skipped to get to the new attributes.

Yes, I know. I'd hope that userspace can remember that per socket - I
don't see a good other way to do this.

If we insert the TLVs in front of, or instead of (with a TLV containing
it), the request message then at least libnl's debugging will need to
be changed.

As it is, I can assume that libnl will not set the CAP setting, and
everything works fine even if I don't change libnl, which makes things
easier.

Do you have any better ideas?

johannes
