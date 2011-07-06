Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45562 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab1GFPky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 11:40:54 -0400
Date: Wed, 6 Jul 2011 17:40:46 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: implement BCMA bus ops
Message-ID: <20110706174046.0ae24b6d@maggie> (sfid-20110706_174058_338617_AA5C8E71)
In-Reply-To: <1309902848-3141-2-git-send-email-zajec5@gmail.com>
References: <1309902848-3141-1-git-send-email-zajec5@gmail.com>
	<1309902848-3141-2-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue,  5 Jul 2011 23:54:08 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/bus.c  |  100 +++++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/b43/bus.h  |    3 +
>  drivers/net/wireless/b43/main.c |    7 +++
>  3 files changed, 110 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
> index 4200713..f56604f 100644
> --- a/drivers/net/wireless/b43/bus.c
> +++ b/drivers/net/wireless/b43/bus.c
> @@ -23,6 +23,106 @@
>  #include "b43.h"
>  #include "bus.h"
>  
> +/* BCMA */
> +#ifdef CONFIG_B43_BCMA
> +static inline int b43_bus_bcma_bus_may_powerdown(struct b43_bus_dev *dev)
> +{
> +	return 0; /* bcma_bus_may_powerdown(dev->bdev->bus); */
> +}

Why is this inline?
You can't inline and take a pointer of the function at the same time.
(The compiler will workaround this by generating multiple versions of
the function, of which at least one is not inline).
So remove it, please. Same below...

> +static inline int b43_bus_bcma_bus_powerup(struct b43_bus_dev *dev,
> +					  bool dynamic_pctl)
> +{
> +	return 0; /* bcma_bus_powerup(dev->sdev->bus, dynamic_pctl); */
> +}
> +static inline int b43_bus_bcma_device_is_enabled(struct b43_bus_dev *dev)
> +{
> +	return bcma_core_is_enabled(dev->bdev);
> +}
> +static inline void b43_bus_bcma_device_enable(struct b43_bus_dev *dev,
> +					     u32 core_specific_flags)
> +{
> +	bcma_core_enable(dev->bdev, core_specific_flags);
> +}
> +static inline void b43_bus_bcma_device_disable(struct b43_bus_dev *dev,
> +					      u32 core_specific_flags)
> +{
> +	bcma_core_disable(dev->bdev, core_specific_flags);
> +}
> +static inline u16 b43_bus_bcma_read16(struct b43_bus_dev *dev, u16 offset)
> +{
> +	return bcma_read16(dev->bdev, offset);
> +}
> +static inline u32 b43_bus_bcma_read32(struct b43_bus_dev *dev, u16 offset)
> +{
> +	return bcma_read32(dev->bdev, offset);
> +}
> +static inline
> +void b43_bus_bcma_write16(struct b43_bus_dev *dev, u16 offset, u16 value)
> +{
> +	bcma_write16(dev->bdev, offset, value);
> +}
> +static inline
> +void b43_bus_bcma_write32(struct b43_bus_dev *dev, u16 offset, u32 value)
> +{
> +	bcma_write32(dev->bdev, offset, value);
> +}
> +static inline
> +void b43_bus_bcma_block_read(struct b43_bus_dev *dev, void *buffer,
> +			    size_t count, u16 offset, u8 reg_width)
> +{
> +	bcma_block_read(dev->bdev, buffer, count, offset, reg_width);
> +}
> +static inline
> +void b43_bus_bcma_block_write(struct b43_bus_dev *dev, const void *buffer,
> +			     size_t count, u16 offset, u8 reg_width)
> +{
> +	bcma_block_write(dev->bdev, buffer, count, offset, reg_width);
> +}
> +
> +struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core)
> +{
> +	struct b43_bus_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return NULL;
> +
> +	dev->bus_type = B43_BUS_BCMA;
> +	dev->bdev = core;
> +
> +	dev->bus_may_powerdown = b43_bus_bcma_bus_may_powerdown;
> +	dev->bus_powerup = b43_bus_bcma_bus_powerup;
> +	dev->device_is_enabled = b43_bus_bcma_device_is_enabled;
> +	dev->device_enable = b43_bus_bcma_device_enable;
> +	dev->device_disable = b43_bus_bcma_device_disable;
> +
> +	dev->read16 = b43_bus_bcma_read16;
> +	dev->read32 = b43_bus_bcma_read32;
> +	dev->write16 = b43_bus_bcma_write16;
> +	dev->write32 = b43_bus_bcma_write32;
> +	dev->block_read = b43_bus_bcma_block_read;
> +	dev->block_write = b43_bus_bcma_block_write;
> +
> +	dev->dev = &core->dev;
> +	dev->dma_dev = core->dma_dev;
> +	dev->irq = core->irq;
> +
> +	/*
> +	dev->board_vendor = core->bus->boardinfo.vendor;
> +	dev->board_type = core->bus->boardinfo.type;
> +	dev->board_rev = core->bus->boardinfo.rev;
> +	*/
> +
> +	dev->chip_id = core->bus->chipinfo.id;
> +	dev->chip_rev = core->bus->chipinfo.rev;
> +	dev->chip_pkg = core->bus->chipinfo.pkg;
> +
> +	dev->bus_sprom = &core->bus->sprom;
> +
> +	dev->core_id = core->id.id;
> +	dev->core_rev = core->id.rev;
> +
> +	return dev;
> +}
> +#endif /* CONFIG_B43_BCMA */
>  
>  /* SSB */
>  #ifdef CONFIG_B43_SSB
> diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
> index 79a5ab4..a70b7b9 100644
> --- a/drivers/net/wireless/b43/bus.h
> +++ b/drivers/net/wireless/b43/bus.h
> @@ -2,12 +2,14 @@
>  #define B43_BUS_H_
>  
>  enum b43_bus_type {
> +	B43_BUS_BCMA,
>  	B43_BUS_SSB,
>  };
>  
>  struct b43_bus_dev {
>  	enum b43_bus_type bus_type;
>  	union {
> +		struct bcma_device *bdev;
>  		struct ssb_device *sdev;
>  	};
>  
> @@ -57,6 +59,7 @@ static inline bool b43_bus_host_is_sdio(struct b43_bus_dev *dev)
>  		dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO);
>  }
>  
> +struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core);
>  struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
>  
>  #endif /* B43_BUS_H_ */
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 410b77f..b85a973 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -5010,7 +5010,14 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
>  #ifdef CONFIG_B43_BCMA
>  static int b43_bcma_probe(struct bcma_device *core)
>  {
> +	struct b43_bus_dev *dev;
> +
> +	dev = b43_bus_dev_bcma_init(core);
> +	if (!dev)
> +		return -ENODEV;
> +
>  	b43err(NULL, "BCMA is not supported yet!");
> +	kfree(dev);
>  	return -EOPNOTSUPP;
>  }
>  

