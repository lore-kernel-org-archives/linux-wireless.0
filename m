Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:12811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762059AbYJJPBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 11:01:54 -0400
Received: by fg-out-1718.google.com with SMTP id 19so360173fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 08:01:51 -0700 (PDT)
Message-ID: <1ba2fa240810100801i7886be3cq7376881951fdec36@mail.gmail.com> (sfid-20081010_170224_158043_54CAC39F)
Date: Fri, 10 Oct 2008 17:01:51 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: splitting out the 3945 RC algorithm from the driver
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1223631856.17594.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223631856.17594.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 11:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I've never really believed that your rate control algorithms are really
> intimately tied to the hardware as you claimed previously.

This was never claimed about 3945 algorithm and even agn can be
separated only diffferenc is that it doesn't update rates in tx path.
(get_rate) The question is what is the price of it against benefit.


And I thought
> that especially now that the driver can tell the RC algorithm it did
> multiple retries (whether or not based on the setup the RC algorithm
> wanted; not like you couldn't have had the idea to report that...) it
> should be possible to better split the RC algorithm off from the driver.

It was always possible the question is not only possibilty but also
timing and effort it takes
and also possible acceptance of this.

> There are a few difficulties:
>  * the code assumes special rate indexing and special rate setups, this
>   isn't hard to solve, just needs a bit of creative thinking and some
>   setup code
>  * the RC algorithm is responsible for adding IBSS stations to the
>   firmware, this is pure design stupidity and must be fixed anyway
>  * the code uses a lot of definitions from the driver

First please again stop this language, you are not telling us
something that we don't know.
There is history how things are developed and there is time for
everything to change.  It wasn't stupid when it was develped mac80211
then what it is now. Not everything happens in timing you wish for.
Last you didn't see my TODO list.


>  * the code checks some things from the driver's HW struct
>
> None of these are really insurmountable, and I've pretty much done that
> for 3945.
>
> I have no intention of actually completing this work or testing this
> rate control algorithm on other HW, I don't believe it is superior to
> the ones we already have. I also don't care much about rate control
> algorithms at all. But I do care about proper separation, which would
> have been nice to start with.
>
> FAIL.
>
> As for the code, it does a few things differently:
>  * it doesn't start at a rate that depends on the RSSI, that seems
>   pointless anyway since we don't know the TX power of the AP, this
>   alone simplifies the code quite a bit

This is heuristic that has been proven working.

>  * it obviously doesn't initialise stations for the firmware
>  * it doesn't use the "G (with protection)" throughput (TPT) tables,
>   this would possibly have required some mac80211 API changes
>
>
> I'm thinking that since iwlagn doesn't really need a RC algorithm since
> it does that in firmware mostly we should introduce a HW flag to disable
> RC algorithms alltogether and move all that code into the driver.

 And
> complete this patch for 3945 so you can actually use this algorithm on
> other HW and another algorithm with 3945 HW.

It's possible.

Thanks
Tomas


> johannes
>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c |  575 ++++++++++++-----------------
>  drivers/net/wireless/iwlwifi/iwl-3945-rs.h |  206 ----------
>  drivers/net/wireless/iwlwifi/iwl-3945.c    |    2
>  drivers/net/wireless/iwlwifi/iwl-3945.h    |  152 +++++++
>  4 files changed, 389 insertions(+), 546 deletions(-)
>
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c  2008-10-09 19:44:03.000000000 +0200
> +++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c       2008-10-09 22:23:42.000000000 +0200
> @@ -1,6 +1,7 @@
>  /******************************************************************************
>  *
>  * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
> + * Copyright 2008, Johannes Berg
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of version 2 of the GNU General Public License as
> @@ -36,10 +37,26 @@
>
>  #include <linux/workqueue.h>
>
> -#include "iwl-3945.h"
> -
>  #define RS_NAME "iwl-3945-rs"
>
> +/* maximum number of rates this algorithm supports */
> +#define MAX_RATES 12
> +
> +#define INVALID_RATE MAX_RATES
> +
> +
> +struct iwl3945_rate_offset {
> +       u8 prev_ieee, prev, next, prev_tgg, next_tgg;
> +};
> +
> +struct iwl3945_rs {
> +       struct iwl3945_rate_offset offs[MAX_RATES];
> +       s32 expected_tpt_a[MAX_RATES];
> +       s32 expected_tpt_b[MAX_RATES];
> +       s32 expected_tpt_g[MAX_RATES];
> +       s32 expected_tpt_g_prot[MAX_RATES];
> +};
> +
>  struct iwl3945_rate_scale_data {
>        u64 data;
>        s32 success_counter;
> @@ -57,60 +74,79 @@ struct iwl3945_rs_sta {
>        u32 flush_time;
>        u32 last_tx_packets;
>        u32 tx_packets;
> -       u8 tgg;
> -       u8 flush_pending;
> -       u8 start_rate;
> -       u8 ibss_sta_added;
> +       bool tgg;
> +       bool flush_pending;
>        struct timer_list rate_scale_flush;
> -       struct iwl3945_rate_scale_data win[IWL_RATE_COUNT];
> +       struct iwl3945_rate_scale_data win[MAX_RATES];
>
>        /* used to be in sta_info */
> -       int last_txrate_idx;
> +       s8 last_txrate_idx;
>  };
>
> -static s32 iwl3945_expected_tpt_g[IWL_RATE_COUNT] = {
> -       7, 13, 35, 58, 0, 0, 76, 104, 130, 168, 191, 202
> +struct rate_switch {
> +       u16 this, prev_ieee, prev, next, prev_tgg, next_tgg;
>  };
>
> -static s32 iwl3945_expected_tpt_g_prot[IWL_RATE_COUNT] = {
> -       7, 13, 35, 58, 0, 0, 0, 80, 93, 113, 123, 125
> +static struct rate_switch iwl3945_rate_switch[] = {
> +       {  10,  10,  10,  20,  10,  20, },
> +       {  20,  10,  10,  55,  10,  55, },
> +       {  55,  20,  20, 110,  20, 110, },
> +       { 110,  90,  55, 120,  55, 180, },
> +       {  60,  55,  55, 110,  55, 110, },
> +       {  90,  60,  55, 110,  55, 110, },
> +       { 120, 110, 110, 180, 110, 180, },
> +       { 180, 120, 120, 240, 110, 240, },
> +       { 240, 180, 180, 360, 180, 360, },
> +       { 360, 240, 240, 480, 240, 480, },
> +       { 480, 360, 360, 540, 360, 540, },
> +       { 540, 480, 480, 540, 480, 540, },
>  };
>
> -static s32 iwl3945_expected_tpt_a[IWL_RATE_COUNT] = {
> -       0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186
> +struct iwl3945_expected_tpt {
> +       u16 bitrate, tpt;
>  };
>
> -static s32 iwl3945_expected_tpt_b[IWL_RATE_COUNT] = {
> -       7, 13, 35, 58, 0, 0, 0, 0, 0, 0, 0, 0
> +static struct iwl3945_expected_tpt iwl3945_expected_tpt_g[] = {
> +       {  10,   7 },
> +       {  20,  13 },
> +       {  55,  35 },
> +       { 110,  58 },
> +       { 120,  76 },
> +       { 180, 104 },
> +       { 240, 130 },
> +       { 360, 168 },
> +       { 480, 191 },
> +       { 540, 202 },
>  };
>
> -struct iwl3945_tpt_entry {
> -       s8 min_rssi;
> -       u8 index;
> +static struct iwl3945_expected_tpt iwl3945_expected_tpt_g_prot[] = {
> +       {  10,   7 },
> +       {  20,  13 },
> +       {  55,  35 },
> +       { 110,  58 },
> +       { 180,  80 },
> +       { 240,  93 },
> +       { 360, 113 },
> +       { 480, 123 },
> +       { 540, 225 },
>  };
>
> -static struct iwl3945_tpt_entry iwl3945_tpt_table_a[] = {
> -       {-60, IWL_RATE_54M_INDEX},
> -       {-64, IWL_RATE_48M_INDEX},
> -       {-72, IWL_RATE_36M_INDEX},
> -       {-80, IWL_RATE_24M_INDEX},
> -       {-84, IWL_RATE_18M_INDEX},
> -       {-85, IWL_RATE_12M_INDEX},
> -       {-87, IWL_RATE_9M_INDEX},
> -       {-89, IWL_RATE_6M_INDEX}
> +static struct iwl3945_expected_tpt iwl3945_expected_tpt_a[] = {
> +       {  60,  40 },
> +       {  90,  57 },
> +       { 120,  72 },
> +       { 180,  89 },
> +       { 240, 121 },
> +       { 360, 154 },
> +       { 480, 177 },
> +       { 540, 186 },
>  };
>
> -static struct iwl3945_tpt_entry iwl3945_tpt_table_g[] = {
> -       {-60, IWL_RATE_54M_INDEX},
> -       {-64, IWL_RATE_48M_INDEX},
> -       {-68, IWL_RATE_36M_INDEX},
> -       {-80, IWL_RATE_24M_INDEX},
> -       {-84, IWL_RATE_18M_INDEX},
> -       {-85, IWL_RATE_12M_INDEX},
> -       {-86, IWL_RATE_11M_INDEX},
> -       {-88, IWL_RATE_5M_INDEX},
> -       {-90, IWL_RATE_2M_INDEX},
> -       {-92, IWL_RATE_1M_INDEX}
> +static struct iwl3945_expected_tpt iwl3945_expected_tpt_b[] = {
> +       {  10,   7 },
> +       {  20,  13 },
> +       {  55,  35 },
> +       { 110,  58 },
>  };
>
>  #define IWL_RATE_MAX_WINDOW          62
> @@ -121,38 +157,11 @@ static struct iwl3945_tpt_entry iwl3945_
>  #define IWL_RATE_MIN_SUCCESS_TH       8
>  #define IWL_RATE_DECREASE_TH       1920
>
> -static u8 iwl3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
> -{
> -       u32 index = 0;
> -       u32 table_size = 0;
> -       struct iwl3945_tpt_entry *tpt_table = NULL;
> -
> -       if ((rssi < IWL_MIN_RSSI_VAL) || (rssi > IWL_MAX_RSSI_VAL))
> -               rssi = IWL_MIN_RSSI_VAL;
> -
> -       switch (band) {
> -       case IEEE80211_BAND_2GHZ:
> -               tpt_table = iwl3945_tpt_table_g;
> -               table_size = ARRAY_SIZE(iwl3945_tpt_table_g);
> -               break;
> -
> -       case IEEE80211_BAND_5GHZ:
> -               tpt_table = iwl3945_tpt_table_a;
> -               table_size = ARRAY_SIZE(iwl3945_tpt_table_a);
> -               break;
> -
> -       default:
> -               BUG();
> -               break;
> -       }
> -
> -       while ((index < table_size) && (rssi < tpt_table[index].min_rssi))
> -               index++;
> +#define IWL_MIN_RSSI_VAL               -100
> +#define IWL_MAX_RSSI_VAL                  0
>
> -       index = min(index, (table_size - 1));
> +#define IWL_INV_TPT    -1
>
> -       return tpt_table[index].index;
> -}
>
>  static void iwl3945_clear_window(struct iwl3945_rate_scale_data *window)
>  {
> @@ -182,16 +191,13 @@ static int iwl3945_rate_scale_flush_wind
>         * and it has been more than IWL_RATE_WIN_FLUSH
>         * since we flushed, clear out the gathered statistics
>         */
> -       for (i = 0; i < IWL_RATE_COUNT; i++) {
> +       for (i = 0; i < MAX_RATES; i++) {
>                if (!rs_sta->win[i].counter)
>                        continue;
>
>                spin_lock_irqsave(&rs_sta->lock, flags);
>                if (time_after(jiffies, rs_sta->win[i].stamp +
>                               IWL_RATE_WIN_FLUSH)) {
> -                       IWL_DEBUG_RATE("flushing %d samples of rate "
> -                                      "index %d\n",
> -                                      rs_sta->win[i].counter, i);
>                        iwl3945_clear_window(&rs_sta->win[i]);
>                } else
>                        unflushed++;
> @@ -211,13 +217,11 @@ static void iwl3945_bg_rate_scale_flush(
>        unsigned long flags;
>        u32 packet_count, duration, pps;
>
> -       IWL_DEBUG_RATE("enter\n");
> -
>        unflushed = iwl3945_rate_scale_flush_windows(rs_sta);
>
>        spin_lock_irqsave(&rs_sta->lock, flags);
>
> -       rs_sta->flush_pending = 0;
> +       rs_sta->flush_pending = false;
>
>        /* Number of packets Rx'd since last time this timer ran */
>        packet_count = (rs_sta->tx_packets - rs_sta->last_tx_packets) + 1;
> @@ -227,10 +231,6 @@ static void iwl3945_bg_rate_scale_flush(
>        if (unflushed) {
>                duration =
>                    jiffies_to_msecs(jiffies - rs_sta->last_partial_flush);
> -/*              duration = jiffies_to_msecs(rs_sta->flush_time); */
> -
> -               IWL_DEBUG_RATE("Tx'd %d packets in %dms\n",
> -                              packet_count, duration);
>
>                /* Determine packets per second */
>                if (duration)
> @@ -247,9 +247,6 @@ static void iwl3945_bg_rate_scale_flush(
>
>                rs_sta->flush_time = msecs_to_jiffies(duration);
>
> -               IWL_DEBUG_RATE("new flush period: %d msec ave %d\n",
> -                              duration, packet_count);
> -
>                mod_timer(&rs_sta->rate_scale_flush, jiffies +
>                          rs_sta->flush_time);
>
> @@ -262,8 +259,6 @@ static void iwl3945_bg_rate_scale_flush(
>        rs_sta->last_flush = jiffies;
>
>        spin_unlock_irqrestore(&rs_sta->lock, flags);
> -
> -       IWL_DEBUG_RATE("leave\n");
>  }
>
>  /**
> @@ -279,10 +274,8 @@ static void iwl3945_collect_tx_data(stru
>  {
>        unsigned long flags;
>
> -       if (!retries) {
> -               IWL_DEBUG_RATE("leave: retries == 0 -- should be at least 1\n");
> +       if (!retries)
>                return;
> -       }
>
>        while (retries--) {
>                spin_lock_irqsave(&rs_sta->lock, flags);
> @@ -317,54 +310,126 @@ static void iwl3945_collect_tx_data(stru
>        }
>  }
>
> -static void rs_rate_init(void *priv, struct ieee80211_supported_band *sband,
> +static void rs_rate_init(void *p, struct ieee80211_supported_band *sband,
>                         struct ieee80211_sta *sta, void *priv_sta)
>  {
> +       struct iwl3945_rs *rs = p;
>        struct iwl3945_rs_sta *rs_sta = priv_sta;
> -       int i;
> +       unsigned long flags;
>
> -       IWL_DEBUG_RATE("enter\n");
> +       if (!rs_sta)
> +               return;
>
> -       /* TODO: what is a good starting rate for STA? About middle? Maybe not
> -        * the lowest or the highest rate.. Could consider using RSSI from
> -        * previous packets? Need to have IEEE 802.1X auth succeed immediately
> -        * after assoc.. */
> +       spin_lock_irqsave(&rs_sta->lock, flags);
>
> -       for (i = IWL_RATE_COUNT - 1; i >= 0; i--) {
> -               if (sta->supp_rates[sband->band] & (1 << i)) {
> -                       rs_sta->last_txrate_idx = i;
> -                       break;
> -               }
> +       rs_sta->tgg = false;
> +
> +       switch (sband->band) {
> +       case IEEE80211_BAND_2GHZ:
> +#if 0
> +               /* TODO: this always does G, not a regression */
> +               if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
> +                       rs_sta->tgg = true;
> +                       rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
> +               } else
> +#endif
> +                       rs_sta->expected_tpt = rs->expected_tpt_g;
> +               break;
> +
> +       case IEEE80211_BAND_5GHZ:
> +               rs_sta->expected_tpt = rs->expected_tpt_a;
> +               break;
> +       case IEEE80211_NUM_BANDS:
> +               BUG();
> +               break;
>        }
>
> -       /* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
> -       if (sband->band == IEEE80211_BAND_5GHZ)
> -               rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
> +       /*
> +        * TODO: what is a good starting rate for STA? About middle? Maybe not
> +        * the lowest or the highest rate.. Could consider using RSSI from
> +        * previous packets? Need to have IEEE 802.1X auth succeed immediately
> +        * after assoc...
> +        */
> +       rs_sta->last_txrate_idx = rate_lowest_index(sband, sta);
>
> -       IWL_DEBUG_RATE("leave\n");
> +       spin_unlock_irqrestore(&rs_sta->lock, flags);
>  }
>
>  static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
>  {
> -       return hw->priv;
> +       struct iwl3945_rs *rs = kzalloc(sizeof(*rs), GFP_KERNEL);
> +       struct ieee80211_supported_band *sband;
> +       struct rate_switch *sw;
> +       int i, j;
> +
> +       if (!rs)
> +               return ERR_PTR(-ENOMEM);
> +
> +#define SETUP_TPT(which) do {                                          \
> +       for (i = 0; i < min(MAX_RATES, sband->n_bitrates); i++)         \
> +       for (j = 0; j < ARRAY_SIZE(iwl3945_expected_tpt_ ##which); j++) \
> +               if (iwl3945_expected_tpt_ ##which[j].bitrate ==         \
> +                   sband->bitrates[i].bitrate)                         \
> +                       rs->expected_tpt_ ##which[i] =                  \
> +                               iwl3945_expected_tpt_ ##which[j].tpt;   \
> +} while (0)
> +
> +       sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
> +       if (sband)
> +               SETUP_TPT(a);
> +
> +       sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
> +       if (!sband)
> +               return rs;
> +
> +       SETUP_TPT(b);
> +       SETUP_TPT(g);
> +       SETUP_TPT(g_prot);
> +
> +#undef SETUP_TPT
> +
> +       for (i = 0; i < min(MAX_RATES, sband->n_bitrates); i++) {
> +               sw = &iwl3945_rate_switch[0];
> +               j = 0;
> +               while (sband->bitrates[i].bitrate <= sw->this &&
> +                      j + 1 < ARRAY_SIZE(iwl3945_rate_switch)) {
> +                       sw++;
> +                       j++;
> +               }
> +               for (j = 0; j < min(MAX_RATES, sband->n_bitrates); j++) {
> +                       struct ieee80211_rate *r = &sband->bitrates[j];
> +
> +                       if (sw->prev_ieee >= r->bitrate)
> +                               rs->offs[i].prev_ieee = j;
> +                       if (sw->prev >= r->bitrate)
> +                               rs->offs[i].prev = j;
> +                       if (sw->prev_tgg >= r->bitrate)
> +                               rs->offs[i].prev_tgg = j;
> +                       if (sw->next <= r->bitrate)
> +                               rs->offs[i].next = j;
> +                       if (sw->next_tgg <= r->bitrate)
> +                               rs->offs[i].next_tgg = j;
> +               }
> +       }
> +
> +       return rs;
>  }
>
> -/* rate scale requires free function to be implemented */
> -static void rs_free(void *priv)
> +static void rs_free(void *p)
>  {
> -       return;
> +       kfree(p);
>  }
>
> -static void rs_clear(void *priv)
> +static void rs_clear(void *p)
>  {
> -       return;
> +       /* nothing to clear */
>  }
>
>
> -static void *rs_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
> +static void *rs_alloc_sta(void *p, struct ieee80211_sta *sta, gfp_t gfp)
>  {
>        struct iwl3945_rs_sta *rs_sta;
> -       struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
> +       struct iwl3945_rs *rs = p;
>        int i;
>
>        /*
> @@ -372,53 +437,40 @@ static void *rs_alloc_sta(void *priv, st
>         *      as well just put all the information there.
>         */
>
> -       IWL_DEBUG_RATE("enter\n");
> -
>        rs_sta = kzalloc(sizeof(struct iwl3945_rs_sta), gfp);
> -       if (!rs_sta) {
> -               IWL_DEBUG_RATE("leave: ENOMEM\n");
> +       if (!rs_sta)
>                return NULL;
> -       }
> -
> -       psta->rs_sta = rs_sta;
>
>        spin_lock_init(&rs_sta->lock);
>
> -       rs_sta->start_rate = IWL_RATE_INVALID;
> -
>        /* default to just 802.11b */
> -       rs_sta->expected_tpt = iwl3945_expected_tpt_b;
> +       rs_sta->expected_tpt = rs->expected_tpt_b;
>
>        rs_sta->last_partial_flush = jiffies;
>        rs_sta->last_flush = jiffies;
>        rs_sta->flush_time = IWL_RATE_FLUSH;
>        rs_sta->last_tx_packets = 0;
> -       rs_sta->ibss_sta_added = 0;
>
>        init_timer(&rs_sta->rate_scale_flush);
>        rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
>        rs_sta->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
>
> -       for (i = 0; i < IWL_RATE_COUNT; i++)
> +       for (i = 0; i < MAX_RATES; i++)
>                iwl3945_clear_window(&rs_sta->win[i]);
>
> -       IWL_DEBUG_RATE("leave\n");
> -
>        return rs_sta;
>  }
>
> -static void rs_free_sta(void *priv, struct ieee80211_sta *sta,
> +static void rs_free_sta(void *p, struct ieee80211_sta *sta,
>                        void *priv_sta)
>  {
> -       struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
>        struct iwl3945_rs_sta *rs_sta = priv_sta;
>
> -       psta->rs_sta = NULL;
> +       if (!rs_sta)
> +               return;
>
> -       IWL_DEBUG_RATE("enter\n");
>        del_timer_sync(&rs_sta->rate_scale_flush);
>        kfree(rs_sta);
> -       IWL_DEBUG_RATE("leave\n");
>  }
>
>
> @@ -427,28 +479,12 @@ static void rs_free_sta(void *priv, stru
>  * for A and B mode we need to overright prev
>  * value
>  */
> -static int rs_adjust_next_rate(struct iwl3945_priv *priv, int rate)
> +static int rs_adjust_next_rate(struct iwl3945_rs *rs,
> +                              enum ieee80211_band band, int rate)
>  {
> -       int next_rate = iwl3945_get_prev_ieee_rate(rate);
> -
> -       switch (priv->band) {
> -       case IEEE80211_BAND_5GHZ:
> -               if (rate == IWL_RATE_12M_INDEX)
> -                       next_rate = IWL_RATE_9M_INDEX;
> -               else if (rate == IWL_RATE_6M_INDEX)
> -                       next_rate = IWL_RATE_6M_INDEX;
> -               break;
> -/* XXX cannot be invoked in current mac80211 so not a regression
> -       case MODE_IEEE80211B:
> -               if (rate == IWL_RATE_11M_INDEX_TABLE)
> -                       next_rate = IWL_RATE_5M_INDEX_TABLE;
> -               break;
> - */
> -       default:
> -               break;
> -       }
> -
> -       return next_rate;
> +       if (band == IEEE80211_BAND_2GHZ)
> +               return rs->offs[rate].prev_ieee;
> +       return max(0, rate - 1);
>  }
>  /**
>  * rs_tx_status - Update rate control values based on Tx results
> @@ -456,30 +492,23 @@ static int rs_adjust_next_rate(struct iw
>  * NOTE: Uses iwl3945_priv->retry_rate for the # of retries attempted by
>  * the hardware for each rate.
>  */
> -static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband,
> +static void rs_tx_status(void *p, struct ieee80211_supported_band *sband,
>                         struct ieee80211_sta *sta, void *priv_sta,
>                         struct sk_buff *skb)
>  {
>        u8 retries, current_count;
>        int scale_rate_index, first_index, last_index;
>        unsigned long flags;
> -       struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
>        struct iwl3945_rs_sta *rs_sta = priv_sta;
>        struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>
> -       IWL_DEBUG_RATE("enter\n");
> +       if (!rs_sta)
> +               return;
>
>        retries = info->status.retry_count;
>        first_index = sband->bitrates[info->tx_rate_idx].hw_value;
> -       if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
> -               IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
> -               return;
> -       }
> -
> -       if (!priv_sta) {
> -               IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
> +       if ((first_index < 0) || (first_index >= MAX_RATES))
>                return;
> -       }
>
>        rs_sta->tx_packets++;
>
> @@ -497,36 +526,29 @@ static void rs_tx_status(void *priv_rate
>         * ACK)
>         */
>        while (retries > 0) {
> -               if (retries < priv->retry_rate) {
> +               if (retries < 1) {
>                        current_count = retries;
>                        last_index = scale_rate_index;
>                } else {
> -                       current_count = priv->retry_rate;
> -                       last_index = rs_adjust_next_rate(priv,
> +                       current_count = 1;
> +                       last_index = rs_adjust_next_rate(p, sband->band,
>                                                         scale_rate_index);
>                }
>
>                /* Update this rate accounting for as many retries
>                 * as was used for it (per current_count) */
>                iwl3945_collect_tx_data(rs_sta,
> -                                   &rs_sta->win[scale_rate_index],
> -                                   0, current_count);
> -               IWL_DEBUG_RATE("Update rate %d for %d retries.\n",
> -                              scale_rate_index, current_count);
> -
> +                                       &rs_sta->win[scale_rate_index],
> +                                       0, current_count);
>                retries -= current_count;
>
>                if (retries)
> -                       scale_rate_index =
> -                           rs_adjust_next_rate(priv, scale_rate_index);
> +                       scale_rate_index = rs_adjust_next_rate(
> +                                       p, sband->band, scale_rate_index);
>        }
>
>
>        /* Update the last index window with success/failure based on ACK */
> -       IWL_DEBUG_RATE("Update rate %d with %s.\n",
> -                      last_index,
> -                      (info->flags & IEEE80211_TX_STAT_ACK) ?
> -                      "success" : "failure");
>        iwl3945_collect_tx_data(rs_sta,
>                            &rs_sta->win[last_index],
>                            info->flags & IEEE80211_TX_STAT_ACK, 1);
> @@ -540,27 +562,23 @@ static void rs_tx_status(void *priv_rate
>            time_after(jiffies, rs_sta->last_partial_flush +
>                       rs_sta->flush_time)) {
>
> -               rs_sta->flush_pending = 1;
> +               rs_sta->flush_pending = true;
>                mod_timer(&rs_sta->rate_scale_flush,
>                          jiffies + rs_sta->flush_time);
>        }
>
>        spin_unlock_irqrestore(&rs_sta->lock, flags);
> -
> -       IWL_DEBUG_RATE("leave\n");
> -
> -       return;
>  }
>
> -static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
> -                                u8 index, u16 rate_mask, enum ieee80211_band band)
> +static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs *rs,
> +                                    struct iwl3945_rs_sta *rs_sta,
> +                                    u8 index, u16 rate_mask,
> +                                    enum ieee80211_band band)
>  {
> -       u8 high = IWL_RATE_INVALID;
> -       u8 low = IWL_RATE_INVALID;
> +       s8 high = index, phigh = index;
> +       s8 low = index, plow = index;
>
> -       /* 802.11A walks to the next literal adjacent rate in
> -        * the rate table */
> -       if (unlikely(band == IEEE80211_BAND_5GHZ)) {
> +       if (band != IEEE80211_BAND_2GHZ) {
>                int i;
>                u32 mask;
>
> @@ -575,7 +593,7 @@ static u16 iwl3945_get_adjacent_rate(str
>
>                /* Find the next rate that is in the rate mask */
>                i = index + 1;
> -               for (mask = (1 << i); i < IWL_RATE_COUNT; i++, mask <<= 1) {
> +               for (mask = (1 << i); i < MAX_RATES; i++, mask <<= 1) {
>                        if (rate_mask & mask) {
>                                high = i;
>                                break;
> @@ -585,30 +603,32 @@ static u16 iwl3945_get_adjacent_rate(str
>                return (high << 8) | low;
>        }
>
> -       low = index;
> -       while (low != IWL_RATE_INVALID) {
> +       while (1) {
>                if (rs_sta->tgg)
> -                       low = iwl3945_rates[low].prev_rs_tgg;
> +                       low = rs->offs[low].prev_tgg;
>                else
> -                       low = iwl3945_rates[low].prev_rs;
> -               if (low == IWL_RATE_INVALID)
> +                       low = rs->offs[low].prev;
> +               if (low == plow) {
> +                       low = INVALID_RATE;
>                        break;
> +               }
> +               plow = low;
>                if (rate_mask & (1 << low))
>                        break;
> -               IWL_DEBUG_RATE("Skipping masked lower rate: %d\n", low);
>        }
>
> -       high = index;
> -       while (high != IWL_RATE_INVALID) {
> +       while (1) {
>                if (rs_sta->tgg)
> -                       high = iwl3945_rates[high].next_rs_tgg;
> +                       high = rs->offs[high].next_tgg;
>                else
> -                       high = iwl3945_rates[high].next_rs;
> -               if (high == IWL_RATE_INVALID)
> +                       high = rs->offs[high].next;
> +               if (high == phigh) {
> +                       high = INVALID_RATE;
>                        break;
> +               }
> +               phigh = high;
>                if (rate_mask & (1 << high))
>                        break;
> -               IWL_DEBUG_RATE("Skipping masked higher rate: %d\n", high);
>        }
>
>        return (high << 8) | low;
> @@ -630,12 +650,12 @@ static u16 iwl3945_get_adjacent_rate(str
>  * rate table and must reference the driver allocated rate table
>  *
>  */
> -static void rs_get_rate(void *priv_r, struct ieee80211_supported_band *sband,
> +static void rs_get_rate(void *p, struct ieee80211_supported_band *sband,
>                        struct ieee80211_sta *sta, void *priv_sta,
>                        struct sk_buff *skb, struct rate_selection *sel)
>  {
> -       u8 low = IWL_RATE_INVALID;
> -       u8 high = IWL_RATE_INVALID;
> +       u8 low = INVALID_RATE;
> +       u8 high = INVALID_RATE;
>        u16 high_low;
>        int index;
>        struct iwl3945_rs_sta *rs_sta = priv_sta;
> @@ -648,49 +668,23 @@ static void rs_get_rate(void *priv_r, st
>        unsigned long flags;
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>        u16 fc, rate_mask;
> -       struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
>        DECLARE_MAC_BUF(mac);
>
> -       IWL_DEBUG_RATE("enter\n");
> -
>        /* Send management frames and broadcast/multicast data using lowest
>         * rate. */
>        fc = le16_to_cpu(hdr->frame_control);
>        if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
>            is_multicast_ether_addr(hdr->addr1) ||
>            !sta || !priv_sta) {
> -               IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
>                sel->rate_idx = rate_lowest_index(sband, sta);
>                return;
>        }
>
>        rate_mask = sta->supp_rates[sband->band];
> -       index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
> -
> -       if (sband->band == IEEE80211_BAND_5GHZ)
> -               rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
> -
> -       if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
> -           !rs_sta->ibss_sta_added) {
> -               u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
> -
> -               if (sta_id == IWL_INVALID_STATION) {
> -                       IWL_DEBUG_RATE("LQ: ADD station %s\n",
> -                                      print_mac(mac, hdr->addr1));
> -                       sta_id = iwl3945_add_station(priv,
> -                                   hdr->addr1, 0, CMD_ASYNC);
> -               }
> -               if (sta_id != IWL_INVALID_STATION)
> -                       rs_sta->ibss_sta_added = 1;
> -       }
> +       index = min(rs_sta->last_txrate_idx, MAX_RATES - 1);
>
>        spin_lock_irqsave(&rs_sta->lock, flags);
>
> -       if (rs_sta->start_rate != IWL_RATE_INVALID) {
> -               index = rs_sta->start_rate;
> -               rs_sta->start_rate = IWL_RATE_INVALID;
> -       }
> -
>        window = &(rs_sta->win[index]);
>
>        fail_count = window->counter - window->success_counter;
> @@ -699,84 +693,61 @@ static void rs_get_rate(void *priv_r, st
>             (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))) {
>                window->average_tpt = IWL_INV_TPT;
>                spin_unlock_irqrestore(&rs_sta->lock, flags);
> -
> -               IWL_DEBUG_RATE("Invalid average_tpt on rate %d: "
> -                              "counter: %d, success_counter: %d, "
> -                              "expected_tpt is %sNULL\n",
> -                              index,
> -                              window->counter,
> -                              window->success_counter,
> -                              rs_sta->expected_tpt ? "not " : "");
>                goto out;
> -
>        }
>
>        window->average_tpt = ((window->success_ratio *
>                                rs_sta->expected_tpt[index] + 64) / 128);
>        current_tpt = window->average_tpt;
>
> -       high_low = iwl3945_get_adjacent_rate(rs_sta, index, rate_mask,
> +       high_low = iwl3945_get_adjacent_rate(p, rs_sta, index, rate_mask,
>                                             sband->band);
>        low = high_low & 0xff;
>        high = (high_low >> 8) & 0xff;
>
> -       if (low != IWL_RATE_INVALID)
> +       if (low != INVALID_RATE)
>                low_tpt = rs_sta->win[low].average_tpt;
>
> -       if (high != IWL_RATE_INVALID)
> +       if (high != INVALID_RATE)
>                high_tpt = rs_sta->win[high].average_tpt;
>
>        spin_unlock_irqrestore(&rs_sta->lock, flags);
>
>        scale_action = 1;
>
> -       if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt) {
> -               IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
> +       if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt)
>                scale_action = -1;
> -       } else if ((low_tpt == IWL_INV_TPT) && (high_tpt == IWL_INV_TPT))
> +       else if ((low_tpt == IWL_INV_TPT) && (high_tpt == IWL_INV_TPT))
>                scale_action = 1;
>        else if ((low_tpt != IWL_INV_TPT) && (high_tpt != IWL_INV_TPT) &&
> -                (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
> -               IWL_DEBUG_RATE("No action -- low [%d] & high [%d] < "
> -                              "current_tpt [%d]\n",
> -                              low_tpt, high_tpt, current_tpt);
> +                (low_tpt < current_tpt) && (high_tpt < current_tpt))
>                scale_action = 0;
> -       } else {
> +       else {
>                if (high_tpt != IWL_INV_TPT) {
>                        if (high_tpt > current_tpt)
>                                scale_action = 1;
> -                       else {
> -                               IWL_DEBUG_RATE
> -                                   ("decrease rate because of high tpt\n");
> +                       else
>                                scale_action = -1;
> -                       }
>                } else if (low_tpt != IWL_INV_TPT) {
> -                       if (low_tpt > current_tpt) {
> -                               IWL_DEBUG_RATE
> -                                   ("decrease rate because of low tpt\n");
> +                       if (low_tpt > current_tpt)
>                                scale_action = -1;
> -                       } else
> +                       else
>                                scale_action = 1;
>                }
>        }
>
>        if ((window->success_ratio > IWL_RATE_HIGH_TH) ||
> -           (current_tpt > window->average_tpt)) {
> -               IWL_DEBUG_RATE("No action -- success_ratio [%d] > HIGH_TH or "
> -                              "current_tpt [%d] > average_tpt [%d]\n",
> -                              window->success_ratio,
> -                              current_tpt, window->average_tpt);
> +           (current_tpt > window->average_tpt))
>                scale_action = 0;
> -       }
>
>        switch (scale_action) {
>        case -1:
> -               if (low != IWL_RATE_INVALID)
> +               if (low != INVALID_RATE)
>                        index = low;
>                break;
>
>        case 1:
> -               if (high != IWL_RATE_INVALID)
> +               if (high != INVALID_RATE)
>                        index = high;
>
>                break;
> @@ -786,18 +757,9 @@ static void rs_get_rate(void *priv_r, st
>                break;
>        }
>
> -       IWL_DEBUG_RATE("Selected %d (action %d) - low %d high %d\n",
> -                      index, scale_action, low, high);
> -
>  out:
> -
>        rs_sta->last_txrate_idx = index;
> -       if (sband->band == IEEE80211_BAND_5GHZ)
> -               sel->rate_idx = rs_sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
> -       else
> -               sel->rate_idx = rs_sta->last_txrate_idx;
> -
> -       IWL_DEBUG_RATE("leave: %d\n", index);
> +       sel->rate_idx = index;
>  }
>
>  static struct rate_control_ops rs_ops = {
> @@ -815,61 +777,6 @@ static struct rate_control_ops rs_ops =
>
>  void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
>  {
> -       struct iwl3945_priv *priv = hw->priv;
> -       s32 rssi = 0;
> -       unsigned long flags;
> -       struct iwl3945_rs_sta *rs_sta;
> -       struct ieee80211_sta *sta;
> -       struct iwl3945_sta_priv *psta;
> -
> -       IWL_DEBUG_RATE("enter\n");
> -
> -       rcu_read_lock();
> -
> -       sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
> -       if (!sta) {
> -               rcu_read_unlock();
> -               return;
> -       }
> -
> -       psta = (void *) sta->drv_priv;
> -       rs_sta = psta->rs_sta;
> -
> -       spin_lock_irqsave(&rs_sta->lock, flags);
> -
> -       rs_sta->tgg = 0;
> -       switch (priv->band) {
> -       case IEEE80211_BAND_2GHZ:
> -               /* TODO: this always does G, not a regression */
> -               if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
> -                       rs_sta->tgg = 1;
> -                       rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
> -               } else
> -                       rs_sta->expected_tpt = iwl3945_expected_tpt_g;
> -               break;
> -
> -       case IEEE80211_BAND_5GHZ:
> -               rs_sta->expected_tpt = iwl3945_expected_tpt_a;
> -               break;
> -       case IEEE80211_NUM_BANDS:
> -               BUG();
> -               break;
> -       }
> -
> -       spin_unlock_irqrestore(&rs_sta->lock, flags);
> -
> -       rssi = priv->last_rx_rssi;
> -       if (rssi == 0)
> -               rssi = IWL_MIN_RSSI_VAL;
> -
> -       IWL_DEBUG(IWL_DL_INFO | IWL_DL_RATE, "Network RSSI: %d\n", rssi);
> -
> -       rs_sta->start_rate = iwl3945_get_rate_index_by_rssi(rssi, priv->band);
> -
> -       IWL_DEBUG_RATE("leave: rssi %d assign rate index: "
> -                      "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
> -                      iwl3945_rates[rs_sta->start_rate].plcp);
> -       rcu_read_unlock();
>  }
>
>  int iwl3945_rate_control_register(void)
> @@ -881,5 +788,3 @@ void iwl3945_rate_control_unregister(voi
>  {
>        ieee80211_rate_control_unregister(&rs_ops);
>  }
> -
> -
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.h  2008-10-09 19:33:10.000000000 +0200
> +++ /dev/null   1970-01-01 00:00:00.000000000 +0000
> @@ -1,206 +0,0 @@
> -/******************************************************************************
> - *
> - * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of version 2 of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
> - *
> - * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> - *
> - * Contact Information:
> - * James P. Ketrenos <ipw2100-admin@linux.intel.com>
> - * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
> - *
> - *****************************************************************************/
> -
> -#ifndef __iwl_3945_rs_h__
> -#define __iwl_3945_rs_h__
> -
> -struct iwl3945_rate_info {
> -       u8 plcp;                /* uCode API:  IWL_RATE_6M_PLCP, etc. */
> -       u8 ieee;                /* MAC header:  IWL_RATE_6M_IEEE, etc. */
> -       u8 prev_ieee;           /* previous rate in IEEE speeds */
> -       u8 next_ieee;           /* next rate in IEEE speeds */
> -       u8 prev_rs;             /* previous rate used in rs algo */
> -       u8 next_rs;             /* next rate used in rs algo */
> -       u8 prev_rs_tgg;         /* previous rate used in TGG rs algo */
> -       u8 next_rs_tgg;         /* next rate used in TGG rs algo */
> -       u8 table_rs_index;      /* index in rate scale table cmd */
> -       u8 prev_table_rs;       /* prev in rate table cmd */
> -};
> -
> -/*
> - * These serve as indexes into
> - * struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
> - */
> -enum {
> -       IWL_RATE_1M_INDEX = 0,
> -       IWL_RATE_2M_INDEX,
> -       IWL_RATE_5M_INDEX,
> -       IWL_RATE_11M_INDEX,
> -       IWL_RATE_6M_INDEX,
> -       IWL_RATE_9M_INDEX,
> -       IWL_RATE_12M_INDEX,
> -       IWL_RATE_18M_INDEX,
> -       IWL_RATE_24M_INDEX,
> -       IWL_RATE_36M_INDEX,
> -       IWL_RATE_48M_INDEX,
> -       IWL_RATE_54M_INDEX,
> -       IWL_RATE_COUNT,
> -       IWL_RATE_INVM_INDEX,
> -       IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
> -};
> -
> -enum {
> -       IWL_RATE_6M_INDEX_TABLE = 0,
> -       IWL_RATE_9M_INDEX_TABLE,
> -       IWL_RATE_12M_INDEX_TABLE,
> -       IWL_RATE_18M_INDEX_TABLE,
> -       IWL_RATE_24M_INDEX_TABLE,
> -       IWL_RATE_36M_INDEX_TABLE,
> -       IWL_RATE_48M_INDEX_TABLE,
> -       IWL_RATE_54M_INDEX_TABLE,
> -       IWL_RATE_1M_INDEX_TABLE,
> -       IWL_RATE_2M_INDEX_TABLE,
> -       IWL_RATE_5M_INDEX_TABLE,
> -       IWL_RATE_11M_INDEX_TABLE,
> -       IWL_RATE_INVM_INDEX_TABLE = IWL_RATE_INVM_INDEX,
> -};
> -
> -enum {
> -       IWL_FIRST_OFDM_RATE = IWL_RATE_6M_INDEX,
> -       IWL_LAST_OFDM_RATE = IWL_RATE_54M_INDEX,
> -       IWL_FIRST_CCK_RATE = IWL_RATE_1M_INDEX,
> -       IWL_LAST_CCK_RATE = IWL_RATE_11M_INDEX,
> -};
> -
> -/* #define vs. enum to keep from defaulting to 'large integer' */
> -#define        IWL_RATE_6M_MASK   (1 << IWL_RATE_6M_INDEX)
> -#define        IWL_RATE_9M_MASK   (1 << IWL_RATE_9M_INDEX)
> -#define        IWL_RATE_12M_MASK  (1 << IWL_RATE_12M_INDEX)
> -#define        IWL_RATE_18M_MASK  (1 << IWL_RATE_18M_INDEX)
> -#define        IWL_RATE_24M_MASK  (1 << IWL_RATE_24M_INDEX)
> -#define        IWL_RATE_36M_MASK  (1 << IWL_RATE_36M_INDEX)
> -#define        IWL_RATE_48M_MASK  (1 << IWL_RATE_48M_INDEX)
> -#define        IWL_RATE_54M_MASK  (1 << IWL_RATE_54M_INDEX)
> -#define        IWL_RATE_1M_MASK   (1 << IWL_RATE_1M_INDEX)
> -#define        IWL_RATE_2M_MASK   (1 << IWL_RATE_2M_INDEX)
> -#define        IWL_RATE_5M_MASK   (1 << IWL_RATE_5M_INDEX)
> -#define        IWL_RATE_11M_MASK  (1 << IWL_RATE_11M_INDEX)
> -
> -/* 3945 uCode API values for (legacy) bit rates, both OFDM and CCK */
> -enum {
> -       IWL_RATE_6M_PLCP = 13,
> -       IWL_RATE_9M_PLCP = 15,
> -       IWL_RATE_12M_PLCP = 5,
> -       IWL_RATE_18M_PLCP = 7,
> -       IWL_RATE_24M_PLCP = 9,
> -       IWL_RATE_36M_PLCP = 11,
> -       IWL_RATE_48M_PLCP = 1,
> -       IWL_RATE_54M_PLCP = 3,
> -       IWL_RATE_1M_PLCP = 10,
> -       IWL_RATE_2M_PLCP = 20,
> -       IWL_RATE_5M_PLCP = 55,
> -       IWL_RATE_11M_PLCP = 110,
> -};
> -
> -/* MAC header values for bit rates */
> -enum {
> -       IWL_RATE_6M_IEEE = 12,
> -       IWL_RATE_9M_IEEE = 18,
> -       IWL_RATE_12M_IEEE = 24,
> -       IWL_RATE_18M_IEEE = 36,
> -       IWL_RATE_24M_IEEE = 48,
> -       IWL_RATE_36M_IEEE = 72,
> -       IWL_RATE_48M_IEEE = 96,
> -       IWL_RATE_54M_IEEE = 108,
> -       IWL_RATE_1M_IEEE = 2,
> -       IWL_RATE_2M_IEEE = 4,
> -       IWL_RATE_5M_IEEE = 11,
> -       IWL_RATE_11M_IEEE = 22,
> -};
> -
> -#define IWL_CCK_BASIC_RATES_MASK    \
> -       (IWL_RATE_1M_MASK          | \
> -       IWL_RATE_2M_MASK)
> -
> -#define IWL_CCK_RATES_MASK          \
> -       (IWL_BASIC_RATES_MASK      | \
> -       IWL_RATE_5M_MASK          | \
> -       IWL_RATE_11M_MASK)
> -
> -#define IWL_OFDM_BASIC_RATES_MASK   \
> -       (IWL_RATE_6M_MASK         | \
> -       IWL_RATE_12M_MASK         | \
> -       IWL_RATE_24M_MASK)
> -
> -#define IWL_OFDM_RATES_MASK         \
> -       (IWL_OFDM_BASIC_RATES_MASK | \
> -       IWL_RATE_9M_MASK          | \
> -       IWL_RATE_18M_MASK         | \
> -       IWL_RATE_36M_MASK         | \
> -       IWL_RATE_48M_MASK         | \
> -       IWL_RATE_54M_MASK)
> -
> -#define IWL_BASIC_RATES_MASK         \
> -       (IWL_OFDM_BASIC_RATES_MASK | \
> -        IWL_CCK_BASIC_RATES_MASK)
> -
> -#define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
> -
> -#define IWL_INV_TPT    -1
> -
> -#define IWL_MIN_RSSI_VAL                 -100
> -#define IWL_MAX_RSSI_VAL                    0
> -
> -extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
> -
> -static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
> -{
> -       u8 rate = iwl3945_rates[rate_index].prev_ieee;
> -
> -       if (rate == IWL_RATE_INVALID)
> -               rate = rate_index;
> -       return rate;
> -}
> -
> -/**
> - * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
> - *
> - * The specific throughput table used is based on the type of network
> - * the associated with, including A, B, G, and G w/ TGG protection
> - */
> -extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
> -
> -/**
> - * iwl3945_rate_control_register - Register the rate control algorithm callbacks
> - *
> - * Since the rate control algorithm is hardware specific, there is no need
> - * or reason to place it as a stand alone module.  The driver can call
> - * iwl3945_rate_control_register in order to register the rate control callbacks
> - * with the mac80211 subsystem.  This should be performed prior to calling
> - * ieee80211_register_hw
> - *
> - */
> -extern int iwl3945_rate_control_register(void);
> -
> -/**
> - * iwl3945_rate_control_unregister - Unregister the rate control callbacks
> - *
> - * This should be called after calling ieee80211_unregister_hw, but before
> - * the driver is unloaded.
> - */
> -extern void iwl3945_rate_control_unregister(void);
> -
> -#endif
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.c     2008-10-09 19:33:11.000000000 +0200
> +++ everything/drivers/net/wireless/iwlwifi/iwl-3945.c  2008-10-09 19:44:55.000000000 +0200
> @@ -41,7 +41,6 @@
>  #include "iwl-3945-core.h"
>  #include "iwl-3945.h"
>  #include "iwl-helpers.h"
> -#include "iwl-3945-rs.h"
>
>  #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
>        [IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,   \
> @@ -677,7 +676,6 @@ static void iwl3945_rx_reply_rx(struct i
>        if (network_packet) {
>                priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
>                priv->last_tsf = le64_to_cpu(rx_end->timestamp);
> -               priv->last_rx_rssi = rx_status.signal;
>                priv->last_rx_noise = rx_status.noise;
>        }
>
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h     2008-10-09 19:33:11.000000000 +0200
> +++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h  2008-10-09 19:44:55.000000000 +0200
> @@ -159,6 +159,155 @@ struct iwl3945_tx_queue {
>
>  #define IWL_NUM_SCAN_RATES         (2)
>
> +/* 3945 uCode API values for (legacy) bit rates, both OFDM and CCK */
> +enum {
> +       IWL_RATE_6M_PLCP = 13,
> +       IWL_RATE_9M_PLCP = 15,
> +       IWL_RATE_12M_PLCP = 5,
> +       IWL_RATE_18M_PLCP = 7,
> +       IWL_RATE_24M_PLCP = 9,
> +       IWL_RATE_36M_PLCP = 11,
> +       IWL_RATE_48M_PLCP = 1,
> +       IWL_RATE_54M_PLCP = 3,
> +       IWL_RATE_1M_PLCP = 10,
> +       IWL_RATE_2M_PLCP = 20,
> +       IWL_RATE_5M_PLCP = 55,
> +       IWL_RATE_11M_PLCP = 110,
> +};
> +
> +/*
> + * These serve as indexes into
> + * struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
> + */
> +enum {
> +       IWL_RATE_1M_INDEX = 0,
> +       IWL_RATE_2M_INDEX,
> +       IWL_RATE_5M_INDEX,
> +       IWL_RATE_11M_INDEX,
> +       IWL_RATE_6M_INDEX,
> +       IWL_RATE_9M_INDEX,
> +       IWL_RATE_12M_INDEX,
> +       IWL_RATE_18M_INDEX,
> +       IWL_RATE_24M_INDEX,
> +       IWL_RATE_36M_INDEX,
> +       IWL_RATE_48M_INDEX,
> +       IWL_RATE_54M_INDEX,
> +       IWL_RATE_COUNT,
> +       IWL_RATE_INVM_INDEX,
> +       IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
> +};
> +
> +enum {
> +       IWL_RATE_6M_INDEX_TABLE = 0,
> +       IWL_RATE_9M_INDEX_TABLE,
> +       IWL_RATE_12M_INDEX_TABLE,
> +       IWL_RATE_18M_INDEX_TABLE,
> +       IWL_RATE_24M_INDEX_TABLE,
> +       IWL_RATE_36M_INDEX_TABLE,
> +       IWL_RATE_48M_INDEX_TABLE,
> +       IWL_RATE_54M_INDEX_TABLE,
> +       IWL_RATE_1M_INDEX_TABLE,
> +       IWL_RATE_2M_INDEX_TABLE,
> +       IWL_RATE_5M_INDEX_TABLE,
> +       IWL_RATE_11M_INDEX_TABLE,
> +       IWL_RATE_INVM_INDEX_TABLE = IWL_RATE_INVM_INDEX,
> +};
> +
> +/* MAC header values for bit rates */
> +enum {
> +       IWL_RATE_6M_IEEE = 12,
> +       IWL_RATE_9M_IEEE = 18,
> +       IWL_RATE_12M_IEEE = 24,
> +       IWL_RATE_18M_IEEE = 36,
> +       IWL_RATE_24M_IEEE = 48,
> +       IWL_RATE_36M_IEEE = 72,
> +       IWL_RATE_48M_IEEE = 96,
> +       IWL_RATE_54M_IEEE = 108,
> +       IWL_RATE_1M_IEEE = 2,
> +       IWL_RATE_2M_IEEE = 4,
> +       IWL_RATE_5M_IEEE = 11,
> +       IWL_RATE_11M_IEEE = 22,
> +};
> +/* XXXX */
> +extern int iwl3945_rate_control_register(void);
> +extern void iwl3945_rate_control_unregister(void);
> +extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
> +
> +enum {
> +       IWL_FIRST_OFDM_RATE = IWL_RATE_6M_INDEX,
> +       IWL_LAST_OFDM_RATE = IWL_RATE_54M_INDEX,
> +       IWL_FIRST_CCK_RATE = IWL_RATE_1M_INDEX,
> +       IWL_LAST_CCK_RATE = IWL_RATE_11M_INDEX,
> +};
> +
> +/* #define vs. enum to keep from defaulting to 'large integer' */
> +#define        IWL_RATE_6M_MASK   (1 << IWL_RATE_6M_INDEX)
> +#define        IWL_RATE_9M_MASK   (1 << IWL_RATE_9M_INDEX)
> +#define        IWL_RATE_12M_MASK  (1 << IWL_RATE_12M_INDEX)
> +#define        IWL_RATE_18M_MASK  (1 << IWL_RATE_18M_INDEX)
> +#define        IWL_RATE_24M_MASK  (1 << IWL_RATE_24M_INDEX)
> +#define        IWL_RATE_36M_MASK  (1 << IWL_RATE_36M_INDEX)
> +#define        IWL_RATE_48M_MASK  (1 << IWL_RATE_48M_INDEX)
> +#define        IWL_RATE_54M_MASK  (1 << IWL_RATE_54M_INDEX)
> +#define        IWL_RATE_1M_MASK   (1 << IWL_RATE_1M_INDEX)
> +#define        IWL_RATE_2M_MASK   (1 << IWL_RATE_2M_INDEX)
> +#define        IWL_RATE_5M_MASK   (1 << IWL_RATE_5M_INDEX)
> +#define        IWL_RATE_11M_MASK  (1 << IWL_RATE_11M_INDEX)
> +
> +#define IWL_CCK_BASIC_RATES_MASK    \
> +       (IWL_RATE_1M_MASK          | \
> +       IWL_RATE_2M_MASK)
> +
> +#define IWL_CCK_RATES_MASK          \
> +       (IWL_BASIC_RATES_MASK      | \
> +       IWL_RATE_5M_MASK          | \
> +       IWL_RATE_11M_MASK)
> +
> +#define IWL_OFDM_BASIC_RATES_MASK   \
> +       (IWL_RATE_6M_MASK         | \
> +       IWL_RATE_12M_MASK         | \
> +       IWL_RATE_24M_MASK)
> +
> +#define IWL_OFDM_RATES_MASK         \
> +       (IWL_OFDM_BASIC_RATES_MASK | \
> +       IWL_RATE_9M_MASK          | \
> +       IWL_RATE_18M_MASK         | \
> +       IWL_RATE_36M_MASK         | \
> +       IWL_RATE_48M_MASK         | \
> +       IWL_RATE_54M_MASK)
> +
> +#define IWL_BASIC_RATES_MASK         \
> +       (IWL_OFDM_BASIC_RATES_MASK | \
> +        IWL_CCK_BASIC_RATES_MASK)
> +
> +#define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
> +
> +struct iwl3945_rate_info {
> +       u8 plcp;                /* uCode API:  IWL_RATE_6M_PLCP, etc. */
> +       u8 ieee;                /* MAC header:  IWL_RATE_6M_IEEE, etc. */
> +       u8 prev_ieee;           /* previous rate in IEEE speeds */
> +       u8 next_ieee;           /* next rate in IEEE speeds */
> +       u8 prev_rs;             /* previous rate used in rs algo */
> +       u8 next_rs;             /* next rate used in rs algo */
> +       u8 prev_rs_tgg;         /* previous rate used in TGG rs algo */
> +       u8 next_rs_tgg;         /* next rate used in TGG rs algo */
> +       u8 table_rs_index;      /* index in rate scale table cmd */
> +       u8 prev_table_rs;       /* prev in rate table cmd */
> +};
> +
> +extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
> +
> +static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
> +{
> +       u8 rate = iwl3945_rates[rate_index].prev_ieee;
> +
> +       if (rate == IWL_RATE_INVALID)
> +               rate = rate_index;
> +       return rate;
> +}
> +
> +
> +
>  struct iwl3945_channel_tgd_info {
>        u8 type;
>        s8 max_power;
> @@ -230,8 +379,6 @@ struct iwl3945_clip_group {
>        const s8 clip_powers[IWL_MAX_RATES];
>  };
>
> -#include "iwl-3945-rs.h"
> -
>  #define IWL_TX_FIFO_AC0        0
>  #define IWL_TX_FIFO_AC1        1
>  #define IWL_TX_FIFO_AC2        2
> @@ -819,7 +966,6 @@ struct iwl3945_priv {
>
>        unsigned long status;
>
> -       int last_rx_rssi;       /* From Rx packet statisitics */
>        int last_rx_noise;      /* From beacon statistics */
>
>        struct iwl3945_power_mgr power_data;
>
>
>
