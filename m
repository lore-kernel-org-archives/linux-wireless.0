Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B009BC282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 20:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72DA7218A6
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 20:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ASj/LcuZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfAXUJF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:09:05 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36670 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729788AbfAXT2v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 14:28:51 -0500
Received: by mail-lf1-f66.google.com with SMTP id a16so5187688lfg.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 11:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=48GYHYZ6qiCwtxZH0GpkAQz9fDNUaOZ72ZNuvHYs+EY=;
        b=ASj/LcuZfmzXmqFGCWmhtf5SzlH6Hi4rSzE+MYCYL5dTqXHRnWF6FBIkatRG6LXf70
         SLYGlKB0YvTrCXNXLy3MJXfu4qI49r5+J5ANIKvtNFcCYwTqKkcJQlsXP9w3HREorwu2
         kcC7kVsFHUQqysuYF05MME7PMtnKm9GdpeAW42nz0a1SB9OqvCQrAF9onUaSP/Q8Lyre
         rwt7DSn1OOnjbE1FAu4CbSOs32+Cpea/fUqMTk1rPu3wInR9id96aypAgafEmjnUqQ0F
         r7fyyao0ZUSrf8ddpCgale21dMoWytu1KtOAqxwAumS3rncNwT9XSXVT86T00rziglEC
         acQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=48GYHYZ6qiCwtxZH0GpkAQz9fDNUaOZ72ZNuvHYs+EY=;
        b=AsEr4EyHpPItMv1pbIlG+KmPFeaB2cKYJsjjHdhRlmzGVPWu5jhTZLUDV53x51r52d
         Gt0AtRKkbb7oCZZHOO0xUkqZPiFRtlm6qU/sjui0L8g9BdtAPUal4BC2JI3Xlx1/WIYW
         woTbj9b24MUyM0kWTd6B/6Fxz1cPIy7Csl3WYfj8yKWbVW9Zzd8FusUy7HmiSn6pVhb7
         zmBtJBIfZlLgH4X/+VjeFqorrnVsG5rwkzVve9EOSsqxpM6oWaLHciiVkEvuizsv5mPj
         DT+jjwvm1urmuCDP9PpEFVhpn7i3boB+UqK/yOVJKXN5dauJ5ZafJGTE90cI7YgbuT7C
         ZFuw==
X-Gm-Message-State: AJcUukfk+UpiW5PTRd34z1bfBF9hIs+roWM+H8TvRS45eTU2MUmMI4+D
        +56xaewu/oOnXPvAoim6xQRvffnjpFoHJfgDmgTX8g==
X-Google-Smtp-Source: ALg8bN4vh2hI3VXPT0zfx5kelJYnxUocFkbqyNdhT7Yj1lPeZERmLO+qRNWF9OUC57LLvQy36Oy8tsAXzBZvyJWk2Lc=
X-Received: by 2002:a19:ced3:: with SMTP id e202mr6599279lfg.13.1548358128578;
 Thu, 24 Jan 2019 11:28:48 -0800 (PST)
MIME-Version: 1.0
References: <20190122142019.21417-1-toke@redhat.com> <20190122142019.21417-5-toke@redhat.com>
In-Reply-To: <20190122142019.21417-5-toke@redhat.com>
From:   Kan Yan <kyan@google.com>
Date:   Thu, 24 Jan 2019 11:28:37 -0800
Message-ID: <CA+iem5vnADN5YSvsts8sBO=_4yNE62E3roySHz5hU6OqNke-6A@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] ath10k: reporting estimated tx airtime for fairness
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Toke,

This patch looks good to me. Great job on getting the airtime fairness
scheduling framework done!


