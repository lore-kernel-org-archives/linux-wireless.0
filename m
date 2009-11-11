Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46130 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759325AbZKKWAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 17:00:15 -0500
Date: Wed, 11 Nov 2009 16:47:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] at76c50x-usb: Supply additional parameters to
	at76_start_monitor scan request
Message-ID: <20091111214742.GM4392@tuxdriver.com>
References: <1257724939.21194.926.camel@rainbow>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257724939.21194.926.camel@rainbow>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 08, 2009 at 07:02:19PM -0500, Jason Andryuk wrote:
> For my Linksys WUSB11 at76c503-i3861 device, scanning fails without
> probe_delay, min_channel_time, and max_channel_time specified for the
> scan request.  These values were found by checking scan requests from
> the at76_usb driver.
> 
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> --
> Prior to this patch, the driver did not produce any scan results on my device.
> 
> 
> diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x
> index d9f2c52..4a3f4ff 100644
> --- a/drivers/net/wireless/at76c50x-usb.c
> +++ b/drivers/net/wireless/at76c50x-usb.c
> @@ -1180,6 +1180,9 @@ static int at76_start_monitor(struct at76_priv *priv)
>         scan.channel = priv->channel;
>         scan.scan_type = SCAN_TYPE_PASSIVE;
>         scan.international_scan = 0;
> +       scan.min_channel_time = cpu_to_le16(priv->scan_min_time);
> +       scan.max_channel_time = cpu_to_le16(priv->scan_max_time);
> +       scan.probe_delay = cpu_to_le16(0);
>  
>         ret = at76_set_card_command(priv->udev, CMD_SCAN, &scan, sizeof(scan));
>         if (ret >= 0)

This patch was whitespace-damaged.  I've manually fixed it, but please
adjust your mailer appropriate for any future patches...

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
