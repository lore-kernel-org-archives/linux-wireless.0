Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2KLTSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:18:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so4576112pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:18:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352746052-1828-2-git-send-email-thomas@cozybit.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
	<1352746052-1828-2-git-send-email-thomas@cozybit.com>
Date: Mon, 12 Nov 2012 11:18:40 -0800
Message-ID: <CAJ-VmokQ19oSgw6UB616n-7r2YZ7Udmtoh-20MPBYDfx3VPo+A@mail.gmail.com> (sfid-20121112_201844_187607_2370BC78)
Subject: Re: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is that true for aggregate RX too? I didn't think the FIFO was big
enough to receive the whole aggregate, so I wonder what timestamp
aggregates sub-frames are receiving.



adrian

On 12 November 2012 10:47, Thomas Pedersen <thomas@cozybit.com> wrote:
> Tested with AR9280.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index a04028b..d4df98a 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -976,7 +976,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>         rx_status->freq = hw->conf.channel->center_freq;
>         rx_status->signal = ah->noise + rx_stats->rs_rssi;
>         rx_status->antenna = rx_stats->rs_antenna;
> -       rx_status->flag |= RX_FLAG_MACTIME_MPDU;
> +       rx_status->flag |= RX_FLAG_MACTIME_END;
>         if (rx_stats->rs_moreaggr)
>                 rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
