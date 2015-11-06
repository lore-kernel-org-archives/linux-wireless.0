Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033985AbbKFWQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 17:16:43 -0500
Date: Sat, 7 Nov 2015 01:16:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: punit vara <punitvara@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wilc1000: Declare *wilc in init_wilc_driver to
 fix build error
Message-ID: <20151106221624.GE18797@mwanda> (sfid-20151106_231706_478689_34C83BDE)
References: <1446847163-9643-1-git-send-email-punitvara@gmail.com>
 <CABXAfNJZSgy+2v1VH8LVhYTtjsgKGmY3u7eyu8mUfYMezRcFPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABXAfNJZSgy+2v1VH8LVhYTtjsgKGmY3u7eyu8mUfYMezRcFPQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh...  Sorry.  I got your email confused with someone else.

> > diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> > index 2a5b36f..0805050 100644
> > --- a/drivers/staging/wilc1000/linux_wlan.c
> > +++ b/drivers/staging/wilc1000/linux_wlan.c
> > @@ -1780,6 +1780,7 @@ int wilc_netdev_init(struct wilc **wilc)
> >  /*The 1st function called after module inserted*/
> >  static int __init init_wilc_driver(void)
> >  {
> > +       struct wilc *wilc;
> >  #ifdef WILC_SPI
> >         struct wilc *wilc;
> >  #endif


The problem is that now if WILC_SPI is defined it's declared twice so
this patch is definitely wrong.  I haven't looked at it further than
that, sorry.

CC the atmel people with these patches.  Use ./scripts/get_maintainer.pl
to find the right maintainers.

regards,
dan carpenter

