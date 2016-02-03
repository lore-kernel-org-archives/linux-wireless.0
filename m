Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbcBCXFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:05:17 -0500
Date: Wed, 3 Feb 2016 15:05:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Glen Lee <glen.lee@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	tony.cho@atmel.com, leo.kim@atmel.com,
	Austin Shin <austin.shin@atmel.com>, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Subject: Re: [PATCH v2 1/2] staging: wilc1000: fix always return 0 error
Message-ID: <20160203230517.GB17828@kroah.com> (sfid-20160204_000531_402683_98E20E6C)
References: <1450936972-5773-1-git-send-email-glen.lee@atmel.com>
 <CAFqt6za45Mh-Fa5b5nfLkMuhPsbsC2OwPfVw2SWYZm0NfNWXbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFqt6za45Mh-Fa5b5nfLkMuhPsbsC2OwPfVw2SWYZm0NfNWXbA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 31, 2015 at 12:19:25AM +0530, Souptick Joarder wrote:
> HI Glen,
> 
> On Thu, Dec 24, 2015 at 11:32 AM, Glen Lee <glen.lee@atmel.com> wrote:
> > This patch fixes a bug that return always 0 so it fails every time.
> >
> > Fixes: c1af9db78950 ("staging: wilc1000: call linux_sdio_init instead of io_init")
> > Signed-off-by: Glen Lee <glen.lee@atmel.com>
> > ---
> > Changes in v2: separate v1 patch into two patches.
> > ---
> >  drivers/staging/wilc1000/wilc_sdio.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> > index e961b50..464d27d 100644
> > --- a/drivers/staging/wilc1000/wilc_sdio.c
> > +++ b/drivers/staging/wilc1000/wilc_sdio.c
> > @@ -614,8 +614,6 @@ static int sdio_init(struct wilc *wilc)
> >         if (!wilc_sdio_init()) {
> >                 dev_err(&func->dev, "Failed io init bus...\n");
> >                 return 0;
> > -       } else {
> > -               return 0;
> >         }
> 
> I think it's better to handle the error case properly when
> wilc_sdio_init() call fails.

It can't :)
