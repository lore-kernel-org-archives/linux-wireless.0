Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53010 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdFIH25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 03:28:57 -0400
Message-ID: <1496993334.2424.1.camel@sipsolutions.net> (sfid-20170609_092901_382816_3171012E)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Fri, 09 Jun 2017 09:28:54 +0200
In-Reply-To: <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com> (sfid-20170609_020723_334469_4A93564B)
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
         <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
         <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
         <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
         (sfid-20170609_020723_334469_4A93564B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-06-08 at 19:07 -0500, Denis Kenzior wrote:

> > > Fundamentally there is a race between the genl/nl80211 socket to
> > > the
> > > kernel and the PAE socket that handles the authentication
> > > aspects.  I
> > > think the only way to
> > > fix this is to make sure that PAE flows over the genl/nl80211
> > > socket
> > > to preserve the proper order of events.  

Correct.

> > > However there are lots of
> > > dragons in the kernel
> > > side of this and we haven't been brave enough to venture into the
> > > depths yet :)

We've actually discussed doing precisely this, for - among other things
- this reason. Just nobody stepped up yet to propose the necessary APIs
and do the remaining work to use it etc.

> > I think that would just push the problem lower.  Probably a real
> > fix
> > would be to somehow propagate
> > the tx-status for the specific packet back to the supplicant and
> > only
> > then it would know that the
> > key could be set.

That's actually possible today, with the wifi-ack sockopt. It's not
really a full solution though I think, there are other issues to solve.
We also discussed this at the last workshop, IIRC.

> Having userspace track individual packets in the kernel sounds  wrong
> to  me.  This also won't help with the packets being received out-of-
> order.  It would be nice if both the RX and TX ordering was
> preserved.  Hence my thinking about running PAE over NL80211.  It
> would then be up to the kernel / drivers to guarantee that the
> various packets are ordered appropriately.

That's actually not possible, since ordering set_key operations vs.
transmitted packets isn't something that's easily done by drivers.

However, the solution is far simpler! Once you have nl80211 PAE
transport, you can easily even set the key before transmitting the
packet and simply indicate that this particular packet should _not_ be
encrypted regardless of key presence.

johannes
