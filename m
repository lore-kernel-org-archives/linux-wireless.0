Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49948 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934222AbcJZI7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 04:59:41 -0400
Message-ID: <1477472376.4059.23.camel@sipsolutions.net> (sfid-20161026_105946_995221_981C6DA0)
Subject: Re: [PATCH net-next] netlink: Add nla_memdup() to wrap kmemdup()
 use on nlattr
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net
Cc: daniel@iogearbox.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 10:59:36 +0200
In-Reply-To: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
References: <2d0864c85200f1b42b1ebceee7c2dc60fe29f26a.1477471562.git.tgraf@suug.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  /**
> + * nla_memdup - duplicate attribute memory (kmemdup)
> + * @src: netlink attribute to duplicate from
> + * @gfp: GFP mask

Actually, is there any point in passing a GFP mask? None of the current
users need it, and it seems fairly unlikely to be needed since this is
typically used on the netlink input path, where you surely shouldn't
need GFP_ATOMIC or so?

johannes
