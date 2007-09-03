Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:59878 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbXICUxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 16:53:13 -0400
Received: by py-out-1112.google.com with SMTP id u77so5074892pyb
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2007 13:53:12 -0700 (PDT)
Message-ID: <40f31dec0709031353t8b2c8deqdc641fe25fc67f6@mail.gmail.com>
Date: Mon, 3 Sep 2007 23:53:12 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Ath5k panic fix
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46DC588D.40305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <m3ejhfvbp3.fsf@maximus.localdomain> <46DC588D.40305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/9/3, Jiri Slaby <jirislaby@gmail.com>:
> Krzysztof Halasa napsal(a):
> > Ath5k panics on ath_open() because sc->pdev is never set, fixed.
> >
> > Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
>
> Acked-by: Jiri Slaby <jirislaby@gmail.com>
>
> I wonder how it is possible that the driver works here.
>
> > --- a/drivers/net/wireless/ath5k_base.c
> > +++ b/drivers/net/wireless/ath5k_base.c
> > @@ -2295,6 +2295,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
> >       hw->max_rssi = 127; /* FIXME: get a real value for this. */
> >       sc = hw->priv;
> >       sc->hw = hw;
> > +     sc->pdev = pdev;
> >
> >       /*
> >        * Mark the device as detached to avoid processing
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
> thanks,

I've already fixed this on r2698 ;-)
http://madwifi.org/changeset/2698

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
