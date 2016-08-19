Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37647 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbcHSG7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 02:59:19 -0400
Received: by mail-wm0-f42.google.com with SMTP id i5so26609865wmg.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Aug 2016 23:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 19 Aug 2016 08:59:17 +0200
Message-ID: <CA+BoTQn0d1bEB662r-Yivmdk_21LhjCQjJP_GoPaj-WT2wA=1g@mail.gmail.com> (sfid-20160819_085923_087416_FB1C954D)
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2016 at 03:26,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> I was seeing kernel crashes due to accessing freed memory
> while debugging a 9984 firmware that was crashing often.
>
> This patch fixes the crashes.  I am not certain if there
> is a better way or not.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 5659ef1..916119c 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4172,8 +4172,10 @@ static void ath10k_mac_txq_init(struct ieee80211_t=
xq *txq)
>  static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq=
 *txq)
>  {
>         struct ath10k_txq *artxq =3D (void *)txq->drv_priv;
> +       struct ath10k_txq *tmp, *walker;
>         struct ath10k_skb_cb *cb;
>         struct sk_buff *msdu;
> +       struct ieee80211_txq *txq_tmp;
>         int msdu_id;
>
>         if (!txq)
> @@ -4182,6 +4184,14 @@ static void ath10k_mac_txq_unref(struct ath10k *ar=
, struct ieee80211_txq *txq)
>         spin_lock_bh(&ar->txqs_lock);
>         if (!list_empty(&artxq->list))
>                 list_del_init(&artxq->list);
> +
> +       /* Remove from ar->txqs in case it still exists there. */
> +       list_for_each_entry_safe(walker, tmp, &ar->txqs, list) {
> +               txq_tmp =3D container_of((void *)walker, struct ieee80211=
_txq,
> +                                      drv_priv);
> +               if (txq_tmp =3D=3D txq)
> +                       list_del(&walker->list);
> +       }

How could this even happen? All artxq->list accesses (add/del) are
protected by txqs_lock so this shouldn't happen, no?

Do you perhaps have the logic around txqs reworked in your tree?


Micha=C5=82
