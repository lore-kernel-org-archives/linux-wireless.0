Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:59801 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0KVGCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 01:02:20 -0500
Subject: RE: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a
 DFS frequencies
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Gabay, Benzy" <benzyg@ti.com>
Cc: "luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03B9@dlee04.ent.ti.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03B9@dlee04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:00:49 +0200
Message-ID: <1289977249.2522.148.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 00:52 -0600, ext Gabay, Benzy wrote:
> Juuso,
> 
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The wl1271 does not support radar detection. Hence, prevent ad-hoc and
> > active scanning on frequencies requiring DFS.
> 
> I know it's a bit late but:
> Doesn't the fact that your referring here to 1271, which is support 2.4Ghz device only matter here to anyone?
> Correct me if I'm wrong here but radar detection was meant only for 5.0Ghz device types. 
> Should this patch should be done on 1273 device type or a change in the naming convention should be applied here.

Yes, you are correct in the fact the naming here is wrong. I used it,
because for legacy reasons, the driver was still called wl1271 at the
time I wrote the patch. Although the driver was named "wl1271" it is
still intended to drive also the wl1273.

Recently, work has been ongoing to change this naming. The wl1271 driver
was renamed to wl12xx to better reflect reality, as you have possibly
noted.

-Juuso

> 
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  drivers/net/wireless/wl12xx/wl1271_main.c |   23
> > +++++++++++++++++++++++
> >  1 files changed, 23 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c
> > b/drivers/net/wireless/wl12xx/wl1271_main.c
> > index f5b1d19..eb9f821 100644
> > --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> > +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> > @@ -335,6 +335,27 @@ out:
> >  	return NOTIFY_OK;
> >  }
> > 
> > +static int wl1271_reg_notify(struct wiphy *wiphy,
> > +			     struct regulatory_request *request) {
> > +	struct ieee80211_supported_band *band;
> > +	struct ieee80211_channel *ch;
> > +	int i;
> > +
> > +	band = wiphy->bands[IEEE80211_BAND_5GHZ];
> > +	for (i = 0; i < band->n_channels; i++) {
> > +		ch = &band->channels[i];
> > +		if (ch->flags % IEEE80211_CHAN_DISABLED)
> > +			continue;
> > +
> > +		if (ch->flags & IEEE80211_CHAN_RADAR)
> > +			ch->flags |= IEEE80211_CHAN_NO_IBSS |
> > +				     IEEE80211_CHAN_PASSIVE_SCAN;
> > +
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static void wl1271_conf_init(struct wl1271 *wl)
> >  {
> > 
> > @@ -2590,6 +2611,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
> >  	wl->hw->queues = 4;
> >  	wl->hw->max_rates = 1;
> > 
> > +	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
> > +
> >  	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
> > 
> >  	return 0;
> > --
> > 1.7.1
> 
> 
> 
> =========
> Benzy Gabay
> Texas Instruments


