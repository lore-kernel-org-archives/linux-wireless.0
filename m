Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34619 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdEJQoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 12:44:25 -0400
Received: by mail-wr0-f195.google.com with SMTP id 6so162456wrb.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 May 2017 09:44:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170510162546.15439-1-adrian@freebsd.org>
References: <20170510162546.15439-1-adrian@freebsd.org>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 10 May 2017 09:44:23 -0700
Message-ID: <CALLGbRL8NQi03U60AwEtOq-W0mFOn1uDmc_TXWRJofPqcP6VXg@mail.gmail.com> (sfid-20170510_184429_300873_6513E38A)
Subject: Re: [PATCH] ath10k: add configurable debugging.
To: Adrian Chadd <adrian@freebsd.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On Wed, May 10, 2017 at 9:25 AM, Adrian Chadd <adrian@freebsd.org> wrote:

> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index 257d10985c6e..7bd461927029 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -200,27 +200,43 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar,
>  #endif /* CONFIG_MAC80211_DEBUGFS */
>
>  #ifdef CONFIG_ATH10K_DEBUG
> -__printf(3, 4) void ath10k_dbg(struct ath10k *ar,
> +static inline int
> +_ath10k_do_dbg(struct ath10k *ar, enum ath10k_debug_mask mask)
> +{
> +       if (ar->trace_debug_mask & mask)
> +               return (1);
> +       if (ar->debug_mask & mask)
> +               return (1);
> +       return (0);
> +}
> +
> +void _ath10k_dbg(struct ath10k *ar,
>                                enum ath10k_debug_mask mask,
>                                const char *fmt, ...);
> -void ath10k_dbg_dump(struct ath10k *ar,
> +
> +void _ath10k_dbg_dump(struct ath10k *ar,
>                      enum ath10k_debug_mask mask,
>                      const char *msg, const char *prefix,
>                      const void *buf, size_t len);
> +
> +#define        ath10k_dbg(ar, mask, ...)                                       \
> +       do {                                                            \
> +               if (_ath10k_do_dbg(ar, mask)) {                         \
> +                       _ath10k_dbg((ar), (mask), __VA_ARGS__);         \
> +               };                                                      \
> +       } while (0)
> +

Looks to me you dropped the "__printf(3, 4)" safety check. Was that intentional?

Thanks,
- Steve
