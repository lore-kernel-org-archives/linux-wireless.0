Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53891 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0JKN4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:56:16 -0400
Subject: Re: [PATCH v2 03/03] wl1271: 11n Support, functionality and
 configuration ability
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CB1DAC8.6050609@ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
	 <1286388491-28752-5-git-send-email-shahar_levi@ti.com>
	 <1286528736.21349.42.camel@chilepepper>  <4CB1DAC8.6050609@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 16:55:56 +0300
Message-ID: <1286805356.24158.3.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 17:24 +0200, ext Shahar Levi wrote:
> >>  static const u8 *wl1271_band_rate_to_idx[] = {
> >> diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c
> b/drivers/net/wireless/wl12xx/wl1271_rx.c
> >> index 94da5dd..109a470 100644
> >> --- a/drivers/net/wireless/wl12xx/wl1271_rx.c
> >> +++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
> >> @@ -53,6 +53,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
> >>      status->band = wl->band;
> >>      status->rate_idx = wl1271_rate_to_idx(wl, desc->rate);
> >>  
> >> +    /* 11n support */
> >> +    if (desc->rate <= CONF_HW_RXTX_RATE_MCS0)
> >> +            status->flag |= RX_FLAG_HT;
> >> +
> >>      status->signal = desc->rssi;
> > 
> > Should this be #ifdef'ed also?
> 
> No, in case of HT not supported the HW will not set MCS rate.

True, but if you don't have the ifdef you're adding unnecessary code in
the RX data path.


> >> diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c
> b/drivers/net/wireless/wl12xx/wl1271_tx.c
> >> index 1b8295c..af54fef 100644
> >> --- a/drivers/net/wireless/wl12xx/wl1271_tx.c
> >> +++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
> >> @@ -236,6 +236,15 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271
> *wl, u32 rate_set)
> >>              rate_set >>= 1;
> >>      }
> >>  
> >> +    /* MCS rates indication are on bits 16 - 23 */
> >> +    rate_set >>= HW_HT_RATES_OFFSET - band->n_bitrates;
> >> +
> >> +    for (bit = 0; bit < 8; bit++) {
> >> +            if (rate_set & 0x1)
> >> +                    enabled_rates |= (CONF_HW_BIT_RATE_MCS_0 <<
> bit);
> >> +            rate_set >>= 1;
> >> +    }
> >> +
> > 
> > And this? #ifdef here as well, maybe? 
> 
> No, in case of HT not supported MCS bit in rate_set will not be set.

Same here, this loop will add more CPU cycles in the TX data path
unnecessarily.



-- 
Cheers,
Luca.

