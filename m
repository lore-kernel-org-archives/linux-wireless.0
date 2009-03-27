Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:34336 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZC0Op1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:45:27 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] p54spi: compensate firmware alignment bug in p54spi_rx
Date: Fri, 27 Mar 2009 15:45:02 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1238129453-7478-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1238129453-7478-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903271545.02837.chunkeey@web.de> (sfid-20090327_154530_792135_F9536D0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 March 2009 05:50:53 Max Filippov wrote:
> Firmware may insert up to 4 padding bytes after the lmac header,
> but it does not amend the size of SPI data transfer.
> Such packets has correct data size in header, thus referencing
> past the end of allocated skb. Put extra 4 bytes to the end of the
> received skb to compensate for this case.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Acked-by: Christian Lamparter <chunkeey@web.de>

> ---
>  drivers/net/wireless/p54/p54spi.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
> index 5e8011c..35ea0dd 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -381,7 +381,12 @@ static int p54spi_rx(struct p54s_priv *priv)
>  		return 0;
>  	}
>  
> -	skb = dev_alloc_skb(len);
> +
> +	/* Firmware may insert up to 4 padding bytes after the lmac header,
> +	 * but it does not amend the size of SPI data transfer.
> +	 * Such packets has correct data size in header, thus referencing
> +	 * past the end of allocated skb. Reserve extra 4 bytes for this case */
> +	skb = dev_alloc_skb(len + 4);
>  	if (!skb) {
>  		dev_err(&priv->spi->dev, "could not alloc skb");
>  		return 0;
> @@ -389,6 +394,9 @@ static int p54spi_rx(struct p54s_priv *priv)
>  
>  	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, skb_put(skb, len), len);
>  	p54spi_sleep(priv);
> +	/* Put additional bytes to compensate for the possible
> +	 * alignment-caused truncation */
> +	skb_put(skb, 4);
>  
>  	if (p54_rx(priv->hw, skb) == 0)
>  		dev_kfree_skb(skb);


