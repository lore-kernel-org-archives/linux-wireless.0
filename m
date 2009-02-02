Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:38620 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZBBLPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 06:15:13 -0500
Received: by fxm13 with SMTP id 13so1395883fxm.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 03:15:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18822.51903.216795.888284@gargle.gargle.HOWL>
References: <18822.51903.216795.888284@gargle.gargle.HOWL>
Date: Mon, 2 Feb 2009 13:15:10 +0200
Message-ID: <1ba2fa240902020315w49a67afg6ddf8a0e5d367548@mail.gmail.com> (sfid-20090202_121520_299184_F008470B)
Subject: Re: [PATCH] mac80211: Extend the rate control API with an update
	callback
From: Tomas Winkler <tomasw@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2009 at 12:28 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> The AP can switch dynamically between 20/40 Mhz channel width,
> in which case we switch the local operating channel, but the
> rate control algorithm is not notified. This patch adds a new callback
> to indicate such changes to the RC algorithm.
>
> Currently, HT channel width change is notified, but this callback
> can be used to indicate any new requirements that might come up later on.

I like the idea. It's good for any coexistence  such G protection
(CTS/RTS) which also affects throughput and RC.
I'm not sure if it's not better to connect it directly somehow with
BSS info changed.
Thanks
Tomas

>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  include/net/mac80211.h |   13 +++++++++++++
>  net/mac80211/ht.c      |   12 ++++++++++++
>  net/mac80211/rate.h    |   12 ++++++++++++
>  3 files changed, 37 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index e2144f0..88d4b8c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1984,6 +1984,16 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
>  /* Rate control API */
>
>  /**
> + * enum rate_control_changed - flags to indicate which parameter changed
> + *
> + * @IEEE80211_RC_CHANNEL_CHANGED: The operating channel has changed, rate
> + *     control algorithm can update its internal state if needed.
> + */
> +enum rate_control_changed {
> +       IEEE80211_RC_CHANNEL_CHANGED = BIT(0)
> +};
> +
> +/**
>  * struct ieee80211_tx_rate_control - rate control information for/from RC algo
>  *
>  * @hw: The hardware the algorithm is invoked for.
> @@ -2019,6 +2029,9 @@ struct rate_control_ops {
>        void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
>        void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
>                          struct ieee80211_sta *sta, void *priv_sta);
> +       void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
> +                           struct ieee80211_sta *sta,
> +                           void *priv_sta, u32 changed);
>        void (*free_sta)(void *priv, struct ieee80211_sta *sta,
>                         void *priv_sta);
>
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 7a38d2e..d2daddd 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -19,6 +19,7 @@
>  #include "ieee80211_i.h"
>  #include "sta_info.h"
>  #include "wme.h"
> +#include "rate.h"
>
>  void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
>                                       struct ieee80211_ht_cap *ht_cap_ie,
> @@ -94,8 +95,10 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>                        u16 ap_ht_cap_flags)
>  {
>        struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>        struct ieee80211_supported_band *sband;
>        struct ieee80211_bss_ht_conf ht;
> +       struct sta_info *sta;
>        u32 changed = 0;
>        bool enable_ht = true, ht_changed;
>        enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
> @@ -138,6 +141,15 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>        if (ht_changed) {
>                 /* channel_type change automatically detected */
>                ieee80211_hw_config(local, 0);
> +
> +               rcu_read_lock();
> +
> +               sta = sta_info_get(local, ifsta->bssid);
> +               if (sta)
> +                       rate_control_rate_update(local, sband, sta,
> +                                        IEEE80211_RC_CHANNEL_CHANGED);
> +
> +               rcu_read_unlock();
>         }
>
>        /* disable HT */
> diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
> index 928da62..8b869f2 100644
> --- a/net/mac80211/rate.h
> +++ b/net/mac80211/rate.h
> @@ -62,6 +62,18 @@ static inline void rate_control_rate_init(struct sta_info *sta)
>        ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
>  }
>
> +static inline void rate_control_rate_update(struct ieee80211_local *local,
> +                                           struct ieee80211_supported_band *sband,
> +                                           struct sta_info *sta, u32 changed)
> +{
> +       struct rate_control_ref *ref = local->rate_ctrl;
> +       struct ieee80211_sta *ista = &sta->sta;
> +       void *priv_sta = sta->rate_ctrl_priv;
> +
> +       if (ref->ops->rate_update)
> +               ref->ops->rate_update(ref->priv, sband, ista,
> +                                     priv_sta, changed);
> +}
>
>  static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
>                                           struct ieee80211_sta *sta,
> --
> 1.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
