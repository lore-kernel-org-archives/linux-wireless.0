Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49147 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0EFV7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 17:59:06 -0400
Received: by pwi5 with SMTP id 5so207554pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 14:59:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273159552-5579-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1273159552-5579-1-git-send-email-wey-yi.w.guy@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 May 2010 14:58:45 -0700
Message-ID: <x2z43e72e891005061458uabf4a6cxae3f5dd4067f0fbb@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mac80211: add offload channel switch support
To: wey-yi.w.guy@intel.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 6, 2010 at 8:25 AM,  <wey-yi.w.guy@intel.com> wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> Adding support to offload the channel switch operation to driver if
> driver can support the function.

Can you please reword this a little, maybe, "This adds support for a
driver specific channel switch callback to be used by drivers which
might require a finer grain control of the operation, typically if you
have a respective firmware API call".

> The original approach, mac80211 utilize the mac_config callback function

Do you mean the mac80211 config() callback?

> and set the CHANNEL_CHANGE flag which is difficult to separate the true
> channel switch request from all the other channel changes condition;

Good point, but why is this needed? More below.

> with this offload approach, driver has more control on how to handle the
> channel switch request from AP, also can provide more accurate timing
> calculation

Is the current timing insufficient, and if so can you provide more
details. If the real reason for this callback is not timing
considerations is the real reason a firmware API thing? If so it
doesn't hurt to just say that to avoid confusing developer in deciding
which approach to take.

> The drivers like to support the channel switch offloading function

Maybe: "The drivers that require a dedicated channel switch callback"...

> will have
> to provide the mactime information (at least for mgmt and action frames)

Might be good to specify why, or at least in the documentation code below.

> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> v2: use "mactime" instead of timestamp in the frame body, the driver has to provide the mactime if need to support the channel switch function
> ---
>  include/net/mac80211.h      |   32 ++++++++++++++++++++++++++++
>  net/mac80211/driver-ops.h   |   11 +++++++++
>  net/mac80211/driver-trace.h |   49 +++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/ieee80211_i.h  |    3 +-
>  net/mac80211/mlme.c         |   48 ++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 138 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2879c8e..dc5ae23 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -708,6 +708,26 @@ struct ieee80211_conf {
>  };
>
>  /**
> + * struct ieee80211_channel_switch - holds the channel switch data
> + *
> + * The information provided in this structure is required for channel switch
> + * operation.
> + *
> + * @timestamp: value in microseconds of the 64-bit Time Synchronization
> + *     Function (TSF) timer when the channel switch ie received.

Might be good to indicate this is derived from the rx status mactime
and the beacon interval from the BSS.

> + * @block_tx: set to true if no more future frames transmission within the BSS
> + *     until the scheduled channel switch
> + * @channel: pointer to ieee80211_channel contain then new channel information
> + * @count: specified the number of TBTT's until the channel switch event.
> + */
> +struct ieee80211_channel_switch {
> +       u64 timestamp;
> +       bool block_tx;
> +       struct ieee80211_channel *channel;
> +       u8 count;
> +};
> +
> +/**
>  * struct ieee80211_vif - per-interface data
>  *
>  * Data in this structure is continually present for driver
> @@ -1694,6 +1714,8 @@ struct ieee80211_ops {
>        int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
>  #endif
>        void (*flush)(struct ieee80211_hw *hw, bool drop);
> +       void (*channel_switch)(struct ieee80211_hw *hw,
> +                              struct ieee80211_channel_switch *ch_switch);
>  };
>
>  /**
> @@ -2444,6 +2466,16 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
>                               enum nl80211_cqm_rssi_threshold_event rssi_event,
>                               gfp_t gfp);
>
> +/**
> + * ieee80211_chswitch_done - Complete channel switch process
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @is_seccess: make the channel switch successful or not

Typo, is_seccess, not success. Also, I don't get what this is for, can
you elaborate?

> + *
> + * Complete the channel switch post-process: set the new operational channel
> + * and wake up the suspended queues.

I don't get it.. who calls this and why, under what conditions?

If drivers have to call this once they are done with the channel
switch operation callback then you might want to specify that and/or
check for the existance of the op upon it being called and warn if it
is not.

> + */
> +void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool is_success);
> +
>  /* Rate control API */
>
>  /**
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 997008e..5662bb5 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -373,4 +373,15 @@ static inline void drv_flush(struct ieee80211_local *local, bool drop)
>        if (local->ops->flush)
>                local->ops->flush(&local->hw, drop);
>  }
> +
> +static inline void drv_channel_switch(struct ieee80211_local *local,
> +                                    struct ieee80211_channel_switch *ch_switch)
> +{
> +       might_sleep();
> +
> +       local->ops->channel_switch(&local->hw, ch_switch);
> +
> +       trace_drv_channel_switch(local, ch_switch);
> +}
> +
>  #endif /* __MAC80211_DRIVER_OPS */
> diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
> index ce734b5..cd1ae9f 100644
> --- a/net/mac80211/driver-trace.h
> +++ b/net/mac80211/driver-trace.h
> @@ -774,6 +774,34 @@ TRACE_EVENT(drv_flush,
>        )
>  );
>
> +TRACE_EVENT(drv_channel_switch,
> +       TP_PROTO(struct ieee80211_local *local,
> +                struct ieee80211_channel_switch *ch_switch),
> +
> +       TP_ARGS(local, ch_switch),
> +
> +       TP_STRUCT__entry(
> +               LOCAL_ENTRY
> +               __field(u64, timestamp)
> +               __field(bool, block_tx)
> +               __field(u16, freq)
> +               __field(u8, count)
> +       ),
> +
> +       TP_fast_assign(
> +               LOCAL_ASSIGN;
> +               __entry->timestamp = ch_switch->timestamp;
> +               __entry->block_tx = ch_switch->block_tx;
> +               __entry->freq = ch_switch->channel->center_freq;
> +               __entry->count = ch_switch->count;
> +       ),
> +
> +       TP_printk(
> +               LOCAL_PR_FMT " new freq:%u count:%d",
> +               LOCAL_PR_ARG, __entry->freq, __entry->count
> +       )
> +);
> +
>  /*
>  * Tracing for API calls that drivers call.
>  */
> @@ -992,6 +1020,27 @@ TRACE_EVENT(api_sta_block_awake,
>        )
>  );
>
> +TRACE_EVENT(api_chswitch_done,
> +       TP_PROTO(struct ieee80211_sub_if_data *sdata, bool is_success),
> +
> +       TP_ARGS(sdata, is_success),
> +
> +       TP_STRUCT__entry(
> +               VIF_ENTRY
> +               __field(bool, is_success)
> +       ),
> +
> +       TP_fast_assign(
> +               VIF_ASSIGN;
> +               __entry->is_success = is_success;
> +       ),
> +
> +       TP_printk(
> +               VIF_PR_FMT " chswitch:%d",
> +               VIF_PR_ARG, __entry->is_success
> +       )
> +);
> +
>  /*
>  * Tracing for internal functions
>  * (which may also be called in response to driver calls)
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 4e73660..be9dda9 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -999,7 +999,8 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
>                                  unsigned long data, void *dummy);
>  void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>                                      struct ieee80211_channel_sw_ie *sw_elem,
> -                                     struct ieee80211_bss *bss);
> +                                     struct ieee80211_bss *bss,
> +                                     u64 timestamp);
>  void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
>  void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 358226f..19b53a8 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -340,7 +340,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>                goto out;
>
>        sdata->local->oper_channel = sdata->local->csa_channel;

If the new driver callback for channel switch failed this operation
channel is still being set to the csa_channel. This *only* works
because on the channels witch done routine you write below you
overwrite the csa_channel variable to the existing operation channel.
This seem rather hackish... if the channel switch callback failed why
would we call the work to do the channel switch?

> -       ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL);
> +       if (!sdata->local->ops->channel_switch) {
> +               /* call "hw_config" only if doing sw channel switch */
> +               ieee80211_hw_config(sdata->local,
> +                       IEEE80211_CONF_CHANGE_CHANNEL);
> +       }

