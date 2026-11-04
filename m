Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=185.203.200.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793786144;
	b=dHHUtzXwaMHlbnvlcglRbnUKRk+x3DHuUYY7YjeP7TSBxa5sDKZsGRRzHovvriXLWyIZ
	 BmQAgMNciFllOErXankox/P6ofy/oIbfp1LrIzA2OICTA2nlnvhRWNZ2Xj7S+xq532v3T
	 NSo8Sv81dRulKHqpCAg3qY8TG2WEBGn6ylGMvNrRBz9WiFQB/iA2Jb6SRXuKctisXNgll
	 86BbjUp4rJoNRJ6xQMweWg02FBZ+xvNcSRXP9foWfnL/gDwznaoRZk0MEfihFTmMzUEfF
	 N98OOv7Jzek9LTbpRBJWYl7ti9wWNGvuxDIdVFe3vlhyyq1+6qXXlhq6C3YDIlt1qcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786144;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=eTFRhcEn12IL6H2Z1l21FtPdZX/lVEm4+csYwTijtb4=;
	b=NsjVsHEAh95siGhdd3zJY47+X7TlbPxDfWhXRzfqzQl+jejfRnuZ+QPH0nPRwubueu1j
	 u34xyxdAWtsE1C5YZnXdx27EyzNC9koOGO9A54V9/EhJWJuAAb8wwnrNZaUVIN3HGh4+t
	 d3FAzPxCPGYPEnvLz0491kirBAU/91ieG2FkeyST8zci6xeFwFl1MoB6/qen3lm6AehyL
	 TnhalHIl46fCtTWR2dBXanrN0v5mYM3j8biPmudQ6m0LA8d5GogQzAjhoSCFHKTDsk1rk
	 auNdnIhZwCzXVfluF8wCSh1GrpIbl/zKq7wi0qXWIazs3BqCTqMfGfCEgiXCnwzdBXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=pengutronix.de;
	spf=pass smtp.mailfrom=pengutronix.de;
	dkim=pass header.d=pengutronix.de header.i=@pengutronix.de header.a=rsa-sha256 header.s=20260414 header.b=b+UdZXft;
	arc=pass header.oldest-pass=0 smtp.remote-ip=185.203.200.13
