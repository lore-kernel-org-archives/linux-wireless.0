Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:36575 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab0I0Jrb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 05:47:31 -0400
Subject: Re: [PATCH 16/25] wl1271: Add support for hardware GEM cipher
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285578777.4043.6.camel@jlt3.sipsolutions.net>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-17-git-send-email-luciano.coelho@nokia.com>
	 <1285578777.4043.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 12:46:46 +0300
Message-ID: <1285580806.11177.65.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:12 +0200, ext Johannes Berg wrote:
> On Mon, 2010-09-27 at 11:37 +0300, Luciano Coelho wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > This patch adds support for the hardware GEM cipher suite.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---
> >  drivers/net/wireless/wl12xx/wl1271.h      |    2 ++
> >  drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +-
> >  drivers/net/wireless/wl12xx/wl1271_main.c |   16 ++++++++++++++++
> >  3 files changed, 19 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
> > index 763ece8..9782bc1 100644
> > --- a/drivers/net/wireless/wl12xx/wl1271.h
> > +++ b/drivers/net/wireless/wl12xx/wl1271.h
> > @@ -117,6 +117,8 @@ enum {
> >  #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
> >  #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
> >  
> > +#define WL1271_CIPHER_SUITE_GEM 0x000FACFF
> 
> NACK, this is a standards-reserved value. Use the correct ID for it or
> allocate one within your own OUI if you don't want to admit what this
> really is (and by now all readers here will know anyway.)

Well I'm sure many or most know what this patch is about. The choice of
value was not intended to hide that.

You're right though, we'll need to change the OUI of the value, unless
you can point me to an official value to use.

-Juuso


> johannes
> 
> 


