Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51561 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZKHN4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:56:16 -0500
Received: by ewy3 with SMTP id 3so2378830ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:56:21 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 9/9] rt2800usb: add eFuse EEPROM support
Date: Sun, 8 Nov 2009 14:56:20 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133955.23584.79455.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133955.23584.79455.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081456.20275.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add eFuse EEPROM support
> 
> It is needed for at least RT3070 chip.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -667,7 +667,11 @@ static void rt2800usb_fill_rxdone(struct
>   */
>  static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
> -	rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom, EEPROM_SIZE);
> +	if (rt2800_efuse_detect(rt2x00dev))
> +		rt2800_read_eeprom_efuse(rt2x00dev);
> +	else
> +		rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
> +				      EEPROM_SIZE);
>  
>  	return rt2800_validate_eeprom(rt2x00dev);
>  }
> 


