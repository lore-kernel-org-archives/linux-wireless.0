Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2281 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161311Ab2CPJFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 05:05:55 -0400
Message-ID: <4F630267.5050909@broadcom.com> (sfid-20120316_100608_198304_CA09F26D)
Date: Fri, 16 Mar 2012 10:05:43 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"ralf@linux-mips.org" <ralf@linux-mips.org>,
	"m@bues.ch" <m@bues.ch>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"zajec5@gmail.com" <zajec5@gmail.com>
Subject: Re: [PATCH v5 4/4] USB: OHCI: remove old SSB OHCI driver
References: <1331851799-5968-1-git-send-email-hauke@hauke-m.de>
 <1331851799-5968-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1331851799-5968-5-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 11:49 PM, Hauke Mehrtens wrote:
> This is now replaced by the new ssb USB driver, which also supports
> devices with an EHCI controller.
>
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   drivers/usb/host/Kconfig    |    7 +-
>   drivers/usb/host/ohci-hcd.c |   21 +----
>   drivers/usb/host/ohci-ssb.c |  260 -------------------------------------------
>   3 files changed, 7 insertions(+), 281 deletions(-)
>   delete mode 100644 drivers/usb/host/ohci-ssb.c
>
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 2fc5637..00b6fc8 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -373,10 +373,15 @@ config USB_OHCI_HCD_PCI
>   	  If unsure, say Y.
>
>   config USB_OHCI_HCD_SSB
> -	bool "OHCI support for Broadcom SSB OHCI core"
> +	bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
>   	depends on USB_OHCI_HCD&&  (SSB = y || SSB = USB_OHCI_HCD)&&  EXPERIMENTAL
> +	select USB_HCD_SSB
> +	select USB_OHCI_HCD_PLATFORM
>   	default n
>   	---help---
> +	  This option is deprecated now and the driver was removed, use
> +	  USB_HCD_SSB and USB_OHCI_HCD_PLATFORM instead.
> +
>   	  Support for the Sonics Silicon Backplane (SSB) attached
>   	  Broadcom USB OHCI core.

Looks fine as it helps transitioning old .config files. Should the 
select statements be mentioned in the help section, ie. 'using' iso 'use'.

Gr. AvS


