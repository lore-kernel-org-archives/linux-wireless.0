Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:63278 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab0DCNnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 09:43:11 -0400
Message-ID: <4BB745E8.6030205@gmail.com>
Date: Sat, 03 Apr 2010 15:43:04 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Luis Correia <luis.f.correia@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH V4] rt2x00: remove MCU requests for SoC platforms
References: <k2g880c1631004011414z59ce4547j1bcea7ad5aff7229@mail.gmail.com> 	<t2qefe7343f1004030447i9d6f290fvd7dd317c63b5b61@mail.gmail.com> <l2mefe7343f1004030449refb18c80l3a81242338a8a4a7@mail.gmail.com>
In-Reply-To: <l2mefe7343f1004030449refb18c80l3a81242338a8a4a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/10 13:49, Luis Correia wrote:
> The ralink SoC platforms do not have an MCU.
> 
> Signed-off-by: Luis Correia <luis.f.correia@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 
> Removed flag usage as per Gertjan suggestion.
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
> b/drivers/net/wireless/rt2x00/rt2800pci.c
> index ce7e88e..1df2d44 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -60,6 +60,12 @@ static void rt2800pci_mcu_status(struct rt2x00_dev
> *rt2x00dev, const u8 token)
>        unsigned int i;
>        u32 reg;
> 
> +       /*
> +        * SOC devices don't support MCU requests.
> +        */
> +       if (rt2x00_is_soc(rt2x00dev))
> +               return;
> +
>        for (i = 0; i < 200; i++) {
>                rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
> 

