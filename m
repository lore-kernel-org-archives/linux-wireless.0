Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21294 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab0J1Rea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 13:34:30 -0400
Subject: Re: [PATCH ] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CC9AC72.40909@ti.com>
References: <1288091935-21688-1-git-send-email-shahar_levi@ti.com>
	 <1288207558.1698.56.camel@powerslave>  <4CC9A1F5.4010308@ti.com>
	 <1288285263.3414.7.camel@powerslave>  <4CC9AC72.40909@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 20:53:56 +0300
Message-ID: <1288288436.3414.10.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-28 at 19:01 +0200, ext Shahar Levi wrote:
> On 10/28/2010 07:01 PM, Luciano Coelho wrote:
> > On Thu, 2010-10-28 at 18:16 +0200, ext Shahar Levi wrote:
> >> On 10/27/2010 09:25 PM, Luciano Coelho wrote:
> >>> On Tue, 2010-10-26 at 13:18 +0200, ext Shahar Levi wrote:
> >>>> +wl12xx_spi-objs                = spi.o
> >>>> +wl12xx_sdio-objs       = sdio.o
> >>>
> >>> Here...
> >> Will be fix in v2
> >
> > There's nothing to fix here.  I just pointed out that the modules are
> > actually called wl12xx_sdio and wl12xx_spi.  So it's correct here
> > already.
> Due to the fact it is confusing spi and sdio i renamed spi.c file name 
> to wl12xx_spi.c (in v2) and in that case i remove those lines.
> The same catch for sdio.c

Sorry, I don't get the reasoning behind this.  sdio.c and spi.c are
better than wl12xx_sdio.c and wl12xx_spi.c.  Why not keep things
consistent all across?


> >>>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/main.c
> >>>> similarity index 99%
> >>>> rename from drivers/net/wireless/wl12xx/wl1271_main.c
> >>>> rename to drivers/net/wireless/wl12xx/main.c
> >>>> index 63036b5..dab10a5 100644
> >>>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> >>>> +++ b/drivers/net/wireless/wl12xx/main.c
> >>>> @@ -31,20 +31,20 @@
> >>>
> >>> [...]
> >>>
> >>>>    #define WL1271_BOOT_RETRIES 3
> >>>
> >>> Did we agree not to change this stuff for now? Yes, now I remember, it's
> >>> better to do it in two steps indeed (ie. do the other changes in a
> >>> separate patch).  But I'd rather apply all the patches add once.
> >> I believe that patch could stand alone. There isn't any connection
> >> between files names and function+defines names.
> >
> > Yes, no need to change these macros or function names in this patch.
> In that case it can be apply alon, is it? ;-)

Not sure I understand this.  We should have two separate patches, one
with the file name changes (including the #define __CONF_H__ stuff) and
another patch just to change the function names and macros.

-- 
Cheers,
Luca.

