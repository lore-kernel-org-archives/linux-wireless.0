Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:44588 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0K3FaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 00:30:21 -0500
Subject: Re: [PATCH] wl12xx: Remove 11j channels from the supported
 channels list.
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: geryk@ti.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291061407.1673.78.camel@powerslave>
References: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
	 <4CF39DBA.2020004@ti.com>  <1291061407.1673.78.camel@powerslave>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 07:30:03 +0200
Message-ID: <1291095003.4284.5632.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 22:10 +0200, Luciano Coelho wrote:
> On Mon, 2010-11-29 at 14:34 +0200, ext Gery Kahn wrote:
> > On 11/29/2010 12:05 PM, juuso.oikarinen@nokia.com wrote:
> > > From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> > >
> > > Because we don't support them at this stage.
> > >
> > > Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> > > ---
> > >   drivers/net/wireless/wl12xx/main.c |    8 --------
> > >   1 files changed, 0 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > > index 7fecefe..dc3a093 100644
> > > --- a/drivers/net/wireless/wl12xx/main.c
> > > +++ b/drivers/net/wireless/wl12xx/main.c
> > > @@ -2374,14 +2374,6 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
> > >
> > >   /* 5 GHz band channels for WL1273 */
> > >   static struct ieee80211_channel wl1271_channels_5ghz[] = {
> > > -	{ .hw_value = 183, .center_freq = 4915},
> > > -	{ .hw_value = 184, .center_freq = 4920},
> > > -	{ .hw_value = 185, .center_freq = 4925},
> > > -	{ .hw_value = 187, .center_freq = 4935},
> > > -	{ .hw_value = 188, .center_freq = 4940},
> > > -	{ .hw_value = 189, .center_freq = 4945},
> > > -	{ .hw_value = 192, .center_freq = 4960},
> > > -	{ .hw_value = 196, .center_freq = 4980},
> > >   	{ .hw_value = 7, .center_freq = 5035},
> > >   	{ .hw_value = 8, .center_freq = 5040},
> > >   	{ .hw_value = 9, .center_freq = 5045},
> > Our firmware do supports Japan channels, so why to remove them?
> 
> We experienced some problems with it (at least).  Juuso reported that
> some strange things were happening, like probe_reqs were going to 2.4GHz
> channels with 11a IEs when these 11j channels were scanned.
> 
> Have you actively tried to use 11j channels? Did you have any problems?
> 

Yes, and also the NVS INI section (look at ini.h) appears to be
currently missing all the calibration/compensation etc values for the
11j channels.

So it seems even if the firmware may support 11j, the infrastructure on
the host side is still lacking. It seems to me there is some work to be
done before these can be enabled.

-Juuso


