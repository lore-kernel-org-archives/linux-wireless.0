Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60267 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbcDPVmc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 17:42:32 -0400
Message-ID: <1460842947.2075.11.camel@sipsolutions.net> (sfid-20160416_234240_748549_B16D5CC5)
Subject: Re: [PATCH] netlink: don't send NETLINK_URELEASE for unbound sockets
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, dmitrijs.ivanovs@ubnt.com,
	linux-wireless@vger.kernel.org
Date: Sat, 16 Apr 2016 23:42:27 +0200
In-Reply-To: <20160416063040.GA6380@gondor.apana.org.au>
References: <20160416063040.GA6380@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-04-16 at 14:30 +0800, Herbert Xu wrote:
> Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > 
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index 215fc08c02ab..330ebd600f25 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -688,7 +688,7 @@ static int netlink_release(struct socket *sock)
> > 
> >        skb_queue_purge(&sk->sk_write_queue);
> > 
> > -       if (nlk->portid) {
> > +       if (nlk->portid && nlk->bound) {
> Any reason why we're still testing portid at all? Isn't testing
> bound enough?

The reason is that while I felt confident in understanding the problem
and its solution, I didn't realize that bound follows portid, and that,
for example, a kernel socket can't get bound. :-)

But yeah - looking at the code after your comment does show that
testing portid is pointless now.

In fact, now that I look at it, I wonder how this situation came about?

In the current code, you can only trigger the problematic situation
through an error condition, afaict - you have to try to bind a socket
with the same portid as an already existing one, and __netlink_insert()
will then fail, but netlink_insert() won't reset the nlk_sk(sk)->portid 
since your commit da314c9923fe ("netlink: Replace rhash_portid with
bound"), even though you had previously fixed precisely this issue
already - commit c0bb07df7d98 ("netlink: Reset portid after
netlink_insert failure"). You then close the socket, and since portid
is assigned, that will trigger NETLINK_URELEASE.

So before the rhash_portid -> bound change, this doesn't seem to have
been a problem, and I guess we didn't get the "stuck in limbo" problem
back because we now check bound everywhere relevant, for purposes of
calling netlink_autobind.

IOW - I'm now even more convinced that the patch is correct, and I'm
also convinced that until fairly recently (da314c9923fe) this wasn't
even a problem.

Maybe we can take the opportunity of removing the "portid" check to put
most of the above into a commit message, but I think you should review
it first.

johannes