Notice how the existing implementation also addresses quiescing in the
timer, how will you address this with this new driver API?

>        /* XXX: shouldn't really modify cfg80211-owned data! */
>        ifmgd->associated->channel = sdata->local->oper_channel;
> @@ -352,6 +356,22 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>        mutex_unlock(&ifmgd->mtx);
>  }
>
> +void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool is_success)
> +{
> +       struct ieee80211_sub_if_data *sdata;
> +       struct ieee80211_if_managed *ifmgd;
> +
> +       sdata = vif_to_sdata(vif);
> +       ifmgd = &sdata->u.mgd;
> +
> +       trace_api_chswitch_done(sdata, is_success);
> +       if (!is_success)
> +               sdata->local->csa_channel = sdata->local->oper_channel;

If this routine is to be called by drivers once they complete the
channel switch operation why do we continue by queuing the channel
switch work below?

> +
> +       ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
> +}
> +EXPORT_SYMBOL(ieee80211_chswitch_done);
> +
>  static void ieee80211_chswitch_timer(unsigned long data)
>  {
>        struct ieee80211_sub_if_data *sdata =
> @@ -368,7 +388,8 @@ static void ieee80211_chswitch_timer(unsigned long data)
>
>  void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>                                      struct ieee80211_channel_sw_ie *sw_elem,
> -                                     struct ieee80211_bss *bss)
> +                                     struct ieee80211_bss *bss,
> +                                     u64 timestamp)
>  {
>        struct cfg80211_bss *cbss =
>                container_of((void *)bss, struct cfg80211_bss, priv);
> @@ -396,6 +417,23 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>
>        sdata->local->csa_channel = new_ch;
>
> +       if (sdata->local->ops->channel_switch) {
> +               /* use driver's channel switch callback */
> +               struct ieee80211_channel_switch ch_switch;
> +               memset(&ch_switch, 0, sizeof(ch_switch));
> +               ch_switch.timestamp = timestamp;

If timestamp is 0 (when the driver does not set it) then this is all
busted and I can see a few bug reports coming out due to it. These bug
reports could be avoided if you check for the timestamp to be
reasonable here and fail otherwise, in fact if the we know the channel
switch operation is busted we may just want to disassociate given the
DFS considerations are sensitive. What do you think?

> +               if (sw_elem->mode) {
> +                       ch_switch.block_tx = true;
> +                       ieee80211_stop_queues_by_reason(&sdata->local->hw,
> +                                       IEEE80211_QUEUE_STOP_REASON_CSA);
> +               }
> +               ch_switch.channel = new_ch;
> +               ch_switch.count = sw_elem->count;
> +               ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
> +               drv_channel_switch(sdata->local, &ch_switch);
> +               return;
> +       }
> +       /* mac80211 handle channel switch */
>        if (sw_elem->count <= 1) {
>                ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
>        } else {
> @@ -1315,7 +1353,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>                                                        ETH_ALEN) == 0)) {
>                struct ieee80211_channel_sw_ie *sw_elem =
>                        (struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
> -               ieee80211_sta_process_chanswitch(sdata, sw_elem, bss);
> +               ieee80211_sta_process_chanswitch(sdata, sw_elem,
> +                                                bss, rx_status->mactime);
>        }
>  }
>
> @@ -1647,7 +1686,8 @@ static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
>
>                        ieee80211_sta_process_chanswitch(sdata,
>                                        &mgmt->u.action.u.chan_switch.sw_elem,
> -                                       (void *)ifmgd->associated->priv);
> +                                       (void *)ifmgd->associated->priv,
> +                                       rx_status->mactime);
>                        break;
>                }
>                mutex_unlock(&ifmgd->mtx);

I'd appreciate more feedback on the why this is being done. Its not
clear to me how we are limited by the current implementation. If you
have a firmware API need that is different and I think that should be
made clear, but if you do need it we need to ensure both methods are
properly documented and their different use cases outlined. I also
think the way these method are split are rather hacky right now.

  Luis
