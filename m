Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0BVIfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 03:35:53 -0500
Subject: Re: [PATCH 15/22] wl1271: Aggregate RX acknowledgements to FW
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1266820722-20202-16-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1266820722-20202-16-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 09:35:47 +0100
Message-ID: <1266827747.5154.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-22 at 08:38 +0200, Juuso Oikarinen wrote:

> 		wl->rx_counter++;
>  		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
> -		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
>  	}
> +
> +	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
>  }

What if the counter overflows and you got the & to change it?

johannes

