Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62424 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaE2HTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 03:19:15 -0400
Received: by mail-qg0-f41.google.com with SMTP id j5so21305121qga.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 00:19:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401346141-9888-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401346141-9888-1-git-send-email-rmanohar@qti.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 29 May 2014 17:18:54 +1000
Message-ID: <CAGRGNgWo8AvT=hUmhR2AKr6xksw5CFFApj3eEX1nd+J=RrENpw@mail.gmail.com> (sfid-20140529_091919_904474_666BDC70)
Subject: Re: [PATCH] ath9k: Fix interface combinations for multi-channel concurrency
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

On Thu, May 29, 2014 at 4:49 PM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> Currently mac80211 does not support WDS and DFS with channel context
> drivers. So advertise these features only when the driver is not
> supporting channel context and modparam "use_chanctx" is introduced
> for preparing channel context support in ath9k.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 1af7708..765a3c0 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -61,6 +61,10 @@ static int ath9k_ps_enable;
>  module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>  MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>
> +static int ath9k_use_chanctx;
> +module_param_named(use_chanctx, ath9k_use_chanctx, int, 0444);
> +MODULE_PARM_DESC(use_chanctx, "Enable channel context for concurrency");
> +
>  bool is_ath9k_unloaded;
>
>  #ifdef CONFIG_MAC80211_LEDS
> @@ -646,8 +650,7 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
>  }
>
>  static const struct ieee80211_iface_limit if_limits[] = {
> -       { .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
> -                                BIT(NL80211_IFTYPE_WDS) },
> +       { .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) },
>         { .max = 8,     .types =
>  #ifdef CONFIG_MAC80211_MESH
>                                  BIT(NL80211_IFTYPE_MESH_POINT) |
> @@ -657,6 +660,10 @@ static const struct ieee80211_iface_limit if_limits[] = {
>                                  BIT(NL80211_IFTYPE_P2P_GO) },
>  };
>
> +static const struct ieee80211_iface_limit wds_limits[] = {
> +       { .max = 2048,  .types = BIT(NL80211_IFTYPE_WDS) },
> +};
> +
>  static const struct ieee80211_iface_limit if_dfs_limits[] = {
>         { .max = 1,     .types = BIT(NL80211_IFTYPE_AP) |
>  #ifdef CONFIG_MAC80211_MESH
> @@ -673,6 +680,13 @@ static const struct ieee80211_iface_combination if_comb[] = {
>                 .num_different_channels = 1,
>                 .beacon_int_infra_match = true,
>         },
> +       {
> +               .limits = wds_limits,
> +               .n_limits = ARRAY_SIZE(if_limits),

Shouldn't this be ARRAY_SIZE(wds_limits)?

> +               .max_interfaces = 2048,
> +               .num_different_channels = 1,
> +               .beacon_int_infra_match = true,
> +       },
>  #ifdef CONFIG_ATH9K_DFS_CERTIFIED
>         {
>                 .limits = if_dfs_limits,
> @@ -722,12 +736,15 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>                         BIT(NL80211_IFTYPE_P2P_GO) |
>                         BIT(NL80211_IFTYPE_P2P_CLIENT) |
>                         BIT(NL80211_IFTYPE_AP) |
> -                       BIT(NL80211_IFTYPE_WDS) |
>                         BIT(NL80211_IFTYPE_STATION) |
>                         BIT(NL80211_IFTYPE_ADHOC) |
>                         BIT(NL80211_IFTYPE_MESH_POINT);
>                 hw->wiphy->iface_combinations = if_comb;
> -               hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
> +               if (!ath9k_use_chanctx) {
> +                       hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
> +                       hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
> +               } else
> +                       hw->wiphy->n_iface_combinations = 1;

Is that right?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
