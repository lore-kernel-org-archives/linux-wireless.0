Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:39726 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeIRSMQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 14:12:16 -0400
Message-ID: <1537274378.2957.23.camel@sipsolutions.net> (sfid-20180918_143957_473767_2368E9D7)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jbenc@redhat.com
Date: Tue, 18 Sep 2018 14:39:38 +0200
In-Reply-To: <847cc635-cb90-821d-5824-07e7f941db75@mojatatu.com> (sfid-20180918_143456_916147_A6997092)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913193004.GF4590@localhost.localdomain>
         <20180913212742.GC3876@unicorn.suse.cz>
         <20180913215839.GI27095@localhost.localdomain>
         <1537177132.2957.6.camel@sipsolutions.net>
         <847cc635-cb90-821d-5824-07e7f941db75@mojatatu.com>
         (sfid-20180918_143456_916147_A6997092)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-18 at 08:34 -0400, Jamal Hadi Salim wrote:

> > > Maybe it would be better to have NLA_IGNORE instead? </idea>
> > 
> > I don't think so, it doesn't give any feedback to the application author
> > that they're doing something wrong.
> > 
> 
> Maybe time to introduce kernel side access-control flags?
> Read/Write permissions for example. Attrs marked as read only
> (in the kernel) cannot be written to.

I dunno, that might work for ethtool, but I want to use it for something
that's not even an attribute you could think about writing to, but the
result of some operation you started.

What would the practical difference be though? Hopefully you wouldn't
have write-only attributes, and then NLA_REJECT is basically equivalent?

johannes
