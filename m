Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54121 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753902AbcHSBAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 21:00:19 -0400
Message-ID: <1471555301.28620.4.camel@sipsolutions.net> (sfid-20160819_031517_467121_A88AB4B7)
Subject: Re: [PATCH 1/3] mac80211: RX BA support for sta
 max_rx_aggregation_subframes
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Date: Thu, 18 Aug 2016 23:21:41 +0200
In-Reply-To: <20160818073627.30972-2-maxim.altshul@ti.com>
References: <20160818073627.30972-1-maxim.altshul@ti.com>
         <20160818073627.30972-2-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-18 at 10:36 +0300, Maxim Altshul wrote:
> 
> @@ -1735,6 +1735,9 @@ struct ieee80211_sta_rates {
>   * @supp_rates: Bitmap of supported rates (per band)
>   * @ht_cap: HT capabilities of this STA; restricted to our own
> capabilities
>   * @vht_cap: VHT capabilities of this STA; restricted to our own
> capabilities
> + * @max_rx_aggregation_subframes: restriction on rx buff size for
> this active
> + *	aggregation. Initially set to local-
> >hw.max_rx_aggregation_subframes but
> + *	can be modified by driver.

The documentation for this makes no sense, it's clearly not a per
"active aggregation" parameter in any way.

>  /**
> + * ieee80211_change_rx_ba_max_subframes - callback to change
> + * sta.max_rx_aggregation_subframes and stop existing BA sessions
> + *
> + * This capability is useful in cases of IOP, i.e. cases where peer
> sta
> + * or ap doesn't respect the max size (Kbps) of an AMPDU.
> + * In these cases the driver/chip may recover by decreasing the
> + * max_rx_aggregation_subframes, which will in turn reduce the size
> of
> + * the whole aggregation.
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface
> callback.
> + * @addr: & to bssid mac address
> + * @max_subframes: new max_rx_aggregation_subframes for this sta
> + */
> +void ieee80211_change_rx_ba_max_subframes(struct ieee80211_vif *vif,
> +					  const u8 *addr,
> +					  u8 max_subframes);

I see no reason for this to exist, it's practically equivalent to
something like this:

sta = ieee80211_find_sta(vif, addr);
if (sta)
	sta->max_subframes = max_subframes;
ieee80211_stop_rx_ba_session(vif, 0xff, addr);

so there's no real need for this. What you did has an advantage if the
driver is doing something stupid like calling the function with the
same argument multiple times, but that's easily fixed or prevented; I
don't really see any other advantages?

johannes
