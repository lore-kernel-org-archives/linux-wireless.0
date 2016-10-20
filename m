Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:47605 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757080AbcJTBt0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 21:49:26 -0400
Subject: Re: [char-misc-next 2/5] watchdog: mei_wdt: use module_mei_cl_driver
 macro
To: Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
References: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
 <1476884011-20645-3-git-send-email-tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <8c4f84af-0cf8-fc41-852c-1e62a87a6d16@roeck-us.net> (sfid-20161020_034949_327488_BA39D5A7)
Date: Wed, 19 Oct 2016 18:49:22 -0700
MIME-Version: 1.0
In-Reply-To: <1476884011-20645-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/2016 06:33 AM, Tomas Winkler wrote:
> Replace boilerplate driver registration with module_mei_cl_driver macro.
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/mei_wdt.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
>
> diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
> index 630bd189f167..116be477c8fd 100644
> --- a/drivers/watchdog/mei_wdt.c
> +++ b/drivers/watchdog/mei_wdt.c
> @@ -699,25 +699,7 @@ static struct mei_cl_driver mei_wdt_driver = {
>  	.remove = mei_wdt_remove,
>  };
>
> -static int __init mei_wdt_init(void)
> -{
> -	int ret;
> -
> -	ret = mei_cldev_driver_register(&mei_wdt_driver);
> -	if (ret) {
> -		pr_err(KBUILD_MODNAME ": module registration failed\n");
> -		return ret;
> -	}
> -	return 0;
> -}
> -
> -static void __exit mei_wdt_exit(void)
> -{
> -	mei_cldev_driver_unregister(&mei_wdt_driver);
> -}
> -
> -module_init(mei_wdt_init);
> -module_exit(mei_wdt_exit);
> +module_mei_cl_driver(mei_wdt_driver);
>
>  MODULE_AUTHOR("Intel Corporation");
>  MODULE_LICENSE("GPL");
>
