Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:64379 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424006AbcFMOYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 10:24:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] staging: wilc1000: Replace semaphore cfg_event with completion
Date: Mon, 13 Jun 2016 15:25:03 +0200
Message-ID: <6370742.CzW4YYN43W@wuerfel> (sfid-20160613_162452_560393_10086132)
In-Reply-To: <1465814259-3009-4-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> <1465814259-3009-4-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 13, 2016 4:07:35 PM CEST Binoy Jayan wrote:
> The semaphore 'cfg_event' is used as completion, so convert
> it to a struct completion type.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>

The change looks good, but


>                         netdev_dbg(vif->ndev, "Set Timed Out\n");
>                         ret_size = 0;
>                 }
> +
>                 wilc->cfg_frame_in_use = 0;
>                 wilc->cfg_frame_offset = 0;
>                 wilc->cfg_seq_no += 1;
> @@ -1246,6 +1247,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
>  {
>         u32 offset;
>         int ret_size;
> +
>         struct wilc *wilc = vif->wilc;
>  
>         if (wilc->cfg_frame_in_use)
> 

These two extra newlines seem unrelated to the other changes and probably
slipped in by accident. The first one is actually ok according to
normal coding style, while the second one looks misplaced.

In general, it's better not to touch whitespace when doing other changes,
except when you are fixing the same code you modify anyway.

	Arnd
