Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41517 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab0EZRvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:51:05 -0400
Received: by pxi18 with SMTP id 18so2637468pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:51:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274896002-10866-1-git-send-email-justinmattock@gmail.com>
References: <1274896002-10866-1-git-send-email-justinmattock@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:50:45 -0700
Message-ID: <AANLkTimrFUYIkTQ7ev-AL0V8y0Lot064h8JK_fU81Lyr@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix ath_print in xmit for harware reset.
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linville@tuxdriver.com, arnd@arndnet.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 10:46 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> ath_print in xmit.c should say "Reseting hardware"
> instead of Resetting HAL!(since HAL is being fazed out).
> dmesg shows:
> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3db1917..617db8e 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>                int r;
>
>                ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to stop TxDMA. Reset HAL!\n");
> +                         "ath9k: Failed to stop TX DMA. Resetting hardware!\n");

Nack, No need to put "ath9k:" since ath_print already prepends "ath: "

  Luis
