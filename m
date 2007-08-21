Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33353
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXHUWAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 18:00:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 6/6] b43: New firmware file format
Date: Tue, 21 Aug 2007 23:58:39 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20070818234833.623623000@bu3sch.de> <1187711200.4218.0.camel@johannes.berg> <20070821201336.GA5313@tuxdriver.com>
In-Reply-To: <20070821201336.GA5313@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708212358.39762.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 21 August 2007 22:13:36 John W. Linville wrote:
> On Tue, Aug 21, 2007 at 05:46:40PM +0200, Johannes Berg wrote:
> > On Sun, 2007-08-19 at 01:48 +0200, Michael Buesch wrote:
> > 
> > > @@ -1598,8 +1601,29 @@ static int do_request_fw(struct b43_wlde
> > >  		b43err(dev->wl, "Firmware file \"%s\" not found "
> > >  		       "or load failed.\n", path);
> > 
> > +		return err;
> > 
> > >  	}
> > > +	if ((*fw)->size < sizeof(struct b43_fw_header))
> > > +		goto err_format;
> > 
> > otherwise it oopses when the file can't be loaded.
> 
> ACK...here is a patch, in case you are lazy... :-)

Whoops, thanks :)

> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index dcf7edc..d8693cf 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -1600,6 +1600,7 @@ static int do_request_fw(struct b43_wldev *dev,
>  	if (err) {
>  		b43err(dev->wl, "Firmware file \"%s\" not found "
>  		       "or load failed.\n", path);
> +		return err;
>  	}
>  	if ((*fw)->size < sizeof(struct b43_fw_header))
>  		goto err_format;



-- 
Greetings Michael.
