Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51819 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CTV3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:29:37 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so1428927eek.23
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 14:29:36 -0700 (PDT)
References: <1363808915-14278-1-git-send-email-blogic@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1363808915-14278-1-git-send-email-blogic@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com> (sfid-20130320_222941_290885_D5C32BE4)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	John Crispin <blogic@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: make the driver build for Ralink SoC
Date: Wed, 20 Mar 2013 22:29:31 +0100
To: John Crispin <blogic@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 20 mrt. 2013, at 20:48, John Crispin <blogic@openwrt.org> wrote:

> Fix up the dependencies to make the driver actually compile on Ralink WiSoC.
> 
> Signed-off-by: John Crispin <blogic@openwrt.org>

I don't think this is a proper way to handle this. rt2x00pci.c was only meant to be used for PCI devices; introducing the use of CONFIG_PCI in that file doesn't seem appropriate to me.

Unfortunately I am away from my home computer, so I can't look at this properly until the weekend.

> ---
> drivers/net/wireless/rt2x00/Kconfig     |    2 +-
> drivers/net/wireless/rt2x00/rt2x00pci.c |    2 ++
> 2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index 2bf4efa..dc7ee6c 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -57,7 +57,7 @@ config RT2800PCI
>    tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
>    depends on PCI || SOC_RT288X || SOC_RT305X
>    select RT2800_LIB
> -    select RT2X00_LIB_PCI if PCI
> +    select RT2X00_LIB_PCI
>    select RT2X00_LIB_SOC if SOC_RT288X || SOC_RT305X
>    select RT2X00_LIB_FIRMWARE
>    select RT2X00_LIB_CRYPTO
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index a0c8cae..fa20add 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -208,6 +208,7 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
> }
> EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
> 
> +#ifdef CONFIG_PCI
> /*
>  * PCI driver handlers.
>  */
> @@ -392,6 +393,7 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
> }
> EXPORT_SYMBOL_GPL(rt2x00pci_resume);
> #endif /* CONFIG_PM */
> +#endif /* CONFIG_PCI */
> 
> /*
>  * rt2x00pci module information.
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