Received: from mx1.white.stw.pengutronix.de (mx1.white.stw.pengutronix.de [185.203.200.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F66606D803;
	Wed,  4 Nov 2026 09:55:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73F66606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pengutronix.de header.i=@pengutronix.de header.a=rsa-sha256 header.s=20260414 header.b=b+UdZXft
Received: from [IPv6:2a0a:edc0:0:900:1d::4e] (lupine.office.stw.pengutronix.de [IPv6:2a0a:edc0:0:900:1d::4e])
	(Authenticated sender: pza@pengutronix.de)
	by mx1.white.stw.pengutronix.de (Postfix) with ESMTPSA id A7088201CE0;
	Wed, 04 Nov 2026 10:55:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pengutronix.de;
	s=20260414; t=1793786140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eTFRhcEn12IL6H2Z1l21FtPdZX/lVEm4+csYwTijtb4=;
	b=b+UdZXftB1uycmAFjc2aKkmFeC0BkmCzWZsxgBJNxVW2zYUWSrWSIm2wL1m7FsXVO4zAy4
	EHpsy5Q07pGo2tCv3prWyJ897xUwbpxCAwM+LB8gV/S1oux3BQvL3lGWHjn7D6SO7zforx
	0enJZf9Y3ADwfrkvxrpKeqBwwa3AJ9S8OyVu8HVYx8rJecxVL7pSw6EN0iNbmKMI112N6u
	aVW2ld+S/fr2y86nQgfeOB+I6nE2wXhLqzltm6yqahkiv1AGfSIlt2Ik+UrH5OjvUDH/oq
	5M6oE4GEsk79Juqrt+tZYlhFi1THkIHXVA5naNOf4rCDMJj3bcQ4Vjk7A8tGww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=pengutronix.de;
	s=20260414; t=1793786140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eTFRhcEn12IL6H2Z1l21FtPdZX/lVEm4+csYwTijtb4=;
	b=eeoEwgOEIWL+AvZU0dby5dnZBv6ZdjGFTJYSXv9jrQE9Iz/vArbXHRv2hfaajThs0II7i6
	IEwITRew6ym5i9IlVosQ+CKh4EExTtUjwGBHeJj7/EmEs7b11VB1U+48RlyP3WRJ55lCst
	2jHGVASEzWqqhRcnIJvgGsGqldzW3r8+0fT31vPfHKEyhI5fwFpfqS+54XjaAScXUQgqPS
	NJKegyXv1ncZ4PMX0sZogpDHG66ElmFQ/dLOTwACFUxWM5iRlNKC44pjL7lKUamqj1J/ZB
	HcgBOol4MdAsqk/UtKNmSROijUpdfO9tl740jbLrLUvcQkiC3oSa5VvI6gj8mQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pza@pengutronix.de smtp.mailfrom=p.zabel@pengutronix.de
ARC-Seal: i=1; s=20260414; d=pengutronix.de; t=1793786140; a=rsa-sha256;
	cv=none;
	b=KVBW48X0NZUsU++qUQbWXD4V09DjVaEyft/+qRnwqvGMbDBn4vdBVjGUZIaVQMgDNvG5KC
	Q9F2emqy240Ktq5SXVa57ddyw0owb9Ts4laqb28PKwBLxMpW25s65ItQTUgI0VWWjSTLtT
	pPfq0z4rHA/SoDlKUvWiHJeGFE8qARTmcgR8aVFqTpwCUNM2lbab2OPfgxZVxDzSQcVEmd
	Hrl6EmB6R4286gkzDvb1rni3RraTwYEy/csIoGeDO4Us3PuqoacvMJlJd6r9/gWJgk3mvE
	MWHzQPr/f3JjAIsUbiwrulGNcQuiNCM27vW21Edvi/n7rxeiLck4jdTr+kseyg==
Message-ID: <dd321689f566e687914908974bbe4c27ce2b587e.camel@pengutronix.de>
Subject: Re: [PATCH v3 4/5] bcma: add host driver for the BCM6362 integrated
 WLAN backplane
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Alessio Ferri <alessio.ferri@mythread.it>, Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,  =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=	
 <zajec5@gmail.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list	
 <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer	
 <tsbogend@alpha.franken.de>, Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Date: Wed, 04 Nov 2026 10:55:40 +0100
In-Reply-To: <20261104-bcm6362-wlan-v3-4-e46562b2ac12@mythread.it>
References: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
	 <20261104-bcm6362-wlan-v3-4-e46562b2ac12@mythread.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mi, 2026-11-04 at 00:31 +0100, Alessio Ferri wrote:
> The BCM6362 integrates a WLAN macro on a dedicated bcma backplane.
> CFE leaves the macro clock gated and in reset, the backplane is
> a big-endian peripheral, and none of the cores has a wrapper:
> gating and reset of ChipCommon and of the 802.11 core go through
> per-core control registers in a separate WLAN control block.
>=20
> Add a host driver for it that:
>=20
>   - maps the ChipCommon and WLAN control register blocks;
>   - enables the clock, cycles the WLAN and WLAN UBUS resets and runs the
>     macro enable sequence bcma touches the backplane;
>   - provides big-endian register and block I/O ops;
>   - emulates BCMA_IOCTL, BCMA_IOST, BCMA_RESET_CTL and BCMA_RESET_ST
>     on top of the per-core control registers. The PHY bits of
>     BCMA_IOST report what b43 needs to hear;
>   - sets the big_endian and wrapperless bus flags before scanning.
>=20
> As for the PCI and generic SoC hosts, the driver is linked into
> bcma.ko and registered from bcma_modinit().
>=20
> Add a MAINTAINERS entry for the driver and its binding.
>=20
> The 802.11 core (rev 0x16) is handled by b43 once a SPROM is
> available; on this SoC it is not stored on the chip and has to be
> provided. In openwrt i use 6362-sprom plus fixups.
>=20
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> ---
>  MAINTAINERS                     |   7 +
>  drivers/bcma/Kconfig            |  12 ++
>  drivers/bcma/Makefile           |   1 +
>  drivers/bcma/bcma_private.h     |  15 ++
>  drivers/bcma/host_soc_bcm6362.c | 419 ++++++++++++++++++++++++++++++++++=
++++++
>  drivers/bcma/main.c             |   6 +
>  6 files changed, 460 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f53047aa8d3c..00d964829db5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5235,6 +5235,13 @@ S:	Maintained
>  F:	arch/arm/boot/dts/broadcom/bcm47189*
>  F:	arch/arm/boot/dts/broadcom/bcm53573*
> =20
> +BROADCOM BCM6362 WLAN BCMA HOST DRIVER
> +M:	Alessio Ferri <alessio.ferri@mythread.it>
> +L:	linux-wireless@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> +F:	drivers/bcma/host_soc_bcm6362.c
> +
>  BROADCOM BCM63XX/BCM33XX UDC DRIVER
>  M:	Kevin Cernekee <cernekee@gmail.com>
>  L:	linux-usb@vger.kernel.org
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index b9558ff20830..ef0c461bdf90 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -38,6 +38,18 @@ config BCMA_HOST_SOC
> =20
>  	  If unsure, say N
> =20
> +config BCMA_HOST_SOC_BCM6362
> +	bool "Support for the BCM6362 integrated WLAN backplane"
> +	depends on BMIPS_GENERIC || COMPILE_TEST
> +	depends on OF
> +	help
> +	  Host driver for the bcma backplane of the WLAN macro
> +	  integrated in the Broadcom BCM6362 SoC. It powers the macro on
> +	  and lets bcma enumerate the backplane, so that the 802.11 core
> +	  can be driven by b43.
> +
> +	  If unsure, say N
> +
>  config BCMA_DRIVER_PCI
>  	bool "BCMA Broadcom PCI core driver"
>  	depends on PCI
> diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
> index f8c37de35da2..3ff93990ecbb 100644
> --- a/drivers/bcma/Makefile
> +++ b/drivers/bcma/Makefile
> @@ -13,6 +13,7 @@ bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+=3D driver_gmac_cm=
n.o
>  bcma-$(CONFIG_BCMA_DRIVER_GPIO)		+=3D driver_gpio.o
>  bcma-$(CONFIG_BCMA_HOST_PCI)		+=3D host_pci.o
>  bcma-$(CONFIG_BCMA_HOST_SOC)		+=3D host_soc.o
> +bcma-$(CONFIG_BCMA_HOST_SOC_BCM6362)	+=3D host_soc_bcm6362.o
>  obj-$(CONFIG_BCMA)			+=3D bcma.o
> =20
>  ccflags-$(CONFIG_BCMA_DEBUG)		:=3D -DDEBUG
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> index 6eded32d1aac..931a0ca0aea3 100644
> --- a/drivers/bcma/bcma_private.h
> +++ b/drivers/bcma/bcma_private.h
> @@ -118,6 +118,21 @@ static inline void __exit bcma_host_soc_unregister_d=
river(void)
>  }
>  #endif /* CONFIG_BCMA_HOST_SOC && CONFIG_OF */
> =20
> +/* host_soc_bcm6362.c */
> +#ifdef CONFIG_BCMA_HOST_SOC_BCM6362
> +int __init bcma_host_soc_bcm6362_register_driver(void);
> +void __exit bcma_host_soc_bcm6362_unregister_driver(void);
> +#else
> +static inline int __init bcma_host_soc_bcm6362_register_driver(void)
> +{
> +	return 0;
> +}
> +
> +static inline void __exit bcma_host_soc_bcm6362_unregister_driver(void)
> +{
> +}
> +#endif /* CONFIG_BCMA_HOST_SOC_BCM6362 */
> +
>  /* driver_pci.c */
>  #ifdef CONFIG_BCMA_DRIVER_PCI
>  u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
> diff --git a/drivers/bcma/host_soc_bcm6362.c b/drivers/bcma/host_soc_bcm6=
362.c
> new file mode 100644
> index 000000000000..5a4fa6a63411
> --- /dev/null
> +++ b/drivers/bcma/host_soc_bcm6362.c
> @@ -0,0 +1,419 @@
[...]
> +struct bcma_host_soc_bcm6362 {
[...]
> +	struct reset_control	*rst_wlan;
> +	struct reset_control	*rst_wlan_ubus;
> +};
[...]
> +/*
> + * Macro enable sequence from the Broadcom board support code: with the
> + * clock forced on and the macro in soft reset, enable the 802.11 core
> + * clock with force gated clock set, then release the soft reset and the
> + * forces.
> + */
> +static int bcma_host_soc_bcm6362_power_on(struct bcma_host_soc_bcm6362 *=
host)
> +{
[...]
> +	reset_control_assert(host->rst_wlan_ubus);
> +	reset_control_assert(host->rst_wlan);

These are asserted in different order than in
bcma_host_soc_bcm6362_power_off(). Is this on purpose?

If the order can be switched here, you can use the reset_control_bulk
API.

> +	fsleep(1000);
> +	reset_control_deassert(host->rst_wlan_ubus);
> +	reset_control_deassert(host->rst_wlan);
> +	fsleep(1000);
[...]
> +}
> +
> +static void bcma_host_soc_bcm6362_power_off(struct bcma_host_soc_bcm6362=
 *host)
> +{
[...]
> +	reset_control_assert(host->rst_wlan);
> +	reset_control_assert(host->rst_wlan_ubus);

[...]
> +static int bcma_host_soc_bcm6362_probe(struct platform_device *pdev)
> +{
[...]
> +	host->rst_wlan =3D devm_reset_control_get_exclusive(dev, "wlan");
> +	if (IS_ERR(host->rst_wlan))
> +		return dev_err_probe(dev, PTR_ERR(host->rst_wlan),
> +				     "failed to get wlan reset\n");
> +
> +	host->rst_wlan_ubus =3D devm_reset_control_get_exclusive(dev, "wlan-ubu=
s");
> +	if (IS_ERR(host->rst_wlan_ubus))
> +		return dev_err_probe(dev, PTR_ERR(host->rst_wlan_ubus),
> +				     "failed to get wlan-ubus reset\n");
[...]
> +}

regards
Philipp
