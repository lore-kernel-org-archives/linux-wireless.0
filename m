Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:3774 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZAWX2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:28:45 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1471836fkf.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 15:28:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090122114546.31443.79387.stgit@tikku>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
Date: Sat, 24 Jan 2009 01:28:43 +0200
Message-ID: <1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com> (sfid-20090124_002850_750884_A6C4E41E)
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power save
	mode is disabled
From: Tomas Winkler <tomasw@gmail.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: johannes@sipsolutions.net, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 1:45 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> When a directed tim bit is set, mac80211 currently disables power save
> ands sends a null frame to the AP. But if dynamic power save is
> disabled, mac80211 will not enable power save ever gain.

Why not?

Fix this by
> adding ps-poll functionality to mac80211. When a directed tim bit is
> set, mac80211 sends a ps-poll frame to the AP and checks for the more
> data bit in the returned data frames.

Still have to see the implementation but this sounds strange.

> Using ps-poll is slower than waking up with null frame, but it's saves more
> power in cases where the traffic is low. Userspace can control if either
> ps-poll or null wakeup method is used by enabling and disabling dynamic
> power save.

Do you have numbers how much power you save?. With PS-Poll you must
stay awak longer not saying that issueing TX (PS-poll) also consume
power.Ususally TXing has higher power consumption then RX.Instead of
tx(null PM=0) rx tx(ack)...rx tx(ack) tx(null PM=1) you have now
tx(ps-poll) rx tx (ack) tx(ps-poll) rx tx(ack).  So if the AP holds
more then 3 packetes PS poll will consume more power in this very
simplified computation.

Do you measure power consumption on of the NIC or the whole system?

Thanks
Tomas


>
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>
>  net/mac80211/ieee80211_i.h |    3 ++
>  net/mac80211/mlme.c        |   56 ++++++++++++++++++++++++++++++++++++++++++--
>  net/mac80211/rx.c          |   34 +++++++++++++++++++++++++++
>  3 files changed, 90 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index c9ffadb..76814e9 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -710,6 +710,7 @@ struct ieee80211_local {
>        unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
>
>        bool powersave;
> +       bool pspolling;
>        struct work_struct dynamic_ps_enable_work;
>        struct work_struct dynamic_ps_disable_work;
>        struct timer_list dynamic_ps_timer;
> @@ -902,6 +903,8 @@ u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
>                            enum ieee80211_band band);
>  void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
>                              u8 *ssid, size_t ssid_len);
> +void ieee80211_send_pspoll(struct ieee80211_local *local,
> +                          struct ieee80211_sub_if_data *sdata);
>
>  /* scan/BSS handling */
>  int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c7e61e2..26b3ed4 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -475,6 +475,41 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
>        ieee80211_tx_skb(sdata, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
>  }
>
> +void ieee80211_send_pspoll(struct ieee80211_local *local,
> +                          struct ieee80211_sub_if_data *sdata)
> +{
> +       struct ieee80211_if_sta *ifsta = &sdata->u.sta;
> +       struct ieee80211_pspoll *pspoll;
> +       struct sk_buff *skb;
> +       u16 fc;
> +
> +       skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*pspoll));
> +       if (!skb) {
> +               printk(KERN_DEBUG "%s: failed to allocate buffer for "
> +                      "pspoll frame\n", sdata->dev->name);
> +               return;
> +       }
> +       skb_reserve(skb, local->hw.extra_tx_headroom);
> +
> +       pspoll = (struct ieee80211_pspoll *) skb_put(skb, sizeof(*pspoll));
> +       memset(pspoll, 0, sizeof(*pspoll));
> +       fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL | IEEE80211_FCTL_PM;
> +       pspoll->frame_control = cpu_to_le16(fc);
> +       pspoll->aid = cpu_to_le16(ifsta->aid);
> +
> +       /* aid in PS-Poll has its two MSBs each set to 1 */
> +       pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
> +
> +       memcpy(pspoll->bssid, ifsta->bssid, ETH_ALEN);
> +       memcpy(pspoll->ta, sdata->dev->dev_addr, ETH_ALEN);
> +
> +       printk(KERN_DEBUG "sending ps-poll");
> +
> +       ieee80211_tx_skb(sdata, skb, 0);
> +
> +       return;
> +}
> +
>  /* MLME */
>  static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
>                                         struct ieee80211_bss *bss)
> @@ -1816,9 +1851,24 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>                directed_tim = ieee80211_check_tim(&elems, ifsta->aid);
>
>                if (directed_tim) {
> -                       local->hw.conf.flags &= ~IEEE80211_CONF_PS;
> -                       ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> -                       ieee80211_send_nullfunc(local, sdata, 0);
> +                       if (local->hw.conf.dynamic_ps_timeout > 0) {
> +                               local->hw.conf.flags &= ~IEEE80211_CONF_PS;
> +                               ieee80211_hw_config(local,
> +                                                   IEEE80211_CONF_CHANGE_PS);
> +                               ieee80211_send_nullfunc(local, sdata, 0);
> +                       } else {
> +                               local->pspolling = true;
> +
> +                               /*
> +                                * Here is assumed that the driver will be
> +                                * able to send ps-poll frame and receive a
> +                                * response even though power save mode is
> +                                * enabled, but some drivers might require
> +                                * to disable power save here. This needs
> +                                * to be investigated.
> +                                */
> +                               ieee80211_send_pspoll(local, sdata);
> +                       }
>                }
>        }
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 9fd9d21..59b0a50 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -740,6 +740,39 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
>        return result;
>  }
>
> +static ieee80211_rx_result debug_noinline
> +ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
> +{
> +       struct ieee80211_local *local;
> +       struct ieee80211_hdr *hdr;
> +       struct sk_buff *skb;
> +
> +       local = rx->local;
> +       skb = rx->skb;
> +       hdr = (struct ieee80211_hdr *) skb->data;
> +
> +       if (!local->pspolling)
> +               return RX_CONTINUE;
> +
> +       if (!ieee80211_has_fromds(hdr->frame_control))
> +               /* this is not from AP */
> +               return RX_CONTINUE;
> +
> +       if (!ieee80211_is_data(hdr->frame_control))
> +               return RX_CONTINUE;
> +
> +       if (!ieee80211_has_moredata(hdr->frame_control)) {
> +               /* AP has no more frames buffered for us */
> +               local->pspolling = false;
> +               return RX_CONTINUE;
> +       }
> +
> +       /* more data bit is set, let's request a new frame from the AP */
> +       ieee80211_send_pspoll(local, rx->sdata);
> +
> +       return RX_CONTINUE;
> +}
> +
>  static void ap_sta_ps_start(struct sta_info *sta)
>  {
>        struct ieee80211_sub_if_data *sdata = sta->sdata;
> @@ -2006,6 +2039,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
>        CALL_RXH(ieee80211_rx_h_passive_scan)
>        CALL_RXH(ieee80211_rx_h_check)
>        CALL_RXH(ieee80211_rx_h_decrypt)
> +       CALL_RXH(ieee80211_rx_h_check_more_data)
>        CALL_RXH(ieee80211_rx_h_sta_process)
>        CALL_RXH(ieee80211_rx_h_defragment)
>        CALL_RXH(ieee80211_rx_h_ps_poll)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
