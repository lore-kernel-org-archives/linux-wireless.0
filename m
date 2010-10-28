Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:38263 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab0J1PL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 11:11:27 -0400
Subject: Re: b43 sdio: WARNING: at drivers/mmc/core/core.c:237
 mmc_wait_for_cmd
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CC99206.5090105@arndnet.de> (sfid-20101028_170910_533098_04D99458)
References: <4CC874F4.5050908@arndnet.de> <4CC8CAAE.3040100@lwfinger.net>
	 <4CC98892.7080000@arndnet.de> <4CC98D85.20703@lwfinger.net>
	 <4CC99206.5090105@arndnet.de> (sfid-20101028_170910_533098_04D99458)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 17:11:18 +0200
Message-ID: <1288278678.29188.71.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-28 at 17:08 +0200, Arnd Hannemann wrote: 
> > Index: wireless-testing/drivers/net/wireless/b43/sdio.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/b43/sdio.c
> > +++ wireless-testing/drivers/net/wireless/b43/sdio.c
> > @@ -175,7 +175,9 @@ static void b43_sdio_remove(struct sdio_
> >  	struct b43_sdio *sdio = sdio_get_drvdata(func);
> > 
> >  	ssb_bus_unregister(&sdio->ssb);
> > +	sdio_claim_host(func);
> >  	sdio_disable_func(func);
> > +	sdio_release_host(func);
> >  	kfree(sdio);
> >  	sdio_set_drvdata(func, NULL);
> >  }
> > 
> 
> Thanks, that fixes the warning.

I'm OK with that patch.

-- 
Greetings Michael.

