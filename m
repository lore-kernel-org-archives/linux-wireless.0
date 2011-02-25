Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58915 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab1BYMWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 07:22:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 04:22:15 -0800
Date: Fri, 25 Feb 2011 17:52:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: Fix compilation warning.
Message-ID: <20110225122229.GA6064@vasanth-laptop>
References: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com> <1298635263-4883-2-git-send-email-vnatarajan@atheros.com> <1298635263-4883-3-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1298635263-4883-3-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 05:31:03PM +0530, Vivek Natarajan wrote:
> Initialize txq to avoid this warning:
> 
> drivers/net/wireless/ath/ath9k/main.c: In function ‘ath9k_flush’:
> drivers/net/wireless/ath/ath9k/main.c:2138: warning: ‘txq’ may be used uninitialized in this function

thanks, my gcc (4.4.3)  does not complain this :).

> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 9b03b5a..238fb76 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2135,7 +2135,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
>  {
>  #define ATH_FLUSH_TIMEOUT	60 /* ms */
>  	struct ath_softc *sc = hw->priv;
> -	struct ath_txq *txq;
> +	struct ath_txq *txq = NULL;
>  	struct ath_hw *ah = sc->sc_ah;
>  	struct ath_common *common = ath9k_hw_common(ah);
>  	int i, j, npend = 0;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
