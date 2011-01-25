Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39914 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1AYMYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 07:24:21 -0500
Received: by pzk35 with SMTP id 35so853542pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 04:24:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
Date: Tue, 25 Jan 2011 14:24:21 +0200
Message-ID: <AANLkTi=m1ySNLvgk91im-SMfxonwy_QHxBGR8di1E3Uk@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Bruno Randolf <br1@einfach.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/25 Bob Copeland <me@bobcopeland.com>:
> Review spotted a problem with the error handling in ath5k_hw_dma_stop:
> a successful return from ath5k_hw_stop_tx_dma will be treated as
> an error, so we always bail out of the loop after processing a single
> active queue.  As a result, we may not actually stop some queues during
> reset.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> These two patches fix some buglets I found when reviewing some old code.
>
>  drivers/net/wireless/ath/ath5k/dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
> index 0064be7..e828b98 100644
> --- a/drivers/net/wireless/ath/ath5k/dma.c
> +++ b/drivers/net/wireless/ath/ath5k/dma.c
> @@ -838,7 +838,7 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah)
>        for (i = 0; i < qmax; i++) {
>                err = ath5k_hw_stop_tx_dma(ah, i);
>                /* -EINVAL -> queue inactive */
> -               if (err != -EINVAL)
> +               if (err && err != -EINVAL)
>                        return err;
>        }
>
> --
> 1.7.1.1

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
