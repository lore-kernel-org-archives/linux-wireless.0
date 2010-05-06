Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:4149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0EFKvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 06:51:22 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2155331fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 03:51:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/3] rt2x00: rt2800: don't overwrite SIFS values on erp changes
Date: Thu, 6 May 2010 12:51:09 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201005061229.44923.helmut.schaa@googlemail.com>
In-Reply-To: <201005061229.44923.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005061251.09142.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

JFI, with this and the previous patch I can reliable transmit and receive
data at 11b and 11g rates with only sporadic retries. Before that I had a
huge amount of retries while transmitting with 11g rates (and enabled CTS
protection).

Nevertheless I don't get good transfer speeds. I didn't measure exactly but
just with scp. And I got ~600-700 KByte/s for TX and 400-500KByte/s for RX.
This is still quite low.

Helmut

Am Donnerstag 06 Mai 2010 schrieb Helmut Schaa:
> The SIFS value is a constant and doesn't need to be updated on erp changes.
> Furthermore the code used 10us for both, the OFDM SIFS and CCK SIFS time
> which broke CTS protected 11g connections (see patch "rt2x00: rt2800: update
> initial SIFS values" for details).
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
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
> 

