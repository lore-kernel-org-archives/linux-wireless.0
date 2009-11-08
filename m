Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36539 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbZKHMjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:39:42 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2345707ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:39:48 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [RFC/RFT] rt2x00: Add dynamic detection of eFuse EEPROM in rt2800pci.
Date: Sun, 8 Nov 2009 13:39:08 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1257679835-25269-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257679835-25269-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081339.08797.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Gertjan van Wingerde wrote:
> Instead of assuming that all rt3090 devices will have an eFuse EEPROM, do as the legacy Ralink driver,
> and detect at run-time whether an eFuse EEPROM is present.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> I only had the possibilitye to test this on a rt2890 device without eFuse EEPROM.
> It would be good if someone can test this on a rt3090 device with eFuse EEPROM.
> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   22 ++++++++++++++++++----
>  drivers/net/wireless/rt2x00/rt2800pci.h |    1 +
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index bff8707..2f284a6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -145,6 +145,15 @@ static void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
>  			       EEPROM_SIZE / sizeof(u16));
>  }
>  
> +static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
> +{
> +	u32 reg;
> +
> +	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
> +
> +	return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
> +}
> +
>  static void rt2800pci_efuse_read(struct rt2x00_dev *rt2x00dev,
>  				 unsigned int i)
>  {
> @@ -182,6 +191,11 @@ static inline void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
>  {
>  }
>  
> +static inline int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
> +{
> +	return 0;
> +}
> +
>  static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
>  {
>  }
> @@ -1091,11 +1105,11 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  	case RT3052:
>  		rt2800pci_read_eeprom_soc(rt2x00dev);
>  		break;
> -	case RT3090:
> -		rt2800pci_read_eeprom_efuse(rt2x00dev);
> -		break;
>  	default:
> -		rt2800pci_read_eeprom_pci(rt2x00dev);
> +		if (rt2800pci_efuse_detect(rt2x00dev))
> +			rt2800pci_read_eeprom_efuse(rt2x00dev);
> +		else
> +			rt2800pci_read_eeprom_pci(rt2x00dev);
>  		break;
>  	}
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
> index 1dbf132..8f944ee 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
> @@ -62,6 +62,7 @@
>  #define EFUSE_CTRL_ADDRESS_IN		FIELD32(0x03fe0000)
>  #define EFUSE_CTRL_MODE			FIELD32(0x000000c0)
>  #define EFUSE_CTRL_KICK			FIELD32(0x40000000)
> +#define EFUSE_CTRL_PRESENT		FIELD32(0x80000000)
>  
>  /*
>   * EFUSE_DATA0


