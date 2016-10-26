Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50670 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753718AbcJZKTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 06:19:04 -0400
Message-ID: <1477477127.4059.27.camel@sipsolutions.net> (sfid-20161026_121957_494734_7E76B151)
Subject: Re: [PATCH net-next] netlink: Add nla_memdup() to wrap kmemdup()
 use on nlattr
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Graf <tgraf@suug.ch>
Cc: davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 12:18:47 +0200
In-Reply-To: <20161026095238.GB16590@pox.localdomain> (sfid-20161026_115243_626103_4ED9717E)
References: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
         <1477472376.4059.23.camel@sipsolutions.net>
         <20161026095238.GB16590@pox.localdomain>
         (sfid-20161026_115243_626103_4ED9717E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-26 at 11:52 +0200, Thomas Graf wrote:
> On 10/26/16 at 10:59am, Johannes Berg wrote:
> > 
> > 
> > > 
> > >  /**
> > > + * nla_memdup - duplicate attribute memory (kmemdup)
> > > + * @src: netlink attribute to duplicate from
> > > + * @gfp: GFP mask
> > 
> > Actually, is there any point in passing a GFP mask? None of the
> > current
> > users need it, and it seems fairly unlikely to be needed since this
> > is
> > typically used on the netlink input path, where you surely
> > shouldn't
> > need GFP_ATOMIC or so?
> 
> I'm fine either way. I didn't want to make assumptions which need
> later changes. It's not hurting either and the function prototype
> is very small.

Yeah, I don't really care much - just wondered.

johannes
