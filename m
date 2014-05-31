Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49464 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaEaUGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 16:06:17 -0400
Date: Sat, 31 May 2014 23:05:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de
Subject: Re: [PATCH 1/3] rtl818x_pci: make RSSI code more readable
Message-ID: <20140531200556.GL17724@mwanda> (sfid-20140531_220620_639249_794FE6E2)
References: <1401553786-7603-1-git-send-email-andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401553786-7603-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 31, 2014 at 06:29:46PM +0200, Andrea Merello wrote:
> remove the if-else chains and use switch-case to make code more
> readable and avoiding long lines that broke in several lines
> 
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
> ---
>  drivers/net/wireless/rtl818x/rtl8180/dev.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> index 2c1c02b..c2dd5e6 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> @@ -209,7 +209,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  	struct rtl8180_priv *priv = dev->priv;
>  	struct rtl818x_rx_cmd_desc *cmd_desc;
>  	unsigned int count = 32;
> -	u8 signal, agc, sq;
> +	u8 agc, sq, signal = 1;

Shouldn't the 1 be 10?  Why did the defaults change?

regards,
dan carpenter

>  	dma_addr_t mapping;
>  
>  	while (count--) {
> @@ -266,18 +266,21 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  			rx_status.rate_idx = (flags >> 20) & 0xF;
>  			agc = (flags2 >> 17) & 0x7F;
>  
> -			if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
> +			switch (priv->chip_family) {
> +			case RTL818X_CHIP_FAMILY_RTL8185:
>  				if (rx_status.rate_idx > 3)
>  					signal = 90 - clamp_t(u8, agc, 25, 90);
>  				else
>  					signal = 95 - clamp_t(u8, agc, 30, 95);
> -			} else if (priv->chip_family ==
> -				   RTL818X_CHIP_FAMILY_RTL8180) {
> +				break;
> +			case RTL818X_CHIP_FAMILY_RTL8180:
>  				sq = flags2 & 0xff;
>  				signal = priv->rf->calc_rssi(agc, sq);
> -			} else {
> +				break;
> +			case RTL818X_CHIP_FAMILY_RTL8187SE:
>  				/* TODO: rtl8187se rssi */
>  				signal = 10;
> +				break;
>  			}
>  			rx_status.signal = signal;
>  			rx_status.freq = dev->conf.chandef.chan->center_freq;
> -- 
> 1.9.1
