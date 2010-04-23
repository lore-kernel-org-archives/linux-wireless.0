Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:3073 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245Ab0DWPZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 11:25:21 -0400
Message-ID: <4BD1BBDE.7080607@gmail.com>
Date: Fri, 23 Apr 2010 17:25:18 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2800: use tx_power2 in rt2800_config_channel_rf3xxx
References: <201004231554.43474.helmut.schaa@googlemail.com>
In-Reply-To: <201004231554.43474.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/10 15:54, Helmut Schaa wrote:
> Get closer to what the ralink driver does by setting the rf register 13
> to tx_power2 during channel switch.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Good catch.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 
> Just found that difference between rt2x00 and the ralink driver.
> However I couldn't see any obvious improvements. So, this change
> is mostly for completeness.
> 
>  drivers/net/wireless/rt2x00/rt2800.h    |    5 +++++
>  drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index ec89372..1c59dc6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1566,6 +1566,11 @@ struct mac_iveiv_entry {
>  #define RFCSR12_TX_POWER		FIELD8(0x1f)
>  
>  /*
> + * RFCSR 13:
> + */
> +#define RFCSR13_TX_POWER		FIELD8(0x1f)
> +
> +/*
>   * RFCSR 15:
>   */
>  #define RFCSR15_TX_LO2_EN		FIELD8(0x08)
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index aa02ff6..3ee9882 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -794,6 +794,11 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>  			  TXPOWER_G_TO_DEV(info->tx_power1));
>  	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
>  
> +	rt2800_rfcsr_read(rt2x00dev, 13, &rfcsr);
> +	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
> +			  TXPOWER_G_TO_DEV(info->tx_power2));
> +	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
> +
>  	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
>  	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
>  	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);

