Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46373 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab1JPK6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Oct 2011 06:58:47 -0400
Received: by iaek3 with SMTP id k3so4807101iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Oct 2011 03:58:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318710223-29285-1-git-send-email-guy@wizery.com>
References: <1318710223-29285-1-git-send-email-guy@wizery.com>
Date: Sun, 16 Oct 2011 12:58:46 +0200
Message-ID: <CAB3XZEdk2pxH4k4tYXn44Sdb8STdXEh7VVsE85__e=M2Fk9s7A@mail.gmail.com> (sfid-20111016_125851_006460_DEADB846)
Subject: Re: [PATCH] wl12xx: set scan probe requests rate according to the
 no_cck flag
From: Eliad Peller <eliad@wizery.com>
To: Guy Eilam <guy@wizery.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Guy,

On Sat, Oct 15, 2011 at 10:23 PM, Guy Eilam <guy@wizery.com> wrote:
> Set the TX rate of probe requests during scanning according to the
> no_cck flag in the scan request struct.
>
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---
[...]

> @@ -243,7 +242,12 @@ void wl1271_scan_stm(struct wl1271 *wl)
>
>        case WL1271_SCAN_STATE_2GHZ_ACTIVE:
>                band = IEEE80211_BAND_2GHZ;
> -               rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
> +               if (wl->scan.req->no_cck)
> +                       rate = wl1271_tx_min_rate_get(wl,
> +                                                CONF_TX_RATE_MASK_BASIC_P2P);
> +               else
> +                       rate = wl1271_tx_min_rate_get(wl,
> +                                                CONF_TX_RATE_MASK_BASIC);

on a second thought, this seems a bit wrong.
i think we should consider the configured bitrate_masks when scanning.
maybe just mask-out the cck rates?

Eliad.
