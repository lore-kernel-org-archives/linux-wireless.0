Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:49531 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbZKESlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:31 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 03/41] rt2800usb: fix rt2800usb_rfcsr_read()
Date: Thu, 5 Nov 2009 19:41:28 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173217.28463.23610.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173217.28463.23610.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911051941.28657.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: fix rt2800usb_rfcsr_read()
> 
> The driver should write the read request into RF_CSR_CFG register
> and not BBP_CSR_CFG one in rt2800usb_rfcsr_read().
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -167,7 +167,7 @@ static void rt2800usb_rfcsr_read(struct 
>  		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
>  		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
>  
> -		rt2x00usb_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
> +		rt2x00usb_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
>  
>  		WAIT_FOR_RFCSR(rt2x00dev, &reg);
>  	}
> 


