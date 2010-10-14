Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0JNPzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 11:55:43 -0400
Subject: Re: [PATCH] libertas: Fix sd8686 firmware reload
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org, pgf@laptop.org, steve@cozybit.com
In-Reply-To: <20101013191402.7C6ED9D401B@zog.reactivated.net>
References: <20101013191402.7C6ED9D401B@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 10:58:56 -0500
Message-ID: <1287071936.7921.35.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 20:14 +0100, Daniel Drake wrote:
> From: Paul Fox <pgf@laptop.org>
> 
> For the SD8686, we cannot rely on the scratch register to read the firmware
> load status, because the same register is used for storing RX packet length.
> Broaden the check to account for this.
> 
> The module can now be unloaded/reloaded successfully.
> 
> Based on the implementation from libertas_tf.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |   32 ++++++++++++++++++++++++++++--
>  1 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 87b6349..d2e5193 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -704,28 +704,54 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
>  
>  	lbs_deb_enter(LBS_DEB_SDIO);
>  
> +	/*
> +	 * Disable interrupts
> +	 */
> +	sdio_claim_host(card->func);
> +	sdio_writeb(card->func, 0x00, IF_SDIO_H_INT_MASK, &ret);
> +	sdio_release_host(card->func);
> +
>  	sdio_claim_host(card->func);
>  	scratch = if_sdio_read_scratch(card, &ret);
>  	sdio_release_host(card->func);
>  
> +	lbs_deb_sdio("firmware status = %#x\n", scratch);
> +	lbs_deb_sdio("scratch ret = %d\n", ret);
> +
>  	if (ret)
>  		goto out;
>  
> -	lbs_deb_sdio("firmware status = %#x\n", scratch);
>  
> +	/*
> +	 * The manual clearly describes that FEDC is the right code to use
> +	 * to detect firmware presence, but for SD8686 it is not that simple.
> +	 * Scratch is also used to store the RX packet length, so we lose
> +	 * the FEDC value early on. So we use a non-zero check in order
> +	 * to validate firmware presence.
> +	 * Additionally, the SD8686 in the Gumstix always has the high scratch
> +	 * bit set, even when the firmware is not loaded. So we have to
> +	 * exclude that from the test.
> +	 */
>  	if (scratch == IF_SDIO_FIRMWARE_OK) {
>  		lbs_deb_sdio("firmware already loaded\n");
>  		goto success;
> +	} else if ((card->model == IF_SDIO_MODEL_8686) && (scratch & 0x7fff)) {
> +		lbs_deb_sdio("firmware may be running\n");
> +		goto success;
>  	}
>  
>  	ret = if_sdio_prog_helper(card);
>  	if (ret)
>  		goto out;
>  
> +	lbs_deb_sdio("Helper firmware loaded\n");
> +
>  	ret = if_sdio_prog_real(card);
>  	if (ret)
>  		goto out;
>  
> +	lbs_deb_sdio("Firmware loaded\n");
> +
>  success:
>  	sdio_claim_host(card->func);
>  	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
> @@ -1083,8 +1109,6 @@ static int if_sdio_probe(struct sdio_func *func,
>  	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
>  	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
>  
> -	priv->fw_ready = 1;
> -
>  	sdio_claim_host(func);
>  
>  	/*
> @@ -1105,6 +1129,8 @@ static int if_sdio_probe(struct sdio_func *func,
>  	if (ret)
>  		goto reclaim;
>  
> +	priv->fw_ready = 1;
> +
>  	/*
>  	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
>  	 */


