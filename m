Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61330 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653AbYKLVfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:35:13 -0500
Message-ID: <491B4C0E.6010807@lwfinger.net> (sfid-20081112_223519_882751_E385BB61)
Date: Wed, 12 Nov 2008 15:35:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: throughput problem/bisect with rtl8187B
References: <413196.94590.qm@web23107.mail.ird.yahoo.com> <200811121710.17957.herton@mandriva.com.br>
In-Reply-To: <200811121710.17957.herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Ok, Looks like sifs or eifs setting then expect values in another format or
> have a different meaning may be (or just cause some hw bug), it's strange,
> I suspect sifs value is the culprit. In the patch I just reverted to values vendor
> driver uses, in it difs remains the same, just eifs isn't changed for short slot
> case and kept with a default value (along with what is supposed to be ack
> timeout register), and sifs set to 0x22. Please try just the following change
> to isolate that the SIFS setting caused the throughput issue:
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index d49f2a7..c0392e4 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -924,7 +924,7 @@ static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
>  			difs = 0x32;
>  			eifs = 0x5b;
>  		}
> -		rtl818x_iowrite8(priv, &priv->map->SIFS, 0xa);
> +		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
>  		rtl818x_iowrite8(priv, &priv->map->SLOT, slot_time);
>  		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);

This patch gives me the best performance yet. I get about 1.0 MB/s download and
580 KB/s upload with a 25 MB file using sftp.

Larry
