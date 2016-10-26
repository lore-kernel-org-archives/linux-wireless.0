Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36385 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933606AbcJZXn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 19:43:57 -0400
Received: by mail-pf0-f173.google.com with SMTP id e6so5025324pfk.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2016 16:43:57 -0700 (PDT)
Date: Wed, 26 Oct 2016 16:43:54 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Rajat Jain <rajatja@google.com>
Subject: Re: [PATCH] mwifiex: don't do unbalanced free()'ing in cleanup_if()
Message-ID: <20161026234353.GA24417@localhost> (sfid-20161027_014401_780834_96072167)
References: <1477524560-49226-1-git-send-email-briannorris@chromium.org>
 <20161026233554.GF27930@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026233554.GF27930@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2016 at 04:35:54PM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 26, 2016 at 04:29:20PM -0700, Brian Norris wrote:

> > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > index 8718950004f3..f04cf5a551b3 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c

> > @@ -2291,6 +2287,14 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
> >  
> >  	mwifiex_sdio_remove(func);
> >  
> > +	/*
> > +	 * Normally, we would let the driver core take care of releasing these.
> > +	 * But we're not letting the driver core handle this one. See above
> > +	 * TODO.
> > +	 */
> > +	sdio_set_drvdata(func, NULL);
> > +	devm_kfree(&func->dev, card);
> 
> Ugh, this really messes the unwind order... I guess it is OK since it is
> the only resource allocated with devm, but I'd be happier if we could
> reuse existing "card" structure.

I'm really not interested in cleaning up the hacky reset function here
(see the other TODOs here). I'm sure it's broken in other ways too. In
its current "design" (if you can call it that) where we remove and
re-probe the device, I'm not sure there's a way to get it to reuse the
'card'.

If you insist on refactoring this to protect the potential future unwind
order (if we use devm more heavily), then I guess I'd have to go back to
manual k{zalloc,free}() for sdio.c.

Brian