On Tue, Jan 22, 2019 at 6:21 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Kan Yan <kyan@google.com>
>
> Transmit airtime will be estimated from last tx rate used.
> Firmware report tx rate by peer stats. Airtime is computed
> on tx path and the same will be reported to mac80211 upon
> tx completion.
>
> This change is based on Kan's orginal commit in Chromium tree
> ("CHROMIUM: ath10k: Implementing airtime fairness based TX scheduler")
> ref: https://chromium-review.googlesource.com/588190
>
> Tested on QCA4019 with firmware version 10.4-3.2.1.1-00015
> Tested on QCA9984 with firmware version 10.4-3.9.0.1-00005
>
> Signed-off-by: Kan Yan <kyan@google.com>
> [rmanohar@codeaurora.org: ported only the airtime computation]
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> [toke@redhat.com: Rebase to mac80211-next, add test note]
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>
> Rajkumar / Kan: Please check that I didn't mess anything up while
> rebasing this onto the current mac80211-next branch!
>
>  drivers/net/wireless/ath/ath10k/core.h   |  2 +
>  drivers/net/wireless/ath/ath10k/htt_rx.c |  1 +
>  drivers/net/wireless/ath/ath10k/mac.c    | 57 ++++++++++++++++++++++--
>  drivers/net/wireless/ath/ath10k/txrx.c   |  4 ++
>  4 files changed, 61 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index 28cecf7375f8..4528a6e47b8d 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -126,6 +126,7 @@ struct ath10k_skb_cb {
>         u8 flags;
>         u8 eid;
>         u16 msdu_id;
> +       u16 airtime_est;
>         struct ieee80211_vif *vif;
>         struct ieee80211_txq *txq;
>  } __packed;
> @@ -498,6 +499,7 @@ struct ath10k_sta {
>         u16 peer_id;
>         struct rate_info txrate;
>         struct ieee80211_tx_info tx_info;
> +       u32 last_tx_bitrate;
>
>         struct work_struct update_wk;
>         u64 rx_duration;
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wirel=
ess/ath/ath10k/htt_rx.c
> index dc9895f2eb9d..6a93b57900ae 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -3078,6 +3078,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
>
>         arsta->txrate.nss =3D txrate.nss;
>         arsta->txrate.bw =3D ath10k_bw_to_mac80211_bw(txrate.bw);
> +       arsta->last_tx_bitrate =3D cfg80211_calculate_bitrate(&arsta->txr=
ate);
>         if (sgi)
>                 arsta->txrate.flags |=3D RATE_INFO_FLAGS_SHORT_GI;
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index cf7fdf72e990..b13dcb4533cb 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3544,7 +3544,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10=
k *ar,
>  static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
>                                     struct ieee80211_vif *vif,
>                                     struct ieee80211_txq *txq,
> -                                   struct sk_buff *skb)
> +                                   struct sk_buff *skb, u16 airtime)
>  {
>         struct ieee80211_hdr *hdr =3D (void *)skb->data;
>         struct ath10k_skb_cb *cb =3D ATH10K_SKB_CB(skb);
> @@ -3561,6 +3561,7 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *=
ar,
>
>         cb->vif =3D vif;
>         cb->txq =3D txq;
> +       cb->airtime_est =3D airtime;
>  }
>
>  bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
> @@ -3948,6 +3949,49 @@ static bool ath10k_mac_tx_can_push(struct ieee8021=
1_hw *hw,
>         return false;
>  }
>
> +/* Return estimated airtime in microsecond, which is calculated using la=
st
> + * reported TX rate. This is just a rough estimation because host driver=
 has no
> + * knowledge of the actual transmit rate, retries or aggregation. If act=
ual
> + * airtime can be reported by firmware, then delta between estimated and=
 actual
> + * airtime can be adjusted from deficit.
> + */
> +#define IEEE80211_ATF_OVERHEAD         100     /* IFS + some slot time *=
/
> +#define IEEE80211_ATF_OVERHEAD_IFS     16      /* IFS only */
> +static u16 ath10k_mac_update_airtime(struct ath10k *ar,
> +                                    struct ieee80211_txq *txq,
> +                                    struct sk_buff *skb)
> +{
> +       struct ath10k_sta *arsta;
> +       u32 pktlen;
> +       u16 airtime =3D 0;
> +
> +       if (!txq || !txq->sta)
> +               return airtime;
> +
> +       spin_lock_bh(&ar->data_lock);
> +       arsta =3D (struct ath10k_sta *)txq->sta->drv_priv;
> +
> +       pktlen =3D skb->len + 38; /* Assume MAC header 30, SNAP 8 for mos=
t case */
> +       if (arsta->last_tx_bitrate) {
> +               /* airtime in us, last_tx_bitrate in 100kbps */
> +               airtime =3D (pktlen * 8 * (1000 / 100))
> +                               / arsta->last_tx_bitrate;
> +               /* overhead for media access time and IFS */
> +               airtime +=3D IEEE80211_ATF_OVERHEAD_IFS;
> +       } else {
> +               /* This is mostly for throttle excessive BC/MC frames, an=
d the
> +                * airtime/rate doesn't need be exact. Airtime of BC/MC f=
rames
> +                * in 2G get some discount, which helps prevent very low =
rate
> +                * frames from being blocked for too long.
> +                */
> +               airtime =3D (pktlen * 8 * (1000 / 100)) / 60; /* 6M */
> +               airtime +=3D IEEE80211_ATF_OVERHEAD;
> +       }
> +       spin_unlock_bh(&ar->data_lock);
> +
> +       return airtime;
> +}
> +
>  int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
>                            struct ieee80211_txq *txq)
>  {
> @@ -3963,6 +4007,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
>         size_t skb_len;
>         bool is_mgmt, is_presp;
>         int ret;
> +       u16 airtime;
>
>         spin_lock_bh(&ar->htt.tx_lock);
>         ret =3D ath10k_htt_tx_inc_pending(htt);
> @@ -3980,7 +4025,8 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
>                 return -ENOENT;
>         }
>
> -       ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
> +       airtime =3D ath10k_mac_update_airtime(ar, txq, skb);
> +       ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
>
>         skb_len =3D skb->len;
>         txmode =3D ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
> @@ -4247,8 +4293,10 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *=
hw,
>         bool is_mgmt;
>         bool is_presp;
>         int ret;
> +       u16 airtime;
>
> -       ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
> +       airtime =3D ath10k_mac_update_airtime(ar, txq, skb);
> +       ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
>
>         txmode =3D ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
>         txpath =3D ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
> @@ -8603,6 +8651,9 @@ int ath10k_mac_register(struct ath10k *ar)
>                 wiphy_ext_feature_set(ar->hw->wiphy,
>                                       NL80211_EXT_FEATURE_ACK_SIGNAL_SUPP=
ORT);
>
> +       if (ath10k_peer_stats_enabled(ar))
> +               wiphy_ext_feature_set(ar->hw->wiphy,
> +                                     NL80211_EXT_FEATURE_AIRTIME_FAIRNES=
S);
>         /*
>          * on LL hardware queues are managed entirely by the FW
>          * so we only advertise to mac we can do the queues thing
> diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireles=
s/ath/ath10k/txrx.c
> index 23606b6972d0..8e7c416cd330 100644
> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -95,6 +95,10 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
>                 wake_up(&htt->empty_tx_wq);
>         spin_unlock_bh(&htt->tx_lock);
>
> +       if (txq && txq->sta)
> +               ieee80211_sta_register_airtime(txq->sta, txq->tid,
> +                                              skb_cb->airtime_est, 0);
> +
>         if (ar->dev_type !=3D ATH10K_DEV_TYPE_HL)
>                 dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DE=
VICE);
>
> --
> 2.20.1
>
