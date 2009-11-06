Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37688 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbZKFQPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 11:15:07 -0500
Date: Fri, 6 Nov 2009 11:09:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Carlo Parata <carlo_parata@hotmail.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com
Subject: Re: [PATCH] Wifi led does not work on Acer Aspire One D250 (ath5k
	driver)
Message-ID: <20091106160926.GA2782@tuxdriver.com>
References: <loom.20091106T135746-452@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20091106T135746-452@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2009 at 01:00:02PM +0000, Carlo Parata wrote:
> With this patch, a Acer Aspire One D250 can turn on the wifi led. The array of
> compatible devices in ath5k driver now includes the hardware present in this
> computer, as well as the led pin and polarity.
> 
> --- ../led.c	2009-11-06 06:16:39.000000000 +0100
> +++ ./drivers/net/wireless/ath/ath5k/led.c	2009-11-06 12:37:44.000000000 +0100
> @@ -73,6 +73,8 @@
>  	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
>  	/* IBM-specific AR5212 (all others) */
>  	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
> +        /* Acer Aspire One D250 AR5007EG */
> +	{ PCI_VDEVICE(ATHEROS, 0x001c), ATH_LED(3, 1) },
>  	{ }
>  };

FWIW, a similar patch earlier this week drew the following from Bob Copeand:

"... but can you by chance put a contact address in the comment?  I've been
collecting them in case we one day figure out a better way to do this so it's
easy to find the people to retest."

Would you mind complying with his request?  Or have I mistakend his applicability?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
