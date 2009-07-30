Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:57103 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZG3SpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:45:17 -0400
Received: by ey-out-2122.google.com with SMTP id 9so439568eyd.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 11:45:17 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] rt2x00dev: cancel all work on disconnect
Date: Thu, 30 Jul 2009 20:45:15 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Michael Buesch <mb@bu3sch.de>
References: <20090729200711.3784.16212.stgit@mj.roinet.com>
In-Reply-To: <20090729200711.3784.16212.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907302045.15400.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I assume fixes the bug Michael reported on Linux-wireless yesterday?
The patch looks good, but I have some minor modification request:

On Wednesday 29 July 2009, Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 658a63b..66b303b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -888,6 +888,13 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
>  
>  	/*
> +	 * Cancel all work.
> +	 */
> +	rt2x00link_stop_tuner(rt2x00dev);

This one isn't needed. rt2x00lib_disable_radio() is doing this.

> +	cancel_work_sync(&rt2x00dev->filter_work);
> +	cancel_work_sync(&rt2x00dev->intf_work);

Could you move these 2 until after the call to rt2x00lib_disable_radio()?

> +	/*
>  	 * Disable radio.
>  	 */
>  	rt2x00lib_disable_radio(rt2x00dev);

Thanks,

Ivo
