Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.161
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793789527;
	b=OiH9l/N1eDjmCBwd9l2bdPkRNSgQNozLtGk5CazM67tTzVVSkCF9mCJmtBLex+4gCurd
	 qk3lzlD9MuLsr6kd36tF8TcVZjv7n3Aln0X2VNESjCXbvHKvUx7uRa3v9o8EvpkGtbsKM
	 O+rUiK9iR/YC3nhyirsbdSEpFaLvRtvCGUkUar5+DuSGozLhQZ/n8g9V35SDic2EH/FDj
	 gN1opINyXRNgg4s5E/gfBy78qWbN33uInNGRsgVcmViGeVQO9TwQAH5VMIUvHLCjH1wqc
	 b0VWIDLxudMVO1J6quPRxxuxFyjkbTWXKDw9XI62Ne7Yi6L+PLomNx4ScSbjz3gJhHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789527;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=AdvHJTj8LMaNorLOD4U2KXWBTBRYScoC0HXmNvOUUM8=;
	b=Z7jDBrQQWXZkpWzbzq6wd5sUSzXB1rZQexXJCOws1R84s8IM7vSMpORZxXVX12RHK53l
	 F23GWl9dNX/gEJrYAACCKO9JLsAmeOWxFz11geor/ipgGBA58ApkvpPzG8uO68bU0XJ6G
	 mSU0cPzQPk+2TLQ9KkDiY7zw0cLQ0KCaosz1BFsbNn8Hr7JKssdXSWnxRxcmwngxXQNI5
	 sSb2uV1UGxEbRn/PuvnzHUcTCHYJWaTUpbIHw7MODJd+IJ6NtlG/uzfnlnjXDPHngaJgY
	 EI3P3n93nBhJrL2dFItRD6VZQUFOY79ol3qmYBmukkh50toEZeHjZcelaFitViGcfGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=kEVFXjeK;
	arc=none smtp.remote-ip=62.149.156.161
