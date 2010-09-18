Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43095 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab0IRR4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 13:56:19 -0400
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 18 Sep 2010 19:56:08 +0200
Subject: RE: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600113431FC4@dnce02.ent.ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
 <1284575472-19888-5-git-send-email-shahar_levi@ti.com>
 <1284578468.1569.29.camel@powerslave>
 <AANLkTimCrCH_yh5y3L8WcfNus9A2RFMCqvK7Xb82VGUL@mail.gmail.com>
 <AC090B9732AB2B4DB7FF476E907FE6600113431B85@dnce02.ent.ti.com>
 <AANLkTinPodQRk8HYDxxZ9BiKJ=-yAg8nybVqGpCqXsa2@mail.gmail.com>
In-Reply-To: <AANLkTinPodQRk8HYDxxZ9BiKJ=-yAg8nybVqGpCqXsa2@mail.gmail.com>
Content-Type: text/plain; charset="windows-1255"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Thursday, September 16, 2010 7:17 PM
> To: Levi, Shahar
> Cc: Luciano Coelho; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
> 
> 2010/9/17 Levi, Shahar <shahar_levi@ti.com>:
> >> -----Original Message-----
> >> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> >> Sent: Thursday, September 16, 2010 2:39 AM
> >> To: Luciano Coelho
> >> Cc: Levi, Shahar; linux-wireless@vger.kernel.org
> >> Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
> >>
> >> On Thu, Sep 16, 2010 at 05:21, Luciano Coelho <luciano.coelho@nokia.com>
> >> wrote:
> >> > On Wed, 2010-09-15 at 20:31 +0200, ext Shahar Levi wrote:
> >> >> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c
> >> b/drivers/net/wireless/wl12xx/wl1271_main.c
> >> >> index e89e574..8f2cea9 100644
> >> >> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> >> >> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> >> >> @@ -2087,7 +2087,9 @@ static struct ieee80211_supported_band
> >> wl1271_band_2ghz = {
> >> >>       .n_channels = ARRAY_SIZE(wl1271_channels),
> >> >>       .bitrates = wl1271_rates,
> >> >>       .n_bitrates = ARRAY_SIZE(wl1271_rates),
> >> >> +#ifdef CONFIG_WL1271_HT
> >> >>       .ht_cap = WL12xx_HT_CAP,
> >> >> +#endif
> >> >
> >> > Here you can use #ifdef CONFIG_WL1271_80211_HT directly, no need to
> >> > duplicate it into a new flag.
> >>
> >> Another thing you might want to do could be to adjust the order of the
> >> patches so you introduce this config option *before* you introduce the
> >> actual code that is protected by it. At the moment, this functionality
> >> is enabled unconditionally if this patch isn't applied, which could
> >> potentially occur during bisection, given that John doesn't squash the
> >> patches into one when he applies them.
> >>
> >> Thanks,
> >>
> >> --
> >>
> >> Julian Calaby
> >>
> >
> > Hi Julian,
> > It is a good point. ".ht_cap = WL12xx_HT_CAP" in wl1271_main.c adds only on
> patch 03/04. I believe that adding "#ifdef CONFIG_WL1271_HT" in wl1271_main.c
> with early patch on code that not exist is less clear. Squashing the patches
> 03 and 04 to one in v2 could prevent that but it will not emphasize the
> configuration option. Is there are cases that the some patches from series not
> applies?
> 
> Bisection (which seems to be my watch word, at the moment) could jump
> into the middle of random patch sets like this.
> 
> Personally, I'd squash 3 and 4 into one patch: I.e. you're saying
> "here's the functionality and it's protected by a Kconfig variable."
> The fact that it's touching the Kconfig file is probably enough
> emphasis in and of itself.
> 
> > Thanks for your review,
> 
> No problem,
> 
> --
> 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/

I am confuse. If there option that patch isn't applied from a series how we could trust any patches series we send to that list. I would greatly appreciate if you help me to understand and elaborate what it bisection danger. Am I missing something?
I really appreciate your willingness to help.
Regards,
Shahar
 

