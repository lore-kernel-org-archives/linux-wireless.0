Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62346 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0EZRRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:17:02 -0400
Received: by pwi7 with SMTP id 7so295120pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:17:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:16:42 -0700
Message-ID: <AANLkTimb2XB1bW5oQ_hL0d-Iet8sqbr-26u2f-wksDYl@mail.gmail.com>
Subject: Re: [PATCH]wireless:ath9k Fix ath_print in xmit.c
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject should just be

ath9k: Fix ath_print in xmit for hardware reset

On Wed, May 26, 2010 at 10:14 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> ath_print in xmit.c should say "Reseting hardware"
> instead of Reaseting HAL!(since HAL is being fazed out).
> dmesg shows:
> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Looks good. You want to address patches To john, and cc the rest.

> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3db1917..2a0558e 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>                int r;
>
>                ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to stop TxDMA. Reset HAL!\n");
> +                         "Unable to stop TxDMA. Reseting hardware!\n");
>
>                spin_lock_bh(&sc->sc_resetlock);
>                r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
> --
> 1.6.5.GIT
>
>
