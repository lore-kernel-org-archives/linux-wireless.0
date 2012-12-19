Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45504 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LSLMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 06:12:49 -0500
Received: by mail-lb0-f172.google.com with SMTP id y2so1626881lbk.17
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 03:12:48 -0800 (PST)
Message-ID: <50D19F97.9000000@27m.se> (sfid-20121219_121254_102737_DB43777B)
Date: Wed, 19 Dec 2012 12:05:59 +0100
From: Jones Desougi <jones.desougi@27m.se>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Daniel Golle <dgolle@allnet.de>, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: rt2800pci: verify ioremap return value
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,

One thing:

On 12/18/2012 05:22 PM, Gabor Juhos wrote:
> An ioremap call is allowed to fail, however
> the return value of that is not checked in
> the 'rt2800pci_read_eeprom_soc' function.
> 
> The patch adds the missing check, and makes
> the function return an int value. The patch
> also converts the 'rt2800_read_eeprom' and
> 'rt2800_ops.read_eeprom' functions to return
> an int value, so the error value can be
> propagated up to the 'rt2800_validate_eeprom'
> function.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++++-
>  drivers/net/wireless/rt2x00/rt2800lib.h |    6 +++---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   17 ++++++++++++-----
>  drivers/net/wireless/rt2x00/rt2800usb.c |    4 +++-
>  4 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 197b446..52b2978 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4635,11 +4635,14 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  	u16 word;
>  	u8 *mac;
>  	u8 default_lna_gain;
> +	int retval;
>  
>  	/*
>  	 * Read the EEPROM.
>  	 */
> -	rt2800_read_eeprom(rt2x00dev);
> +	retval = rt2800_read_eeprom(rt2x00dev);
> +	if (retval)
> +		return retval;
>  
>  	/*
>  	 * Start validation of the data that has been read.
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
> index a128cea..8252c67 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.h
> @@ -43,7 +43,7 @@ struct rt2800_ops {
>  			    const unsigned int offset,
>  			    const struct rt2x00_field32 field, u32 *reg);
>  
> -	void (*read_eeprom)(struct rt2x00_dev *rt2x00dev);
> +	int (*read_eeprom)(struct rt2x00_dev *rt2x00dev);
>  	bool (*hwcrypt_disabled)(struct rt2x00_dev *rt2x00dev);
>  
>  	int (*drv_write_firmware)(struct rt2x00_dev *rt2x00dev,
> @@ -117,11 +117,11 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
>  	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
>  }
>  
> -static inline void rt2800_read_eeprom(struct rt2x00_dev *rt2x00dev)
> +static inline int rt2800_read_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
>  
> -	rt2800ops->read_eeprom(rt2x00dev);
> +	return rt2800ops->read_eeprom(rt2x00dev);
>  }
>  
>  static inline bool rt2800_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 9224d87..5fc16dd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -90,17 +90,21 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
>  }
>  
>  #if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> -static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
> +static int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
>  {
>  	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
>  
> +	if (!base_addr)
> +		return -ENOMEM;
> +
>  	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
>  
>  	iounmap(base_addr);
>  }

Missing return at the end, since it should now return an int.
Even if this is gone with the second patch.

>  #else
> -static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
> +static inline int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
>  {
> +	return -ENOMEM;
>  }
>  #endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
>  
> @@ -970,14 +974,17 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
>  /*
>   * Device probe functions.
>   */
> -static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
> +static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	if (rt2x00_is_soc(rt2x00dev))
> -		rt2800pci_read_eeprom_soc(rt2x00dev);
> -	else if (rt2800pci_efuse_detect(rt2x00dev))
> +		return rt2800pci_read_eeprom_soc(rt2x00dev);
> +
> +	if (rt2800pci_efuse_detect(rt2x00dev))
>  		rt2800pci_read_eeprom_efuse(rt2x00dev);
>  	else
>  		rt2800pci_read_eeprom_pci(rt2x00dev);
> +
> +	return 0;
>  }
>  
>  static const struct ieee80211_ops rt2800pci_mac80211_ops = {
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 5c149b5..48de5c9 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -735,13 +735,15 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
>  /*
>   * Device probe functions.
>   */
> -static void rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
> +static int rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	if (rt2800_efuse_detect(rt2x00dev))
>  		rt2800_read_eeprom_efuse(rt2x00dev);
>  	else
>  		rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
>  				      EEPROM_SIZE);
> +
> +	return 0;
>  }
>  
>  static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
> 


Regards,
   /Jones

