Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39691 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaBMIzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 03:55:32 -0500
Received: by mail-pd0-f174.google.com with SMTP id z10so10178891pdj.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 00:55:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392237482-18172-1-git-send-email-johannes@sipsolutions.net>
References: <1392237482-18172-1-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 13 Feb 2014 10:55:16 +0200
Message-ID: <CA+XVXffxt5A_EOMJqMA6hHzZBaCy46ctdXL6R4k+QY_oVTAC7g@mail.gmail.com> (sfid-20140213_095536_006610_DD4B843D)
Subject: Re: [PATCH] mac80211: add NAPI support back
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 10:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> NAPI was originally added to mac80211 a long time ago (by John in
> commit 4e6cbfd09c66 in July 2010), but then removed years later
> (by Stanislaw in commit 30c97120c6c7 in February 2013). No driver
> ever used it, so that was fine.
>
> Now I'm adding support for NAPI to our driver, so add some code
> to mac80211 again  to support NAPI. John was originally wrapping
> some (but not nearly all NAPI-related functions), but that doesn't
> scale very well with the number of functions that are there, some
> of which are even only inlines. Thus, instead of doing that, let
> the drivers manage the NAPI struct, except for napi_add() which is
> needed so mac80211 knows how to call napi_gro_receive().
>
> Also remove some no longer needed definitions that were left when
> NAPI support was removed.
>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Reviewed-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/mac80211.h     | 34 +++++++++++++---------------------
>  net/mac80211/ieee80211_i.h |  2 ++
>  net/mac80211/main.c        | 12 ++++++++++++
>  net/mac80211/rx.c          |  5 ++++-
>  4 files changed, 31 insertions(+), 22 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4005c5b..2d4d312 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1642,10 +1642,6 @@ enum ieee80211_hw_flags {
>   *     the hw can report back.
>   * @max_rate_tries: maximum number of tries for each stage
>   *
> - * @napi_weight: weight used for NAPI polling.  You must specify an
> - *     appropriate value here if a napi_poll operation is provided
> - *     by your driver.
> - *
>   * @max_rx_aggregation_subframes: maximum buffer size (number of
>   *     sub-frames) to be used for A-MPDU block ack receiver
>   *     aggregation.
> @@ -1699,7 +1695,6 @@ struct ieee80211_hw {
>         int vif_data_size;
>         int sta_data_size;
>         int chanctx_data_size;
> -       int napi_weight;
>         u16 queues;
>         u16 max_listen_interval;
>         s8 max_signal;
> @@ -2622,8 +2617,6 @@ enum ieee80211_roc_type {
>   *     callback. They must then call ieee80211_chswitch_done() to indicate
>   *     completion of the channel switch.
>   *
> - * @napi_poll: Poll Rx queue for incoming data frames.
> - *
>   * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
>   *     Parameters are bitmaps of allowed antennas to use for TX/RX. Drivers may
>   *     reject TX/RX mask combinations they cannot support by returning -EINVAL
> @@ -2882,7 +2875,6 @@ struct ieee80211_ops {
>         void (*flush)(struct ieee80211_hw *hw, u32 queues, bool drop);
>         void (*channel_switch)(struct ieee80211_hw *hw,
>                                struct ieee80211_channel_switch *ch_switch);
> -       int (*napi_poll)(struct ieee80211_hw *hw, int budget);
>         int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
>         int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
>
> @@ -3164,21 +3156,21 @@ void ieee80211_free_hw(struct ieee80211_hw *hw);
>   */
>  void ieee80211_restart_hw(struct ieee80211_hw *hw);
>
> -/** ieee80211_napi_schedule - schedule NAPI poll
> - *
> - * Use this function to schedule NAPI polling on a device.
> - *
> - * @hw: the hardware to start polling
> - */
> -void ieee80211_napi_schedule(struct ieee80211_hw *hw);
> -
> -/** ieee80211_napi_complete - complete NAPI polling
> - *
> - * Use this function to finish NAPI polling on a device.
> +/**
> + * ieee80211_napi_add - initialize mac80211 NAPI context
> + * @hw: the hardware to initialize the NAPI context on
> + * @napi: the NAPI context to initialize
> + * @napi_dev: dummy NAPI netdevice, here to not waste the space if the
> + *     driver doesn't use NAPI
> + * @poll: poll function
> + * @weight: default weight
>   *
> - * @hw: the hardware to stop polling
> + * See also netif_napi_add().
>   */
> -void ieee80211_napi_complete(struct ieee80211_hw *hw);
> +void ieee80211_napi_add(struct ieee80211_hw *hw, struct napi_struct *napi,
> +                       struct net_device *napi_dev,
> +                       int (*poll)(struct napi_struct *, int),
> +                       int weight);
>
>  /**
>   * ieee80211_rx - receive frame
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 0014b53..8603dfb 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -1242,6 +1242,8 @@ struct ieee80211_local {
>
>         struct ieee80211_sub_if_data __rcu *p2p_sdata;
>
> +       struct napi_struct *napi;
> +
>         /* virtual monitor interface */
>         struct ieee80211_sub_if_data __rcu *monitor_sdata;
>         struct cfg80211_chan_def monitor_chandef;
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 1f7d842..b055f6a5 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1076,6 +1076,18 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  }
>  EXPORT_SYMBOL(ieee80211_register_hw);
>
> +void ieee80211_napi_add(struct ieee80211_hw *hw, struct napi_struct *napi,
> +                       struct net_device *napi_dev,
> +                       int (*poll)(struct napi_struct *, int),
> +                       int weight)
> +{
> +       struct ieee80211_local *local = hw_to_local(hw);
> +
> +       netif_napi_add(napi_dev, napi, poll, weight);
> +       local->napi = napi;

I'm not really familiar with NAPI, but shouldn't netif_napi_del be
called at some point? And if so, it will leave mac80211 in an
inconsistent state.
Maybe if we make it part of ieee80211_register/unregister_hw the
scoping of local->napi will be nicer?

Arik
