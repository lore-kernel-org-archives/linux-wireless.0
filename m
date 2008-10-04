Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47944 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168AbYJDBgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 21:36:41 -0400
Message-ID: <48E6C8A1.1060404@lwfinger.net> (sfid-20081004_033646_338645_15703650)
Date: Fri, 03 Oct 2008 19:36:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/8] b43: remove remaining b43_radio_{read|write}16 from
 main.c
References: <1223066926.6512.27.camel@brick>
In-Reply-To: <1223066926.6512.27.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Harvey Harrison wrote:
> The 16 is not necessary anymore and is defnined to read/write.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 6df9b65..cc1f4a9 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -789,7 +789,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
>  	b43_write16(dev, 0x0502, 0x0030);
>  
>  	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
> -		b43_radio_write16(dev, 0x0051, 0x0017);
> +		b43_radio_write(dev, 0x0051, 0x0017);
>  	for (i = 0x00; i < max_loop; i++) {
>  		value = b43_read16(dev, 0x050E);
>  		if (value & 0x0080)
> @@ -809,7 +809,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
>  		udelay(10);
>  	}
>  	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
> -		b43_radio_write16(dev, 0x0051, 0x0037);
> +		b43_radio_write(dev, 0x0051, 0x0037);
>  
>  	write_unlock(&wl->tx_lock);
>  	spin_unlock_irq(&wl->irq_lock);

NACK. The two extra characters are absolutely harmless, but they do
contain useful information. In addition, who knows if a future
Broadcom device starts using 32-bit read/writes.

Larry