Received: from smtpcmd14161.aruba.it (smtpcmd14161.aruba.it [62.149.156.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EF3606A326
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 10:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1EF3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=kEVFXjeK
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id OYaxxFepQTDqGOYaxx2VHi; Wed, 04 Nov 2026 11:51:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793789516; bh=wNgqLILEOdHZXc13SFI3Wdpijs6INKgpdd3ZJUwhMRQ=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=kEVFXjeKWgFRCLUsBEgY4ZGfFbKIDB1CMgEcfc6B2ttE396UoFHe2qo3OOP9xbYeJ
	 eFu9ltG4xxmnsx/iLrzSvMe4f2OTY2k1swvnTXncwfPqKJU+8NR6MdCQHAXU3dsOpt
	 ts4lfp3v5ab6ZhApBaeAtwaftlM0v+PrwU9coREL7rfTgOHK/u2Iewpt9CMDh6V/vL
	 SoCigMxY3uPZh9tVraz5iXSyutvPQqiWIuA5Rr/BBGToYp9ivoquldY7eLCvzaGtmb
	 ONPyb9lh+bCSm2/3jlM+DAoxF4y3Q494adD//i/PouRhb3cY6w3wz1MiK2pzD7sm3+
	 0WLmFbISedgYw==
Date: Wed, 4 Nov 2026 11:51:47 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski	
 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, =?UTF-8?B?UmFm?=
 =?UTF-8?B?YcWCIE1pxYJlY2tp?=	 <zajec5@gmail.com>, Florian Fainelli
 <florian.fainelli@broadcom.com>, Broadcom internal kernel review list	
 <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer	
 <tsbogend@alpha.franken.de>, Jonas Gorski <jonas.gorski@gmail.com>,
 linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 4/5] bcma: add host driver for the BCM6362 integrated
 WLAN backplane
Message-ID: <20261104115147.4c0e518c@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <dd321689f566e687914908974bbe4c27ce2b587e.camel@pengutronix.de>
References: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
	<20261104-bcm6362-wlan-v3-4-e46562b2ac12@mythread.it>
	<dd321689f566e687914908974bbe4c27ce2b587e.camel@pengutronix.de>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfBaJse0+xjGdcVDK3RvXo6oxSNpNRuykK7O/ESaYWKhzMNSrvI/64/mXjtKF06aFYhoTTCX8gaiOp58kcVGvaiRTAh3KRpOGUs+F+7Trz1WopqX93MsS
 B1iZ5FU8iRYnUqca6REnLxlyFQ2R08ou464NjJo/ThBsoerTEuaVbAn67H59IlKmF3KPVoi1dikZZSwTsoHu61YVXsP0MpeFsJkjRU5aMRP8N2b+wiqLdv0/
 0cS/6/M2WNUlr82W48id9O5FOraIRJ1e3tIQzi2Z/Cx7B3AaUMKWg1wN8gksQM1u5fQCwGFAsYvIXXddPFkXyfmplTESYwChMEQSortmOxbcJYIz4Zm3iuJ3
 ccFskl3AcYL6k+f4M5glvYCfM5fGACHS9UtxrjOC/6YWvlC25YdQxRM75xV2GXR+SVR6yQYEz5C92T0dw3XaPugVGiwMH/RrRoMbzpBMWCF4GjftclY2Sq4h
 vZuHmgk0BH4lh0rmNlJKCg/BltdT0ltJVzV9ufDoYRNdLj2Jzd0eBM3tfvl4J+u/WqA3nnYu8vfzE3EsSGMaOL/PyIxw/2madZPubeQlWGADgF0ZmcObay5G
 c/iPCWg0VumMYNfyiSkFRM8bykwZ6fUfOKjFRKRd0kngB1H3l7u9lq7Dam5hvfQodf8=

On Wed, 04 Nov 2026 10:55:40 +0100
Philipp Zabel <p.zabel@pengutronix.de> wrote:

> On Mi, 2026-11-04 at 00:31 +0100, Alessio Ferri wrote:
> > The BCM6362 integrates a WLAN macro on a dedicated bcma backplane.
> > CFE leaves the macro clock gated and in reset, the backplane is
> > a big-endian peripheral, and none of the cores has a wrapper:
> > gating and reset of ChipCommon and of the 802.11 core go through
> > per-core control registers in a separate WLAN control block.
> > 
> > Add a host driver for it that:
> > 
> >   - maps the ChipCommon and WLAN control register blocks;
> >   - enables the clock, cycles the WLAN and WLAN UBUS resets and
> > runs the macro enable sequence bcma touches the backplane;
> >   - provides big-endian register and block I/O ops;
> >   - emulates BCMA_IOCTL, BCMA_IOST, BCMA_RESET_CTL and BCMA_RESET_ST
> >     on top of the per-core control registers. The PHY bits of
> >     BCMA_IOST report what b43 needs to hear;
> >   - sets the big_endian and wrapperless bus flags before scanning.
> > 
> > As for the PCI and generic SoC hosts, the driver is linked into
> > bcma.ko and registered from bcma_modinit().
> > 
> > Add a MAINTAINERS entry for the driver and its binding.
> > 
> > The 802.11 core (rev 0x16) is handled by b43 once a SPROM is
> > available; on this SoC it is not stored on the chip and has to be
> > provided. In openwrt i use 6362-sprom plus fixups.
> > 
> > Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> > ---
> >  MAINTAINERS                     |   7 +
> >  drivers/bcma/Kconfig            |  12 ++
> >  drivers/bcma/Makefile           |   1 +
> >  drivers/bcma/bcma_private.h     |  15 ++
> >  drivers/bcma/host_soc_bcm6362.c | 419
> > ++++++++++++++++++++++++++++++++++++++++ drivers/bcma/main.c
> >      |   6 + 6 files changed, 460 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index f53047aa8d3c..00d964829db5 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5235,6 +5235,13 @@ S:	Maintained
> >  F:	arch/arm/boot/dts/broadcom/bcm47189*
> >  F:	arch/arm/boot/dts/broadcom/bcm53573*
> >  
> > +BROADCOM BCM6362 WLAN BCMA HOST DRIVER
> > +M:	Alessio Ferri <alessio.ferri@mythread.it>
> > +L:	linux-wireless@vger.kernel.org
> > +S:	Maintained
> > +F:
> > Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > +F:	drivers/bcma/host_soc_bcm6362.c +
> >  BROADCOM BCM63XX/BCM33XX UDC DRIVER
> >  M:	Kevin Cernekee <cernekee@gmail.com>
> >  L:	linux-usb@vger.kernel.org
> > diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> > index b9558ff20830..ef0c461bdf90 100644
> > --- a/drivers/bcma/Kconfig
> > +++ b/drivers/bcma/Kconfig
> > @@ -38,6 +38,18 @@ config BCMA_HOST_SOC
> >  
> >  	  If unsure, say N
> >  
> > +config BCMA_HOST_SOC_BCM6362
> > +	bool "Support for the BCM6362 integrated WLAN backplane"
> > +	depends on BMIPS_GENERIC || COMPILE_TEST
> > +	depends on OF
> > +	help
> > +	  Host driver for the bcma backplane of the WLAN macro
> > +	  integrated in the Broadcom BCM6362 SoC. It powers the
> > macro on
> > +	  and lets bcma enumerate the backplane, so that the
> > 802.11 core
> > +	  can be driven by b43.
> > +
> > +	  If unsure, say N
> > +
> >  config BCMA_DRIVER_PCI
> >  	bool "BCMA Broadcom PCI core driver"
> >  	depends on PCI
> > diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
> > index f8c37de35da2..3ff93990ecbb 100644
> > --- a/drivers/bcma/Makefile
> > +++ b/drivers/bcma/Makefile
> > @@ -13,6 +13,7 @@ bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+=
> > driver_gmac_cmn.o bcma-$(CONFIG_BCMA_DRIVER_GPIO)		+=
> > driver_gpio.o bcma-$(CONFIG_BCMA_HOST_PCI)		+=
> > host_pci.o bcma-$(CONFIG_BCMA_HOST_SOC)		+= host_soc.o
> > +bcma-$(CONFIG_BCMA_HOST_SOC_BCM6362)	+= host_soc_bcm6362.o
> >  obj-$(CONFIG_BCMA)			+= bcma.o
> >  
> >  ccflags-$(CONFIG_BCMA_DEBUG)		:= -DDEBUG
> > diff --git a/drivers/bcma/bcma_private.h
> > b/drivers/bcma/bcma_private.h index 6eded32d1aac..931a0ca0aea3
> > 100644 --- a/drivers/bcma/bcma_private.h
> > +++ b/drivers/bcma/bcma_private.h
> > @@ -118,6 +118,21 @@ static inline void __exit
> > bcma_host_soc_unregister_driver(void) }
> >  #endif /* CONFIG_BCMA_HOST_SOC && CONFIG_OF */
> >  
> > +/* host_soc_bcm6362.c */
> > +#ifdef CONFIG_BCMA_HOST_SOC_BCM6362
> > +int __init bcma_host_soc_bcm6362_register_driver(void);
> > +void __exit bcma_host_soc_bcm6362_unregister_driver(void);
> > +#else
> > +static inline int __init
> > bcma_host_soc_bcm6362_register_driver(void) +{
> > +	return 0;
> > +}
> > +
> > +static inline void __exit
> > bcma_host_soc_bcm6362_unregister_driver(void) +{
> > +}
> > +#endif /* CONFIG_BCMA_HOST_SOC_BCM6362 */
> > +
> >  /* driver_pci.c */
> >  #ifdef CONFIG_BCMA_DRIVER_PCI
> >  u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
> > diff --git a/drivers/bcma/host_soc_bcm6362.c
> > b/drivers/bcma/host_soc_bcm6362.c new file mode 100644
> > index 000000000000..5a4fa6a63411
> > --- /dev/null
> > +++ b/drivers/bcma/host_soc_bcm6362.c
> > @@ -0,0 +1,419 @@  
> [...]
> > +struct bcma_host_soc_bcm6362 {  
> [...]
> > +	struct reset_control	*rst_wlan;
> > +	struct reset_control	*rst_wlan_ubus;
> > +};  
> [...]
> > +/*
> > + * Macro enable sequence from the Broadcom board support code:
> > with the
> > + * clock forced on and the macro in soft reset, enable the 802.11
> > core
> > + * clock with force gated clock set, then release the soft reset
> > and the
> > + * forces.
> > + */
> > +static int bcma_host_soc_bcm6362_power_on(struct
> > bcma_host_soc_bcm6362 *host) +{  
> [...]
> > +	reset_control_assert(host->rst_wlan_ubus);
> > +	reset_control_assert(host->rst_wlan);  
> 
> These are asserted in different order than in
> bcma_host_soc_bcm6362_power_off(). Is this on purpose?
> 
> If the order can be switched here, you can use the reset_control_bulk
> API.
> 

No particular purpose, will do in v4.

> > +	fsleep(1000);
> > +	reset_control_deassert(host->rst_wlan_ubus);
> > +	reset_control_deassert(host->rst_wlan);
> > +	fsleep(1000);  
> [...]
> > +}
> > +
> > +static void bcma_host_soc_bcm6362_power_off(struct
> > bcma_host_soc_bcm6362 *host) +{  
> [...]
> > +	reset_control_assert(host->rst_wlan);
> > +	reset_control_assert(host->rst_wlan_ubus);  
> 
> [...]
> > +static int bcma_host_soc_bcm6362_probe(struct platform_device
> > *pdev) +{  
> [...]
> > +	host->rst_wlan = devm_reset_control_get_exclusive(dev,
> > "wlan");
> > +	if (IS_ERR(host->rst_wlan))
> > +		return dev_err_probe(dev, PTR_ERR(host->rst_wlan),
> > +				     "failed to get wlan reset\n");
> > +
> > +	host->rst_wlan_ubus =
> > devm_reset_control_get_exclusive(dev, "wlan-ubus");
> > +	if (IS_ERR(host->rst_wlan_ubus))
> > +		return dev_err_probe(dev,
> > PTR_ERR(host->rst_wlan_ubus),
> > +				     "failed to get wlan-ubus
> > reset\n");  
> [...]
> > +}  
> 
> regards
> Philipp

Thank you
Alessio
