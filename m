Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:1114 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbYBBVkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 16:40:42 -0500
Received: by py-out-1112.google.com with SMTP id u52so2369647pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 13:40:41 -0800 (PST)
Message-ID: <43e72e890802021340h7d4778a8hf9827531cd387bcc@mail.gmail.com> (sfid-20080202_214045_187835_298546F8)
Date: Sat, 2 Feb 2008 16:40:40 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [RFC: 2.6 patch] ath5k/phy.c: fix negative array index
Cc: "Adrian Bunk" <bunk@kernel.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <40f31dec0802021338x6075d134n5c1270a424d7ae5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080202211617.GE9375@cs181133002.pp.htv.fi>
	 <40f31dec0802021338x6075d134n5c1270a424d7ae5b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 2, 2008 4:38 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/2/2, Adrian Bunk <bunk@kernel.org>:
>
> > This patch fixes a negative array index spotted by the Coverity checker.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> >
> > I'm not 100% sure whether my patch is correct, but if not this patch is
> > the easiest way to show the problem.
> >
> > --- linux-2.6/drivers/net/wireless/ath5k/phy.c.old      2008-02-02 21:44:58.000000000 +0200
> > +++ linux-2.6/drivers/net/wireless/ath5k/phy.c  2008-02-02 21:48:28.000000000 +0200
> > @@ -1176,10 +1176,13 @@ static int ath5k_hw_rf5112_rfregs(struct
> >                 obdb = channel->freq >= 5725 ? 3 :
> >                     (channel->freq >= 5500 ? 2 :
> >                         (channel->freq >= 5260 ? 1 :
> >                             (channel->freq > 4000 ? 0 : -1)));
> >
> > +               if (obdb == -1)
> > +                       return -EINVAL;
> > +
> >                 if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
> >                                 ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
> >                         return -EINVAL;
> >
> >                 if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
> >
>
> Thanx ;-)
>
> Acked-by: Nick Kossifidis <mickflemm@gmail.com>

This won't apply after the API changes, I'll port it and send it as
part of the series.

Thanks,

  Luis
