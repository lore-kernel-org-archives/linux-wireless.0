Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:59725 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbCITsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:48:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v5 2/3] wl18xx: add basic device-tree support
Date: Mon, 09 Mar 2015 20:47:46 +0100
Message-ID: <10327320.45ToCM2gnq@wuerfel> (sfid-20150309_204819_109355_1BFA8FB5)
In-Reply-To: <1425915402-10012-2-git-send-email-eliad@wizery.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <1425915402-10012-2-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 March 2015 17:36:41 Eliad Peller wrote:
> @@ -323,11 +388,14 @@ out:
>  static void wl1271_remove(struct sdio_func *func)
>  {
>         struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
> +       struct wlcore_platdev_data *pdev_data = glue->core->dev.platform_data;
> +       struct wl12xx_platform_data *pdata = pdev_data->pdata;
>  
>         /* Undo decrement done above in wl1271_probe */
>         pm_runtime_get_noresume(&func->dev);
>  
>         platform_device_unregister(glue->core);
> +       wlcore_del_platform_data(pdata);
>         kfree(glue);
>  }
>  
> 

The third patch looks ok, but now you should remove the wl12xx_platform_data
from the wlcore code, since it's not used any more, it was broken to start
with (as it supports only one instance) and we want to prevent others from
adding new users of that. Since the only thing you need is the irq number,
you can directly add the irq number to struct wlcore_platdev_data and
remove the pdata pointer there.

	Arnd
