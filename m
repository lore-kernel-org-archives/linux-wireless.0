Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32994 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756680AbcK3SjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 13:39:02 -0500
Received: by mail-pg0-f66.google.com with SMTP id 3so2046754pgd.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 10:39:02 -0800 (PST)
Date: Wed, 30 Nov 2016 10:38:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: get rid of global user_rmmod flag
Message-ID: <20161130183853.GD31934@dtor-ws> (sfid-20161130_193910_056550_1F2216E3)
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
 <1480517537-9920-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480517537-9920-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

On Wed, Nov 30, 2016 at 08:22:17PM +0530, Amitkumar Karwar wrote:
> @@ -3177,9 +3184,6 @@ static int mwifiex_pcie_init_module(void)
>  
>  	pr_debug("Marvell PCIe Driver\n");
>  
> -	/* Clear the flag in case user removes the card. */
> -	user_rmmod = 0;
> -
>  	ret = pci_register_driver(&mwifiex_pcie);
>  	if (ret)
>  		pr_err("Driver register failed!\n");
> @@ -3200,9 +3204,6 @@ static int mwifiex_pcie_init_module(void)
>   */
>  static void mwifiex_pcie_cleanup_module(void)
>  {
> -	/* Set the flag as user is removing this module. */
> -	user_rmmod = 1;
> -
>  	pci_unregister_driver(&mwifiex_pcie);
>  }

Now that your module init/exit code turns into wrapper around bus
driver registration calls, please consider using module_pci_driver(),
module_usb_driver(). Note that I do not see module_sdio_driver, but you
could still use

module_driver(mwifiex_sdio, sdio_register_driver, sdio_unregister_driver);

Thanks.

-- 
Dmitry
