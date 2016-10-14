Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57573 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbcJNIsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 04:48:20 -0400
Message-ID: <1476434750.31114.11.camel@sipsolutions.net> (sfid-20161014_104858_027168_AD587E6C)
Subject: Re: [mac80211] BUG_ON with current -git (4.8.0-11417-g24532f7)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Oct 2016 10:45:50 +0200
In-Reply-To: <20161014083957.GA421@swordfish> (sfid-20161014_104004_754246_F321C7F9)
References: <20161010150358.GA514@swordfish>
         <20161010153050.GA836@swordfish>
         <1476263106.5271.23.camel@sipsolutions.net>
         <20161012141245.GA436@swordfish>
         <1476282127.5271.30.camel@sipsolutions.net>
         <CALCETrXg9-OpJx5Rqz8afyaug+0DjzxvpdbOV9q6i01=zCZbcQ@mail.gmail.com>
         <1476338524.4904.1.camel@sipsolutions.net> <20161013134252.GA583@swordfish>
         <1476366354.4904.31.camel@sipsolutions.net>
         <CALCETrW8imkGTtR9-mFB=e=Gdr1QXVuhXN3GRs2B6wbmPaaGhA@mail.gmail.com>
         <20161014083957.GA421@swordfish> (sfid-20161014_104004_754246_F321C7F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-14 at 17:39 +0900, Sergey Senozhatsky wrote:
> 
> given that we have a known issue shouldn't VMAP_STACK be
> disabled for now, or would you rather prefer to mark MAC80211
> as incompatible: "depends on CFG80211 && !VMAP_STACK"?

Yeah. It's a bit complicated by the fact that most people will probably
have hardware crypto in their wifi NICs, so that they won't actually
hit the software crypto path. As I said in my other email though, we
can't guarantee - even if the driver says it can do hardware crypto -
that it really will do it for all frames (some might not be able to do
for management frames for example), so we also can't really catch this
at runtime ...

Making mac80211 depend on !VMAP_STACK is probably technically best, but
I fear it'll break a lot of people's configurations who don't have a
problem right now (e.g. Linus's, who probably enabled this, but I know
where he uses wifi he uses an Intel NIC that will always do HW crypto).

Andy, what do you think?

johannes
