Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51117 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932239AbcJMOOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 10:14:10 -0400
Message-ID: <1476366354.4904.31.camel@sipsolutions.net> (sfid-20161013_161416_031304_06D9E79F)
Subject: Re: [mac80211] BUG_ON with current -git (4.8.0-11417-g24532f7)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 13 Oct 2016 15:45:54 +0200
In-Reply-To: <20161013134252.GA583@swordfish> (sfid-20161013_154350_352486_97A4AB85)
References: <20161010150358.GA514@swordfish>
         <20161010153050.GA836@swordfish>
         <1476263106.5271.23.camel@sipsolutions.net>
         <20161012141245.GA436@swordfish>
         <1476282127.5271.30.camel@sipsolutions.net>
         <CALCETrXg9-OpJx5Rqz8afyaug+0DjzxvpdbOV9q6i01=zCZbcQ@mail.gmail.com>
         <1476338524.4904.1.camel@sipsolutions.net> <20161013134252.GA583@swordfish>
         (sfid-20161013_154350_352486_97A4AB85)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-13 at 22:42 +0900, Sergey Senozhatsky wrote:
> 
> > > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commi
> > > t/?h=x86/vmap_stack&id=0a39cfa6fbb5d5635c85253cc7d6b44b54822afd
> > > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commi
> > > t/?h=x86/vmap_stack&id=bf8cfa200b5a01383ea39fc8ce2f32909767baa8
> > 
> > That truly sounds like something we'd rather avoid in the TX/RX
> > paths though, which should perform well.
> 
> didn't fix.

It couldn't, since the new helpers weren't used in mac80211 in those
patches yet.

> so I finally had some time to do a better bug-reporter job.
> 
> I added a bunch of printk-s and several virt_addr_valid()-s
> to ieee80211_aes_ccm_encrypt().
> 
> and right befoe the Oops I see the following report from
> virt_addr_valid()
> 
> 
>  FAIL: 00004100002cba02 > ffffc900802cba02 || 1 -> (00004100002cba02
> >> 39) == 130

Yeah, we already know that in this function the aad variable is on the
stack, it explicitly is.

The question, though, is why precisely that fails in the crypto code.
Can you send the Oops report itself?

johannes
