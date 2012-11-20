Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61190 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2KTLqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:46:14 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so8373752iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:46:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353410411-18833-6-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com> <1353410411-18833-6-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 20 Nov 2012 13:45:58 +0200
Message-ID: <CA+XVXfcXYbqgOaX43_X4b1+CL4Pchr_cR2_4Y1YyycF4dk6_Hg@mail.gmail.com> (sfid-20121120_124618_437127_9E702359)
Subject: Re: [PATCH v2 05/11] wlcore: add chanctx implementation
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 1:20 PM, Eliad Peller <eliad@wizery.com> wrote:
> Add some basic chanctx implementation - debug prints,
> and save the vif's channel/band/type.
>
> After that, we no longer need to handle channel change
> notifications on op_config.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: take mutex, flush on unassign (thanks Arik!)
>     squash patch [09/15] into this one (thanks Johannes!)
>
> drivers/net/wireless/ti/wlcore/main.c |  145 ++++++++++++++++++---------------
>  1 files changed, 79 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 18ac8d1..450ff49 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -2682,49 +2682,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>                              struct ieee80211_conf *conf, u32 changed)
>  {
>         bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
> -       int channel, ret;
> -
> -       channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
> -
> -       /* if the channel changes while joined, join again */
> -       if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
> -           ((wlvif->band != conf->channel->band) ||
> -            (wlvif->channel != channel) ||
> -            (wlvif->channel_type != conf->channel_type))) {
> -               /* send all pending packets */
> -               ret = wlcore_tx_work_locked(wl);
> -               if (ret < 0)
> -                       return ret;
> -
> -               wlvif->band = conf->channel->band;
> -               wlvif->channel = channel;
> -               wlvif->channel_type = conf->channel_type;
> -
> -               if (is_ap) {
> -                       wl1271_set_band_rate(wl, wlvif);
> -                       ret = wl1271_init_ap_rates(wl, wlvif);
> -                       if (ret < 0)
> -                               wl1271_error("AP rate policy change failed %d",
> -                                            ret);
> -               } else {
> -                       /*
> -                        * FIXME: the mac80211 should really provide a fixed
> -                        * rate to use here. for now, just use the smallest
> -                        * possible rate for the band as a fixed rate for
> -                        * association frames and other control messages.
> -                        */
> -                       if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
> -                               wl1271_set_band_rate(wl, wlvif);
> -
> -                       wlvif->basic_rate =
> -                               wl1271_tx_min_rate_get(wl,
> -                                                      wlvif->basic_rate_set);
> -                       ret = wl1271_acx_sta_rate_policies(wl, wlvif);
> -                       if (ret < 0)
> -                               wl1271_warning("rate policy for channel "
> -                                              "failed %d", ret);
> -               }
> -       }
> +       int ret;
>
>         if ((changed & IEEE80211_CONF_CHANGE_PS) && !is_ap) {
>
> @@ -2779,37 +2737,17 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
>         struct wl1271 *wl = hw->priv;
>         struct wl12xx_vif *wlvif;
>         struct ieee80211_conf *conf = &hw->conf;
> -       int channel, ret = 0;
> -
> -       channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
> +       int ret = 0;
>
> -       wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
> +       wl1271_debug(DEBUG_MAC80211, "mac80211 config psm %s power %d %s"
>                      " changed 0x%x",
> -                    channel,
>                      conf->flags & IEEE80211_CONF_PS ? "on" : "off",
>                      conf->power_level,
>                      conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use",
>                          changed);
>
> -       /*
> -        * mac80211 will go to idle nearly immediately after transmitting some
> -        * frames, such as the deauth. To make sure those frames reach the air,
> -        * wait here until the TX queue is fully flushed.
> -        */
> -       if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
> -           ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
> -            (conf->flags & IEEE80211_CONF_IDLE)))
> -               wl1271_tx_flush(wl);
> -
>         mutex_lock(&wl->mutex);
>
> -       /* we support configuring the channel and band even while off */
> -       if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> -               wl->band = conf->channel->band;
> -               wl->channel = channel;
> -               wl->channel_type = conf->channel_type;
> -       }
> -
>         if (changed & IEEE80211_CONF_CHANGE_POWER)
>                 wl->power_level = conf->power_level;
>
> @@ -3758,7 +3696,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
>         struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
>         int ret = 0;
>
> -       if ((changed & BSS_CHANGED_BASIC_RATES)) {
> +       if (changed & BSS_CHANGED_BASIC_RATES) {
>                 u32 rates = bss_conf->basic_rates;
>
>                 wlvif->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates,
> @@ -4184,6 +4122,76 @@ out:
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
> +       mutex_lock(&wl->mutex);
> +
> +       wlvif->band = ctx->channel->band;
> +       wlvif->channel = channel;
> +       wlvif->channel_type = ctx->channel_type;
> +
> +       /* update default rates according to the band */
> +       wl1271_set_band_rate(wl, wlvif);

set_band_rate should be fixed to also set wl->basic_rate. but this can
be a separate patch..
previously we had some manual code to set the basic_rate, which you removed.
