Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41428 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750812AbcLANLK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 08:11:10 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 2/2] mwifiex: get rid of global user_rmmod flag
Date: Thu, 1 Dec 2016 13:11:07 +0000
Message-ID: <f7feb7c9b515451787321fda912188c8@SC-EXCH04.marvell.com> (sfid-20161201_141113_792642_2BBD5F4A)
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
 <1480517537-9920-2-git-send-email-akarwar@marvell.com>
 <20161130183853.GD31934@dtor-ws>
In-Reply-To: <20161130183853.GD31934@dtor-ws>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Thursday, December 01, 2016 12:09 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; briannorris@google.com; Xinming Hu
> Subject: Re: [PATCH 2/2] mwifiex: get rid of global user_rmmod flag
> 
> Hi Amitkumar,
> 
> On Wed, Nov 30, 2016 at 08:22:17PM +0530, Amitkumar Karwar wrote:
> > @@ -3177,9 +3184,6 @@ static int mwifiex_pcie_init_module(void)
> >
> >  	pr_debug("Marvell PCIe Driver\n");
> >
> > -	/* Clear the flag in case user removes the card. */
> > -	user_rmmod = 0;
> > -
> >  	ret = pci_register_driver(&mwifiex_pcie);
> >  	if (ret)
> >  		pr_err("Driver register failed!\n"); @@ -3200,9 +3204,6 @@
> static
> > int mwifiex_pcie_init_module(void)
> >   */
> >  static void mwifiex_pcie_cleanup_module(void)  {
> > -	/* Set the flag as user is removing this module. */
> > -	user_rmmod = 1;
> > -
> >  	pci_unregister_driver(&mwifiex_pcie);
> >  }
> 
> Now that your module init/exit code turns into wrapper around bus
> driver registration calls, please consider using module_pci_driver(),
> module_usb_driver(). Note that I do not see module_sdio_driver, but you
> could still use
> 
> module_driver(mwifiex_sdio, sdio_register_driver,
> sdio_unregister_driver);
> 

Thanks for review.
I just submitted a separate patch which handles this cleanup.
https://patchwork.kernel.org/patch/9456135/

Regards,
Amitkumar
