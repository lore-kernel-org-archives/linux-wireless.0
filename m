Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33049 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753277AbdCHNZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 08:25:46 -0500
Received: by mail-wr0-f177.google.com with SMTP id u48so23284773wrc.0
        for <linux-wireless@vger.kernel.org>; Wed, 08 Mar 2017 05:24:54 -0800 (PST)
Subject: Re: [PATCH] mac80211: reject/clear user rate mask if not usable
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170308102008.31184-1-johannes@sipsolutions.net>
Cc: kirtika@google.com, Johannes Berg <johannes.berg@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9f80f983-ca51-ae55-163e-311d86d1edbe@broadcom.com> (sfid-20170308_142643_182824_B63E35CF)
Date: Wed, 8 Mar 2017 14:17:44 +0100
MIME-Version: 1.0
In-Reply-To: <20170308102008.31184-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8-3-2017 11:20, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the user rate mask results in no (basic) rates being usable,
> clear it. Also, if we're already operating when it's set, reject
> it instead.
> 
> Technically, selecting basic rates as the criterion is a bit too
> restrictive, but calculating the usable rates over all stations
> (e.g. in AP mode) is harder, and all stations must support the
> basic rates. Similarly, in client mode, the basic rates will be
> used anyway for control frames.
> 
> This fixes the "no supported rates (...) in rate_mask ..." warning
> that occurs on TX when you've selected a rate mask that's not
> compatible with the connection (e.g. an AP that enables only the
> rates 36, 48, 54 and you've selected only 6, 9, 12.)
> 
> Reported-by: Kirtika Ruchandani <kirtika@google.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/cfg.c  | 18 +++++++++++++++++-
>  net/mac80211/mlme.c |  2 ++
>  net/mac80211/rate.c | 29 +++++++++++++++++++++++++++++
>  net/mac80211/rate.h |  2 ++
>  4 files changed, 50 insertions(+), 1 deletion(-)
> 

[...]

> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index 094c15645228..8c8d178ba798 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -2,6 +2,7 @@
>   * Copyright 2002-2005, Instant802 Networks, Inc.
>   * Copyright 2005-2006, Devicescape Software, Inc.
>   * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
> + * Copyright 2017	Intel Deutschland GmbH
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -241,6 +242,34 @@ static void rate_control_free(struct ieee80211_local *local,
>  	kfree(ctrl_ref);
>  }
>  
> +void ieee80211_check_rate_mask(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_supported_band *sband;
> +	u32 user_mask, basic_rates = sdata->vif.bss_conf.basic_rates;
> +	enum nl80211_band band;
> +
> +	if (WARN_ON(!sdata->vif.bss_conf.chandef.chan))
> +		return;
> +
> +	if (WARN_ON_ONCE(!basic_rates))
> +		return;
> +
> +	band = sdata->vif.bss_conf.chandef.chan->band;
> +	user_mask = sdata->rc_rateidx_mask[band];
> +	sband = local->hw.wiphy->bands[band];
> +
> +	basic_rates = sdata->vif.bss_conf.basic_rates;

basic_rates has already been initialized (and checked) above so this is
redundant.

Regards,
Arend
