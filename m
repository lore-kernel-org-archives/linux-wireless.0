Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:36779 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752555AbYG2UzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 16:55:11 -0400
Received: from chimera.site ([96.225.228.12]) by xenotime.net for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 13:55:09 -0700
Date: Tue, 29 Jul 2008 13:55:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Andreas Schwab" <schwab@suse.de>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: Fix iwlwifi compilation without CONFIG_IWLWIFI_DEBUG
Message-Id: <20080729135509.6db7c9b4.rdunlap@xenotime.net> (sfid-20080729_225516_192899_84AFBD71)
In-Reply-To: <1ba2fa240807291350m4d698713k7c3ea21d25ee105f@mail.gmail.com>
References: <jebq0g8qdf.fsf@sykes.suse.de>
	<1ba2fa240807291350m4d698713k7c3ea21d25ee105f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 29 Jul 2008 23:50:25 +0300 Tomas Winkler wrote:

> On Tue, Jul 29, 2008 at 10:03 PM, Andreas Schwab <schwab@suse.de> wrote:
> > drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
> > drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
> > drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
> > drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
> >
> > Signed-off-by: Andreas Schwab <schwab@suse.de>
> > ---
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
> > index 899d7a2..a58571c 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-led.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
> > @@ -195,8 +195,10 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
> >                return;
> >
> >
> > +#ifdef CONFIG_IWLWIFI_DEBUG
> >        IWL_DEBUG_LED("Led type = %s brightness = %d\n",
> >                        led_type_str[led->type], brightness);
> > +#endif
> >        switch (brightness) {
> >        case LED_FULL:
> >                if (led->type == IWL_LED_TRG_ASSOC)
> >
> 
> Thanks for your patch
> But the fixes were already sent out  a week ago or You can find them
> on this mailing list.

But the reason that we are seeing this (third IIRC) patch for this problem
is that the patch needs to be merged somewhere..... :(
other than the mailing list.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
