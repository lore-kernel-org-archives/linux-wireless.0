Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:38847 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab0EDSJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 14:09:54 -0400
Received: by pzk16 with SMTP id 16so2041996pzk.22
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 11:09:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BDFD3C1.4000209@openwrt.org>
References: <4BDFD3C1.4000209@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 4 May 2010 11:09:32 -0700
Message-ID: <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix another source of corrupt frames
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 12:58 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Atheros hardware supports receiving frames that span multiple
> descriptors and buffers. In this case, the rx status of every
> descriptor except for the last one is invalid and may contain random
> data. Because the driver does not support this, it needs to drop such
> frames.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> --- a/drivers/net/wireless/ath/ath9k/common.c
> +++ b/drivers/net/wireless/ath/ath9k/common.c
> @@ -57,13 +57,19 @@ static bool ath9k_rx_accept(struct ath_c
>         * rs_more indicates chained descriptors which can be used
>         * to link buffers together for a sort of scatter-gather
>         * operation.
> -        *
> +        * reject the frame, we don't support scatter-gather yet and
> +        * the frame is probably corrupt anyway
> +        */
> +       if (rx_stats->rs_more)
> +               return false;

Actually this is required by ath9k_htc, it does process these, but
ath9k doesn't so this could be done within ath9k itself.

  Luis
