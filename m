Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:39872 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeIRSaD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 14:30:03 -0400
Message-ID: <1537275441.2957.26.camel@sipsolutions.net> (sfid-20180918_145740_492030_67BED375)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jbenc@redhat.com
Date: Tue, 18 Sep 2018 14:57:21 +0200
In-Reply-To: <26dd9a66-9515-93aa-e21f-51c37db6be2c@mojatatu.com> (sfid-20180918_145515_710821_B5A2C6C9)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913193004.GF4590@localhost.localdomain>
         <20180913212742.GC3876@unicorn.suse.cz>
         <20180913215839.GI27095@localhost.localdomain>
         <1537177132.2957.6.camel@sipsolutions.net>
         <847cc635-cb90-821d-5824-07e7f941db75@mojatatu.com>
         <1537274378.2957.23.camel@sipsolutions.net>
         <26dd9a66-9515-93aa-e21f-51c37db6be2c@mojatatu.com>
         (sfid-20180918_145515_710821_B5A2C6C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-18 at 08:55 -0400, Jamal Hadi Salim wrote:

> Execute permission kind of thing? i.e if i understood you correctly
> if acl is "rwx" then attribute can only be written to (or read from) if
> the "thing executing" is complete

But it's not an attribute that you're executing, it's some kind of
command, and then you get the return value of that command in that
attribute?

Say you want to scan for wifi networks - you trigger a scan, later you
get a notification giving you some data about the scan (let's say the
time it took) - there's no way you can set that time attribute.

(NB: it doesn't work this way, we don't have that attribute now, but I
didn't want to pick a more complicated example)

> > What would the practical difference be though? Hopefully you wouldn't
> > have write-only attributes, and then NLA_REJECT is basically equivalent?
> > 
> 
> If ACL says "-w-" then reading should get explicit permission denied
> code possibly with an extack which is more descriptive that reading
> is not allowed.

Perhaps. But NLA_REJECT comes with an extack string to tell you, so ...

I dunno. I think we already bloated the policies too much by including
the validation_data pointer, and would hate to add more to that :-)

johannes
