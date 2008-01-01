Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59964 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYAAAwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 19:52:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH 1/2] ssb: add 'ssb_pcihost_set_power_state' function
Date: Tue, 1 Jan 2008 01:50:47 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <200801010116.46190.mboton@gmail.com>
In-Reply-To: <200801010116.46190.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801010150.47787.mb@bu3sch.de> (sfid-20080101_005230_189848_622FCCDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 January 2008 01:16:46 Miguel Bot=C3=B3n wrote:
> This patch adds the 'ssb_pcihost_set_power_state' function.
>=20
> This function allows us to set the power state of a PCI device
> (for example b44 ethernet device).=20
>=20
> Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>

Acked-by: Michael Buesch <mb@bu3sch.de>

>=20
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index a21ab29..aa70fd0 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -349,6 +349,13 @@ static inline void ssb_pcihost_unregister(struct=
 pci_driver *driver)
>  {
>  	pci_unregister_driver(driver);
>  }
> +
> +static inline
> +void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_=
t state)
> +{
> +	if (sdev->bus->bustype =3D=3D SSB_BUSTYPE_PCI)
> +		pci_set_power_state(sdev->bus->host_pci, state);
> +}
>  #endif /* CONFIG_SSB_PCIHOST */
> =20
> =20
>=20



--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
