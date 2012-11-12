Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57208 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2KLTA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:00:57 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so4909455lbo.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:00:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352746052-1828-2-git-send-email-thomas@cozybit.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com> <1352746052-1828-2-git-send-email-thomas@cozybit.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 12 Nov 2012 20:00:36 +0100
Message-ID: <CAB=NE6X-LvntZ+fOV2b1AGmpQxEqyJNEu-wsc1wP7zvb8+vhFA@mail.gmail.com> (sfid-20121112_200101_323550_3D9F5066)
Subject: Re: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
To: Thomas Pedersen <thomas@cozybit.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 7:47 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
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

Thanks but can you clarify the implications of this change within the
commit log ? Was something not working, if not, why exactly is this
change important?

  Luis
