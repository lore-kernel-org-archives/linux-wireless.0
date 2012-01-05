Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55537 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab2AEMd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 07:33:27 -0500
MIME-Version: 1.0
In-Reply-To: <1325765663-7141-1-git-send-email-festevam@gmail.com>
References: <1325765663-7141-1-git-send-email-festevam@gmail.com>
Date: Thu, 5 Jan 2012 13:33:25 +0100
Message-ID: <CAL1gcdOrr41Br1Z-JCih6BGdxLmZ9ns+W-cVRxvd+guO2xC_zQ@mail.gmail.com> (sfid-20120105_133332_525252_32FDC803)
Subject: Re: [PATCH] drivers: net: Fix dependency for EEPROM_93CX6
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, linville@tuxdriver.com,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 5, 2012 at 1:14 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Fix the following build warning:
>
> warning: (KS8851 && AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

NAK, at least for the rt2x00 part, but probably for the other parts as well.
The rt2x00 drivers actually need the EEPROM_93CX6 driver to be
present, otherwise they won't work correctly. Therefore only selecting
the symbol when MISC_DEVICES has been enabled can lead to a
non-functional configuration for the rt2x00 devices.

A correct fix would be to also select MISC_DEVICES at all locations
where EEPROM_93CX6 is selected.

---
Gertjan.

> ---
>  drivers/net/ethernet/8390/Kconfig    |    2 +-
>  drivers/net/ethernet/micrel/Kconfig  |    3 +--
>  drivers/net/wireless/Kconfig         |    2 +-
>  drivers/net/wireless/rt2x00/Kconfig  |    8 ++++----
>  drivers/net/wireless/rtl818x/Kconfig |    4 ++--
>  5 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
> index e04ade4..d967c74 100644
> --- a/drivers/net/ethernet/8390/Kconfig
> +++ b/drivers/net/ethernet/8390/Kconfig
> @@ -69,7 +69,7 @@ config AX88796
>  config AX88796_93CX6
>        bool "ASIX AX88796 external 93CX6 eeprom support"
>        depends on AX88796
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          Select this if your platform comes with an external 93CX6 eeprom.
>
> diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
> index 1ea811c..bc99abf 100644
> --- a/drivers/net/ethernet/micrel/Kconfig
> +++ b/drivers/net/ethernet/micrel/Kconfig
> @@ -42,8 +42,7 @@ config KS8851
>        select NET_CORE
>        select MII
>        select CRC32
> -       select MISC_DEVICES
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          SPI driver for Micrel KS8851 SPI attached network chip.
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index abd3b71..d15d3a9 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -223,7 +223,7 @@ config ADM8211
>        tristate "ADMtek ADM8211 support"
>        depends on MAC80211 && PCI && EXPERIMENTAL
>        select CRC32
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This driver is for ADM8211A, ADM8211B, and ADM8211C based cards.
>          These are PCI/mini-PCI/Cardbus 802.11b chips found in cards such as:
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index a0a7854..c7be1a9 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -21,7 +21,7 @@ config RT2400PCI
>        tristate "Ralink rt2400 (PCI/PCMCIA) support"
>        depends on PCI
>        select RT2X00_LIB_PCI
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This adds support for rt2400 wireless chipset family.
>          Supported chips: RT2460.
> @@ -32,7 +32,7 @@ config RT2500PCI
>        tristate "Ralink rt2500 (PCI/PCMCIA) support"
>        depends on PCI
>        select RT2X00_LIB_PCI
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This adds support for rt2500 wireless chipset family.
>          Supported chips: RT2560.
> @@ -46,7 +46,7 @@ config RT61PCI
>        select RT2X00_LIB_FIRMWARE
>        select RT2X00_LIB_CRYPTO
>        select CRC_ITU_T
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This adds support for rt2501 wireless chipset family.
>          Supported chips: RT2561, RT2561S & RT2661.
> @@ -62,7 +62,7 @@ config RT2800PCI
>        select RT2X00_LIB_FIRMWARE
>        select RT2X00_LIB_CRYPTO
>        select CRC_CCITT
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This adds support for rt27xx/rt28xx/rt30xx wireless chipset family.
>          Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890, RT3052,
> diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
> index 17d80fe..3e399b8 100644
> --- a/drivers/net/wireless/rtl818x/Kconfig
> +++ b/drivers/net/wireless/rtl818x/Kconfig
> @@ -4,7 +4,7 @@
>  config RTL8180
>        tristate "Realtek 8180/8185 PCI support"
>        depends on MAC80211 && PCI && EXPERIMENTAL
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This is a driver for RTL8180 and RTL8185 based cards.
>          These are PCI based chips found in cards such as:
> @@ -60,7 +60,7 @@ config RTL8180
>  config RTL8187
>        tristate "Realtek 8187 and 8187B USB support"
>        depends on MAC80211 && USB
> -       select EEPROM_93CX6
> +       select EEPROM_93CX6 if MISC_DEVICES
>        ---help---
>          This is a driver for RTL8187 and RTL8187B based cards.
>          These are USB based chips found in devices such as:
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
