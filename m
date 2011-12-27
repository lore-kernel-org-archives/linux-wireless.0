Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1L0XGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 18:06:01 -0500
Date: Wed, 28 Dec 2011 00:05:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] b43: fix regression in PIO case
In-Reply-To: <CACna6ry1tKXtUSQHknkEbzBq_gZUyxn1-9Guba2a56xzx242SA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112272359240.6684@axis700.grange> (sfid-20111228_000623_607911_1264F7CE)
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange> <alpine.DEB.2.00.1112261824000.12108@axis700.grange> <CACna6ry1tKXtUSQHknkEbzBq_gZUyxn1-9Guba2a56xzx242SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Dec 2011, Rafał Miłecki wrote:

> W dniu 26 grudnia 2011 18:28 użytkownik Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> napisał:
> > This patch fixes the regression, introduced by
> >
> > commit 17030f48e31adde5b043741c91ba143f5f7db0fd
> > From: Rafał Miłecki <zajec5@gmail.com>
> > Date: Thu, 11 Aug 2011 17:16:27 +0200
> > Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw
> >
> > in PIO case.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
> > index ce8a4bd..b64b64c 100644
> > --- a/drivers/net/wireless/b43/pio.c
> > +++ b/drivers/net/wireless/b43/pio.c
> > @@ -617,9 +617,19 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
> >        const char *err_msg = NULL;
> >        struct b43_rxhdr_fw4 *rxhdr =
> >                (struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
> > +       size_t rxhdr_size = sizeof(*rxhdr);
> >
> >        BUILD_BUG_ON(sizeof(wl->pio_scratchspace) < sizeof(*rxhdr));
> > -       memset(rxhdr, 0, sizeof(*rxhdr));
> > +       switch (dev->fw.hdr_format) {
> > +       case B43_FW_HDR_410:
> > +       case B43_FW_HDR_351:
> > +               rxhdr_size -= sizeof(rxhdr->format_598) -
> > +                       sizeof(rxhdr->format_351);
> > +               break;
> > +       case B43_FW_HDR_598:
> > +               break;
> > +       }
> > +       memset(rxhdr, 0, rxhdr_size);
> 
> Huuh, that's really tricky. Can you just do "normal" conditions as
> Larry suggested, please?

Sorry? I absolutely see nothing tricky there. Do you think this would look 
"less tricky" to you:

	switch (dev->fw.hdr_format) {
	case B43_FW_HDR_410:
	case B43_FW_HDR_351:
		rxhdr_size = offsetof(struct b43_rxhdr_fw4,
					format_351) +
			sizeof(rxhdr_size->format_351);
		break;
	case B43_FW_HDR_598:
		rxhdr_size = sizeof(*rxhdr);
		break;
	}

?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
