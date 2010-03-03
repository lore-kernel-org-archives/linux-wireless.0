Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0CCAr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 19:47:26 -0500
Date: Tue, 2 Mar 2010 19:47:23 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath9k: Fix HW deinit
Message-ID: <20100303004723.GI8069@bombadil.infradead.org>
References: <19336.46721.589379.479488@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19336.46721.589379.479488@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 27, 2010 at 11:36:57AM +0530, Sujith wrote:
> Also, free ath_hw instance properly.
> ath9k_hw_deinit() shouldn't do it.
> 
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 -
>  drivers/net/wireless/ath/ath9k/hw.c           |    4 +---
>  drivers/net/wireless/ath/ath9k/init.c         |    3 +++
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index 5378c6e..67a9dd2 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -491,7 +491,6 @@ err_queues:
>  err_debug:
>  	ath9k_hw_deinit(ah);
>  err_hw:
> -
>  	kfree(ah);
>  	priv->ah = NULL;
>  

This is only doing white space changes and I'd like to see this in for
2.6.34-rc2 so better just drop this unneeded hunk.

  Luis
