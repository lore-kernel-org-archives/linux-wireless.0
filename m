Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:57982 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbXJaRMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 13:12:15 -0400
Received: by an-out-0708.google.com with SMTP id b36so27846ana
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 10:12:14 -0700 (PDT)
Message-ID: <43e72e890710311012h598591e3qeb2cdf6b5e664f5a@mail.gmail.com> (sfid-20071031_171220_025610_C63C92BC)
Date: Wed, 31 Oct 2007 13:12:13 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Remove fill_tx_desc
Cc: "Ulrich Meis" <meis@nets.rwth-aachen.de>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0710301334g4c012906va5c66b0f1b85bc83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071027235827.GH5973@localhost.domain.invalid>
	 <43e72e890710300945r41bd982bife52835660ff0c10@mail.gmail.com>
	 <20071030192740.GA10233@nets.rwth-aachen.de>
	 <40f31dec0710301334g4c012906va5c66b0f1b85bc83@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2007/10/30, Ulrich Meis <meis@nets.rwth-aachen.de>:
> > On Tue 30.10.07 12:45, Luis R. Rodriguez wrote:
> > > On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:
> > > > fill_tx_desc is used for fast frames operation, since
> > > > we don't support fast frames (and since fill_tx_desc
> > > > had a bug -thanx to Ulrich Meis for finding that out-)
> > > > these functions are not needed (+ they are misleading
> > > > because they don't "fill" any tx descriptor).
> > > >
> > > > I couldn't test this patch much so plz someone ACK it...
> > > >
> > > > It applies on top of my previous patches (i just thought
> > > > that [PATCH 8/7] won't look nice ;-) ).
> > > >
> > > >
> > > > Changes-licensed-under: ISC
> > > > Signed-off-by: Ulrich Meis <meis@nets.rwth-aachen.de>
> > > > Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> > >
> > > Very nice, I've been testing this on 2.6.24-rc1 for a day without
> > > problems. I'll soon post results of of all your patches and your 1-7
> > > series on big endian. Compiling takes a while there, heh.. I guess I
> > > should be cross compiling huh.
> >
> > People using the 5212 need the line below though if they wanna be able
> > to sent out frames :) It's missing in the 4word version. Besides that
> > the patches also seem to run fine here.
> >
> > Uli
> >
>
> Ouch, i've missed this, thanx for finding out ;-)
>
> > +       tx_desc->tx_control_1 = buff_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
> > +
>
> 2W_TX_DESC -> define for 2word descriptor (check out hw.h) just to
> maintain naming
> scheme, i suggest we use the 4W_TX_DESC define (they are the same
> values but it's better for code readability).
>
>  tx_desc->tx_control_1 = buff_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
>
> can you plz repost the patch as a separate thread (check out
> http://www.linuxwireless.org/en/developers/SubmittingPatches) ?

IMO you should have just sent a patch as your patch really does break
AR5212 TX but whatever works with John. Anyway, just a pointer to John
-- hunk 3 on hw.c will fail here but its not important its just a
redundant hunk.

  Luis
