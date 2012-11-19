Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53185 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KSVXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:23:33 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so7540257iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 13:23:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353343170-26516-9-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com> <1353343170-26516-9-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 19 Nov 2012 23:23:16 +0200
Message-ID: <CA+XVXfcramc=cNy9cGt9VzJQGWd+a4dtEZ89Ku_jXxwqMPQfqw@mail.gmail.com> (sfid-20121119_222336_783499_FBF95583)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
> Add some basic chanctx implementation.
>
> Only add debug prints, and save the vif's channel/band/type.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c |   66 +++++++++++++++++++++++++++++++++
>  1 files changed, 66 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 4f4a9e5..caafd8c 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -4150,6 +4150,67 @@ out:
>         mutex_unlock(&wl->mutex);
>  }
>
> +static int wlcore_op_add_chanctx(struct ieee80211_hw *hw,
> +                                struct ieee80211_chanctx_conf *ctx)
> +{
> +       wl1271_debug(DEBUG_MAC80211, "mac80211 add chanctx %d (type %d)",
> +                    ieee80211_frequency_to_channel(ctx->channel->center_freq),
> +                    ctx->channel_type);
> +       return 0;
> +}
> +
> +static void wlcore_op_remove_chanctx(struct ieee80211_hw *hw,
> +                                    struct ieee80211_chanctx_conf *ctx)
> +{
> +       wl1271_debug(DEBUG_MAC80211, "mac80211 remove chanctx %d (type %d)",
> +                    ieee80211_frequency_to_channel(ctx->channel->center_freq),
> +                    ctx->channel_type);
> +}
> +
> +static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
> +                                    struct ieee80211_chanctx_conf *ctx,
> +                                    u32 changed)
> +{
> +       wl1271_debug(DEBUG_MAC80211,
> +                    "mac80211 change chanctx %d (type %d) changed 0x%x",
> +                    ieee80211_frequency_to_channel(ctx->channel->center_freq),
> +                    ctx->channel_type, changed);
> +}
> +
> +static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
> +                                       struct ieee80211_vif *vif,
> +                                       struct ieee80211_chanctx_conf *ctx)
> +{
> +       struct wl1271 *wl = hw->priv;
> +       struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
> +       int channel = ieee80211_frequency_to_channel(
> +               ctx->channel->center_freq);
> +
> +       wl1271_debug(DEBUG_MAC80211,
> +                    "mac80211 assign chanctx (role %d) %d (type %d)",
> +                    wlvif->role_id, channel, ctx->channel_type);
> +
> +       wlcore_tx_work_locked(wl);

is this some kind of a lame attempt at a flush? :)

why not use flush here if the channel was set - or better yet, flush
stuff at wlcore_op_unassign_vif_chanctx, which is currently unused.
we'll need the TODO there for the per-vif-flush. once everything is
upstreamed (hw queues) it would be pretty trivial to implement.

also not sure what happened to the rest of the stuff done on channel
config - updating the rate_set according to band etc..

> +       wlvif->band = ctx->channel->band;
> +       wlvif->channel = channel;
> +       wlvif->channel_type = ctx->channel_type;
> +
> +       return 0;
> +}
> +
> +static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
> +                                          struct ieee80211_vif *vif,
> +                                          struct ieee80211_chanctx_conf *ctx)
> +{
> +       struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
> +
> +       wl1271_debug(DEBUG_MAC80211,
> +                    "mac80211 unassign chanctx (role %d) %d (type %d)",
> +                    wlvif->role_id,
> +                    ieee80211_frequency_to_channel(ctx->channel->center_freq),
> +                    ctx->channel_type);
> +}
> +
>  static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
>                              struct ieee80211_vif *vif, u16 queue,
>                              const struct ieee80211_tx_queue_params *params)
> @@ -4972,6 +5033,11 @@ static const struct ieee80211_ops wl1271_ops = {
>         .flush = wlcore_op_flush,
>         .remain_on_channel = wlcore_op_remain_on_channel,
>         .cancel_remain_on_channel = wlcore_op_cancel_remain_on_channel,
> +       .add_chanctx = wlcore_op_add_chanctx,
> +       .remove_chanctx = wlcore_op_remove_chanctx,
> +       .change_chanctx = wlcore_op_change_chanctx,
> +       .assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
> +       .unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
>         CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
>  };
>
> --
> 1.7.6.401.g6a319
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
