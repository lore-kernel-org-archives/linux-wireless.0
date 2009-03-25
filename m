Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:44395 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZCYKwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 06:52:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 1/2] p54spi: mask value read from SPI_ADRS_DMA_WRITE_CTRL in p54spi_wait_bit
Date: Wed, 25 Mar 2009 11:55:55 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903251155.55608.chunkeey@web.de> (sfid-20090325_115227_201310_D45A14DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 March 2009 06:30:15 Max Filippov wrote:
>  Mask value read from SPI_ADRS_DMA_WRITE_CTRL in p54spi_wait_bit.
>  Without this, 'fw_upload not allowed to DMA write' is observed at both N800 and N810.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>

Acked-by: Christian Lamparter <chunkeey@web.de>
> ---
>  drivers/net/wireless/p54/p54spi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
> index 2b222aa..d13268f 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -171,7 +171,7 @@ static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
>  
>  	for (i = 0; i < 2000; i++) {
>  		p54spi_spi_read(priv, reg, &buffer, sizeof(buffer));
> -		if (buffer == bits)
> +		if ((buffer & bits) == bits)
>  			return 1;
>  
>  		msleep(1);
