Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLJAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:00:48 -0500
Subject: Re: [PATCH] mac80211: Do not request FIF_BCN_PRBRESP_PROMISC for
 HW scan.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bartosz.Markowski@tieto.com,
	Janusz.Dziedzic@tieto.com
In-Reply-To: <CAMG6FYgGB12s+vTGRuKb1E8qzwMa3=kV2pm5ZFQ=BO4WqqZSRQ@mail.gmail.com> (sfid-20111211_225335_668297_3861F175)
References: <CAMG6FYgGB12s+vTGRuKb1E8qzwMa3=kV2pm5ZFQ=BO4WqqZSRQ@mail.gmail.com>
	 (sfid-20111211_225335_668297_3861F175)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:00:44 +0100
Message-ID: <1323680444.3442.5.camel@jlt3.sipsolutions.net> (sfid-20111212_100051_519504_47F64535)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-12-11 at 22:47 +0100, Dmitry Tarnyagin wrote:
> ieee80211_configure_filter code used local->scanning as a boolean value
> when it was a bit mask. Bits SCAN_HW_SCANNING, SCAN_COMPLETED, SCAN_ABORTED
> should not set FIF_BCN_PRBRESP_PROMISC filter.
> 
> Similar mistake was fixed also in ieee80211_hw_config (power
> configuration code).

Seems right -- although the probresp-promisc filter thing is debatable
and I think the changelog should be more explicit about it, maybe saying
that the driver can always change that by itself in the hw scan callback
if it requires it... That part isn't really only bugfix, it's a semantic
change.

The second part, yeah, obviously.

johannes

> Verified-by: Vitaly Wool <vitaly.wool@sonyeric­sson.com>
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> ---
>  net/mac80211/main.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index cae4435..54f78ab 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -47,7 +47,7 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
>  	if (atomic_read(&local->iff_allmultis))
>  		new_flags |= FIF_ALLMULTI;
> 
> -	if (local->monitors || local->scanning)
> +	if (local->monitors || test_bit(SCAN_SW_SCANNING, &local->scanning))
>  		new_flags |= FIF_BCN_PRBRESP_PROMISC;
> 
>  	if (local->fif_probe_req || local->probe_req_reg)
> @@ -193,8 +193,8 @@ int ieee80211_hw_config(struct ieee80211_local
> *local, u32 changed)
>  		changed |= IEEE80211_CONF_CHANGE_SMPS;
>  	}
> 
> -	if ((local->scanning & SCAN_SW_SCANNING) ||
> -	    (local->scanning & SCAN_HW_SCANNING))
> +	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
> +	    test_bit(SCAN_HW_SCANNING, &local->scanning))
>  		power = chan->max_power;
>  	else
>  		power = local->power_constr_level ?


