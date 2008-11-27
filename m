Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:50053 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYK0L0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 06:26:06 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFT][RFC][PATCH] p54: utilize cryptographic accelerator
Date: Thu, 27 Nov 2008 12:26:05 +0100
Cc: linux-wireless@vger.kernel.org
References: <200811242215.00475.chunkeey@web.de> <492DE6BD.5060206@lwfinger.net>
In-Reply-To: <492DE6BD.5060206@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811271226.05700.chunkeey@web.de> (sfid-20081127_122610_631948_7C68C5EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 November 2008 01:15:57 Larry Finger wrote:
> > diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> > --- a/drivers/net/wireless/p54/p54common.c	2008-11-24 21:05:42.590287518 +0100
> > +++ b/drivers/net/wireless/p54/p54common.c	2008-11-24 22:06:13.951266225 +0100
> > @@ -843,6 +863,8 @@ static int p54_assign_address(struct iee
> >  
> >  	spin_lock_irqsave(&priv->tx_queue.lock, flags);
> >  	left = skb_queue_len(&priv->tx_queue);
> > +	if (left > 30)
> > +		return -ENOMEM;
> 
> The above returns with tx_queue.lock still set.
Oops, this piece should be in another patch.
So, ok it's gone now.

> --snip--
> > +		}
> > +	}
> > +
> > +	mutex_lock(&priv->conf_mutex);
> > +	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey) +
> > +			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_RX_KEYCACHE,
> > +			GFP_ATOMIC);
> > +	if (!skb) {
> > +		mutex_unlock(&priv->conf_mutex);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	rxkey = (struct p54_keycache *)skb_put(skb, sizeof(*rxkey));
> > +	rxkey->entry = cpu_to_le16(key->keyidx);
> > +	rxkey->key_id = cpu_to_le16(key->keyidx);
> 
> Sparse objects to the above two statments because key->keyidx is of type s8, and
> both rxkey->entry and rxkey->key_id are of type u8. A conversion to le16 is not
> needed.
> 
> A patch for both problems is below:
Thanks... I guess the final RFT/RFC will be ready on friday/saturday.
there are a two outstanding issues:
	- do we need to swap CCMP's IV as well?
	- does MIC failure & replay detection work?
		(or did you test that, when you were working with TKIP?)

Regards,
	Chr
