Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60316 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZJPHV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 03:21:59 -0400
From: Kalle Valo <kalle.valo@iki.fi>
To: John Willis <John.Willis@Distant-earth.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] wl1251: add support for PG11 chips.
References: <01c201ca4d9c$c2c44500$484ccf00$@Willis@Distant-earth.com>
Date: Fri, 16 Oct 2009 10:19:59 +0300
In-Reply-To: <01c201ca4d9c$c2c44500$484ccf00$@Willis@Distant-earth.com> (ext
	John Willis's message of "Thu, 15 Oct 2009 15:38:16 +0200")
Message-ID: <87vdifbyao.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Willis <John.Willis@Distant-earth.com> writes:

> From: David-John Willis <John.Willis@Distant-earth.com>
>
> This simple patch adds support for the PG11 variant of the WL1251 chip as
> used on the OpenPandora OMAP3 device.
>
> Signed-off-by: David-John Willis <John.Willis@Distant-earth.com>

Thanks for the patch. And excellent news that it's working on your
device.

Minor comment:

> --- a/drivers/net/wireless/wl12xx/wl1251_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1251_main.c
> @@ -185,6 +185,9 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
>  		break;
>  	case CHIP_ID_1251_PG10:
>  	case CHIP_ID_1251_PG11:
> +		wl1251_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG11)",
> +			     wl->chip_id);
> +		break;
>  	default:
>  		wl1251_error("unsupported chip id: 0x%x", wl->chip_id);
>  		ret = -ENODEV;

This patch also enables PG10 support, but as that hardware revision is
untested I think it's better not to enable it. I'll edit the patch a bit
regarding this and then send it to John.

-- 
Kalle Valo
