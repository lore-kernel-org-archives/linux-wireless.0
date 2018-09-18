Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:41862 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbeIRWQ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 18:16:28 -0400
Message-ID: <1537288970.2957.30.camel@sipsolutions.net> (sfid-20180918_184327_490638_BF09948B)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jbenc@redhat.com
Date: Tue, 18 Sep 2018 18:42:50 +0200
In-Reply-To: <1a1e0b60-24d9-a313-f46e-afb590a99b3a@mojatatu.com> (sfid-20180918_151301_702300_B4843B3E)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913193004.GF4590@localhost.localdomain>
         <20180913212742.GC3876@unicorn.suse.cz>
         <20180913215839.GI27095@localhost.localdomain>
         <1537177132.2957.6.camel@sipsolutions.net>
         <847cc635-cb90-821d-5824-07e7f941db75@mojatatu.com>
         <1537274378.2957.23.camel@sipsolutions.net>
         <26dd9a66-9515-93aa-e21f-51c37db6be2c@mojatatu.com>
         <1537275441.2957.26.camel@sipsolutions.net>
         <1a1e0b60-24d9-a313-f46e-afb590a99b3a@mojatatu.com>
         (sfid-20180918_151301_702300_B4843B3E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-18 at 09:12 -0400, Jamal Hadi Salim wrote:

> Not very familiar with how wifi scan gets initiated. I am guessing
> you issue some GET or SET to start a scan - and you get an async
> response when it is complete (and it would include the time it took)?
> Or maybe you get an immediate response and event notification later
> and the time spent is in that notification?

There isn't really a GET or SET. It's just an arbitrary generic netlink
command that you send down. Not everything is a GET/SET model :-)

But yes, you issue a command via generic netlink to start a scan, with
some attributes, and then eventually get an async notification when it's
done (or was aborted for some reason.)

For purposes of my example, that time attribute would be in the
notification, yes.

> I would still see that as a read-only attribute.

I suppose you could, but you never really get to see it anywhere else.

> And the utility of "execute" bit is only in blocking another scan
> from being initiated when one is in progress, if that is a desired
> goal.

Not sure I understand that. I'm not really talking about some sort of
generic "SET_VALUE" command with a "SCAN_NOW" attribute?

> > I dunno. I think we already bloated the policies too much by including
> > the validation_data pointer, and would hate to add more to that :-)
> 
> Your mileage may vary. NLA_REJECT may work acls offer more fine grained
> controls.

Fair point. We do have padding in the policy (at least on 64-bit
platforms) that we could use for more bits ;-)

johannes
