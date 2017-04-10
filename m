Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34466 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdDJUyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 16:54:16 -0400
Date: Mon, 10 Apr 2017 13:54:14 -0700
From: Myungho Jung <mhjungk@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: netdev@vger.kernel.org, David Miller <davem@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: add null pointer check before releasing socket
 buffer
Message-ID: <20170410205414.GB12557@fqdn.specialj.com> (sfid-20170410_225423_480742_9652F91A)
References: <1491801800-4371-1-git-send-email-mhjungk@gmail.com>
 <3716717.OUypxXNBrR@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3716717.OUypxXNBrR@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 10, 2017 at 02:12:54PM +0200, Christian Lamparter wrote:
> (Added linux-wireless, since this is a wireless driver)
> 
> On Sunday, April 9, 2017 10:23:20 PM CEST Myungho Jung wrote:
> > Kernel panic is caused by trying to dereference null pointer. Check if
> > the pointer is null before freeing space.
> Do you have the kernel panic somewhere?
> I think you have an even bigger problem: You see, in order to get EEPROM
> readback and rx_stats feedback you need to sent a request to the firmware
> and if the response's req_id cookies don't match, you end up filling up 
> the very limited device address space.
> 
> As for adding if (!skb) checks. I think kfree, kfree_skb, dev_kfree_skb 
> (aka consume_skb) all check for null pointers already. So the logical
> thing to do would be to make dev_kfree_skb_irq (which would also fix
> dev_kfree_skb_any) consistent with kfree, kfree_skb, dev_kfree_skb and
> add the check there.
> 
> > Signed-off-by: Myungho Jung <mhjungk@gmail.com>
> > ---
> >  drivers/net/wireless/intersil/p54/txrx.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
> > index 1af7da0..8956061 100644
> > --- a/drivers/net/wireless/intersil/p54/txrx.c
> > +++ b/drivers/net/wireless/intersil/p54/txrx.c
> > @@ -503,7 +503,9 @@ static void p54_rx_eeprom_readback(struct p54_common *priv,
> >  
> >  	priv->eeprom = NULL;
> >  	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
> > -	dev_kfree_skb_any(tmp);
> > +	if (unlikely(!tmp))
> > +		dev_kfree_skb_any(tmp);
> > +
> >  	complete(&priv->eeprom_comp);
> >  }
> >  
> > @@ -597,7 +599,9 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
> >  	}
> >  
> >  	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
> > -	dev_kfree_skb_any(tmp);
> > +	if (unlikely(!tmp))
> > +		dev_kfree_skb_any(tmp);
> > +
> >  	complete(&priv->stat_comp);
> >  }
> >  
> > 
> 
> 

I found that the fix was totally opposite to my thought. Sorry about
confusion. I'm not sure it actually caused kernel panic but guessed from
a bug report [https://bugzilla.kernel.org/show_bug.cgi?id=195289]. And
correct fix will be like this:
	if (likely(tmp))
		dev_kfree_skb_any(tmp);

But, like you said, I think null pointer should be checked in
dev_kfree_skb_irq although already checking before calling it in many
other places. I'll try another patch. Thank you for your advice.

Thanks,
Myungho
