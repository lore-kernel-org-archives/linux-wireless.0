Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37620 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932336Ab1JaJhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:37:05 -0400
Received: by bkbzs8 with SMTP id zs8so2981535bkb.40
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 02:37:01 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: set scan probe requests rate according to the
 no_cck flag
From: Luciano Coelho <coelho@ti.com>
To: guy@wizery.com
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
In-Reply-To: <CAB3XZEdk2pxH4k4tYXn44Sdb8STdXEh7VVsE85__e=M2Fk9s7A@mail.gmail.com>
References: <1318710223-29285-1-git-send-email-guy@wizery.com>
	 <CAB3XZEdk2pxH4k4tYXn44Sdb8STdXEh7VVsE85__e=M2Fk9s7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 11:36:57 +0200
Message-ID: <1320053817.2672.1.camel@cumari> (sfid-20111031_103710_951117_C8E29626)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-10-16 at 12:58 +0200, Eliad Peller wrote: 
> hi Guy,
> 
> On Sat, Oct 15, 2011 at 10:23 PM, Guy Eilam <guy@wizery.com> wrote:
> > Set the TX rate of probe requests during scanning according to the
> > no_cck flag in the scan request struct.
> >
> > Signed-off-by: Guy Eilam <guy@wizery.com>
> > ---
> [...]
> 
> > @@ -243,7 +242,12 @@ void wl1271_scan_stm(struct wl1271 *wl)
> >
> >        case WL1271_SCAN_STATE_2GHZ_ACTIVE:
> >                band = IEEE80211_BAND_2GHZ;
> > -               rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
> > +               if (wl->scan.req->no_cck)
> > +                       rate = wl1271_tx_min_rate_get(wl,
> > +                                                CONF_TX_RATE_MASK_BASIC_P2P);
> > +               else
> > +                       rate = wl1271_tx_min_rate_get(wl,
> > +                                                CONF_TX_RATE_MASK_BASIC);
> 
> on a second thought, this seems a bit wrong.
> i think we should consider the configured bitrate_masks when scanning.
> maybe just mask-out the cck rates?

Any follow up on this?

-- 
Cheers,
Luca.

