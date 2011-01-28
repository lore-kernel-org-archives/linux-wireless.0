Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45899 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1A1Gvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 01:51:45 -0500
Received: by gwj20 with SMTP id 20so960209gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 22:51:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296158081-16398-5-git-send-email-eliad@wizery.com>
References: <1296158081-16398-1-git-send-email-eliad@wizery.com> <1296158081-16398-5-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Fri, 28 Jan 2011 08:51:28 +0200
Message-ID: <AANLkTinp6gryW5wG_QcbqyT4ZMP17QSZ48Mqbwjaz+me@mail.gmail.com>
Subject: Re: [PATCH 4/4] wl12xx: set supported_rates after association
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 21:54, Eliad Peller <eliad@wizery.com> wrote:
> Instead of looking for supported_rates change on every tx packet,
> just extract the supported_rates after association completes (station only).
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/acx.c  |    4 +
>  drivers/net/wireless/wl12xx/cmd.c  |   11 +--
>  drivers/net/wireless/wl12xx/main.c |  112 +++++++++++++++---------------------
>  drivers/net/wireless/wl12xx/tx.c   |   22 -------
>  4 files changed, 54 insertions(+), 95 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index 6ea19d7..33840d9 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -783,6 +783,10 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
>
>        acx->rate_class_cnt = cpu_to_le32(ACX_TX_RATE_POLICY_CNT);
>
> +       wl1271_debug(DEBUG_ACX, "basic_rate: 0x%x, full_rate: 0x%x",
> +               acx->rate_class[ACX_TX_BASIC_RATE].enabled_rates,
> +               acx->rate_class[ACX_TX_AP_FULL_RATE].enabled_rates);
> +
>        ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
>        if (ret < 0) {
>                wl1271_warning("Setting of rate policies failed: %d", ret);
> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 66d15e7..97ffd7a 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -286,13 +286,7 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
>        join->rx_filter_options = cpu_to_le32(wl->rx_filter);
>        join->bss_type = bss_type;
>        join->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
> -       /*
> -        * for supported_rate_set, we should use wl->rate_set. however,
> -        * it seems that acx_rate_policies doesn't affect full_rate, and
> -        * since we want to avoid additional join, we'll use a 0xffffffff value,
> -        * and let the fw find the actual supported rates
> -        */
> -       join->supported_rate_set = cpu_to_le32(0xffffffff);
> +       join->supported_rate_set = cpu_to_le32(wl->rate_set);
>
>        if (wl->band == IEEE80211_BAND_5GHZ)
>                join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
> @@ -310,6 +304,9 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
>        wl->tx_security_last_seq = 0;
>        wl->tx_security_seq = 0;
>
> +       wl1271_debug(DEBUG_CMD, "cmd join: basic_rate_set=0x%x, rate_set=0x%x",
> +               join->basic_rate_set, join->supported_rate_set);
> +
>        ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join), 0);
>        if (ret < 0) {
>                wl1271_error("failed to initiate cmd join");
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 0f6786d..57f4553 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -978,39 +978,10 @@ int wl1271_plt_stop(struct wl1271 *wl)
>  static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>        struct wl1271 *wl = hw->priv;
> -       struct ieee80211_conf *conf = &hw->conf;
> -       struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
> -       struct ieee80211_sta *sta = txinfo->control.sta;
>        unsigned long flags;
>        int q;
>
> -       /*
> -        * peek into the rates configured in the STA entry.
> -        * The rates set after connection stage, The first block only BG sets:
> -        * the compare is for bit 0-16 of sta_rate_set. The second block add
> -        * HT rates in case of HT supported.
> -        */
>        spin_lock_irqsave(&wl->wl_lock, flags);
> -       if (sta &&
> -           (sta->supp_rates[conf->channel->band] !=
> -           (wl->sta_rate_set & HW_BG_RATES_MASK)) &&
> -               wl->bss_type != BSS_TYPE_AP_BSS) {
> -               wl->sta_rate_set = sta->supp_rates[conf->channel->band];
> -               set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
> -       }
> -
> -#ifdef CONFIG_WL12XX_HT
> -       if (sta &&
> -           sta->ht_cap.ht_supported &&
> -           ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=
> -             sta->ht_cap.mcs.rx_mask[0])) {
> -               /* Clean MCS bits before setting them */
> -               wl->sta_rate_set &= HW_BG_RATES_MASK;
> -               wl->sta_rate_set |=
> -                       (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
> -               set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
> -       }
> -#endif
>        wl->tx_queue_count++;
>        spin_unlock_irqrestore(&wl->wl_lock, flags);
>
> @@ -2246,6 +2217,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>  {
>        bool do_join = false, set_assoc = false;
>        bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
> +       u32 sta_rate_set = 0;
>        int ret;
>        struct ieee80211_sta *sta;
>
> @@ -2311,6 +2283,46 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>                }
>        }
>
> +       rcu_read_lock();
> +       sta = ieee80211_find_sta(vif, bss_conf->bssid);
> +       if (sta)  {
> +               /* save the supp_rates of the ap */
> +               sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
> +
> +               /* handle new association with HT and HT information change */
> +               if ((changed & BSS_CHANGED_HT) &&
> +                   (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
> +                       ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
> +                                                            true);
> +                       if (ret < 0) {
> +                               wl1271_warning("Set ht cap true failed %d",
> +                                              ret);
> +                               rcu_read_unlock();
> +                               goto out;
> +                       }
> +                       ret = wl1271_acx_set_ht_information(wl,
> +                                               bss_conf->ht_operation_mode);
> +                       if (ret < 0) {
> +                               wl1271_warning("Set ht information failed %d",
> +                                              ret);
> +                               rcu_read_unlock();
> +                               goto out;

Perhaps its better to also save sta->ht_cap locally and
rcu_read_unlock() immediately? Seems to me wl1271_acx_set_ht_*()
functions might block.

Arik
