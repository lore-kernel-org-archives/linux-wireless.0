Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61797 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2KSVNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:13:54 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so7525884iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 13:13:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353343170-26516-6-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com> <1353343170-26516-6-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 19 Nov 2012 23:13:39 +0200
Message-ID: <CA+XVXfeUxiSPu58mYEaS-gJbT1L1-sWrH9R8mkXBVyaUaS09fw@mail.gmail.com> (sfid-20121119_221358_481560_36D9FDF0)
Subject: Re: [PATCH 05/15] wlcore: implement .remain_on_channel() callback
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
> implement the reamin_on_channel() callback by starting
> a dev role (already associated with the current vif)
> on the requested channel/band.
>
> This channel is usually different from the channel
> of the sta role, so pass it to wl12xx_roc() as well,
> and notify mac80211 (async) when the fw is ready
> on the new channel.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
[...]
> @@ -1608,7 +1610,7 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>         }
>
>         cmd->role_id = role_id;
> -       cmd->channel = wlvif->channel;
> +       cmd->channel = channel;
>         switch (wlvif->band) {
>         case IEEE80211_BAND_2GHZ:
>                 cmd->band = WLCORE_BAND_2_4GHZ;

This seems wrong... What happens if the roc is on another band from
the one the vif is connected on?

The dev role is started on the correct band, but the roc will be on
the band of the wlvif..

[...]
> +static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
> +                                      struct ieee80211_vif *vif,
> +                                      struct ieee80211_channel *chan,
> +                                      enum nl80211_channel_type channel_type,
> +                                      int duration)
> +{
> +       struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
> +       struct wl1271 *wl = hw->priv;
> +       int channel, ret = 0;
> +
> +       channel = ieee80211_frequency_to_channel(chan->center_freq);
> +
> +       wl1271_debug(DEBUG_MAC80211, "mac80211 roc %d (%d)",
> +                    channel, wlvif->role_id);
> +
> +       mutex_lock(&wl->mutex);
> +
> +       if (unlikely(wl->state != WLCORE_STATE_ON))
> +               goto out;
> +
> +       /* return EBUSY if we can't ROC right now */
> +       if (WARN_ON(wl->roc_vif ||
> +                   find_first_bit(wl->roc_map,
> +                                  WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES)) {
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
> +       /*
> +        * make sure the vif has dev role.
> +        * TODO: enable dev role dynamically instead of pre-allocating it.
> +        */

Not sure what you mean here. Seems pretty dynamic to me..

> +       if (WARN_ON_ONCE(!(wlvif->bss_type == BSS_TYPE_STA_BSS ||
> +                          wlvif->bss_type == BSS_TYPE_IBSS))) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       ret = wl1271_ps_elp_wakeup(wl);
> +       if (ret < 0)
> +               goto out;
> +
> +       ret = wl12xx_start_dev(wl, wlvif, chan->band, channel);
> +       if (ret < 0)
> +               goto out_sleep;
> +
> +       wl->roc_vif = vif;
> +       ieee80211_queue_delayed_work(hw, &wl->roc_complete_work,
> +                                    msecs_to_jiffies(duration));
> +out_sleep:
> +       wl1271_ps_elp_sleep(wl);
> +out:
> +       mutex_unlock(&wl->mutex);
> +       return ret;
> +}
> +
> +static int __wlcore_roc_completed(struct wl1271 *wl)
> +{
> +       struct wl12xx_vif *wlvif;
> +       int ret;
> +
> +       /* already completed */
> +       if (unlikely(!wl->roc_vif))
> +               return 0;
> +
> +       wlvif = wl12xx_vif_to_data(wl->roc_vif);
> +
> +       if (!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
> +               return -EBUSY;
> +
> +       ret = wl12xx_stop_dev(wl, wlvif);
> +       if (ret < 0)
> +               return ret;
> +
> +       wl->roc_vif = NULL;
> +
> +       return 0;
> +}
> +
> +static int wlcore_roc_completed(struct wl1271 *wl)
> +{
> +       int ret;
> +
> +       wl1271_debug(DEBUG_MAC80211, "roc complete");
> +
> +       mutex_lock(&wl->mutex);
> +
> +       if (unlikely(wl->state != WLCORE_STATE_ON)) {
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
> +       ret = wl1271_ps_elp_wakeup(wl);
> +       if (ret < 0)
> +               goto out;
> +
> +       ret = __wlcore_roc_completed(wl);
> +
> +       wl1271_ps_elp_sleep(wl);
> +out:
> +       mutex_unlock(&wl->mutex);
> +
> +       return ret;
> +}
> +
> +static void wlcore_roc_complete_work(struct work_struct *work)
> +{
> +       struct delayed_work *dwork;
> +       struct wl1271 *wl;
> +       int ret;
> +
> +       dwork = container_of(work, struct delayed_work, work);
> +       wl = container_of(dwork, struct wl1271, roc_complete_work);
> +
> +       ret = wlcore_roc_completed(wl);
> +       if (!ret)
> +               ieee80211_remain_on_channel_expired(wl->hw);
> +}
> +
> +static int wlcore_op_cancel_remain_on_channel(struct ieee80211_hw *hw)
> +{
> +       struct wl1271 *wl = hw->priv;
> +
> +       wl1271_debug(DEBUG_MAC80211, "mac80211 croc");
> +
> +       /* TODO: per-vif */
> +       wl1271_tx_flush(wl);
> +
> +       /*
> +        * we can't just flush_work here, because it might deadlock
> +        * (as we might get called from the same workqueue)
> +        */
> +       cancel_delayed_work_sync(&wl->roc_complete_work);
> +       wlcore_roc_completed(wl);
> +
> +       return 0;
> +}
> +
>  static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
>  {
>         struct wl1271 *wl = hw->priv;
> @@ -4849,6 +4970,8 @@ static const struct ieee80211_ops wl1271_ops = {
>         .set_bitrate_mask = wl12xx_set_bitrate_mask,
>         .channel_switch = wl12xx_op_channel_switch,
>         .flush = wlcore_op_flush,
> +       .remain_on_channel = wlcore_op_remain_on_channel,
> +       .cancel_remain_on_channel = wlcore_op_cancel_remain_on_channel,
>         CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
>  };
>
> @@ -5245,6 +5368,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
>         wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
>                 sizeof(struct ieee80211_header);
>
> +       wl->hw->wiphy->max_remain_on_channel_duration = 5000;

Isn't this the default?

> +
>         wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
>                                 WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
>
> @@ -5343,6 +5468,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
>         INIT_WORK(&wl->tx_work, wl1271_tx_work);
>         INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
>         INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
> +       INIT_DELAYED_WORK(&wl->roc_complete_work, wlcore_roc_complete_work);
>         INIT_DELAYED_WORK(&wl->tx_watchdog_work, wl12xx_tx_watchdog_work);
>         INIT_DELAYED_WORK(&wl->connection_loss_work,
>                           wl1271_connection_loss_work);
> diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
> index 1030b6b..b636f1d 100644
> --- a/drivers/net/wireless/ti/wlcore/wlcore.h
> +++ b/drivers/net/wireless/ti/wlcore/wlcore.h
> @@ -286,6 +286,9 @@ struct wl1271 {
>         /* Connection loss work */
>         struct delayed_work connection_loss_work;
>
> +       struct ieee80211_vif *roc_vif;
> +       struct delayed_work roc_complete_work;
> +
>         bool sched_scanning;
>
>         /* The current band */
> --
> 1.7.6.401.g6a319
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
