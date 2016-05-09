Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35654 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbcEIM2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 08:28:55 -0400
Received: by mail-wm0-f43.google.com with SMTP id e201so135104906wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 05:28:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462446039-1070-2-git-send-email-michal.kazior@tieto.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 9 May 2016 14:28:53 +0200
Message-ID: <CA+BoTQmdk2Et5Ca02HFj76L21Yn4NOKPFD0V_BJ4ZyhxBVPewA@mail.gmail.com> (sfid-20160509_142858_752409_6B23F9C0)
Subject: Re: [PATCHv4 1/5] mac80211: skip netdev queue control with software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 May 2016 at 13:00, Michal Kazior <michal.kazior@tieto.com> wrote:
[...]
> -static void ieee80211_drv_tx(struct ieee80211_local *local,
> -                            struct ieee80211_vif *vif,
> -                            struct ieee80211_sta *pubsta,
> -                            struct sk_buff *skb)
> +static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
> +                                         struct ieee80211_vif *vif,
> +                                         struct ieee80211_sta *pubsta,
> +                                         struct sk_buff *skb)
>  {
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> -       struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>         struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> -       struct ieee80211_tx_control control = {
> -               .sta = pubsta,
> -       };
> -       struct ieee80211_txq *txq = NULL;
> -       struct txq_info *txqi;
> -       u8 ac;
>
>         if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
>             (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
> -               goto tx_normal;
> +               return NULL;
>
>         if (!ieee80211_is_data(hdr->frame_control))
> -               goto tx_normal;
> +               return NULL;
>
>         if (pubsta) {
>                 u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
>
> -               txq = pubsta->txq[tid];
> +               return to_txq_info(pubsta->txq[tid]);
>         } else if (vif) {
> -               txq = vif->txq;
> +               return to_txq_info(vif->txq);
>         }

I just noticed this crashes on non-wake_tx_queue drivers. I'll re-spin
a v5 with this fixed later.


Michał
