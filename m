Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38956 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754849AbdDJPkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 11:40:14 -0400
Message-ID: <1491838811.28432.8.camel@sipsolutions.net> (sfid-20170410_174028_849361_B9460115)
Subject: Re: [PATCH v3 1/5] netlink: extended ACK reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: David Ahern <dsa@cumulusnetworks.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
Date: Mon, 10 Apr 2017 17:40:11 +0200
In-Reply-To: <029e6587-c0e8-bdb0-49e9-2abe2946a7ff@cumulusnetworks.com> (sfid-20170410_173530_723869_8DC854E1)
References: <20170408202434.12018-1-johannes@sipsolutions.net>
         <20170408202434.12018-2-johannes@sipsolutions.net>
         <fddba2c8-3b85-d5df-81c4-ef31c459e40c@cumulusnetworks.com>
         <1491838218.28432.5.camel@sipsolutions.net>
         <029e6587-c0e8-bdb0-49e9-2abe2946a7ff@cumulusnetworks.com>
         (sfid-20170410_173530_723869_8DC854E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-10 at 09:35 -0600, David Ahern wrote:

> > Do you have any better ideas?
> 
> NETLINK_F_CAP_ACK and NETLINK_F_EXT_ACK should be incompatible -- if
> one is set the other can not be set. CAP_ACK means abbreviate the
> response and EXT_ACK means give me more data.

So you mean if I want EXT_ACK I cannot also cap the message?

I guess that's doable, but again wouldn't it hurt applications that
want to use CAP? I assume every application wants to use EXT_ACK
eventually, and those that use CAP right now wouldn't be able to.

Another thought: if we add a new flag that indicates "message has been
capped", which we introduce in this same patch, then we can disentangle
this more easily, right?

Adding a new flag for "TLVs present" won't really help, but if you know
the message was capped then you know the TLVs start after the inner
nlmsghdr and you ignore that header's nlmsg_len.

johannes
