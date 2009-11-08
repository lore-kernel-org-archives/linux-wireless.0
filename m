Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:53981 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZKHNz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:55:56 -0500
Received: by ey-out-2122.google.com with SMTP id 25so5413eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:56:01 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
Date: Sun, 8 Nov 2009 14:55:59 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133948.23584.12804.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133948.23584.12804.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081455.59312.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: add eFuse EEPROM support code to rt2800lib
> 
> eFuse EEPROM is used also by USB chips (i.e. RT3070)
> so move the needed code from rt2800pci to rt2800lib.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800.h    |   29 +++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.c |   43 ++++++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.h |    2 +
>  drivers/net/wireless/rt2x00/rt2800pci.c |   38 ++--------------------------
>  drivers/net/wireless/rt2x00/rt2800pci.h |   29 ---------------------
>  5 files changed, 77 insertions(+), 64 deletions(-)


> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -147,44 +147,12 @@ static void rt2800pci_read_eeprom_pci(st
>  
>  static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
>  {
> -	u32 reg;
> -
> -	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
> -
> -	return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
> +	return rt2800_efuse_detect(rt2x00dev);
>  }

It would be better to fix all calls to rt2800pci_efuse_detect to use rt2800_efuse_detect
rather then adding a special wrapper function for it.

> -static void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
> +static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
>  {
> -	unsigned int i;
> -
> -	for (i = 0; i < EEPROM_SIZE / sizeof(u16); i += 8)
> -		rt2800pci_efuse_read(rt2x00dev, i);
> +	rt2800_read_eeprom_efuse(rt2x00dev);
>  }

Same here.

Ivo
