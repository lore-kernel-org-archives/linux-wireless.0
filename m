Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40461 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0DMQzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 12:55:22 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: register platform_device to pass board data
References: <1271110918-18599-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 13 Apr 2010 19:55:19 +0300
In-Reply-To: <1271110918-18599-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 13 Apr 2010 01\:21\:58 +0300")
Message-ID: <87k4sbnvgo.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> wl1251 is embedded chip that can be connected using SDIO bus, and is not
> an actual SDIO card. For this reason there is a need to pass some board
> specific data, like 'EEPROM is attached' flag or power control callback.
> However there is no way to pass this data through SDIO subsystem, so
> this patch registers dummy platform_device to allow that.

Thanks a lot, this is really needed. Few comments though:

> +struct wl12xx_platform_data *wl12xx_board_data;

Shouldn't this be static? Also I assume that there is no way to
allocate this dynamically, am I correct?

> @@ -208,6 +240,10 @@ static int __init wl1251_sdio_init(void)
>  {
>  	int err;
>  
> +	err = platform_driver_register(&wl1251_platform_driver);
> +	if (err)
> +		wl1251_error("failed to register platform driver: %d", err);

You should exit the function here.

Can you fix the above and resend, please?

-- 
Kalle Valo
