Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46854 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbeHXGca (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 02:32:30 -0400
Received: by mail-yw1-f66.google.com with SMTP id j131-v6so2588223ywc.13
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2018 19:59:54 -0700 (PDT)
Received: from mail-yb0-f175.google.com (mail-yb0-f175.google.com. [209.85.213.175])
        by smtp.gmail.com with ESMTPSA id m3-v6sm2090187ywe.50.2018.08.23.19.59.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Aug 2018 19:59:53 -0700 (PDT)
Received: by mail-yb0-f175.google.com with SMTP id c1-v6so2992236ybq.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2018 19:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180824011247.GA25648@embeddedor.com>
References: <20180824011247.GA25648@embeddedor.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 23 Aug 2018 19:59:51 -0700
Message-ID: <CAGXu5j+TkaLoXaGi0mc4-xZSnDdM=z=J9n-h5GOaoOTM5MgBLQ@mail.gmail.com> (sfid-20180824_050001_402682_03436A1D)
Subject: Re: [PATCH] ath10k: use struct_size() in kzalloc()
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 23, 2018 at 6:12 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>
> struct foo {
>         int stuff;
>         void *entry[];
> };
>
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
>
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
>
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
>
> This issue was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/wireless/ath/ath10k/ce.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
> index 18c709c..d0381aa 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -1416,10 +1416,8 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
>
>         nentries = roundup_pow_of_two(nentries);
>
> -       src_ring = kzalloc(sizeof(*src_ring) +
> -                          (nentries *
> -                           sizeof(*src_ring->per_transfer_context)),
> -                          GFP_KERNEL);
> +       src_ring = kzalloc(struct_size(src_ring, per_transfer_context,
> +                                      nentries), GFP_KERNEL);
>         if (src_ring == NULL)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -1476,10 +1474,8 @@ ath10k_ce_alloc_src_ring_64(struct ath10k *ar, unsigned int ce_id,
>
>         nentries = roundup_pow_of_two(nentries);
>
> -       src_ring = kzalloc(sizeof(*src_ring) +
> -                          (nentries *
> -                           sizeof(*src_ring->per_transfer_context)),
> -                          GFP_KERNEL);
> +       src_ring = kzalloc(struct_size(src_ring, per_transfer_context,
> +                                      nentries), GFP_KERNEL);
>         if (!src_ring)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -1534,10 +1530,8 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
>
>         nentries = roundup_pow_of_two(attr->dest_nentries);
>
> -       dest_ring = kzalloc(sizeof(*dest_ring) +
> -                           (nentries *
> -                            sizeof(*dest_ring->per_transfer_context)),
> -                           GFP_KERNEL);
> +       dest_ring = kzalloc(struct_size(dest_ring, per_transfer_context,
> +                                       nentries), GFP_KERNEL);
>         if (dest_ring == NULL)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -1580,10 +1574,8 @@ ath10k_ce_alloc_dest_ring_64(struct ath10k *ar, unsigned int ce_id,
>
>         nentries = roundup_pow_of_two(attr->dest_nentries);
>
> -       dest_ring = kzalloc(sizeof(*dest_ring) +
> -                           (nentries *
> -                            sizeof(*dest_ring->per_transfer_context)),
> -                           GFP_KERNEL);
> +       dest_ring = kzalloc(struct_size(dest_ring, per_transfer_context,
> +                                       nentries), GFP_KERNEL);
>         if (!dest_ring)
>                 return ERR_PTR(-ENOMEM);
>
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
