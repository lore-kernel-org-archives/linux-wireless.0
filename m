Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50468 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2K1FgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 00:36:08 -0500
Message-ID: <1354080927.25524.6.camel@cumari.coelho.fi> (sfid-20121128_063613_107600_7F128ADC)
Subject: Re: [PATCH 14/20] wlcore: restore default channel configuration
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Victor Goldenshtein <victorg@ti.com>
Date: Wed, 28 Nov 2012 07:35:27 +0200
In-Reply-To: <CA+XVXfeeo9kPmKyo=qtn_bAnj5gveiKa6PiMq8hV-5P9P4oyhw@mail.gmail.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-15-git-send-email-arik@wizery.com>
	 <1354023406.950.109.camel@cumari.coelho.fi>
	 <CA+XVXfeeo9kPmKyo=qtn_bAnj5gveiKa6PiMq8hV-5P9P4oyhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 23:32 +0200, Arik Nemtsov wrote:
> On Tue, Nov 27, 2012 at 3:36 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> >> From: Victor Goldenshtein <victorg@ti.com>
> >>
> >> wlcore allocates two static structs wl1271_band_2ghz & wl1271_band_5ghz
> >> which are used/modified by Reg-Domain e.g. some channel might be marked
> >> as passive at some point. Make sure we don't keep stale settings around
> >> if the HW is unregistered/registered during operation.
> >>
> >> [Arik - use Tx-power constant and tweak commit message]
> >>
> >> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >
> > [...]
> >
> >> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> >> index e68cd3f..3ced59b 100644
> >> --- a/drivers/net/wireless/ti/wlcore/main.c
> >> +++ b/drivers/net/wireless/ti/wlcore/main.c
> >
> > [...]
> >
> >> @@ -5537,6 +5537,7 @@ wlcore_iface_combinations[] = {
> >>
> >>  static int wl1271_init_ieee80211(struct wl1271 *wl)
> >>  {
> >> +     int i;
> >>       static const u32 cipher_suites[] = {
> >>               WLAN_CIPHER_SUITE_WEP40,
> >>               WLAN_CIPHER_SUITE_WEP104,
> >> @@ -5599,6 +5600,22 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
> >>                    ARRAY_SIZE(wl1271_channels_5ghz) >
> >>                    WL1271_MAX_CHANNELS);
> >>       /*
> >> +     * clear channel flags from the previous usage
> >> +     * and restore max_power & max_antenna_gain values.
> >> +     */
> >> +     for (i = 0; i < ARRAY_SIZE(wl1271_channels); i++) {
> >> +             wl1271_band_2ghz.channels[i].flags = 0;
> >> +             wl1271_band_2ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
> >> +             wl1271_band_2ghz.channels[i].max_antenna_gain = 0;
> >> +     }
> >> +
> >> +     for (i = 0; i < ARRAY_SIZE(wl1271_channels_5ghz); i++) {
> >> +             wl1271_band_5ghz.channels[i].flags = 0;
> >> +             wl1271_band_5ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
> >> +             wl1271_band_5ghz.channels[i].max_antenna_gain = 0;
> >> +     }
> >> +
> >> +     /*
> >
> > This looks a bit hacky, because you must know what values are being
> > modified by cfg80211.  What if in the future there are more values in
> > the channel structure that are being modified?
> >
> > The best would be to have a copy of the struct to pass to cfg80211 when
> > the hardware is registered and realloc it when we unregister.  That
> > would be safer and more future-proof, but would use a bit more memory
> > though.
> 
> Yea a new struct wasn't used because of the memory requirement. I
> agree a copy is cleaner.
> Let's start with this one to solve the actual bug and make a TODO for later?

Sure, let's add it to the TOneverbeDOne list. :P


> I'm also not sure that having cfg80211 change a structure allocated
> and owned by the driver is the cleanest solution for the regulatory
> stuff.

Yeah, but it has always been like that.  I think the idea is probably
the same: to avoid duplicate arrays.  But if cfg80211 modifies it, it
should be able to reset it back to the original as well.  Or the driver
must alloc a new one each time.

I wonder what the other drivers do...

--
Luca.

