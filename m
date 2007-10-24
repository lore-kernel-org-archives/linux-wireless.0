Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54118
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXJXU4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 16:56:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH 1/2] ssb: Add "ssb_pci_set_power_state" function
Date: Wed, 24 Oct 2007 22:55:39 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <200710242131.21959.mboton.lkml@gmail.com>
In-Reply-To: <200710242131.21959.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200710242255.39772.mb@bu3sch.de> (sfid-20071024_215627_687100_E9CF96E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 October 2007 21:31:21 Miguel Bot=F3n wrote:
> Add "ssb_pci_set_power_state" function. This allows set the power sta=
te of a=20
> PCI device (for example b44 ethernet device).
>=20
> diff -ruN linux-2.6.23/include/linux/ssb/ssb.h=20
> linux-2.6.23.orig/include/linux/ssb/ssb.h
> --- linux-2.6.23.orig/include/linux/ssb/ssb.h	2007-10-24 19:02:33.000=
000000=20
> +0200
> +++ linux-2.6.23/include/linux/ssb/ssb.h	2007-10-24 19:49:37.00000000=
0 +0200
> @@ -402,6 +402,14 @@
>  {
>  	pci_unregister_driver(driver);
>  }
> +
> +/* Set PCI device power state */
> +static inline
> +void ssb_pci_set_power_state(struct ssb_device *dev, pci_power_t sta=
te)
> +{
> +	if(dev->bus->bustype =3D=3D SSB_BUSTYPE_PCI)
          ^
Coding style issue.

> +		pci_set_power_state(dev->bus->host_pci, state);
> +}
>  #endif /* CONFIG_SSB_PCIHOST */
> =20

The rest is acked.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
