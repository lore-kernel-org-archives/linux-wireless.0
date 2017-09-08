Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753414AbdIHB1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 21:27:12 -0400
Date: Fri, 8 Sep 2017 03:27:06 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Don't printk raw binary if serial number is
 not burned in.
Message-ID: <20170908032706.1fa59da9@elisabeth> (sfid-20170908_032800_000443_A52861EE)
In-Reply-To: <20170907235103.5359-1-kilobyte@angband.pl>
References: <20170907235103.5359-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri,  8 Sep 2017 01:51:03 +0200
Adam Borowski <kilobyte@angband.pl> wrote:

> I assume that a blank efuse comes with all ones, thus I did not bother
> recognizing other possible junk values.  This matches 100% of dongles
> I've seen (a single Gembird 8192eu).
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> index 80fee699f58a..bdc37e7272ca 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> @@ -614,7 +614,11 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
>  
>  	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
>  	dev_info(&priv->udev->dev, "Product: %.11s\n", efuse->device_name);
> -	dev_info(&priv->udev->dev, "Serial: %.11s\n", efuse->serial);
> +	if (strncmp(efuse->serial,
> +		    "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff", 11))

You might want to use memchr_inv():

	if (memchr_inv(efuse->serial, 0xff, 11))
		dev_info(&priv->udev->dev, "Serial: %.11s\n", efuse->serial);
	...

Mostly cosmetic though.

--
Stefano
