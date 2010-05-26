Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowhand.arndnet.de ([88.198.19.76]:57888 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757268Ab0EZRrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:47:35 -0400
Message-ID: <4BFD5A49.4050601@arndnet.de>
Date: Wed, 26 May 2010 19:28:41 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com
Subject: Re: [PATCH]wireless:ath9k Fix ath_print in xmit.c
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 26.05.2010 19:14, schrieb Justin P. Mattock:
> ath_print in xmit.c should say "Reseting hardware"
> instead of Reaseting HAL!(since HAL is being fazed out).
> dmesg shows:
> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>
>  
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3db1917..2a0558e 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>  		int r;
>  
>  		ath_print(common, ATH_DBG_FATAL,
> -			  "Unable to stop TxDMA. Reset HAL!\n");
> +			  "Unable to stop TxDMA. Reseting hardware!\n");
>   
1.) Should'nt it read "Resetting"
2.) Why "common" ? Seems it is ath9k specific so message should read
"ath9k: Failed to stop TX DMA"
3.) While we are at it write "TX DMA" instead of "TxDMA" just to be
consistent...
>  
>  		spin_lock_bh(&sc->sc_resetlock);
>  		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
>   

Best regards,
Arnd

