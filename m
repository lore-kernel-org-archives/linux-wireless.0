Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2520 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab0EFQ7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 12:59:13 -0400
Message-ID: <4BE2F55F.8010109@gmail.com>
Date: Thu, 06 May 2010 18:59:11 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/3] rt2x00: rt2800: don't overwrite SIFS values on erp
 changes
References: <201005061229.44923.helmut.schaa@googlemail.com>
In-Reply-To: <201005061229.44923.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/10 12:29, Helmut Schaa wrote:
> The SIFS value is a constant and doesn't need to be updated on erp changes.
> Furthermore the code used 10us for both, the OFDM SIFS and CCK SIFS time
> which broke CTS protected 11g connections (see patch "rt2x00: rt2800: update
> initial SIFS values" for details).
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index f786068..858455f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -640,8 +640,6 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp)
>  	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
>  
>  	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
> -	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, erp->sifs);
> -	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, erp->sifs);
>  	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
>  	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
>  

