Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62050 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaD2MCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 08:02:07 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so101996wgh.7
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 05:02:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>
References: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>
Date: Tue, 29 Apr 2014 05:02:04 -0700
Message-ID: <CAJ+vNU2xBLMML6RA+4BxosYg4ZFK7==z2pLKmU38Ho1BpozuOg@mail.gmail.com> (sfid-20140429_140753_433622_1ED370D8)
Subject: Re: [PATCH 1/2] ath9k: fix possible hang on flush
From: Tim Harvey <tharvey@gateworks.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@lists.ath9k.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 21, 2014 at 4:14 PM, Tim Harvey <tharvey@gateworks.com> wrote:
> If a flush is requested, make sure to clear the descriptor once we've
> processed it.
>
> This resolves a hang that will occur if all RX descriptors are full when a
> flush is requested.
>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 6c9accd..e77a253 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1113,14 +1113,13 @@ requeue_drop_frag:
>                 }
>  requeue:
>                 list_add_tail(&bf->list, &sc->rx.rxbuf);
> -               if (flush)
> -                       continue;
>
>                 if (edma) {
>                         ath_rx_edma_buf_link(sc, qtype);
>                 } else {
>                         ath_rx_buf_relink(sc, bf);
> -                       ath9k_hw_rxena(ah);
> +                       if (!flush)
> +                               ath9k_hw_rxena(ah);
>                 }
>         } while (1);
>
> --
> 1.8.3.2
>

+cc ath9k-devel@lists.ath9k.org

Tim
