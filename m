Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28308.mail.ukl.yahoo.com ([87.248.110.127]:22781 "HELO
	web28308.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752655AbZIKIVr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 04:21:47 -0400
Message-ID: <839237.19551.qm@web28308.mail.ukl.yahoo.com>
Date: Fri, 11 Sep 2009 08:21:49 +0000 (GMT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] sdio: pass unknown cis tuples to sdio drivers
To: Pierre Ossman <pierre@ossman.eu>
Cc: akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <20090911080659.2ac822fc@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- El vie, 11/9/09, Pierre Ossman <pierre@ossman.eu> escribió:
> The description for this patch should be made clearer. The title
> suggests it adds functionality that's already in place. It should be
> something along the lines of "Also pass malformed tuples to
> card drivers".

Hi Pierre,

Thanks for your patch review.

I didn't want to use "malformed" in the first place. I used "unknown" as "unknown to the SDIO core". The SDIO core in Linux only knows about FUNCE tuples of type 1 (with a sane length) as described in the SDIO Simplified Spec V2.00.

I think we just have a language issue here, but if you prefer the "malformed" wording I'm ok with that.

> In the sake of sanity, you might want to add this behaviour to all
> parsers, not just the FUNCE one.

I didn't find an application for the other parsers yet, so I tried to stick to the strictly necessary and just did the FUNCE one which has a direct application for Broadcom cards.

> 
> I'm also unclear on how this is supposed to work. What does the
> broadcom tuple look like? This patch looks like it will silence a lot
> of legitimate warnings, and possibly pollute the card structures with
> bogus data.

The contents of the Broadcom FUNCE (type 0x22) tuple that contains the MAC address of a card looks like the following (tuple size 8):

04 06 00 1d bc 62 79 fd
^^ ^^ ^^^^^^^^^^^^^^^^^
 |  |                 |
 |  |                 +--- MAC address
 |  +--------------------- length (6 bytes for a ethernet MAC address)
 +------------------------ type 4 (CISTPL_FUNCE_LAN_NODE_ID)

If you prefer it, instead of passing al "unknown" (or "malformed") FUNCE tuples to SDIO drivers, I can let through only a subset of whitelisted FUNCE types (starting with type 4).

> 
> > diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> > index 963f293..87934ac 100644
> > --- a/drivers/mmc/core/sdio_cis.c
> > +++ b/drivers/mmc/core/sdio_cis.c
> > @@ -123,8 +123,9 @@ static int cistpl_funce_func(struct sdio_func *func,
> >      vsn = func->card->cccr.sdio_vsn;
> >      min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
> >  
> > +    /* let the SDIO driver take care of unknown tuples */
> >      if (size < min_size || buf[0] != 1)
> 
> Misleading comment, the tuple is not unknown.
> 

Same language issue described before.

> > -        return -EINVAL;
> > +        return -EILSEQ;
> >  
> 
> What does this change improve?

-EILSEQ is used to indicate that the tuple was not parsed by the SDIO core and should be passed to the SDIO driver via the SDIO func tuple list.

> 
> >      /* TPLFE_MAX_BLK_SIZE */
> >      func->max_blksize =
> buf[12] | (buf[13] << 8);
> > @@ -154,13 +155,7 @@ static int cistpl_funce(struct mmc_card *card, struct sdio_func *func,
> >      else
> >          ret = cistpl_funce_common(card, buf, size);
> >  
> > -    if (ret) {
> > -        printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
> > -               "type %u\n", mmc_hostname(card->host), size, buf[0]);
> > -        return ret;
> > -    }
> > -
> > -    return 0;
> > +    return ret;
> >  }
> >  
> >  typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
> 
> Silencing a legitimate error.
> 

Yes, I see your point.

I think we can keep this code but prevent displaying the error if ret == -EILSEQ (i.e. the tuple is "unknown"/"malformed" BUT should be passed to the SDIO driver for parsing).

> > +        if (ret == -EILSEQ) {
> > +       
>     /* this tuple is unknown to the core */
> 
> Misleading comment, the tuple might be known but malformed.

Same languange issue again.

> 
> Rgds
> -- 
>      -- Pierre Ossman

Thanks a lot for your comments,
Albert



      
