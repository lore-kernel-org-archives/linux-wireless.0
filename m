Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f176.google.com ([209.85.222.176]:45867 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab0EZSCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:02:52 -0400
Received: by pzk6 with SMTP id 6so2895413pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:02:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274896804-19441-1-git-send-email-justinmattock@gmail.com>
References: <1274896804-19441-1-git-send-email-justinmattock@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 11:02:31 -0700
Message-ID: <AANLkTilII7C41BTshkXyCmAU81LQ3fJF0ogq_BLVv6w-@mail.gmail.com>
Subject: Re: [PATCH][RESEND] ath9k: Fix ath_print in xmit for hardware reset.
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linville@tuxdriver.com, arnd@arndnet.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 11:00 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> ath_print in xmit.c should say "Reseting hardware"
> instead of Resetting HAL!(since HAL is being fazed out).
> dmesg shows:
> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>

For next time, no need for extra spaces between the SOB and the ---.
And instead of RESEND do [PATCH v2]. Please read:

http://wireless.kernel.org/en/developers/Documentation/git-guide

> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3db1917..09cb13c 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>                int r;
>
>                ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to stop TxDMA. Reset HAL!\n");
> +                         "Failed to stop TX DMA. Resetting hardware!\n");
>
>                spin_lock_bh(&sc->sc_resetlock);
>                r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);

Thanks, this is good.

  Luis
