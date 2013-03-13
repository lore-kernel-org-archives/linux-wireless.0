Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:36833 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMMaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:30:01 -0400
Received: by mail-ia0-f176.google.com with SMTP id i18so904995iac.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 05:30:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363177215-12685-1-git-send-email-blogic@openwrt.org>
References: <1363177215-12685-1-git-send-email-blogic@openwrt.org>
Date: Wed, 13 Mar 2013 13:30:00 +0100
Message-ID: <CAL1gcdOBOjwUWrG=+RfaDOCzGdQ+BbX9uyCFq=E33jW=YuY2Ng@mail.gmail.com> (sfid-20130313_133006_936767_FC638B0B)
Subject: Re: [PATCH] rt2x00: fix rt2x00 to work with the new ralink SoC config symbols
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: John Crispin <blogic@openwrt.org>,
	John Linville <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 13, 2013 at 1:20 PM, John Crispin <blogic@openwrt.org> wrote:
> Since v3.9-rc1 the kernel has basic support for Ralink WiSoC. The config symbols
> are named slightly different than before. Fix the rt2x00 to match the new
> symbols.
>
> The commit causing this breakage is:
> commit ae2b5bb6570481b50a7175c64176b82da0a81836
> Author: John Crispin <blogic@openwrt.org>
> Date:   Sun Jan 20 22:05:30 2013 +0100
> MIPS: ralink: adds Kbuild files
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

John L., please apply to wireless for inclusion in 3.9.

> ---
>  drivers/net/wireless/rt2x00/Kconfig     |    4 ++--
>  drivers/net/wireless/rt2x00/rt2800pci.c |   14 +++++++-------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index 44d6ead..2bf4efa 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -55,10 +55,10 @@ config RT61PCI
>
>  config RT2800PCI
>         tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
> -       depends on PCI || RALINK_RT288X || RALINK_RT305X
> +       depends on PCI || SOC_RT288X || SOC_RT305X
>         select RT2800_LIB
>         select RT2X00_LIB_PCI if PCI
> -       select RT2X00_LIB_SOC if RALINK_RT288X || RALINK_RT305X
> +       select RT2X00_LIB_SOC if SOC_RT288X || SOC_RT305X
>         select RT2X00_LIB_FIRMWARE
>         select RT2X00_LIB_CRYPTO
>         select CRC_CCITT
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 48a01aa..ded73da 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -89,7 +89,7 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
>         rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
>  }
>
> -#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> +#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
>  static int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
>  {
>         void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
> @@ -107,7 +107,7 @@ static inline int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
>  {
>         return -ENOMEM;
>  }
> -#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
> +#endif /* CONFIG_SOC_RT288X || CONFIG_SOC_RT305X */
>
>  #ifdef CONFIG_PCI
>  static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
> @@ -1177,7 +1177,7 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
>  #endif /* CONFIG_PCI */
>  MODULE_LICENSE("GPL");
>
> -#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> +#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
>  static int rt2800soc_probe(struct platform_device *pdev)
>  {
>         return rt2x00soc_probe(pdev, &rt2800pci_ops);
> @@ -1194,7 +1194,7 @@ static struct platform_driver rt2800soc_driver = {
>         .suspend        = rt2x00soc_suspend,
>         .resume         = rt2x00soc_resume,
>  };
> -#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
> +#endif /* CONFIG_SOC_RT288X || CONFIG_SOC_RT305X */
>
>  #ifdef CONFIG_PCI
>  static int rt2800pci_probe(struct pci_dev *pci_dev,
> @@ -1217,7 +1217,7 @@ static int __init rt2800pci_init(void)
>  {
>         int ret = 0;
>
> -#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> +#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
>         ret = platform_driver_register(&rt2800soc_driver);
>         if (ret)
>                 return ret;
> @@ -1225,7 +1225,7 @@ static int __init rt2800pci_init(void)
>  #ifdef CONFIG_PCI
>         ret = pci_register_driver(&rt2800pci_driver);
>         if (ret) {
> -#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> +#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
>                 platform_driver_unregister(&rt2800soc_driver);
>  #endif
>                 return ret;
> @@ -1240,7 +1240,7 @@ static void __exit rt2800pci_exit(void)
>  #ifdef CONFIG_PCI
>         pci_unregister_driver(&rt2800pci_driver);
>  #endif
> -#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> +#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
>         platform_driver_unregister(&rt2800soc_driver);
>  #endif
>  }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
