Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:18165 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbbKZMWD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:22:03 -0500
Message-ID: <5656F95C.60107@bfs.de> (sfid-20151126_132208_869280_152C1223)
Date: Thu, 26 Nov 2015 13:21:48 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rt2x00: type bug in _rt2500usb_register_read()
References: <20151126115523.GD10556@mwanda>
In-Reply-To: <20151126115523.GD10556@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 26.11.2015 12:55, schrieb Dan Carpenter:
> This code causes a static checker bug.
> 
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:232 _rt2500usb_register_read()
> warn: passing casted pointer 'value' to 'rt2500usb_register_read()' 32 vs 16.
> 
> If the low 16 bits were initialized to zero then this code would only be
> a problem on big endian systems.  But in this case this is case the low
> 16 bits are never initialized.  This is called from a function which is
> created using a macro:
> 
> RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);
> 
> We end up copying uninitialized data to the user which is bogus and an
> information leak.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Not tested.  Perhaps we should just remove this code since it has never
> worked.
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> index b50d873..d26018f 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> @@ -229,7 +229,10 @@ static void _rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
>  				     const unsigned int offset,
>  				     u32 *value)
>  {
> -	rt2500usb_register_read(rt2x00dev, offset, (u16 *)value);
> +	u16 tmp;
> +
> +	rt2500usb_register_read(rt2x00dev, offset, &tmp);
> +	*value = tmp;
>  }
>  

perhaps, cleaning *value would be sufficient ? Avoiding the need for a tmp var.

*value = 0
rt2500usb_register_read(rt2x00dev, offset, (u16 *)value);


re,
 wh

>  static void _rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
