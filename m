Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44432 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBYHYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 02:24:51 -0500
Received: by mail-bk0-f51.google.com with SMTP id 6so98294bkj.38
        for <linux-wireless@vger.kernel.org>; Mon, 24 Feb 2014 23:24:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393312414-9404-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393312414-9404-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 25 Feb 2014 08:24:49 +0100
Message-ID: <CA+BoTQkgFVgWGJTTLOJ2tiqqaJ=0O7JvGAMDWc8JHt0rJP92UA@mail.gmail.com> (sfid-20140225_082455_070390_B7F76C31)
Subject: Re: [PATCH] ath10k: improve rx path when play with attention flags
From: Michal Kazior <michal.kazior@tieto.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2014 08:13, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> Currently when we check attention flags we do __le32_to_cpu()
> four times for each packet. This could have performance
> impact for BIG endian platforms. This patch improve this
> little bit.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c |   71 +++++-------------------------
>  1 file changed, 11 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 316433f..97e4cd5 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -810,62 +810,6 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
>         ath10k_process_rx(htt->ar, info);
>  }
>
> -static bool ath10k_htt_rx_has_decrypt_err(struct sk_buff *skb)
> -{
> -       struct htt_rx_desc *rxd;
> -       u32 flags;
> -
> -       rxd = (void *)skb->data - sizeof(*rxd);
> -       flags = __le32_to_cpu(rxd->attention.flags);
> -
> -       if (flags & RX_ATTENTION_FLAGS_DECRYPT_ERR)
> -               return true;
> -
> -       return false;
> -}
> -
> -static bool ath10k_htt_rx_has_fcs_err(struct sk_buff *skb)
> -{
> -       struct htt_rx_desc *rxd;
> -       u32 flags;
> -
> -       rxd = (void *)skb->data - sizeof(*rxd);
> -       flags = __le32_to_cpu(rxd->attention.flags);
> -
> -       if (flags & RX_ATTENTION_FLAGS_FCS_ERR)
> -               return true;
> -
> -       return false;
> -}
> -
> -static bool ath10k_htt_rx_has_mic_err(struct sk_buff *skb)
> -{
> -       struct htt_rx_desc *rxd;
> -       u32 flags;
> -
> -       rxd = (void *)skb->data - sizeof(*rxd);
> -       flags = __le32_to_cpu(rxd->attention.flags);
> -
> -       if (flags & RX_ATTENTION_FLAGS_TKIP_MIC_ERR)
> -               return true;
> -
> -       return false;
> -}
> -
> -static bool ath10k_htt_rx_is_mgmt(struct sk_buff *skb)
> -{
> -       struct htt_rx_desc *rxd;
> -       u32 flags;
> -
> -       rxd = (void *)skb->data - sizeof(*rxd);
> -       flags = __le32_to_cpu(rxd->attention.flags);
> -
> -       if (flags & RX_ATTENTION_FLAGS_MGMT_TYPE)
> -               return true;
> -
> -       return false;
> -}
> -
>  static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
>  {
>         struct htt_rx_desc *rxd;
> @@ -929,6 +873,9 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>                         struct sk_buff *msdu_head, *msdu_tail;
>                         enum htt_rx_mpdu_status status;
>                         int msdu_chaining;
> +                       struct htt_rx_desc *rxd;
> +                       u32 att_flags;
> +

No need for an empty line I suppose? I would also prefer `attention`
instead of `att_flags`, but no big deal.


>                         msdu_head = NULL;
>                         msdu_tail = NULL;
> @@ -950,7 +897,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>                                 continue;
>                         }
>
> -                       if (ath10k_htt_rx_has_decrypt_err(msdu_head)) {
> +                       rxd = (void *)msdu_head->data - sizeof(*rxd);

I think container_of(msdu_head->data, htt_tx_desc, msdu_payload) is a
better fit here :-)


> +                       att_flags = __le32_to_cpu(rxd->attention.flags);

Attention flags don't contain bitmasked values so we can skip the
conversion altogether here and do __cpu_to_le32() on the constant
values.


> +
> +

More empty lines?



Michał
